# Deploy Next.js app on AWS Cloudfront

This example shows you how to deploy your Next.js app on AWS Cloudfront.

## How to use

1. Fork this repository
2. Create a Lifecycle Job
3. Select your forked repository with the appropriate branch (e.g. `main`)
4. Set the "Root application path" to the example you want to use (e.g. `examples/deploy-nextjs-app-on-cloudfront`)
5. Set the "Dockerfile path" to the Dockerfile in the example you want to use (e.g. `Dockerfile`)
6. Select "Start" event and add the following CMD Arguments: `["upload.sh"]` - which indicates to the Lifecycle Job to run the `upload.sh` script when the Lifecycle Job starts.
7. Create your Lifecycle Job but **do not deploy it yet**.
8. Go to your Lifecycle Job variables and create:
   1. `AWS_ACCESS_KEY_ID` environment variable alias to provide to `upload.sh` your AWS access key ID.
   2. `AWS_SECRET_ACCESS_KEY` environment variable alias to provide to `upload.sh` your AWS secret access key.
   3. `AWS_DEFAULT_REGION` environment variable alias to provide to `upload.sh` your AWS default region.
   4. `AWS_BUCKET_NAME` environment variable alias to provide to `upload.sh` your AWS S3 bucket name.
   5. `AWS_CLOUDFRONT_DISTRIBUTION_ID` environment variable alias to provide to `upload.sh` your AWS Cloudfront distribution ID.
9. Deploy your Lifecycle Job.

Your NextJS app is now deployed on AWS with Cloudfront.
