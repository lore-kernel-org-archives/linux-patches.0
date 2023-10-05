Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E7A1863
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 03:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1c60f1a2652so4786495ad.0
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 20:59:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696478348; x=1697083148;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+Jkb9so4Sx/SuJj60Fyzc1sAp0BI3gQYpSvgDry1RU=;
        b=Epd6KhWR+w7IyIg7TZeBzHU5tAEwKEgS9dY/6e5PMHDzZ+3AlH2rdT1EuVE8TgLmry
         5XaRft5xxbg15gSM3ZEQoD1xC7Lx8GerTW2ODggzkBym8lzI9JZUZrjQJMLGLgpHr61V
         jQZAXHVE8W3J32oja40B54k5mWqkcnXt15gPzmTgcvq1hvcCcNNcbrKHaqMEn8XtKnkV
         Rb/ey04e6RKAFzAQNmT8yYzqph7o+XR/DUAyyCtNn95kBgqrRwmrda+3NEMH5cGMwfcQ
         tkODNytoC+ZPtwV80daZg/ngDAEfnUVoIUYT78ii0VnwyxqzR6xchcAAu0lFzznOs77c
         w/Pw==
X-Gm-Message-State: AOJu0YyOaE0bcbDzVAccRC4vS4pkJQLz3aa+b3rTgDV20Gwn4A3NHfUS
	hobJ0+rkctsHfK0AiizRsd8=
X-Google-Smtp-Source: AGHT+IHAxgh1RuIcuUvDcXDLUh/lmF/YHHBUPm/7q98TdAA0PrzTlYpYEdCFxJzdIf9FrJHWVapM5g==
X-Received: by 2002:a17:902:db10:b0:1bc:edd:e891 with SMTP id m16-20020a170902db1000b001bc0edde891mr398542plx.1.1696478348342;
        Wed, 04 Oct 2023 20:59:08 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id c16-20020a170903235000b001c724732058sm392807plh.235.2023.10.04.20.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 20:59:07 -0700 (PDT)
Date: Thu, 5 Oct 2023 03:59:05 +0000
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
Message-ID: <ZR40iZDLy43WzEy3@liuwe-devbox-debian-v2>
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

I've got the clearance to use "GPL-2.0 WITH Linux-syscall-note". We can
close on this issue. Thank you for the review.

Thanks,
Wei.

> 
> thanks,
> 
> greg k-h
