Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9697691C
	for <patches@lists.linux.dev>; Thu, 21 Dec 2023 21:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bg5uUgNr"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-dbdb8e032f7so1450803276.1
        for <patches@lists.linux.dev>; Thu, 21 Dec 2023 13:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703194740; x=1703799540; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PXU/wSqHvT5f9DP/nkZcmoPPi2e4LA2mSngSGEQpvNg=;
        b=bg5uUgNrLvWh9zyrfAvyQafHm6y5L1q2XJIrtjIUz6pbmQONvvI78aWeBJUVr87CNL
         kzhemaV3SKQG/Y5fdJpx2DrqPA80BRRTZuvqogw77xqKZ7QW2BXc2m9l/IoWpdTyq9LV
         Mq1bauTuovIb+MsGqWRZat0LTlW6E9ZjC3PigC/dMwLVW/PBpQdL0fgdIGdJi0PxBO7K
         GyiDbyk4KrIlNHOVEND8D6veCHPTNO97hQa+8XUpZ9rOotXyZIrZT7KM53bi9qyMzKLw
         atFvL5kDmrucDOkNu0rrbBYPBbit84P4YLl5EFzeHwQ+CLORhIZTpbtFRZPycseWtRIf
         H0Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703194740; x=1703799540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PXU/wSqHvT5f9DP/nkZcmoPPi2e4LA2mSngSGEQpvNg=;
        b=HRPkaPTh7+BUoq4JoKKCKsO+2cp3IqNcwitdjzbOb5VjQJE7YE3ky9ArKwjHzUE9bj
         xOHugBhxnCcvmqcYxhn4niuDzn2ksM7Wqud/6P936C2KtEk7N41tQZLKrc9Znf6ZLzOK
         zGQDarxWg0ue1ZLPyk4IJymtZI1LtQ4nPUgWx/Pxts+ggwadTCu846hLwgp920sdlQeY
         iDkOMtv+Xs56zXgQlFLD6ZFftCDJNx79S0w9ubUQmYqd6GCtdtxxanjYBojJsDQ63TEI
         ReSwTz6QjKWKR5ypXtXIV0M7r/tp0HoAEcd9MDSxBTijS4fbvsgglk/Wlnp7DyYOHTPz
         Oiew==
X-Gm-Message-State: AOJu0Yz/R0M58UBGoinKj25dPMJSVvlHfjcvUscNEiZLN/qxMOFgLI30
	i+65QfAEsBTwfXwFT3CuYkudSBesy72s1NR0gqY=
X-Google-Smtp-Source: AGHT+IEhMe74JI+7lQZDzUiCsOMUeUyAr8WAul676bT3WI7OIr6gqXdlQpGTwTIT/+hE3RCkjK+kJGE8F59mVr5xOFU=
X-Received: by 2002:a05:6902:604:b0:dbd:c25f:972b with SMTP id
 d4-20020a056902060400b00dbdc25f972bmr372437ybt.56.1703194740681; Thu, 21 Dec
 2023 13:39:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231215235428.243211-1-ojeda@kernel.org>
In-Reply-To: <20231215235428.243211-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 21 Dec 2023 22:38:49 +0100
Message-ID: <CANiq72kfpdNdCXtxFM-YVLuOp34u_edieX0q_a94-5kAxdGRWg@mail.gmail.com>
Subject: Re: [PATCH] rust: support `srctree`-relative links
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 16, 2023 at 12:54=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Some of our links use relative paths in order to point to files in the
> source tree, e.g.:
>
>     //! C header: [`include/linux/printk.h`](../../../../include/linux/pr=
intk.h)
>     /// [`struct mutex`]: ../../../../include/linux/mutex.h
>
> These are problematic because they are hard to maintain and do not suppor=
t
> `O=3D` builds.
>
> Instead, provide support for `srctree`-relative links, e.g.:
>
>     //! C header: [`include/linux/printk.h`](srctree/include/linux/printk=
.h)
>     /// [`struct mutex`]: srctree/include/linux/mutex.h
>
> The links are fixed after `rustdoc` generation to be based on the absolut=
e
> path to the source tree.
>
> Essentially, this is the automatic version of Tomonori's fix [1],
> suggested by Gary [2].
>
> Suggested-by: Gary Guo <gary@garyguo.net>
> Reported-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
> Closes: https://lore.kernel.org/r/20231026.204058.2167744626131849993.fuj=
ita.tomonori@gmail.com [1]
> Fixes: 48fadf440075 ("docs: Move rustdoc output, cross-reference it")
> Link: https://lore.kernel.org/rust-for-linux/20231026154525.6d14b495@euge=
o/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

By the way, since I didn't mention it: this obviously requires the
source tree to be available at its path, so we may want to improve on
that later (e.g. exporting the needed files in the output folder), but
it is a strict improvement since it fixes the immediate issue, it
cleans the paths already reducing the maintenance burden (i.e. we can
keep the syntax even if we change the rest) and is a smaller change if
we decide to send it to stable later.

Cheers,
Miguel
