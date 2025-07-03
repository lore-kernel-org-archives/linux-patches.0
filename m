Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB751FDA89
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 23:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751584133; cv=none; b=kPe1QWh8kCPsWw9t9scn17K+tT68EgK9A14Hk6RKg8goSO5/M1CBA4M5V4kioHO8rYQK5Jx6NLX8NuGOfH0liPE3gPPw646RX+9C7LLnGd16/Uep6BxAQO0Br1/00C+wgSbiASAwyLLzCNSvG3rEXObP3dNbmRhn0Dj3JUuFDss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751584133; c=relaxed/simple;
	bh=kL2COggKRi2MMcxxxXVitt/0SKh/NzBOsX4IqvP2l1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hj1VcjReDXA/SXSUh52o/B8yQdXHc+8DSuZLswiJN0Mcc33uoPhPT1SAwvIL1xfnQ7mYrnL9ad+lPtM2ctjnmwXXPevs/ZI928Cr1qYQkFqnSMVwYctl23UNxpqwDVG0Z9WJ8VtDdGU44fvqqtzJUG09tMgU+bV/eQtW8mQ6tBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c+NaAca2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c+NaAca2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751584130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1YING2rD+/FRmd+v26pZBtJAEWyYAk3xy5D8dkgpzl4=;
	b=c+NaAca2ST3tJzPSQ1l14kIqNrBo8R3juBPcif8i1eUUaZ16+bTs4xiVa35gcKOaJEnAcW
	Dk0alyE5/EMm8PViHkpA3jkY2Thgh0YtAZ7r/KTO+e3o+iD8CdUstQgBR+KYkMqnV49gjB
	Sm77S+T8014uzrGNYqn2oGpp1RMRsxw=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-fozwtKy7Of-EtpQVe_JBsg-1; Thu, 03 Jul 2025 19:08:49 -0400
X-MC-Unique: fozwtKy7Of-EtpQVe_JBsg-1
X-Mimecast-MFC-AGG-ID: fozwtKy7Of-EtpQVe_JBsg_1751584129
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3ddd689c2b8so770495ab.1
        for <patches@lists.linux.dev>; Thu, 03 Jul 2025 16:08:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751584129; x=1752188929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1YING2rD+/FRmd+v26pZBtJAEWyYAk3xy5D8dkgpzl4=;
        b=XG2k1DcaC3Psa49T55uV5bfGwyiAAzRz4X+V5stCUJpMAL4FfHPhRrtyGklJwa+30k
         FoDYzDzCinkhBbjrExI0IEvFF6+7kHCXSpneqsVoYc9B4tShPFSe9tYlpNhtae1a/lDD
         tmSreejHTQoRmsRRkvcM8SGbZExbYIIV9OKCafci1x16NV0y0hauJ6jRvmxCDY3sYTO3
         r2tPNNhGEkMHwBQ4RvfPUuSjcOvHJiX52+eqe3GwnAtHKs8fu28AhbAMFyqBuDc+Jh3y
         1ywRzLeBD2Qtn3rIpcgCkqPiozEWas0fqDTeNguI3FbpiWBFNytkv1YgmIzML3cbKMH8
         cTkA==
X-Forwarded-Encrypted: i=1; AJvYcCWDQLvte+x/r2Y7E8WzV6sgJIZuqLSCXFo6pEM9tz8Yhc8OxoI/jaW0KwqH9Ol/1o1ufjp7jc0Y@lists.linux.dev
X-Gm-Message-State: AOJu0YwfUWNfj/O1YR6VTviQxeARSslvRnOpDBilutQgAXpKFs6v7IEa
	1lx+OxQFnXNiUi0Xb9IwOyzBG5AMhRVTbBhP1s0SNz9ErxhAMbaVUxbIDHKXorVhxREcrqXsCVQ
	lhR3DoFq2gIKBGgvDAuBCLHLkYE89Z2Q9ucwtHDNAJjxGzRw+UW9QWktbS58=
X-Gm-Gg: ASbGncsMwd7yU7PIblINEzFI485+2GLI3m6Es84jGIbdMZPtWzBWaHW0pLsftf/q67S
	yht69Js+hgmLjoLQ3YnN2+hBjbcdPNnudcX0TRKKLFh9CZis2apFBlNNwilfYCEautFUWtwXth6
	p8dvdPrdSVwvUMVEBp7YtvL2iA+PZefIwIM8gE/pevWE76XcAA9D7vxcbGCCAxEJMu4UJV0De46
	ai+RoJRbuiVIq82++fC832MYt4m6en3DEZmwvgq0Fg//YwN7QXb7D8CtpEgegfFQv9co70HMS1S
	ka59bMxSEixXg/XUxlI41jCU3w==
X-Received: by 2002:a05:6e02:1f12:b0:3dc:8075:ccb0 with SMTP id e9e14a558f8ab-3e135583c90mr940555ab.3.1751584128940;
        Thu, 03 Jul 2025 16:08:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZXOkCizG+2QD0k3c4R9Q17zYhNsPo1zPJTd155GX4jed8qYJ0mWeqGMBx7xHtV3Apq5n84w==
X-Received: by 2002:a05:6e02:1f12:b0:3dc:8075:ccb0 with SMTP id e9e14a558f8ab-3e135583c90mr940495ab.3.1751584128553;
        Thu, 03 Jul 2025 16:08:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e0fe22116bsm2415475ab.38.2025.07.03.16.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 16:08:47 -0700 (PDT)
Date: Thu, 3 Jul 2025 17:08:46 -0600
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
Message-ID: <20250703170846.2aa614d1.alex.williamson@redhat.com>
In-Reply-To: <20250703161727.09316904.alex.williamson@redhat.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<2-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<20250701132859.2a6661a7.alex.williamson@redhat.com>
	<20250703153030.GA1322329@nvidia.com>
	<20250703161727.09316904.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yAZ0HgeNGYESBqrb7oxfqtTGV_yuJjATsVDlLhAlCIY_1751584129
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 3 Jul 2025 16:17:27 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Thu, 3 Jul 2025 12:30:30 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Jul 01, 2025 at 01:28:59PM -0600, Alex Williamson wrote:  
> > > > +enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
> > > > +{
> > > > +	struct pci_dev *bridge = bus->self;
> > > > +	int type;
> > > > +
> > > > +	/* Consider virtual busses isolated */
> > > > +	if (!bridge)
> > > > +		return PCIE_ISOLATED;
> > > > +	if (pci_is_root_bus(bus))
> > > > +		return PCIE_ISOLATED;    
> > > 
> > > How do we know the root bus isn't conventional?    
> > 
> > If I read this right this is dead code..
> > 
> > /*
> >  * Returns true if the PCI bus is root (behind host-PCI bridge),
> >  * false otherwise
> >  *
> >  * Some code assumes that "bus->self == NULL" means that bus is a root bus.
> >  * This is incorrect because "virtual" buses added for SR-IOV (via
> >  * virtfn_add_bus()) have "bus->self == NULL" but are not root buses.
> >  */
> > static inline bool pci_is_root_bus(struct pci_bus *pbus)
> > {
> > 	return !(pbus->parent);
> > 
> > Looking at the call chain of pci_alloc_bus():
> >  pci_alloc_child_bus() - Parent bus may not be NULL
> >  pci_add_new_bus() - All callers pass !NULL bus
> >  pci_register_host_bridge() - Sets self and parent to NULL
> > 
> > Thus if pci_is_root() == true implies bus->self == NULL so we can't
> > get here.  
> 
> Yep, seems correct.
> 
> > So I will change it to be like:
> > 
> > 	/*
> > 	 * This bus was created by pci_register_host_bridge(). There is nothing
> > 	 * upstream of this, assume it contains the TA and that the root complex
> > 	 * does not allow P2P without going through the IOMMU.
> > 	 */
> > 	if (pci_is_root_bus(bus))
> > 		return PCIE_ISOLATED;  
> 
> Ok, but did we sidestep the question of whether the root bus can be
> conventional?
> 
> > 
> > 	/*
> > 	 * Sometimes SRIOV VFs can have a "virtual" bus if the SRIOV RID's
> > 	 * extend past the bus numbers of the parent. The spec says that SRIOV
> > 	 * VFs and PFs should act the same as functions in a MFD. MFD isolation
> > 	 * is handled outside this function.
> > 	 */
> > 	if (!bridge)
> > 		return PCIE_ISOLATED;
> > 
> > And now it seems we never took care with SRIOV, along with the PF
> > every SRIOV VF needs to have its ACS checked as though it was a MFD..  
> 
> There's actually evidence that we did take care to make sure VFs never
> flag themselves as multifunction in order to avoid the multifunction
> ACS tests.  I think we'd see lots of devices suddenly unusable for one
> of their intended use cases if we grouped VFs that don't expose an ACS
> capability.  Also VFs from multiple PFs exist on the same virtual bus,
> so I imagine if the PF supports ACS but the VF doesn't, you'd end up
> with multiple isolation domains on the same bus.  Thus, we've so far
> take the approach that "surely the hw vendor intended these to be used
> independently", and only considered the isolation upstream from the VFs.

BTW, spec 6.0.1, section 6.12:

  For ACS requirements, single-Function devices that are SR-IOV capable
  must be handled as if they were Multi-Function Devices, since they
  essentially behave as Multi-Function Devices after their Virtual
  Functions (VFs) are enabled.

Also, section 7.7.11:

  If an SR-IOV Capable Device other than one in a Root Complex
  implements internal peer-to-peer transactions, ACS is required, and
  ACS P2P Egress Control must be supported.

The latter says to me that a non root complex SR-IOV device that does
not implement ACS does not implement internal p2p routing.  OTOH, the
former seems to suggest that we need to consider VFs as peers of the
PF, maybe even governed by ACS on the PF, relative to MF routing.  I'm
not really finding anything that says the VF itself needs to implement
ACS.  Thanks,

Alex

