Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABF741227
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 23:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DugbmtQr"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-40b51e26a7aso11045e9.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 15:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701819593; x=1702424393; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tSWCSu+uiAqROdUkMO1B316jZcgb431g6mYLbAjqo80=;
        b=DugbmtQrjyNajgXHSlUO/iscC+asM67rl88pKVjXWNHI6Y8sajHVcrU92wHb9OBRua
         7rgeq2LbVMbOzRJGZDRBwvgSLBepiq+S+Aug6h/mTddBEXhUsUaK2Y/vhiJSgwWHMOU4
         2Oq6L4QZj1l2eXniCmqi1r9zaFxBxMyOx+XMKiDof9GFcxq+qIXXiFBjhaRM1OllZr2T
         yJJu5I4kKnU7Rwd1QByF3o3L/FCWs79ThONRx4l+EciWOYE5sYAWpEjxBs4uQhA344yF
         HN7d0D7qCAghHMuMH2nIWuYpO0AwJLK+U+jitPz8BjlWvoRflcLsUicNks+UeLRVaBfd
         dURw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701819593; x=1702424393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tSWCSu+uiAqROdUkMO1B316jZcgb431g6mYLbAjqo80=;
        b=QUWDg4ZXmHa+fAZIezimCodMvPOpmgfRIjG44XaWW8ajq132rXniD+c8o3hAwy7D7J
         qbpLmLa8F3nC2qcMNpA1cGP9dHVM1DnBlPh+7EZcklKsi2xo6+QcIG7CgixN7Me1lKSi
         uFM0ghMeMd5yz8xZI+QPD+ImoSlEJP7AwcbaN5dNZtNWtpbyoXFHyUK2VdduX7zcY3wx
         uWlo6xJXW14w4AeD1eUAgDVPpkkmYMT/muT0MRQ9hGA4chsETHfSwmuD4nl2HF7VlaFX
         EgaDMZ1u051HHhVg/wJIeBQTXzjAJqdWBrLuZXAfhGaR3BYXgCiBqaFZAZztiG39Hudd
         Kz7Q==
X-Gm-Message-State: AOJu0YxbuqJ9l8RaTOD5FPXY0I2cyEf5dioPEliYPOT4FRG97anLGxcl
	vI9/CfgkHVdCoDB/QJZMywc/Dr6xF1MwIgGHkf5E0g==
X-Google-Smtp-Source: AGHT+IF8mDldPOjjvLBVwxyoBmhqdFoqGknCkdePsEll3+maAHtLGMnd7XmU96mZreg/qdTS7mVk+MDJmUNb3enDW1M=
X-Received: by 2002:a05:600c:3b22:b0:40b:4355:a04b with SMTP id
 m34-20020a05600c3b2200b0040b4355a04bmr32914wms.6.1701819592988; Tue, 05 Dec
 2023 15:39:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231129-riscv-restrict-dwarf5-llvm-v1-0-ec0d368fb538@kernel.org>
 <20231129-riscv-restrict-dwarf5-llvm-v1-2-ec0d368fb538@kernel.org>
 <CAFP8O3JscgacLPX-_pc2J0uhqk=ehtxSNStzo7PwewPSuXkxiw@mail.gmail.com>
 <20231201194858.GA290910@dev-arch.thelio-3990X> <CAFP8O3+uta+GQO7dpeNLe0OMFnX-tdEyvHREEu1ThjA3nFtTkQ@mail.gmail.com>
 <20231201215021.GA2579712@dev-arch.thelio-3990X> <CAFP8O3LJPqPVxcRzi_Qxvu_w8w76BXmfWv8YnsK+bMvqXb701Q@mail.gmail.com>
 <20231204231155.GA3560411@dev-arch.thelio-3990X>
In-Reply-To: <20231204231155.GA3560411@dev-arch.thelio-3990X>
From: Fangrui Song <maskray@google.com>
Date: Tue, 5 Dec 2023 15:39:39 -0800
Message-ID: <CAFP8O3Kgzt=fdOLH+TG1vDTfNzY_-YebhsdAgPJ7XJ+x7qO1ow@mail.gmail.com>
Subject: Re: [PATCH 2/2] riscv: Restrict DWARF5 when building with LLVM to
 known working versions
To: Nathan Chancellor <nathan@kernel.org>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	conor@kernel.org, ndesaulniers@google.com, linux-riscv@lists.infradead.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 4, 2023 at 3:12=E2=80=AFPM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> On Fri, Dec 01, 2023 at 08:31:12PM -0800, Fangrui Song wrote:
> > Perhaps: Clang generates .uleb128 with label differences for DWARF v5,
> > a feature that older binutils ports, utilizing RISC-V style linker
> > relaxation, do not support.
> >
> > (Signed LEB128 is used by DWARF as well, but it is encoded directly
> > into DW_OP_fbreg/DW_LNS_advance_line/etc, and explicit .sleb128
> > directives are not emitted)
> > (In assemblers, "label difference" is a more common term.)
> > (People working on DWARF tend to prefer DWARF v5 to DWARF5, when the
> > full "DWARF version 5" feels too verbose.)
>
> Thanks, does this diff seem reasonable to you? I'd like to keep the
> issue link as a paper trail and I figured that we might as well make the
> configuration name slightly more accurate with that additional
> information. I will send it as a separate patch in v2 tomorrow if so in
> order to give people a chance to further chime in on the series.
>
> Cheers,
> Nathan
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index a0ebce05a368..76c2cc697573 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -231,9 +231,10 @@ config DEBUG_INFO
>           in the "Debug information" choice below, indicating that debug
>           information will be generated for build targets.
>
> -# Clang is known to generate .{s,u}leb128 with symbol deltas with DWARF5=
, which
> -# some targets may not support: https://sourceware.org/bugzilla/show_bug=
.cgi?id=3D27215
> -config AS_HAS_NON_CONST_LEB128
> +# Clang generates .uleb128 with label differences for DWARF v5, a featur=
e that
> +# older binutils ports do not support when utilizing RISC-V style linker
> +# relaxation: https://sourceware.org/bugzilla/show_bug.cgi?id=3D27215
> +config AS_HAS_NON_CONST_ULEB128
>         def_bool $(as-instr,.uleb128 .Lexpr_end4 - .Lexpr_start3\n.Lexpr_=
start3:\n.Lexpr_end4:)
>
>  choice
> @@ -258,7 +259,7 @@ config DEBUG_INFO_NONE
>  config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
>         bool "Rely on the toolchain's implicit default DWARF version"
>         select DEBUG_INFO
> -       depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 |=
| (AS_IS_GNU && AS_VERSION >=3D 23502 && AS_HAS_NON_CONST_LEB128)
> +       depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 |=
| (AS_IS_GNU && AS_VERSION >=3D 23502 && AS_HAS_NON_CONST_ULEB128)
>         help
>           The implicit default version of DWARF debug info produced by a
>           toolchain changes over time.
> @@ -283,7 +284,7 @@ config DEBUG_INFO_DWARF5
>         bool "Generate DWARF Version 5 debuginfo"
>         select DEBUG_INFO
>         depends on !ARCH_HAS_BROKEN_DWARF5
> -       depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION=
 >=3D 23502 && AS_HAS_NON_CONST_LEB128)
> +       depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION=
 >=3D 23502 && AS_HAS_NON_CONST_ULEB128)
>         help
>           Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0=
+ (gcc
>           5.0+ accepts the -gdwarf-5 flag but only had partial support fo=
r some

This diff looks good to me.


--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
