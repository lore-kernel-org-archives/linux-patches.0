Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D7F1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-57ba2cd3507so48372eaf.2
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 11:14:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696443282; x=1697048082;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6nCGy29qXBi+ptXe1DWiTKziKMJYl0S7yqrhbrtMgRk=;
        b=YXEkNd86SkkPldBpH3sSf3s51B9IT8uI3xVFjab7Mmt8bPxdr4LJ35lGup9g5J0jNv
         OzYvr0h5FdYC8+5GQ3Op6rJRuoUIY6Wr+2+TUXkbZCbdz30xpqgPwq3wn46knoDctIqR
         cDgMaiQkx4EjpLspv2tthFLHU8HJ1vFdeH6R1XnaEePbY+gA3OKrys4KPf/6dYl68q6f
         2GxNz627KNMJn8EzYIn2L8xKyc3vloxG462zsEbU3GpozwBbSbdl+SYQCu2dQuTQ9vGT
         IVpBc76Px16sZ2XAjJ7l2ASNT/Thb872C9R4HugoVvCjwHAeVTzFybdaiCs8kJ00bd5d
         aqwA==
X-Gm-Message-State: AOJu0YwCfNC8K/nloB1UiOtUonajEZBTn79HC6+PXsh4gsO2bnJdaTcN
	wUQIlW8NBm4TajL+pwpvH/k=
X-Google-Smtp-Source: AGHT+IG7EHbaeeYSQWuYVxJewBVTKh+hSRaSfAIMnjP6jTwYH5NMi2y1YeijxB0WtRbsPtXrqTnwuw==
X-Received: by 2002:a05:6358:5e12:b0:139:d5b9:87d3 with SMTP id q18-20020a0563585e1200b00139d5b987d3mr2311233rwn.5.1696443282278;
        Wed, 04 Oct 2023 11:14:42 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id v7-20020a170902b7c700b001c627413e87sm4013296plz.290.2023.10.04.11.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 11:14:41 -0700 (PDT)
Date: Wed, 4 Oct 2023 18:14:40 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Wei Liu <wei.liu@kernel.org>,
	Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org, patches@lists.linux.dev,
	mikelley@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
	decui@microsoft.com, apais@linux.microsoft.com,
	Tianyu.Lan@microsoft.com, ssengar@linux.microsoft.com,
	mukeshrathor@microsoft.com, stanislav.kinsburskiy@gmail.com,
	jinankjain@linux.microsoft.com, vkuznets@redhat.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, hpa@zytor.com, will@kernel.org,
	catalin.marinas@arm.com
Subject: Re: [PATCH v4 13/15] uapi: hyperv: Add mshv driver headers defining
 hypervisor ABIs
Message-ID: <ZR2rkNYnQds1MGZ0@liuwe-devbox-debian-v2>
References: <1696010501-24584-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1696010501-24584-14-git-send-email-nunodasneves@linux.microsoft.com>
 <2023093057-eggplant-reshoot-8513@gregkh>
 <ZRia1uyFfEkSqmXw@liuwe-devbox-debian-v2>
 <2023100154-ferret-rift-acef@gregkh>
 <ZRyj5kJJYaBu22O3@liuwe-devbox-debian-v2>
 <2023100458-confusing-carton-3302@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023100458-confusing-carton-3302@gregkh>

Hi Greg

On Wed, Oct 04, 2023 at 08:11:13AM +0200, Greg KH wrote:
> On Tue, Oct 03, 2023 at 11:29:42PM +0000, Wei Liu wrote:
> > > > > > diff --git a/include/uapi/hyperv/hvgdk.h b/include/uapi/hyperv/hvgdk.h
> > > > > > new file mode 100644
> > > > > > index 000000000000..9bcbb7d902b2
> > > > > > --- /dev/null
> > > > > > +++ b/include/uapi/hyperv/hvgdk.h
> > > > > > @@ -0,0 +1,41 @@
> > > > > > +/* SPDX-License-Identifier: MIT */
> > > > > 
> > > > > That's usually not a good license for a new uapi .h file, why did you
> > > > > choose this one?
> > > > > 
> > > > 
> > > > This is chosen so that other Microsoft developers who don't normally
> > > > work on Linux can review this code.
> > > 
> > > Sorry, but that's not how kernel development is done.  Please fix your
> > > internal review processes and use the correct uapi header file license.
> > > 
> > > If your lawyers insist on this license, that's fine, but please have
> > > them provide a signed-off-by on the patch that adds it and have it
> > > documented why it is this license in the changelog AND in a comment in
> > > the file so we can understand what is going on with it.
> > > 
> > 
> > We went through an internal review with our legal counsel regarding the
> > MIT license. We have an approval from them.
> > 
> > Let me ask if using something like "GPL-2.0 WITH Linux-syscall-note OR
> > MIT" is possible.
> 
> That marking makes no sense from a legal point of view, please work with
> your lawyers as it seems they do not understand license descriptions
> very well :(
> 

Do you mean "GPL-2.0 WITH Linux-syscall-note OR MIT" doesn't make sense?

Why is that? I see that in various UAPI headers.

include/uapi/drm/lima_drm.h:1:/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
include/uapi/linux/io_uring.h:1:/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
include/uapi/linux/kfd_sysfs.h:1:/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
include/uapi/linux/rkisp1-config.h:1:/* SPDX-License-Identifier: ((GPL-2.0+ WITH Linux-syscall-note) OR MIT) */
include/uapi/linux/wireguard.h:1:/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
include/uapi/xen/evtchn.h:1:/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR MIT) */
include/uapi/xen/gntdev.h:1:/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR MIT) */
include/uapi/xen/privcmd.h:1:/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR MIT) */

Thanks,
Wei.

> thanks,
> 
> greg k-h
