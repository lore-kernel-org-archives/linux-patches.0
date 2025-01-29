Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1FA1DA0E0
	for <patches@lists.linux.dev>; Wed, 29 Jan 2025 12:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738153759; cv=none; b=cz/wOr4Mmv9klr7U/Wk9+TE4n6HEomtu07dhb5Nc3kwCbT1fwW73y5AP+RbZ+2DM4Yma8Xrnb3CVtuF82S/zwwI11xfMHF6mR4utVQvYGdXJP8VuzoNmpwqlqqGnH2vNG3FdnXnvv/LVGSJPk0ldnuLXMyDop4mNVT9wiMiEZME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738153759; c=relaxed/simple;
	bh=aGlAAuEIVLY1trq7D4Y9/0tyfynruVWNn7IwhthU0vc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZX4682JxTtZKKRIfDG5lRBECk9T3U9SeEpYRgeOLbfFyWiWG3piDv2moidAeCQrKD5J+pVSa11yyKP6iHh5FsPCJ7Tg2a/YgGamgyMQZrOiEphHD836WfM2ydVhvBmJmyoeY76+04yI1/HJqWiIUMi4aybMU+nt8m0GYSBYIt9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EGV4Qk8e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EGV4Qk8e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738153756;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z2rZzWmBPUWvjcNF+Tp2W7jWB2lbA7lN2MnSH0V5dqM=;
	b=EGV4Qk8ehTO8IFvb0O0pkB81nogWzMaZkdxmm0XPSBSxZXk9ceZFp4rHBSwOc9NSfrCvkW
	adM6Z4dZ5q3kEDHkG1QWFe6woBB5wQoEuhG7Ku5Ts5hpzc0Z39bmvYTf9ednnAN7VCeHrY
	4SiqWmQ87YJJlnZlKCfNLHktetU/4OM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-a32qgFs5Pk2FqlxiIbrCuw-1; Wed, 29 Jan 2025 07:29:15 -0500
X-MC-Unique: a32qgFs5Pk2FqlxiIbrCuw-1
X-Mimecast-MFC-AGG-ID: a32qgFs5Pk2FqlxiIbrCuw
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43621907030so52369905e9.1
        for <patches@lists.linux.dev>; Wed, 29 Jan 2025 04:29:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738153754; x=1738758554;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z2rZzWmBPUWvjcNF+Tp2W7jWB2lbA7lN2MnSH0V5dqM=;
        b=TXWKHk7r2Ljslp7fakdqWcfCqYcD+nwpgq0pba3LlO0ut/xuOVTnIwpYfI17Byur6T
         RvYcWCi4T15RTnOcyi1xhOQV5W1SF0Tb17zA565ig9UXjATPIi4QPS1xNLKE2WGBtCfz
         6KKcOW++xTJ0nKME2U9Mzjdsv2UsclLW+mXCGzbm9D059Gg4zd8YTHi88fp2nZQbSla0
         zk/+hxeYAZNi4Wpg63eJjDsCPMbtEdE2xVkiLXEFKghMnzSi2ZqADr7ADTV0rBDB9+e5
         7x2RZzKOFAKVASsT4RrVJ7CYI2ajbKBhNKguWNIX9kiStY9W6nDJV0PMp+Fdu7+CXlYR
         A85Q==
X-Forwarded-Encrypted: i=1; AJvYcCXw45DGIqnZ+ccBezsLY898KqG9Nlz+e8wHaVFO0Bwxgu7NRv2w1Pi0aYHL8d/3WsicRod+ZOx3@lists.linux.dev
X-Gm-Message-State: AOJu0YxalITTy7LmPyjs+oEt8+d8LLbc85SHWrMRkHD+QN5Y8H8B8IQc
	lXXtZkiSoHoqUv2ZZxFx5hBnIocevQOS4cu2bnnBndStfiS8HNHTwVrW3b9CUSAAAKsxuUoYvDq
	WZtsnzqfoxlc3RyKPUHqnJyevZrdMSxgO3LNKDsNnFBjQQgKYYbooy+k=
X-Gm-Gg: ASbGncs5WfKwXl33wCnc+uEgPUC32ldrTpYjXrWC/ja0IDmoZBkqPikvqiI/YmDCmCl
	K7jcGBhov3KgygE/e+X5o4eBqLnBFHyF2puzKUnmiR+g1HogdWX8ulLI8xR/4AhW0IUQCSNytAz
	fWyX7E5+8RhiROrGsVwR8yhgEAzUOHaVxikJR4gJ+0cPLD5TkD84CsKlGWYWGl9cKu/wOrn3+XM
	xAxoaWLS/T23yHlRm3R/5q527IIpaBDVIYsFkY0GRd8PiTnKIwRIYoTysR9zMu8997wsa2SPWQm
	c3Wi41hXvp7NdeiAWHAJ87RQnDisAOCNVjYpa7Mum7yXmVdj2FmS
X-Received: by 2002:a05:6000:2a6:b0:38c:2745:2df3 with SMTP id ffacd0b85a97d-38c51e95dc8mr2661448f8f.37.1738153754451;
        Wed, 29 Jan 2025 04:29:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEd8a98Fk4FsyLzo/fsw4POBiKHb+ykWAZ+mPPkOyJLd/auzYk5opYB2Di0YY/K4rHi8Qvhrw==
X-Received: by 2002:a05:6000:2a6:b0:38c:2745:2df3 with SMTP id ffacd0b85a97d-38c51e95dc8mr2661397f8f.37.1738153754034;
        Wed, 29 Jan 2025 04:29:14 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438d7aa296esm34288705e9.1.2025.01.29.04.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 04:29:13 -0800 (PST)
Message-ID: <94a6414e-d047-41c7-b740-4b57fae0ebbb@redhat.com>
Date: Wed, 29 Jan 2025 13:29:10 +0100
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
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, will@kernel.org,
 robin.murphy@arm.com, kevin.tian@intel.com, tglx@linutronix.de,
 maz@kernel.org, alex.williamson@redhat.com, joro@8bytes.org,
 shuah@kernel.org, reinette.chatre@intel.com, yebin10@huawei.com,
 apatel@ventanamicro.com, shivamurthy.shastri@linutronix.de,
 bhelgaas@google.com, anna-maria@linutronix.de, yury.norov@gmail.com,
 nipun.gupta@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
 jean-philippe@linaro.org, mdf@kernel.org, mshavit@google.com,
 shameerali.kolothum.thodi@huawei.com, smostafa@google.com, ddutile@redhat.com
References: <cover.1736550979.git.nicolinc@nvidia.com>
 <9914f9e6b32d49f74ace2200fd50583def9f15f6.1736550979.git.nicolinc@nvidia.com>
 <787fd89b-fbc0-4fd5-a1af-63dfddf13435@redhat.com>
 <20250123181657.GT5556@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250123181657.GT5556@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UfkZD0Sf_IlvLiHDyY5_XqdCFYue9hfY9JPdFnLljPE_1738153754
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jason,


On 1/23/25 7:16 PM, Jason Gunthorpe wrote:
> On Thu, Jan 23, 2025 at 06:10:47PM +0100, Eric Auger wrote:
>> Hi,
>>
>>
>> On 1/11/25 4:32 AM, Nicolin Chen wrote:
>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>>
>>> SW_MSI supports IOMMU to translate an MSI message before the MSI message
>>> is delivered to the interrupt controller. On such systems the iommu_domain
>>> must have a translation for the MSI message for interrupts to work.
>>>
>>> The IRQ subsystem will call into IOMMU to request that a physical page be
>>> setup to receive MSI message, and the IOMMU then sets an IOVA that maps to
>>> that physical page. Ultimately the IOVA is programmed into the device via
>>> the msi_msg.
>>>
>>> Generalize this to allow the iommu_domain owner to provide its own
>>> implementation of this mapping. Add a function pointer to struct
>>> iommu_domain to allow the domain owner to provide an implementation.
>>>
>>> Have dma-iommu supply its implementation for IOMMU_DOMAIN_DMA types during
>>> the iommu_get_dma_cookie() path. For IOMMU_DOMAIN_UNMANAGED types used by
>>> VFIO (and iommufd for now), have the same iommu_dma_sw_msi set as well in
>>> the iommu_get_msi_cookie() path.
>>>
>>> Hold the group mutex while in iommu_dma_prepare_msi() to ensure the domain
>>> doesn't change or become freed while running. Races with IRQ operations
>>> from VFIO and domain changes from iommufd are possible here.
>> this was my question in previous comments
> Ah, well there is the answer :)
>
>>> Rreplace the msi_prepare_lock with a lockdep assertion for the group mutex
>> Replace
>>> as documentation. For the dma_iommu.c each iommu_domain unique to a
>> is?
>>> group.
> Yes
>
> Replace the msi_prepare_lock with a lockdep assertion for the group mutex
> as documentation. For the dmau_iommu.c each iommu_domain is unique to a
> group.
>
>>> @@ -443,6 +449,9 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
>>>  	struct iommu_dma_cookie *cookie = domain->iova_cookie;
>>>  	struct iommu_dma_msi_page *msi, *tmp;
>>>  
>>> +	if (domain->sw_msi != iommu_dma_sw_msi)
>>> +		return;
>>> +
>> I don't get the above check.
> It is because of this:
>
> void iommu_domain_free(struct iommu_domain *domain)
> {
> 	if (domain->type == IOMMU_DOMAIN_SVA)
> 		mmdrop(domain->mm);
> 	iommu_put_dma_cookie(domain);
>
> iommufd may be using domain->sw_msi so iommu_put_dma_cookie() needs to
> be a NOP. Also, later we move cookie into a union so it is not
> reliably NULL anymore.
OK
>
>> The comment says this is also called for a
>> cookie prepared with iommu_get_dma_cookie(). Don't you need to do some
>> cleanup for this latter?
> That seems seems OK, only two places set domain->iova_cookie:
>
> int iommu_get_dma_cookie(struct iommu_domain *domain)
> {
> 	domain->iova_cookie = cookie_alloc(IOMMU_DMA_IOVA_COOKIE);
> 	iommu_domain_set_sw_msi(domain, iommu_dma_sw_msi);
>
> and
>
> int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
> {
> 	domain->iova_cookie = cookie;
> 	iommu_domain_set_sw_msi(domain, iommu_dma_sw_msi);
>
> So (domain->sw_msi == iommu_dma_sw_msi) in iommu_put_dma_cookie() for
> both cases..
makes sense.

Thanks

Eric
>
> Jason
>

