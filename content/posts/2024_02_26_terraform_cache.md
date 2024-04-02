---
title: "Speed Up and Save Internet Bandwidth Your Terraform/OpenTofu/Terragrunt with Caching Provider Binary"
description: "Speed Up and Save Internet Bandwidth Your Terraform/OpenTofu/Terragrunt with Caching Provider Binary"
date: 2024-02-26T18:53:05+07:00
categories:
  - "Cheatsheet"
tags:
  - "terraform"
  - "opentofu"
  - "terragrunt"
draft: false

featuredImage: "/2024_02_26_terraform_cache/2.png"
featuredImagePreview: "/2024_02_26_terraform_cache/2.png"
---

# Speed Up and Save Your Terraform/OpenTofu/Terragrunt with Caching Provider Binary

As many already knows, `terraform` will download the provider binary from the internet when we run `terraform init` / `tofu init` / `terragrunt init` command each time we invoke it in newly directory or project. This is a good thing, but it can be a problem when we have a slow internet connection or when we have a lot of providers to download or you have terragrunt monorepo that will be run in sequence, simply complex terraform or IaC dependency. This is where the caching provider binary comes in handy and will help you. Your project `.terraform` directory will have symbolic link to the provider binary in the cache directory.

You guys simple create `.terraformrc` file in your home directory, and following line of code and create the cache dir, by:

```bash
cat > ~/.terraformrc <<OF
plugin_cache_dir   = "$HOME/.terraform.d/plugin-cache"
OF

mkdir -p ~/.terraform.d/plugin-cache
```

And do your usual `terraform` or `terragrunt` command, and you will see the provider binary will be cached in the `~/.terraform.d/plugin-cache` directory, versioned.

{{< image src="/2024_02_26_terraform_cache/1.png" caption="`terraform`/`opentofu`/`terragrunt` Provider Cache" >}}

{{< image src="/2024_02_26_terraform_cache/3.png" caption="Provider Binary Symbolic link" >}}
