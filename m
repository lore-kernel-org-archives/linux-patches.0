Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9493196446
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 10:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963903; cv=none; b=aVRfmkK5pHd1VPK98AXgIguDfGk4t4qdgExnAC4brdPWZrhdTWVkxSv8XSs7YWHqrgEeaDi2C9PB7NGrYPsoWBrxT4IUNF72lfwdj6T5nrL12r5Yi83bvt2KYK2c/ah2sTfz/LPFE2d3OHwOe1d0o6BxL9bKIb6sA40xNUalo78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963903; c=relaxed/simple;
	bh=oO0euwLlbAwqUe9osbySCpSY/KLWU9E6/QQ8kCU2eKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OSRxgy7hD5dU2kYGPjhPf5zUqT4v4QJRMdHbqWDzgjmPwH7GAjTWcqhL9A8xN8FWLnWZ9oqfAsk9Rv5MU01iAnQIesvr6nITSi2yEe9MW7lU+GAxuz2xepIuQCF0snNqjAylvpiKXOHX+vdaWp7Xjc0g1BeYtrAEY0+4b5NHHVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T8WArEm3; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T8WArEm3"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-374cacf18b1so3090462f8f.2
        for <patches@lists.linux.dev>; Tue, 10 Sep 2024 03:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725963900; x=1726568700; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LItVPrRgPRXz93pKfnwrtSMcwlhD9zKRya1Te/J8aUM=;
        b=T8WArEm3AlYlHd027OAi/uZWJJf65CN4TMO0tNaFaSWHbCY6+izLTXaVuxiLCeYNQa
         IqQ6Xwf9ZF47euDvZTIUiGYsveO5FbihVxBHjrGSS3dh3C580yvbOUDjeoeK09TKrNN2
         8//30Zq8rLhqM+4bl3azN+h+fNeUfupPsWsVfJIyu+ySRzkS+R+Hn5ASnlJ+ME323j21
         Ej3KxUZlN9bgPyYxI/s8pCkHO3vqpi+/W6eby6lQsrxrSrF5ZwMi1A1AHBd216z+L8KH
         LeevzQxueKFe++Sp2pjTEH52rBn+PZSFXaRCYv5IIt6B7jcqtZpiFcY5BWZtHP0yNMV8
         BQkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725963900; x=1726568700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LItVPrRgPRXz93pKfnwrtSMcwlhD9zKRya1Te/J8aUM=;
        b=JIG1tqJlxI+/YxTQpNCXkorSYMKGEqIDGg/plvAT0UgRM0az7LfIT2s2kSKAX4NQU1
         tnNbmjOc4RWKb7Ol3Gs7njTWBWEiSIIIK+NhVaynJM2Avl0VL6Mb2QUQr4q9F65aJZeS
         Z5nXmQFw9UI+bSrUqpci7HMSGLLHd93uAiZ6b/gtE0R9fgVptNDq4ItMPqwEWWLz7dZi
         qBqkIIdpm+Rq/gIoVyn+g92Tp5ajmFKtdCwk7oz1uKF+reMiKdUe1s+dfOesq80IiWpS
         sRzkP0yFzllM1ViE6EB/2tQ/EBC1ZI4mXvxxRt16viB1Kpzir4hFHKWeXg6GdAWGCI9x
         p1/g==
X-Forwarded-Encrypted: i=1; AJvYcCXB/4qwQrY+5vyyicV8ipfFxdqtlczQyUlcvDprv5X4GDcp+00bJ6/G+rnIYhwZNqDNNEYnC4U3@lists.linux.dev
X-Gm-Message-State: AOJu0YyvddmJuELl1oHSIbRPnqr1MZbcXysYTTgwBi9Gbj2LhSvshPXD
	Ayw15pEyVT2sUxFfogm3YiAR0wPmHjTA1Lufs2eLMPvnu5pYY/CbvexMdAF6zaMtI4IR3CIBS9e
	bFLXFRuDbPbD94Ss4cZe6hVoQ0uXZwnQVjr9Q
X-Google-Smtp-Source: AGHT+IFE+aeaOIu3mHHqd9rU8fMjNrnXlDx31+3SUTswLoHNnWIdHXKc2Ye99D86WGP6iwo1+QjiSLM9Js5qXzIwyYk=
X-Received: by 2002:adf:fc91:0:b0:374:c432:4971 with SMTP id
 ffacd0b85a97d-3789268e9a0mr6557616f8f.16.1725963899859; Tue, 10 Sep 2024
 03:24:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240910092557.876094467@linuxfoundation.org> <20240910092604.257546283@linuxfoundation.org>
In-Reply-To: <20240910092604.257546283@linuxfoundation.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 10 Sep 2024 12:24:48 +0200
Message-ID: <CAH5fLgi7_=3W3WdPR2KcUW73Ma=SXo-dX20z0xx+AK4S_N3SwQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 153/192] rust: macros: provide correct provenance when
 constructing THIS_MODULE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Boqun Feng <boqun.feng@gmail.com>, Trevor Gross <tmgross@umich.edu>, 
	Benno Lossin <benno.lossin@proton.me>, Gary Guo <gary@garyguo.net>, 
	Miguel Ojeda <ojeda@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 10, 2024 at 12:12=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Boqun Feng <boqun.feng@gmail.com>
>
> [ Upstream commit a5a3c952e82c1ada12bf8c55b73af26f1a454bd2 ]
>
> Currently while defining `THIS_MODULE` symbol in `module!()`, the
> pointer used to construct `ThisModule` is derived from an immutable
> reference of `__this_module`, which means the pointer doesn't have
> the provenance for writing, and that means any write to that pointer
> is UB regardless of data races or not. However, the usage of
> `THIS_MODULE` includes passing this pointer to functions that may write
> to it (probably in unsafe code), and this will create soundness issues.
>
> One way to fix this is using `addr_of_mut!()` but that requires the
> unstable feature "const_mut_refs". So instead of `addr_of_mut()!`,
> an extern static `Opaque` is used here: since `Opaque<T>` is transparent
> to `T`, an extern static `Opaque` will just wrap the C symbol (defined
> in a C compile unit) in an `Opaque`, which provides a pointer with
> writable provenance via `Opaque::get()`. This fix the potential UBs
> because of pointer provenance unmatched.
>
> Reported-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
> Reviewed-by: Trevor Gross <tmgross@umich.edu>
> Reviewed-by: Benno Lossin <benno.lossin@proton.me>
> Reviewed-by: Gary Guo <gary@garyguo.net>
> Closes: https://rust-for-linux.zulipchat.com/#narrow/stream/x/topic/x/nea=
r/465412664
> Fixes: 1fbde52bde73 ("rust: add `macros` crate")
> Cc: stable@vger.kernel.org # 6.6.x: be2ca1e03965: ("rust: types: Make Opa=
que::get const")
> Link: https://lore.kernel.org/r/20240828180129.4046355-1-boqun.feng@gmail=
.com
> [ Fixed two typos, reworded title. - Miguel ]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

The opaque type doesn't exist yet on 6.1, so this needs to be changed
for the 6.1 backport. It won't compile as-is.

> ---
>  rust/macros/module.rs | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/rust/macros/module.rs b/rust/macros/module.rs
> index 031028b3dc41..071b96639a2e 100644
> --- a/rust/macros/module.rs
> +++ b/rust/macros/module.rs
> @@ -183,7 +183,11 @@ pub(crate) fn module(ts: TokenStream) -> TokenStream=
 {
>              // freed until the module is unloaded.
>              #[cfg(MODULE)]
>              static THIS_MODULE: kernel::ThisModule =3D unsafe {{
> -                kernel::ThisModule::from_ptr(&kernel::bindings::__this_m=
odule as *const _ as *mut _)
> +                extern \"C\" {{
> +                    static __this_module: kernel::types::Opaque<kernel::=
bindings::module>;
> +                }}
> +
> +                kernel::ThisModule::from_ptr(__this_module.get())
>              }};
>              #[cfg(not(MODULE))]
>              static THIS_MODULE: kernel::ThisModule =3D unsafe {{
> --
> 2.43.0
>
>
>
