Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83AC3081CD
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 11:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762774688; cv=none; b=Nogy38NQ5XprqyUtULBL/dpDK0wTgqcE6SADHHAtTG2lbfCQE5Ii5Ra9QM+lfvX5snzeFLdOf1WdQfuhs3lLOSS5PRNcgB/27VG5aDKkZXIn/sK0/nM/RJemLJgRy744mTPwN1p9drGz7ffZhx6F8XYP120i4emINAUZUsq11lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762774688; c=relaxed/simple;
	bh=uxSBBgdJ6G0wqOTbxb4Aw2gp4edL/LWe0qLGHZZW64A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oo8uCtK0Na1C47f6VBXeLKmQuBg5yjoeEupA1XK4QmPAENz0GpSVGuSdlSiq+Q06y3KHRvcb6P+VhXIo9mz5aigNV83INQjYk3mW1ouJpL6EwkmPf2Csqsjjwso0E/CLKZEuxlBVFpPLw8KrUZbnhLWJDuSHYJ7DNmMaQcelcMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PZVGBnVz; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PZVGBnVz"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-64097bef0e2so4140624a12.3
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 03:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762774685; x=1763379485; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KMnqzGHQkZQbLlqJI77L5ey44wwkU20ch9eam4NwE+Y=;
        b=PZVGBnVzb4vx5Rj3pi9vrMuKWgsGTBM48edAcqvMy56CnKX7j6ajBEAMTuNj9I0js9
         gk6OoQNLSfuzq8HzUX/IOYW8vbf6H45EomL60GHPeMFLfHFw+5FBRhpCfPA9CyeNGiab
         Nc77KcWPurkq+8vCkuEIqOW8jP/Vr7siud0CPmxr40KIB5By4GIDDOvmdiizW/SjLSDQ
         Mbzc3aaa1u9fib1aV8iUYKOe+LQLmD22JQdfFrGsQilAui1R5IAne+YgJ+lQXq04UNoy
         +IIrQsvANbYu8MOqhjyfavbzO2hiqPxuJcypDQ1C4FZTFnVpQuo0YhCJQMpsfe3XWtkA
         p7iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762774685; x=1763379485;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KMnqzGHQkZQbLlqJI77L5ey44wwkU20ch9eam4NwE+Y=;
        b=w69wNg6ErK2jYqa164Vg+HSyQQ5Il7Rl8n1zoKbzmiuXDB+aRNHYDNHBAhXlOUcGSL
         Dc7TNs54beiUYvxo6JpwQeKKWf8AlcaYhTLgwGS00NFM5z4mN1Gz6NqXy29l3iHDV3eP
         jrmxJuqUl8nzGLCqJY0jQq7VlcspS60AlL8bDbiaNZ55sw+7Z5JIvabyiBdFTG2PUt6M
         fBjxasfRuanInaBf0JIgUIIjOo2MZN0JkaLDrQU7KRtsrvqCjArf9HgfYQMyvQ2g75Si
         j4FCOwJ0fmGnT4mN0KLJEZ003ZM/f3ZWHAglb2OabWUAnxCz6T1GQ6UsEQ3y/knuCafi
         apcA==
X-Forwarded-Encrypted: i=1; AJvYcCUb+5H13JoQNf4Ycrq+r1NsEoEwWrkmzi29e32Jhei6FdRvzNU44TXVyqXf9YYOyCK39NpA+Wdr@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5hwnbhQ6lkpU4u03QoLBFQhUoexqzcOoqPMert2uPlJT2KhhS
	ash2gmOOM+dEEuIH90sC/T1T9iia4wyV4SmTt4whzVc14ofxFfZettLC4N60CNeHKvisZ2MkW+W
	TTXQd30WOclUir610HA==
X-Google-Smtp-Source: AGHT+IGSOTdSHkqL0poJ5tqc7TrtRGaLiDYCsGpAd4/lDD5jX1KPXKGf/AHVmm5qz5MunTDbIDoNGHc6Ka1J5BQ=
X-Received: from edbek21.prod.google.com ([2002:a05:6402:3715:b0:640:cfc4:f37f])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:354b:b0:640:9b11:5d65 with SMTP id 4fb4d7f45d1cf-6415e822920mr5942384a12.24.1762774685141;
 Mon, 10 Nov 2025 03:38:05 -0800 (PST)
Date: Mon, 10 Nov 2025 11:38:04 +0000
In-Reply-To: <20251110095025.1475896-10-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-10-ojeda@kernel.org>
Message-ID: <aRHOnGyLx-bEVqcY@google.com>
Subject: Re: [PATCH 09/18] rust: proc-macro2: enable support in kbuild
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Mon, Nov 10, 2025 at 10:50:14AM +0100, Miguel Ojeda wrote:
> With all the new files in place and ready from the new crate, enable
> the support for it in the build system.
> 
> `proc_macro_byte_character` and `proc_macro_c_str_literals` were
> stabilized in Rust 1.79.0 [1] and were implemented earlier than our
> minimum Rust version (1.78) [2][3]. Thus just enable them instead of using
> the `cfg` that `proc-macro2` uses to emulate them in older compilers.
> 
> Link: https://github.com/rust-lang/rust/pull/123431 [1]
> Link: https://github.com/rust-lang/rust/pull/112711 [2]
> Link: https://github.com/rust-lang/rust/pull/119651 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  Makefile                          |  3 +++
>  rust/Makefile                     | 32 +++++++++++++++++++++++++++++--
>  scripts/generate_rust_analyzer.py |  7 +++++++
>  3 files changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index fb4389aa5d5f..6ff887523eee 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1830,6 +1830,9 @@ PHONY += rustfmt rustfmtcheck
>  
>  rustfmt:
>  	$(Q)find $(srctree) $(RCS_FIND_IGNORE) \
> +		\( \
> +			-path $(srctree)/rust/proc-macro2 \
> +		\) -prune -o \
>  		-type f -a -name '*.rs' -a ! -name '*generated*' -print \
>  		| xargs $(RUSTFMT) $(rustfmt_flags)
>  
> diff --git a/rust/Makefile b/rust/Makefile
> index 9eea6563ef35..a614a23023cb 100644
> --- a/rust/Makefile
> +++ b/rust/Makefile
> @@ -27,6 +27,8 @@ endif
>  
>  obj-$(CONFIG_RUST) += exports.o
>  
> +always-$(CONFIG_RUST) += libproc_macro2.rlib
> +
>  always-$(CONFIG_RUST_KERNEL_DOCTESTS) += doctests_kernel_generated.rs
>  always-$(CONFIG_RUST_KERNEL_DOCTESTS) += doctests_kernel_generated_kunit.c
>  
> @@ -76,6 +78,17 @@ core-flags := \
>      --edition=$(core-edition) \
>      $(call cfgs-to-flags,$(core-cfgs))
>  
> +proc_macro2-cfgs := \
> +    feature="proc-macro" \
> +    wrap_proc_macro \
> +    $(if $(call rustc-min-version,108800),proc_macro_span_file proc_macro_span_location)
> +
> +# Stable since Rust 1.79.0: `feature(proc_macro_byte_character,proc_macro_c_str_literals)`.
> +proc_macro2-flags := \
> +    --cap-lints=allow \
> +    -Zcrate-attr='feature(proc_macro_byte_character,proc_macro_c_str_literals)' \
> +    $(call cfgs-to-flags,$(proc_macro2-cfgs))
> +

I don't understand this. We enable the features even on 1.79, but we
only pass the proc_macro_span_file, proc_macro_span_location cfgs on
1.88 and above?

We add the appropriate feature(_) invocations on older compilers, so
should we not support those things on those compilers?

Alice
