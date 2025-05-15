Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4A929B8C0
	for <patches@lists.linux.dev>; Thu, 15 May 2025 21:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747343572; cv=none; b=O+IeEyShug9ORyACKSL8+hcsZ5DetZdHVGfGzzA3GaNE+EAvLbah0j2cVN0tjqQlG0CiUjcc3Ofrai6wwNx1CYsGqWky/oMF5eFpqe5P+b9SkYf5PRpDtXVIFQ0S6BICgrQhOObyx3YU/tnCs+wf0F0Qh5y6UKd4v7sEW+0C/e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747343572; c=relaxed/simple;
	bh=q3PDrZM6G8zDDRhj4QwvJtG8rSqiKqS/I3flXIXrZeU=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=riXmeNEbzADRhWQ8fE1Nju9DWtcMUczRsE/Hn59g526yPPRjlbDOCMarotghDWf8SKezLVrvC0pZnukGRvzvMF10XrD4tVUyol4PIRJTxCt9WcK1k6FRrNqdEGZ+xLU3yhY/3zEJAHNLg1egcdA6Ha59OB5aLZsgee5HJq7jaMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GUb1VMCA; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GUb1VMCA"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43cfdc2c8c9so7528395e9.2
        for <patches@lists.linux.dev>; Thu, 15 May 2025 14:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747343569; x=1747948369; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=opuvm8FKWBIYNRf90PxXi7sMcW0qx9YAX9FlKAsACPA=;
        b=GUb1VMCACibCsv3ejvg+pEEnlcU6YFmkyE7aEyKcY3IbKN0hNS3Ab3lywpS1v8iojm
         ePIlmLmIBHxP+4QP/Q2yYanlpO86ND8ZAM8jwv4ncw98VCbPq5e0CCIygiCo/Utqm9vC
         +mOWOvscXBbnAeYrB0Zx2RyjXZTilJ72ajXFaQf3f1cW5IrAFxaMsgNtb3RW95mr298y
         8ozAc7pyD54IHbRiYq+jEQ7nDYsGF4k4qLX1AUtUZAGE7omBQj5b00riLenRq2Hgcrl/
         bYGI7zmhEVAExrmu1uBARGbXYo33jaE1rwrCwahs3nO3SveyeCZu3hqE+ySqgf8claZ7
         RH2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747343569; x=1747948369;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=opuvm8FKWBIYNRf90PxXi7sMcW0qx9YAX9FlKAsACPA=;
        b=jWmRWg9sOSJkDPUaQ1we30uCns9EnrD9RU4PgHh61Vo/8tYNHxg3JZkn9zCQnUooSJ
         0WqcWlxA36/HtgGf0ltjq8kT1qioSJxoY5RAYJEdCNb7lYbBFcJIGZ68pEnx6EAf01Q6
         B2unplJfMSWdvuhXcj2kSobFEncMuuqeXIPRP2P9eIAUAUOtadma/McZTnGzfGPeQqSb
         LTjoyL+CD42nVoRUufXDdoYKc82jI0gN9bWAmRr6PD0jZbUcyqEicBvCaVpelmZO/xyi
         WRSlVO5JyNrwce5FquDmVVj3j5IaKdRABFBuxcVFQF8scQRDwJUiU3dq0U1zwxemhRtG
         DsBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzoO004pOSBSkU6yYM0L/o5kbFmsnIh0IUm+rmxWRP5gcFCFpy1ccW/0VS6aM+jzEqfwIPm7S6@lists.linux.dev
X-Gm-Message-State: AOJu0YwL9pqvJBnQZoZILPiCK31U5GNrVpwkc2tgo5uD4voKUIEFz84K
	zxaAczIapaJ8TVdN4dt0jZuIg/gRx/gmGhNFRt90yZn5AqUNbzyWqXJcX04q+XlZA/e4FP35IGu
	or3q9f+2KdbvL9wZveIeHXxPkvFTFT74=
X-Gm-Gg: ASbGncvicc6W68DqiO6689C/eP62TZeCKvcbVaCdr+H6zA1NMAImSfggqnAKZF3Y4P1
	F6LVy1lHenIO63DteamE4Py/x4WdnJoKPUTCK29xjdHWL7N83vzc4lrFep3juwUzTJooefDIOps
	pomvbgzooEvmwE7NpRdI9ZgG58o0eGm4QxPw==
X-Google-Smtp-Source: AGHT+IEYoK6f7wP0SPm/gfKqdWjWZ4HX90FKs87O0UBgxajWhbvIOpj9PHkIZ8r7babBAps9G/Ln4njRTceq0nIyQp0=
X-Received: by 2002:a5d:5c84:0:b0:3a2:12a:e637 with SMTP id
 ffacd0b85a97d-3a35c8542a6mr1195017f8f.56.1747343568560; Thu, 15 May 2025
 14:12:48 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 May 2025 14:12:48 -0700
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 May 2025 14:12:48 -0700
From: Kane York <kanepyork@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <097a4926cebc9030469d42cc7a3392b39dfd703d.camel@nvidia.com>
References: <097a4926cebc9030469d42cc7a3392b39dfd703d.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 15 May 2025 14:12:48 -0700
X-Gm-Features: AX0GCFslEILHetAnpjY2QFEJ9SocrJkFvcA9OUfU-AXwwAPQyRsjmsYuQT8ABk4
Message-ID: <CABeNrKVfCHww2k_W-0s4GQE=2bA+wjje=FEH=gL8FhNbFB1tOw@mail.gmail.com>
Subject: Re: [PATCH 1/5] objtool/rust: add one more `noreturn` Rust function
 for Rust 1.87.0
To: ttabi@nvidia.com
Cc: a.hindborg@kernel.org, acourbot@nvidia.com, alex.gaynor@gmail.com, 
	aliceryhl@google.com, apopple@nvidia.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, dakr@kernel.org, 
	gary@garyguo.net, jhubbard@nvidia.com, joelagnelf@nvidia.com, 
	jpoimboe@kernel.org, linux-kernel@vger.kernel.org, ojeda@kernel.org, 
	patches@lists.linux.dev, peterz@infradead.org, rust-for-linux@vger.kernel.org, 
	stable@vger.kernel.org, tmgross@umich.edu
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 May 2025 19:06:10 +0000, Timur Tabi <ttabi@nvidia.com> wrote:
> On Thu, 2025-05-15 at 09:18 -0700, Josh Poimboeuf wrote:
> > > Since I build with LLVM=1, I'm assuming the answer is 18.1.3
> >
> > I'm not able to recreate, can you run with OBJTOOL_VERBOSE=1 and paste
> > the output?
>
> You probably can't repro because it includes code that hasn't been merged upstream yet.  Try this:
>
> https://github.com/ttabi/linux/commits/alex
>
>   CHK     kernel/kheaders_data.tar.xz
> drivers/gpu/nova-core/nova_core.o: warning: objtool:
> _RNvXsa_NtCs8S3917Wilyo_9nova_core5vbiosNtB5_14PciAtBiosImageINtNtCsgK88DPai1lC_4core7convert7TryFro
> mNtB5_13BiosImageBaseE8try_from() falls through to next function

...

> 011b     634b:	e8 00 00 00 00       	call   6350 <.Ltmp38>	634c:
> R_X86_64_PLT32
> _RNvNtNtCsgK88DPai1lC_4core5slice5index26slice_start_index_len_fail-0x4

Yup, that's an unrecognized noreturn function.

src/core/slice/index.rs:
> #[cfg_attr(not(feature = "panic_immediate_abort"), inline(never), cold)]
> #[cfg_attr(feature = "panic_immediate_abort", inline)]
> #[track_caller]
> #[rustc_const_unstable(feature = "const_slice_index", issue = "none")]
> const fn slice_start_index_len_fail(index: usize, len: usize) -> ! {
>     // SAFETY: we are just panicking here
>     unsafe {
>         const_eval_select(
>             (index, len),
>             slice_start_index_len_fail_ct,
>             slice_start_index_len_fail_rt,
>         )
>     }
> }
>
> // FIXME const-hack
> #[inline]
> #[track_caller]
> fn slice_start_index_len_fail_rt(index: usize, len: usize) -> ! {
>     panic!("range start index {index} out of range for slice of length {len}");
> }

The return is at offset 0093 (x62c3) with a jump to __x86_return_thunk.
