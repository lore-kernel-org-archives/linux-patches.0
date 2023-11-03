Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50FC1C2B9
	for <patches@lists.linux.dev>; Fri,  3 Nov 2023 15:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JmlTba1p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699026685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cQfUHragInpQXkGJlCrmUlsPxp9RJTqS4atEg6g9qME=;
	b=JmlTba1pM1UX2NwooDLN+O05x451+XsMd8NwRFMzo0T3ChlwVSxpBEme0FNCyyZ3KEYc6x
	gj/GLi4lTEH/DmZoAjOx1EGoIiAItGTItJkkIaANE6wS95YQilIN/O08mu5JGnzaZjis2I
	qGT/u7/S1AJK5kLgxsSbdqfRauHyR6o=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-NpKIjx4FPcS7MkUleFG-tg-1; Fri, 03 Nov 2023 11:51:24 -0400
X-MC-Unique: NpKIjx4FPcS7MkUleFG-tg-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7a2cc9ee5d0so205161939f.2
        for <patches@lists.linux.dev>; Fri, 03 Nov 2023 08:51:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699026683; x=1699631483;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cQfUHragInpQXkGJlCrmUlsPxp9RJTqS4atEg6g9qME=;
        b=OmaeIkVBvdfefjcRBfplw9WdtNPFZzhwn/k8H97cEiB60eh9llYU2CRdBNDmCRkfN7
         jmVCNyp87Ur8zfbUnft8gfZH1oUMc2s9U8xiWHg67o0dbexJgeFMSi6AKM8JcT7v+oqg
         vlkLeteEBK63YyCPhIN+XwIPLV+ZlwB+MNlYvXf7fc6arp+pv8yOvCk8JvJDc7MU9ho7
         re8X/1RKqbI/e2fzWv/ZmIgR3XukX30djY7ZwUtdRMFykmEF7+y6/PzxoKzEf73biRRG
         X9uEbG54zNisOumoda3HLEevEAR5ZOzU7OokVj5y0Hw7uf3JasdVKunZeToQW9gXxJuS
         +4sg==
X-Gm-Message-State: AOJu0YzcJ+J/bZwEqrSUUyWZfe8hRflbYqm3pu67d1rCn4sbJjyglF0Q
	p+W1BRheq6G1tBqueSPdFUGGZhcc1Y3arlAukJBtSk+Qfgtng/HZmHaVJGjuPc7EDGLuCTwfyBM
	V3H1WhBjqyVQwyLipbA==
X-Received: by 2002:a05:6e02:1846:b0:357:8d71:347f with SMTP id b6-20020a056e02184600b003578d71347fmr34486488ilv.8.1699026683242;
        Fri, 03 Nov 2023 08:51:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFGj8CHxufE7VHtH3JkFgjEN1b6NgZYdSnvw1WC8K1DBeYPqTQM5Psn/dldpSTv/MzEpAzisw==
X-Received: by 2002:a05:6e02:1846:b0:357:8d71:347f with SMTP id b6-20020a056e02184600b003578d71347fmr34486459ilv.8.1699026683002;
        Fri, 03 Nov 2023 08:51:23 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id b16-20020a92ce10000000b003596a440efasm281748ilo.19.2023.11.03.08.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Nov 2023 08:51:22 -0700 (PDT)
Date: Fri, 3 Nov 2023 09:51:19 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>, "jgg@nvidia.com"
 <jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
 "shameerali.kolothum.thodi@huawei.com"
 <shameerali.kolothum.thodi@huawei.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, "Liu, Jing2"
 <jing2.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, "Yu, Fenghua"
 <fenghua.yu@intel.com>, "tom.zanussi@linux.intel.com"
 <tom.zanussi@linux.intel.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
 <patches@lists.linux.dev>
Subject: Re: [RFC PATCH V3 00/26] vfio/pci: Back guest interrupts from
 Interrupt Message Store (IMS)
Message-ID: <20231103095119.63aa796f.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276BCEA3275EC7203E06FDA8CA5A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
	<BL1PR11MB52710EAB683507AD7FAD6A5B8CA0A@BL1PR11MB5271.namprd11.prod.outlook.com>
	<20231101120714.7763ed35.alex.williamson@redhat.com>
	<BN9PR11MB52769292F138F69D8717BE8D8CA6A@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20231102151352.1731de78.alex.williamson@redhat.com>
	<BN9PR11MB5276BCEA3275EC7203E06FDA8CA5A@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 3 Nov 2023 07:23:13 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, November 3, 2023 5:14 AM
> > 
> > On Thu, 2 Nov 2023 03:14:09 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >   
> > > > From: Tian, Kevin
> > > > Sent: Thursday, November 2, 2023 10:52 AM
> > > >  
> > > > >
> > > > > Without an in-tree user of this code, we're just chopping up code for
> > > > > no real purpose.  There's no reason that a variant driver requiring IMS
> > > > > couldn't initially implement their own SET_IRQS ioctl.  Doing that  
> > > >
> > > > this is an interesting idea. We haven't seen a real usage which wants
> > > > such MSI emulation on IMS for variant drivers. but if the code is
> > > > simple enough to demonstrate the 1st user of IMS it might not be
> > > > a bad choice. There are additional trap-emulation required in the
> > > > device MMIO bar (mostly copying MSI permission entry which contains
> > > > PASID info to the corresponding IMS entry). At a glance that area
> > > > is 4k-aligned so should be doable.
> > > >  
> > >
> > > misread the spec. the MSI-X permission table which provides
> > > auxiliary data to MSI-X table is not 4k-aligned. It sits in the 1st
> > > 4k page together with many other registers. emulation of them
> > > could be simple with a native read/write handler but not sure
> > > whether any of them may sit in a hot path to affect perf due to
> > > trap...  
> > 
> > I'm not sure if you're referring to a specific device spec or the PCI
> > spec, but the PCI spec has long included an implementation note
> > suggesting alignment of the MSI-X vector table and pba and separation
> > from CSRs, and I see this is now even more strongly worded in the 6.0
> > spec.
> > 
> > Note though that for QEMU, these are emulated in the VMM and not
> > written through to the device.  The result of writes to the vector
> > table in the VMM are translated to vector use/unuse operations, which
> > we see at the kernel level through SET_IRQS ioctl calls.  Are you
> > expecting to get PASID information written by the guest through the
> > emulated vector table?  That would entail something more than a simple
> > IMS backend to MSI-X frontend.  Thanks,
> >   
> 
> I was referring to IDXD device spec. Basically it allows a process to
> submit a descriptor which contains a completion interrupt handle.
> The handle is the index of a MSI-X entry or IMS entry allocated by
> the idxd driver. To mark the association between application and
> related handles the driver records the PASID of the application
> in an auxiliary structure for MSI-X (called MSI-X permission table)
> or directly in the IMS entry. This additional info includes whether
> an MSI-X/IMS entry has PASID enabled and if yes what is the PASID
> value to be checked against the descriptor.
> 
> As you said virtualizing MSI-X table itself is via SET_IRQS and it's
> 4k aligned. Then we also need to capture guest updates to the MSI-X
> permission table and copy the PASID information into the
> corresponding IMS entry when using the IMS backend. It's MSI-X
> permission table not 4k aligned then trapping it will affect adjacent
> registers.
> 
> My quick check in idxd spec doesn't reveal an real impact in perf
> critical path. Most registers are configuration/control registers
> accessed at driver init time and a few interrupt registers related
> to errors or administrative purpose.

Right, it looks like you'll need to trap writes to the MSI-X
Permissions Table via a sparse mmap capability to avoid assumptions
whether it lives on the same page as the MSI-X vector table or PBA.
Ideally the hardware folks have considered this to avoid any conflict
with latency sensitive registers.

The variant driver would use this for collecting the meta data relative
to the IMS interrupt, but this is all tangential to whether we
preemptively slice up vfio-pci-core's SET_IRQS ioctl or the iDXD driver
implements its own.

And just to be clear, I don't expect the iDXD variant driver to go to
extraordinary lengths to duplicate the core ioctl, we can certainly
refactor and export things where it makes sense, but I think it likely
makes more sense for the variant driver to implement the shell of the
ioctl rather than trying to multiplex the entire core ioctl with an ops
structure that's so intimately tied to the core implementation and
focused only on the MSI-X code paths.  Thanks,

Alex

