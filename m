Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC904C96
	for <patches@lists.linux.dev>; Sun,  4 May 2025 18:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746383506; cv=none; b=nmNo2ll3TFMLcMnfXA0ioXsQzzgobAVPuKVTO3ljZJDqCfOLmt0box4w5gkShHEWCj/z/0ZFWYYnoVMUERbnsa1ib5Fj/d06/Rf5W9CTu2omROmpE0nBoCeEU0EpPgprbXEv3X5iUvxaW9FFmQGri0FU4Wmy9RoTHv+wc/0h+cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746383506; c=relaxed/simple;
	bh=jCzBsYxspV1laTgHvP+KP+6A7COw+U0qAa5tc30If1Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y50oJUIlAUWrszdMPMd0eW4fOha5JSe2mOa6fbbgmf5llZB8DcYC6DJP97nyzIRgyvZ4wka6NgIdVsLrgv7TpkPVTMHKKG3Z7N9NFi+CHmC2tM503J6OAoWe3Xhiwms0arNk9Jew3ueNxYHkKeAB3gK1MiaL8b0mNG41/UJVXJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NCgHIhAq; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NCgHIhAq"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7373aa99e2cso523824b3a.0
        for <patches@lists.linux.dev>; Sun, 04 May 2025 11:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746383505; x=1746988305; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jCzBsYxspV1laTgHvP+KP+6A7COw+U0qAa5tc30If1Y=;
        b=NCgHIhAqQDkKIf/DqzkIFLLxoyyyYb3zmyXJPQzuQhi25LJWWnnRYHyCefapq3+/M+
         WSTrzbTGqyrs8O6x6Za7FhOXDAdAw7RnXuPctb3nYVINaxDNxNpda0V5aTm2QQ6yyxEx
         rAFnr5ZEGYBnwKAJvKaRLBn4L4cuOpy9KBiV1GXJ8QB1tqhWe74xW9H8CusPLVNfsTWU
         VEsTk41BFqi9GWcEfYD4WML8ZH2P+YGwsDTKnSb0TayVPnAl+91CAGvaTjxitzGIjmN7
         JGkfnW5E1RHQT4Kcxydssg9Oj/Boe8HpDAiaGFrWke5XmqOa/QW/vlN9+f3GZ02XQY7t
         Pqgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746383505; x=1746988305;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jCzBsYxspV1laTgHvP+KP+6A7COw+U0qAa5tc30If1Y=;
        b=NqcWjEemeusPT5mzroCVGuppxA12CYyDr3LDP7f3JuHj/7mXCvfr4aV9RNXkChKbDM
         aRPodRC2HEwRaGlon4LpMD/q0GE4tfQWLGSC4m8eeV+2FTZ1mAsMpeUrANF67pxYfDGQ
         0Os6Npy+RGG35sCcF6Qc11U42rOw8p6qODsDtGGqVwxo3Jt1DHcgzq+FMBAGEKrdQop0
         Rh+SmoQNWcudw8AzHhbQf8qS+aeP7E3pjjJL6RChKtNbIjNlKQE/UQSsLhEkOmEMcIw/
         b3LOGk37OoZ/HVC4N90vIW7P1q9V/4b69ezIQXoKOKgM+vl01l3E8fOxUqZPO9LVtrp9
         ksYA==
X-Forwarded-Encrypted: i=1; AJvYcCVg9NRINjNvHU9XF9aAeM+yc1e7vucvWVg/0C3lBBvfssrxYY3IvduM4nDGFlGKX9cAmPoXouxW@lists.linux.dev
X-Gm-Message-State: AOJu0Yye1iwuvx+Zr0dKAiXH/9Xcu5jiYFYGPT+AwmBdJ0/2oXSVVcRd
	RWTPMNfjQebbBZdkQyY4ir4wLvBfSzv7UnJ21ENF5r0PBsa8L2Z4GrTt4Nk0BfZ2e3bB8uAvemT
	7cqAJZYWALpZQTujHzkPxi8jdzHA=
X-Gm-Gg: ASbGnctqncoADnv2rC3cqxjQmhOOj4Q2GwMZ9EgZoFSZ7CvJpOg7pekhX0NAbkG9+1F
	/cQ67/kbqs2MznjS69vVmt+ZrUJB0o6gp0iMdBhBTUxA0juLj6wGmF1ZG4tpNNkfDEov91MZXzL
	oHQXkjpp5Bx3hK+mKa7Hs2XyXMpOzEKanX
X-Google-Smtp-Source: AGHT+IHM1qFzExr2JO+eQkxetxwIHEXTTQylqRXZSO/+GOHj2EgGo9fWj+nqCH+Onwgpa00JM1zRryqBij0OZ8ZX1UE=
X-Received: by 2002:a17:90b:1a85:b0:2ff:5759:549a with SMTP id
 98e67ed59e1d1-30a4e578abfmr6303285a91.1.1746383504603; Sun, 04 May 2025
 11:31:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502215133.1923676-1-ojeda@kernel.org> <20250502215133.1923676-5-ojeda@kernel.org>
 <CAJ-ks9k=uxxumgEU84-54u8OxxJVBsUprGk7Ht31ndoumHB95w@mail.gmail.com>
In-Reply-To: <CAJ-ks9k=uxxumgEU84-54u8OxxJVBsUprGk7Ht31ndoumHB95w@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 4 May 2025 20:31:32 +0200
X-Gm-Features: ATxdqUF8ymJwZfZr1C5xgS3xxNqN2FX1ijfVb70q7bwMJYIUF0VTvVP0RvPxx3o
Message-ID: <CANiq72=Q_Vbfh6YhDsNeCBDPZ-q1d2HNfaTj4azAsd2Q-zPfEw@mail.gmail.com>
Subject: Re: [PATCH 4/7] rust: str: convert `rusttest` tests into KUnit
To: Tamir Duberstein <tamird@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, Rae Moar <rmoar@google.com>, 
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 4, 2025 at 7:31=E2=80=AFPM Tamir Duberstein <tamird@gmail.com> =
wrote:
>
> Is that true? The build host is often easier to work with. There's a
> number of host tests on the C side that exist precisely for this
> reason.

Even for tests that could run in the host (pure functions), if you
test in the host, then you are not testing the actual kernel code, in
the sense of same compile flags, target, etc.

Moreover, you have UML, which gives you access to other APIs.

As for "easier to work with", I am not sure what you mean -- KUnit
does not really require anything special w.r.t. building the kernel
normally. In a way, these restricted host tests actually are an extra
hassle, in that you have to deal with yet another test environment and
special restrictions.

But which host tests are you referring to?

Thanks for reviewing!

Cheers,
Miguel
