Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D13214A7F
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 21:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744234531; cv=none; b=kt8LQg9ME+lhdSo31RpvQjyY/IlKenBNpik8jJYDWWYU6PjVgUR7LC0N3TC7Hp2LC7ff73CjtDrQ05CeFNDy7YVhb3ZDR8xkIQ/AdRdBs+UK+Vla/RhZNUR3XiNwAbz1a2n47K0HL7NZT2f0HJqU5tJf2/Yq+/moVunrM40diQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744234531; c=relaxed/simple;
	bh=DtY0vGLHcf+CQtDC0YI1wt0uIFmrfTa1t3e4mx9zvdM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AQathPEIkH6aYH0HB1WiRFVla3YuxR9v1etOXIdGAN8g8sRJF3C/jKS2iuxWDIfaU+i+EKVv74o0AoFv8qOWAeYJ9kRyQcKddzr6iASNYehNAS5vgcokn91+WX3CH7V9VQe88ESl8egeEtyQl7eq5sko5dhVwXly83Szu5WRpkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KtcidWn5; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KtcidWn5"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e789411187so1171a12.1
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 14:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744234527; x=1744839327; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hBtSrPe7WZluOp+nomC0bfsWMrHWKW7U6czDExpfaAo=;
        b=KtcidWn58ibSr5DK4yNLjEkJloc7NalOCredBKROGplkzbj7LlFn7pCSSOztsjUTY3
         hwUmNZN8fms5LFf8Ml4uzNGAaRrvOZy9S5emUYdPgTPaDCCHYGIwvP/jESL/qif8dPBv
         rMhmwRLDF/kbCGgrqfEv1YQqScaNQ+O9Eho3nLCMSPIBJ0UqrpLIKRb2d22LQ/KFu2v1
         DMppNM1Sstfzs61ZyS/KxZt2eYXTgOeoOYIT2OFpCdjXrz5a2xcfXmCcEl2Mzy1LYZie
         YIKU2a7OmHnkxQYUS8Iulh8p1ujQa7JJwoOroFGjY04d2PcvWBGNy4gq5QmsaCjwoGHJ
         6N3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744234527; x=1744839327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hBtSrPe7WZluOp+nomC0bfsWMrHWKW7U6czDExpfaAo=;
        b=Y61yMtmOFfhrBo7y54U4eJAhj+3p8M9HAO4h7JDWh5eGEnM/urHZjtPaxBU0fYoLmA
         nlbGqNpwwbrAn2troXN8ElWiRZSUc/tWolno8kNqOXf/eshAR0gV0MFKq6FMRycM6aZb
         +qLlRTtlDB+R5CANnR2LxLajhqPCL5u+fzC6BP323zY4VEbQaL9gaqLzdq22/2nj65vs
         dMGNm65XPxomOgG05KEMR/iEZ5jpISr6E/TMNf0QpTfS55Si4XQWgjZrs9ZHQgx93mnd
         765GxsQlqhh57cKE2dChZgaNrj5zH8VwyN4EewxsR1MAVivkMbMU/kzsKrnIYoSmiyLh
         jLBA==
X-Forwarded-Encrypted: i=1; AJvYcCVXO+/sZ6y87T2RVXL+THH5i8yasKR7Tn6Jk6T+1ULsKgKEaHLGTgQ4Xhpz4NFoyVRYltqZL1mU@lists.linux.dev
X-Gm-Message-State: AOJu0YwnxCwdhGIPtTgs29gjc8dgi/tjq+o5gAHmYXNNGBHV+gzELPjS
	MImp97lJvCcLKuQRSTQ0Np2g25s4aphsgxGSedwEVBlNDCrMTKdxXgtEopfuYZVWGvYxTIdGW6C
	wtpdZz6mTbNWYveIalqzr5OH4zx1ImriHmEtl
X-Gm-Gg: ASbGncv8WInS4bwaTWmHyIMeGqmz/kC7VyecLeZ/DbKYA7d7GRFjbgfIQXV1bC2u/EE
	AD2MG15TLHETZ8m0JgJksR5EpKe5VGYvng11T5w2TXQYzL80eXT/wh+t+at7qahoun8nKu0ox3I
	L0FRzy05Azkl+k1fkcao+Kzx1eHyQE59KEoXHUYDt0NF9I7Zyhu/fI7SEy4nF8R18=
X-Google-Smtp-Source: AGHT+IHPCp84FrskA1MxfUD14D4kgZf0Pn5Jyg9pNQCJj5QuZD0wTInhm0c57wkfzvcDWR168vHuSJT3TGtpjWG2WvY=
X-Received: by 2002:a50:99d7:0:b0:5ed:f521:e06c with SMTP id
 4fb4d7f45d1cf-5f3291cd5a2mr14691a12.7.1744234526715; Wed, 09 Apr 2025
 14:35:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408220311.1033475-1-ojeda@kernel.org>
In-Reply-To: <20250408220311.1033475-1-ojeda@kernel.org>
From: Matthew Maurer <mmaurer@google.com>
Date: Wed, 9 Apr 2025 14:35:15 -0700
X-Gm-Features: ATxdqUFhVkSOwO53hFox7UAmqaM-iyfDXe_LO4ZiaZoTyX7HLUuRtwe61t2vc0E
Message-ID: <CAGSQo00QxBbUb8AxwqtRKXy96na_HUVmAG9nWmX=cVvozqwWaA@mail.gmail.com>
Subject: Re: [PATCH] rust: kasan/kbuild: fix missing flags on first build
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	kasan-dev@googlegroups.com, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Sami Tolvanen <samitolvanen@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 8, 2025 at 3:03=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> If KASAN is enabled, and one runs in a clean repository e.g.:
>
>     make LLVM=3D1 prepare
>     make LLVM=3D1 prepare
>
> Then the Rust code gets rebuilt, which should not happen.
>
> The reason is some of the LLVM KASAN `rustc` flags are added in the
> second run:
>
>     -Cllvm-args=3D-asan-instrumentation-with-call-threshold=3D10000
>     -Cllvm-args=3D-asan-stack=3D0
>     -Cllvm-args=3D-asan-globals=3D1
>     -Cllvm-args=3D-asan-kernel-mem-intrinsic-prefix=3D1
>
> Further runs do not rebuild Rust because the flags do not change anymore.
>
> Rebuilding like that in the second run is bad, even if this just happens
> with KASAN enabled, but missing flags in the first one is even worse.
>
> The root issue is that we pass, for some architectures and for the moment=
,
> a generated `target.json` file. That file is not ready by the time `rustc=
`
> gets called for the flag test, and thus the flag test fails just because
> the file is not available, e.g.:
>
>     $ ... --target=3D./scripts/target.json ... -Cllvm-args=3D...
>     error: target file "./scripts/target.json" does not exist
>
> There are a few approaches we could take here to solve this. For instance=
,
> we could ensure that every time that the config is rebuilt, we regenerate
> the file and recompute the flags. Or we could use the LLVM version to
> check for these flags, instead of testing the flag (which may have other
> advantages, such as allowing us to detect renames on the LLVM side).
>
> However, it may be easier than that: `rustc` is aware of the `-Cllvm-args=
`
> regardless of the `--target` (e.g. I checked that the list printed
> is the same, plus that I can check for these flags even if I pass
> a completely unrelated target), and thus we can just eliminate the
> dependency completely.
>
> Thus filter out the target.
>
> This does mean that `rustc-option` cannot be used to test a flag that
> requires the right target, but we don't have other users yet, it is a
> minimal change and we want to get rid of custom targets in the future.
>
> We could only filter in the case `target.json` is used, to make it work
> in more cases, but then it would be harder to notice that it may not
> work in a couple architectures.
>
> Cc: Matthew Maurer <mmaurer@google.com>
> Cc: Sami Tolvanen <samitolvanen@google.com>
> Cc: stable@vger.kernel.org
> Fixes: e3117404b411 ("kbuild: rust: Enable KASAN support")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> By the way, I noticed that we are not getting `asan-instrument-allocas` e=
nabled
> in neither C nor Rust -- upstream LLVM renamed it in commit 8176ee9b5dda =
("[asan]
> Rename asan-instrument-allocas -> asan-instrument-dynamic-allocas")). But=
 it
> happened a very long time ago (9 years ago), and the addition in the kern=
el
> is fairly old too, in 342061ee4ef3 ("kasan: support alloca() poisoning").
> I assume it should either be renamed or removed? Happy to send a patch if=
 so.
>
>  scripts/Makefile.compiler | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/Makefile.compiler b/scripts/Makefile.compiler
> index 8956587b8547..7ed7f92a7daa 100644
> --- a/scripts/Makefile.compiler
> +++ b/scripts/Makefile.compiler
> @@ -80,7 +80,7 @@ ld-option =3D $(call try-run, $(LD) $(KBUILD_LDFLAGS) $=
(1) -v,$(1),$(2),$(3))
>  # TODO: remove RUSTC_BOOTSTRAP=3D1 when we raise the minimum GNU Make ve=
rsion to 4.4
>  __rustc-option =3D $(call try-run,\
>         echo '#![allow(missing_docs)]#![feature(no_core)]#![no_core]' | R=
USTC_BOOTSTRAP=3D1\
> -       $(1) --sysroot=3D/dev/null $(filter-out --sysroot=3D/dev/null,$(2=
)) $(3)\
> +       $(1) --sysroot=3D/dev/null $(filter-out --sysroot=3D/dev/null --t=
arget=3D%,$(2)) $(3)\
>         --crate-type=3Drlib --out-dir=3D$(TMPOUT) --emit=3Dobj=3D- - >/de=
v/null,$(3),$(4))

The problem with this change is that some `rustc` flags will only be
valid on some platforms. For example, if we check if a
`-Zsanitizer=3Dshadow-call-stack` is available, it will fail for non
aarch64 targets. I don't think we're currently directly detecting any
of these, because all of the stuff we're using is known present by
virtue of minimum compiler version, which means we can possibly get
away with this change for now. That said, this isn't a long term
solution unless we are getting rid of target.json files altogether, as
one of the main adaptations we've been putting in those is to enable
additional target features.

>
>  # rustc-option
>
> base-commit: 0af2f6be1b4281385b618cb86ad946eded089ac8
> --
> 2.49.0
