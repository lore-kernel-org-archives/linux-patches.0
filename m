Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C0B12B60
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 12:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GBG3uuFc"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-59f6767a15dso18085137b3.0
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 05:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696509111; x=1697113911; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xn7VVCSDyOglaO22IolgEibFcmi33m0Re01Fsy79xeo=;
        b=GBG3uuFcO6KqUdhTQWp+enIHQigjPFIL68nd6cKjNltgJ72MgEErI0B9Z91f3D/Mxz
         KpfGqEedjE0b9rUFqIuAtafC4DogI8DsS8nyYuCvPPlg/XhGvmifMsAl1YNgeKtCn4Sj
         M1PmE4i8X+Q0cKJL+Fqsp577S6a3d62adn6Pu6nP0FU0jB66ZAi6TXuIycfBy7VuwqQi
         DiuONtbFHGCZmLmOC0GZDxZ5Ii2uAO/kia7hFpmnLHagywCHO9ztZVNZQr2y0T2GkuY4
         FXxsAQx0hzo7JOrza6af8QAcPJT0zwQMnUG0BRb0UjEM8zD/dsJQ0QpPoOakOy/H7pqj
         vJuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696509111; x=1697113911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xn7VVCSDyOglaO22IolgEibFcmi33m0Re01Fsy79xeo=;
        b=EPD/0sILePKqAiy6h4XzJJQ0QEYdcjwdj/VNehRmql5FADsJDIVZiGlcsGxcEUV6Ml
         +dZkZ5gzyZos9wENmPAwwy/xBLrRARi3SC/ZTuWHuHnC1S0w/HZSTv95ACr5EeM/QlkN
         Dg19FWZTI+wCi8Op/Y3wzIJL4C2xfRa+WRztMgzz7aRMVVhfD2ImcWQyhyHD9rEUOZYy
         64cEBEN4LdQRAYhNHgXSXDbqMCLveLAuP6R4JYDI+7SWQJ7gHXzdwzHhvawtXnqH8dfd
         S2I0UZqfu4iwq0Nr5T0kkCqoZrr6D3ix/dwp57/bfWoYLSM8PXTr3Iozt4NZnGxdTtFS
         fgMg==
X-Gm-Message-State: AOJu0YzYwHSxeoJD38suXEexwt5iWRsWvZpGKppOGeBUcNE6sNKauGVw
	XJmoJ5ptiUjEThV636vDMhZg4GTRLIiFtchiZoA=
X-Google-Smtp-Source: AGHT+IFJBlZvtG/mUg81VTlKsyGpl8FT/mxlBMcyuccmpQZtTUd9bGVCv1OiYr8WCRX2hzrEA3yQd327RdEJHO9bJQg=
X-Received: by 2002:a81:6dd1:0:b0:5a5:740:1f8b with SMTP id
 i200-20020a816dd1000000b005a507401f8bmr2066155ywc.16.1696509111311; Thu, 05
 Oct 2023 05:31:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230823160244.188033-1-ojeda@kernel.org>
In-Reply-To: <20230823160244.188033-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 5 Oct 2023 14:31:40 +0200
Message-ID: <CANiq72=XFeyfS11KxVj8hJA80nQJixUm_diMcKAY9i6NBkBVng@mail.gmail.com>
Subject: Re: [PATCH 0/2] Rust 1.72.0 upgrade
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 23, 2023 at 6:02=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This is the third upgrade to the Rust toolchain since the initial Rust
> merge, from 1.71.1 to 1.72.0 (i.e. the latest, to be released tomorrow).
>
> Please see the main patch message for a long explanation of the upgrade,
> the policy for future upgrades and some indications on how to easily
> review this.
>
> The series is based on `rust-next`.

Applied to `rust-next`, using 1.72.1 instead of .0 (no changes
otherwise, i.e. in `alloc`) and reworded to mention that we were
hitting the bug with debug assertions enabled.

Thanks everyone!

Cheers,
Miguel
