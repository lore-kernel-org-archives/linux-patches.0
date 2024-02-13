Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469C05EE6C
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 15:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707838672; cv=none; b=AR74kKUqJ5axm4Y8EVNqfU7YhVgK4hNtnW4jZaLUelflk5+r8C60oRVk6xh5wJc8VfJ+C/d0GS2vtwxVmh35WKRCRnmrRkTxBMzcoG8rWy2RE42SxtxgCm5/nCA1MfUH6cc0S4yY7ahIW6jbkUO0g81vbuH549LvcMCqyL3Jz8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707838672; c=relaxed/simple;
	bh=AJ2ShXMY9mclzo7RH3al2C9ykS8lXSKpfydDfw4OJLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q2WrWwt+HaVmnuJLuToryOA/5arNtD1rQYXignnVjEgkMd5i/JuX1DuxiYvAeNJom7cbVBPP6z4M7qid5sDNdqlWPZBF1lT+kTGWHvl1EZw9zXM7/v4RlbpHqssPeG45/zfEK07cbTffjZSEYKhlNsTngVC/1ORzAXZTc0cwfVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bN3EYP8B; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bN3EYP8B"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-40f0218476aso56285e9.1
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 07:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707838668; x=1708443468; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zwr6PKiZpNhLTE2guxAZqjlW96JM5kQoMb1X0WZ59CU=;
        b=bN3EYP8B3ps9maKZe6XYPoen3xQ3GrgsdsFKjIfaR1rLDRTy19wXK3uqXLp6nNq48y
         3l2GE3DYFixQrDRrlAxCzjYoWyABzKKZepxHaHQZldVZh3/Tg2BUDj/XeBHswZsuEpY6
         +smCJKwhtkKqPKfbb/kPcSfU+b6guAlgapflVehCUx1vOFgKcZTaahJCU1N15zh4vPgV
         dvNMj7xvwQF+of6FrQvbuxhhhXH66gyAniG+NvegNTEVECYYgyhwt6q9cdnk0fcdCU7v
         WAf2tD0BNsfpoKB3+sEo3Lcg9fE/ghGthRkVfhVmp2HB7cllht4xTJgqxBeZo5sj7WjB
         Focw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707838668; x=1708443468;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zwr6PKiZpNhLTE2guxAZqjlW96JM5kQoMb1X0WZ59CU=;
        b=bNJtjQ0EBeyh9B7cKvlASkgL8gPdH1lWxhhDANuyCZvhH8lWOjQiBdZwW/jq3YPfG6
         z+yzP0HAa/pFBn0TQBZVmzMGOAfFaZxAxPxDPFU7AI6MNf14lsoYT7rZdT3AdY2FQ30P
         Edmi8c3ZElyaM2nGKtm6Xai0YAH8TbdLMi+XaaRKN2Hxctu7fXs6FmDmdjTfKJTMZv1P
         soDUlAT6K2x+qn0SCa0PAMVgLmaCbN+QNGNs9c3EaD0hGHbk1snHr3Yx58iBqmthT8n6
         OhQ9RFZO2gUFHTSW2GgljRKxx/h4JQieZucPioCAsbHo8vIJpfbZiOEAu6MKjK0imacJ
         36zQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxOAjoh7r4MtubNGr+pFTuRgkdw5LGjktoLcKTfpf0MT7SGbr8MnmymBtyVXFcK8mTYVxe+F0uKOjlreHg/wOHOpA/kQqXyQ==
X-Gm-Message-State: AOJu0Yy1YoP5DttE0G2mYFRU3mKEthwJG1PKhqfg1DCa0SefOkx8n7eA
	shfjuttVgddNuQLo//D+uGxjnoFm21AvJLrz7oLjTa7n404bXsT9AR+9IzIU3Q==
X-Google-Smtp-Source: AGHT+IHtsU5AWhMPPiPV60/mKu/c1RVNIy8lz4Y19Wq//wfQ65ZRTok6AKBtoFN6I/zlMgz+M2mYcA==
X-Received: by 2002:a05:600c:3d05:b0:411:c03e:217c with SMTP id bh5-20020a05600c3d0500b00411c03e217cmr110189wmb.1.1707838668442;
        Tue, 13 Feb 2024 07:37:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUIEKZahnjEoFxPo2yqL67J4jEmvZOYyvfU1gzL2Qd6fxYKmkx18l93i5SVRdDWQtc77GT2wSjtCQy6+yaXxocP7dukAEaRZY+C0D6rODQ3rCYDK8RzPdpU4k6ehXzd5Xe6ETfiej+pZOeRIA28aWQ7dRaGPAWc7QorbQ2CbbsxPv4dTpjIvLoGyGMqz3EEOaUxoo9fRAoQEwmfBBDbBwgf7lSgpczfVE+vB92+9EmskxbgA5HroFh0v7Zf+QLdRVgpkxB3ilfOWmsA8CgBVLb4sWxAdZmJTLqKGl985Wrhh3xWkSTXX08Z0zQC9z/vyAgaaTCt/oRvgnb/CTj8ktqrFusTceqzLEfc1g+rxNBDnMYyrt2edxWIr9UKtzSVtitEoLAfWyf9fDKOqIP9twNiB8nowYIqS31uGUhaVF0JymIrrbEZEyxAUKQPiPBJxhJL9ZI6PSHBDwTzrgBXaYV66kbDdOuXHW77BM8xYiifwTiCS7YeRQ==
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id n40-20020a05600c3ba800b00411c724fa10sm1694378wms.2.2024.02.13.07.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 07:37:47 -0800 (PST)
Date: Tue, 13 Feb 2024 15:37:43 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 03/17] iommu/arm-smmu-v3: Move
 arm_smmu_rmr_install_bypass_ste()
Message-ID: <ZcuMx0w6MDWpkLne@google.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <3-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>

Hi Jason,

On Tue, Feb 06, 2024 at 11:12:40AM -0400, Jason Gunthorpe wrote:
> Logically arm_smmu_init_strtab() is the function that allocates and
> populates the stream table with the initial value of the STEs. After this
> function returns the stream table should be fully ready.
> 
> arm_smmu_rmr_install_bypass_ste() adjusts the initial stream table to force
> any SIDs that the FW says have IOMMU_RESV_DIRECT to use bypass. This
> ensures there is no disruption to the identity mapping during boot.
> 
> Put arm_smmu_rmr_install_bypass_ste() into arm_smmu_init_strtab(), it
> already executes immediately after arm_smmu_init_strtab().
> 
> No functional change intended.

I think arm_smmu_init_strtab is quite low level to abstract FW configuration in it.
For example in KVM[1] we'd re-use a big part of this driver and rely on similar
low-level functions. But no strong opinion.

[1] https://lore.kernel.org/kvmarm/20230201125328.2186498-1-jean-philippe@linaro.org/


Thanks,
Mostafa

> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Moritz Fischer <moritzf@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 6123e5ad95822c..2ab36dcf7c61f5 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -101,6 +101,8 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
>  	{ 0, NULL},
>  };
>  
> +static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu);
> +
>  static void parse_driver_options(struct arm_smmu_device *smmu)
>  {
>  	int i = 0;
> @@ -3256,6 +3258,7 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
>  	cfg->strtab_base_cfg = reg;
>  
>  	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents);
> +
>  	return 0;
>  }
>  
> @@ -3279,6 +3282,8 @@ static int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
>  
>  	ida_init(&smmu->vmid_map);
>  
> +	/* Check for RMRs and install bypass STEs if any */
> +	arm_smmu_rmr_install_bypass_ste(smmu);
>  	return 0;
>  }
>  
> @@ -4073,9 +4078,6 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
>  	/* Record our private device structure */
>  	platform_set_drvdata(pdev, smmu);
>  
> -	/* Check for RMRs and install bypass STEs if any */
> -	arm_smmu_rmr_install_bypass_ste(smmu);
> -
>  	/* Reset the device */
>  	ret = arm_smmu_device_reset(smmu, bypass);
>  	if (ret)
> -- 
> 2.43.0
> 
