Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DA923ABB6
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 22:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751581059; cv=none; b=AGrhAtk+y3wSbDPA7VXe/soZadWxgYGw2sLvCZACi7bX0GQcCa/2equ8lCiFIzqvMA4KiJwRcbtzMh+cYivdj+RIAbTY9VA7NhJdUI6oeGccHZUW0JP5nStRKEgqat5CF9GxgpaqvcV8MAPQlwP7GTSpyqeFpVMoLrTQwo3tvpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751581059; c=relaxed/simple;
	bh=4ypezCMzqx2m8rAZovbE9cWrKwtdXpCPRYKVPomZyMo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fYZl9F5VEPKsWVs3XvdTqKT94YmTm6PqsjvbkbwXfMHuTLxaKG0v3XTXysv2QLRQuPT0CYPApzogO7fLIADtwn3L0Hk0OHbi98ks2FyKIuU1+FoGyM/Dmn4s6Fw4zlKiYIfzs5leyeOztKg3UoxiKbNdGXHIbQjakrioMyqkP90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JMm777n2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JMm777n2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751581055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dsjcnePffsNnJ3iYlPAnCmr2JiGAFkwGmeExoquH+U=;
	b=JMm777n2C4DRY6n4IcybNH0M902Y3PPE39VX7XpSCYgWYI2Bfx4mJoL0EqATC6Yl+fE+p1
	Cmzln35bao8gfZyHLSxoWU7JPFChm9EtYbOSGiEZhoKeGjmT6hxZIG9n6jYPuMh8kc1mdP
	GACvx7YlZB9sjtfkOKMzRZe30efToG4=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-yOc5osExP6yy21LDjZL8ag-1; Thu, 03 Jul 2025 18:17:32 -0400
X-MC-Unique: yOc5osExP6yy21LDjZL8ag-1
X-Mimecast-MFC-AGG-ID: yOc5osExP6yy21LDjZL8ag_1751581051
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-87373f99cd5so6305439f.3
        for <patches@lists.linux.dev>; Thu, 03 Jul 2025 15:17:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751581051; x=1752185851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4dsjcnePffsNnJ3iYlPAnCmr2JiGAFkwGmeExoquH+U=;
        b=YKMpKGPkWSOg1xX+UGzwH9fJ1bb2Pw+9nyHdCmhmGHVDr4eRy86vBfqpqDsY7U+HeZ
         4JPMQMC1AFk9HIoBT/1FovrToI31v3i9tlD2e8OwXnUMHZwnrYOFUqsbg56ljWWrCjLj
         t0I4lSP+9IecRR9+MKzBAk7FEDob0Vy+OZCghdzumsLOw6GWB9jMtXC8eFB0IpOeTSja
         zwB5gOa/CX9giR4UWx8Xt2e6sYxrJGWnZIVjab5miT3X9uVor81r5TgDsZZWh2RCkUqD
         aPdDjcUKoaYGvhuOx8Hd6nEfcZApoP1A6G995UrG/axCV8i+gEjjFc6n1ptyWOqqx9/F
         2nFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWoayZFiAya066833wNDA4EYDgKzRjkiONqyEc4/eYSGrMIyz1DbPeNMdERCn1lQC3+x/a61/4j@lists.linux.dev
X-Gm-Message-State: AOJu0Yz60tii5DjvCyIIBidZ4j/AVgpfngQHceuwHdPMgK1gRmvyrY+l
	XCYPXVNDYQW4bbz+Fmp2kncNmcDZas43T0nueq6iyRqhg5lrSKgYxP+sfQBH0VQqRFvxiy3XkLf
	57WxSd6nY4jrymaKYZuZhfjzPDgQEkjhl8tgWCRJ4Lc/TTZ7ldoc4llN7iEA=
X-Gm-Gg: ASbGncvd7MQIIuGQ73zSFi5rRpXu9+3ee6Hnz0A5Xtld7WRHjCkb/ZiSCDxUTi2mcaR
	MQXYSqLo2O/eHsdLNqQ/NOCQyr7+6oeYpkpC4BSRNUhpjM1Au4TdjqBGIzoZrp4n1AICHcuJ+Xx
	V2Uf2Q5MWCqcSmrIEJ1AuF51vT0LFQ7fLyNM8bPo4glyS103XgbaH77yAUwD9NC8V0LbHmP9CSx
	n/ZM1h67mjL0giDyp8cszlCshGb8wE6fPp0rgnbHDMzp35U/h/dJYDZC2xHD/GZW3MyKaYaPVEE
	AE/Ca8yzuNBzv7onKE7mzL/w+A==
X-Received: by 2002:a05:6602:1607:b0:864:9c2b:f842 with SMTP id ca18e2360f4ac-876e13a009dmr22655139f.0.1751581051204;
        Thu, 03 Jul 2025 15:17:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHK1hmIX7xtD4BcGg0tZpgeCzpZcsDTIoTx2ZGihjZIL7CUA+/RzY0cwRoZX1T3Wpx/+Vp+hg==
X-Received: by 2002:a05:6602:1607:b0:864:9c2b:f842 with SMTP id ca18e2360f4ac-876e13a009dmr22652739f.0.1751581050636;
        Thu, 03 Jul 2025 15:17:30 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-503b599c53csm153978173.24.2025.07.03.15.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 15:17:29 -0700 (PDT)
Date: Thu, 3 Jul 2025 16:17:27 -0600
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
Message-ID: <20250703161727.09316904.alex.williamson@redhat.com>
In-Reply-To: <20250703153030.GA1322329@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<2-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<20250701132859.2a6661a7.alex.williamson@redhat.com>
	<20250703153030.GA1322329@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QZUK6sAbGaH2Zj2RLn01pHAwqA7NyIgYnuk19VuBYcc_1751581051
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 3 Jul 2025 12:30:30 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jul 01, 2025 at 01:28:59PM -0600, Alex Williamson wrote:
> > > +enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
> > > +{
> > > +	struct pci_dev *bridge = bus->self;
> > > +	int type;
> > > +
> > > +	/* Consider virtual busses isolated */
> > > +	if (!bridge)
> > > +		return PCIE_ISOLATED;
> > > +	if (pci_is_root_bus(bus))
> > > +		return PCIE_ISOLATED;  
> > 
> > How do we know the root bus isn't conventional?  
> 
> If I read this right this is dead code..
> 
> /*
>  * Returns true if the PCI bus is root (behind host-PCI bridge),
>  * false otherwise
>  *
>  * Some code assumes that "bus->self == NULL" means that bus is a root bus.
>  * This is incorrect because "virtual" buses added for SR-IOV (via
>  * virtfn_add_bus()) have "bus->self == NULL" but are not root buses.
>  */
> static inline bool pci_is_root_bus(struct pci_bus *pbus)
> {
> 	return !(pbus->parent);
> 
> Looking at the call chain of pci_alloc_bus():
>  pci_alloc_child_bus() - Parent bus may not be NULL
>  pci_add_new_bus() - All callers pass !NULL bus
>  pci_register_host_bridge() - Sets self and parent to NULL
> 
> Thus if pci_is_root() == true implies bus->self == NULL so we can't
> get here.

Yep, seems correct.

> So I will change it to be like:
> 
> 	/*
> 	 * This bus was created by pci_register_host_bridge(). There is nothing
> 	 * upstream of this, assume it contains the TA and that the root complex
> 	 * does not allow P2P without going through the IOMMU.
> 	 */
> 	if (pci_is_root_bus(bus))
> 		return PCIE_ISOLATED;

Ok, but did we sidestep the question of whether the root bus can be
conventional?

> 
> 	/*
> 	 * Sometimes SRIOV VFs can have a "virtual" bus if the SRIOV RID's
> 	 * extend past the bus numbers of the parent. The spec says that SRIOV
> 	 * VFs and PFs should act the same as functions in a MFD. MFD isolation
> 	 * is handled outside this function.
> 	 */
> 	if (!bridge)
> 		return PCIE_ISOLATED;
> 
> And now it seems we never took care with SRIOV, along with the PF
> every SRIOV VF needs to have its ACS checked as though it was a MFD..

There's actually evidence that we did take care to make sure VFs never
flag themselves as multifunction in order to avoid the multifunction
ACS tests.  I think we'd see lots of devices suddenly unusable for one
of their intended use cases if we grouped VFs that don't expose an ACS
capability.  Also VFs from multiple PFs exist on the same virtual bus,
so I imagine if the PF supports ACS but the VF doesn't, you'd end up
with multiple isolation domains on the same bus.  Thus, we've so far
take the approach that "surely the hw vendor intended these to be used
independently", and only considered the isolation upstream from the VFs.
Thanks,

Alex

