Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3965627EFFB
	for <patches@lists.linux.dev>; Tue,  1 Jul 2025 19:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751398153; cv=none; b=Ag71WDm2Vr2tmWhfEh8N6UDm1+YVDddQ5M1RGDGXMctl77YDpn/jKWa3X/TzWklG3IBqkfgK0OwOCMBv/lfLWjkbZTIeZt+bR9iJbfy5UBYxRv2dLi8DRbVF4/KWNVoZ/hn3fhjMrhgVPgjJ5oyYcS7LD5y/eW3WWPfXF3KT0e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751398153; c=relaxed/simple;
	bh=Der6lHkCC98no1Vn4NQll5rTYBWXTKnaq2KSJ3XTARI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eTfYe2N4eNafgOIywa6oYVszSpHD2OvL8OTGPkpWhVf3P0xRhhkEWYDbb0/5ZsWMs5vDEGE2q/XAw9Vv4tfQgRpr5+eGEZ9wyh9XE8MibtqrDCJ1guJwDoANc3Imrplt4my9sgSONi8SpMVxNXv3kYn+isOUlmisgaYPaNi/5zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LN/qjXx7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LN/qjXx7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751398151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mjTFqfwrz80T+KU/Vvx3G5r4It+9k632M4DI6S0TxZ8=;
	b=LN/qjXx7ejcFaIcbG0dsKU5WcOT+LAR5IhXrbBBY9uGp3sQoV87IwdxgKvmx2bt5dqp14B
	NP5/1QtbcepJ/o3/boMm9HtQDX2a4I3fT9lAdamTZqBoOi8o5OwxngiXSxqad80TFdBsfO
	IMMy4pjaLz+0UUl2xAB8W/o5a8DlK5Y=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-zJHSfxFLNZOcS4Z2ba7Vhw-1; Tue, 01 Jul 2025 15:29:10 -0400
X-MC-Unique: zJHSfxFLNZOcS4Z2ba7Vhw-1
X-Mimecast-MFC-AGG-ID: zJHSfxFLNZOcS4Z2ba7Vhw_1751398149
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-739f16f11b3so146278a34.0
        for <patches@lists.linux.dev>; Tue, 01 Jul 2025 12:29:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751398149; x=1752002949;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mjTFqfwrz80T+KU/Vvx3G5r4It+9k632M4DI6S0TxZ8=;
        b=BCkAlcXZIPFtEbW+X7SJuXzP6u1YGoyxXl6y/8ahk40VXUzg/6WVKi7SHZEJ+MBNWo
         DZ9l0rZrRTVsGKDXBAezvXbZ9jLiPWPiqSy7ylDnKVUuVxhLCy6A5/ciCnhqeQCNrCgF
         WkuSIGfJ6tKHc8Itrv74JpYqhXg0/RI6Ltljaoml4pOxAddoq7fOo5KOUkTK5zBo2oUX
         xMWZ5EVPRChW2a1Tf0c+YaRv9h5RPdDWHiDPmgLJFGwu5W/fG9nEKobCge/aBzzyVrhM
         an/Te5o1bd0q+Hpp9v33TSRvYjMHye4QawActCPpJlJs/f9zj3daebxkegAhkmh8QUyE
         gkjg==
X-Forwarded-Encrypted: i=1; AJvYcCX4zsLhB1h8VGYgY/7TyODODqvxinxvUueUrpbubXnskXvj+iQBvCSddQXteuiYBBwGtfNnyzTA@lists.linux.dev
X-Gm-Message-State: AOJu0Yxvc6jq6QkhhZU4BIWXQqhu1ARNCtGGk+7vY4PQYhIyTVuzxcIy
	oNj24Hz3bPzHkB8huaDdaWPap9Sd7kiHTarGOA6y4K3pFaq9F08CCLPU8IAiPDRvOjcvY1Vq/xN
	oGMte9ShtYMBlDbs/obxLF9xtEmZ0HFHJf/yF/r0DkLLgOp51A/LVuk7YfIc=
X-Gm-Gg: ASbGnct3B9JURLD7+/MLtxXpAriSnBqr/dlKG7MwNFZvHKHPDZD5A80amE/PDRdtTev
	4oJyzksn/Ue1+d62YN6jwTG5nqAD5jIUGD7OgH6womffzhwDQWfMsi8AY1OOoBgmcKbGdx7I/js
	yQIFhHLO/lD3n6DTSPp0OWK2zIZfddk3qSJvNawkTtUwD7+L1ovgnTaagjxi7OoiX9VAzZ/+jip
	+k7lhv7xyT9OkJzCG0QeUM5E/e8QiAvGa1SSzwGUIiLS2GHTK2+ljUE36GVo0cX4ynlq6/JlrxS
	aVohBRVYYIBwxjjhA9a6Colfjg==
X-Received: by 2002:a05:6808:2217:b0:401:f524:a97d with SMTP id 5614622812f47-40b7b0a8707mr1196644b6e.4.1751398149417;
        Tue, 01 Jul 2025 12:29:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAidfeboIYE5QUTm/6yW8HPYX8OflJWQclvBEIzO4DlJkq5XCLurirKOmJEIcC02wo+DFNcg==
X-Received: by 2002:a05:6808:2217:b0:401:f524:a97d with SMTP id 5614622812f47-40b7b0a8707mr1196629b6e.4.1751398149030;
        Tue, 01 Jul 2025 12:29:09 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-40b322c1e25sm2242252b6e.20.2025.07.01.12.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 12:29:07 -0700 (PDT)
Date: Tue, 1 Jul 2025 13:29:05 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev, Joerg Roedel
 <joro@8bytes.org>, linux-pci@vger.kernel.org, Robin Murphy
 <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, Lu Baolu
 <baolu.lu@linux.intel.com>, galshalom@nvidia.com, Joerg Roedel
 <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 maorg@nvidia.com, patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu
 <tony.zhu@intel.com>
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250701132905.67d29191.alex.williamson@redhat.com>
In-Reply-To: <3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eYzenE6LaQdV_MpKIDugdkiZbTPbrBgzBf46Cpa10a0_1751398149
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 30 Jun 2025 19:28:33 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index d265de874b14b6..f4584ffacbc03d 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -65,8 +65,16 @@ struct iommu_group {
>  	struct list_head entry;
>  	unsigned int owner_cnt;
>  	void *owner;
> +
> +	/* Used by the device_group() callbacks */
> +	u32 bus_data;
>  };
>  
> +/*
> + * Everything downstream of this group should share it.
> + */
> +#define BUS_DATA_PCI_UNISOLATED BIT(0)

NON_ISOLATED for consistency w/ enum from the previous patch?

...
> +struct iommu_group *pci_device_group(struct device *dev)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct iommu_group *group;
> +	struct pci_dev *real_pdev;
> +
> +	if (WARN_ON(!dev_is_pci(dev)))
> +		return ERR_PTR(-EINVAL);
> +
> +	/*
> +	 * Arches can supply a completely different PCI device that actually
> +	 * does DMA.
> +	 */
> +	real_pdev = pci_real_dma_dev(pdev);
> +	if (real_pdev != pdev) {
> +		group = iommu_group_get(&real_pdev->dev);
> +		if (!group) {
> +			/*
> +			 * The real_pdev has not had an iommu probed to it. We
> +			 * can't create a new group here because there is no way
> +			 * for pci_device_group(real_pdev) to pick it up.
> +			 */
> +			dev_err(dev,
> +				"PCI device is probing out of order, real device of %s is not probed yet\n",
> +				pci_name(real_pdev));
> +			return ERR_PTR(-EPROBE_DEFER);
> +		}
> +		return group;
> +	}
> +
> +	if (pdev->dev_flags & PCI_DEV_FLAGS_BRIDGE_XLATE_ROOT)
> +		return iommu_group_alloc();
> +
> +	/* Anything upstream of this enforcing non-isolated? */
> +	group = pci_hierarchy_group(pdev);
>  	if (group)
>  		return group;
>  
> -	/* No shared group found, allocate new */
> -	return iommu_group_alloc();
> +	switch (pci_bus_isolated(pdev->bus)) {
> +	case PCIE_ISOLATED:
> +		/* Check multi-function groups and same-bus devfn aliases */
> +		group = pci_get_alias_group(pdev);
> +		if (group)
> +			return group;
> +
> +		/* No shared group found, allocate new */
> +		return iommu_group_alloc();

I'm not following how we'd handle a multi-function root port w/o
consistent ACS isolation here.  How/where does the resulting group get
the UNISOLATED flag set?

I think that's necessary for the look-back in pci_hierarchy_group(),
right?  Thanks,

Alex

