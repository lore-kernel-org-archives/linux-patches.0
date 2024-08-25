Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808A26F076
	for <patches@lists.linux.dev>; Sun, 25 Aug 2024 20:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724617522; cv=none; b=aVH25eo5YOGfQs4DOxgiVZEEGHxnBPtCKhx/fiR9xwTn5ZU0LaaalwIcwrwzif8n0EqCMy7esVMNKFiY6bx/MmzsKDgJkIkqaviQJz96/gsiO2I7LX0e63fxEf5ajB9CM6TIXsZsYQM+gDzttTMRPTnq21vTS4FRDPgg/jx1KCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724617522; c=relaxed/simple;
	bh=PLF+XAa7kibaNCJLJ2jSiiFd5un4L9bAbuBTPmptxYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QIGUXkPmaxkKQUyrdKbj8Fs7EGCDWU9XiGHZeZr1Ou1VrRRj1mAs5p8oi6u379LFIKfk7MrFD3GapW/Dt/+rIm6bTw8Fnz3V9Ay4yKuyQXZQdDotL29ozbxiJyTQO0JoZdVxcOg00pa3MhvZ564sKro6BXQx1CyZ+vLXWYhpyeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W0pQC20y; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W0pQC20y"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5d5c8c1006eso2775803eaf.3
        for <patches@lists.linux.dev>; Sun, 25 Aug 2024 13:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724617519; x=1725222319; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=50RI/a1NZmhiwt7nlsK+guAvWBNFkemQkKhjN0j6aOU=;
        b=W0pQC20yB6b6vlW6x7aucGz9ysZWeQO77da4T5OHw2oy3xbhaTdshUOkHKNYxgw1Rk
         fO3eOwIqU55IlIFoeqpW1D0X3+HHQvYQTNNtouMQG1NOz4ChM3EQYWF2Lozl3Um+WFt0
         HRLDAs0sEGbJzA7tm4W2OmeFI4LoO1pbJTejhfgp+EVQXA5cnO57aC06lgZ10SoZsfto
         AGUsD2avfZsep4qjR8rSda/pJ014+qM6kcdMQ/AseJvfcRxjAl9bsdPPYdkmnRAVh+nw
         pWJT4JF+LBVBCB38GpD35eYiIH6Wo9pG0WmHMkZa67egvlGjG64PRQ0dwiKlLKh1x2yH
         A51g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724617519; x=1725222319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=50RI/a1NZmhiwt7nlsK+guAvWBNFkemQkKhjN0j6aOU=;
        b=ZzF4HIYedLhWwiLweNbCP0Qxzf5XzU+pB5P3m5kDZaNEEsZ+zXPdY3fBkSTKGyhdUv
         ZdthCjlUveUgKkjsJVoRf+dyeAjpF87HA2E2SkRcgAXxBxQWo/upnolxdF//IlyC4rrs
         FQduizbVBpV8Sm1vjjIJikcRV7zVJbD+FIFzXH7Ly/KSQ38Hv9LEZe1VwXpA9cDz+FL7
         UPr+nBV/35kPUOuBc4dTTurYVhvD9H2jndrO1Llx6iuEj0AyRxwTQLtEoxXDpVuQ0xaJ
         xKaT5yyR1llbbk83P0vjO2S+CBkjo+NTC3ilYp5ql95GYbaIW8lIz+aDxJy1GZCpqTaa
         NdYg==
X-Forwarded-Encrypted: i=1; AJvYcCWSU+BM/avjVbeI5L1QyAOW7p2dMKO9zJPW6g3wQ+iIAuQF0Wv/Q1dXhRp92v+a1sK0A7k6lwG6@lists.linux.dev
X-Gm-Message-State: AOJu0YwF4fi5AfYNQ4FfPQNcN+eyzeS9FMo0jV0uHN6m9uTqvsUQnzf5
	M5umi6P8US8HSK000p6KjTBuO0r5XatcDdpn6gps1ZjIR3nZr+0oXCIJB/7zFaAoyjouMGldHKF
	KOicgE5jt8POKOyouRTj1IjRyEKc=
X-Google-Smtp-Source: AGHT+IFGU5O5gyc3TgWpgfRqxbYR3vkdTRqKzvhpIj7OVx9PfV9d+nAJJKaOipWlJDXJhWRbgsLMkB5n9Ws97Tw/rZg=
X-Received: by 2002:a05:6820:174a:b0:5c6:9320:2df6 with SMTP id
 006d021491bc7-5dcc6282916mr7857893eaf.7.1724617519570; Sun, 25 Aug 2024
 13:25:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240818141249.387166-1-ojeda@kernel.org> <CANiq72=amLCxV3QRVqK0gVKnGZe_YeqB79LkydEjZ_hJ6_K4QA@mail.gmail.com>
In-Reply-To: <CANiq72=amLCxV3QRVqK0gVKnGZe_YeqB79LkydEjZ_hJ6_K4QA@mail.gmail.com>
From: Guillaume Gomez <guillaume1.gomez@gmail.com>
Date: Sun, 25 Aug 2024 22:25:08 +0200
Message-ID: <CAAOQCfSi9sMqgBzh+v42XGOh2fopytBSjxfPp6kd5DUcGtq20w@mail.gmail.com>
Subject: Re: [RFC PATCH] rust: enable rustdoc's `--generate-link-to-definition`
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Don't hesitate if you encounter any bug to tell me so I can fix them.

Any feedback is also very appreciated!


Le dim. 25 ao=C3=BBt 2024 =C3=A0 22:22, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> a =C3=A9crit :
>
> On Sun, Aug 18, 2024 at 4:13=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> w=
rote:
> >
> > In Rust 1.56.0 [1], rustdoc introduced the "jump to definition"
> > feature [2], i.e. the unstable flag `--generate-link-to-definition`.
> > It adds links to the source view of the documentation.
> >
> > For instance, in the source view of `rust/kernel/sync.rs`, for this cod=
e:
> >
> >     impl Default for LockClassKey {
> >         fn default() -> Self {
> >             Self::new()
> >         }
> >     }
> >
> > It will add three hyperlinks:
> >
> >   - `Default` points to the rendered "Trait `core::default::Default`"
> >     page (not the source view, since it goes to another crate, though
> >     this may change).
> >
> >   - `LockClassKey` points to the `pub struct LockClassKey(...);` line
> >     in the same page, highlighting the line number.
> >
> >   - `Self::new()` points to the `pub const fn new() -> Self { ... }`
> >     associated function, highlighting its line numbers (i.e. for the
> >     full function).
> >
> > This makes the source view more useful and a bit closer to the experien=
ce
> > in e.g. the Elixir Cross Referencer [3].
> >
> > I have provisionally enabled it for rust.docs.kernel.org [4] -- one can
> > take a look at the source view there for an example of how it looks lik=
e.
> >
> > Thus enable it.
> >
> > Cc: Guillaume Gomez <guillaume1.gomez@gmail.com>
> > Link: https://github.com/rust-lang/rust/pull/84176 [1]
> > Link: https://github.com/rust-lang/rust/issues/89095 [2]
> > Link: https://elixir.bootlin.com [3]
> > Link: https://rust.docs.kernel.org [4]
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
>
> Applied to `rust-next` -- thanks!
>
> Let's enable this since it has already been useful for people. If it
> happens to break, we can always disable it. And it may help getting it
> stabilized.
>
> Cheers,
> Miguel
