Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DDF1FE454
	for <patches@lists.linux.dev>; Thu,  9 Jan 2025 20:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736455496; cv=none; b=YN8f9Azl8gnMEljbze4qOub2xves2ePvN6C7UeAUfHYPHzVcB1C8lEAcW1vXYvXZ4V3h8uoLTptgvFA3wYUUvy2Dnx8Esc14BIoNNw3X3Ooby+yqlZwSV74qVh7i76yCBq3SUCrJWShiCsqkATNVMfOovrneguGvR4/nF09OMLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736455496; c=relaxed/simple;
	bh=AlRB6GfwaGyq6rK14nL1W5hFUWrwYyTuo8YTIqAZWhw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IbFzsAp6lwSxq6giJFfaQCj80THq1pXL3MSiEXH1gGMUg/gEXoxY6TW+nO5zjpVtwNuyRSWM7b4L5gzd0XLDrOTZGhajhZdo/ciJF0lLpiaM5PW6CjEDAqB1IPmb9zUa9X7whemtbqj6uTcozZKX4ZdZRArZ9axOSEdXYJ4/0gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=YpgVEgXq; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="YpgVEgXq"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-21649a7bcdcso21535485ad.1
        for <patches@lists.linux.dev>; Thu, 09 Jan 2025 12:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1736455494; x=1737060294; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahDuKardNqhYr55KFBv/RB6jvPta03a89PwG7tSKRMk=;
        b=YpgVEgXqfiI2gzgAC9dfMFyphxlocsi0TQ1OourhkjaEhQMKXPOhGJwYQ2PVDfqZzo
         Gh0e+JpIzJPWojlI2PVe6YH7qKtK6uzS12k7WaSeHwy7aAsdLWJ+FlgjfoxFbKvPewxE
         2sBAqjbypN1kOOFEQzwoL4RDVIFgkU/zqeRkGmfhpiBmXn7IebnAjzhobeDQXvJeBW5Q
         JPLGXGsM8Dm5Te+w4hYhWA3swG77Uk5BdOu0QMJ9LajptX2azlY4DFnG6kUFWobrXUJV
         QkDyjCLo/LsJJBhtoI+AG3srGNoGtBlYhi+c57bvweDpyrE+bL6m7jqoK9Kf859whaRO
         03bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736455494; x=1737060294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ahDuKardNqhYr55KFBv/RB6jvPta03a89PwG7tSKRMk=;
        b=Xzs5bFXnVQqpih8XGyLKqpXvc6r9zdvW2KLEq1BGtNfRzGpmm80dKiInRy4XBGOzZ/
         n0yqKF2x9U3I0MPRR+uZwLMNj8JdOzEOKa4RpaWPG7LaR4qVHEO6Nu7kcAfcCsksEC2T
         KBjfUrtDglaSb+lmvXKDmNzJq3JWE0YYa3l9q+1gKrwq/+ywKp5BW6BsnR8jUHdhme0g
         ih+Udegn1Gf7SkAg4+R+kwRntzndO2qiqTD4UT5Vec+p4cwErOxcNKv7EpDzYZuiz9lO
         6vLuOniT/EXIMKgRjq0+InftSzOpCBgfzo2cIdIY2WEnXDKpSoiOfqPRX9OSk1fPuil6
         iOSA==
X-Forwarded-Encrypted: i=1; AJvYcCV4HSSSFHf3POBTTKUXN6t750qspPurw0UDYMpOY7GMRQmTFalhCE4qJOhlva0m/XmoRo82LSiZ@lists.linux.dev
X-Gm-Message-State: AOJu0YyWs8p8RPv2I0bNLw903IaBzoJRSRQU1NQhoxLFcsKXzh8MX+6d
	xVVNFXaDoDTrls+YTNWtYuxQ1m3JttsgEHRt1c2J85uPD8UcAA6B+BFjtGvpcW/ehVMi+1yjkyx
	WeWlfxwM3rlRfmW/zLI+qzuzr50gzF1mKobDckw==
X-Gm-Gg: ASbGncskqSCaoV5AURKcM0k+p6Z2k90cHDotmGiIY0eJfd8XWWP9Wj/8i674oZDjd6C
	YdKgOKS4E0Ht3rGm2mwgP1GxCE1/g3zrhYbj2NJ1feGrG09y5NPFIuSAN
X-Google-Smtp-Source: AGHT+IHqEioSHkNL1QwCoj1k4S6AIOOZsZNefbwDOM2EBkfs99GFRbuIr6UtwlzDW8FB/CGWz0fT1OsoIsbLZUS7JlM=
X-Received: by 2002:a17:902:e843:b0:216:2e5e:971d with SMTP id
 d9443c01a7336-21a83fd9648mr118906185ad.51.1736455494138; Thu, 09 Jan 2025
 12:44:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106151150.585603565@linuxfoundation.org> <20250106151153.592449889@linuxfoundation.org>
 <3DB3A6D3-0D3A-4682-B4FA-407B2D3263B2@cloudflare.com> <2025010953-squeak-garlic-08de@gregkh>
 <CALrw=nHC27RRxG7aPzzGNaknaHiDzXKSL7o+MLCY=kjNFzWX3g@mail.gmail.com>
In-Reply-To: <CALrw=nHC27RRxG7aPzzGNaknaHiDzXKSL7o+MLCY=kjNFzWX3g@mail.gmail.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Thu, 9 Jan 2025 20:44:43 +0000
X-Gm-Features: AbW1kvYLVO-L7A46WopjdwtP3JEd5FzxIeMx9vTMMz3FZNGugIv997wxNF9MKk8
Message-ID: <CALrw=nG+_KyvPiKBnZOVin4XL4fbwiKWj6=o2x0rMELQBpP9iQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 079/222] x86, crash: wrap crash dumping code into
 crash related ifdefs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Baoquan He <bhe@redhat.com>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, 
	Hari Bathini <hbathini@linux.ibm.com>, Pingfan Liu <piliu@redhat.com>, 
	Klara Modin <klarasmodin@gmail.com>, Michael Kelley <mhklinux@outlook.com>, 
	Nathan Chancellor <nathan@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Yang Li <yang.lee@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Sasha Levin <sashal@kernel.org>, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 9, 2025 at 6:08=E2=80=AFPM Ignat Korchagin <ignat@cloudflare.co=
m> wrote:
>
> On Thu, Jan 9, 2025 at 6:07=E2=80=AFPM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Jan 09, 2025 at 05:39:04PM +0000, Ignat Korchagin wrote:
> > > Hi,
> > >
> > > > On 6 Jan 2025, at 15:14, Greg Kroah-Hartman <gregkh@linuxfoundation=
.org> wrote:
> > > >
> > > > 6.6-stable review patch.  If anyone has any objections, please let =
me know.
> > >
> > > I think this back port breaks 6.6 build (namely vmlinux.o link stage)=
:
> > >   LD [M]  net/netfilter/xt_nat.ko
> > >   LD [M]  net/netfilter/xt_addrtype.ko
> > >   LD [M]  net/ipv4/netfilter/iptable_nat.ko
> > >   UPD     include/generated/utsversion.h
> > >   CC      init/version-timestamp.o
> > >   LD      .tmp_vmlinux.kallsyms1
> > > ld: vmlinux.o: in function `__crash_kexec':
> > > (.text+0x15a93a): undefined reference to `machine_crash_shutdown'
> > > ld: vmlinux.o: in function `__do_sys_kexec_file_load':
> > > kexec_file.c:(.text+0x15cef1): undefined reference to `arch_kexec_pro=
tect_crashkres'
> > > ld: kexec_file.c:(.text+0x15cf28): undefined reference to `arch_kexec=
_unprotect_crashkres'
> > > make[2]: *** [scripts/Makefile.vmlinux:37: vmlinux] Error 1
> > > make[1]: *** [/home/ignat/git/test/mainline/linux-6.6.70/Makefile:116=
4: vmlinux] Error 2
> > > make: *** [Makefile:234: __sub-make] Error 2
> > >
> > > The KEXEC config setup, which triggers above:
> > >
> > > # Kexec and crash features
> > > #
> > > CONFIG_CRASH_CORE=3Dy
> > > CONFIG_KEXEC_CORE=3Dy
> > > # CONFIG_KEXEC is not set
> > > CONFIG_KEXEC_FILE=3Dy
> > > # CONFIG_KEXEC_SIG is not set
> > > # CONFIG_CRASH_DUMP is not set
> > > # end of Kexec and crash features
> > > # end of General setup
> >
> > Odd, why has no one see this on mainline?  Are we missing a change
> > somewhere or should this just be reverted for now?
>
> I actually tested the mainline with this config and it works, so I
> think we're missing a change
>
> Ignat

From the looks of it it is missing 02aff8480533 ("crash: split crash
dumping code out from kexec_core.c")

Ignat

> > thanks,
> >
> > greg k-h
