Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423DF14A4FB
	for <patches@lists.linux.dev>; Thu, 23 Jan 2025 17:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737652259; cv=none; b=cV6CXiJOqXPfDqRE8JoB9g1RygF5RIcXTw9o8MLi/E6KZIJR8VFgWYZSVeRUNkSIpXmOVXm56FC88T/00D3EAKY++S3sMqMDPpw//jcXMwcuV//RzbnI//IOqAy/Xu6Nr/S6THFq+xbTT8Y/t7a+R4Rd4ISgPUOzkT2FMPPHoFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737652259; c=relaxed/simple;
	bh=T8q34VTWnC53A/omtKXw33TuIrilLgKAMYPU65cm/Qk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PdAnrzhiR7wkJRzp6ZKDwhhHknK3FAGpOA3+SGEVqoXKTaR70ouXzT8yvoSXVyNy3aMJzrys5IP1SHllLtx3LLSWNCXbcbC0uIF6uwV9ifO9PEafPHNymgPnKNtTuwQ6gdzVJPuOj2v+govy4vtsRCwKpWApucM8iQOZvgH848c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MBY+mDAP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MBY+mDAP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737652256;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jAh/e6F0HEaFnHy5OVzmfXhKo/WXlBkiKIGsXte00qk=;
	b=MBY+mDAP2k/Q3mzUyt3ERQL5bH5KEjf/lPa1d2n7eTeeFCMKbVS0DguaC90SPqlybgVArl
	WQXBBNjOzIPVqbM0AAF9csFHUEX/S9+H24SB+CZ6m7MwchCdDXg5JVs8b0kWtXBmyEcW9n
	W/YhaONfe2f1V9oj/RYiWMu04dzsYpI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-yLmPE9llOO-ouKz4sdt-vA-1; Thu, 23 Jan 2025 12:10:53 -0500
X-MC-Unique: yLmPE9llOO-ouKz4sdt-vA-1
X-Mimecast-MFC-AGG-ID: yLmPE9llOO-ouKz4sdt-vA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4362f893bfaso6813665e9.1
        for <patches@lists.linux.dev>; Thu, 23 Jan 2025 09:10:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737652252; x=1738257052;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jAh/e6F0HEaFnHy5OVzmfXhKo/WXlBkiKIGsXte00qk=;
        b=NLBxVq7hz4siZtJFOvTgbm3vXYkmhu19vbg1oP4/z8VZXxVbEAG6hq0vdv/TFSkpte
         bLbJIXJgtU8qcXY9guHBpOyl8xGT/EM9tP5wFpRDK4XQWaMvCUSwHKX2qaPXiDZN9s81
         CnT1uBvU9SychEaSVRuWaEOvzDydfC7nz8vwa3GTpnpoonmyRIPgJrV7vNT8sBNBlRXl
         SA3HX4UDjPsbpfbd/NprMMMaZvkDN2fyBvO8JXXGMJyCLpZIIQowP54syv331GAF/C0u
         i4pxmn+94zBNdPAw5m+tW7gBGifI1OtGKPqM0oT4ERb3toNW0jBQrWtpdAp8lliazqNw
         hE8A==
X-Forwarded-Encrypted: i=1; AJvYcCVWSo/IJgRpO5Wi2PdRNacfxu0EdILifB5KlKUg9srEg0mLrR+im7Cg+TBCNhAB/HT/ft+GgBeq@lists.linux.dev
X-Gm-Message-State: AOJu0YziWYz+nJhqOdzMpCNDqYWx1TwCdp7bdCTxLlS8TP+9P0f0c7O8
	YPEkfaFWUp1T99WJECIkyBlVNTW/yNjvXR1lO7x4E/i9uD/hyPazyjLk8ruxb+GN5JIlyphcH9Z
	30Lg8gaVLoom2gNqMpL8/s8K4v3XVIamThk1UokpU55DalFTgvXXsyvg=
X-Gm-Gg: ASbGncttmYJEThXjkcpQpEi360VDHdkYZ3HXz9E16ULzX2CyRF3pmDpNidwre7IKTg3
	vp6nnJe/6laJ5cEoZ3to7mgBUUeC4LsUKyLDIOTW6b8Im/C0y8Yi9TYvOYqpQBYqb8bs5lv4fof
	V3QbVIyPmf4EMfGyiTnXsuFC4dYjB7p1tBQvaXHb6oj6qSHpF2qV9a/Kc7EkeER6RBYNOr9Fgk+
	7ClSnhG1OViIbNxWgfYZuqQWHQxo7dY6quqgbN2Px5AROlF2ORth7WIo/mmviFV3t2G9ukvhuz4
	sCrPbViLQ8S15ktFkqriXdEGpb4ySvm6hBwTNl6t1Q==
X-Received: by 2002:a05:600c:3d96:b0:434:9dfe:20e6 with SMTP id 5b1f17b1804b1-43891439dfdmr245029605e9.23.1737652251741;
        Thu, 23 Jan 2025 09:10:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGkHdqQ1Du/TgX49VGOUPaX03Xnk0FckQu07hyXzCGV6GJ69vec6Iv7VJ8KrVMowrhApHUZ3w==
X-Received: by 2002:a05:600c:3d96:b0:434:9dfe:20e6 with SMTP id 5b1f17b1804b1-43891439dfdmr245029225e9.23.1737652251235;
        Thu, 23 Jan 2025 09:10:51 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b31d9a39sm67975795e9.31.2025.01.23.09.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 09:10:50 -0800 (PST)
Message-ID: <787fd89b-fbc0-4fd5-a1af-63dfddf13435@redhat.com>
Date: Thu, 23 Jan 2025 18:10:47 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 03/13] iommu: Make iommu_dma_prepare_msi() into a
 generic operation
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
 <9914f9e6b32d49f74ace2200fd50583def9f15f6.1736550979.git.nicolinc@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <9914f9e6b32d49f74ace2200fd50583def9f15f6.1736550979.git.nicolinc@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GL8UG4qund9TtH9h_sw-8xnVxZt45kxyG1PjWeUASyU_1737652252
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,


On 1/11/25 4:32 AM, Nicolin Chen wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
>
> SW_MSI supports IOMMU to translate an MSI message before the MSI message
> is delivered to the interrupt controller. On such systems the iommu_domain
> must have a translation for the MSI message for interrupts to work.
>
> The IRQ subsystem will call into IOMMU to request that a physical page be
> setup to receive MSI message, and the IOMMU then sets an IOVA that maps to
> that physical page. Ultimately the IOVA is programmed into the device via
> the msi_msg.
>
> Generalize this to allow the iommu_domain owner to provide its own
> implementation of this mapping. Add a function pointer to struct
> iommu_domain to allow the domain owner to provide an implementation.
>
> Have dma-iommu supply its implementation for IOMMU_DOMAIN_DMA types during
> the iommu_get_dma_cookie() path. For IOMMU_DOMAIN_UNMANAGED types used by
> VFIO (and iommufd for now), have the same iommu_dma_sw_msi set as well in
> the iommu_get_msi_cookie() path.
>
> Hold the group mutex while in iommu_dma_prepare_msi() to ensure the domain
> doesn't change or become freed while running. Races with IRQ operations
> from VFIO and domain changes from iommufd are possible here.
this was my question in previous comments
>
> Rreplace the msi_prepare_lock with a lockdep assertion for the group mutex
Replace
> as documentation. For the dma_iommu.c each iommu_domain unique to a
is?
> group.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> [nicolinc: move iommu_domain_set_sw_msi() from iommu_dma_init_domain() to
>  iommu_dma_init_domain(); add in iommu_put_dma_cookie() an sw_msi test]
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  include/linux/iommu.h     | 44 ++++++++++++++++++++++++++-------------
>  drivers/iommu/dma-iommu.c | 33 +++++++++++++----------------
>  drivers/iommu/iommu.c     | 29 ++++++++++++++++++++++++++
>  3 files changed, 73 insertions(+), 33 deletions(-)
>
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 3a4215966c1b..423fdfa6b3bb 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -44,6 +44,8 @@ struct iommu_dma_cookie;
>  struct iommu_fault_param;
>  struct iommufd_ctx;
>  struct iommufd_viommu;
> +struct msi_desc;
> +struct msi_msg;
>  
>  #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
>  #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
> @@ -216,6 +218,12 @@ struct iommu_domain {
>  	struct iommu_domain_geometry geometry;
>  	struct iommu_dma_cookie *iova_cookie;
>  	int (*iopf_handler)(struct iopf_group *group);
> +
> +#if IS_ENABLED(CONFIG_IRQ_MSI_IOMMU)
> +	int (*sw_msi)(struct iommu_domain *domain, struct msi_desc *desc,
> +		      phys_addr_t msi_addr);
> +#endif
> +
>  	void *fault_data;
>  	union {
>  		struct {
> @@ -234,6 +242,16 @@ struct iommu_domain {
>  	};
>  };
>  
> +static inline void iommu_domain_set_sw_msi(
> +	struct iommu_domain *domain,
> +	int (*sw_msi)(struct iommu_domain *domain, struct msi_desc *desc,
> +		      phys_addr_t msi_addr))
> +{
> +#if IS_ENABLED(CONFIG_IRQ_MSI_IOMMU)
> +	domain->sw_msi = sw_msi;
> +#endif
> +}
> +
>  static inline bool iommu_is_dma_domain(struct iommu_domain *domain)
>  {
>  	return domain->type & __IOMMU_DOMAIN_DMA_API;
> @@ -1475,6 +1493,18 @@ static inline ioasid_t iommu_alloc_global_pasid(struct device *dev)
>  static inline void iommu_free_global_pasid(ioasid_t pasid) {}
>  #endif /* CONFIG_IOMMU_API */
>  
> +#ifdef CONFIG_IRQ_MSI_IOMMU
> +#ifdef CONFIG_IOMMU_API
> +int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr);
> +#else
> +static inline int iommu_dma_prepare_msi(struct msi_desc *desc,
> +					phys_addr_t msi_addr)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_IOMMU_API */
> +#endif /* CONFIG_IRQ_MSI_IOMMU */
> +
>  #if IS_ENABLED(CONFIG_LOCKDEP) && IS_ENABLED(CONFIG_IOMMU_API)
>  void iommu_group_mutex_assert(struct device *dev);
>  #else
> @@ -1508,26 +1538,12 @@ static inline void iommu_debugfs_setup(void) {}
>  #endif
>  
>  #ifdef CONFIG_IOMMU_DMA
> -#include <linux/msi.h>
> -
>  int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base);
> -
> -int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr);
> -
>  #else /* CONFIG_IOMMU_DMA */
> -
> -struct msi_desc;
> -struct msi_msg;
> -
>  static inline int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
>  {
>  	return -ENODEV;
>  }
> -
> -static inline int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
> -{
> -	return 0;
> -}
>  #endif	/* CONFIG_IOMMU_DMA */
>  
>  /*
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index bf91e014d179..3b58244e6344 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -24,6 +24,7 @@
>  #include <linux/memremap.h>
>  #include <linux/mm.h>
>  #include <linux/mutex.h>
> +#include <linux/msi.h>
>  #include <linux/of_iommu.h>
>  #include <linux/pci.h>
>  #include <linux/scatterlist.h>
> @@ -102,6 +103,9 @@ static int __init iommu_dma_forcedac_setup(char *str)
>  }
>  early_param("iommu.forcedac", iommu_dma_forcedac_setup);
>  
> +static int iommu_dma_sw_msi(struct iommu_domain *domain, struct msi_desc *desc,
> +			    phys_addr_t msi_addr);
> +
>  /* Number of entries per flush queue */
>  #define IOVA_DEFAULT_FQ_SIZE	256
>  #define IOVA_SINGLE_FQ_SIZE	32768
> @@ -398,6 +402,7 @@ int iommu_get_dma_cookie(struct iommu_domain *domain)
>  		return -ENOMEM;
>  
>  	mutex_init(&domain->iova_cookie->mutex);
> +	iommu_domain_set_sw_msi(domain, iommu_dma_sw_msi);
>  	return 0;
>  }
>  
> @@ -429,6 +434,7 @@ int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
>  
>  	cookie->msi_iova = base;
>  	domain->iova_cookie = cookie;
> +	iommu_domain_set_sw_msi(domain, iommu_dma_sw_msi);
>  	return 0;
>  }
>  EXPORT_SYMBOL(iommu_get_msi_cookie);
> @@ -443,6 +449,9 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
>  	struct iommu_dma_cookie *cookie = domain->iova_cookie;
>  	struct iommu_dma_msi_page *msi, *tmp;
>  
> +	if (domain->sw_msi != iommu_dma_sw_msi)
> +		return;
> +
I don't get the above check. The comment says this is also called for a
cookie prepared with iommu_get_dma_cookie(). Don't you need to do some
cleanup for this latter?
>  	if (!cookie)
>  		return;
>  
> @@ -1800,33 +1809,19 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
>  	return NULL;
>  }
>  
> -/**
> - * iommu_dma_prepare_msi() - Map the MSI page in the IOMMU domain
> - * @desc: MSI descriptor, will store the MSI page
> - * @msi_addr: MSI target address to be mapped
> - *
> - * Return: 0 on success or negative error code if the mapping failed.
> - */
> -int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
> +static int iommu_dma_sw_msi(struct iommu_domain *domain, struct msi_desc *desc,
> +			    phys_addr_t msi_addr)
>  {
>  	struct device *dev = msi_desc_to_dev(desc);
> -	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
> -	struct iommu_dma_msi_page *msi_page;
> -	static DEFINE_MUTEX(msi_prepare_lock); /* see below */
> +	const struct iommu_dma_msi_page *msi_page;
>  
> -	if (!domain || !domain->iova_cookie) {
> +	if (!domain->iova_cookie) {
>  		msi_desc_set_iommu_msi_iova(desc, 0, 0);
>  		return 0;
>  	}
>  
> -	/*
> -	 * In fact the whole prepare operation should already be serialised by
> -	 * irq_domain_mutex further up the callchain, but that's pretty subtle
> -	 * on its own, so consider this locking as failsafe documentation...
> -	 */
> -	mutex_lock(&msi_prepare_lock);
> +	iommu_group_mutex_assert(dev);
>  	msi_page = iommu_dma_get_msi_page(dev, msi_addr, domain);
> -	mutex_unlock(&msi_prepare_lock);
>  	if (!msi_page)
>  		return -ENOMEM;
>  
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 599030e1e890..fbbbcdba8a4f 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -3587,3 +3587,32 @@ int iommu_replace_group_handle(struct iommu_group *group,
>  	return ret;
>  }
>  EXPORT_SYMBOL_NS_GPL(iommu_replace_group_handle, "IOMMUFD_INTERNAL");
> +
> +#if IS_ENABLED(CONFIG_IRQ_MSI_IOMMU)
> +/**
> + * iommu_dma_prepare_msi() - Map the MSI page in the IOMMU domain
> + * @desc: MSI descriptor, will store the MSI page
> + * @msi_addr: MSI target address to be mapped
> + *
> + * The implementation of sw_msi() should take msi_addr and map it to
> + * an IOVA in the domain and call msi_desc_set_iommu_msi_iova() with the
> + * mapping information.
> + *
> + * Return: 0 on success or negative error code if the mapping failed.
> + */
> +int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
> +{
> +	struct device *dev = msi_desc_to_dev(desc);
> +	struct iommu_group *group = dev->iommu_group;
> +	int ret = 0;
> +
> +	if (!group)
> +		return 0;
> +
> +	mutex_lock(&group->mutex);
> +	if (group->domain && group->domain->sw_msi)
> +		ret = group->domain->sw_msi(group->domain, desc, msi_addr);
> +	mutex_unlock(&group->mutex);
> +	return ret;
> +}
> +#endif /* CONFIG_IRQ_MSI_IOMMU */
Thanks

Eric

