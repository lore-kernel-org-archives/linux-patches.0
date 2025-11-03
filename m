Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2938621A457
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 17:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762192078; cv=none; b=mMGIaF3japOjgVOvRWFY710BcEVHxGBavzAs+FAwtNzwhFXUbMTgPfGYzozkY6jm8s225DPCBHcIY+tMLCp8jEm53gRBqNbxHbUTacqqwO1ItWxi+DJDCufBiCX+jyaJ9Jfr5tOFU6ibpokTD10ve/+Aw2m+Ma3DVC7ZZlB8hbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762192078; c=relaxed/simple;
	bh=SgKh3F2MqSvY/+atnwKQbzqTAv1ZnedXCRhqmQOnc24=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nfbz0JmPjF8RM1VwNUVL8uGtpKHCSEpIeHr68pNLSHMFNxzhg447gsYaW2TTQ9fUbwK1I515g2cq1iFmmafgLQRbt2Vz4NXmIhDUX2pEa/v+ZhIVPLXb9s9bnfcJU10/449Ed3Yq1+WVoxYG1rZHNDkPi7xRorKu3kc0hpqNyIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linuxtx.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=BWoXjnh+; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="BWoXjnh+"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-431d65ad973so18911415ab.3
        for <patches@lists.linux.dev>; Mon, 03 Nov 2025 09:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1762192075; x=1762796875; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FjAKDCwmdTaGo3dsotYYIlyzJDEkmULXfXj+ZPIjvrU=;
        b=BWoXjnh+eLPMMgFLLqdfAMvgb5KqgaGlj02btYiUmDpRbHuJS8oT7QXpOKVVHrLqNJ
         7uz9aRH9uJHKkAR3JGI5y2cXHaTlfKEomZztCGnQU2GRm0lILbRT4xHbf/gI3jMJtdgW
         l6sjN7vO4wzF3ipqcJ2T//KGhYMSgkCefU49M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762192075; x=1762796875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FjAKDCwmdTaGo3dsotYYIlyzJDEkmULXfXj+ZPIjvrU=;
        b=WsL3/vKlg35CiHU8omIT6qVc1ShMJEEwdVg36GNjVCZreWo6r1l7lOBdlTeEhvlDMG
         VP5p8IQesgHFI6fEM08f/PCXMI0UuDFQDbfOs0TF4M6EqmV90buJzZKgBVK7Cum8RweX
         ZkMWPenbOnLAeY1artYCF7NF2EFw8MMzacvRNPXTWWMimQGzP2ubmZYNcUj+4dOF4RUH
         Hp23eS3cjBDOquNjqeTxtIe7p0LkztKWu+OX61qGniXOHA3/YzfpT/Ug2c8raDWeVOG8
         SANHRVrXJt/vBwmZTgpQdXRnQgYtpbd7JytiebcM2kNKR0wWhPSqtqZnpDs+iMBS3BwA
         HOvg==
X-Forwarded-Encrypted: i=1; AJvYcCWu1fk8zoiq68x3w7hOjhY6XUD6T14t6bge6+4RvEAhgIu1L1HXEeGB1cAeemVInVM9jTcecbFn@lists.linux.dev
X-Gm-Message-State: AOJu0Yzty/g7hDksZZDNUfqgJlLMGOT3lhcM76GXBLJd+M7dThc7vmFQ
	bSdZC45aH4KgL98MIZ47qL0Gb7HPwoZIVVNKISuV/pXN7BUwfs1WmBBp22CYYDL8QxFlnr3ghai
	sn5L+nI82Bq3e+bA8lHx4fF0wBJlP78XXygye0akU
X-Gm-Gg: ASbGncuFNjeF4WQoW31QTzq7FWnZa4UrKFfnvgCMxauAoMKH6m22sd/ijxJsJvS03y8
	QZEVhi+gQtpWvVR0M642LFPC2p/JJtTAs9Ef08SQ20h33N6ZbpuD1NLp0wPKl5lkQB9ISMMFift
	kvszlidMHMNWGmO1Kkc3C5c7v5gVm3wT+8WJraLXC0uNB5BmBO7TdNU4gYz3rItjdsKpIOrjWrg
	uHqzdl6fcIlkFfR4JmrW0HlRC/Aeeb1hTeZgozF0qTdJYOUU4+svw0vZ5dqgJlKchmyEz95
X-Google-Smtp-Source: AGHT+IEoZVeUMOUD21Jwvlvqg2DuQudLZFKN+F2ECw8IcJFa2Y5MP2DG+/93iqFN9rXQ8x3ei5N8FSQ+NKgZ+YBpzNA=
X-Received: by 2002:a05:6e02:12c1:b0:42e:d74:7260 with SMTP id
 e9e14a558f8ab-4330d217155mr180383195ab.29.1762192075132; Mon, 03 Nov 2025
 09:47:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251102212853.1505384-1-ojeda@kernel.org> <aQiDjuHK0qpgmj1J@google.com>
In-Reply-To: <aQiDjuHK0qpgmj1J@google.com>
From: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 3 Nov 2025 10:47:43 -0700
X-Gm-Features: AWmQ_bnqgY3TD7_cPq8iTJOPSR5fRhrV4vLHy7AAe5o1XlAgXCBBQw2b5bBW9MI
Message-ID: <CAFxkdAqxuFDMraNBNrOXPDpRzQTQftmc+QQMh_PVMgmLkuv=Tw@mail.gmail.com>
Subject: Re: [PATCH 1/2] rust: kbuild: treat `build_error` and `rustdoc` as
 kernel objects
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 3, 2025 at 3:29=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> wr=
ote:
>
> On Sun, Nov 02, 2025 at 10:28:52PM +0100, Miguel Ojeda wrote:
> > Even if normally `build_error` isn't a kernel object, it should still
> > be treated as such so that we pass the same flags. Similarly, `rustdoc`
> > targets are never kernel objects, but we need to treat them as such.
> >
> > Otherwise, starting with Rust 1.91.0 (released 2025-10-30), `rustc`
> > will complain about missing sanitizer flags since `-Zsanitizer` is a
> > target modifier too [1]:
> >
> >     error: mixing `-Zsanitizer` will cause an ABI mismatch in crate `bu=
ild_error`
> >      --> rust/build_error.rs:3:1
> >       |
> >     3 | //! Build-time error.
> >       | ^
> >       |
> >       =3D help: the `-Zsanitizer` flag modifies the ABI so Rust crates =
compiled with different values of this flag cannot be used together safely
> >       =3D note: unset `-Zsanitizer` in this crate is incompatible with =
`-Zsanitizer=3Dkernel-address` in dependency `core`
> >       =3D help: set `-Zsanitizer=3Dkernel-address` in this crate or uns=
et `-Zsanitizer` in `core`
> >       =3D help: if you are sure this will not cause problems, you may u=
se `-Cunsafe-allow-abi-mismatch=3Dsanitizer` to silence this error
> >
> > Thus explicitly mark them as kernel objects.
> >
> > Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned=
 in older LTSs).
> > Link: https://github.com/rust-lang/rust/pull/138736 [1]
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
>
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>

I can verify that this fixes kernel builds with rust 1.91 in Fedora.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
