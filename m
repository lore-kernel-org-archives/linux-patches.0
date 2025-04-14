Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2923228935A
	for <patches@lists.linux.dev>; Mon, 14 Apr 2025 14:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744639990; cv=none; b=JVSywOQUS1a3HdOb/cGkhRrko0j0aMaNvjfvgLkxDlXNZ3r9h9GVAwQs2n8H8Zha/qctTaJ8/VQJTelzti8sJ+bX7A9TatnD+3mtcPOajaW+exUIw10T+zNq2rDuSmDtua7eoz29nOgkcepVGDUa0CjjSiF9EiZZ7CPIZPjDJF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744639990; c=relaxed/simple;
	bh=JGu0at/RD2vqhxqMJrfihAdf+64Bi0oxbT0As0hZ3HY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HmkiTUOWTUGgbLRtOD3Leu1afMmvLBmEYIkgfEH+DA9zszYHBMkThJ1dq0E4JWQQQFbJc5TrZJDYYMj3VLFqudxWbwQHVLdwgmNnmTrqQBZ4WIaJtddRcg01olrJqJOhkxDvBn5ibN9Q/OK6zrzY94r0EIJYKfxDzNYwWXjtXdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1XIOZLQd; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1XIOZLQd"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43cf172ffe1so36998555e9.3
        for <patches@lists.linux.dev>; Mon, 14 Apr 2025 07:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744639987; x=1745244787; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9qyjN4QQdDtsuyJsBJ3ZLaKa0PbRDX12PvwRR8lghAo=;
        b=1XIOZLQdzOiApaOkinntfOrSL50S5hamZFoAuRPspy8h9ZsLnnLJXTyfBOoCr4YU2C
         dPiSjO2gy8ufMD5id24xKU+g8R2N2N4Ci8mGyY75e8iXJCLkwnIZ5Qt3mk6FXcthez3q
         evmCKnCnzoLzfToOl2PgdL42px4s2Jy8lLqnB+8tNCGNYr9kQ0xdRB1MOWHEEAuYkLGK
         75uzPsMunTrsiOz8duF59N2wVxOUpgfmUg6omfa9XW5wni6yGwC/Qd64fkXJN1+QYJQo
         9UV76VT50NfMkA3W87LX6ky3J4zmYQoBcdrN7b7aeZxlqQhtoxThtV9KWnX+HbVbCsUI
         VUgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744639987; x=1745244787;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9qyjN4QQdDtsuyJsBJ3ZLaKa0PbRDX12PvwRR8lghAo=;
        b=wWmDhf4FFeGdiQ5nDOlF/seo0BGoH6RBJmxqy8XyGmXln5B6LHtuGIzxVjNC64yKxt
         /47biNZor2QqQ7mn+tZ88lyyvpMcwW78d3AHC7J/1eGzQqMr6K4JeKWlCcKgijdRz/oY
         lhoNBW7pKkBlj8zkL7hpUmrUw4etf1U/mr+orgDmG76f/EWl0/1N9g+0iJWRofx0oVu0
         oXr7A51NWaAvO6ucIfjRtRPZSlH0CNZosvP1+X3Y/aPbNPKlDdWZpnTt+PSqonfxdQeZ
         4HHCn/gwSZljAYrr14mTHGLnxrtGPzZYdiKUfTBFkJ6fJ1NcqRhLAj5PFNHlycCW+ulg
         dpaA==
X-Forwarded-Encrypted: i=1; AJvYcCX3Gj/XZQ2hL+sZnHC4QIJciiUziPT8+3jIulJS6AZqJSC2UGRkdZix8Uuyp/NliiS2hMYSWfdj@lists.linux.dev
X-Gm-Message-State: AOJu0YwkZXAV7+dMeoBqW1m7LPp3cAiVeEUubuv759hzeb4p6/s/DKV6
	slcQse19dcIYmQsUqtZAJwUwwKt1AguaRZSzhALZY7xtoxnBAy3D5XZuTqmCMGP15Exl7Ko+YP6
	6D434BL8A0TG/gA==
X-Google-Smtp-Source: AGHT+IGft2n73Jgd/n7sFueItrFb4zEsB1AkLjdcXqlT5WpXoWdbJLqYxkVeAdfukXvsCm+OlwDWnyhr39heiQY=
X-Received: from wmhu23.prod.google.com ([2002:a05:600c:a377:b0:43d:1d5b:1c79])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:83c6:b0:43d:b85:1831 with SMTP id 5b1f17b1804b1-43f3a7d8c5emr126843825e9.0.1744639987578;
 Mon, 14 Apr 2025 07:13:07 -0700 (PDT)
Date: Mon, 14 Apr 2025 14:13:05 +0000
In-Reply-To: <CANiq72ngfTJ5PTYaJOOQ2NedERrLYzA62hL8Fgw5C4QkuZ2R-Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250413005650.1745894-1-ojeda@kernel.org> <CAH5fLgiF0kZdOYaQi18_LTNx6Onq-5PBomA=bwS0m0z+C0wtvg@mail.gmail.com>
 <CANiq72ngfTJ5PTYaJOOQ2NedERrLYzA62hL8Fgw5C4QkuZ2R-Q@mail.gmail.com>
Message-ID: <Z_0X8Z9M2H0mmcK8@google.com>
Subject: Re: [PATCH] rust: add C FFI types to the prelude
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 14, 2025 at 03:22:44PM +0200, Miguel Ojeda wrote:
> On Mon, Apr 14, 2025 at 10:47=E2=80=AFAM Alice Ryhl <aliceryhl@google.com=
> wrote:
> >
> > I wonder if it would make more sense to rephrase this section to first
> > say that rfl has type aliases for the C integer types called c_int and
> > so on, then mention that they are available in the prelude, and then
> > at the end of the section have a note that we don't use the type
> > aliases from core::ffi. I think focusing on how to use C integer
> > types, rather than technical details about how they are defined, is
> > more relevant for a reader who is just looking for coding guidelines.
>=20
> Hmm... I see what you mean. In other places in the document, we start
> comparing with userspace Rust in order to establish a bit of context.
> But, more importantly, in this particular guideline I think it is
> quite important to say "do not use the usual ones", because they are
> actually different types, i.e. it is not just a style thing.
>=20
> I have thought a couple times about perhaps changing the overall style
> of the document to have a 1-liner short summary on each guideline --
> some books do something like that consistently. And perhaps an
> example, before a longer description. So something like the following,
> which is closer to what you are suggesting:
>=20
>     To refer to C types, use the FFI types (aliases) available from
> the `kernel` prelude, e.g. ``c_int``.
>=20
>     For instance:
>=20
>         ...
>=20
>     Refer to them with a single segment path: e.g. ``c_char`` instead
> of ``ffi::c_char`` or ``kernel::ffi::c_char``.
>=20
>     Do not use the `core::ffi::*` types -- they are different and some
> do not map to the correct C type.
>=20
> But even with this style, I think it is important putting the last
> sentence in the "1-liner summary". Otherwise, someone may skip the
> guideline thinking "oh, OK, it is just a style thing about using just
> small paths, I will fix it later", without realizing they are actually
> different sets of types unless they read the entire section, no?

Hmm. Maybe, but I think having it at the end is okay. Could we catch
core::ffi with checkpath instead of clippy? Just search for core::ffi?

Alice
