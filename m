Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99EA14A609
	for <patches@lists.linux.dev>; Thu, 23 Jan 2025 17:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737652266; cv=none; b=DgB56uc0D6TbZ5BdeZXhFsu0M3Ol8EH8ZXypQEZzPNFcTXzHNtQpYg6w4Q3pFjjX9xwXzvCqvDwUwF++JMiB4urLH5TI0MmcwT/Pe/1dVt17GFFS9poonEFZOkh1xEgp2HlUMXuF4cEfZ07LG/b+Z3GCA1ps1aVV30fId0/Zfj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737652266; c=relaxed/simple;
	bh=IElpbLrsOsHo9Fqp9+eo4+iSffumW7TRTtUYq1XiB5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gq2ocEC5DVJZFebuvouB0415WACAl/uDYPXneoZehAZAa5p/LijQ9l7vDsoR//u+2fTmniDoXuVaCn8IGgtl8YOg97sJfSrhPKpLq5eZg9pLzr1KCMOubbT5/+vOMtOpqi2C0tzim2pS2DIVvwiGZEQdovamRnu1JLmVVteyT5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YvL5j7Ib; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YvL5j7Ib"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737652263;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8fOKblc3FZS7ikfIHW19sV5gSa/Sm7uYNFXMWgCbP3w=;
	b=YvL5j7Ibvz00bIfVZNeDZjf7BIQg3bjsSwQCLlxP86YM+D1HSW9Al2D7fwC2DRMIYLiq95
	Jqz+qz/2NzjbeTIzo8sgoe5v0SVixSVIowfx4XGI3qMFYCP32utycgPMyqLWNSpaPJ1AGB
	0LpnkrEQ6Dku0AqeK3WUGUHkrNRrN+o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-mMBiPlPVONCXNBp3evNbEA-1; Thu, 23 Jan 2025 12:11:02 -0500
X-MC-Unique: mMBiPlPVONCXNBp3evNbEA-1
X-Mimecast-MFC-AGG-ID: mMBiPlPVONCXNBp3evNbEA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361efc9d1fso9315645e9.2
        for <patches@lists.linux.dev>; Thu, 23 Jan 2025 09:11:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737652261; x=1738257061;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8fOKblc3FZS7ikfIHW19sV5gSa/Sm7uYNFXMWgCbP3w=;
        b=rZ7HZ+gD6iSgU+TSoC/Xe611uZ6R9cDXqpqvXL8GxslDDZBu3wpViob76/jheI50J7
         TAhchmIs4gjAVAfROyMoY3+JxGCYoYl/Nq9+A68250gJ36dx/LV4ZUpFPTuLUb8tL/ll
         OfegL4Z9YCUwbGlmgFW2r5QSRjJ20A+343dABXzTPx31Lu3qAxZKi2SljHc8cYUHI/6f
         g22LfxYKxinwTz/MqUMqzut7J5zATCfXFj6bqI4JMtc7urddJqrKvrJ4swdjheMhKWPf
         K4IkMCcnWUsWBs4auZOWG4KylqVEPn48tAmJbXmOfpzCo17Ri/EQWJ4Q2HpTP8CrgJdg
         0M+g==
X-Forwarded-Encrypted: i=1; AJvYcCV7DS/1PAJ+Rr5rtor+scAL+8BKMfSPU/8JGpmkrDwWKWmpOY2TfFk7UC08/49mbLIrv7tqnwdd@lists.linux.dev
X-Gm-Message-State: AOJu0YxxHkgd7QKaLftrkQcN6kYJYXd+oNSodPrh8hPA+2HTSYlVOO8u
	q7CE/e2VtjGqMRJ1tIxNPy61548qCLS3/oFkucQUl3hcuVI6CP309ye/5aVQ4H86BfH88Sf3zZZ
	MTtnx3b+wKt2TIosCNiRE2nFojGP4x3KnmusiP0Xz5UJS29fQhcUQxYM=
X-Gm-Gg: ASbGncsCi9VixUqjf0gnxR5Q4C/pJwPVPt1NgveJp9twXwjbbq4Z3OemSLBjtm7zPP7
	uuwjAw5Eq7tTFFhzqyQ+wpofemq8TEqHj2RwkBR8q0E3jQRc5VbOnwyhresB1j8SjFyGvTFZBnu
	2VJZOgyDSgvJo3lvGTgYenvODrCWD4YEp1FDsCMv4FEL8pus4NF4cz5fNRkNsyTvvEeKKZ5c+E7
	AfhX2i7MobfO8jLxW0Etg1nvK5PdRTEDzgG08ibD4Jo1kDuCBv31RuPaHUV3D32Wpn4BbDbv8j/
	wu4GSMWTzBR+fTdyFyPsAENN3hGLNzMnILFbDTTF3g==
X-Received: by 2002:a05:600c:c87:b0:434:ff30:a159 with SMTP id 5b1f17b1804b1-438912d54b1mr280615845e9.0.1737652261101;
        Thu, 23 Jan 2025 09:11:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEve2JNXs/aOVwoBIaoWNaT3prodhge18rjmwvoIe2mZAtYGf3exTDDbW8BsosdzSW8HiTIkw==
X-Received: by 2002:a05:600c:c87:b0:434:ff30:a159 with SMTP id 5b1f17b1804b1-438912d54b1mr280615385e9.0.1737652260533;
        Thu, 23 Jan 2025 09:11:00 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b31d9a39sm67975795e9.31.2025.01.23.09.10.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 09:10:59 -0800 (PST)
Message-ID: <fa9b443d-e068-41bc-ad03-9f04818c72e0@redhat.com>
Date: Thu, 23 Jan 2025 18:10:54 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 02/13] genirq/msi: Rename
 iommu_dma_compose_msi_msg() to msi_msg_set_msi_addr()
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
 <242034456c0bfcd7ecf75cb29d8e5c99db0675d6.1736550979.git.nicolinc@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <242034456c0bfcd7ecf75cb29d8e5c99db0675d6.1736550979.git.nicolinc@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Tb7X8xCiAoxPSnjEREfuKSejU4IRCwXaqRbqv8nbCj4_1737652261
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit




On 1/11/25 4:32 AM, Nicolin Chen wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
>
> The new function is used to take in a u64 MSI address and store it in the
> msi_msg. If the iommu has provided an alternative address then that is
> replaced instead.
>
> All callers have a tidy u64 already so this also consolidates the repeated
> low/high code into a small helper.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  include/linux/msi.h               | 18 ++++++++----------
>  drivers/irqchip/irq-gic-v2m.c     |  5 +----
>  drivers/irqchip/irq-gic-v3-its.c  | 13 +++----------
>  drivers/irqchip/irq-gic-v3-mbi.c  | 12 ++++--------
>  drivers/irqchip/irq-ls-scfg-msi.c |  5 ++---
>  5 files changed, 18 insertions(+), 35 deletions(-)
>
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index d442b4a69d56..f6369748fc6e 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -296,13 +296,8 @@ static inline void msi_desc_set_iommu_msi_iova(struct msi_desc *desc,
>  #endif
>  }
>  
> -/**
> - * iommu_dma_compose_msi_msg() - Apply translation to an MSI message
> - * @desc: MSI descriptor prepared by iommu_dma_prepare_msi()
> - * @msg: MSI message containing target physical address
> - */
> -static inline void iommu_dma_compose_msi_msg(struct msi_desc *desc,
> -					     struct msi_msg *msg)
> +static inline void msi_msg_set_msi_addr(struct msi_desc *desc,
> +					struct msi_msg *msg, u64 msi_addr)
nit: msi_msg_set_addr(ess) may be enough as the populated fields are
address_lo/hi
>  {
>  #ifdef CONFIG_IRQ_MSI_IOMMU
>  	if (desc->iommu_msi_page_shift) {
> @@ -310,11 +305,14 @@ static inline void iommu_dma_compose_msi_msg(struct msi_desc *desc,
>  			       << desc->iommu_msi_page_shift;
>  
>  		msg->address_hi = upper_32_bits(msi_iova);
> -		msg->address_lo = lower_32_bits(msi_iova) |
> -				  (msg->address_lo &
> -				   ((1 << desc->iommu_msi_page_shift) - 1));
> +		msg->address_lo =
> +			lower_32_bits(msi_iova) |
> +			(msi_addr & ((1 << desc->iommu_msi_page_shift) - 1));
> +		return;
>  	}
>  #endif
> +	msg->address_hi = upper_32_bits(msi_addr);
> +	msg->address_lo = lower_32_bits(msi_addr);
>  }
>  
>  int msi_domain_insert_msi_desc(struct device *dev, unsigned int domid,
> diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
> index be35c5349986..6599c56873ad 100644
> --- a/drivers/irqchip/irq-gic-v2m.c
> +++ b/drivers/irqchip/irq-gic-v2m.c
> @@ -87,9 +87,6 @@ static void gicv2m_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
>  	struct v2m_data *v2m = irq_data_get_irq_chip_data(data);
>  	phys_addr_t addr = gicv2m_get_msi_addr(v2m, data->hwirq);
>  
> -	msg->address_hi = upper_32_bits(addr);
> -	msg->address_lo = lower_32_bits(addr);
> -
>  	if (v2m->flags & GICV2M_GRAVITON_ADDRESS_ONLY)
>  		msg->data = 0;
>  	else
> @@ -97,7 +94,7 @@ static void gicv2m_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
>  	if (v2m->flags & GICV2M_NEEDS_SPI_OFFSET)
>  		msg->data -= v2m->spi_offset;
>  
> -	iommu_dma_compose_msi_msg(irq_data_get_msi_desc(data), msg);
> +	msi_msg_set_msi_addr(irq_data_get_msi_desc(data), msg, addr);
>  }
>  
>  static struct irq_chip gicv2m_irq_chip = {
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 92244cfa0464..8c3ab7b471ca 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -1809,17 +1809,10 @@ static u64 its_irq_get_msi_base(struct its_device *its_dev)
>  static void its_irq_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
>  {
>  	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> -	struct its_node *its;
> -	u64 addr;
> -
> -	its = its_dev->its;
> -	addr = its->get_msi_base(its_dev);
> -
> -	msg->address_lo		= lower_32_bits(addr);
> -	msg->address_hi		= upper_32_bits(addr);
> -	msg->data		= its_get_event_id(d);
>  
> -	iommu_dma_compose_msi_msg(irq_data_get_msi_desc(d), msg);
> +	msg->data = its_get_event_id(d);
> +	msi_msg_set_msi_addr(irq_data_get_msi_desc(d), msg,
> +			     its_dev->its->get_msi_base(its_dev));
>  }
>  
>  static int its_irq_set_irqchip_state(struct irq_data *d,
> diff --git a/drivers/irqchip/irq-gic-v3-mbi.c b/drivers/irqchip/irq-gic-v3-mbi.c
> index 3fe870f8ee17..513479da9ee3 100644
> --- a/drivers/irqchip/irq-gic-v3-mbi.c
> +++ b/drivers/irqchip/irq-gic-v3-mbi.c
> @@ -147,22 +147,18 @@ static const struct irq_domain_ops mbi_domain_ops = {
>  
>  static void mbi_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
>  {
> -	msg[0].address_hi = upper_32_bits(mbi_phys_base + GICD_SETSPI_NSR);
> -	msg[0].address_lo = lower_32_bits(mbi_phys_base + GICD_SETSPI_NSR);
>  	msg[0].data = data->parent_data->hwirq;
> -
> -	iommu_dma_compose_msi_msg(irq_data_get_msi_desc(data), msg);
> +	msi_msg_set_msi_addr(irq_data_get_msi_desc(data), &msg[0],
> +			     mbi_phys_base + GICD_SETSPI_NSR);
>  }
>  
>  static void mbi_compose_mbi_msg(struct irq_data *data, struct msi_msg *msg)
>  {
>  	mbi_compose_msi_msg(data, msg);
>  
> -	msg[1].address_hi = upper_32_bits(mbi_phys_base + GICD_CLRSPI_NSR);
> -	msg[1].address_lo = lower_32_bits(mbi_phys_base + GICD_CLRSPI_NSR);
>  	msg[1].data = data->parent_data->hwirq;
> -
> -	iommu_dma_compose_msi_msg(irq_data_get_msi_desc(data), &msg[1]);
> +	msi_msg_set_msi_addr(irq_data_get_msi_desc(data), &msg[1],
> +			     mbi_phys_base + GICD_CLRSPI_NSR);
>  }
>  
>  static bool mbi_init_dev_msi_info(struct device *dev, struct irq_domain *domain,
> diff --git a/drivers/irqchip/irq-ls-scfg-msi.c b/drivers/irqchip/irq-ls-scfg-msi.c
> index c0e1aafe468c..2ac6d89b4cb4 100644
> --- a/drivers/irqchip/irq-ls-scfg-msi.c
> +++ b/drivers/irqchip/irq-ls-scfg-msi.c
> @@ -87,8 +87,6 @@ static void ls_scfg_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
>  {
>  	struct ls_scfg_msi *msi_data = irq_data_get_irq_chip_data(data);
>  
> -	msg->address_hi = upper_32_bits(msi_data->msiir_addr);
> -	msg->address_lo = lower_32_bits(msi_data->msiir_addr);
>  	msg->data = data->hwirq;
>  
>  	if (msi_affinity_flag) {
> @@ -98,7 +96,8 @@ static void ls_scfg_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
>  		msg->data |= cpumask_first(mask);
>  	}
>  
> -	iommu_dma_compose_msi_msg(irq_data_get_msi_desc(data), msg);
> +	msi_msg_set_msi_addr(irq_data_get_msi_desc(data), msg,
> +			     msi_data->msiir_addr);
>  }
>  
>  static int ls_scfg_msi_set_affinity(struct irq_data *irq_data,

