Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5762741A0
	for <patches@lists.linux.dev>; Tue,  1 Jul 2025 12:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751374729; cv=none; b=Yjysv+4EDF2yvoHdC+5pq+FVUDbfj/K2NiNc1lnqCYYm7MgjgTTctZ/vGYBSwGlOznFs8gRGOqW9JV0AL/7KDDXpbTT9bJB+ThM6J+abBrax2Hv7h5RCqPjJa2MZN85ch8Y2nmlOWk3oOv9QJ/SfIddFxtqibdA6iLQzv8XWEuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751374729; c=relaxed/simple;
	bh=QVjsIYXh5KgkJGxwJvk1fAvS8lppUJ46HEMqAQrLa48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G2yW6SquAG9mKTYHhw6oo2oPNFgHJ/s6MvdYvR2Q7naUc6JAeVIjcDujxKnqDBY8ElOIo/aihM93URjPOtwikcC7mOyO+T7yP9r0el5uD6nVKnW3bxC7Y8ilN6mjf1B1q/p0As8e5ajwR1V0PT5fQSRO8JY51ut2l/Mf6BeGpII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2F2JANDG; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2F2JANDG"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-235e389599fso212075ad.0
        for <patches@lists.linux.dev>; Tue, 01 Jul 2025 05:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751374727; x=1751979527; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uzw4uNd5li2mXa+WfFMUaVuwZFHwRlbcR3UhOImbWD4=;
        b=2F2JANDGbunYe2PZ5PxjbC/CNE698PYs0OnwSL/HqJ0pIFtUnFys8B61fi0qP7i0Ei
         /+rK/cUf6trRfJZBv8bbH939r6kyUlA+nPXZzvDacvNMdWdDg9KwYVFMIbF2OviP2j6s
         K4jQ3TwEBvzX8Gog+cHt4tNBjPXeLATydPSfUreRJ22mt/TfBskeRcU2x/306KhUzP7q
         leqQz9zfKnksBwD+p8t5VK7KN/E3Bv45I30l8R1s3I8Z4Gwi9VONlu98D7XBiZjGzSeJ
         jWI8NXi+C6TKXA86YlRT1+4zT6ZXynHEAPD52qoH6UXjgvZzQGXfhBaJVeOeiQuLAwF2
         qVag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751374727; x=1751979527;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uzw4uNd5li2mXa+WfFMUaVuwZFHwRlbcR3UhOImbWD4=;
        b=NqsOqGKk+r6VVMP79UB0SjzD1nYgbzgPcC4s0gpwQH2Aw2n7Dol0hgyOnEq1QMWMyU
         RLQthvz+5bd63CJSvRxtqypP3HIsRD400Oa3tVf3dSlOC4e/EWHQ1QD7egWu2ZvR+IsK
         gG5KbDLBpV55qW/o01gNBM69IRJEGDPsvEp39flw6PGPYo2MhRsAW/DGcHfrgHfaf3I+
         UNB8tYkmCEpiWuJp4jRa7hwyfgIysg9ogvLuMXINaqiOnLzBJg3V8wL58d4kpcZY3dIv
         91Q5Js+4szV1zWFfQcGVirRrzBfgCw6VkPBJE4C/YZOt4Q2U9TTr1nalBLs5boxqJ9jY
         AstQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpXyHuD76BM93W2NkijGwg118br9S0dBrzu1Qr5TNJYLbzHHKpqFbWWKQ4BwIloz8Owo2w+zRO@lists.linux.dev
X-Gm-Message-State: AOJu0YwVKoFizYhHa89Dbbp6xwsREtKKusJSFnrfkrZDBqImwoJ/z8X5
	b6KiqwNuv8+AOkIr3URJR8RpCYjM5/Su26x4+aJP/TC5Vr8NaEqDxJOfKb7zmDB10A==
X-Gm-Gg: ASbGncuzyJ6X/DNZEx8cQ/knVQd5bAjSppJzI6ZynmAcYAik02gRL72LT2KydBlrZ5x
	Uba0byk3VJ0OLA0kgebst8JHJxl9Bux0vo5wQVqn8atkU+TYC10V2dKStTQJKPTSNBkD7fMNskh
	/7AjToTOmZuwTGF+kEUmI8wGTxi9YFDOqlXWRF3O/qXlfMJjKLQ/3liqj33m0GR//kfkAo1BSdx
	JZgjnGxSbnWxy7oJXfi5Z9CssEnKcoguAblvra4yL7uCXS0E0Y6m5jGKg39PGWv75erp+oDPalc
	18ZkCn6Nf8RkfGho2dfbg8KEq0RDhF9WL93/IQUz10ASf5ldId3Vc4hb98J6mxCmBw4qy+Rkj5/
	wn9gO2vbg9px9EYQpTyZ+09DR6ssGIZk=
X-Google-Smtp-Source: AGHT+IGmj2MAzmEBH+PWX1NsLuSUKrLgxpjLMp3KA3CIsShNt/Sqit3dWlHjLZzB1pekp9REtBE7WA==
X-Received: by 2002:a17:902:f70b:b0:234:bca7:2934 with SMTP id d9443c01a7336-23c5fef098cmr2059855ad.6.1751374726581;
        Tue, 01 Jul 2025 05:58:46 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb39bcbcsm104502905ad.134.2025.07.01.05.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 05:58:45 -0700 (PDT)
Date: Tue, 1 Jul 2025 12:58:36 +0000
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
Subject: Re: [PATCH v7 20/28] iommufd: Allow an input data_type via
 iommu_hw_info
Message-ID: <aGPbfM2iZP7ww1fC@google.com>
References: <cover.1750966133.git.nicolinc@nvidia.com>
 <ebbcdf1437bd1f96aa76e9132eba3c68472403c3.1750966133.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebbcdf1437bd1f96aa76e9132eba3c68472403c3.1750966133.git.nicolinc@nvidia.com>

On Thu, Jun 26, 2025 at 12:34:51PM -0700, Nicolin Chen wrote:
> The iommu_hw_info can output via the out_data_type field the vendor data
> type from a driver, but this only allows driver to report one data type.
> 
> Now, with SMMUv3 having a Tegra241 CMDQV implementation, it has two sets
> of types and data structs to report.
> 
> One way to support that is to use the same type field bidirectionally.
> 
> Reuse the same field by adding an "in_data_type", allowing user space to
> request for a specific type and to get the corresponding data.
> 
> For backward compatibility, since the ioctl handler has never checked an
> input value, add an IOMMU_HW_INFO_FLAG_INPUT_TYPE to switch between the
> old output-only field and the new bidirectional field.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  include/uapi/linux/iommufd.h   | 20 +++++++++++++++++++-
>  drivers/iommu/iommufd/device.c |  9 ++++++---
>  2 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 6ad361ff9b06..6ae9d2102154 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -628,6 +628,15 @@ enum iommufd_hw_capabilities {
>  	IOMMU_HW_CAP_PCI_PASID_PRIV = 1 << 2,
>  };
>  
> +/**
> + * enum iommufd_hw_info_flags - Flags for iommu_hw_info
> + * @IOMMU_HW_INFO_FLAG_INPUT_TYPE: If set, @in_data_type carries an input type
> + *                                 for user space to request for a specific info
> + */
> +enum iommufd_hw_info_flags {
> +	IOMMU_HW_INFO_FLAG_INPUT_TYPE = 1 << 0,
> +};
> +
>  /**
>   * struct iommu_hw_info - ioctl(IOMMU_GET_HW_INFO)
>   * @size: sizeof(struct iommu_hw_info)
> @@ -637,6 +646,12 @@ enum iommufd_hw_capabilities {
>   *            data that kernel supports
>   * @data_uptr: User pointer to a user-space buffer used by the kernel to fill
>   *             the iommu type specific hardware information data
> + * @in_data_type: This shares the same field with @out_data_type, making it be
> + *                a bidirectional field. When IOMMU_HW_INFO_FLAG_INPUT_TYPE is
> + *                set, an input type carried via this @in_data_type field will
> + *                be valid, requesting for the info data to the given type. If
> + *                IOMMU_HW_INFO_FLAG_INPUT_TYPE is unset, any input value will
> + *                be seen as IOMMU_HW_INFO_TYPE_DEFAULT
>   * @out_data_type: Output the iommu hardware info type as defined in the enum
>   *                 iommu_hw_info_type.
>   * @out_capabilities: Output the generic iommu capability info type as defined
> @@ -666,7 +681,10 @@ struct iommu_hw_info {
>  	__u32 dev_id;
>  	__u32 data_len;
>  	__aligned_u64 data_uptr;
> -	__u32 out_data_type;
> +	union {
> +		__u32 in_data_type;
> +		__u32 out_data_type;
> +	};
>  	__u8 out_max_pasid_log2;
>  	__u8 __reserved[3];
>  	__aligned_u64 out_capabilities;
> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> index 64a51993e6a1..cbd86aabdd1c 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -1506,6 +1506,7 @@ EXPORT_SYMBOL_NS_GPL(iommufd_access_rw, "IOMMUFD");
>  
>  int iommufd_get_hw_info(struct iommufd_ucmd *ucmd)
>  {
> +	const u32 SUPPORTED_FLAGS = IOMMU_HW_INFO_FLAG_INPUT_TYPE;
>  	struct iommu_hw_info *cmd = ucmd->cmd;
>  	void __user *user_ptr = u64_to_user_ptr(cmd->data_uptr);
>  	const struct iommu_ops *ops;
> @@ -1515,12 +1516,14 @@ int iommufd_get_hw_info(struct iommufd_ucmd *ucmd)
>  	void *data;
>  	int rc;
>  
> -	if (cmd->flags || cmd->__reserved[0] || cmd->__reserved[1] ||
> -	    cmd->__reserved[2])
> +	if (cmd->flags & ~SUPPORTED_FLAGS)
> +		return -EOPNOTSUPP;
> +	if (cmd->__reserved[0] || cmd->__reserved[1] || cmd->__reserved[2])
>  		return -EOPNOTSUPP;
>  
>  	/* Clear the type field since drivers don't support a random input */
> -	cmd->out_data_type = IOMMU_HW_INFO_TYPE_DEFAULT;
> +	if (!(cmd->flags & IOMMU_HW_INFO_FLAG_INPUT_TYPE))
> +		cmd->in_data_type = IOMMU_HW_INFO_TYPE_DEFAULT;
>  
>  	idev = iommufd_get_device(ucmd, cmd->dev_id);
>  	if (IS_ERR(idev))

Reviewed-by: Pranjal Shrivastava <praan@google.com>

> -- 
> 2.43.0
> 
