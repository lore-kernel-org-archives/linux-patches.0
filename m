Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC9B2777F3
	for <patches@lists.linux.dev>; Tue,  1 Jul 2025 19:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751398149; cv=none; b=dUOz5mSM8u2cjHnVV1vgzT6j08K/C4k457nHoFXtpRBLBZWQWzX2Sgr7joObEzcd1FNUaQeZAUHWf3YiLQnE0EFv6eHZ9qW/H5HMDT83PNrfzJYYK54ZZVqtpxffzbCM3UdQP2bY3OtFWDoNN2jDmEk08iVjrrZrtCpjfPLcLhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751398149; c=relaxed/simple;
	bh=qi5MFGChAXKFUZDjtd1nmNXpvDA6MtQYTfDI2UZXy1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VMqE+R0ss1+FSLCe5UkOoCQbZwd5pdDovhjU0p9ZB6rS9r2/Yuob4veDryGfwOPYsa0R3ZOPr9nOUzoIzQaicn+2EJotFTcJDNkEoWZPF1Hj+iEanQINh/8eVbSU/ZPBSQFHGFAn/tqJ3iLPXOgn98+Cyay5cjC8TiWSc7vBdqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FI0poBBL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FI0poBBL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751398146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+gDtWunL173OL9YHHTWlvkL7hyhpmJ6KyKj/K99C8D4=;
	b=FI0poBBLD3EbrOUaez7Eptc4dGQKPTw8kG654pUZuyGLg0lqsokJQHlE/A9JBgLtit+sp0
	93wH2ZL9w6h1WDlz0WYGzhy5TMXVCcAheiRYr8vnZntsMDrggzjZuWPmV+71Dm5P6kxLtT
	M3P/YeFkjDfiTo9oXssG9VXyBOgMMCE=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-ULHcTyzHOve5BhYFfZ_KHQ-1; Tue, 01 Jul 2025 15:29:05 -0400
X-MC-Unique: ULHcTyzHOve5BhYFfZ_KHQ-1
X-Mimecast-MFC-AGG-ID: ULHcTyzHOve5BhYFfZ_KHQ_1751398145
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-2ea1e609e38so1296813fac.2
        for <patches@lists.linux.dev>; Tue, 01 Jul 2025 12:29:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751398145; x=1752002945;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+gDtWunL173OL9YHHTWlvkL7hyhpmJ6KyKj/K99C8D4=;
        b=r/coALfQU2cPAJTB8e/h+7FSwzt5ZPlUYs4kqnU2+ziyt41x8zUnZC5/saBUE8Z5zE
         dvMFnu32RJ3msUmzidGi4rzwlKRS/Z3EVpJPTWFCkMHzQnA+gEbu451W/dRABNZrZsC9
         LthaDd6MyS1zDvnmeT9HAnEtR55Nk/idzgwo5owrnvlHNeBtC1CHhfXvzdQOWISvDEod
         KGPTBS+RJiAllJ1kwyBMHnPK0bd1AK2AGL+oURQmYSRtDJs8OGOGi7nnwcjl2SbimyUI
         7oLRByRmPrYmiYhwHFxo3Ouv4Lq9CVYXzWvS7VulZPclHm0ziBg2hL91crwgkhZRNpMn
         /t7w==
X-Forwarded-Encrypted: i=1; AJvYcCVW7uJgLad9lhDpSS2+fPqDT1pPlpHOQDmVKjA2RknnQN56csEKfX/nI7bJ24Dg/Xgt+ychRhT5@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7eFE0RusBmHMcNbUyBXAIzjT2k75lStXDzfVoQXcU4obPcKAw
	XwpjBNiGB3dBQK0zJiuLAuUP0Qm0C+DhCcC1GUtrvURtm037Ow1db4T8r/xYgH2WoGIWrvRJLkV
	4FYdR1CTf/Jejgyw/pVXJDSaRXvo3HgcQLiQoGK7VbeneDhqDdujyp47YulY=
X-Gm-Gg: ASbGncuttPCa0vnIlt6o0B2cYya7KF7udscmc3YnMv2C+Fes4G44Z0hfGAyOZA46WfZ
	PLr1DcVFwFkwDqTVOEK9823ur5kVjrixyaqitD60Lo8Qv6ydRrLP8JnRsoXApiUz3yItxnly9pf
	vhR1Y1kVUH9caOfdX1J7t8H3JseUe0/S5SttDx8vsRVpJOGxHIDMsoHQ2nkHsQZgwg2ASb01HrZ
	XAqVLTgXAPMstQfMDKTzewuTuqwFCKb57+yk753k0dcBxQLzT+XIBFExATQsFArTH5/SS8+6wlN
	TnmPoE1v9U8ENyodRv83g47HJw==
X-Received: by 2002:a05:6871:3a14:b0:2d6:1e7:f583 with SMTP id 586e51a60fabf-2f5a8c8e573mr2994fac.3.1751398144978;
        Tue, 01 Jul 2025 12:29:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzxKBtIcEO/jlL/s7uq955z0t1nlv/4m/A44xpr3gujAXNCGCC9EjB5EeKqcMmTn3VuTuxcA==
X-Received: by 2002:a05:6871:3a14:b0:2d6:1e7:f583 with SMTP id 586e51a60fabf-2f5a8c8e573mr2981fac.3.1751398144405;
        Tue, 01 Jul 2025 12:29:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2efd4ef71e3sm3405314fac.19.2025.07.01.12.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 12:29:03 -0700 (PDT)
Date: Tue, 1 Jul 2025 13:28:59 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev, Joerg Roedel
 <joro@8bytes.org>, linux-pci@vger.kernel.org, Robin Murphy
 <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, Lu Baolu
 <baolu.lu@linux.intel.com>, galshalom@nvidia.com, Joerg Roedel
 <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 maorg@nvidia.com, patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu
 <tony.zhu@intel.com>
Subject: Re: [PATCH 02/11] PCI: Add pci_bus_isolation()
Message-ID: <20250701132859.2a6661a7.alex.williamson@redhat.com>
In-Reply-To: <2-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<2-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MjENmowgfEwogVUNBBAzLOjASUJ1X-LESeZdgea8B6o_1751398145
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 30 Jun 2025 19:28:32 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index 53840634fbfc2b..540a503b499e3f 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -113,6 +113,156 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
>  	return ret;
>  }
>  
> +static enum pci_bus_isolation pcie_switch_isolated(struct pci_bus *bus)
> +{
> +	struct pci_dev *pdev;
> +
> +	/*
> +	 * Within a PCIe switch we have an interior bus that has the Upstream
> +	 * port as the bridge and a set of Downstream port bridging to the
> +	 * egress ports.
> +	 *
> +	 * Each DSP has an ACS setting which controls where its traffic is
> +	 * permitted to go. Any DSP with a permissive ACS setting can send
> +	 * traffic flowing upstream back downstream through another DSP.
> +	 *
> +	 * Thus any non-permissive DSP spoils the whole bus.
> +	 */
> +	guard(rwsem_read)(&pci_bus_sem);
> +	list_for_each_entry(pdev, &bus->devices, bus_list) {
> +		/* Don't understand what this is, be conservative */
> +		if (!pci_is_pcie(pdev) ||
> +		    pci_pcie_type(pdev) != PCI_EXP_TYPE_DOWNSTREAM ||
> +		    pdev->dma_alias_mask)
> +			return PCIE_NON_ISOLATED;
> +
> +		if (!pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
> +			return PCIE_SWITCH_DSP_NON_ISOLATED;
> +	}
> +	return PCIE_ISOLATED;
> +}
> +
> +static bool pci_has_mmio(struct pci_dev *pdev)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i <= PCI_ROM_RESOURCE; i++) {
> +		struct resource *res = pci_resource_n(pdev, i);
> +
> +		if (resource_size(res) && resource_type(res) == IORESOURCE_MEM)
> +			return true;
> +	}
> +	return false;
> +}

Maybe the intent is to make this as generic as possible, but it seems
to only be used for bridge devices, so technically it could get
away with testing only the first two resources, right?

> +
> +/**
> + * pci_bus_isolated - Determine how isolated connected devices are
> + * @bus: The bus to check
> + *
> + * Isolation is the ability of devices to talk to each other. Full isolation
> + * means that a device can only communicate with the IOMMU and can not do peer
> + * to peer within the fabric.
> + *
> + * We consider isolation on a bus by bus basis. If the bus will permit a
> + * transaction originated downstream to complete on anything other than the
> + * IOMMU then the bus is not isolated.
> + *
> + * Non-isolation includes all the downstream devices on this bus, and it may
> + * include the upstream bridge or port that is creating this bus.
> + *
> + * The various cases are returned in an enum.
> + *
> + * Broadly speaking this function evaluates the ACS settings in a PCI switch to
> + * determine if a PCI switch is configured to have full isolation.
> + *
> + * Old PCI/PCI-X busses cannot have isolation due to their physical properties,
> + * but they do have some aliasing properties that effect group creation.
> + *
> + * pci_bus_isolated() does not consider loopback internal to devices, like
> + * multi-function devices performing a self-loopback. The caller must check
> + * this separately. It does not considering alasing within the bus.
> + *
> + * It does not currently support the ACS P2P Egress Control Vector, Linux does
> + * not yet have any way to enable this feature. EC will create subsets of the
> + * bus that are isolated from other subsets.
> + */
> +enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
> +{
> +	struct pci_dev *bridge = bus->self;
> +	int type;
> +
> +	/* Consider virtual busses isolated */
> +	if (!bridge)
> +		return PCIE_ISOLATED;
> +	if (pci_is_root_bus(bus))
> +		return PCIE_ISOLATED;

How do we know the root bus isn't conventional?  I suppose this is only
called by IOMMU code, but QEMU can make some pretty weird
configurations.  Thanks,

Alex

