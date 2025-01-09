Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4131946A2
	for <patches@lists.linux.dev>; Thu,  9 Jan 2025 18:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736446143; cv=none; b=E2cJ3Z3tUxmuEL8OcGzuR2rggDIYcXGV14BDYbWZIEk9dm5Ju5C2PruR3JA+xIBERLy68zd4v1QNIdtYZ1JzDPdSHWF3zZcjwv4tc7LbCW9X5FjRdAr2ASdl5UUBSNdov9HO4xQcnplyEK9+rJggSALjMj32Y2VP9J/204yPzDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736446143; c=relaxed/simple;
	bh=LOWvfSAeFJX0TkK1ditU3Y3kWM44ZqKnQUa5HEDo+FA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gOER3/JY7xFAJYiLiBRf177UGy/5J0I5e3TYjKt68W3McSePSUvvm04TsDC8EltVrLQbrKCgTGjAw6XwPTgG7SEB4YUzh3J/7NlwYQzvVatS9ugEuWZPsW1GhDPDBP5OjuSmxk9TW8iORH6UfTBWnJgKhpJ5NxDwhnih0ly+NnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=d7fW30dY; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="d7fW30dY"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2f42992f608so1821122a91.0
        for <patches@lists.linux.dev>; Thu, 09 Jan 2025 10:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1736446141; x=1737050941; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OIBaW7JwdgjUdrWSxiA2g79nkPYvUF3i5zeAkytJz5k=;
        b=d7fW30dYIO3IJjvOvvfHkxSN4nzVVZaXK+nbn/oWMrpdlmbXtYcNbRpRqaAfgo5a1O
         HhUK+Uff0pTdWY2UkVWdyOeSqRxXYDwTnSsd61BaRGVwgdmRA5BfB7Vs5nYwPeaqnxdN
         STmjSLpV6tgXnchttDtajCptFGksOQgAIV8PS641+sEL60MZ9mquhuWQKaJSh5Noa8a6
         K6m78sBL2eHn21XjHlxkeCLCuMtJU9OBEb0h3rWvtEpEysif37s5c/fgMIQy7RVTC+Ly
         dFksFL89lIn9m726cq6ckiFDRR0gjGpIMNm75u/z36k5JeSgRndpJO0p9Y4bFp4SQaem
         SoyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736446141; x=1737050941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OIBaW7JwdgjUdrWSxiA2g79nkPYvUF3i5zeAkytJz5k=;
        b=cpQis8xkVVouR37cyFEBlsjhOlcvCRp8W/ZbzDSglUaEppckEhh+9k2kycKtq2PBUF
         qkSDGhRBhWHrSkfr7iavSmDG6K4oi7B7AA76wbp+Hlao8+MfPUv22Jr4JjoaTkZEZB6J
         nBQFCy8TX3hBPUP4u9r7n2ic/ai/aVstsdgGzhddUGlMYS3ZKNaEsUgLNccGFzmLruMy
         z0Wb7BIRzwiYLZj40aEHJIaYWFcw8p2nC+5+KL418TpDdEVPCgGxA6dyddhalAtMJHB7
         eBvxO57bAinrM8jjouJymJ3gsi1QPrgsKjh4/Bp9E17kBe8SZJ5vbjnJyRQDTpYiyPqY
         WUUA==
X-Forwarded-Encrypted: i=1; AJvYcCWBAgWwEHXRtBhcC70dA/rNZGpQCCk60iDPlmOFma7CTe2tg+POBmPqkwZMtbklIVi5a4j7D8VL@lists.linux.dev
X-Gm-Message-State: AOJu0Yx58McS8iEjF4LSzSofTmpsisJeJdG7vS26owpF+3pT+3N9kJrl
	9Z6urB3AT9bKGQHjrTXC2U/qA8joIopX8ykv5U21vGN0aZnHluNqreQanx742zZRq6EartJ0BOH
	AEpSqS2OXjtaMLcwrhGvvvNqb8cm7hZTVXC/yjA==
X-Gm-Gg: ASbGnctqazsROZ6JIkKZkL1Ir81t27Ot8kN+kmUXxQUGkyZcJBkOgO+K2FEOtf3/Sfa
	ypGj4D7KiliPkV6w48trxAwNl3HeN3JGsTO47Gn8=
X-Google-Smtp-Source: AGHT+IHGpZR26QegtJklr6eG/rvlcOSo3+gLEc+Ikyd9eF8cCninJpw3xD8uUVa4OVXN8ZVb/HbA5cEZc6Zxr8rGAm4=
X-Received: by 2002:a17:90b:4d05:b0:2ee:f80c:6884 with SMTP id
 98e67ed59e1d1-2f548f426ccmr11426719a91.33.1736446140970; Thu, 09 Jan 2025
 10:09:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106151150.585603565@linuxfoundation.org> <20250106151153.592449889@linuxfoundation.org>
 <3DB3A6D3-0D3A-4682-B4FA-407B2D3263B2@cloudflare.com> <2025010953-squeak-garlic-08de@gregkh>
In-Reply-To: <2025010953-squeak-garlic-08de@gregkh>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Thu, 9 Jan 2025 18:08:49 +0000
X-Gm-Features: AbW1kvYGPiZrbCwxQJQjhFIE2fo2ZXjftiSnUMFMG14at11sQreZWwrN_NTG8sc
Message-ID: <CALrw=nHC27RRxG7aPzzGNaknaHiDzXKSL7o+MLCY=kjNFzWX3g@mail.gmail.com>
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

On Thu, Jan 9, 2025 at 6:07=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jan 09, 2025 at 05:39:04PM +0000, Ignat Korchagin wrote:
> > Hi,
> >
> > > On 6 Jan 2025, at 15:14, Greg Kroah-Hartman <gregkh@linuxfoundation.o=
rg> wrote:
> > >
> > > 6.6-stable review patch.  If anyone has any objections, please let me=
 know.
> >
> > I think this back port breaks 6.6 build (namely vmlinux.o link stage):
> >   LD [M]  net/netfilter/xt_nat.ko
> >   LD [M]  net/netfilter/xt_addrtype.ko
> >   LD [M]  net/ipv4/netfilter/iptable_nat.ko
> >   UPD     include/generated/utsversion.h
> >   CC      init/version-timestamp.o
> >   LD      .tmp_vmlinux.kallsyms1
> > ld: vmlinux.o: in function `__crash_kexec':
> > (.text+0x15a93a): undefined reference to `machine_crash_shutdown'
> > ld: vmlinux.o: in function `__do_sys_kexec_file_load':
> > kexec_file.c:(.text+0x15cef1): undefined reference to `arch_kexec_prote=
ct_crashkres'
> > ld: kexec_file.c:(.text+0x15cf28): undefined reference to `arch_kexec_u=
nprotect_crashkres'
> > make[2]: *** [scripts/Makefile.vmlinux:37: vmlinux] Error 1
> > make[1]: *** [/home/ignat/git/test/mainline/linux-6.6.70/Makefile:1164:=
 vmlinux] Error 2
> > make: *** [Makefile:234: __sub-make] Error 2
> >
> > The KEXEC config setup, which triggers above:
> >
> > # Kexec and crash features
> > #
> > CONFIG_CRASH_CORE=3Dy
> > CONFIG_KEXEC_CORE=3Dy
> > # CONFIG_KEXEC is not set
> > CONFIG_KEXEC_FILE=3Dy
> > # CONFIG_KEXEC_SIG is not set
> > # CONFIG_CRASH_DUMP is not set
> > # end of Kexec and crash features
> > # end of General setup
>
> Odd, why has no one see this on mainline?  Are we missing a change
> somewhere or should this just be reverted for now?

I actually tested the mainline with this config and it works, so I
think we're missing a change

Ignat

> thanks,
>
> greg k-h
