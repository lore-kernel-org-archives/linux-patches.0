Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EC94EF15B
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 17:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790615142; cv=none; b=WL7GtqukpA9KkDKTWoSrvOedkfLt+CF11mIKG4JvC6Gx0/pRIQU2yEUZHWz4JyNHbRIjOKUvHJf/x5J+YNtcMl2hkX5D0AjSA0jKlm4qWtyfj88COAP1Bbxpda4k1uyOvE1d0klSuLdabgbHxVhVQFbzf9JxZsus1pWC04TDz5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790615142; c=relaxed/simple;
	bh=Q8tvAWP6jumWUL42nIbZpr65seFVkU5veTcSD+6xbwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DZUjXiai3WaoPkUTZhhZTAOnew2mrLk4zF4rwHS7tI5Ift5H1wK168WZdVGmbAKTHly9Xx5xmwRqGc280+XJkYE11KaV6XWbnsjgihDvyhtsY91zAV3xL9ZzoitT7exRG1+gOXZxtjN5GDz8PPl1WbBTJMgajvpd5mpK2npMsVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VE9RsxAx; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VE9RsxAx"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2d8fd7a3f38so1985ad.1
        for <patches@lists.linux.dev>; Mon, 28 Sep 2026 10:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790615138; x=1791219938; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ban7nhZo4CJqKpPDdVZLRncSMRaeOxomE1+tyNWWrJM=;
        b=VE9RsxAxNoRRG6vXXxqX9/n5ok+MraQGl1uy8PK66De318SzniQWQTrF10Y17EGGlG
         pU4bMTwjD2CVaMF9qH5MB3NuVQKrvQwrqbO2XTtNOwI/neXbDyXsrewx1XqIYYzWNCCu
         6Va3Fdkfhi3dOVYv6FJv9wkpBqR7Nu5D71u0van3EtJgQmQnUQ3gnhnzSebi243gC9tH
         QiI6KBcJd3z6+1P373JvmaYsAe2LV8EeTC0vVSPXDYto3DEvoQjBaJ0fBGwP9jt2iKQS
         XRmm+wc9uWHUg58Te16boCy6jqOELaLG+xp557mC6OkxZBSjZFQLqbblmhIbmaJm03c/
         Y0yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790615138; x=1791219938;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ban7nhZo4CJqKpPDdVZLRncSMRaeOxomE1+tyNWWrJM=;
        b=1HjCs4ivCzydJLIdFH9hrprxC9JQuUbN98FSUZghnJkO1HT1IaXCsQ+cwf67Xi/+K+
         FXVFs12avmcxdfu+sV6W9tGmbFIt5XlyB/bREiYDFmoDA8LcZCqP+9Vf0kPS5/UjVo26
         0CFuuxdWbUA7Zp0zoQTdBZA0fpJqMSltohP2b7clrbjKBrsxQFRM+ALPBoBXLUZjWJow
         FvLlTwcXC7ftU+jNzgD8vVS/+i9OPe5uRWUP3xeWJl02AP4xsd0+l09jRl8I4d+QVVVm
         KpOq7CaSDqxvegzmhYE1Wqy8kE0OHNKkaswLVUMdSg4827xXYOKWWuK1/moXaGnKSN6o
         f1Vw==
X-Forwarded-Encrypted: i=1; AKwUvBzL23LhxU/qKY/tWauRah/ECAHfCKZzxhfqCc0zWwqISjEewpyK6aEieybmwpxUxU7gWol6pzwj@lists.linux.dev
X-Gm-Message-State: AFq9FYJoLcSW4Goy+IMfeqNL4gKd+7IH0G6OKZwuWyeKRTSrVSsmkaHi
	g8kLEBqKKm8UTmDWB8IoSHvBvNmuoyW5Oq/+fYAI8rWN3qxpTPDjgcYLUYGJJG4dHw==
X-Gm-Gg: AYBFou0Q3qs92iYWSNELFfeCVqExJqqwwnGrrbLf4MiF3xobWKjfOmpnuLjOIF64rrI
	rxKYNJJo+rUhDT0CQPCxGVRbNXGfLGIJxQ3zRf7S6zjxSsdoTouyUmCFyVmTeWswvBEWRbDq5W6
	L5EDtiw+klf0n18rggbHcxKq4wzWDsSt5bGEPRkPkyOwP/nMEP1fSJjvWw8aOWUf7CUJI++KYHX
	Otxetw2VDqzG9YBh/epjPwcSxbtR82RVqNeEygcX4RWCIgfT4UW6kXWBPr5sxXoMLiv8iyoid0h
	Ez5cIGKD5InO0YiVKJnhzHneBp/1TYWwZQ81CagPcuuRbarhN2bi/WkpMW+1biddC170o7Sf+iC
	15Iujgt4hRLzfSUY1TFihDzOMg6cJRze26QahCYrBXYinZDwQIrE0Gy7gOUDpAdCa5du4zUraW8
	cJ0E58EunvPstGiwwI5+ymrzKSrAphJ6ouvNOdHNad4cYeZfb/gQp79iKc7orwty5iuF4+97Vnj
	bqTdwj4qai+LuD28GGPpcASgRNY38/tawpc
X-Received: by 2002:a17:903:1aa3:b0:2d5:db38:800f with SMTP id d9443c01a7336-2dfa6227507mr8287085ad.14.1790615137568;
        Mon, 28 Sep 2026 10:05:37 -0700 (PDT)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9142b00dsm45359075ad.49.2026.09.28.10.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 10:05:37 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:05:29 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v7 7/9] iommu/arm-smmu-v3: Populate the tlbi at the top
 of the call chain
Message-ID: <arqeWXL1jhz9R9-j@google.com>
References: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
 <7-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>

On Mon, Sep 21, 2026 at 08:55:15PM -0300, Jason Gunthorpe wrote:
> Each of these have their own unique situation, populate the tlbi right at
> the top and pass it into arm_smmu_domain_inv_range(). They will diverge
> further when the iommupt invalidation scheme is introduced.
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 21 ++++----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 54 ++++++++++---------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 15 ++++--
>  3 files changed, 51 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 2f76f649dcf1a5..faeec656da9e7f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -140,16 +140,19 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
>  {
>  	struct arm_smmu_domain *smmu_domain =
>  		container_of(mn, struct arm_smmu_domain, mmu_notifier);
> -	size_t size;
> +	struct arm_smmu_tlbi tlbi = {
> +		.tgsz_lg2 = smmu_domain->tgsz_lg2,
> +		.iova = start,
> +		/*
> +		 * The mm_types defines vm_end as the first byte after the end
> +		 * address, different from IOMMU subsystem using the last
> +		 * address of an address range.
> +		 */
> +		.size = end - start,
> +		.iopte_size = PAGE_SIZE,
> +	};
>  
> -	/*
> -	 * The mm_types defines vm_end as the first byte after the end address,
> -	 * different from IOMMU subsystem using the last address of an address
> -	 * range. So do a simple translation here by calculating size correctly.
> -	 */
> -	size = end - start;
> -
> -	arm_smmu_domain_inv_range(smmu_domain, start, size, PAGE_SIZE, false);
> +	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
>  }
>  
>  static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index b7c9cd074924e4..4062ef2e13fe30 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2801,25 +2801,13 @@ static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
>  	}
>  }
>  
> -void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
> -			       unsigned long iova, size_t size,
> -			       unsigned int granule, bool leaf)
> +void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
> +			  struct arm_smmu_domain *smmu_domain)

A caller re-using the tlbi would overflow the 2-entry range.cmds[], since
num_cmds is never reset or checked. Should we sanity check num_cmds here?

Otherwise,

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
