Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4552FD7CA
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 12:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764678176; cv=none; b=FgY6d+GrXsTZ+n5wZjRUT52W7kOWyH2nPOlRF3kjzZrxwibBt2C6sWJTwgWjyykS808i9bAsXhZikjYS+hAOhpzMiVLYEgK4RpHExfsVbgmoqOJuTSGCF+a38N70sRptBLL9ZgB3zF988mti3HG5xjd+lydUiSh+DXfmUmYg43E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764678176; c=relaxed/simple;
	bh=pWe6+giiiKN7ygWHpgsDbutK/nK8fllT7LHQnwMycfQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UDzTm6glv1QOPoYCHwd52XKfuI0QupgMN/D80bEzRc9R82VhsTqPhTdl1V4mlMxEZTM65gi65CIkh8HDSLge1KuOScURTI/iRZVsWIAwHFcdO50zXVRheNFVVGHAM0273SWRka0LFIDyEoOky5nUGSHW5rZs7vnd1lmRDghVOCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=buZ1FkYO; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="buZ1FkYO"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b2ffe9335so4451011f8f.1
        for <patches@lists.linux.dev>; Tue, 02 Dec 2025 04:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764678173; x=1765282973; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tG6TZ+lvc6AvBf3kAUv3CSNPcBSdqg2e2HCc+7igxJI=;
        b=buZ1FkYOq/0eJlLmQaZ8w2OlbA2ZW8eipEjwjnA2xK4/xyuFPf4zQeH3GQo4c/6W7i
         IBVhKGibqf/XrsYRi6IBYtaLUlDzEwErYQqtOc/PkXnwThWMwxwCfgrlTWsTLUbPk744
         Ea/CqR5Pcallxwb8JHZ65skOaVHRtCY6U/hgycx+C3gceIulvYEou0LH1uANdPUDmeSE
         HxW26LsuHs2xU/zN7vJxXHvDQb3IpcM2hiAdWz7H8sQIL9POGhDUNQ/F2ZAflpejbyTT
         x97cQStoQkqfda642dylXfVXRdr7s+xQcRRvTfI+Iw5yeSlXqYOMT+4jvxqqJNGlkB4U
         Wg8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764678173; x=1765282973;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tG6TZ+lvc6AvBf3kAUv3CSNPcBSdqg2e2HCc+7igxJI=;
        b=HSQm4y9xmd7xy6AyhH3T7ozcZ7Pn6rsVjCsrUC9rQgg9CZ+QHeUqeVZBc/i04G/5/5
         eV/6ChHLB0KFh1MT6oh1zmNh5GzID/cFcwQG8RuXDXd3aQQhNeEopszPKcdLnS6b1JP5
         TSAFmNfOx/YuH7Pty1bTzyLM1aO5g/4fcxx40w7uLkGqHjjuyh9tzYRfoBpfRjQOWW+q
         iz+UkIo7LGKeXlSdeooSs/FwjdXhQDcsB8m1MYdWSUyJjqL7u6anFHzJ7SkNjxEi61c7
         LjOQOnMjhoUTtRO5PjPplK4MUZQm7Wr/8Qy84WrElwi6oVVYBlUkk4X6QqkjsjApoir4
         PymA==
X-Forwarded-Encrypted: i=1; AJvYcCWze6ikw+0pcInmWmifecHM1ZeMQBN0L6jfUQp+f/JR9oIKKHUijbmeOJmE+KG8lzsYKqLTbqyZ@lists.linux.dev
X-Gm-Message-State: AOJu0YwrxeDnaRnM+qSK+ijPnVEgJiD9IV8QyovWzf5uyNogwtHfmhUF
	x2r76jkO5uUTls5ZqfAs6cNfpeCD1pgJPM6f1P6K7Nw52tIas7lkSNrhXf3Z0LbB+fmZ6IYgpHZ
	wK2+4saK7DjMRkrVBuA==
X-Google-Smtp-Source: AGHT+IG293sjcaTqwvNWJNNZvfIkK6AJIFsV1HBwHGuSZ3ABuviusOdhyqCdhJ0d6RGcMV3jUs9iiMhGsbe5Qu8=
X-Received: from wrj14.prod.google.com ([2002:a5d:5a4e:0:b0:429:c639:ae9d])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:184a:b0:427:526:16aa with SMTP id ffacd0b85a97d-42cc1d23e6fmr47464249f8f.58.1764678172786;
 Tue, 02 Dec 2025 04:22:52 -0800 (PST)
Date: Tue, 2 Dec 2025 12:22:52 +0000
In-Reply-To: <CANiq72=1ipov2pV9pSQwGh9WMA4NvQRV_cBCO0hhChVg=c-Njw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251201000949.1626363-1-ojeda@kernel.org> <aS3seTNRum3ZXMom@yury>
 <CANiq72=1ipov2pV9pSQwGh9WMA4NvQRV_cBCO0hhChVg=c-Njw@mail.gmail.com>
Message-ID: <aS7aHIJbi3DlaUcc@google.com>
Subject: Re: [PATCH] rust: id_pool: fix example
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Yury Norov <yury.norov@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, Burak Emir <bqe@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 02, 2025 at 12:13:33AM +0100, Miguel Ojeda wrote:
> On Mon, Dec 1, 2025 at 8:29=E2=80=AFPM Yury Norov <yury.norov@gmail.com> =
wrote:
> >
> > Thanks Miguel,
> >
> > I applied this, but the fact that you've sent a second fix to
> > documentation that actually is a build fix, raises the questions.
> >
> > Because Rust documentation bears compilable chunks of code, I think
> > we need to enable rustdoc tests target by default, so that developers
> > will not send broken tests.
>=20
> You're welcome!
>=20
> This one is a Kconfig in the normal build, i.e.
> `CONFIG_RUST_KERNEL_DOCTESTS` (it is true that the other patch was for
> a different target).
>=20
> If you mean enabling that by Kconfig default, then I don't think we
> can do that -- KUnit on its own (which this uses) is not meant for
> normal builds. Perhaps we could have something that just checks the
> build, but people should really run the doctests anyway, since they
> typically contain `assert!`s and so on that can be wrong.
>=20
> If you mean enabling it in Intel's kernel test robot, then I think
> they do it (or at least I told them about it long ago). But maybe
> something is missing.
>=20
> In our P entry in `MAINTAINERS` ("Subsystem Profile document") we ask
> people to run them among other things, so I would perhaps suggest
> having something like that too (or linking to ours if you prefer):
>=20
>     https://rust-for-linux.com/contributing#submit-checklist-addendum
>=20
> Of course new contributors will miss that initially, but actually
> people find the doctests quite useful, so generally people get to run
> them. At the end of the day, maintainers should test these too before
> applying and otherwise someone will notice sooner or later.

Yeah sorry I forgot to check the docs this time. I usually do run them,
but there are so many targets to check that sometimes I forget some of
them.

Alice
