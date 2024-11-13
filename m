Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C7B1EBA0A
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 13:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731504859; cv=none; b=IPDa/bHIcrSC1ctk6mNRu5wH5bR3CWLJ0lvGsD5J6/blsAMtSyYxA2YTGoY5+ekQqJ1hbZzhB6QBa0uraIgYgfTshRCS0/IsUnGYySYA8rnfClL1XVA86VXoH0Nk7CQIEgi/WY2DuJIX1xSO5u1agy3q/WDRsbbnsVnFW+bRfo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731504859; c=relaxed/simple;
	bh=KZ1cVqAR4M3IuF9kRDgut1hnAjGKGAjMfbKFCXnZxlQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jL0LKpJ/GhCWxKQXgnJJyaHyCSksE14/W/1a/S3zbWJtjzvc5zWpGrPY8voCTQcApMEsD4vMeNKjJfuQNpnTb28l3idNENSAExtFjl+udPrp7RxTP+CKR7KRsJkgURkmXdvLJRCJFekda8/s02QIxkRNtswMJ1O03ZI5BrpkCWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T1k9+fOy; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T1k9+fOy"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43161e7bb25so56417415e9.2
        for <patches@lists.linux.dev>; Wed, 13 Nov 2024 05:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731504856; x=1732109656; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r+L+l6iciWCr4lKpFcEtaZCqtWfcPHk/ITTH5PaehCo=;
        b=T1k9+fOyd+pFoTfOyQB1ETFXnARWJKBhFSv5LL9pNt6B386VNl1Ft4C9PwHNeLazQe
         gGETORvEyLcC9NnwQhiEV3JOXz51bwZMEPTQpPUkxAV54/tqbXZHN7o78u9vK0XgSVtg
         xTX1CLKcot0nmlnxnmm72Jr0lH1/lcMEoN07E1LsBzoMyKti6SRW0rtdxj0jnmv4ntFA
         1GYHwGU/gJ2bjft7wq0H6D+BbJ3awCc136DSer0RUdnqG9goFyyoiZxXAXi1KuxZnkBG
         e6MnenrOY47p+KDvbxgH9GBnScPrItzA/tCzCsHryo4e9Oo0iKJLW222a0rffR8p4TeJ
         zzXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731504856; x=1732109656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r+L+l6iciWCr4lKpFcEtaZCqtWfcPHk/ITTH5PaehCo=;
        b=dvPqvRy6SjdQ1E0WIBu6cBDBn/Rqu3zRRm+U4z1+ZsrYVKQaus465NYs4nmYFM196o
         1S5G5EFKVsTsqM4yY3Xrq3q2jU2bRppNYTieOLgaLHDR/ARO3jgaEXW9jEx9lWd8RSdl
         Z26ca6Onhj7RfoGnVKBy7hteu5VxgM34bSiQvpZfjohVZ23SwoDrSDZElhdb7Mh2Wgqg
         NSmp03RapPnTBHJ2n0B9RQkrwQi0USyGthvQVEaPs2E7r8P7Igz0bml6AmdoIRt3jN51
         o3Z6xobWapYi1s1dgtCFczddyAyoPNk6ObdfCxJVDOA9xDDU+13zys1EUVXgiDXg4CY+
         mDKw==
X-Forwarded-Encrypted: i=1; AJvYcCVMyPVZ0CBDoJhGKp3hiOOAAd+pQ2M2rcK2dsf1llNZnp3+RwPJmUEzYKTV1rMoX1t2RstjOmyn@lists.linux.dev
X-Gm-Message-State: AOJu0YzvmT++nD4tfo5wlnu6iLy7ezjXf8NSDYUrOwZN1Ni76Ew2wnBY
	/uoJBqYPUcSru2vmtNJEjOsdmqwXsvXLyPG5a8CKw+LCNckF8ANYlFpf3e/jn1xh7iCY1OupNx9
	534IxpFDV0s8fJ0oP2N0jpOu/z/B6tfwp/JLz
X-Google-Smtp-Source: AGHT+IEXrXCRg6Pm6Erkl8kn4myTQuZfk+jsms0GRM+sUn39EGENQJna6yyxHKVvww5XL3XcEMAW4LSvyPWbOYGFIGA=
X-Received: by 2002:a05:6000:1a89:b0:37d:45ab:422b with SMTP id
 ffacd0b85a97d-38208124c87mr5152314f8f.31.1731504855525; Wed, 13 Nov 2024
 05:34:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241112184455.855133-1-ojeda@kernel.org>
In-Reply-To: <20241112184455.855133-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 13 Nov 2024 14:34:03 +0100
Message-ID: <CAH5fLghFZTG2X_mYE2yGJwPM31NrJdkA-cpZTCYsdghR8YdY8Q@mail.gmail.com>
Subject: Re: [PATCH v3] kbuild: rust: add PROCMACROLDFLAGS
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, HONG Yifan <elsk@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2024 at 7:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> From: HONG Yifan <elsk@google.com>
>
> These are flags to be passed when linking proc macros for the Rust
> toolchain. If unset, it defaults to $(KBUILD_HOSTLDFLAGS).
>
> This is needed because the list of flags to link hostprogs is not
> necessarily the same as the list of flags used to link libmacros.so.
> When we build proc macros, we need the latter, not the former (e.g. when
> using a Rust compiler binary linked to a different C library than host
> programs).
>
> To distinguish between the two, introduce this new variable to stand
> out from KBUILD_HOSTLDFLAGS used to link other host progs.
>
> Signed-off-by: HONG Yifan <elsk@google.com>
> Link: https://lore.kernel.org/r/20241017210430.2401398-2-elsk@google.com
> [ v3:
>
>   - `export`ed the variable. Otherwise it would not be visible in
>     `rust/Makefile`.

Despite the missing export, the previous version worked for us too.
I'm not sure why that is.

>   - Removed "additional" from the documentation and commit message,
>     since this actually replaces the other flags, unlike other cases.
>
>   - Added example of use case to documentation and commit message.
>     Thanks Alice for the details on what Google needs!
>
>   - Instead of `HOSTLDFLAGS`, used `KBUILD_HOSTLDFLAGS` as the fallback
>     to preserve the previous behavior as much as possible, as discussed
>     with Alice/Yifan. Thus moved the variable down too (currently we
>     do not modify `KBUILD_HOSTLDFLAGS` elsewhere) and avoided
>     mentioning `HOSTLDFLAGS` directly in the documentation.
>
>   - Fixed documentation header formatting.
>
>   - Reworded slightly.
>
>          - Miguel ]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Tested-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
