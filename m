Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624F2236A79
	for <patches@lists.linux.dev>; Thu, 22 May 2025 09:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747907246; cv=none; b=tR+a9YZ+w6wOwMVxUFtlH5t8qLxKexDyiXJF19QZ6JM1uGdI3seW2JWRogJTP8TnAwN16lO5ftC1THMbE+7YIcbzCAS1DTioII0Px14fcKo3eHD5Ejh+rp3xt5S9KE6USt9j3lyDlQ61Q0hD7s2T0F4VLb9R8ek6zZeSGf/oM3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747907246; c=relaxed/simple;
	bh=4Mi//bmqCitlsd1rQzDuiS76DZ9pyq2kmydmOzYN5jw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cK3y6xQggniDnEY82rduAHQDgYhctgFIbZRvbZB/lUn6OTOQzyc8VijqTSeW4U7UKUwL4HAT7K3uH+6JARBFjZgeChxGzTsdULZA53lQsDEEzZlvERdSoWTztc7jYcfV9vT7zu0EJ+Qou9+rQXrcGhG5gmBetjUJZFHVAu6hzxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nF9Ko1EF; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nF9Ko1EF"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-231ba912ba1so7785255ad.2
        for <patches@lists.linux.dev>; Thu, 22 May 2025 02:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747907244; x=1748512044; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ipAwY8ZxlvEf1nakEvQVnIk9cDkKI8+OAel+80ahbDs=;
        b=nF9Ko1EFwCMOEUr5XjX0VipQ2o3CfokysIQZR4mhA7MFVSMDZwjN1pITRvSocqlmDw
         II3gS7Yo5kVrhw6xS2i58o21GJr27N6grRMZERzNSVUd84l99rI5ijz3xR9IRLZkyvFQ
         q4mp1VrIdI0nyU2chzuNL7awrZXLTZLISsdIx3cwnH7h4O6+yJSkh/gil8GSNFtxod5g
         pk46u/eiDPRtszN43LrAnD+XZ0b1+V0e+rP1fxvzNIPeOPon1XK6DqEZogqm5wS2Lux6
         29czzPS/Xo6Xc1L9kx/TH1nBvARChQt3xFyFV/riuzoq0YmgjxBpvb9Key+RaTB4bIVh
         zyLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747907244; x=1748512044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ipAwY8ZxlvEf1nakEvQVnIk9cDkKI8+OAel+80ahbDs=;
        b=GAe/WTE9egCRPvUfHW7Jt2UY/7xbuxGKNiZDWLvq3guHWpl5vBmP4TUwQwN38117jA
         QPpB/OE8k1I+5rriNtfzf23RWtRwKKGhvnd6xL2Z8fHHqheAAEzbtRUuF6Jz7NCclLBp
         OnWBNfhe/sQJrmMAYW15Ma/1PQS08vk5/uIdb8HVkizd3NIC1IAWzEfpFlOyp1YeKvnm
         V2GV7I/5NupRltPvnU6YzxT0N/fv7C7exjA4Q1pcypM6327UPpLyDD5HeCY+p7psb4qH
         sRipK0TlRt2dg9FIZzJ8Dt6FhvXmHCbNkQ1CMG259yj0PPVv9VYqP+UlyqFDUXfwjjeH
         BNyw==
X-Forwarded-Encrypted: i=1; AJvYcCWGOt8os/WdzQRTgDcdtJ99d4ZXivU0489vqZzPcZwRXeMlF19E7FiPr3Zmvmge6Bc+zIvoWmb8@lists.linux.dev
X-Gm-Message-State: AOJu0YyUAllNLvCJ6KTx9Yp8QgA24wMIVMQ/LEhkNJhVrsOusVJXNq+Z
	7jKKEAflPI7oluw7vdVnVQ9OF87VNqCuDQT5e6J0jSQknktOzwL2EVXWbjL0ilpIt2Zbj0hGldx
	34GZ32w0l6Bl+o55Z+Y3cWxMi/ZYrB2U=
X-Gm-Gg: ASbGncvI7X4SkHePQ0gEEAoU9rto8HDoMClD83mzK8idy5V8a6388ioosORIwROnb+e
	jPX/2d6MzfY/mxgLxfA8sJIEI93DhOfDXISIGybOs90MRaM3e+4Y8hRqCl3HqIpmmOCkUJLCc8b
	59Es/WWNU6D9oGVdZRVmAxcjDq51CQzIu7
X-Google-Smtp-Source: AGHT+IHKkMNeaj6kG+RCv22d49KV67QvtWhnBvQaNqs96AouSRNF37SPJJw4Y6hGaON6FpFmZHUqDu6VOEZ338Aktx8=
X-Received: by 2002:a17:903:2285:b0:22f:b00d:fe59 with SMTP id
 d9443c01a7336-231d450fd20mr120664705ad.9.1747907244533; Thu, 22 May 2025
 02:47:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520182125.806758-1-ojeda@kernel.org>
In-Reply-To: <20250520182125.806758-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 22 May 2025 11:47:10 +0200
X-Gm-Features: AX0GCFudr69K7Ker-OBq61Wf5eeUt338xEQM0BHHVJyg1bvCHsTu9tjB29wkrAQ
Message-ID: <CANiq72=p4P9MuFKNy28PdHSqznvW_8Tep1wjm3zPXqbZVrujfg@mail.gmail.com>
Subject: Re: [PATCH] rust: remove unneeded Rust 1.87.0 `allow(clippy::ptr_eq)`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Danilo Krummrich <dakr@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2025 at 8:22=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Before a change to relax the lint was backported to Rust 1.87.0 before
> its release, Clippy was expected to warn with:
>
>     error: use `core::ptr::eq` when comparing raw pointers
>        --> rust/kernel/list.rs:438:12
>         |
>     438 |         if self.first =3D=3D item {
>         |            ^^^^^^^^^^^^^^^^^^ help: try: `core::ptr::eq(self.fi=
rst, item)`
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#ptr_eq
>         =3D note: `-D clippy::ptr-eq` implied by `-D warnings`
>         =3D help: to override `-D warnings` add `#[allow(clippy::ptr_eq)]=
`
>
> The backported finally landed indeed, thus remove the `allow`s we added
> back then, which were added just in case the backport did not land
> in time.
>
> See commit a39f30870927 ("rust: allow Rust 1.87.0's `clippy::ptr_eq`
> lint") for details.
>
> Link: https://github.com/rust-lang/rust/pull/140859 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

    [ Reworded for clarity. - Miguel ]

Cheers,
Miguel
