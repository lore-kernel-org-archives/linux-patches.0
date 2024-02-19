Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DA125566
	for <patches@lists.linux.dev>; Mon, 19 Feb 2024 09:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708333564; cv=none; b=q3D319XpJ18BUfzE7Y4EMLzSKkRD+mOGNPqMrLxUebNNW0n2tSzvCjBHmVGXFUa+z43wnpD76u7gSDUaa/l0D7ucSMuqUFVMx2TFspbx8kAB7t2d/c8tjdglEa9hd8Z6UpLLrVv6mpr9z6XDJzSvbnEmXl6rK8spHH/fJHCprpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708333564; c=relaxed/simple;
	bh=xpY3ZmKzm5W53U81GOab3gbPC2jYO9O/nb67la/7GTs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h2VqoWbzNpyn4Hs/fG5EVZ8+FkMax273V7qRoJsU8+w1p0Ak/AzJlXzAMcOCL0DZoWMqLFusdnNcZlfZHB8a8eqV2oHUVLgp0DxPmUZyC/LdcAvzjSERj85oouBNym0GJ9sY5s9236VeNzIfW3ScKqlmhd0zhPEd2/ySXE/Dgy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OMfB88ZK; arc=none smtp.client-ip=209.85.217.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OMfB88ZK"
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-4703dcd55acso81752137.3
        for <patches@lists.linux.dev>; Mon, 19 Feb 2024 01:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708333562; x=1708938362; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xpY3ZmKzm5W53U81GOab3gbPC2jYO9O/nb67la/7GTs=;
        b=OMfB88ZKG0AmbgOWBo/4IHSCkZjlJnL8QjRma64quJBenngbnXxaYBWO9OpehTe+h9
         4kFzhXZuDrzI7Zw4gFMy7//wrR6Vo1ciqrIP5mQClsenRDIZZOE6IAhCjXIIl5Z+WkYW
         3pzTuDhrdRW9TPO3vnNHpzBpnsO68gbAI4WhrsRS4SgVqefJ9bGLWIRciT2D6inZRiRL
         h01/GitBil2DgnZmrAZxDXG3qmQ298PHBtqcgsupzRaSy/ePxKGwF/wAi+aYw2+Ecx2H
         swlhSdOuLESpPZmRhJuBv6dr7G72Tck77AqG5jTmV9shABxGHf/f3dO2juiZTacV/kxG
         lBbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708333562; x=1708938362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xpY3ZmKzm5W53U81GOab3gbPC2jYO9O/nb67la/7GTs=;
        b=RNUUZPrUBuMli/kJmfrRvfngXS/ZG7wGwOJXxz4FxH57ja5rneeRPXNDMoHnZ2Bjmw
         cHZfOTckiEzWHRwrpAFmWtbNJoN7WI/nz1aXyd4hLxnKcqL+RBCyqTXKP6hcFgRUs1G6
         yOedhdJhGM3F9PA07j2T6VzWt4fRHrdCy7w8dIESV/FFEnD/50ioJWa3VNJFMD8kE4oT
         GFP0mw6BVP0FM+1W0w/zalKAUHeVB20H9WeicEaFJzP5tguGCbGY9ce21IRnAuVU+EqG
         1xjmu7kMoiL47jOmPClUHP/pS8TFsp2Lx/B5KiOxR/Ga33jJ1Oha67cT7772OzjmdIw/
         FeJQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8lTOr2zzmI7bvvGz3eLk2su8onPpF4qgKTMpaKpiMctxzA6nieiDiEpvRuW1CoU+D4pWYmYJ76os0W77cbIu8qprbgh30WA==
X-Gm-Message-State: AOJu0Yze4BPEh5zyP9sgVWY3p8C1D/Hh5Z06cmwJ0+5kIVdfzMSOX5qY
	BPazPCLKF03nTJxP6ncjgtDUKEGfdbAE9BV2H27XgizDZmfEsIiWa2NPBSIUQORq+U8u7yZ5J0+
	SQijcM2bPZt0CpY41SMHHskScFd5bmmb6rpPz
X-Google-Smtp-Source: AGHT+IF1//6y3SGVWkcDFEE9RbhBB+iqv2Qr9EGFFuWkEJX/nlJvEdkBWwNoyAZuDtuFmc9lsVY4W0RoTQFSx7ySmig=
X-Received: by 2002:a67:f3da:0:b0:470:4510:eda8 with SMTP id
 j26-20020a67f3da000000b004704510eda8mr995388vsn.21.1708333561626; Mon, 19 Feb
 2024 01:06:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240217002717.57507-1-ojeda@kernel.org>
In-Reply-To: <20240217002717.57507-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 19 Feb 2024 10:05:50 +0100
Message-ID: <CAH5fLgirUqw2hkEgFKOV4a2N2sW-GAGVY=KkkyzptMN+H2txfQ@mail.gmail.com>
Subject: Re: [PATCH] rust: upgrade to Rust 1.77.0
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 17, 2024 at 1:27=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This is the next upgrade to the Rust toolchain, from 1.76.0 to 1.77.0
> (i.e. the latest) [1].
>
> See the upgrade policy [2] and the comments on the first upgrade in
> commit 3ed03f4da06e ("rust: upgrade to Rust 1.68.2").
>
> # Unstable features
>
> The `offset_of` feature (single-field `offset_of!`) that we were using
> got stabilized in Rust 1.77.0 [3].
>
> Therefore, now the only unstable features allowed to be used outside the
> `kernel` crate is `new_uninit`, though other code to be upstreamed may
> increase the list.
>
> Please see [4] for details.
>
> # Required changes
>
> Rust 1.77.0 merged the `unused_tuple_struct_fields` lint into `dead_code`=
,
> thus upgrading it from `allow` to `warn` [5]. In turn, this makes `rustc`
> complain about the `ThisModule`'s pointer field being never read. Thus
> locally `allow` it for the moment, since we will have users later on
> (e.g. Binder needs a `as_ptr` method [6]).

Maybe you should just add the as_ptr method to ThisModule now? It will
silence the warning, and doesn't trigger a warning of its own since it
is pub.

> # Other changes
>
> Rust 1.77.0 introduces the `--check-cfg` feature [7], for which there
> is a Call for Testing going on [8]. We were requested to test it and
> we found it useful [9] -- we will likely enable it in the future.
>
> # `alloc` upgrade and reviewing

[...]

> Link: https://github.com/rust-lang/rust/blob/stable/RELEASES.md#version-1=
770-2024-03-21 [1]
> Link: https://rust-for-linux.com/rust-version-policy [2]
> Link: https://github.com/rust-lang/rust/pull/118799 [3]
> Link: https://github.com/Rust-for-Linux/linux/issues/2 [4]
> Link: https://github.com/rust-lang/rust/pull/118297 [5]
> Link: https://lore.kernel.org/rust-for-linux/20231101-rust-binder-v1-2-08=
ba9197f637@google.com/#Z31rust:kernel:lib.rs [6]
> Link: https://doc.rust-lang.org/nightly/unstable-book/compiler-flags/chec=
k-cfg.html [7]
> Link: https://github.com/rust-lang/rfcs/pull/3013#issuecomment-1936648479=
 [8]
> Link: https://github.com/rust-lang/rust/issues/82450#issuecomment-1947462=
977 [9]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
