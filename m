Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AD51DFE1
	for <patches@lists.linux.dev>; Thu,  2 Nov 2023 21:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z3Zy5fCE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698959637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wfkOCZI8s/vE06TUoYXsRUD43KZX2PM2aWjgbIbsBpM=;
	b=Z3Zy5fCE+H2PlUQgOTKlHDrB/lg5VqJ1jIIDV3MxKzuNsc9nu4B/lWNwMym9gZGTc83TaI
	c+eJSkhTqIeW9AiH0ZfYJcP8Fc6l0f7cr7X7+mGmIY57nuFxOeQ6zEaZCLAqs5oHdVH+i6
	zGqbQdRQ7odvgaAANY8fBa++jITFawY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362--Tml6uiWPu6dorfAM3q6ew-1; Thu, 02 Nov 2023 17:13:55 -0400
X-MC-Unique: -Tml6uiWPu6dorfAM3q6ew-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7aad53fd070so192082439f.1
        for <patches@lists.linux.dev>; Thu, 02 Nov 2023 14:13:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698959635; x=1699564435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wfkOCZI8s/vE06TUoYXsRUD43KZX2PM2aWjgbIbsBpM=;
        b=IxTA4TmbtEswSedhjBGfGVXg2WVg2PLFUpd2fsm9zYd+1Z/45crnoRApQbhdrM+aoC
         SVAB2tfnMmt7RWpnBiYEEfFNKSMnLrx0NYbcLFvR2K0RtgwljU84QKAJaGhSdfQm0m7H
         rLgsvB+pjI5gzNhoNsM7f808aBR69062fxwPWjKW3RoD0LzsgKpPDSzFNYTPLNtsuxWO
         4Ydv2csbmSK4WAjrL19oEIYsspDrhqtwJlIcaPNs7Rxp7U56+GRJ9wy0RDL3QG7lxGa0
         N1i+pfKVGZ4PfcvfahCHlpdMFnFTeTCUr0108ycunUDqgKrJsVLN1Ac64JIHyBiIbE1Z
         UlXA==
X-Gm-Message-State: AOJu0Yzjx2PEp750RNsFF+7gXR69szdXIF7Y49Hu/oTKKhTAnhp8ns00
	ohCm0n3tS2LRKd3Sfj8rSYeK7r8WLR4Wx7EaprpWpXGhBJ+CWfAk8FmeG64U/cFnMXam1AVHrML
	puR+anYCOq0lVB/Iy/w==
X-Received: by 2002:a05:6e02:1aa3:b0:357:a51e:7dc4 with SMTP id l3-20020a056e021aa300b00357a51e7dc4mr1194193ilv.8.1698959635173;
        Thu, 02 Nov 2023 14:13:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRtIDvk2h6ou5ybOQtJNHDdfQL1y1Tux+ld68/4dPL58MpKjJYWrha15wfkZsxlztkkSrmeg==
X-Received: by 2002:a05:6e02:1aa3:b0:357:a51e:7dc4 with SMTP id l3-20020a056e021aa300b00357a51e7dc4mr1194170ilv.8.1698959634873;
        Thu, 02 Nov 2023 14:13:54 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id r20-20020a056e02109400b0035742971dd3sm96799ilj.16.2023.11.02.14.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 14:13:54 -0700 (PDT)
Date: Thu, 2 Nov 2023 15:13:52 -0600
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
Message-ID: <20231102151352.1731de78.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB52769292F138F69D8717BE8D8CA6A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
	<BL1PR11MB52710EAB683507AD7FAD6A5B8CA0A@BL1PR11MB5271.namprd11.prod.outlook.com>
	<20231101120714.7763ed35.alex.williamson@redhat.com>
	<BN9PR11MB52769292F138F69D8717BE8D8CA6A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
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

On Thu, 2 Nov 2023 03:14:09 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Tian, Kevin
> > Sent: Thursday, November 2, 2023 10:52 AM
> >   
> > >
> > > Without an in-tree user of this code, we're just chopping up code for
> > > no real purpose.  There's no reason that a variant driver requiring IMS
> > > couldn't initially implement their own SET_IRQS ioctl.  Doing that  
> > 
> > this is an interesting idea. We haven't seen a real usage which wants
> > such MSI emulation on IMS for variant drivers. but if the code is
> > simple enough to demonstrate the 1st user of IMS it might not be
> > a bad choice. There are additional trap-emulation required in the
> > device MMIO bar (mostly copying MSI permission entry which contains
> > PASID info to the corresponding IMS entry). At a glance that area
> > is 4k-aligned so should be doable.
> >   
> 
> misread the spec. the MSI-X permission table which provides
> auxiliary data to MSI-X table is not 4k-aligned. It sits in the 1st
> 4k page together with many other registers. emulation of them
> could be simple with a native read/write handler but not sure
> whether any of them may sit in a hot path to affect perf due to
> trap...

I'm not sure if you're referring to a specific device spec or the PCI
spec, but the PCI spec has long included an implementation note
suggesting alignment of the MSI-X vector table and pba and separation
from CSRs, and I see this is now even more strongly worded in the 6.0
spec.

Note though that for QEMU, these are emulated in the VMM and not
written through to the device.  The result of writes to the vector
table in the VMM are translated to vector use/unuse operations, which
we see at the kernel level through SET_IRQS ioctl calls.  Are you
expecting to get PASID information written by the guest through the
emulated vector table?  That would entail something more than a simple
IMS backend to MSI-X frontend.  Thanks,

Alex

