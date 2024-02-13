Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC34411C83
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 05:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707802328; cv=none; b=W+Wl3u3Yph/2uiYzj4D7DAftTZLRNCK+fGAsV+dI8ounPEbp1VSK5itFBVKF50iHOjEd6cwL8jDnNtw2gM9VQPoqfD0qoiNigD2+xnKXZ6T8wUY8/hlEuxhgE1roxbsu2WehAtCeqVVTRqExR3VCGE1FHgOqPJmQUuAs5HAyvc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707802328; c=relaxed/simple;
	bh=mA1g3ztIrrBkockXGX61+9oeZE/SSsqqxSwzue3DwC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uP/czcYtcLACKTcz34uxFCFcZQ3eVErgpm2r+Tir8FhU4XTt7nKk+2rQ5rngAiW4FQ/mKoxAKszlOoXBOK7K3DCc89ovmhentXxmRf6A5QR1/LkvbO10+so+u88kSgpUQnKF0m+AnFf9l1mVo+r0sw/6/E6WbTiYM63nojgLqYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fEAJvfEk; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fEAJvfEk"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-40f0218476aso23595e9.1
        for <patches@lists.linux.dev>; Mon, 12 Feb 2024 21:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707802325; x=1708407125; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/uGxhCM1MdcJFnYKRZ4H5uYyqjD3LQ1oI9REjxtPAas=;
        b=fEAJvfEkCArbhbWlwGs+wSZiYjJ0x1YUnby0K1IzdneeeGdTyLXsrdSqntatfQNWc1
         RV/fgeflXv4EhwBzEPMhKv8r1Zqjb9rAl2szuFgnbwsKaqsJMYrVEOIoMxfMQyPY2R2Y
         4kGINSft7sJvieYKcnW+u2q+RDOlqB4YAu9vdqPvE6q2JItT9Spa2z5HiiCiuPQBAxQ2
         mi7FqA3ybaeocYZwhZG2z66718D+yTUED5mPV6GpG35rGrg/hFWblG2g+5sGPhB2l69J
         KetLIG0uj8Pf4ekswwyFn3uVL3EA8oh0gtvTbeCZqFlkdu3pt8MGb5HOXQG+zE+KlVKZ
         qdPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707802325; x=1708407125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/uGxhCM1MdcJFnYKRZ4H5uYyqjD3LQ1oI9REjxtPAas=;
        b=pKz35yxCcSG1z3m9RfTyHrC8OI1fVanwrjhLbr5oHG2gv2FvxFvP73+FNqFjk6zmMj
         1C39Wzr3PUSb6JPO1iDYxT5PVpssdEzkvKyNmrrezFXvU+SO6mude5q9/6/1ANM1Cv8g
         DNLFq1I0bvLDLswesDVGLXT1unpS0pMteWNhG8hTloHiv6g5w6Myb1T9qYGvpjZlgasM
         sFXnUI8TNmElWNhoA9Hy/Viu1B5SnMH0HuYLNiqmgWMwcfIxTloIlbn/kDUwEJXorsW4
         mpFrtgDNgfgz5ypExIqPXabkLquCQpduLWBLallBozRxPMdf+FdH0D2VtIUK/w0z63PH
         lByQ==
X-Gm-Message-State: AOJu0YxQnN6mwnQIi82mJjoFYA5fywn7YzTY79t07JSUB67uqIeC/n/k
	nGJ7Rmf+1mozJ2mz7VxCkbDnuYaHX+EdAHeuKkbYJNHCdv0PT1dKLsZ0xjl6wNOkF3s+yITcdbS
	ZTIrHDAtJXUv9wzUYQd6HEE3iVhFwI3C29EkL
X-Google-Smtp-Source: AGHT+IEaPMLN67YL+DXqKdgepRD4xM/SrPXG1yc2zqO33nupBblqrP0TTTLzZpgw1FDdMm9kVwRaeXJGaEAy18xsjrw=
X-Received: by 2002:a05:600c:3d8e:b0:410:802c:2d43 with SMTP id
 bi14-20020a05600c3d8e00b00410802c2d43mr71596wmb.4.1707802324902; Mon, 12 Feb
 2024 21:32:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240207-s390-lld-and-orphan-warn-v1-0-8a665b3346ab@kernel.org> <20240207-s390-lld-and-orphan-warn-v1-3-8a665b3346ab@kernel.org>
In-Reply-To: <20240207-s390-lld-and-orphan-warn-v1-3-8a665b3346ab@kernel.org>
From: Fangrui Song <maskray@google.com>
Date: Mon, 12 Feb 2024 21:31:53 -0800
Message-ID: <CAFP8O3KHsjCWowDTBxOq7GQ3bdsA2tAMO5Y4YfKR374Dz_Z54g@mail.gmail.com>
Subject: Re: [PATCH 03/11] s390: vmlinux.lds.S: Explicitly handle '.got' and
 '.plt' sections
To: Nathan Chancellor <nathan@kernel.org>
Cc: hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, ndesaulniers@google.com, 
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 7, 2024 at 4:15=E2=80=AFPM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> When building with CONFIG_LD_ORPHAN_WARN after selecting
> CONFIG_ARCH_HAS_LD_ORPHAN_WARN, there are a lot of warnings around the
> GOT and PLT sections:
>
>   s390-linux-ld: warning: orphan section `.plt' from `arch/s390/kernel/he=
ad64.o' being placed in section `.plt'
>   s390-linux-ld: warning: orphan section `.got' from `arch/s390/kernel/he=
ad64.o' being placed in section `.got'
>   s390-linux-ld: warning: orphan section `.got.plt' from `arch/s390/kerne=
l/head64.o' being placed in section `.got.plt'
>   s390-linux-ld: warning: orphan section `.iplt' from `arch/s390/kernel/h=
ead64.o' being placed in section `.iplt'
>   s390-linux-ld: warning: orphan section `.igot.plt' from `arch/s390/kern=
el/head64.o' being placed in section `.igot.plt'
>
>   s390-linux-ld: warning: orphan section `.iplt' from `arch/s390/boot/hea=
d.o' being placed in section `.iplt'
>   s390-linux-ld: warning: orphan section `.igot.plt' from `arch/s390/boot=
/head.o' being placed in section `.igot.plt'
>   s390-linux-ld: warning: orphan section `.got' from `arch/s390/boot/head=
.o' being placed in section `.got'
>
> Currently, only the '.got' section is actually emitted in the final
> binary. In a manner similar to other architectures, put the '.got'
> section near the '.data' section and coalesce the PLT sections,
> checking that the final section is zero sized, which is a safe/tested
> approach versus full discard.
>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/s390/boot/vmlinux.lds.S   | 19 +++++++++++++++++++
>  arch/s390/kernel/vmlinux.lds.S | 19 +++++++++++++++++++
>  2 files changed, 38 insertions(+)
>
> diff --git a/arch/s390/boot/vmlinux.lds.S b/arch/s390/boot/vmlinux.lds.S
> index 389df0e0d9e5..4aa2f340c8d9 100644
> --- a/arch/s390/boot/vmlinux.lds.S
> +++ b/arch/s390/boot/vmlinux.lds.S
> @@ -39,6 +39,9 @@ SECTIONS
>                 *(.rodata.*)
>                 _erodata =3D . ;
>         }
> +       .got : {
> +               *(.got)
> +       }
>         NOTES
>         .data : {
>                 _data =3D . ;
> @@ -118,6 +121,22 @@ SECTIONS
>         }
>         _end =3D .;
>
> +       /*
> +        * Sections that should stay zero sized, which is safer to
> +        * explicitly check instead of blindly discarding.
> +        */
> +       .got.plt : {
> +               *(.got.plt)
> +       }
> +       ASSERT(SIZEOF(.got.plt) =3D=3D 0, "Unexpected GOT/PLT entries det=
ected!")
> +       .plt : {
> +               *(.plt)
> +               *(.plt.*)
> +               *(.iplt)
> +               *(.igot .igot.plt)
> +       }
> +       ASSERT(SIZEOF(.plt) =3D=3D 0, "Unexpected run-time procedure link=
ages detected!")
> +

It seems that arches that drop .plt typically place input section
description on one line. This saves vertical space.
It's shorter to use one input section description to match multiple
sections, e.g.

    *(.plt .iplt)

In GNU ld, .igot  is part of .got (RW data), so placing .igot in .plt
(code) looks strange.


>         /* Sections to be discarded */
>         /DISCARD/ : {
>                 *(.eh_frame)
> diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.ld=
s.S
> index d231a3faf981..661a487a3048 100644
> --- a/arch/s390/kernel/vmlinux.lds.S
> +++ b/arch/s390/kernel/vmlinux.lds.S
> @@ -62,6 +62,9 @@ SECTIONS
>         .data.rel.ro : {
>                 *(.data.rel.ro .data.rel.ro.*)
>         }
> +       .got : {
> +               *(.got)
> +       }
>
>         . =3D ALIGN(PAGE_SIZE);
>         _sdata =3D .;             /* Start of data section */
> @@ -241,6 +244,22 @@ SECTIONS
>         DWARF_DEBUG
>         ELF_DETAILS
>
> +       /*
> +        * Sections that should stay zero sized, which is safer to
> +        * explicitly check instead of blindly discarding.
> +        */
> +       .got.plt : {
> +               *(.got.plt)
> +       }
> +       ASSERT(SIZEOF(.got.plt) =3D=3D 0, "Unexpected GOT/PLT entries det=
ected!")
> +       .plt : {
> +               *(.plt)
> +               *(.plt.*)
> +               *(.iplt)
> +               *(.igot .igot.plt)
> +       }
> +       ASSERT(SIZEOF(.plt) =3D=3D 0, "Unexpected run-time procedure link=
ages detected!")
> +
>         /* Sections to be discarded */
>         DISCARDS
>         /DISCARD/ : {
>
> --
> 2.43.0
>


--
=E5=AE=8B=E6=96=B9=E7=9D=BF
