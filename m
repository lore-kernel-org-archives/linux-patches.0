Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E3A20F6
	for <patches@lists.linux.dev>; Tue, 26 Sep 2023 05:54:37 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-690d25b1dbdso7065785b3a.2
        for <patches@lists.linux.dev>; Mon, 25 Sep 2023 22:54:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695707677; x=1696312477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3dY4iQ05Jpgj0v/7/dnf9FZuuddQ+ufy0Lt0k1nc7Hs=;
        b=fEp7IfgyHnUcKEAz0/zO7gsSvpsZpvqUcEvXG0CYHjzUTBOlMBmatPPewcBY2axtKi
         VBwfIXXebOR/jSerCnBzC4T6nr+Qw+ZDDvDin6Y4bHukXRuDg1TbfQIJ4QoeQ3vt9cF/
         M8SLVFwdF64tKZ0gmwQZT/DImbXRcWM+gaw7W5JcjSTswCtd28wqC1rWaVV2LPyDfJ7N
         kBvwpgfWzsmekkmN0mFn/etpk1fVDTXvhZoA0UBVJMEd3+iDQ+gV/iUAXmHlU/JyzzNz
         3ohtxETPQt213RS9yd9d8k1MC1lZGpzdDt3sWzbkk7npR9dFyt5d76xQ9ArM33G8SpYD
         cDrw==
X-Gm-Message-State: AOJu0YyU86LiHFzim5aSJnLUQnvHpl8jkOL4ae25OQrUgutz9XMP9rVC
	A5c7GkuGBGV4/SNvCCDUszY=
X-Google-Smtp-Source: AGHT+IFgn3+5rJgRk2N+N182GTYklfIHuPGT/K/du1PYKJBfSqVicqb6ZgalhcdlSnKCzbYuLscRDA==
X-Received: by 2002:a05:6a20:918a:b0:153:5366:dec1 with SMTP id v10-20020a056a20918a00b001535366dec1mr10756399pzd.15.1695707676866;
        Mon, 25 Sep 2023 22:54:36 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id n6-20020a170903110600b001c60c0dbb97sm4684819plh.17.2023.09.25.22.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 22:54:36 -0700 (PDT)
Date: Tue, 26 Sep 2023 05:54:34 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org, patches@lists.linux.dev,
	mikelley@microsoft.com, kys@microsoft.com, wei.liu@kernel.org,
	haiyangz@microsoft.com, decui@microsoft.com,
	apais@linux.microsoft.com, Tianyu.Lan@microsoft.com,
	ssengar@linux.microsoft.com, mukeshrathor@microsoft.com,
	stanislav.kinsburskiy@gmail.com, jinankjain@linux.microsoft.com,
	vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
	will@kernel.org, catalin.marinas@arm.com
Subject: Re: [PATCH v3 15/15] Drivers: hv: Add modules to expose /dev/mshv to
 VMMs running on Hyper-V
Message-ID: <ZRJyGrm4ufNZvN04@liuwe-devbox-debian-v2>
References: <1695407915-12216-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1695407915-12216-16-git-send-email-nunodasneves@linux.microsoft.com>
 <2023092342-staunch-chafe-1598@gregkh>
 <e235025e-abfa-4b31-8b83-416ec8ec4f72@linux.microsoft.com>
 <2023092630-masculine-clinic-19b6@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023092630-masculine-clinic-19b6@gregkh>

On Tue, Sep 26, 2023 at 06:52:46AM +0200, Greg KH wrote:
> On Mon, Sep 25, 2023 at 05:07:24PM -0700, Nuno Das Neves wrote:
> > On 9/23/2023 12:58 AM, Greg KH wrote:
> > > Also, drivers should never call pr_*() calls, always use the proper
> > > dev_*() calls instead.
> > > 
> > 
> > We only use struct device in one place in this driver, I think that is the
> > only place it makes sense to use dev_*() over pr_*() calls.
> 
> Then the driver needs to be fixed to use struct device properly so that
> you do have access to it when you want to print messages.  That's a
> valid reason to pass around your device structure when needed.

Greg, ACRN and Nitro drivers do not pass around the device structure.
Instead, they rely on a global struct device. We can follow the same.

Nuno, I checked our code. We already have a misc device. We can use that
for dev_* calls.

Something like this:

   dev_warn(mshv_dev.this_device, "this is a warning message");

This should resolve Greg's concern.

Thanks,
Wei.

> 
> thanks,
> 
> greg k-h
> 
