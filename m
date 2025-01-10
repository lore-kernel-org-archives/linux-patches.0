Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C076B209F3B
	for <patches@lists.linux.dev>; Fri, 10 Jan 2025 10:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736503559; cv=none; b=Nvcn752poq6hA3kn1+maPqIWlf/B24WLoYyQoYz2mF2N4NWq5RwhM8fwl6GNQtQ38ru+tQdyGg/nVoGRPn50jk4d5CPMAJjVQsupYZpDovXkGAOmzvGwDAlgfxChS1Tp7rox7ZaNQ5P842r6BhTIta4NVZ48gCAPWQ0e+Oo5co8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736503559; c=relaxed/simple;
	bh=zqWR6uUUhRzE5apPpzst4i3UCWD2C2Dw81UIiybH4k8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eZaWmGc99T9C1nob4in9PW8zQ42gV1dlFOvgJ48/s1PlHgnvZT0n3/b1vrzeiegAa4OfZCWdOH9o6wuaxgFj6w7sgxK5Vw9GfAVFskq2RmjnQ4IOyNMLuu2CXvPq0YbK7JXyLPmwVHJbVlJHszLoYJkLiMvw6lKBPc3xMRHJDkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=bNNhd62Y; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="bNNhd62Y"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21619108a6bso30712995ad.3
        for <patches@lists.linux.dev>; Fri, 10 Jan 2025 02:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1736503557; x=1737108357; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6/OtJufzLaqyKcYD/pgKEeBnjxZ49eDu4/BDU+oB74=;
        b=bNNhd62Y3nL4/bewZ6OWajINCIa5cWHKonQeyFm4AD2mIWlpyrfZWbxxFdtVhOvC02
         KdiQdgg7zw1na3g6AmLTf3biim3pIzTzjv62/YCncFsrQI0gBA3D6n4CnMRH9b0lORHu
         0wxfkwtDzXKf1+5HaZ5c8h+vaN7DwM0Ud1gZ3mQUPhy0lbpmXgGoc8WdXoGUY9SU5OaW
         XfP1bKgCzllgxLVtAvLV6kwx5NY965nIs66deBTnoQw9ghjmaN6Mg6QcC6OGNMFoauxr
         UohbuAwiWMEpkuXFs0eOl03wzd1bWO1M0sMf0djsH8TTW6yTBev3W4IaUFlCBw/S2ye9
         4iUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736503557; x=1737108357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F6/OtJufzLaqyKcYD/pgKEeBnjxZ49eDu4/BDU+oB74=;
        b=WbCu7MrOyUvrhWlsXxQP6fq1HHdjC7u+OmRW50hyITH9CoXzuDH0322/cxPT8UA9W8
         /qpRseqhvx8RhfPyE+KUp1h5h0256swDPb9gtP16jg8/DFkf9VzMeQT+UN7Ql8D99r55
         EA0NWlaOAZmFCozrM6P6/J5ZTU66NOSVJbgvoRHiTcwI6hNdovd8IvvTGES5gnw2f0e9
         4j4/EJNDhCtlNwMUw7OlurlFdngbL9iV82Kw1xqBjYGC2siTSKUyXyegsgWptRYJQRcS
         tONAd2rx8oBK/ZW60/ElVmX+KEILABGY56d85zOpJ4MAW+Sy+EwuFmjx+ywkRBs1LMF1
         caJg==
X-Forwarded-Encrypted: i=1; AJvYcCW3sXRKm10ZlmmTIJNeMrUWOLR3/T/TZ+p5OyrxSKqnaoN2fsbaOVOhuAhEc5OUPXIu6J5l9egN@lists.linux.dev
X-Gm-Message-State: AOJu0YxIWKtSvFmmHA9Hq4LGV2FONjeJIi/tYQSBVTngeMYsZMIAAtsF
	GPaabMmC71zJnUSC8RZ5RheG+wHpe8mj+rnJ9ZrpYett1UKYJ3slTYNR2FfdFbepZAEMS1ujlOs
	PYSvoXgm1FpHjjCHW53O5itQkKiys2Raoayspjg==
X-Gm-Gg: ASbGncuJZ+12vze7n3euW7uWo/NM7JuQCURaY2psI5ku05ldnNyyu5vv37QXdoTPvpw
	NacrIEY6JjmmEAG9tBpQ9crr3PKyPfgu2L9rcFqoK014GWLX+Q/pP8g==
X-Google-Smtp-Source: AGHT+IE9wZ2CoJEw9/XLgi3IcaR7qp0BfvyjD0qLw7ghplmpAZyxf7VjUplqDtECXqeNM7nT7jYGlL3Orq+vuGYeXt8=
X-Received: by 2002:a17:90b:224a:b0:2ee:49c4:4a7c with SMTP id
 98e67ed59e1d1-2f548ec8a4emr15689661a91.18.1736503557095; Fri, 10 Jan 2025
 02:05:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106151150.585603565@linuxfoundation.org> <20250106151153.592449889@linuxfoundation.org>
 <3DB3A6D3-0D3A-4682-B4FA-407B2D3263B2@cloudflare.com> <2025010953-squeak-garlic-08de@gregkh>
 <CALrw=nHC27RRxG7aPzzGNaknaHiDzXKSL7o+MLCY=kjNFzWX3g@mail.gmail.com>
 <CALrw=nG+_KyvPiKBnZOVin4XL4fbwiKWj6=o2x0rMELQBpP9iQ@mail.gmail.com> <2025011043-tiny-debit-4507@gregkh>
In-Reply-To: <2025011043-tiny-debit-4507@gregkh>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Fri, 10 Jan 2025 10:05:45 +0000
X-Gm-Features: AbW1kvZ7WkVF351a-eB2b9dFvPyEnzanKaQ75tdCkxSKBn1KX90cHAQAhdWU3Kc
Message-ID: <CALrw=nERvgZSsSrex9c11k8ejbq36sYQsjw9MTA8pjC7h0hZ+Q@mail.gmail.com>
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

On Fri, Jan 10, 2025 at 9:58=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jan 09, 2025 at 08:44:43PM +0000, Ignat Korchagin wrote:
> > On Thu, Jan 9, 2025 at 6:08=E2=80=AFPM Ignat Korchagin <ignat@cloudflar=
e.com> wrote:
> > >
> > > On Thu, Jan 9, 2025 at 6:07=E2=80=AFPM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Thu, Jan 09, 2025 at 05:39:04PM +0000, Ignat Korchagin wrote:
> > > > > Hi,
> > > > >
> > > > > > On 6 Jan 2025, at 15:14, Greg Kroah-Hartman <gregkh@linuxfounda=
tion.org> wrote:
> > > > > >
> > > > > > 6.6-stable review patch.  If anyone has any objections, please =
let me know.
> > > > >
> > > > > I think this back port breaks 6.6 build (namely vmlinux.o link st=
age):
> > > > >   LD [M]  net/netfilter/xt_nat.ko
> > > > >   LD [M]  net/netfilter/xt_addrtype.ko
> > > > >   LD [M]  net/ipv4/netfilter/iptable_nat.ko
> > > > >   UPD     include/generated/utsversion.h
> > > > >   CC      init/version-timestamp.o
> > > > >   LD      .tmp_vmlinux.kallsyms1
> > > > > ld: vmlinux.o: in function `__crash_kexec':
> > > > > (.text+0x15a93a): undefined reference to `machine_crash_shutdown'
> > > > > ld: vmlinux.o: in function `__do_sys_kexec_file_load':
> > > > > kexec_file.c:(.text+0x15cef1): undefined reference to `arch_kexec=
_protect_crashkres'
> > > > > ld: kexec_file.c:(.text+0x15cf28): undefined reference to `arch_k=
exec_unprotect_crashkres'
> > > > > make[2]: *** [scripts/Makefile.vmlinux:37: vmlinux] Error 1
> > > > > make[1]: *** [/home/ignat/git/test/mainline/linux-6.6.70/Makefile=
:1164: vmlinux] Error 2
> > > > > make: *** [Makefile:234: __sub-make] Error 2
> > > > >
> > > > > The KEXEC config setup, which triggers above:
> > > > >
> > > > > # Kexec and crash features
> > > > > #
> > > > > CONFIG_CRASH_CORE=3Dy
> > > > > CONFIG_KEXEC_CORE=3Dy
> > > > > # CONFIG_KEXEC is not set
> > > > > CONFIG_KEXEC_FILE=3Dy
> > > > > # CONFIG_KEXEC_SIG is not set
> > > > > # CONFIG_CRASH_DUMP is not set
> > > > > # end of Kexec and crash features
> > > > > # end of General setup
> > > >
> > > > Odd, why has no one see this on mainline?  Are we missing a change
> > > > somewhere or should this just be reverted for now?
> > >
> > > I actually tested the mainline with this config and it works, so I
> > > think we're missing a change
> > >
> > > Ignat
> >
> > >From the looks of it it is missing 02aff8480533 ("crash: split crash
> > dumping code out from kexec_core.c")
>
> Ok, I can duplicate this here now, but wow, backporting that commit is
> not going to work.  Let me see if I can just revert a few things
> instead...

Yeah, I tried that yesterday, but saw it is not that trivial. Thank you!

> thanks for the .config section, that helped out a lot!
>
> greg k-h
