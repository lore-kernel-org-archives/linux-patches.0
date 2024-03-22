Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C64769968
	for <patches@lists.linux.dev>; Fri, 22 Mar 2024 18:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711132586; cv=none; b=FwWgK1wY04XZgVGfQpZpJHzDVts70NZ/sUPJsDP0oIv69+7ysm77VKEdSZ9iMCY6XAOFNTkCdy5DNfVoiDxHmSgKrmrgtwvy4YckDpnJWemEvismNpmdXLgFcagE5yymtyKd1rwIbchqX/I/7+WBuZ60Uh1/FyRFsBM3iQctgCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711132586; c=relaxed/simple;
	bh=JoClKObtEAGJ+tT2fQIpky3Dipfqc32Ut+GvILAfph0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BF0N9Fty3r8Yevp1t+Zog7FPldS2JRs3I2E20CP5qmkO18jV4Ct4BII+l1+zLmKzGu64ifdAyQmhcdaB0NFMkTR+SUOomQ7cg79IRrIBDkEN6wmep1ke2G6l3UXChuU2Bxndz3d1I+vnYpgFbBudYQxt6txt651R5FiA0VYfpjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iWpukIG5; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iWpukIG5"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1deddb82b43so18255ad.0
        for <patches@lists.linux.dev>; Fri, 22 Mar 2024 11:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711132584; x=1711737384; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nVPoc0zBfC9U1ic1aSzwWnoSA6XoyfQtm0d93m0EMpw=;
        b=iWpukIG5k1tDs7/3wEIPNqyjncJneQUNdaRWGYMJi0J1noDuDwWgHkn0jRaP8l2jjf
         NroZfe/omjadWVOa36tRvLyY/5dzEtYHNrSp29viz6+msymqKhevQjDlW8ntJPsdjmOM
         BWklyIVBM6+Byj1g1bROm5DRUIWY5SzBQ2lj/GotFZpBpVA/yaR2LMBIw63z7ye3q+lu
         tV149Ug8GWDKv1Re76ttEkIWOUO1qhH6BsX53BB1i4YuUZV/P2iFdU4Ov/dwFB3WDDAK
         NkUTRMo7Lzr5KuWAUROf7l3jvUK+9aMP+LhPEr7xk7YF/+/BQoa56q9+nAuRG7XBsqR9
         lXZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711132584; x=1711737384;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nVPoc0zBfC9U1ic1aSzwWnoSA6XoyfQtm0d93m0EMpw=;
        b=v/2W4WnBcfzIFEYij3ywVyc9Z9GHmpMR5N69B5dSqIXGC3G09yuL2uASZwY1P2bEJ0
         59ngwodm1l5o++Fsy0h9SyYN97D5a3ZzkiRN4xmGRBk/XUke/PXKpFHehkff8SM1Enq5
         ENRoproXqOx3YWjh6sum+DJ9PD7Das0eAQZs99SbAAM9LaJl5czS4DqJsgsHZoLL9P7/
         XAaWKUlRLETeuMGgPPqBApU+SyrTCTHVdycZywmBls1Ka12LpdQ7HeRQyZy4MinpWuJl
         kA+iXUuID7pN6iCVuRD3LXkwBu9G6jnPVetS25EQswASgt2/1C7qq2bVqQqN0JETIn9K
         y3Vg==
X-Forwarded-Encrypted: i=1; AJvYcCVNAtfq2/NI3sHNkbaIL2HtVzMrqCDocecIVRKOivODqP3xkt6HUEQ52kKCpPkZrhVLFA0QhWlUB/QaUUhxbZkZ+KzY/HLLQg==
X-Gm-Message-State: AOJu0YzgSKe+DZh5exawhHMCplNjOG80nYBfCpzTAdZI23qoDW0SrRY0
	1OnqpRmzIzKMQX+KXXpmLdT2bsugi2fbNVSeOBh4k9MtUctxNXepQaSm1K5BFQ==
X-Google-Smtp-Source: AGHT+IEqcUEHz846wp32mZoycYvHFc25nLCog9QUGkMqh5QA3Top43vW55sXYxEXlOBafcwvEnZn3A==
X-Received: by 2002:a17:902:ce81:b0:1e0:9f59:ed0e with SMTP id f1-20020a170902ce8100b001e09f59ed0emr67263plg.25.1711132583667;
        Fri, 22 Mar 2024 11:36:23 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id v7-20020aa799c7000000b006e77dcba6a2sm62198pfi.207.2024.03.22.11.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 11:36:23 -0700 (PDT)
Date: Fri, 22 Mar 2024 18:36:17 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 06/27] iommu/arm-smmu-v3: Consolidate clearing a CD
 table entry
Message-ID: <Zf3PoRy_q7dC_SA9@google.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <6-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>

Hi Jason,

On Mon, Mar 04, 2024 at 07:43:54PM -0400, Jason Gunthorpe wrote:
> A cleared entry is all 0's. Make arm_smmu_clear_cd() do this sequence.
> 
> If we are clearing an entry and for some reason it is not already
> allocated in the CD table then something has gone wrong.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  2 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 20 ++++++++++++++-----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  2 ++
>  3 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 347c2fdd865c1a..bb9bb6fd7914ce 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -558,7 +558,7 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
>  
>  	mutex_lock(&sva_lock);
>  
> -	arm_smmu_write_ctx_desc(master, id, NULL);
> +	arm_smmu_clear_cd(master, id);
>  
>  	list_for_each_entry(t, &master->bonds, list) {
>  		if (t->mm == mm) {
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 237fd6d92c880b..3fb4a1523d1d3f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1303,6 +1303,19 @@ static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
>  	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
>  }
>  
> +void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
> +{
> +	struct arm_smmu_cd target = {};
> +	struct arm_smmu_cd *cdptr;
> +
> +	if (!master->cd_table.cdtab)
> +		return;
> +	cdptr = arm_smmu_get_cd_ptr(master, ssid);
> +	if (WARN_ON(!cdptr))
> +		return;

I don’t understand the SVA code enough, but AFAICT, arm_smmu_sva_set_dev_pasid
can allocate the L2 CD table through arm_smmu_write_ctx_desc. And if it failed
before allocating the CD table, then remove_dev_pasid would be called, which
warns here, the previous code would tolerate that, but that might regress on
systems with panic_on_warn, so I am not sure if that is necessary.

Otherwise, Reviewed-by: Mostafa Saleh <smostafa@google.com>

> +	arm_smmu_write_cd_entry(master, ssid, cdptr, &target);
> +}
> +
>  int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
>  			    struct arm_smmu_ctx_desc *cd)
>  {
> @@ -2702,9 +2715,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  	case ARM_SMMU_DOMAIN_S2:
>  		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
>  		arm_smmu_install_ste_for_dev(master, &target);
> -		if (master->cd_table.cdtab)
> -			arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
> -						      NULL);
> +		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
>  		break;
>  	}
>  
> @@ -2752,8 +2763,7 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
>  	 * arm_smmu_domain->devices to avoid races updating the same context
>  	 * descriptor from arm_smmu_share_asid().
>  	 */
> -	if (master->cd_table.cdtab)
> -		arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, NULL);
> +	arm_smmu_clear_cd(master, IOMMU_NO_PASID);
>  	return 0;
>  }
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 7078ed569fd4d3..87a7b57f566fbc 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -749,6 +749,8 @@ extern struct xarray arm_smmu_asid_xa;
>  extern struct mutex arm_smmu_asid_lock;
>  extern struct arm_smmu_ctx_desc quiet_cd;
>  
> +void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
> +
>  int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
>  			    struct arm_smmu_ctx_desc *cd);
>  void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
> -- 
> 2.43.2
>
Thanks,
Mostafa
