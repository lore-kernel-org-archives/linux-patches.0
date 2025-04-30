Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D903322331C
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 22:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746050647; cv=none; b=EUWg3neEs8n0bvhkQImN6iSR8s8YgD8CFBk3ZXoO4PuoImKN4c3HOYzakzkawxiZqMo+1SCV3vhIjpkIETkrUzFHFtS4ww4lUYH+jjU2wi2wHdG2bre0iAvhQpUvdfdEj1bXDzIp+t4aWAMYdCtN/ECtbTKw5Y5XqIX18pm5UBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746050647; c=relaxed/simple;
	bh=a6a4m8o4Fnf9b9bUx8vDZ1tnb4WXvfqXb62W3uQzEvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hFzP1dUJ0terngvcyVgpi9COOKOREaZ8d+ltf8cOBSJ3YzB99TcwlNOVd85xvbfEjS6RShjDnGDi7VlxuIm//+mhETbRutzxEpvERfFwy+Mm9la6XVSQVvEegUtwVSAr/FehH7zpOwcsBitez563azTJfRub1cbvq1flHemS3BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U8lLM25r; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U8lLM25r"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2264c9d0295so20585ad.0
        for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746050645; x=1746655445; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FVawBlGLpoSzo0dY08dmSMH05U/ahZ0t0/eytQcNdTQ=;
        b=U8lLM25rXYMGU1dJN8XbgAmRBqmR1/upk3NBTsr5NNCQGmO2nGwD1nR2JEyhCQ5Lbh
         o0ufwMiW4gjSsJlA2SpcSoPTQ/K65jRwbOQCwy8qneAHffI5vlRO/VCsilRAWerw/RTp
         HdwZ6Db8BmBaEv/Ubx+Sh1zHgkipT/3to41e7w9sdu9rVzMnevhG/vtfLzFtJLKBlvhD
         1TFaHNiVnGt+/aAXine3vdEnpw6oasxCGs+7F/ELQuaIj7PVZWt1x5gRuIOGy1OWJh7v
         hvpgKLanMG3dm7lNvqMLh/5GN7yYrLqxXXRCvQFNPfGURp1Z1Ld/4FLRtx6ahjrq/XVM
         tbeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746050645; x=1746655445;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FVawBlGLpoSzo0dY08dmSMH05U/ahZ0t0/eytQcNdTQ=;
        b=iueqg48Y/i41vSdjVcLQ5q7UiuuLc7YWqCGHnqwCNgbruxTgdZcKJ1oF1YMJeuIPso
         eHf+P53NcSXCnmNoi+WRrPO4cPHyZCj+FORbyV9lHOYCaRBtVIfw7acmf6D0MLeL2brH
         4HnLHgnoLFAGlmSeerG1oPk3DIjTNAQNAvob284iTUIShQOfQdgJ1D7vp50z7EzVDpRy
         dQ5TCm+2aAx4ocQ978+j153bj2YMF6D9N73nLWo6qpPILLWs+s2tUUaYI+8xInSJLhpV
         puxNIxgeNJAF8untwC8u7sdgPeUK3/No1x3qL4nDSMmS7aoBvv7okoSyEPiVJVX4ufL6
         hgOw==
X-Forwarded-Encrypted: i=1; AJvYcCW1ZF8yQ0eMhiKeLuoB9VNfoDZs8yuSbY3Ux1CKDAJVvRPIkpCLGqkYWPSDBqs1W8RWp6ovELXX@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9vDYjWy/lG2gPaTzD6A8TYLMfeNpWm3OvKXngaU/ScffVy5iL
	5ol7cenebUi/XBuBJ2C5+vea91KGFhGDaAbNwodbxyVJVQCLdWJTMeDzXy5UUw==
X-Gm-Gg: ASbGnctouuBcVEZDFwohSonhGvapG4rWptJwtywB38oWdNc8cZ+kS+moObKOGsmugih
	Wexj+sOugSinMG+PsC0kHHAE2WqkSYd4wkkIe1PV09Xdf4jbFm12OB6PlCzZEWYnwIgIo8Nu1C4
	/2DcWLtj4za9vD8OeFouUpE4fWgJsNugGvSGewNc5QkJfb9vp4fQ1RktEf1Mk3havtEQsplfswF
	U3C+jUs0bn3IbGPiHwaRClyawwNV36OOpJ1eS0gpfsi+KyhSpDvckSUBKxFRYFUhRmGoqA9aiqS
	HPU6RnPfljcMk1h1vuUjHzKg16lZ1CovgvBMSR6a7TkXWrxeKVGl0yljwcwTnZFHEK4IC/4I
X-Google-Smtp-Source: AGHT+IGd4hYbbWLBFZpJCFZt3J+kQFvNTF3X43diXZZjefIRoFc4WvBq3IOD+DnYRjbMCinfwG1ReQ==
X-Received: by 2002:a17:903:17c3:b0:21f:9f4:4a03 with SMTP id d9443c01a7336-22e07a8ada1mr325415ad.21.1746050644476;
        Wed, 30 Apr 2025 15:04:04 -0700 (PDT)
Received: from google.com (2.210.143.34.bc.googleusercontent.com. [34.143.210.2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5104cd5sm127537775ad.199.2025.04.30.15.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 15:04:04 -0700 (PDT)
Date: Wed, 30 Apr 2025 22:03:53 +0000
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
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com
Subject: Re: [PATCH v2 22/22] iommu/tegra241-cmdqv: Add
 IOMMU_VEVENTQ_TYPE_TEGRA241_CMDQV support
Message-ID: <aBKeSeuPvTruzchM@google.com>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <a7db1d2fe5dd43ac7ac075df662f3ab743ac6aa2.1745646960.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7db1d2fe5dd43ac7ac075df662f3ab743ac6aa2.1745646960.git.nicolinc@nvidia.com>

On Fri, Apr 25, 2025 at 10:58:17PM -0700, Nicolin Chen wrote:
> Add a new vEVENTQ type for VINTFs that are assigned to the user space.
> Simply report the two 64-bit LVCMDQ_ERR_MAPs register values.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

> ---
>  include/uapi/linux/iommufd.h                  | 15 +++++++++++++
>  .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    | 22 +++++++++++++++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index d69e7c1d39ea..d814b0f61fad 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -1113,10 +1113,12 @@ struct iommufd_vevent_header {
>   * enum iommu_veventq_type - Virtual Event Queue Type
>   * @IOMMU_VEVENTQ_TYPE_DEFAULT: Reserved for future use
>   * @IOMMU_VEVENTQ_TYPE_ARM_SMMUV3: ARM SMMUv3 Virtual Event Queue
> + * @IOMMU_VEVENTQ_TYPE_TEGRA241_CMDQV: NVIDIA Tegra241 CMDQV Extension IRQ
>   */
>  enum iommu_veventq_type {
>  	IOMMU_VEVENTQ_TYPE_DEFAULT = 0,
>  	IOMMU_VEVENTQ_TYPE_ARM_SMMUV3 = 1,
> +	IOMMU_VEVENTQ_TYPE_TEGRA241_CMDQV = 2,
>  };
>  
>  /**
> @@ -1140,6 +1142,19 @@ struct iommu_vevent_arm_smmuv3 {
>  	__aligned_le64 evt[4];
>  };
>  
> +/**
> + * struct iommu_vevent_tegra241_cmdqv - Tegra241 CMDQV IRQ
> + *                                      (IOMMU_VEVENTQ_TYPE_TEGRA241_CMDQV)
> + * @lvcmdq_err_map: 128-bit logical vcmdq error map, little-endian.
> + *                  (Refer to register LVCMDQ_ERR_MAPs per VINTF )
> + *
> + * The 128-bit register value from HW exclusively reflect the error bits for a
> + * Virtual Interface represented by a vIOMMU object. Read and report directly.
> + */
> +struct iommu_vevent_tegra241_cmdqv {
> +	__aligned_le64 lvcmdq_err_map[2];
> +};
> +
>  /**
>   * struct iommu_veventq_alloc - ioctl(IOMMU_VEVENTQ_ALLOC)
>   * @size: sizeof(struct iommu_veventq_alloc)
> diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
> index 88e2b6506b3a..d8830b526601 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
> @@ -292,6 +292,20 @@ static inline int vcmdq_write_config(struct tegra241_vcmdq *vcmdq, u32 regval)
>  
>  /* ISR Functions */
>  
> +static void tegra241_vintf_user_handle_error(struct tegra241_vintf *vintf)
> +{
> +	struct iommufd_viommu *viommu = &vintf->vsmmu.core;
> +	struct iommu_vevent_tegra241_cmdqv vevent_data;
> +	int i;
> +
> +	for (i = 0; i < LVCMDQ_ERR_MAP_NUM_64; i++)
> +		vevent_data.lvcmdq_err_map[i] =
> +			readq_relaxed(REG_VINTF(vintf, LVCMDQ_ERR_MAP_64(i)));
> +
> +	iommufd_viommu_report_event(viommu, IOMMU_VEVENTQ_TYPE_TEGRA241_CMDQV,
> +				    &vevent_data, sizeof(vevent_data));
> +}
> +
>  static void tegra241_vintf0_handle_error(struct tegra241_vintf *vintf)
>  {
>  	int i;
> @@ -337,6 +351,14 @@ static irqreturn_t tegra241_cmdqv_isr(int irq, void *devid)
>  		vintf_map &= ~BIT_ULL(0);
>  	}
>  
> +	/* Handle other user VINTFs and their LVCMDQs */
> +	while (vintf_map) {
> +		unsigned long idx = __ffs64(vintf_map);
> +
> +		tegra241_vintf_user_handle_error(cmdqv->vintfs[idx]);
> +		vintf_map &= ~BIT_ULL(idx);
> +	}
> +
>  	return IRQ_HANDLED;
>  }
>  
> -- 
> 2.43.0
> 
