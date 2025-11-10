Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8340130FF37
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 13:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762782152; cv=none; b=tlI0MYRIX6eOjLJuc0Z7SKZppbX/soZsWOuQk1h+VrfZet64LPqkLoZpBw0dP7EWnt7VtPV8efEi4edNc3vNXH4h/SYELVAvuAzqChL3iAHE1e4sQe7esqHJJLc4Ep7+YN9J4g2A+GKGwkctgiN1RN4gukEfKZPGL5U5LutZJsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762782152; c=relaxed/simple;
	bh=PAdjbqg0ugnMG+0+hkw0gIL4xG3r5RPuYT8bL7baWBs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ggM/zg4Ph7CST0daElLzFw2pF2GXr38jweVr7IjiJ+4wFcmZaIBE2nafap4knJlChyNq1lCJExY0CUaUfMPnpLgLVHUyaUY21i2xFWBb9Xewtlfs+/QLZcWPaWS8HQnUmcNDpOOiEWlKZyVLj75t37dU8BLFhM6ELwHvzfzDcMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p2NJd6eI; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p2NJd6eI"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429c5c8ae3bso2481750f8f.0
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 05:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762782148; x=1763386948; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PAdjbqg0ugnMG+0+hkw0gIL4xG3r5RPuYT8bL7baWBs=;
        b=p2NJd6eIW1UO2oouWfb9CqcZQMmOQqmGZ2F0UUqzV4fQ8ZbbzPiY1nt6sqRtm7hB8Y
         DSt0zY3MtGtx/P40sOM7HHLL8RzQpUg/4ATk058JNI62EIxPU9PF63duGminKuoje9D+
         Eu+rXDwUp8vyR9B9eKuxrEYSZGOVbyiDKBGSzeWzgaCb+4sSQuTPxDfBI8KuSIP0tEtF
         j+/yMoxdbdpb+SDD5xLExMUIMgntnguQkpON2Eor5/ZeLMM5Xo4vA7ewGe/wEv1GFEIo
         02XipIX0NaaHC6Pv0eVoESR0c89CEkJePHOocDjupP/9dyngNTRoBD2SkMXQWpi5ZMs1
         +cVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762782148; x=1763386948;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PAdjbqg0ugnMG+0+hkw0gIL4xG3r5RPuYT8bL7baWBs=;
        b=Li1hLkQ1d9wsIP3QbqXqX4Ie/9H9QqQMBqPwsmtGRGUxb+1/KzhsLeTDSz6hxhx/MF
         GaX6e9qfuRjQWbUpI5ARlbJVV4rmaXMAgITabAvXIu1FsUtF/8m+mmovDAJW8W+L8fhp
         QJS7kL4FcY0cznDOGdT3KfVBiEXkdwc2JTAJUOHMjpuF4AfioadOXcNrWY1viaBYkKtv
         px2E8tWk2QzjVJWT5fXcgCtQ8Blv3Bf0G6aWY/nYD04NOYGmDPMbhOU1Krry0gtMi2rU
         E9rFr1Hu8WEjOr0aPKqBuofUaGOcXMk5OghW6WwfCwk77xqxgFA8SYKqsMyvSsfycmdp
         hvQg==
X-Forwarded-Encrypted: i=1; AJvYcCVtLAZh/D5/sEA8k6rG8xDSXcNUtiMT9arskuyo9ygKMYBZqt1hlnaVm4+SoNHefAIE3M5uB+5j@lists.linux.dev
X-Gm-Message-State: AOJu0YwUZOjO4MuJDAmhtwKNRv06PXN4texdseynPPI/qfG92VL/rCXk
	2PjH8SFYlBHEJu8jwFuuACqyfXhDYSsRhgViGjMjpySL4LCNRkwXSwirt/oq2rmKeZ8YscFumGx
	rL9k0yZ+pkWmoadDjBg==
X-Google-Smtp-Source: AGHT+IGdYLsMwQu7IW6P9IMv+n1Ga2zIS4ZW4YRMrMw3h6aVj+LGhXmv8UdaVn1QueN1sB3azN/HLRdoRa7dYS4=
X-Received: from wrxf7.prod.google.com ([2002:a05:6000:1287:b0:429:de3f:827d])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f87:0:b0:425:8bc2:9c43 with SMTP id ffacd0b85a97d-42b2dc12867mr7026361f8f.1.1762782147990;
 Mon, 10 Nov 2025 05:42:27 -0800 (PST)
Date: Mon, 10 Nov 2025 13:42:27 +0000
In-Reply-To: <CANiq72msN1B8c8QFuH2VK40xXY3=uGiGL=YgAo68o92LTO=kLw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-19-ojeda@kernel.org>
 <aRHRYbHIfxMQ77eh@google.com> <CANiq72msN1B8c8QFuH2VK40xXY3=uGiGL=YgAo68o92LTO=kLw@mail.gmail.com>
Message-ID: <aRHrw2p2YX5TyDYq@google.com>
Subject: Re: [PATCH 18/18] rust: syn: enable support in kbuild
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 02:38:58PM +0100, Miguel Ojeda wrote:
> On Mon, Nov 10, 2025 at 12:49=E2=80=AFPM Alice Ryhl <aliceryhl@google.com=
> wrote:
> >
> > This change seems unrelated?
>=20
> It is needed to actually use them in proc macros, e.g. to build the
> new `pin-init`. We could move it to that patch series, but then it
> means it is harder to use this series (e.g. someone was waiting to
> port other macros).
>=20
> I can put it in a final patch or perhaps just mention it in the log,
> similar to the `quote` one.

With that mentioned in the commit message:
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
