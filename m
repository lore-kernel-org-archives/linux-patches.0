Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A55026C398
	for <patches@lists.linux.dev>; Tue,  1 Jul 2025 12:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751374279; cv=none; b=Xpi0LvLEd15YFDooMj7rIgGrt/QlEWrdHa4linUiEw57y7f8ba11+pSLQJw/PHLAXfXFzU2CUxrOBw5qMWg81ndmFqsSh6uM+7MKZPrH8ziHZwI+Uunf2F74C5uXrD72URHaCBUnFp7wQBSdI2i/RWMWEHW/i1e0/FSsAzkIFTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751374279; c=relaxed/simple;
	bh=UTZrlI9y+37r9TWwpMElUdLKen5fGKONWtUw6j0dYNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NWO8V85yDsi46Zce/1b0zlZ1l1nLZcyGmSm9syZtJPUAQ6lxp3es7l4dowTi8Sipt9XF+Jw935v/foqldL1H480w0IO/ZnnzwaeH7Wc7fYuASiKK1GNUpMorcDBBSYFxyxBnN/htAEoA1qqXQnwM0JMTJoZX7l3xn/ghg7ZGzG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zHfCvsGc; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zHfCvsGc"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2357c61cda7so118965ad.1
        for <patches@lists.linux.dev>; Tue, 01 Jul 2025 05:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751374276; x=1751979076; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GPts6df6Q4890tqHCArh7YEtzYo+b0PlaNL9e95JEQ4=;
        b=zHfCvsGcjxNb0mDxtkHEIxfZDcSn5XICM451CgeSl5QxDgOAPSoEra0g62ng30PyKE
         +uuZ1TGHZ1uKjo0M7YvDgG43v/k657gwVFLJoevI3MCR8C4hUegBk+/RzRDyiWfEdTEw
         At/SXQ/pppF/a/eLtM+PWXjHg92rNRQc0wQcH+2jVtfwnjqpD/xgfqhPVJhCOMBhQXpu
         pZxKOVvKVSj9T+6eK5mBPkP2Z6j8uK0yR6v38PLVoE5TMoBfUAdQsJjmJ0KUa6Ta1o/E
         mH3DLPVQZq9UsLMnHjGHoH4BsdMVkRgnk6jVmczkguql/6SBOOQszNtJ37MSSy7YBqTS
         Zcsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751374276; x=1751979076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GPts6df6Q4890tqHCArh7YEtzYo+b0PlaNL9e95JEQ4=;
        b=nw+GTR9bjoH0GZby/5+GSZ9RJ1YaSvwTrok2Uam5xJFhYqgckFysxD5rgVt9NjZKxG
         34ftlDCifOP2dSvNCIU13voa5nDbBlkBz2Yvlpa1vwWXXT2/optXiMQ7lKOMjqIavdHL
         ep8S4AMvpDg6S2aMv1Lp5qMuBJqqCPuS+lPi8lvmHAo5qiu/8Mg396ozvZLBKLHpJiod
         x9gCULr+bgyNb0fPxD4jqR5cDNfquXMdJYTFTcR+NUBFtncabYaEAyNlKEvSe3eawKZH
         RrszEm4Crl20cMWCSmnECXPX5soRFtrE7pOsCVlXSzNTZGJGLxQSOqeRAg3Apn1dMfNm
         TxRA==
X-Forwarded-Encrypted: i=1; AJvYcCX2BdgmwWT4IOP2b0WARqG6ZUVNWZFqycn7zdDHDVKzar6CNsVHs5TYXqFz+vgaQKvkiOVaFEwb@lists.linux.dev
X-Gm-Message-State: AOJu0Yxsr0oWOEept7TqRbjHEFwF+5qkt7WExGJ8pHXG5XVM5motX2KO
	CNTrM7la0BwvG73f+MXTUpO+Dyq687M5r7yzXR9xYW8v7sD7uZO7Emnjg0vFQwBMvw==
X-Gm-Gg: ASbGncte29hZD+dh7YXHM3qNyAC6QLMXl29J6NSZGVuNSDTXCelxpqv6qzgNGfasxsy
	UyAoypR9sX4uHGcfgpegJTLLgsXISOQAKdrvKW9vn6NoeXsHa3AGi/Kapy757nOk5reNqVPRjqu
	ZIyv8JnH4fa1jdD1Fa0ks95SqyduBkk3Ozg+dhrqm0TUXDmiws0xKFqYrvwvZIznS4tkBWNg24w
	/Jf8Z8tACzgUwR03sIc7nuiz6nCi/+jsxEh7w80l+sJVf9h2XlQNfgibo1v2echghb025soZUxO
	faVPI6CChUDkkbv+OcD3lqovUbz1nqmYwpTRiO1NtQcv5uK9m/Vp3bcQHaSYPK6GKzGRZm0eMx2
	DJ6PS4jnq14jGCOwRqp2h
X-Google-Smtp-Source: AGHT+IGScnewrdwJXz5o2+pGS36a0Kxzmd5AqmLzt37Kv43BKh9NBBAVMo2i4U9SfF+orF6VioLZJQ==
X-Received: by 2002:a17:903:b07:b0:234:bfa1:da3e with SMTP id d9443c01a7336-23c5ff04d7cmr1891395ad.5.1751374275468;
        Tue, 01 Jul 2025 05:51:15 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af57ee760sm11194996b3a.155.2025.07.01.05.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 05:51:14 -0700 (PDT)
Date: Tue, 1 Jul 2025 12:51:05 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	bagasdotme@gmail.com, robin.murphy@arm.com, joro@8bytes.org,
	thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
	shuah@kernel.org, jsnitsel@redhat.com, nathan@kernel.org,
	peterz@infradead.org, yi.l.liu@intel.com, mshavit@google.com,
	zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com,
	dwmw2@infradead.org, baolu.lu@linux.intel.com
Subject: Re: [PATCH v7 03/28] iommu: Use enum iommu_hw_info_type for type in
 hw_info op
Message-ID: <aGPZuSKBSADLbwas@google.com>
References: <cover.1750966133.git.nicolinc@nvidia.com>
 <f588bf6a47cbaf350a03e5a1680074b852fb5502.1750966133.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f588bf6a47cbaf350a03e5a1680074b852fb5502.1750966133.git.nicolinc@nvidia.com>

On Thu, Jun 26, 2025 at 12:34:34PM -0700, Nicolin Chen wrote:
> Replace u32 to make it clear. No functional changes.
> 
> Also simplify the kdoc since the type itself is clear enough.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  include/linux/iommu.h                               | 6 +++---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c | 3 ++-
>  drivers/iommu/intel/iommu.c                         | 3 ++-
>  drivers/iommu/iommufd/selftest.c                    | 3 ++-
>  4 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 04548b18df28..b87c2841e6bc 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -563,8 +563,7 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
>   * @capable: check capability
>   * @hw_info: report iommu hardware information. The data buffer returned by this
>   *           op is allocated in the iommu driver and freed by the caller after
> - *           use. The information type is one of enum iommu_hw_info_type defined
> - *           in include/uapi/linux/iommufd.h.
> + *           use.
>   * @domain_alloc: Do not use in new drivers
>   * @domain_alloc_identity: allocate an IDENTITY domain. Drivers should prefer to
>   *                         use identity_domain instead. This should only be used
> @@ -623,7 +622,8 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
>   */
>  struct iommu_ops {
>  	bool (*capable)(struct device *dev, enum iommu_cap);
> -	void *(*hw_info)(struct device *dev, u32 *length, u32 *type);
> +	void *(*hw_info)(struct device *dev, u32 *length,
> +			 enum iommu_hw_info_type *type);
>  
>  	/* Domain allocation and freeing by the iommu driver */
>  #if IS_ENABLED(CONFIG_FSL_PAMU)
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> index 9f59c95a254c..69bbe39e28de 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> @@ -7,7 +7,8 @@
>  
>  #include "arm-smmu-v3.h"
>  
> -void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type)
> +void *arm_smmu_hw_info(struct device *dev, u32 *length,
> +		       enum iommu_hw_info_type *type)
>  {
>  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
>  	struct iommu_hw_info_arm_smmuv3 *info;
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 7aa3932251b2..850f1a6f548c 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4091,7 +4091,8 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
>  	return ret;
>  }
>  
> -static void *intel_iommu_hw_info(struct device *dev, u32 *length, u32 *type)
> +static void *intel_iommu_hw_info(struct device *dev, u32 *length,
> +				 enum iommu_hw_info_type *type)
>  {
>  	struct device_domain_info *info = dev_iommu_priv_get(dev);
>  	struct intel_iommu *iommu = info->iommu;
> diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
> index 74ca955a766e..7a9abe3f47d5 100644
> --- a/drivers/iommu/iommufd/selftest.c
> +++ b/drivers/iommu/iommufd/selftest.c
> @@ -287,7 +287,8 @@ static struct iommu_domain mock_blocking_domain = {
>  	.ops = &mock_blocking_ops,
>  };
>  
> -static void *mock_domain_hw_info(struct device *dev, u32 *length, u32 *type)
> +static void *mock_domain_hw_info(struct device *dev, u32 *length,
> +				 enum iommu_hw_info_type *type)
>  {
>  	struct iommu_test_hw_info *info;
>  

Reviewed-by: Pranjal Shrivastava <praan@google.com>

> -- 
> 2.43.0
> 
