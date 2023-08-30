Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CD66FA1
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 23:44:36 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-68bedc0c268so190921b3a.0
        for <patches@lists.linux.dev>; Wed, 30 Aug 2023 16:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693439076; x=1694043876; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Iloc+1foZTd3D7il1KXtcra5Lia6qDKnkjAXReM/7hY=;
        b=RTmWklR7x+zpQowuoj0AKxImjZmPL15tEhbLYvoudu1V/c8hW6Ur6uzGWPZ9xqdWq/
         ibgTXG1TwcH9XXM2ezdQ8WmCk1lCGSavAaDrnL3wzl03e8EcrujlvalIg07QE0cREDzC
         xcl6O/xSS7vXirSUEZyfwXHQtaV1DJVAIURuk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693439076; x=1694043876;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iloc+1foZTd3D7il1KXtcra5Lia6qDKnkjAXReM/7hY=;
        b=d7rjU9fHHggLAGSTYjcOgzf4zf6jBz0/cpGgDDk8e1vhxrboLAvo9+SWCJ97hN0Srb
         WmXiv76TihVTAkAyxKsW/9dLybsOO06STmC7oJU+bzulXv8x7TLVorntQDikP7SYhjEO
         TgZkhqWr1it7NQZi3nHpZ3WhNst0WIFHmRoXDMQH/EjkEgJhBIc6nYS0LhzUkmxPg49J
         HosEPQ+rNTp5H7NU1i26Ydc8r8PDvMoZbpODc+Hc2d2zveY1ltLwgpQBcdZVan8mJagp
         PURoSyUIMvKKI7rh1vykxnRFDDvBmExJC5KK/YHfOvEokpL7SP75R2/Js4sWSin5MjSF
         2Uvg==
X-Gm-Message-State: AOJu0YxhN7n+PoUCpugt8K2JKOdSxv2NfbHYPScSbB/A1pRJnfz26O2N
	9SnaVZquop19xy7p1upgHx1/QAopPLGXUKiI+E8=
X-Google-Smtp-Source: AGHT+IHYyQVG26HerVdU+4vxHN6Ebsm8IcJMnKrdHcXsURJ/juD8+fBTCoS9l7E6Cm3dE+6RAuDQ6g==
X-Received: by 2002:a05:6a21:66cb:b0:138:2fb8:6b42 with SMTP id ze11-20020a056a2166cb00b001382fb86b42mr3570828pzb.14.1693439076090;
        Wed, 30 Aug 2023 16:44:36 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id x26-20020aa784da000000b0064d57ecaa1dsm125836pfn.28.2023.08.30.16.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 16:44:35 -0700 (PDT)
Date: Wed, 30 Aug 2023 16:44:35 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, akpm@linux-foundation.org,
	Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
	Conor Dooley <conor@kernel.org>, ndesaulniers@google.com,
	trix@redhat.com, linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev, patches@lists.linux.dev, lkp@intel.com
Subject: Re: [PATCH] lib/Kconfig.debug: Restrict DEBUG_INFO_SPLIT for RISC-V
Message-ID: <202308301644.AABBE6694@keescook>
References: <20230816-riscv-debug_info_split-v1-1-d1019d6ccc11@kernel.org>
 <mhng-747958b0-514c-4fc8-ac37-0769562ba385@palmer-ri-x1c9>
 <20230830153646.GA954264@dev-arch.thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230830153646.GA954264@dev-arch.thelio-3990X>

On Wed, Aug 30, 2023 at 08:36:46AM -0700, Nathan Chancellor wrote:
> On Wed, Aug 30, 2023 at 06:22:45AM -0700, Palmer Dabbelt wrote:
> > On Wed, 16 Aug 2023 10:35:43 PDT (-0700), nathan@kernel.org wrote:
> > > When building for ARCH=riscv using LLVM < 14, there is an error with
> > > CONFIG_DEBUG_INFO_SPLIT=y:
> > > 
> > >   error: A dwo section may not contain relocations
> > > 
> > > This was worked around in LLVM 15 by disallowing '-gsplit-dwarf' with
> > > '-mrelax' (the default), so CONFIG_DEBUG_INFO_SPLIT is not selectable
> > > with newer versions of LLVM:
> > > 
> > >   $ clang --target=riscv64-linux-gnu -gsplit-dwarf -c -o /dev/null -x c /dev/null
> > >   clang: error: -gsplit-dwarf is unsupported with RISC-V linker relaxation (-mrelax)
> > > 
> > > GCC silently had a similar issue that was resolved with GCC 12.x.
> > > Restrict CONFIG_DEBUG_INFO_SPLIT for RISC-V when using LLVM or GCC <
> > > 12.x to avoid these known issues.
> > > 
> > > Link: https://github.com/ClangBuiltLinux/linux/issues/1914
> > > Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99090
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Closes: https://lore.kernel.org/all/202308090204.9yZffBWo-lkp@intel.com/
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > > Since this only impacts RISC-V, it seems reasonable that this would go
> > > in via their tree but I have added Andrew in case he wants to take it.
> > > ---
> > >  lib/Kconfig.debug | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > > index d6798513a8c2..bd51274f4771 100644
> > > --- a/lib/Kconfig.debug
> > > +++ b/lib/Kconfig.debug
> > > @@ -355,6 +355,11 @@ endchoice # "Compressed Debug information"
> > >  config DEBUG_INFO_SPLIT
> > >  	bool "Produce split debuginfo in .dwo files"
> > >  	depends on $(cc-option,-gsplit-dwarf)
> > > +	# RISC-V linker relaxation + -gsplit-dwarf has issues with LLVM and GCC
> > > +	# prior to 12.x:
> > > +	# https://github.com/llvm/llvm-project/issues/56642
> > > +	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99090
> > > +	depends on !RISCV || GCC_VERSION >= 120000
> > >  	help
> > >  	  Generate debug info into separate .dwo files. This significantly
> > >  	  reduces the build directory size for builds with DEBUG_INFO,
> > 
> > Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
> > Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
> > 
> > Not sure who's taking stuff for lib/Kconfig.debug, I can take it via the
> > RISC-V tree if folks are OK with it.  Kees and Andrew were the last to touch
> > it.
> 
> I don't think lib/Kconfig.debug has a formal maintainer. Given that and
> the fact that this change only affects RISC-V, I think it is entirely
> reasonable for you to take it.

Agreed -- got for it. :)

-- 
Kees Cook
