Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504C81422B0
	for <patches@lists.linux.dev>; Tue,  4 Jun 2024 16:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717517698; cv=none; b=Ph239U1uY3+4w1FkJxXx4zgsdgTs6JC1bxcWlcO5hqj8oq9atqJfadAKqT0Ti6/+xRzH/w4ERV4bsSpjlqeIbd2AkSokERzaCqqrGYwDSWCvYjkVDOcgn+/QNXj/hrGrIzI+Wr2ULuUSfhu4K20mcPhcoVDNud24juztbT9xLPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717517698; c=relaxed/simple;
	bh=A+KJEf62r+PQJ2NFLQQYh/BjL05TFImeAFPqIdGD1J8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GO0DlCZS+/xS4LZ/UNK0SWPzyhWDcRzpOF9JB/S8JJRDdz4NnqVpcSrlfNvrii+wv+B8Td54QO7kxnWKep0fEaKnH9J7SEJlfk8rQvcTp1nzBuZuu3MVJW7f0fO+03INrRrs5+LAFlFCdGvLY8NzmuV81Rgjgfh6/9RvQgAO5+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hQQTOzxc; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hQQTOzxc"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-42135a497c3so143465e9.0
        for <patches@lists.linux.dev>; Tue, 04 Jun 2024 09:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717517694; x=1718122494; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sog84U7Wd5TBpIF8EHL5jNYn8tkvMRV0fzjn9o9wjNM=;
        b=hQQTOzxc9vK82yakLewcK2B+zz1+1q/rSPmmBKHJ+sORokgnEBah543BKF/WhjyW+R
         vMxhu8qbKUGWXePZx7gvhsqlX5gICX1Q1frlqavrblm3J6Mw3ZMu5CneSWGQYoWs2/Is
         vUm6IO3JKeIHeBIbvnfVbZOzD1gM8peHnRSSjo6ISXuMZgYkHWgMViS5Im5e7Xf2jzOH
         tyXrjq2+3dKZkNyZaKfoT+CFsQW9gbRYkXJOeRa3+VxiqBo6YupxdXNfpw8NSJJU9XWi
         7rJdpCVN8ncbLzDSIv2EzyCH42nW4wjfnkuFDXdh3HsFihtVdC/Fd0Kapl61f/cknCYl
         hQYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717517695; x=1718122495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sog84U7Wd5TBpIF8EHL5jNYn8tkvMRV0fzjn9o9wjNM=;
        b=LDo1Cq2YDFrch1RYy0yq+2CtkKgqkrrA6Bmim2pFfYg8nhdzqRCK02JpSPO0CLjj8y
         QtFByDKWplCMh10dY+ibUxzPukuQyGDocg0eNbse/LkbDNso/9rwBXXKOkq/gnY4fWYc
         +diLPFuoeCetRIcbkNmbFMJJSMyrqAOGXtKsumeTyx8T9nvYnbN05+827mtTNiTQ9Ymk
         5R7s1tf+xRi2pABOrl2aXz4hZ2kYsJU4IWa59sGfUAQEDs3MXMtbbjUPr6x169dUuj+x
         FNoyx7PBpYLvfgY9qRVGn2wmLrjGvzvXpQfhDw9OR4q6HwyVMhG1u+TnYfrkppmMkqPE
         Mq3g==
X-Forwarded-Encrypted: i=1; AJvYcCVzFAO+Aqgj8o698xfCP8AVrn2AzWn+y7DPRKQpi8ilWTDHNAzz8yFMJ7Q1vr8IjlmunSPeKvI+bomSxlqLl44Pu5hA+G+hNA==
X-Gm-Message-State: AOJu0Yzs8p1xueEr0P1SlMISW29miExeZfgAoxgpY5+3tmrsvsgmW4sP
	O2OtTBQaMxqp2wdMeBWbl+LL7irDAO5RrFFPuVTClA3I/FNkUTWQ7GhWPcjweA==
X-Google-Smtp-Source: AGHT+IHORJ6oTFX5Gt9IksIYn5pHPDh+i7h51QlKwFVCpGyoweS9KLKWHiKZzbzJ90ofU21HdPIECA==
X-Received: by 2002:a05:600c:5122:b0:41b:e55c:8dca with SMTP id 5b1f17b1804b1-4214b226851mr2552395e9.7.1717517694401;
        Tue, 04 Jun 2024 09:14:54 -0700 (PDT)
Received: from google.com (230.213.79.34.bc.googleusercontent.com. [34.79.213.230])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4214f46edd4sm26319855e9.45.2024.06.04.09.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 09:14:54 -0700 (PDT)
Date: Tue, 4 Jun 2024 16:14:50 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 6/7] iommu/arm-smmu-v3: Shrink the cdtab l1_desc array
Message-ID: <Zl89eleAaHzdNYjV@google.com>
References: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <6-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>

Hi Jason,

On Mon, Jun 03, 2024 at 07:31:32PM -0300, Jason Gunthorpe wrote:
> The top of the 2 level CD table is (at most) 1024 entries big, and two
> high order allocations are required. One of __le64 which is programmed
> into the HW (8k) and one of struct arm_smmu_l1_ctx_desc which holds the
> CPU pointer (16k).
> 
> There are two copies of the l2ptr_dma, one is stored in the struct
> arm_smmu_l1_ctx_desc, and another is encoded in the __le64 for the HW to
> use. Instead of storing two copies just decode the value from the __le64.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 35 ++++++++++-----------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
>  2 files changed, 16 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 3f2e0462433d2d..7a6c9aac4cd450 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1167,28 +1167,19 @@ static void arm_smmu_sync_cd(struct arm_smmu_master *master,
>  	arm_smmu_cmdq_batch_submit(smmu, &cmds);
>  }
>  
> -static int arm_smmu_alloc_cd_leaf_table(struct arm_smmu_device *smmu,
> -					struct arm_smmu_l1_ctx_desc *l1_desc)
> +static void arm_smmu_write_cd_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
>  {
> -	size_t size = CTXDESC_L2_ENTRIES * sizeof(struct arm_smmu_cd);
> -
> -	l1_desc->l2ptr = dma_alloc_coherent(smmu->dev, size,
> -					    &l1_desc->l2ptr_dma, GFP_KERNEL);
> -	if (!l1_desc->l2ptr)
> -		return -ENOMEM;
> -	return 0;
> -}
> -
> -static void arm_smmu_write_cd_l1_desc(__le64 *dst,
> -				      struct arm_smmu_l1_ctx_desc *l1_desc)
> -{
> -	u64 val = (l1_desc->l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) |
> -		  CTXDESC_L1_DESC_V;
> +	u64 val = (l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) | CTXDESC_L1_DESC_V;
>  
>  	/* The HW has 64 bit atomicity with stores to the L2 CD table */
>  	WRITE_ONCE(*dst, cpu_to_le64(val));
>  }
>  
> +static dma_addr_t arm_smmu_cd_l1_get_desc(__le64 *src)
> +{
> +	return le64_to_cpu(*src) & CTXDESC_L1_DESC_L2PTR_MASK;
> +}
> +
>  struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
>  					u32 ssid)
>  {
> @@ -1227,13 +1218,18 @@ struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
>  
>  		l1_desc = &cd_table->l1_desc[idx];
>  		if (!l1_desc->l2ptr) {
> +			dma_addr_t l2ptr_dma;
>  			__le64 *l1ptr;
>  
> -			if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
> +			l1_desc->l2ptr = dma_alloc_coherent(
> +				smmu->dev,
> +				CTXDESC_L2_ENTRIES * sizeof(struct arm_smmu_cd),
> +				&l2ptr_dma, GFP_KERNEL);
> +			if (!l1_desc->l2ptr)
>  				return NULL;
>  
>  			l1ptr = &cd_table->cdtab.l1_desc[idx];
> -			arm_smmu_write_cd_l1_desc(l1ptr, l1_desc);
> +			arm_smmu_write_cd_l1_desc(l1ptr, l2ptr_dma);
>  			/* An invalid L1CD can be cached */
>  			arm_smmu_sync_cd(master, ssid, false);
>  		}
> @@ -1406,7 +1402,8 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
>  
>  			dma_free_coherent(smmu->dev, size,
>  					  cd_table->l1_desc[i].l2ptr,
> -					  cd_table->l1_desc[i].l2ptr_dma);
> +					  arm_smmu_cd_l1_get_desc(
> +						  &cd_table->cdtab.l1_desc[i]));
>  		}
>  		kfree(cd_table->l1_desc);
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 21c1acf34dd29c..1ffe2fdfd3755f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -587,7 +587,6 @@ struct arm_smmu_ctx_desc {
>  
>  struct arm_smmu_l1_ctx_desc {
>  	struct arm_smmu_cd		*l2ptr;
> -	dma_addr_t			l2ptr_dma;

Maybe now we can also get rid of arm_smmu_l1_ctx_desc, and embed l2ptr directly
in arm_smmu_ctx_desc_cfg?

>  };
>  
>  struct arm_smmu_ctx_desc_cfg {
> -- 
> 2.45.2
> 

Thanks,
Mostafa
