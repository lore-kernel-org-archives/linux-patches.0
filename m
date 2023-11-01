Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E69D18E06
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 18:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ONcyxDtr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698862040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cNirxrwnGNxPhSeDEuyk3fyxTyLRlM+krbj6sC5I3yE=;
	b=ONcyxDtrYYx8ypk/nbevfr4hJr98pYevjwi/q9utKxbHR1OsV0r1iaDn7NojAZlHgZhlbt
	u/1P7QUpAD6w3vveeP+Q1mzkvTMePqoD9QGZ3LRguMIrFn3PTcQm5tp6wR6LYEHfUg6KrD
	PZzsYENEsLfjceLDLH9y1JcY6svRbds=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-n-cfwqnoP06SkmBKIs3okg-1; Wed, 01 Nov 2023 14:07:18 -0400
X-MC-Unique: n-cfwqnoP06SkmBKIs3okg-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3590c65d78eso756265ab.0
        for <patches@lists.linux.dev>; Wed, 01 Nov 2023 11:07:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698862037; x=1699466837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cNirxrwnGNxPhSeDEuyk3fyxTyLRlM+krbj6sC5I3yE=;
        b=EQmbi4Cmn0cTULNQFpXAehjz6ZwsQGValble5JbB9x9SShu9GQwhXo8AgsnF7N+dd8
         coufyZFW0HAHrUNGUWRXTBqUAKCU8+jhalVDkyjT/M1x3SbZ+0WV0ZMmE23DaBa2cN7R
         YF1qds0A2m5xR0fkP/Q2cDKmhDTqb3As4IOQhnxuu26y01IlJ7xUQ9+fJttZKmetwfvh
         O3exJGzAmz6TbFXHiIFymzcwLsUf6VtVIjya4N14TJOoT1+Y1wYmZhfask7wtdArwtby
         /yHcodj/kfWB/xhb3chdRrm1PLUWoAGSrwZjPccznIR9DnsFWJcE3rsoSLwV9Pp37RQW
         uzgQ==
X-Gm-Message-State: AOJu0YzjhyKY+RpdQcbwwoFOQstVAn37dny3T+ahMdTWgrtTUn6Msgbz
	VK9gm/0mnxV73G60P1yZN1uiXkSDbwyYiojGOFCRU50zU3G/7umow36ad4ORDoBybtGaRSiMXHg
	GYwOmXhzU9GP2HuLNJQ==
X-Received: by 2002:a05:6e02:310e:b0:359:39af:ffba with SMTP id bg14-20020a056e02310e00b0035939afffbamr6214775ilb.7.1698862037341;
        Wed, 01 Nov 2023 11:07:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDtPEU6mYCp0PSMGNZDkTtE/bY4ZfUUnVuiRWcA3PR8aPIt2pxI5neewOpstUTBhrwmao2ig==
X-Received: by 2002:a05:6e02:310e:b0:359:39af:ffba with SMTP id bg14-20020a056e02310e00b0035939afffbamr6214753ilb.7.1698862037083;
        Wed, 01 Nov 2023 11:07:17 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id a18-20020a92c712000000b0034e2572bb50sm649746ilp.13.2023.11.01.11.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Nov 2023 11:07:16 -0700 (PDT)
Date: Wed, 1 Nov 2023 12:07:14 -0600
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
Message-ID: <20231101120714.7763ed35.alex.williamson@redhat.com>
In-Reply-To: <BL1PR11MB52710EAB683507AD7FAD6A5B8CA0A@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
	<BL1PR11MB52710EAB683507AD7FAD6A5B8CA0A@BL1PR11MB5271.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Tue, 31 Oct 2023 07:31:24 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Chatre, Reinette <reinette.chatre@intel.com>
> > Sent: Saturday, October 28, 2023 1:01 AM
> > 
> > Changes since RFC V2:
> > - RFC V2:
> > https://lore.kernel.org/lkml/cover.1696609476.git.reinette.chatre@intel.com
> > /
> > - Still submiting this as RFC series. I believe that this now matches the
> >   expectatations raised during earlier reviews. If you agree this is
> >   the right direction then I can drop the RFC prefix on next submission.
> >   If you do not agree then please do let me know where I missed
> >   expectations.  
> 
> Overall this matches my expectation. Let's wait for Alex/Jason's thoughts
> before moving to next-level refinement.

It feels like there's a lot of gratuitous change without any clear
purpose.  We create an ops structure so that a variant/mdev driver can
make use of the vfio-pci-core set_irqs ioctl piecemeal, but then the
two entry points that are actually implemented by the ims version are
the same as the core version, so the ops appear to be at the wrong
level.  The use of the priv pointer for the core callbacks looks like
it's just trying to justify the existence of the opaque pointer, it
should really just be using container_of().  We drill down into various
support functions for MSI (ie. enable, disable, request_interrupt,
free_interrupt, device name), but INTx is largely ignored, where we
haven't even kept is_intx() consistent with the other helpers.

Without an in-tree user of this code, we're just chopping up code for
no real purpose.  There's no reason that a variant driver requiring IMS
couldn't initially implement their own SET_IRQS ioctl.  Doing that
might lead to a more organic solution where we create interfaces where
they're actually needed.  The existing mdev sample drivers should also
be considered in any schemes to refactor the core code into a generic
SET_IRQS helper for devices exposing a vfio-pci API.  Thanks,

Alex

