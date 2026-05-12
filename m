Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5606393DD3
	for <patches@lists.linux.dev>; Tue, 12 May 2026 21:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778622795; cv=none; b=YoHNGhug+CoJYrOhxmc17IHqCV3nljvAJ+42loxoCoOMWasPveWd8azBCcZMXXvXHQLaky0tJeq6UBokVtS/6gFTtjODBObR7TPOQaVUin5wE4Df2pGBeiXdyQB4oKZopi0LDh9/gWPVMpz7rOLkqnSC9qyN7PS2fMbQ/alkY4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778622795; c=relaxed/simple;
	bh=5f0sbgLOx99dwJMkBq5NiUwfH0lg4jMa9lQjzCvSrPs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bSnM2wygC09ruNzVpZZ7oBKfp/aQmc+pFvfma6gYwm8iJBKebTPEaCjJpwPmCna3lF7kyg3Ctvcp6IXI7nM0Phq5OcExYdWG1LCdaOujnbJ8P4zrDQuhVDhlmo1FjB37IYmDRoZfIFHuR2XGeTVnaiUrplqXxeDxZSa2n7GowV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XpzTLVW5; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XpzTLVW5"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c829366cf25so2828726a12.0
        for <patches@lists.linux.dev>; Tue, 12 May 2026 14:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778622793; x=1779227593; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fvVTealEAKbqzDp6SQK7MaRjPvv5/iK5fsP9B8BXPtw=;
        b=XpzTLVW5uG56uRT/lXEGlS/RmpNDsRjbrClw8KZZ6lQbMCEibLOUM7YM4eLKRgAkRP
         lYZjfZQ2U+dV2sOpsgNrfFs3jO2jFayBSDWrRGfo7hAFdCimnUdSfVZbhn1sQThgnhH2
         YwbZgmiQHQWC9TnaA4ql4u7RYvdSsrDVucdPd+AADmv8gjqG6+5elLRUvM9+6P7einT+
         0ujWt+aayAUXdVUVdLXFrrhihJhwfQb1mfKban708UyBQDcBuB3sYA9/kGIchEx/2X8A
         ApKVtoJQD+5a1iLZ6yzzxGzEWDTZSk7UHR/zr5BnRq+VYM3Ht63PjNoUlYka6SmrUiv7
         rf2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778622793; x=1779227593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fvVTealEAKbqzDp6SQK7MaRjPvv5/iK5fsP9B8BXPtw=;
        b=KsIBzZevyt3oS/YAhZA/4IjHEBzBHAy7fgPYZzVlLprF0jxvg5UrYiu7Xy9PPgqBqL
         pbS205nGRcbNS09sw2/LjCj1nhQG4om9/1O3gPrIvukc38cJG1lpg+8dHZQITM8s8cSD
         xRcfv+ro0NzRX59JTtdl4Hk0niz4uw7emgyVvvLz9z9F7qIZROaa6d2DZ7nmT9x1kXCv
         w3yI01MyLSB6897F2W7TD7HaNAe2nSUbGpkSBY4cDjigX42APyg0nigaDAVDSW30EhjZ
         7SVWpwi+DYs0BNEQTOrXvsOnXsGQ7Lgh4af6BYLtHXkCiOJLytOBuuosN9UEnQ9CTpbp
         ngWA==
X-Forwarded-Encrypted: i=1; AFNElJ8EjkJ7Sp116hIP4Jo6SBDbSqQriFrmYT2cu5PPaFJEppRsn8/yiAfaeKaL9kU/xIJRktT8OWJb@lists.linux.dev
X-Gm-Message-State: AOJu0YwR5s8UPZvTQ21pq8LX+9zQ/fUkSZMLXSixB1PSS7OEPvDZmnFp
	sUF5nlEDWXCoS0iX3T03eYcjyDBlrTBktuLwHPRI6q6ug/1fiF+7n90/2XfUkxaZYEBvBbmu+yE
	I/eV8Iw==
X-Received: from pfvo27.prod.google.com ([2002:a05:6a00:1b5b:b0:837:e90f:8cd9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3a06:b0:82f:7b98:e499
 with SMTP id d2e1a72fcca58-83f058b2dc4mr95628b3a.31.1778622792910; Tue, 12
 May 2026 14:53:12 -0700 (PDT)
Date: Tue, 12 May 2026 14:53:12 -0700
In-Reply-To: <20260512205250.313933-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260512173940.376401154@linuxfoundation.org> <20260512205250.313933-1-ojeda@kernel.org>
Message-ID: <agOhSMXZGSv0bPhX@google.com>
Subject: Re: [PATCH 6.18 091/270] LoongArch: KVM: Compile switch.S directly
 into the kernel
From: Sean Christopherson <seanjc@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: gregkh@linuxfoundation.org, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, Dave Hansen <dave.hansen@linux.intel.com>, 
	chenhuacai@loongson.cn, lixianglai@loongson.cn, patches@lists.linux.dev, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, May 12, 2026, Miguel Ojeda wrote:
> On Tue, 12 May 2026 19:38:12 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > 6.18-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Xianglai Li <lixianglai@loongson.cn>
> >
> > commit 5203012fa6045aac4b69d4e7c212e16dcf38ef10 upstream.
> >
> > If we directly compile the switch.S file into the kernel, the address of
> > the kvm_exc_entry function will definitely be within the DMW memory area.
> > Therefore, we will no longer need to perform a copy relocation of the
> > kvm_exc_entry.
> >
> > So this patch compiles switch.S directly into the kernel, and then remove
> > the copy relocation execution logic for the kvm_exc_entry function.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> For loongarch64, I am seeing a bunch of errors like:
> 
>     arch/loongarch/kvm/switch.S:201:1: error: unrecognized instruction mnemonic
>     EXPORT_SYMBOL_FOR_KVM(kvm_exc_entry)
>     ^
> 
> `EXPORT_SYMBOL_FOR_KVM` does not exist in 6.18. Does this need a subset
> of commit 6276c67f2bc4 ("x86: Restrict KVM-induced symbol exports to KVM
> modules where obvious/possible")?

Either that or just convert EXPORT_SYMBOL_FOR_KVM() => EXPORT_SYMBOL_GPL().  If
that's somewhat scriptable for ongoing LTS backports, that's probably the best
option.  EXPORT_SYMBOL_FOR_KVM() will only work for 6.18, and the list of backports
needed to get EXPORT_SYMBOL_FOR_MODULES() working on older LTS kernels looks to
be non-trivial

If we do end up backporting EXPORT_SYMBOL_FOR_KVM() and others, we might as well
also grab a subset of 01122b89361e ("perf: Use EXPORT_SYMBOL_FOR_KVM() for the
mediated APIs") to ensure a kvm_types.h stub is present on all archs.  That way
EXPORT_SYMBOL_FOR_KVM() usage in arch-neutral code will also work.

diff --git include/asm-generic/Kbuild include/asm-generic/Kbuild
index 295c94a3ccc1..9aff61e7b8f2 100644
--- include/asm-generic/Kbuild
+++ include/asm-generic/Kbuild
@@ -32,6 +32,7 @@ mandatory-y += irq_work.h
 mandatory-y += kdebug.h
 mandatory-y += kmap_size.h
 mandatory-y += kprobes.h
+mandatory-y += kvm_types.h
 mandatory-y += linkage.h
 mandatory-y += local.h
 mandatory-y += local64.h

