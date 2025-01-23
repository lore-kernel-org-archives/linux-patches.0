Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0DF13E03A
	for <patches@lists.linux.dev>; Thu, 23 Jan 2025 17:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737652261; cv=none; b=c+0wz7QQIOX8B4qKq3LgUMGvWzU1wbvHhKPJaCCSGxcHCZuma18U3R8Yo6157g3j7qarL7WSIWJtLwMulD7JP9q3gpOCpIZ4xe+bynJncOuQf9PVP/NGB1USxZOJiY85CHdIuPJwUG5j1S+5SNuquvG77VVIPHqYUbistJ6HAiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737652261; c=relaxed/simple;
	bh=So1bT6v/8IBUYr9O0B8Tc8G+IQCBnuKe6Hrn1SqQMRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QpC995XKnPGP+O6nccm1lRZ2WA6zCr6L/Sh7nOz01dzNCWsqSMgIOHWc3+ch/kOdYl7NDCmlF5S+rBPoFJ61vZ3V5S8gXGTgc539RC4WJxM+EEMUeIkswcJa1mzjP8v8Yy+bNw3yh6kzhhs16/HB5WJ0GNCV9Nqrx9/SJVgttLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NToe/0Ou; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NToe/0Ou"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737652257;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f2lz1JhxCiAQPWfDUtfyCfkikpyW82hyEvi1Or2PPgU=;
	b=NToe/0OuIXlIkeO0rD1Zd9FJtxZrD4RZJxHJlukMl2xM0rSbTyVpOv58JaZGPQNw9zbwFr
	B786fanhgOQqLdRUjnLP5yFFq4DQ29PCvWbvfmRVuRzeW1Au0uEhZopT1C2N1/qnr+G/zb
	BqXt3WcKH1LikY1LSYsKGIryq32e5c4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-pCTQjhaZMP-XxWZXD6fPPQ-1; Thu, 23 Jan 2025 12:10:56 -0500
X-MC-Unique: pCTQjhaZMP-XxWZXD6fPPQ-1
X-Mimecast-MFC-AGG-ID: pCTQjhaZMP-XxWZXD6fPPQ
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38634103b0dso663172f8f.2
        for <patches@lists.linux.dev>; Thu, 23 Jan 2025 09:10:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737652255; x=1738257055;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f2lz1JhxCiAQPWfDUtfyCfkikpyW82hyEvi1Or2PPgU=;
        b=KrKL6YCxZ5RX+mtCWIQAr8ALXFjVUgABMofI5D7SVcpK0KCGWuyCTbdfV7gIj1IaX1
         3GzGyxTrX+8Ik8CC3dsXKH4lGZFHOwpH6HCKPJXGnqhEzMOdYIf00NAWIk1ENJfnYbMU
         hbEVLssVwldIphT4ZES5hCNeTeOxosgU11qcZekId1OkggKAFAR/Z9zhxJ5BeWZe8kyA
         TRBXACBjjooreeNCCeEFthlEjJfdYqjZbhoptUUbQpQBELVu7d0NxTht2ISz4KH9Qtoc
         zf5L85F8epy38UVnRC43OCJlFZzoNcUVS8tpoXjqCS5XhSsuE7EDPvUu26v0lYSrN93h
         qjRw==
X-Forwarded-Encrypted: i=1; AJvYcCWM5kW785P774OlvX9c3b4K7e3xG/1MJ+Wm/DJ0dUKZrkqT6z33ODLpPB04fUdHU3Sk4NHKvjcI@lists.linux.dev
X-Gm-Message-State: AOJu0Yxbksl7Zfj48tR80szvuelecgQddiyJTEvTn7sWn2yAoL228mUS
	6MECSv+50X1Fni+tP4dQ8T5WSbBb+C8Bd0GAp1wAgnpF1wwK6EWF1v7Zqrenh2FBzjb1VhhK8i5
	S9xlmKrSlU6br004T0gDyXzzbEm3O2O564kSwZ6ufSiDWBFDlzHooYg8=
X-Gm-Gg: ASbGncsKEPpgxor8u7nKAUkJmwtQ44iFebjDmxDa0ZdCrs/E54/6EZIPRVotkbOS5lL
	1p3cgLrO1WuERKFm6cktYD78dGJrxDiueK9aeK8vTkMif/p+LECw3P6/ynUapnHVmGQlLYpX1qx
	0Jj+2TTPdORgANHC8MEfpiBhAT2QqoVR0twrZQvcezT1AEQ0JyihfWsNKjY3GEcxCLzMIDMxHB0
	Z6e9h+4FA9A8KxouBRYoL30HBe97etGkoQ5K4rEU0FYQiqCsx56iVhZumXGb6FNDjG9exK39pew
	3iETobvTQJ+nrhkqtJ5PFOKYrfkT2oDGqCY5+ObwLg==
X-Received: by 2002:a5d:6da4:0:b0:38b:e32a:10a6 with SMTP id ffacd0b85a97d-38bf57a9932mr29480875f8f.41.1737652255081;
        Thu, 23 Jan 2025 09:10:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGK/5MgTOgXIu9+Lg1LjrltVZkaY8JHUprLufh35bjJjxTwBW+dXwhnf8hS5iSt70eBgqDsvw==
X-Received: by 2002:a5d:6da4:0:b0:38b:e32a:10a6 with SMTP id ffacd0b85a97d-38bf57a9932mr29480826f8f.41.1737652254632;
        Thu, 23 Jan 2025 09:10:54 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b31d9a39sm67975795e9.31.2025.01.23.09.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 09:10:53 -0800 (PST)
Message-ID: <1b48e138-3134-442a-9796-e3a33b106221@redhat.com>
Date: Thu, 23 Jan 2025 18:10:48 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 01/13] genirq/msi: Store the IOMMU IOVA directly in
 msi_desc instead of iommu_cookie
To: Nicolin Chen <nicolinc@nvidia.com>, will@kernel.org,
 robin.murphy@arm.com, jgg@nvidia.com, kevin.tian@intel.com,
 tglx@linutronix.de, maz@kernel.org, alex.williamson@redhat.com
Cc: joro@8bytes.org, shuah@kernel.org, reinette.chatre@intel.com,
 yebin10@huawei.com, apatel@ventanamicro.com,
 shivamurthy.shastri@linutronix.de, bhelgaas@google.com,
 anna-maria@linutronix.de, yury.norov@gmail.com, nipun.gupta@amd.com,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
 jean-philippe@linaro.org, mdf@kernel.org, mshavit@google.com,
 shameerali.kolothum.thodi@huawei.com, smostafa@google.com, ddutile@redhat.com
References: <cover.1736550979.git.nicolinc@nvidia.com>
 <671b2128c193fc9ac9af0f4add96f85a785f513a.1736550979.git.nicolinc@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <671b2128c193fc9ac9af0f4add96f85a785f513a.1736550979.git.nicolinc@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u-I0dv4zAfr2E-_pNZHVfXN9ofilhBDUXEaVqM1jBuo_1737652255
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


Hi Nicolin,

On 1/11/25 4:32 AM, Nicolin Chen wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
>
> All the iommu cases simply want to override the MSI page's address with
those which translate MSIs
> the IOVA that was mapped through the iommu. This doesn't need a cookie
> pointer, we just need to store the IOVA and its page size in the msi_desc.
>
> Instead provide msi_desc_set_iommu_msi_iova() which allows the IOMMU side
> to specify the IOVA that the MSI page is placed during
> iommu_dma_prepare(). This is stored in the msi_desc and then
iommu_dma_prepare_msi()
> iommu_dma_compose_msi_msg() is a simple inline that sets address_hi/lo.
>
> The next patch will correct the naming.
>
> This is done because we cannot correctly lock access to group->domain in
> the atomic context that iommu_dma_compose_msi_msg() is called under. Today
> the locking miss is tolerable because dma_iommu.c operates under an
> assumption that the domain does not change while a driver is probed.
>
> However iommufd now permits the domain to change while the driver is
> probed and VFIO userspace can create races with IRQ changes calling
> iommu_dma_prepare/compose_msi_msg() and changing/freeing the iommu_domain.
and is it safe in iommu_dma_prepare_msi()?
>
> Removing the pointer, and critically, the call to
> iommu_get_domain_for_dev() during compose resolves this race.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  include/linux/iommu.h     |  6 ------
>  include/linux/msi.h       | 45 +++++++++++++++++++++++----------------
>  drivers/iommu/dma-iommu.c | 30 +++++---------------------
>  3 files changed, 32 insertions(+), 49 deletions(-)
>
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 318d27841130..3a4215966c1b 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -1513,7 +1513,6 @@ static inline void iommu_debugfs_setup(void) {}
>  int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base);
>  
>  int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr);
> -void iommu_dma_compose_msi_msg(struct msi_desc *desc, struct msi_msg *msg);
>  
>  #else /* CONFIG_IOMMU_DMA */
>  
> @@ -1529,11 +1528,6 @@ static inline int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_a
>  {
>  	return 0;
>  }
> -
> -static inline void iommu_dma_compose_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
> -{
> -}
> -
>  #endif	/* CONFIG_IOMMU_DMA */
>  
>  /*
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index b10093c4d00e..d442b4a69d56 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -184,7 +184,8 @@ struct msi_desc {
>  	struct msi_msg			msg;
>  	struct irq_affinity_desc	*affinity;
>  #ifdef CONFIG_IRQ_MSI_IOMMU
> -	const void			*iommu_cookie;
you may add kernel doc comments above
> +	u64				iommu_msi_iova : 58;
> +	u64				iommu_msi_page_shift : 6;
>  #endif
>  #ifdef CONFIG_SYSFS
>  	struct device_attribute		*sysfs_attrs;
> @@ -285,28 +286,36 @@ struct msi_desc *msi_next_desc(struct device *dev, unsigned int domid,
>  
>  #define msi_desc_to_dev(desc)		((desc)->dev)
>  
> -#ifdef CONFIG_IRQ_MSI_IOMMU
> -static inline const void *msi_desc_get_iommu_cookie(struct msi_desc *desc)
> -{
> -	return desc->iommu_cookie;
> -}
> -
> -static inline void msi_desc_set_iommu_cookie(struct msi_desc *desc,
> -					     const void *iommu_cookie)
> +static inline void msi_desc_set_iommu_msi_iova(struct msi_desc *desc,
> +					       u64 msi_iova,
> +					       unsigned int page_shift)
>  {
> -	desc->iommu_cookie = iommu_cookie;
> -}
> -#else
> -static inline const void *msi_desc_get_iommu_cookie(struct msi_desc *desc)
> -{
> -	return NULL;
> +#ifdef CONFIG_IRQ_MSI_IOMMU
> +	desc->iommu_msi_iova = msi_iova >> page_shift;
> +	desc->iommu_msi_page_shift = page_shift;
> +#endif
>  }
>  
> -static inline void msi_desc_set_iommu_cookie(struct msi_desc *desc,
> -					     const void *iommu_cookie)
> +/**
> + * iommu_dma_compose_msi_msg() - Apply translation to an MSI message
> + * @desc: MSI descriptor prepared by iommu_dma_prepare_msi()
> + * @msg: MSI message containing target physical address
> + */
> +static inline void iommu_dma_compose_msi_msg(struct msi_desc *desc,
> +					     struct msi_msg *msg)
>  {
> -}
> +#ifdef CONFIG_IRQ_MSI_IOMMU
> +	if (desc->iommu_msi_page_shift) {
> +		u64 msi_iova = desc->iommu_msi_iova
> +			       << desc->iommu_msi_page_shift;
> +
> +		msg->address_hi = upper_32_bits(msi_iova);
> +		msg->address_lo = lower_32_bits(msi_iova) |
> +				  (msg->address_lo &
> +				   ((1 << desc->iommu_msi_page_shift) - 1));
> +	}
>  #endif
> +}
>  
>  int msi_domain_insert_msi_desc(struct device *dev, unsigned int domid,
>  			       struct msi_desc *init_desc);
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 2a9fa0c8cc00..bf91e014d179 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -1815,7 +1815,7 @@ int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
>  	static DEFINE_MUTEX(msi_prepare_lock); /* see below */
>  
>  	if (!domain || !domain->iova_cookie) {
> -		desc->iommu_cookie = NULL;
> +		msi_desc_set_iommu_msi_iova(desc, 0, 0);
>  		return 0;
>  	}
>  
> @@ -1827,33 +1827,13 @@ int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
>  	mutex_lock(&msi_prepare_lock);
>  	msi_page = iommu_dma_get_msi_page(dev, msi_addr, domain);
>  	mutex_unlock(&msi_prepare_lock);
> -
> -	msi_desc_set_iommu_cookie(desc, msi_page);
> -
>  	if (!msi_page)
>  		return -ENOMEM;
> -	return 0;
> -}
>  
> -/**
> - * iommu_dma_compose_msi_msg() - Apply translation to an MSI message
> - * @desc: MSI descriptor prepared by iommu_dma_prepare_msi()
> - * @msg: MSI message containing target physical address
> - */
> -void iommu_dma_compose_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
> -{
> -	struct device *dev = msi_desc_to_dev(desc);
> -	const struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
> -	const struct iommu_dma_msi_page *msi_page;
> -
> -	msi_page = msi_desc_get_iommu_cookie(desc);
> -
> -	if (!domain || !domain->iova_cookie || WARN_ON(!msi_page))
> -		return;
> -
> -	msg->address_hi = upper_32_bits(msi_page->iova);
> -	msg->address_lo &= cookie_msi_granule(domain->iova_cookie) - 1;
> -	msg->address_lo += lower_32_bits(msi_page->iova);
> +	msi_desc_set_iommu_msi_iova(
> +		desc, msi_page->iova,
> +		ilog2(cookie_msi_granule(domain->iova_cookie)));
> +	return 0;
>  }
>  
>  static int iommu_dma_init(void)

