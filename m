Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943A22FA0F5
	for <patches@lists.linux.dev>; Tue, 12 Aug 2025 19:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755028421; cv=none; b=K/55hTivVSl2UgQLxMQS7oED3ZzOyvi7WapGlEFgEIJ8P7J7mFK+jE4y/uR4V0QlT7R+UOGXK372IPwSnUQiTffjton0lNaW76niAVJSd6gOITwlexh0dA5/AWM+At3Fqy9+na6t5Fq/LaOa9q6Twcn+FRMfNLOwrkcjs2ULnIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755028421; c=relaxed/simple;
	bh=jfUO6qCBqlSZXuckE9FhCMnfK7Vk1fhQB4xTAnQFad0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=da6u3iNMZieSPUkUVMqP+2cVzqzpVjb0dKHiAqJ9ZzilCzz1xQGprq/AcxnSgEecmjochx3olA79HrdvnwCr8B6SkiRPZANTAhto51to1tBcr9ORsC/qvbunXa8aq7RX+BxJj4rzDan7vDuum2ybE8eQ3jE357vW3f9DdVRnyb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UxMvlhcE; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UxMvlhcE"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24286ed452fso6220085ad.1
        for <patches@lists.linux.dev>; Tue, 12 Aug 2025 12:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755028419; x=1755633219; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yUSrkYVX911mMRYKobG/gB2geQHq7LE3EhoaramfDxQ=;
        b=UxMvlhcE1eCByFQpHSZhZcRUZ3SMPREMqEyycADtkn9tIpIKSt4tPdfLRf4ZxxHByy
         2c3rmV65pfm/ziA0ETbtGoiN/F109K+6HT2p3cYPQiCxIbrc5T8pQq8gW9nfpKos3yah
         zxnfA3gqbP8aO1LU0ETiPFjjpmIQqaQiP8xFvu8ozogRk4yn7YiER4Wdb7eGDAEDiKVO
         pPV5olY6s/Q9mdntMhYtBj7t80wuiagLuESBEaQAV1TGuYvsq6LRutwwazkkBcxi0p0U
         jmmEHkjXSg1vPj9tP7rYFupgfSFwdRudeAvUqOCoxxeiKHDouhOKaIQxRw63Xhn43Ku5
         f5nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755028419; x=1755633219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yUSrkYVX911mMRYKobG/gB2geQHq7LE3EhoaramfDxQ=;
        b=W31DHX2aRrzs6qFYqqh7GXWQuoanFGgZjqEDn5zawhzIukfpm0juaMXoX114kxm9Te
         o/vYLh5wJHJ4s0IkX21it3FsamhmWaZfzoNPzskZCycr26ijDsolmtn1Jb34V8HrEQZM
         CZ7Z8RWkjjJyChjnmW9gzcdTdD3pu8FHCsRrOhkigFYq6kCv8tM1XK0XmaYxW8B+oF5t
         hChsEyx673fkiDw8Mt88vJKqK5uaDVxIW3nD8awRySRi1lbWif4sF6BYmNGJYIkfgMCM
         ehPaR3sRx2yDxw1jVuq5bubHxcNUNKWhuQyHD5MsCCSnC26zOjC2PWCL5khqThGbi260
         UIrg==
X-Forwarded-Encrypted: i=1; AJvYcCVbAEFrJMqKIqQ0WautLBoPrLvU7T8Y7nnG4DwY5YQgWWS4Fb5X2x5BQXqHhT5ZLrlPAaV2nnIF@lists.linux.dev
X-Gm-Message-State: AOJu0YzyMmoxLRTGItStcrHbIpkMFPmB3Z4mSvkIQ4MncQHB9CWvQj9D
	gE9S7QcxwdyHDNUyj9SRs9nnXImttKQFP6AY7WoxPWpX5XQJ66MpVi9X/XwH769HbshcqVVDraq
	aJoSy0rHZZQWW98n3+jf2nOcx358SnJ1p9um4tk4=
X-Gm-Gg: ASbGncuwQ28IIp6KhqJ5G1TgQL9cG0xtykof0WO2otA7Lxhka4CyOTSU1MCFt1t6d1o
	wN6eVLB3oh/Zh2bbAFgf3LutJ/kyCXMi5pIKFQbjF2nu2hxNwKOgN6296caRvb15X7AjcVZDwuU
	WIh5NugL00/7NdXaNilIP+zPVrZs7OWHZO7YvU5wGefLDx4IJllKn7+TRB3FUm9HKP21rdpFvok
	+7YJH/ShAyaOM2aOP0=
X-Google-Smtp-Source: AGHT+IEp8ZHS0gi6OP2eLRYeC79aMI4AVXuuqLVTdRChktGJBcowaIzzYNgkr6q7V4I87a++yIMfwzKOeEh83L8KTQc=
X-Received: by 2002:a17:902:c40b:b0:242:d186:5bce with SMTP id
 d9443c01a7336-2430d10c634mr3551675ad.3.1755028418798; Tue, 12 Aug 2025
 12:53:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250727092317.2930617-1-ojeda@kernel.org>
In-Reply-To: <20250727092317.2930617-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 12 Aug 2025 21:53:27 +0200
X-Gm-Features: Ac12FXynfRUtTtDBXz4z5dQZylg5ZZY4k8nbGOlwYd92YMdN3RiA45CrmjTdvgc
Message-ID: <CANiq72nOtuBNuuQQuW2piWynhizZg29Q7VgzUPAmB17w6XtQ+g@mail.gmail.com>
Subject: Re: [PATCH] rust: workaround `rustdoc` target modifiers bug
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
	Guillaume Gomez <guillaume1.gomez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 27, 2025 at 11:23=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Starting with Rust 1.88.0 (released 2025-06-26), `rustdoc` complains
> about a target modifier mismatch in configurations where `-Zfixed-x18`
> is passed:
>
>     error: mixing `-Zfixed-x18` will cause an ABI mismatch in crate `rust=
_out`
>       |
>       =3D help: the `-Zfixed-x18` flag modifies the ABI so Rust crates co=
mpiled with different values of this flag cannot be used together safely
>       =3D note: unset `-Zfixed-x18` in this crate is incompatible with `-=
Zfixed-x18=3D` in dependency `core`
>       =3D help: set `-Zfixed-x18=3D` in this crate or unset `-Zfixed-x18`=
 in `core`
>       =3D help: if you are sure this will not cause problems, you may use=
 `-Cunsafe-allow-abi-mismatch=3Dfixed-x18` to silence this error
>
> The reason is that `rustdoc` was not passing the target modifiers when
> configuring the session options, and thus it would report a mismatch
> that did not exist as soon as a target modifier is used in a dependency.
>
> We did not notice it in the kernel until now because `-Zfixed-x18` has
> been a target modifier only since 1.88.0 (and it is the only one we use
> so far).
>
> The issue has been reported upstream [1] and a fix has been submitted
> [2], including a test similar to the kernel case.
>
> Meanwhile, conditionally pass `-Cunsafe-allow-abi-mismatch=3Dfixed-x18`
> to workaround the issue on our side.
>
> Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Closes: https://lore.kernel.org/rust-for-linux/36cdc798-524f-4910-8b77-d7=
b9fac08d77@oss.qualcomm.com/
> Link: https://github.com/rust-lang/rust/issues/144521 [1]
> Link: https://github.com/rust-lang/rust/pull/144523 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks everyone!

  [ This is now fixed upstream (thanks Guillaume for the quick review),
    so it will be fixed in Rust 1.90.0 (expected 2025-09-18).

      - Miguel ]

Cheers,
Miguel
