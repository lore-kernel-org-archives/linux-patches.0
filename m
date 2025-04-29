Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031582512E8
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 21:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745961632; cv=none; b=JByGwfD95hX2te8DWn/AsYC4P1yHCbhiHGdJM7rI1oMxNG9l7pr2Df5j02vU4bfL87QN7GvFH7IPKIpyVdixilSN0jYMvXMk4jWa4hBnmzTt8Hi2XjAhp8M2kEuzJ8k4IEyidFb5VB+6VL/k/uauh+0+TlQivPqr1wF8YumVaaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745961632; c=relaxed/simple;
	bh=Nc8aBTnIKfrJZS9eBFscfQWugrCaRlFMW/WcJ6BU07g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nPfuwTzab17gn4YjoSj0x/WNnVr3+6tZ6zepFkzczfQSK+qIf2KLxaaQNnHeJNAYqrlr8UBNsuIZHlYIqQriHeKvcnlJbSrRhHN4jFCLI1Uimh1HANIMuovCP88m9KShf6nWRCeBS7CJml3pPb/BC12uOYQ8pmGUB2oEvnBHbZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SajXOdky; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SajXOdky"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2240ff0bd6eso13213925ad.0
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 14:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745961630; x=1746566430; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RuEwpUiS1Ijorc0+ZjEUdCrIger40NnHEM6HilN26Ys=;
        b=SajXOdkyaLbyDN0muDVxVX6ZxKo8yHpLKUVwAaczsPJJCMxanP8fMYgF6ShMSUKKlW
         JZm5lBy/3r+3S4V4sGxONF+3HmQddPhH4lyOWYVTjIlk9iEZgISD3k9Cdkw6W3lqeJuT
         GMW0W+t75oM1g4RaoJQkMHtkuHPqLxLxAUG9NvtaxcxWekc1662cyoXiBcsKTdgEFWcz
         OkQStnoSm/HmE0wTaSHbhi0QJNCNzWvFpN+I0/ox9xNP7UmJ9/EfIdrY+dnvRJNtaWCq
         r6aXGmapYV/KcbO+C4zWTU+O/Esqg5bujlTeDllJkJx7gIVQ6/KWtxpODtyKZyGhmiXI
         7szg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745961630; x=1746566430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RuEwpUiS1Ijorc0+ZjEUdCrIger40NnHEM6HilN26Ys=;
        b=XmbsOahojEm/CoSX/JYZ0y/0c5VSlHTDdQAq0ThzgmCE4I6VY6INqlNokrG83zFA1r
         J/FQ84haR+QVtfMFK4hyGzlQSMKjUmxEri62gaRHBgu7gJfPGWUZj7tIpXaQJhYQSvll
         WPBo3NWtne0BZJR0bAfIm2VWUr7jTcq9AFDLKJY/g/fP0PO1LiJ0yMr7CvuFoqAs9/Wt
         E83OaoK/5Y5rz7JcqAv+Ltbb8NG+hj0+flRFQI6yALQSOTIN3LenUa0UXfsQn60eFR8y
         EkyBFwIK5WVrlCHbXZFK6b33c5B/RBOsEvPRrsO9R2qoMOlnJYYO0Xk4wItwG6DYDk7I
         vNTg==
X-Forwarded-Encrypted: i=1; AJvYcCWNXucKwSo4Uq0Sf745hJyIYrPwl/U1STiilU7hhj8dTGmh0g+KrsEeTLtSTeHGiS3VLETr5hB2@lists.linux.dev
X-Gm-Message-State: AOJu0YzNqDL7Gd3YW1V7Jb3uYg2sxziG7XLGs64ldnwg53xvwGgdLz69
	hnE5QMBtHdgHY8UXVxJGwPXw04L8N8udzr5o9O4GkfyjgUDzK3qM6MeC9YVEqd1ev3mp40FjRZH
	KbFwyXvb9/aEtX+QWzi9Qwz4tvBJ9FjV733c=
X-Gm-Gg: ASbGncuc0rIWg97yGLAO7zI1/XbZhUNYa99DFFabpmIxCgDLeZQs8fCMC+gRuamTtha
	n85WfoqPfqjHtgXemNdWIJROTrZXHahyfKF57jQJR8XVXajV8JR5UyvsVUCTtOgXWMUmTLyg5ER
	7017rKec2DNG+6/brEPvK4GIhC1nR5gd0z
X-Google-Smtp-Source: AGHT+IHx6LSagutwWXWlXWcT66mNZZN+2hua2TKdaMPOojePVst4PzjYeGrk56iqzEJdy0eKxnLLmvUlDVvxgEZDNLc=
X-Received: by 2002:a17:90b:4b8f:b0:309:f0d4:6e7f with SMTP id
 98e67ed59e1d1-30a34a96e51mr4788a91.5.1745961630133; Tue, 29 Apr 2025 14:20:30
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250429210629.513521-1-ojeda@kernel.org>
In-Reply-To: <20250429210629.513521-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 29 Apr 2025 23:20:18 +0200
X-Gm-Features: ATxdqUFLuTg4gTSoOk2wtfwNi9ZMgfkk-gHPkVREbWARr9S1gL-bnI_2gdfy1bA
Message-ID: <CANiq72=vWNZ_y_5R45Kd6KrnBwfd55bh8yAqxtvZcVrrHr5eWA@mail.gmail.com>
Subject: Re: [PATCH v2] rust: device: allow `Device<DeviceContext>::parent()`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2025 at 11:06=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> When `CONFIG_AUXILIARY_BUS` is disabled, `parent()` is still dead code:
>
>     error: method `parent` is never used
>       --> rust/kernel/device.rs:71:19
>        |
>     64 | impl<Ctx: DeviceContext> Device<Ctx> {
>        | ------------------------------------ method in this implementati=
on
>     ...
>     71 |     pub(crate) fn parent(&self) -> Option<&Self> {
>        |                   ^^^^^^
>        |
>        =3D note: `-D dead-code` implied by `-D warnings`
>        =3D help: to override `-D warnings` add `#[allow(dead_code)]`
>
> Thus reintroduce the `expect`, but now as a conditional one. Do so as
> `dead_code` since that is narrower.
>
> An `allow` would also be possible, but Danilo wants to catch new users
> in the future [1].
>
> Link: https://lore.kernel.org/rust-for-linux/aBE8qQrpXOfru_K3@pollux/ [1]
> Fixes: ce735e73dd59 ("rust: auxiliary: add auxiliary device / driver abst=
ractions")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Great, I updated this message and somehow broke the title completely
-- please assume it was:

    rust: device: conditionally expect `dead_code` for
`Device<DeviceContext>::parent()`

And, again, please feel free to just `fixup` this patch if preferred.

Cheers,
Miguel
