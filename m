Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941677F7D3
	for <patches@lists.linux.dev>; Thu,  9 May 2024 19:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715282805; cv=none; b=UXDN3JRfN+tkDIwh4OaAgZQQy5Kdajs0GOdbaR+yFMxu8Ea+34cPSuzSFUB1NzPHm2Lt+rmA405Mtra5Sr8zziGUlsGe1GYejL80WLDu05VKLGj8wwMNhSfLPJeqXKWI8ePtyI+WXsyVVOXQwNc04RyoZN5Trte6HTHEO1rsP0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715282805; c=relaxed/simple;
	bh=5xyp7Ps2HTHOcftYvjj1pUgEgLq3IRWAjmvCBScaoks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=O+ZlR0jZKjZjaLEGYNr65Psm3LwIu5O/VY+5b2h9XLwrCfEdkMuiR5HWlo+TFWV+MJhjljzjIqOJXBirNtYmBnMJ1TtxhyNeNH/WtsIetZoKPAXkykC11Ls8WAwHcuQxoShJfYASmuj8tJVQuAjphTiSxiptIJmcxAtAtW6m26Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YSd+j07N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YSd+j07N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715282802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p4g4FsYQoeNhGpgdCyFYmiZ8HUo2de78KOwvfm89r2E=;
	b=YSd+j07NA4xmkvP29ZwKp9nlzzRAZFGOKOA4lFQJY09Ev6z2WXWIHgxJPvZNdw79vHp0CG
	IVU1xKaHXVGJGsMA3SnuGQC56KJGPqmbIhcwX5CqoHPAfVTIiACWYS9AQ4RJvm62PFYMIq
	mP8pNx4MxbTXGeVj1tRKSQCzqKncJxs=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539--Z_5g1gROyONIk_rCrPFEQ-1; Thu, 09 May 2024 15:26:39 -0400
X-MC-Unique: -Z_5g1gROyONIk_rCrPFEQ-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2b2a8bd5ee0so1076196a91.2
        for <patches@lists.linux.dev>; Thu, 09 May 2024 12:26:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715282798; x=1715887598;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p4g4FsYQoeNhGpgdCyFYmiZ8HUo2de78KOwvfm89r2E=;
        b=EPtMpT5u2pReVgh4c/iDQsmxz+8+V5j/pISZdjI5M13KD/1Y0QgGZP/UtiSIZtU8ue
         77AKQUrpyce5I27qhBIDwCj8CxwhuvSQb2SKenDd+F0B8MI9LS96UEGMfrtZEj1BHwsz
         6Ml+tMnM4/XoE8DrEPSaILsWSfXjxkzoCtgFnqVhv9vVD0frLolaNdD9nnj0LZSaB1q9
         oGah8EerxwQSxguhWNdswDPLKICBKMB2GmcPvP6xXmgXz8GhPU4kfZw9FIFH8rzKmvV1
         4SC2PZAgvB3iCPin87H94E4ytW7MGFbjMcmVpxWfaZwB9oR2w02+0cueynKx9f2bdS2A
         73tQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9xQvIyFdCcC0aTGS7oMfe7q+wGsWyAkabUTEOZuk2YsBvTFrJSiqlqsscwzskyoGvcuFC/MbJ9OlqT6f9kSVvil0E2beyyg==
X-Gm-Message-State: AOJu0YwzM3CqgHttNxdHW/zdbSfNfkReCedLdAB8VoMOCGl5KZ20CnPT
	YO66r+O2TWpZAOspISJmZLTfUcKeQqH6PeSSDdunEfHrlQArushy+ghzeCQCU9lDeOQGMeISoCs
	vdPwqExvMXFSLlv5sWGUuJCocU3Jy7GkEUAsnhPM7o/5qk5o/SL3YlfzRHQE0qP4=
X-Received: by 2002:a17:90a:4307:b0:2b5:4ee8:e5e8 with SMTP id 98e67ed59e1d1-2b6cc758bb5mr425321a91.16.1715282798061;
        Thu, 09 May 2024 12:26:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1R7o3oF6G44XPCyXfp0bcIMx7PIyvpgYOTjDAYNP0/jmwyVCteoG1w8IfUcJ/qgMKjfhfgQ==
X-Received: by 2002:a17:90a:4307:b0:2b5:4ee8:e5e8 with SMTP id 98e67ed59e1d1-2b6cc758bb5mr425300a91.16.1715282797653;
        Thu, 09 May 2024 12:26:37 -0700 (PDT)
Received: from localhost (ip98-179-76-110.ph.ph.cox.net. [98.179.76.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b628ea6aadsm3699352a91.50.2024.05.09.12.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 12:26:36 -0700 (PDT)
Date: Thu, 9 May 2024 12:26:36 -0700
From: Jerry Snitselaar <jsnitsel@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, 
	Thierry Reding <thierry.reding@gmail.com>, Krishna Reddy <vdumpa@nvidia.com>, patches@lists.linux.dev, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH rc] iommu/arm-smmu: Use the correct type in
 nvidia_smmu_context_fault()
Message-ID: <pv3rl4cvvfgwv73c4mxosxbkghkz5py6cbqap2vkbs3rphk3od@d22igwn4gn7v>
References: <0-v1-24ce064de41f+4ac-nvidia_smmu_fault_jgg@nvidia.com>
 <xn6ghekaim52yotb6zikv7af3l225vlvt2m5wtho4powlpaelb@diu3pshryraw>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <xn6ghekaim52yotb6zikv7af3l225vlvt2m5wtho4powlpaelb@diu3pshryraw>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 09, 2024 at 11:51:55AM GMT, Jerry Snitselaar wrote:
> On Thu, May 09, 2024 at 02:45:51PM GMT, Jason Gunthorpe wrote:
> > This was missed because of the function pointer indirection.
> > 
> > nvidia_smmu_context_fault() is also installed as a irq function, and the
> > 'void *' was changed to a struct arm_smmu_domain. Since the iommu_domain
> > is embedded at a non-zero offset this causes nvidia_smmu_context_fault()
> > to miscompute the offset. Fixup the types.
> > 
> >   Unable to handle kernel NULL pointer dereference at virtual address 0000000000000120
> >   Mem abort info:
> >     ESR = 0x0000000096000004
> >     EC = 0x25: DABT (current EL), IL = 32 bits
> >     SET = 0, FnV = 0
> >     EA = 0, S1PTW = 0
> >     FSC = 0x04: level 0 translation fault
> >   Data abort info:
> >     ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
> >     CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> >     GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> >   user pgtable: 4k pages, 48-bit VAs, pgdp=0000000107c9f000
> >   [0000000000000120] pgd=0000000000000000, p4d=0000000000000000
> >   Internal error: Oops: 0000000096000004 [#1] SMP
> >   Modules linked in:
> >   CPU: 1 PID: 47 Comm: kworker/u25:0 Not tainted 6.9.0-0.rc7.58.eln136.aarch64 #1
> >   Hardware name: Unknown NVIDIA Jetson Orin NX/NVIDIA Jetson Orin NX, BIOS 3.1-32827747 03/19/2023
> >   Workqueue: events_unbound deferred_probe_work_func
> >   pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> >   pc : nvidia_smmu_context_fault+0x1c/0x158
> >   lr : __free_irq+0x1d4/0x2e8
> >   sp : ffff80008044b6f0
> >   x29: ffff80008044b6f0 x28: ffff000080a60b18 x27: ffffd32b5172e970
> >   x26: 0000000000000000 x25: ffff0000802f5aac x24: ffff0000802f5a30
> >   x23: ffff0000802f5b60 x22: 0000000000000057 x21: 0000000000000000
> >   x20: ffff0000802f5a00 x19: ffff000087d4cd80 x18: ffffffffffffffff
> >   x17: 6234362066666666 x16: 6630303078302d30 x15: ffff00008156d888
> >   x14: 0000000000000000 x13: ffff0000801db910 x12: ffff00008156d6d0
> >   x11: 0000000000000003 x10: ffff0000801db918 x9 : ffffd32b50f94d9c
> >   x8 : 1fffe0001032fda1 x7 : ffff00008197ed00 x6 : 000000000000000f
> >   x5 : 000000000000010e x4 : 000000000000010e x3 : 0000000000000000
> >   x2 : ffffd32b51720cd8 x1 : ffff000087e6f700 x0 : 0000000000000057
> >   Call trace:
> >    nvidia_smmu_context_fault+0x1c/0x158
> >    __free_irq+0x1d4/0x2e8
> >    free_irq+0x3c/0x80
> >    devm_free_irq+0x64/0xa8
> >    arm_smmu_domain_free+0xc4/0x158
> >    iommu_domain_free+0x44/0xa0
> >    iommu_deinit_device+0xd0/0xf8
> >    __iommu_group_remove_device+0xcc/0xe0
> >    iommu_bus_notifier+0x64/0xa8
> >    notifier_call_chain+0x78/0x148
> >    blocking_notifier_call_chain+0x4c/0x90
> >    bus_notify+0x44/0x70
> >    device_del+0x264/0x3e8
> >    pci_remove_bus_device+0x84/0x120
> >    pci_remove_root_bus+0x5c/0xc0
> >    dw_pcie_host_deinit+0x38/0xe0
> >    tegra_pcie_config_rp+0xc0/0x1f0
> >    tegra_pcie_dw_probe+0x34c/0x700
> >    platform_probe+0x70/0xe8
> >    really_probe+0xc8/0x3a0
> >    __driver_probe_device+0x84/0x160
> >    driver_probe_device+0x44/0x130
> >    __device_attach_driver+0xc4/0x170
> >    bus_for_each_drv+0x90/0x100
> >    __device_attach+0xa8/0x1c8
> >    device_initial_probe+0x1c/0x30
> >    bus_probe_device+0xb0/0xc0
> >    deferred_probe_work_func+0xbc/0x120
> >    process_one_work+0x194/0x490
> >    worker_thread+0x284/0x3b0
> >    kthread+0xf4/0x108
> >    ret_from_fork+0x10/0x20
> >   Code: a9b97bfd 910003fd a9025bf5 f85a0035 (b94122a1)
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: e0976331ad11 ("iommu/arm-smmu: Pass arm_smmu_domain to internal functions")
> > Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
> > Closes: https://lore.kernel.org/all/jto5e3ili4auk6sbzpnojdvhppgwuegir7mpd755anfhwcbkfz@2u5gh7bxb4iv
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Tested-by: Jerry Snitselaar <jsnitsel@redhat.com>
> Acked-by: Jerry Snitselaar <jsnitsel@redhat.com>

Actually looking at it again, does arm_smmu_context_fault need to be
updated as well? The devm_request_irq call is getting passed the
smmu_domain whether context_fault is arm_smmu_context_fault or
nvidia_smmu_context_fault.

> 
> > ---
> >  drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > Joerg, once Jerry ack's this you should grab it for this cycle.
> > 
> > Thanks,
> > Jason
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c b/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c
> > index 87bf522b9d2eec..957d988b6d832f 100644
> > --- a/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c
> > +++ b/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c
> > @@ -221,11 +221,9 @@ static irqreturn_t nvidia_smmu_context_fault(int irq, void *dev)
> >  	unsigned int inst;
> >  	irqreturn_t ret = IRQ_NONE;
> >  	struct arm_smmu_device *smmu;
> > -	struct iommu_domain *domain = dev;
> > -	struct arm_smmu_domain *smmu_domain;
> > +	struct arm_smmu_domain *smmu_domain = dev;
> >  	struct nvidia_smmu *nvidia;
> >  
> > -	smmu_domain = container_of(domain, struct arm_smmu_domain, domain);
> >  	smmu = smmu_domain->smmu;
> >  	nvidia = to_nvidia_smmu(smmu);
> >  
> > 
> > base-commit: dff9180946cc45d90a77e1c8645989cdcfd31437
> > -- 
> > 2.43.2
> > 
> 

