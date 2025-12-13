# AWS_Infrastructure_with_Terraform
CI/CD Practice.

# Push1
# terraform apply(※作成resource:VPC,ECS,ECR,Open Connectプロバイダー)
このプッシュでは、ECR、IAM、およびOIDCプロバイダー用の新しいリソースを追加しました。(2025/12/12 commit)

`terraform apply -auto-approve`を実行後、AWS Management ConsoleのIAMサービス管理画面で、OpenID Connectを使用したGitHubへの接続が確立されていることを確認してください。
(※Image 1: Identity provider section
     Image 2: Identity provider details)
<img width="1912" height="739" alt="OIDC1" src="https://github.com/user-attachments/assets/1d88542d-21ce-435e-a141-2fb573eb7ae9" />
<img width="1439" height="559" alt="OIDC2" src="https://github.com/user-attachments/assets/7d30ba4f-114a-4bbe-80f0-f9c6f8cbe28b" />

# Push2
(※試験構築につき、再作成頻度高を想定して記載。)
terraform applyでモジュール配下のVPC,ECS,IAM,ECR.Open Connectプロバイダー構築後を想定とし、
下記を実施する。

■ワークフロー実行の前段に必要な設定
➀前提を満たす
OIDC で引き受ける IAM ロール ARN（IAM_ARN_TO_PUSH_IMAGE）と、その信頼ポリシーを設定する。

<img width="1986" height="922" alt="image" src="https://github.com/user-attachments/assets/915dde9a-01d5-445c-a933-677b8f4f5bc8" />

上記ページにおいて、AWSマネージャーコンソールからIAM→ロールより開かれるページの「信頼されたエンティティ」の項目において「arn:aws:iam::<アカウントID>:oidc-provider/token.actions.githubusercontent.com」であるものを記入する。
(設定に必要なのは「GitHub OIDC トークン(IAM→ID プロバイダーの対象リソース)を信頼し、ECR への push 権限を持つ IAMロール」)

<img width="1981" height="826" alt="image" src="https://github.com/user-attachments/assets/37c40ed7-0f76-43be-8927-c26515cadb99" />

記入後、下記画面で設定確定「Add secret」する。
<img width="1963" height="894" alt="image" src="https://github.com/user-attachments/assets/86693a2a-eb7f-498a-8660-57ca34fe34df" />

Add実行後、Repository secretに要素が追加される。
<img width="1967" height="913" alt="image" src="https://github.com/user-attachments/assets/1bdd2497-57e5-4e57-94b0-f509c17aa6d6" />

なお、上記secret記載のロールは下記画像のように
sub が repo:<org>/<repo>:* など対象リポジトリを許可していること、aud が sts.amazonaws.com であることを確認する。
<img width="1969" height="788" alt="image" src="https://github.com/user-attachments/assets/811d991a-cdac-4d53-a9df-b76ab859e3bd" />

対象のECRはapply後に作成されるため、そおのECR配下にワークフロー内に記載の「context: ./image」の、./image配下にDockerビルドコンテキストが存在することを確認する。
無い場合はterraform initを実行したディレクトリ直下にDockerfileやアプリのリソースを入れる./imageディレクトリを作成し(今回のリポジトリにて存在するもの)、その配下にDockerfileを作成する。
(ビルドファイルはGo言語のものを使用していますが、実際のアプリケーションファイルはAPチームから連携される想定なので、あくまで最小構成かつ簡素な内容にしています。)
※go.sumについての役割は依存のチェックサム。今回は外部依存なしなので空で問題ありませんが、Dockerfile が COPY するため存在させます。

ローカル環境内でイメージビルドが成功するか確認する。（任意）
（※以下、ローカル環境のターミナル画面）

`**$ docker build -t test-image ./image/**
[+] Building 26.3s (15/15) FINISHED                                                                                                        docker:default
 => [internal] load build definition from Dockerfile                                                                                                 0.1s
 => => transferring dockerfile: 418B                                                                                                                 0.0s 
 => [internal] load metadata for docker.io/library/golang:1.22-alpine                                                                                3.1s 
 => [internal] load metadata for docker.io/library/alpine:3.19                                                                                       1.8s 
 => [internal] load .dockerignore                                                                                                                    0.1s
 => => transferring context: 2B                                                                                                                      0.0s 
 => [builder 1/6] FROM docker.io/library/golang:1.22-alpine@sha256:1699c10032ca2582ec89a24a1312d986a3f094aed3d5c1147b19880afe40e052                  9.0s
 => => resolve docker.io/library/golang:1.22-alpine@sha256:1699c10032ca2582ec89a24a1312d986a3f094aed3d5c1147b19880afe40e052                          0.1s 
 => => sha256:5f837c998576dcb54bc285997f33fcc2166dff6aa48fe3a374da92474efd5fe8 126B / 126B                                                           0.4s 
 => => sha256:afa154b433c7f72db064d19e1bcfa84ee196ad29120328f6bdb2c5fbd7b8eeac 69.36MB / 69.36MB                                                     4.0s 
 => => sha256:4d75fd4b73869ed224045c010cdec78756eefb6752a5a8e4804294009eac11e9 294.90kB / 294.90kB                                                   0.8s 
 => => sha256:1f3e46996e2966e4faa5846e56e76e3748b7315e2ded61476c24403d592134f0 3.64MB / 3.64MB                                                       0.9s
 => => extracting sha256:1f3e46996e2966e4faa5846e56e76e3748b7315e2ded61476c24403d592134f0                                                            0.4s
 => => extracting sha256:4d75fd4b73869ed224045c010cdec78756eefb6752a5a8e4804294009eac11e9                                                            0.4s
 => => extracting sha256:afa154b433c7f72db064d19e1bcfa84ee196ad29120328f6bdb2c5fbd7b8eeac                                                            4.3s 
 => => extracting sha256:5f837c998576dcb54bc285997f33fcc2166dff6aa48fe3a374da92474efd5fe8                                                            0.1s 
 => => extracting sha256:4f4fb700ef54461cfa02571ae0db9a0dc1e0cdb5577484a6d75e68dc38e8acc1                                                            0.1s
 => [stage-1 1/3] FROM docker.io/library/alpine:3.19@sha256:6baf43584bcb78f2e5847d1de515f23499913ac9f12bdf834811a3145eb11ca1                         1.5s
 => => resolve docker.io/library/alpine:3.19@sha256:6baf43584bcb78f2e5847d1de515f23499913ac9f12bdf834811a3145eb11ca1                                 0.1s
 => => sha256:17a39c0ba978cc27001e9c56a480f98106e1ab74bd56eb302f9fd4cf758ea43f 3.42MB / 3.42MB                                                       0.8s
 => => extracting sha256:17a39c0ba978cc27001e9c56a480f98106e1ab74bd56eb302f9fd4cf758ea43f                                                            0.5s
 => [internal] load build context                                                                                                                    0.1s
 => => transferring context: 496B                                                                                                                    0.0s
 => [stage-1 2/3] WORKDIR /app                                                                                                                       0.3s
 => [builder 2/6] WORKDIR /app                                                                                                                       0.8s
 => [builder 3/6] COPY go.mod go.sum ./                                                                                                              0.2s
 => [builder 4/6] RUN go mod download                                                                                                                1.6s
 => [builder 5/6] COPY . .                                                                                                                           0.2s
 => [builder 6/6] RUN go build -o app                                                                                                                9.4s
 => [stage-1 3/3] COPY --from=builder /app/app .                                                                                                     0.1s
 => exporting to image                                                                                                                               1.1s
 => => exporting layers                                                                                                                              0.6s 
 => => exporting manifest sha256:80e067525cd9860d7d9f142a8cbee2323c4938be10fc849a641c106072f3625e                                                    0.0s
 => => exporting config sha256:950c35ec9dfe05eacab054d7e6cdc49a2618cec31f3fd22b4321308fd742e1f8                                                      0.0s 
 => => exporting attestation manifest sha256:37d2abb926b43bf154556a6c8723e4b135434528159083ef71cfa8f58b8fce7c                                        0.1s 
 => => exporting manifest list sha256:ebe6e9d35c6809d88ee83779c675240656054f50b06fa011c8adb1c6a25736fa                                               0.0s
 => => naming to docker.io/library/test-image:latest                                                                                                 0.0s 
 => => unpacking to docker.io/library/test-image:latest                                                                                              0.1s`

上記、ローカル環境にてビルド成功を確認し、
aws configure listコマンドでawsコマンド実行元環境におけるプロファイルを確認する。
問題無ければ、「Amazon ECR >プライベートレジストリ >リポジトリ>イメージ」から各ECRイメージ毎に参照できる「プッシュコマンドを表示」からコピペ可能なコマンド群を全て順に実行する。


コマンド実行後に。対象のイメージ画面にてローカル環境よりイメージが配置されていることを確認する。
<img width="1995" height="776" alt="image" src="https://github.com/user-attachments/assets/c6cc6f37-b39d-4931-bd10-9efa91c955d8" />


上記が確認できれば➀は完了。

移行、ワークフローファイルをリポジトリに反映する。
やることはローカル環境からpush⇒PR作成⇒mainにマージして最新化石なので手順省略。

