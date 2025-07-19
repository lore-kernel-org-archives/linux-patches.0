Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65C67FD
	for <patches@lists.linux.dev>; Sat, 19 Jul 2025 21:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752959177; cv=none; b=jPMzP8JIkpnZYrkAsJl59ODLxx6KsufVi+COiAGA51BIed6gJog74T+o93iGv61moF0B7FxbiGwz2aVNoV6KtvONO+uhL3ROulgBd3tLw0whkcCocijCLr8VQ6QHCyaZxnMoiKFOyMkzqQHbhtmSdbuvkYmwIaMK+DGYeFWXUQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752959177; c=relaxed/simple;
	bh=nyswjgChzex87fkUmGlz803mOXSUIG3Re0obcW/WBZk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lAZDCM7J4I1J/DHRh/IzC02xVFZ+ptArdoJjyOfi8hwW1S2+UHU1rNsKWF+RQ/dmZK2knt/y6wm8lUVDthvV/dS6XUjXZUTwysTMXy51z8f9FmVLg37/KGbIXc1O6UTpm5zh7hwp5QOGlCUzpIyTZRgBAq7rG0e+Y3g/n1fo8l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BtNv+WV8; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BtNv+WV8"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-558f7472d64so3700488e87.0
        for <patches@lists.linux.dev>; Sat, 19 Jul 2025 14:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752959174; x=1753563974; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDD5lvVgbLQzMHEKqvD4drpjZqiteKdnziSv4nMIVYg=;
        b=BtNv+WV8qFt9q+8C8XBoZ1iwzdnFU8cocWn5TYMQMH2se1jxOJ8EErGp+DOxgpcqtz
         F1YBKeXIw3q04UF7kPSD2Q7A27PcqysdORW2roYk8hcM5RWx0jswiW3XZ5uQqY7ECC3f
         1IhtlSzqylP+etOgaCJnN76fzj2wEx/97/9xXytgRE8NvsQCYg0Ely/no3ivYUnD1kX3
         i0zjk+QNux1uO8i97uBbR8RzsoxVVzhinjamWzPY8IzMPzoN+nVw3Zibulf6DP+AP+/S
         n06KBQE7yfHmp/s4lSjRHeLn1AO6nEXbwfs+WXfl9ku4l+eFc4CyFYf1C4dzPLrTVHuH
         K3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752959174; x=1753563974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KDD5lvVgbLQzMHEKqvD4drpjZqiteKdnziSv4nMIVYg=;
        b=ibYZT4as1zkaYuFEFuLRKSnL9HJnVrJJ2+jWpQzeV9lIJFCWaiAjl/6YCwhmAERX7p
         eT+mIOfqlpgoR99LYSLHaiHfleUuMlFl61/TnPnjW00WevkCljV2jfwDzc5vvawW5bdS
         M8bxKLacj8ppl0+qfprKOV9ArQhBWNijutctcWjbzf2zGpEFApXvAqDf5Sn4x14xaT8o
         NToSkwWONzXzHfE4++AHy7K+rGvtFOy1M2k/A4hmwie1n0qreUNF98ePNr+akrl/zrkY
         2Z/tt3A2cyiV2KX56wZnOMSHsUc/6frPK4EPI2F15qQeWG0Dhh5b8e1hu14+i/7ATIog
         4OPA==
X-Forwarded-Encrypted: i=1; AJvYcCWinAgd3YJY7FhO+2bfRTMPFiEXxEaWSbkebS0+Qco/sOQklgjv4SJUmh35Djx493NEpUAYjSfh@lists.linux.dev
X-Gm-Message-State: AOJu0YywEXbzWlilPFZ2kOZqsNL0jiMdduYPFs6wcG2OF2/ZEcL6xrfl
	2MrXqOS776Nl3QUdinbcAcnxtLhEyc/bITKQiCylzzYxMFzrdbU4Y+YuUznxULeAA9VrRMWMR/9
	xzrq5H+KF9mvdbytGbKtL6IGXV15ChwA=
X-Gm-Gg: ASbGnctvqBdin3l8JnEJx+8EHLmNSG9OuKn+8O8eUoYYFw8v0+rzg4bSiF08LzOV423
	qbh2MKd7vOlzLtg7K29HZ76xhLPvLWUFnY2gaGyGMyE4JRxhigXpWjP5HGwoiR1/eTFM+JSBBaC
	wP3mXLKIwaJvMkGeeT6vGzEI+a3QUI4tsg25izSyrnFXZUceZWuteJGa97RCwF2aKRItNvDjP6C
	hAHtADowEhJNFjy/h+BMMsh/dx8a3tLIIPXMy3PfA==
X-Google-Smtp-Source: AGHT+IFel6LcPVo3L3MCsNHOrcdqbyyvw2loT4c8a3F8Eu9ST3sLv5A/WpAB8b1q4cUP+onWoJI49Fm8mHtQap8cx7Y=
X-Received: by 2002:a05:651c:b28:b0:32b:9792:1029 with SMTP id
 38308e7fff4ca-33098f6680amr28756151fa.14.1752959173475; Sat, 19 Jul 2025
 14:06:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250719183649.596051-1-ojeda@kernel.org>
In-Reply-To: <20250719183649.596051-1-ojeda@kernel.org>
From: Tamir Duberstein <tamird@gmail.com>
Date: Sat, 19 Jul 2025 17:05:37 -0400
X-Gm-Features: Ac12FXwNuJFlNB4FrlOz_4LZnrwumCxbRuVE87wbB2tt8bbMYaX8TCEyZEcw5sk
Message-ID: <CAJ-ks9=Ye4v4g0roTu_CJSveRwj6c6P95kGfzy29VEh2c8XHKA@mail.gmail.com>
Subject: Re: [PATCH] rust: list: undo unintended replacement of method name
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 19, 2025 at 2:37=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> When we renamed `Opaque::raw_get` to `cast_into`, there was one
> replacement that was not supposed to be there.
>
> It does not cause an issue so far because it is inside a macro rule (the
> `ListLinksSelfPtr` one) that is unused so far. However, it will start
> to be used soon.
>
> Thus fix it now.
>
> Fixes: 64fb810bce03 ("rust: types: rename Opaque::raw_get to cast_into")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Tamir Duberstein <tamird@gmail.com>

> ---
>  rust/kernel/list/impl_list_item_mod.rs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/rust/kernel/list/impl_list_item_mod.rs b/rust/kernel/list/im=
pl_list_item_mod.rs
> index c1edba0a9501..3f6c30e14904 100644
> --- a/rust/kernel/list/impl_list_item_mod.rs
> +++ b/rust/kernel/list/impl_list_item_mod.rs
> @@ -252,7 +252,7 @@ unsafe fn view_value(links_field: *mut $crate::list::=
ListLinks<$num>) -> *const
>                  // the pointer stays in bounds of the allocation.
>                  let self_ptr =3D unsafe { (links_field as *const u8).add=
(spoff) }
>                      as *const ::core::cell::UnsafeCell<*const Self>;
> -                let cell_inner =3D ::core::cell::UnsafeCell::cast_into(s=
elf_ptr);
> +                let cell_inner =3D ::core::cell::UnsafeCell::raw_get(sel=
f_ptr);
>                  // SAFETY: This is not a data race, because the only fun=
ction that writes to this
>                  // value is `prepare_to_insert`, but by the safety requi=
rements the
>                  // `prepare_to_insert` method may not be called in paral=
lel with `view_value` or
>
> base-commit: 23b128bba76776541dc09efaf3acf6242917e1f0
> --
> 2.50.1
>
