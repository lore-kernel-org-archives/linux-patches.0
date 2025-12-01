Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8226290DBB
	for <patches@lists.linux.dev>; Mon,  1 Dec 2025 23:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764630828; cv=none; b=SSHhSCCAoErKWlU95+MAFFQ7WKfDVkF3tnvXAvNTqxF8h3Be7vmJHMTlK7SvwXcb8LUXMaFlrwlv1fnV85E1/QocBbXVSxsc55JqD1T1NM38s5aklKYuupr6ZV1rg8I/bjUKXn5YBGaGz6B2BfKPaVhdMbX8uvAhyO9HFg7+nKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764630828; c=relaxed/simple;
	bh=Ngf+KJNQQvbi+fFDERAbtaRR97fIqpGeUdUu552Airo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MOY4Bq7PvyCVwyEPztEwtUTtJr7YNEuNB2fyAnO2O2xThE1McmbnHNTLLU+lBRRdSzxNLeYdJl6yZ4Vjq1WkDGIifzsurOAYHxxIxTvGcDbB1bUX9xtd+E7ccA+wFcy0xkAgc38kE96yVNpQk1rUqhwCJ4Q4/fT6gFzFw4R2szQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gZBQfJz8; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gZBQfJz8"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-29806bd4776so8347285ad.0
        for <patches@lists.linux.dev>; Mon, 01 Dec 2025 15:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764630826; x=1765235626; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N7lnIapC5hP7XLdYbLhmU83mhpibTCJunY9NEXIM8bs=;
        b=gZBQfJz8uMOETXtpe/tIiB0NN5R1vSMOqhjpFEaDIFfAgyRDaGCnpQGGv20SQ3uciX
         mzJuVW/nrhn0yZVHcPxcCa7qHgzR89x57lSHF9WkMi84R9qo1BntVulNJ3u4GsoNxNie
         vgo10iwx8y+Ge8C43+1CYdS3/B8PNXcxVRhg79sHvUow65ACyFwWyBNIKR+Dsj3XbeS3
         2yM1E3TCVhNpNlogxmcDkd8rUMHWR5XMN0G5MSbfZ2L1aAgU8hCBxWcMPzPAbkMW7LYv
         j/+xQVSMbIg9gX1KQHmGU4P6aVCe9Encf6lRnANpZvCxBIwDbPD3cH4BZMWj6zMx1VdT
         6MSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764630826; x=1765235626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N7lnIapC5hP7XLdYbLhmU83mhpibTCJunY9NEXIM8bs=;
        b=NPFVzXmF422yfpSa9N07k80eX346X19DZ05vWkQCvgEwpfdohvFM4i9LmO5PQoc0xD
         NS43POy1JZS4LdOiXHLSTgr1ywmveTV2NLJ+fJcgBEaVRgkvRERbahni4+W8sSAvPiaE
         ND6Ty/piN6oRHDhX16tCfc6NkQEiEtcT60+hVkJIhSkVUSVeWv2cq/QlJZVfIgTZ5LNR
         yf/VVN8GRlvtBqUyUqfee9VSOn4h8Dq4Uvpd0Vln9W7CVEbAyleeQvN+iYLxoc+mhFJC
         mVoYu2V9oGntsIy/6Ahwvv/G8HUSwwK6D2pby9zn2etYflVgUtYlP3tYqR7EQ1DollCP
         DMzg==
X-Forwarded-Encrypted: i=1; AJvYcCUIheN1mjvKaYakrXNzHqpId+6bYiRCS/J112Vxalkm/TEbCxeXYRNBtnWJjfGf87TSibmZdlXr@lists.linux.dev
X-Gm-Message-State: AOJu0YzPlv0XhwQcYEeh3u+dc1tNxGm/ND0tQvlIJp+QlvcJcnY8Bn6I
	ndP7BrALjBFBJhQg9rMrHagGDb+ph7JuCGqOplCNjoW8sE7PulqZx23w7j4PglYBzW6TFCWtreQ
	c39ilPUskCrjHp/wRrgVkPJK/p0TaCOA=
X-Gm-Gg: ASbGncuciVcFeFNo56Aw20J2s991wB3TWFp+bEwnS1jTPOcMv5+jfTEH5bbpuNQsbJB
	4ZvGjyvWJSlhgr8Vq7WQG1kz6jHXqxIWf0tLt/3nDX4Be6gcSySmzSdr0Gv58gfl86wgWuhgWMh
	Tjb/uZB2DB/4k49fd2crY1yd+O9T17R16gnG+1O9cVwZFq29vwQoQYMJ0rBC5MYcYOvAq4ieZuI
	spkbfm7UwMBGXDPlbSM+YWjP6X/UPllvn6Ozv989Vwgby93IhMWQlafm6OjhAumXK4k3HIae7cG
	T1brHd0ljW/sIsZVJAbBvHd2nDYSOaW+xQ7Yn0/ra9dGu0c0KBDGTX8Ch5x0XzQbopVyS0PjscD
	HhDA/4s1Z4Xju/w==
X-Google-Smtp-Source: AGHT+IGxVdTUYHF8iE2D6SOC3zDFLgWrtThDk+vCT5QlDGLr9pFuDZMTKe6/03j4SaY+hb4WZpWt98bJyvFLpp/EFRw=
X-Received: by 2002:a05:7022:43a5:b0:11a:2020:ac85 with SMTP id
 a92af1059eb24-11c9d873c80mr23376629c88.4.1764630825825; Mon, 01 Dec 2025
 15:13:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251201000949.1626363-1-ojeda@kernel.org> <aS3seTNRum3ZXMom@yury>
In-Reply-To: <aS3seTNRum3ZXMom@yury>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 2 Dec 2025 00:13:33 +0100
X-Gm-Features: AWmQ_bkHrITwvcm3bjCTQmkTP8nrImOcwwWE4np_O6AAArIp946vcpIx0rfJqY4
Message-ID: <CANiq72=1ipov2pV9pSQwGh9WMA4NvQRV_cBCO0hhChVg=c-Njw@mail.gmail.com>
Subject: Re: [PATCH] rust: id_pool: fix example
To: Yury Norov <yury.norov@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Burak Emir <bqe@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 1, 2025 at 8:29=E2=80=AFPM Yury Norov <yury.norov@gmail.com> wr=
ote:
>
> Thanks Miguel,
>
> I applied this, but the fact that you've sent a second fix to
> documentation that actually is a build fix, raises the questions.
>
> Because Rust documentation bears compilable chunks of code, I think
> we need to enable rustdoc tests target by default, so that developers
> will not send broken tests.

You're welcome!

This one is a Kconfig in the normal build, i.e.
`CONFIG_RUST_KERNEL_DOCTESTS` (it is true that the other patch was for
a different target).

If you mean enabling that by Kconfig default, then I don't think we
can do that -- KUnit on its own (which this uses) is not meant for
normal builds. Perhaps we could have something that just checks the
build, but people should really run the doctests anyway, since they
typically contain `assert!`s and so on that can be wrong.

If you mean enabling it in Intel's kernel test robot, then I think
they do it (or at least I told them about it long ago). But maybe
something is missing.

In our P entry in `MAINTAINERS` ("Subsystem Profile document") we ask
people to run them among other things, so I would perhaps suggest
having something like that too (or linking to ours if you prefer):

    https://rust-for-linux.com/contributing#submit-checklist-addendum

Of course new contributors will miss that initially, but actually
people find the doctests quite useful, so generally people get to run
them. At the end of the day, maintainers should test these too before
applying and otherwise someone will notice sooner or later.

I hope that helps!

Cheers,
Miguel
