Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB6B7F476
	for <patches@lists.linux.dev>; Thu,  9 May 2024 19:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715283051; cv=none; b=SUh7hi5Y/npWIhhunprN/cQBBqF1c6LxN1cGe8g9SY3aBRgpDCE612r6a3Bn+ZGJhg+0NQ3CaXRYeqh2IovRu40NBpcJDoTNL5JPoZtc2g5gybQLi2KDN8zEH86P1jdn6S3efZOIRtMDPIN3ahkbYwQHftcaWHan4nKA72dUJbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715283051; c=relaxed/simple;
	bh=3BOVOEfnKNHqljyyiF8FQcGMN8rbd1UYB2BOrZsP5Zg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=VgcVD7kfIb0FrinvaJOOscuhhi26OZ2M6CqEQ1OYOTRmC61pjarPa8YgaRwxnHjpECzCzw7gL4PzDcNlkvIoz2GvNn3m1mj0frw2mCxSG/H0IEytPgWRHSi+PjGChuDrECnggmEkcmBEe75n4OnpkSlqmsr8O0h5u1SyGEj9uE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TYvSsOOH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TYvSsOOH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715283047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jZ77OMppMBsu928qRfvEttoPGVG58lty6ejOFQq/CXw=;
	b=TYvSsOOHCDQvhOIOLeZAj0bm/vrPxkRiELcCWWK0UDQyAzAaELiUQaehCIUGkNNAglGv4L
	736ADo+5As9N3ovih2GQ2pyY/A4l2h8NnVH/Khb8rXKBGe9rcJ7eIokri10rELwxo9Zi2w
	8DGca8RQX+q96FEJO5SZrOAr5zRHQNc=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-LeUgoFIpOgyDyZA-LcglUw-1; Thu, 09 May 2024 15:30:45 -0400
X-MC-Unique: LeUgoFIpOgyDyZA-LcglUw-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-6ece5eeb7c0so1058925b3a.2
        for <patches@lists.linux.dev>; Thu, 09 May 2024 12:30:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715283044; x=1715887844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jZ77OMppMBsu928qRfvEttoPGVG58lty6ejOFQq/CXw=;
        b=P5x835X/xJGTn8/KJetuQMZUvQWwCLGG3dYQyHl0KBZDwmHFc9ssSzmpC0d2pk7NMN
         nG77EPaVqvgqPHkS7jX9D8Yzb74k81Sf89jSmwf1jMQPgjc1jMjMNwbM2Nlp/KMYx+JL
         X9M6CuoN53HpqJyLQ7cHLq6ylGPBcBjfcb8U5oPlK+xg0RqLDR+m5Ki74V+bP8t7Z9UX
         VBD+dYoRXXWVsc9PeUrH2xEjbMaKqjDNxPRvdOGfAxmKIqhR1C0UZEJC1ld+WdgzYRvw
         zYsO+hOOCsWCNJkkITP2ZWY4eM9OJ3r3HO9vLvm/YfhMKzaVopu3PjRef+MFhoCkYOH1
         GI9w==
X-Forwarded-Encrypted: i=1; AJvYcCW9/yvIUa8akcn8JG6FxX7ovyxBLagiU0S5dsUZp5Td6O3aBZLMw00L3COWhV4ToB67SXX6vex4GnQvACPSGcZ/y6+t8J03fA==
X-Gm-Message-State: AOJu0YyZAwPyep38cDsDFzv86kJdUnYNKhCPxsW0XaH9UQewO/MWdAhq
	4P4Tvs6LftX/fgMDoEjWVuUZUdqYl2KpOrbt6R64mpu3le0gJSRDe6Ruzny7I+dPYHN8CL+qlls
	WRkJRXUMRugxeywiCxeYkAd19u10rSF2Te9kQEIum1bkPs8n/ofzzAAc=
X-Received: by 2002:a05:6a00:ccc:b0:6ea:f351:1df9 with SMTP id d2e1a72fcca58-6f4e03485a5mr488249b3a.23.1715283044544;
        Thu, 09 May 2024 12:30:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4dbELWlZwAJIYYcfFMH+ATASFCTvJhKu6Tpk3vKTrRjueglva7Arg+O02Yv/akngT8hoyJQ==
X-Received: by 2002:a05:6a00:ccc:b0:6ea:f351:1df9 with SMTP id d2e1a72fcca58-6f4e03485a5mr488220b3a.23.1715283044110;
        Thu, 09 May 2024 12:30:44 -0700 (PDT)
Received: from localhost (ip98-179-76-110.ph.ph.cox.net. [98.179.76.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2a827f2sm1655047b3a.75.2024.05.09.12.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 12:30:43 -0700 (PDT)
Date: Thu, 9 May 2024 12:30:42 -0700
From: Jerry Snitselaar <jsnitsel@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, 
	Thierry Reding <thierry.reding@gmail.com>, Krishna Reddy <vdumpa@nvidia.com>, patches@lists.linux.dev, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH rc] iommu/arm-smmu: Use the correct type in
 nvidia_smmu_context_fault()
Message-ID: <pjrej3zdefuc4s6bd554cltx46zjbmvjd7zfzk56e775omsy2p@7qt5njnw7ujy>
References: <0-v1-24ce064de41f+4ac-nvidia_smmu_fault_jgg@nvidia.com>
 <xn6ghekaim52yotb6zikv7af3l225vlvt2m5wtho4powlpaelb@diu3pshryraw>
 <pv3rl4cvvfgwv73c4mxosxbkghkz5py6cbqap2vkbs3rphk3od@d22igwn4gn7v>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <pv3rl4cvvfgwv73c4mxosxbkghkz5py6cbqap2vkbs3rphk3od@d22igwn4gn7v>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 09, 2024 at 12:26:36PM GMT, Jerry Snitselaar wrote:
> On Thu, May 09, 2024 at 11:51:55AM GMT, Jerry Snitselaar wrote:
> > On Thu, May 09, 2024 at 02:45:51PM GMT, Jason Gunthorpe wrote:
> > > This was missed because of the function pointer indirection.
> > > 
> > > nvidia_smmu_context_fault() is also installed as a irq function, and the
> > > 'void *' was changed to a struct arm_smmu_domain. Since the iommu_domain
> > > is embedded at a non-zero offset this causes nvidia_smmu_context_fault()
> > > to miscompute the offset. Fixup the types.
> > > 
> > >   Unable to handle kernel NULL pointer dereference at virtual address 0000000000000120
> > >   Mem abort info:
> > >     ESR = 0x0000000096000004
> > >     EC = 0x25: DABT (current EL), IL = 32 bits
> > >     SET = 0, FnV = 0
> > >     EA = 0, S1PTW = 0
> > >     FSC = 0x04: level 0 translation fault
> > >   Data abort info:
> > >     ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
> > >     CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> > >     GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> > >   user pgtable: 4k pages, 48-bit VAs, pgdp=0000000107c9f000
> > >   [0000000000000120] pgd=0000000000000000, p4d=0000000000000000
> > >   Internal error: Oops: 0000000096000004 [#1] SMP
> > >   Modules linked in:
> > >   CPU: 1 PID: 47 Comm: kworker/u25:0 Not tainted 6.9.0-0.rc7.58.eln136.aarch64 #1
> > >   Hardware name: Unknown NVIDIA Jetson Orin NX/NVIDIA Jetson Orin NX, BIOS 3.1-32827747 03/19/2023
> > >   Workqueue: events_unbound deferred_probe_work_func
> > >   pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > >   pc : nvidia_smmu_context_fault+0x1c/0x158
> > >   lr : __free_irq+0x1d4/0x2e8
> > >   sp : ffff80008044b6f0
> > >   x29: ffff80008044b6f0 x28: ffff000080a60b18 x27: ffffd32b5172e970
> > >   x26: 0000000000000000 x25: ffff0000802f5aac x24: ffff0000802f5a30
> > >   x23: ffff0000802f5b60 x22: 0000000000000057 x21: 0000000000000000
> > >   x20: ffff0000802f5a00 x19: ffff000087d4cd80 x18: ffffffffffffffff
> > >   x17: 6234362066666666 x16: 6630303078302d30 x15: ffff00008156d888
> > >   x14: 0000000000000000 x13: ffff0000801db910 x12: ffff00008156d6d0
> > >   x11: 0000000000000003 x10: ffff0000801db918 x9 : ffffd32b50f94d9c
> > >   x8 : 1fffe0001032fda1 x7 : ffff00008197ed00 x6 : 000000000000000f
> > >   x5 : 000000000000010e x4 : 000000000000010e x3 : 0000000000000000
> > >   x2 : ffffd32b51720cd8 x1 : ffff000087e6f700 x0 : 0000000000000057
> > >   Call trace:
> > >    nvidia_smmu_context_fault+0x1c/0x158
> > >    __free_irq+0x1d4/0x2e8
> > >    free_irq+0x3c/0x80
> > >    devm_free_irq+0x64/0xa8
> > >    arm_smmu_domain_free+0xc4/0x158
> > >    iommu_domain_free+0x44/0xa0
> > >    iommu_deinit_device+0xd0/0xf8
> > >    __iommu_group_remove_device+0xcc/0xe0
> > >    iommu_bus_notifier+0x64/0xa8
> > >    notifier_call_chain+0x78/0x148
> > >    blocking_notifier_call_chain+0x4c/0x90
> > >    bus_notify+0x44/0x70
> > >    device_del+0x264/0x3e8
> > >    pci_remove_bus_device+0x84/0x120
> > >    pci_remove_root_bus+0x5c/0xc0
> > >    dw_pcie_host_deinit+0x38/0xe0
> > >    tegra_pcie_config_rp+0xc0/0x1f0
> > >    tegra_pcie_dw_probe+0x34c/0x700
> > >    platform_probe+0x70/0xe8
> > >    really_probe+0xc8/0x3a0
> > >    __driver_probe_device+0x84/0x160
> > >    driver_probe_device+0x44/0x130
> > >    __device_attach_driver+0xc4/0x170
> > >    bus_for_each_drv+0x90/0x100
> > >    __device_attach+0xa8/0x1c8
> > >    device_initial_probe+0x1c/0x30
> > >    bus_probe_device+0xb0/0xc0
> > >    deferred_probe_work_func+0xbc/0x120
> > >    process_one_work+0x194/0x490
> > >    worker_thread+0x284/0x3b0
> > >    kthread+0xf4/0x108
> > >    ret_from_fork+0x10/0x20
> > >   Code: a9b97bfd 910003fd a9025bf5 f85a0035 (b94122a1)
> > > 
> > > Cc: stable@vger.kernel.org
> > > Fixes: e0976331ad11 ("iommu/arm-smmu: Pass arm_smmu_domain to internal functions")
> > > Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
> > > Closes: https://lore.kernel.org/all/jto5e3ili4auk6sbzpnojdvhppgwuegir7mpd755anfhwcbkfz@2u5gh7bxb4iv
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > Tested-by: Jerry Snitselaar <jsnitsel@redhat.com>
> > Acked-by: Jerry Snitselaar <jsnitsel@redhat.com>
> 
> Actually looking at it again, does arm_smmu_context_fault need to be
> updated as well? The devm_request_irq call is getting passed the
> smmu_domain whether context_fault is arm_smmu_context_fault or
> nvidia_smmu_context_fault.
> 

Never mind. I can't read today.

> > 
> > > ---
> > >  drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c | 4 +---
> > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > > 
> > > Joerg, once Jerry ack's this you should grab it for this cycle.
> > > 
> > > Thanks,
> > > Jason
> > > 
> > > diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c b/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c
> > > index 87bf522b9d2eec..957d988b6d832f 100644
> > > --- a/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c
> > > +++ b/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c
> > > @@ -221,11 +221,9 @@ static irqreturn_t nvidia_smmu_context_fault(int irq, void *dev)
> > >  	unsigned int inst;
> > >  	irqreturn_t ret = IRQ_NONE;
> > >  	struct arm_smmu_device *smmu;
> > > -	struct iommu_domain *domain = dev;
> > > -	struct arm_smmu_domain *smmu_domain;
> > > +	struct arm_smmu_domain *smmu_domain = dev;
> > >  	struct nvidia_smmu *nvidia;
> > >  
> > > -	smmu_domain = container_of(domain, struct arm_smmu_domain, domain);
> > >  	smmu = smmu_domain->smmu;
> > >  	nvidia = to_nvidia_smmu(smmu);
> > >  
> > > 
> > > base-commit: dff9180946cc45d90a77e1c8645989cdcfd31437
> > > -- 
> > > 2.43.2
> > > 
> > 
> 

