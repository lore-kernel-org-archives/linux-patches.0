Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDA5286D6A
	for <patches@lists.linux.dev>; Tue, 20 May 2025 20:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747771763; cv=none; b=CpSX/o3Wj+bkvEC+mioV3WQkqP6r2mHT1v+iWED6h4lnGyYK6kYXPdWnXJ+bU+mVbZt0mOqVTbzzXrxSxsebfpTyvG5eB7l8PvnmTeXenGC/JPfolUOd7YJHIAVaHiPQyD7vkhoMeMuKrI0wKxtofD36k9DxZzjT4pccZCmydcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747771763; c=relaxed/simple;
	bh=V4N2yfPT4vLArvTmMIGEmcZ/2fv5s912zQIeD+Vi+50=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AQTgDnRHx1AU814cjqJs/ZjbjbItjo8cniRcQRlkmegBd72HzScsK0cDx4vxZXyO86HM6UCy6uF1b4pAgTzRN2u6GG3itgNXhMdzRmiBMFle6PEJEx868kGwxOZ1s/ehMKouNNDOf8wDlSgAXDtUrcmi1l+CAvhqOgqq0PwZgpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h3AuyMcq; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h3AuyMcq"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-54afb5fcebaso7106454e87.3
        for <patches@lists.linux.dev>; Tue, 20 May 2025 13:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747771759; x=1748376559; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XuyoTXp3MODuWVPPgdIVH6d5EFlhvXCFhKmlk5Ftb7c=;
        b=h3AuyMcqj+5A4yIOUPBJkn2Mn8zrXwfbR8RaqE9Nuk9msbVLGG5gFoMiJMG/RXy5OV
         smxheZdx56hkpyzkWG+R8oKTW5ZEUID29jcH2H9gEuLJwLczEwrJD9You92YrgqAs4GL
         G2r0hTiimyZ3DidxoW/SYagjH8THBu1KglUXBMEDaISMiUyJ8R6EJdGzKRqODI4cNOWO
         eQYm4CPCmPU/pUbBSg0xgJW1dOH0NMZYP3FS5h8rUYcwVp1IxXFETyxrNKX+/1nfqDCE
         3qsT+ahAzTm2SmZAfNG8t+o5Msmia/JAD0tzohOloigb01m9YvH+z/uXTJkz/K6WxA85
         61TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747771759; x=1748376559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XuyoTXp3MODuWVPPgdIVH6d5EFlhvXCFhKmlk5Ftb7c=;
        b=c4oejatCg44xLdEDRt/J1gqlw/oJPKtkvFKTTxT4o/ssiw8+1cP5JWFatwCk4eOmRB
         vEPzbbg+0oTVqB+rNdU77mcj7Tk3hAN+RQr5os8g0BwaiyKi49HS8gdURJkJZq4dvt3v
         rvKgWnGtSkGmK25rxEB7VQQSo3rFZwBDumLZZZwz1zPznMzWK5f3JYys8n2wLnS/R5+h
         FDMGkvlTXlH2SnZ+1NNdBf6zns8fvBnE1ozQG5rxb4yQ9SLYalVy9EvMoJswlc+RwthD
         VBAvlUjhXm5z02gQJPYB1TWk8MwxPHzYovigrOWhhMmApIS6bDzQgAov/T5scMWTKflC
         f4YA==
X-Forwarded-Encrypted: i=1; AJvYcCVWEalbXmeiq6B8IopTdjSlOIj9MGj31vDuvRtwCGC2pseY6wi25bZMzG36rIiyzue/Isc/+mDJ@lists.linux.dev
X-Gm-Message-State: AOJu0YzTkO5gh8UbV2srOM4ktyNiSxaFE0/cfKIAW5llykXSqT6odtzw
	SGvHqgeapvuGUXtMMIwb21eGFnXM1NGhVfqbMJonA7TO9SprMjQOE/25KEuDl8hXrPx//xkoCR3
	iXXqVqt7OCoW0E3VSkj2FH6aG3ztgicQ=
X-Gm-Gg: ASbGncvY2btwv/p1QArVBtSCg4cgb/RGG4eX0KjKEMRe4e/ZmwXu3XWG0NDouldlQ7Z
	Cpf3af8qdDYd3OwnsiCkzy0eGHXGLlWFKm1VEGu1Sx8czyKdlRRL/TEcoScDE1dAxVeWMEqH3mp
	4HgDCKv40R9208wSN56w5WMOB7n2FAaxP3B45aht73cHKOklk8mfIvD75ISYTBn3dBWA==
X-Google-Smtp-Source: AGHT+IFf0lnQCFWkFCfdxrk+JO5rkXC6xmEqU21o1BjXv2ej3TB/usiYBL0/wQcTYaIG0NmijVMU13ndZBXFAgFK5yo=
X-Received: by 2002:a05:6512:6289:b0:54f:bd1b:a556 with SMTP id
 2adb3069b0e04-550e71c96d3mr6396517e87.21.1747771759405; Tue, 20 May 2025
 13:09:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520195345.905374-1-ojeda@kernel.org>
In-Reply-To: <20250520195345.905374-1-ojeda@kernel.org>
From: Tamir Duberstein <tamird@gmail.com>
Date: Tue, 20 May 2025 16:08:43 -0400
X-Gm-Features: AX0GCFuYtYwPuzH1amM1oKvd4aiYFppH2qm_DIkyK8s7rHnx32DMa7RGwsTYPAo
Message-ID: <CAJ-ks9=mrZnvME=6++fMNaLFZ8a5DXib5ZLuaYorFZv01GBMWQ@mail.gmail.com>
Subject: Re: [PATCH v2] rust: kbuild: rebuild if `.clippy.toml` changes
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2025 at 3:53=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> We rarely modify `.clippy.toml`, but currently we do not rebuild if that
> happens, thus it is easy to miss possible changes in lints.
>
> Thus rebuild in case of changes.
>
> Cc: stable@vger.kernel.org
> Reported-by: Tamir Duberstein <tamird@gmail.com>
> Closes: https://github.com/Rust-for-Linux/linux/issues/1151
> Fixes: 7d56786edcbd ("rust: introduce `.clippy.toml`")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/Makefile | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/rust/Makefile b/rust/Makefile
> index 3aca903a7d08..107299c32065 100644
> --- a/rust/Makefile
> +++ b/rust/Makefile
> @@ -57,6 +57,10 @@ rustdoc_test_quiet=3D--test-args -q
>  rustdoc_test_kernel_quiet=3D>/dev/null
>  endif
>
> +ifeq ($(KBUILD_CLIPPY),1)
> +       clippy_toml :=3D $(srctree)/.clippy.toml
> +endif
> +
>  core-cfgs =3D \
>      --cfg no_fp_fmt_parse
>
> @@ -405,11 +409,12 @@ quiet_cmd_rustc_procmacro =3D $(RUSTC_OR_CLIPPY_QUI=
ET) P $@
>                 --crate-name $(patsubst lib%.$(libmacros_extension),%,$(n=
otdir $@)) $<
>
>  # Procedural macros can only be used with the `rustc` that compiled it.
> -$(obj)/$(libmacros_name): $(src)/macros/lib.rs FORCE
> +$(obj)/$(libmacros_name): $(src)/macros/lib.rs $(clippy_toml) FORCE
>         +$(call if_changed_dep,rustc_procmacro)
>
>  $(obj)/$(libpin_init_internal_name): private rustc_target_flags =3D --cf=
g kernel
> -$(obj)/$(libpin_init_internal_name): $(src)/pin-init/internal/src/lib.rs=
 FORCE
> +$(obj)/$(libpin_init_internal_name): $(src)/pin-init/internal/src/lib.rs=
 \
> +    $(clippy_toml) FORCE
>         +$(call if_changed_dep,rustc_procmacro)
>
>  quiet_cmd_rustc_library =3D $(if $(skip_clippy),RUSTC,$(RUSTC_OR_CLIPPY_=
QUIET)) L $@
> @@ -495,7 +500,8 @@ endif
>
>  $(obj)/compiler_builtins.o: private skip_gendwarfksyms =3D 1
>  $(obj)/compiler_builtins.o: private rustc_objcopy =3D -w -W '__*'
> -$(obj)/compiler_builtins.o: $(src)/compiler_builtins.rs $(obj)/core.o FO=
RCE
> +$(obj)/compiler_builtins.o: $(src)/compiler_builtins.rs $(obj)/core.o \
> +    $(clippy_toml) FORCE
>         +$(call if_changed_rule,rustc_library)
>
>  $(obj)/pin_init.o: private skip_gendwarfksyms =3D 1

This is only changing 3 targets, right? libmacros, libpin_init, and
compiler_builtins. Can you help me understand why only these need to
change? Is it because these are leaf nodes in the graph?

The `rusttest` target wouldn't rebuild properly, I think? Is it
possible to apply this rule to all rust targets, rather than
individual ones?
