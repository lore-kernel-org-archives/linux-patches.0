Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E6721D59C
	for <patches@lists.linux.dev>; Mon, 16 Jun 2025 21:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750110449; cv=none; b=gPzdthFy/GrSeYXkz9Fo1oJ20MWmrR9n0uQ3SOxwUPS4LC9wZpvTmySq8l2p8skbf8Rfj1I3n3ZhFxbYgVMdb8OflTxZPCKwNK2gGSGxhZG/BR+9mKwUdVv8QgrhhfJfQ42jgk+3PtfukIXWXHVCZT1y7zGJvYZWlccbeLL75vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750110449; c=relaxed/simple;
	bh=z2qeyaEDa8QvsVY4HmYmJ2h1mEKFu6Hb5NQ1IlDbbqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G0/pfzK5n736kKLn6+c977hSeHUx88IgUF4zoWNPIRde/FV+TCbeLck3jTL/gc01TuoGhhPbVUh3Cg7+9kJcTmheI1HO6MUT/WI5NK6KyBDVMvs2/JunNpgEpvnypA6HiWFlx3Gl8TN9qhk3dbsMWTvkBLXm9eUcBwzCkrlLM1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VLysaXlM; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VLysaXlM"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-235ca5eba8cso58245ad.0
        for <patches@lists.linux.dev>; Mon, 16 Jun 2025 14:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750110447; x=1750715247; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b+7yTuFOYw/+OFN7i63Es/kgRcKQFjeHwd4HaCwCrWY=;
        b=VLysaXlM/WrX8CiV3CW74jaoyuBzF7+qPMxq+eFUnAt84PHumrSN9RWFdsfwzCezrn
         hQkMdSDsQlGP5XOkFauOTbIumpwrbSgG+9DfwIngjLQNdWYCYiBFbiT9e7PeJOKSmr+R
         cN4xH0/nMG//PQ28LPffbBsyZMjv8/QbCR2bVTgrgnriO/d6VA0LRS00l8zM/fXmuFwr
         L3G6tmWnU/A7erSSalgxpdBvZxuMGHRdOOzY48YiRKSdKhsSY1ml/FOLA1IXgcw/bXf2
         GstXnpWRrSLd18rqe5nOpBROjHCEaZqLP1veJ/IHjm/slHkCQq6OGiZqQTpW4xaohshl
         CFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750110447; x=1750715247;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+7yTuFOYw/+OFN7i63Es/kgRcKQFjeHwd4HaCwCrWY=;
        b=Dzql3ZTPnWG4LKeoFljkMIWClIEn2u2fVjXqXMfmvIwh9TTQkX76QE+rMbYCRVOqEn
         8Ig0a7bLpEwJbHXYP+NH33Q/71a6q0P2k1ELYFOaHnvgPWzVGZquOGtpQ6X73F96h2y2
         CnkJkTgdMBMK3VTgj/D5wfIP0/U1UYfSEAaFOfnaV/g36E5HIU2C9xpDJFryY8gSKMPr
         CuRyfPlaAwsmf0lJW/ImJGvw7niTEHeo43pLAUcO+uOssA7Z469RMXt9TsoWD/fYaNyp
         JTs3Vy5/P/7/K5hpTNzF3TQtX35YT5gy4kR7noOuBBP7fei1EC0czWgJ6y2uf8OaxxKX
         jtMQ==
X-Forwarded-Encrypted: i=1; AJvYcCV81J6i/Ud/z4YctkH+IEvJ/ORmAQl43eQsfcK/KW6h+z2fYHdFKdCehClCD7LqcjMIKAXmTJ3m@lists.linux.dev
X-Gm-Message-State: AOJu0YznozWtzd11+Tw4GUToGTjyTf47hyFn9LdVmvsfDd+2RdGl7GF3
	A/ZMNce7uHfeq9oDAjLofBFZMg72F2JKtT3Px6d/WfjwLEW1/Y5IIHfRv3cmjNIkQw==
X-Gm-Gg: ASbGncvqKPArDYpzeA2JP6FTFNiB1CD3Zpd7t5uq1wNuxxJuMEOPRiRbyJzI0OWafMi
	DTATm5NsI4gKU84j67OXX5CIau6qMEmis+/GwyRrPmTeGQlmHow3hnvQAUEu3UiZCF+KSRGlZ0l
	H3pF+y0Ic1JYapX7y1DEC1ScGu83nus0iKxA6PsCjy/3vRX4UVgD2RVKyEoSyO7JDGh/MjZHmnD
	gnqoR+CwiCju+fnvXRefFiuhBEWv/2JG1SDiGxyDTlakMn5Gk+OB6l9YM51K8cX0PwRgvDqo5yz
	xP74b8IC2kRiMGk14mNZgh2sEsTFjgpbvY7m5vTTxQm2y1hIOB8KVARgCEgh/dXBEKShAUNGWXX
	paoPFr2VmMdslDiWbrzMt24M2YPn0lmU=
X-Google-Smtp-Source: AGHT+IHag3rw8aX4ZKoeizjYKIh5qE5BVC5WmHX9g+TIQMgoMav4KZZJKeYmD/v1LvZQLFwcJimtlg==
X-Received: by 2002:a17:903:1a27:b0:234:bf4:98ba with SMTP id d9443c01a7336-2366c5bf768mr6069465ad.6.1750110446641;
        Mon, 16 Jun 2025 14:47:26 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fe1680c1esm6263160a12.48.2025.06.16.14.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 14:47:26 -0700 (PDT)
Date: Mon, 16 Jun 2025 21:47:17 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, will@kernel.org,
	robin.murphy@arm.com, joro@8bytes.org, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v2 04/14] iommufd: Use enum iommu_veventq_type for type
 in struct iommufd_veventq
Message-ID: <aFCQ5fAn4FYXUr0G@google.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <208a260c100a00667d3799feaad1260745f96c6b.1749882255.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <208a260c100a00667d3799feaad1260745f96c6b.1749882255.git.nicolinc@nvidia.com>

On Fri, Jun 13, 2025 at 11:35:16PM -0700, Nicolin Chen wrote:
> Replace unsigned init, to make it clear. No functional changes.

Nit: s/init/int

> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommufd/iommufd_private.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> index 4619285c09b7..32f0631368e1 100644
> --- a/drivers/iommu/iommufd/iommufd_private.h
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -526,7 +526,7 @@ struct iommufd_veventq {
>  	struct list_head node; /* for iommufd_viommu::veventqs */
>  	struct iommufd_vevent lost_events_header;
>  
> -	unsigned int type;
> +	enum iommu_veventq_type type;
>  	unsigned int depth;
>  
>  	/* Use common.lock for protection */
> @@ -581,7 +581,8 @@ iommufd_get_viommu(struct iommufd_ucmd *ucmd, u32 id)
>  }
>  
>  static inline struct iommufd_veventq *
> -iommufd_viommu_find_veventq(struct iommufd_viommu *viommu, u32 type)
> +iommufd_viommu_find_veventq(struct iommufd_viommu *viommu,
> +			    enum iommu_veventq_type type)
>  {
>  	struct iommufd_veventq *veventq, *next;
>  
> -- 
> 2.43.0
> 
