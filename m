Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473BD27BF7C
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 08:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756801774; cv=none; b=mFllF1hkaaHZef5dMXVXXWVnFjApbAUWmVIV7MSkAMm/P3TBF7B/MzU7hdvvp1LUIBIbRkJUolIJRsgYbQx5jtkvTyja8vQRW3IA7ovdzB0iFUHU3bYe0qcxrH34krUgZ7Sd+6xmhwD+5LSCHo+dx7OZYiQFGV5YIhH/hImQ1U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756801774; c=relaxed/simple;
	bh=mz6MChWAhIh1fUS9YL3zMQPODRH3xmYPsKPrGEnKmVE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U8JrZ84OF1cj5n32ojDFb4K6wHTFTR+HsVrZMdt9FMrkCyxBChrKMEUah5fBC5nBJ+peu7Jzank/FPGGaLVPsYPoXsBz33hxqaxAHl4TvTtjS6QN2TSvPFjwFx8aY5xRTvexjf8NXouJ6MZ2A/PBGxUik1cjloADQ6X/cFVE7/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2SHWmy4p; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2SHWmy4p"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45b920e0c25so7074225e9.3
        for <patches@lists.linux.dev>; Tue, 02 Sep 2025 01:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756801771; x=1757406571; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fMrVj7jAgdBMUg6bB9EkBvTIBFRbh5mF4KGnDnI9ZoQ=;
        b=2SHWmy4pp2u6kkyUxIJBAlOCYOIs0yYV9cF8w287InDpw0WGwDufff/enapxg4Y7iH
         yw5kcO49dY7XQE12+ynhipCCLpd7pspDkp3Nd7vvkT7h2BmHKeme+0itW/P6X6hgZnJZ
         5kppnA8Z8/b3ac62qPuhyuZTKJwFjUJN70RuyQWLNAtQMDTT9GLaKrEfBdWgsF6QjLQd
         nQ8LD9x01mECqEZS1S1ASpfeZ43KeX0tc5MJ0fJ5s99GXq4/MMkRpj/TQmJgBMbWWxIN
         3GaGutxkZrqHvuT1HZzegvHNrGR/pPLIuLpd+L4nzYHests3IMZug4w2bHNSn4Q34vVB
         Z3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756801771; x=1757406571;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fMrVj7jAgdBMUg6bB9EkBvTIBFRbh5mF4KGnDnI9ZoQ=;
        b=Z1t2LvTA3oBLWNF3unfqhUJp4QTMZ3EzZ9Y89tWGkL4olJLDkMPHYw4xpu351SxL2q
         5ms+nMsp8BBsnLAj4VImbL1E3hOJWDYXHKMp/Ho/t0q0dyDKiFMpAsk5KVTRRI8Cn2iv
         6mg/blvu+LJXg2yHnoarAdjyBNtflsasMCZ+LP7k23MggIl9gGA4sOeKhTgY0DQT6KWU
         vZf2J3GRiVSXA/72A26P4+4JBv3UH2ZP6TYW7Pp3+jpzN0Gf4nqTKY+VPJLn2s7nvI1Z
         4JD0JP+KEd2Z7biC5DurRoDdqFOQv5QWyQZeblBxZ1aCgRkV9xqZeDIf40tCkVszEUUN
         a5ww==
X-Forwarded-Encrypted: i=1; AJvYcCXWsombWdTiVTaOPng4bhj00NbMYRVlaNFr0E0b9X8iCfZ2t8KQzAKHm+qXGCMKuH+WIqv//PNG@lists.linux.dev
X-Gm-Message-State: AOJu0YyfiJuAbtlJFc5Fov56I4M7LaCElB5AwgyN6j6BrOoDdhCXZKP9
	gpfVx05RNIbBmIM33hMG9i7ynaUOoBNMYVXWqzvl+bYFw8JtvDNUSaODqrDRoCYHTfX0eEiiSNn
	EXG/UN6NBqVf75VzBxQ==
X-Google-Smtp-Source: AGHT+IH+wbAKMP4pet3Iec/jg+z/+uHyKtEPnwn80rzGG04HiSXVcEQZ2VRn1KYTtbbuXX26NiHOYJCKfauiaaw=
X-Received: from wrbbs17.prod.google.com ([2002:a05:6000:711:b0:3b7:8b93:59f4])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1a8c:b0:3c9:24f5:4711 with SMTP id ffacd0b85a97d-3d1def66f6dmr8162944f8f.43.1756801770707;
 Tue, 02 Sep 2025 01:29:30 -0700 (PDT)
Date: Tue, 2 Sep 2025 08:29:29 +0000
In-Reply-To: <20250901-shrimp-define-9d99cc2a012a@spud>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250408220311.1033475-1-ojeda@kernel.org> <20250901-shrimp-define-9d99cc2a012a@spud>
Message-ID: <aLaq6TpUtLkqHg_o@google.com>
Subject: Re: [PATCH] rust: kasan/kbuild: fix missing flags on first build
From: Alice Ryhl <aliceryhl@google.com>
To: Conor Dooley <conor@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	kasan-dev@googlegroups.com, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Matthew Maurer <mmaurer@google.com>, Sami Tolvanen <samitolvanen@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, Sep 01, 2025 at 06:45:54PM +0100, Conor Dooley wrote:
> Yo,
> 
> On Wed, Apr 09, 2025 at 12:03:11AM +0200, Miguel Ojeda wrote:
> > If KASAN is enabled, and one runs in a clean repository e.g.:
> > 
> >     make LLVM=1 prepare
> >     make LLVM=1 prepare
> > 
> > Then the Rust code gets rebuilt, which should not happen.
> > 
> > The reason is some of the LLVM KASAN `rustc` flags are added in the
> > second run:
> > 
> >     -Cllvm-args=-asan-instrumentation-with-call-threshold=10000
> >     -Cllvm-args=-asan-stack=0
> >     -Cllvm-args=-asan-globals=1
> >     -Cllvm-args=-asan-kernel-mem-intrinsic-prefix=1
> > 
> > Further runs do not rebuild Rust because the flags do not change anymore.
> > 
> > Rebuilding like that in the second run is bad, even if this just happens
> > with KASAN enabled, but missing flags in the first one is even worse.
> > 
> > The root issue is that we pass, for some architectures and for the moment,
> > a generated `target.json` file. That file is not ready by the time `rustc`
> > gets called for the flag test, and thus the flag test fails just because
> > the file is not available, e.g.:
> > 
> >     $ ... --target=./scripts/target.json ... -Cllvm-args=...
> >     error: target file "./scripts/target.json" does not exist
> > 
> > There are a few approaches we could take here to solve this. For instance,
> > we could ensure that every time that the config is rebuilt, we regenerate
> > the file and recompute the flags. Or we could use the LLVM version to
> > check for these flags, instead of testing the flag (which may have other
> > advantages, such as allowing us to detect renames on the LLVM side).
> > 
> > However, it may be easier than that: `rustc` is aware of the `-Cllvm-args`
> > regardless of the `--target` (e.g. I checked that the list printed
> > is the same, plus that I can check for these flags even if I pass
> > a completely unrelated target), and thus we can just eliminate the
> > dependency completely.
> > 
> > Thus filter out the target.
> 
> 
> 
> 
> > This does mean that `rustc-option` cannot be used to test a flag that
> > requires the right target, but we don't have other users yet, it is a
> > minimal change and we want to get rid of custom targets in the future.
> 
> Hmm, while this might be true, I think it should not actually have been
> true. Commit ca627e636551e ("rust: cfi: add support for CFI_CLANG with Rust")
> added a cc-option check to the rust kconfig symbol, checking if the c
> compiler supports the integer normalisations stuff:
> 	depends on !CFI_CLANG || RUSTC_VERSION >= 107900 && $(cc-option,-fsanitize=kcfi -fsanitize-cfi-icall-experimental-normalize-integers)
> and also sets the relevant options in the makefile:
> 	ifdef CONFIG_RUST
> 	       # Always pass -Zsanitizer-cfi-normalize-integers as CONFIG_RUST selects
> 	       # CONFIG_CFI_ICALL_NORMALIZE_INTEGERS.
> 	       RUSTC_FLAGS_CFI   := -Zsanitizer=kcfi -Zsanitizer-cfi-normalize-integers
> 	       KBUILD_RUSTFLAGS += $(RUSTC_FLAGS_CFI)
> 	       export RUSTC_FLAGS_CFI
> 	endif
> but it should also have added a rustc-option check as, unfortunately,
> support for kcfi in rustc is target specific. This results in build
> breakages where the arch supports CFI_CLANG and RUST, but the target in
> use does not have the kcfi flag set.
> I attempted to fix this by adding:
> 	diff --git a/arch/Kconfig b/arch/Kconfig
> 	index d1b4ffd6e0856..235709fb75152 100644
> 	--- a/arch/Kconfig
> 	+++ b/arch/Kconfig
> 	@@ -916,6 +916,7 @@ config HAVE_CFI_ICALL_NORMALIZE_INTEGERS_CLANG
> 	 config HAVE_CFI_ICALL_NORMALIZE_INTEGERS_RUSTC
> 	        def_bool y
> 	        depends on HAVE_CFI_ICALL_NORMALIZE_INTEGERS_CLANG
> 	+       depends on $(rustc-option,-C panic=abort -Zsanitizer=kcfi -Zsanitizer-cfi-normalize-integers)
> 	        depends on RUSTC_VERSION >= 107900
> 	        # With GCOV/KASAN we need this fix: https://github.com/rust-lang/rust/pull/129373
> 	        depends on (RUSTC_LLVM_VERSION >= 190103 && RUSTC_VERSION >= 108200) || \
> but of course this does not work for cross compilation, as you're
> stripping the target information out and so the check passes on my host
> even though my intended
> RUSTC_BOOTSTRAP=1 rustc -C panic=abort -Zsanitizer=kcfi -Zsanitizer-cfi-normalize-integers -Ctarget-cpu=generic-rv64 --target=riscv64imac-unknown-none-elf
> is a failure.
> 
> I dunno too much about rustc itself, but I suspect that adding kcfi to
> the target there is a "free" win, but that'll take time to trickle down
> and the minimum version rustc version for the kernel isn't going to have
> that.
> 
> I'm not really sure what your target.json suggestion below is, so just
> reporting so that someone that understands the alternative solutions can
> fix this.

Probably right now we have to do this cfg by

	depends on CONFIG_ARM

to prevent riscv if rustc has the missing setting
set on riscv. Once we add it to riscv, we change it to

	depends on CONFIG_ARM || (RUSTC_VERSION >= ??? || CONFIG_RISCV)

Alice
