Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D5D190468
	for <patches@lists.linux.dev>; Mon, 18 Nov 2024 09:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731923478; cv=none; b=aJPt/AfOh1rkfD9wMNBmyEqO1AaJxLxNc3LQOwDiNDneSTfMTPQ9+u+gZ+PHK6r30Yo8mj4+DzQF9mZjow8FYDE3Qo2MC9NH/Ay6bbox+E7hZiJNn+8C9xrLOyEW7n4Ozrfqg9keMMWKe7NCR66IREjqfv9qGv9Quqqi6sjCR1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731923478; c=relaxed/simple;
	bh=fs4ypAPmfdq2UW6IC9ptzKTs3zVBZiwuFcsDZgF7kSo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GtLOQgYC2ADkPS1WW9qMIJdBLhVi6zlu8A7MY4RRlCy3TWScVujQI7hwoqxhgUPVlZMZwBBBch8kRcN8URfnw3bi4NCE/e36S4LEwkx6UYfm0ZpekRcj3dBHY2tHVZ2rxQnX8cNO94E29c8pvP5J265H4xdbdOyCPs1nydTd4ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0A2EC/S3; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0A2EC/S3"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-382442b7d9aso710332f8f.1
        for <patches@lists.linux.dev>; Mon, 18 Nov 2024 01:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731923474; x=1732528274; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q1w3/EKU4DDNibR7p4Pm58BLCBS93+Vc73KiDAGwas4=;
        b=0A2EC/S3B154gD5EPQm6nPmoDq+P8z433McdfZU2T8bDHM0kP4SGG6WyAQAKsi7DxK
         inK0LYrCOnMuxvDhHwhOv/59brGa1r+CZcJfJfsjXsuhH1255w3ziPCCltlMXmMIyzZW
         +AOCA+tJLOZhaWgJxbA0NvwMEXUMHKcX/QI0V+m14FRlY+fvycsKHedZzkq3h6voUE66
         E47akm/tWbtSKCK5ESXn9FNOfTlOdiTs5awbAniBsVKMp0NBfgGymgtyUWVGxo2GgfTs
         m+0tgjllH3Cp2Y/3Vir7JALKyRIgAqf2bUx4Lf3XgzU6Qq+091isEEcUvA4bsFYLcT8o
         7slg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731923474; x=1732528274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q1w3/EKU4DDNibR7p4Pm58BLCBS93+Vc73KiDAGwas4=;
        b=w4fiFvR13aSa9dhgvm0lNUeRAMUMl11NJAU+tJWz8IDqfckeNecMWhOMsWHR5kkTZ9
         M960hURnOq95Xx7JOrKkusCDcXObbYIHeIcKWPO55RfdCxcVSg0k60hpE7SFnx0cU76y
         i5iMTdqFBQKb0BFfi+V67DuNIylvtH4odxJKx0NQuDJaL5mVJIDGtnP5R5plIED18GBF
         BBgE6rbNzQPPyKNdTnIxPAT8jbOiXBcGxWSgAJXCImyiMerDqBihE/vqeypL4pT3L22s
         5RyuvM9RvKlKAl9BH6h1jNrAkzRuQvdWeTOz9awUdt1YUsfOArYXy+BjjaUOCwFtF2wz
         1OwA==
X-Forwarded-Encrypted: i=1; AJvYcCWcMcMFai3gZ1EwWAOEge9f31XaBCwZpu1xOZABz2Mq4udafX96MKflWGsoj6SOxKWm5Falpxd+@lists.linux.dev
X-Gm-Message-State: AOJu0YwLqljYsyq/Pho6bD2m3tVP95ENCHn8HlPE59jqlTZldkVcmfrJ
	bFcTRHv3bV7M7w+U8Mpenp7Mrx3Pj8x/vUtUNJxe9oIjYVx0NwUb66mOg7e8ErigkDrx37xIt7w
	SLCbK4/sMO6jRP0Hv+16haXCxrb+LWVIgBfxMQTGBY2RvJ6FUXSWQ
X-Google-Smtp-Source: AGHT+IF/HxwlIp/P2WNiK3LFSeQ/hhPkxBPup/QUg6YJO/2lD9/YHMs8mef1h80THaOZxVMjUMY8PZOdqonMoI53F9w=
X-Received: by 2002:a05:6000:402c:b0:37d:50e1:b3d3 with SMTP id
 ffacd0b85a97d-38225905999mr8490191f8f.20.1731923474385; Mon, 18 Nov 2024
 01:51:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241116181538.369355-1-ojeda@kernel.org>
In-Reply-To: <20241116181538.369355-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 18 Nov 2024 10:51:02 +0100
Message-ID: <CAH5fLgjU3BUU4nu6LscYKHTtZ8WSChXvf391v5v=xNK_2w7nrw@mail.gmail.com>
Subject: Re: [PATCH] rust: allow `clippy::needless_lifetimes`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 16, 2024 at 7:16=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> In beta Clippy (i.e. Rust 1.83.0), the `needless_lifetimes` lint has
> been extended [1] to suggest eliding `impl` lifetimes, e.g.
>
>     error: the following explicit lifetimes could be elided: 'a
>     --> rust/kernel/list.rs:647:6
>         |
>     647 | impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator=
 for Iter<'a, T, ID> {}
>         |      ^^                                                        =
          ^^
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#needless_lifetimes
>         =3D note: `-D clippy::needless-lifetimes` implied by `-D warnings=
`
>         =3D help: to override `-D warnings` add `#[allow(clippy::needless=
_lifetimes)]`
>     help: elide the lifetimes
>         |
>     647 - impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator=
 for Iter<'a, T, ID> {}
>     647 + impl<T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for=
 Iter<'_, T, ID> {}
>
> A possibility would have been to clean them -- the RFC patch [2] did
> this, while asking if we wanted these cleanups. There is an open issue
> [3] in Clippy about being able to differentiate some of the new cases,
> e.g. those that do not involve introducing `'_`. Thus it seems others
> feel similarly.
>
> Thus, for the time being, we decided to `allow` the lint.
>
> Link: https://github.com/rust-lang/rust-clippy/pull/13286 [1]
> Link: https://lore.kernel.org/rust-for-linux/20241012231300.397010-1-ojed=
a@kernel.org/ [2]
> Link: https://github.com/rust-lang/rust-clippy/issues/13514 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

Does this need any backports to keep old kernels warning-free on new compil=
ers?
