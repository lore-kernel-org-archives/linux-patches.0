Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D501DDC9
	for <patches@lists.linux.dev>; Sat,  7 Sep 2024 22:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725747753; cv=none; b=s2jU6bgfGcBfw8rCZ48kK8xDleagKU+iYuC0ran5OvbvLsOQAn5fSP4PlhIDJxEOZetaK7IInUm7EfJy3NCpAcOvJiHJaQQp2g66DrxwlYjYWJEY1kFVA5Sv46XCCr/uuAs+lN/pRW6i2fCz995yspNf157k2YWkUBVuWl+s9ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725747753; c=relaxed/simple;
	bh=5Ya+GrOx8iFM33Lbbtk9RoMuJPVWPdjs5LKsBxWWcko=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=c+e+LakJW5zHSzes+gBB/ZNDjnrqo0gdAUMoMCBuT2lcdK0loaq5KU0nKFjRueta/MBhral1HWH/hus0TrcIq5RfrloLEpCpbx0aF8RfxTwxYCm0HhbdnWuV94Wfy//eqmpETbsfV0lPc3hjzwRW9ShCkKvhAc+wV/8nIjvkccA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gw+sI3+C; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gw+sI3+C"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2da55ea8163so2360005a91.1
        for <patches@lists.linux.dev>; Sat, 07 Sep 2024 15:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725747752; x=1726352552; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Ya+GrOx8iFM33Lbbtk9RoMuJPVWPdjs5LKsBxWWcko=;
        b=Gw+sI3+CKmTTVQLKUlPN+cEmCYATkg7jRDTA/3DBH1+kMbmgl45QByf9gz5b9ibdUB
         BkMK8etr2CB8ou8Fs1oKFGlwzZ/k3vqo7d93SYG61ZYRSu5AwDRuJqz0Dh4fg9VdDiSe
         2nI5hBCJtzR4qOaf5yTa7ACR+PpxRXVh/DB0O9V62BIhdTofC3sHgTUpubitvo2nfla8
         TTIAuKw0CFjwIt9HKSjAz3vhq+KnPWzkO45D1PXIo+fK60FXu+cJ6RkDMbFMv3EfNXXY
         pDThpMMEClZ2QtlBEe9PMTN/U5GhTsKMUMESebHzSSIm3SUKhq0znzMfAqydMyZvuSXc
         ohUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725747752; x=1726352552;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Ya+GrOx8iFM33Lbbtk9RoMuJPVWPdjs5LKsBxWWcko=;
        b=Z1EtAaqh/x43q2zBZOhiHnC9OAfjHBODoUEkIIf81axAvFB+ESMx74Fssm43KOYYoH
         2px61Fu6zQQ24qF1dtIOZBs3WIalBoiJKC2XNCrctqTDBHBlRjeZ8m9QpZMKuSAr6xtb
         JAGcyz9LPPXX7Fi4PKK8lrGySbLBZORsGinhXBl+7ZXBZ7/jBKQWjbc9OJ6LUP9ISwiy
         gSXdHWTY1RqZeX2VqNCfpfgVmdfYNh0UkPIxdDFNIar6bGrpi2bi9u4oKHsNSsIjShNi
         KzsPNUHNRSu6WY/SE8+GAko3rc6zMbj0yzw6hie33hfOyi5rF39MBQqubiHdYdy2kLB4
         /8bA==
X-Forwarded-Encrypted: i=1; AJvYcCXIMNKJM4azg2bY/TcyCfyzS1EIscbo3/pGxOdS7in+MfZ4yUr3uu595xFeYJy7XYa3xO6Ur/pr@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+bUXxZh4WUmHG+X1kDqE56wtlLB/b9WXFq+7q6v4pVBavVKwF
	9gW5B+n9nrVQUGg1TxlzdZnLNuYW9wpb6euKndR/h/s1ZnMSGZTC
X-Google-Smtp-Source: AGHT+IG/HV5r+YZqFHMlZOHZKa+nFuVeg9UR3D8/72VNjiZ/5r4muwDJe42wWMrU28RnU1tIZRYyDg==
X-Received: by 2002:a17:90b:4c84:b0:2d8:87d3:903b with SMTP id 98e67ed59e1d1-2dad5196fe1mr6549829a91.35.1725747751627;
        Sat, 07 Sep 2024 15:22:31 -0700 (PDT)
Received: from smtpclient.apple ([2601:647:4d82:420:7c04:afa9:dac3:3f3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2db044f37dasm1732529a91.34.2024.09.07.15.22.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2024 15:22:30 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH 16/19] Documentation: rust: add coding guidelines on lints
From: comex <comexk@gmail.com>
In-Reply-To: <CANiq72ktnMSfMfGEhN1kO0F+C5O_KsUY1y_eb7ZL+qzzSkg9bw@mail.gmail.com>
Date: Sat, 7 Sep 2024 15:22:18 -0700
Cc: Alice Ryhl <aliceryhl@google.com>,
 Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>,
 Trevor Gross <tmgross@umich.edu>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <22A86237-4168-4D4A-8782-7A65AFAEC44C@gmail.com>
References: <20240904204347.168520-1-ojeda@kernel.org>
 <20240904204347.168520-17-ojeda@kernel.org>
 <CAH5fLgg20kDCJfD_6+fTSogOnpqK0x3a6eKaTahgSvdgfFzSEw@mail.gmail.com>
 <CANiq72ktnMSfMfGEhN1kO0F+C5O_KsUY1y_eb7ZL+qzzSkg9bw@mail.gmail.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
X-Mailer: Apple Mail (2.3776.700.51)



> On Sep 5, 2024, at 2:45=E2=80=AFAM, Miguel Ojeda =
<miguel.ojeda.sandonis@gmail.com> wrote:
>=20
> On Thu, Sep 5, 2024 at 10:16=E2=80=AFAM Alice Ryhl =
<aliceryhl@google.com> wrote:
>>=20
>> Wow, does C really not have an easier way to do it?
>=20
> Yeah, it would be nice to get a similar system in C.
>=20
> There are targeted attributes that can annotate certain things, like
> `[[maybe_unused]]` in C23 (and vendor attributes too like our
> `__maybe_unused` macro), so `-Wunused-function` is not really the best
> example in that sense -- I will think of a better one (it was nice to
> use the same as in the other examples I wrote for `expect` later on,
> which is why I used it).
>=20
> But, as far as I am aware, there is no way to handle lints (and levels
> and so on) in a simple and consistent way like Rust does.

You can always hide the pragmas behind a macro:

https://gcc.godbolt.org/z/WTEaYWW8c

It=E2=80=99s not perfect, because warning names sometimes differ between =
GCC and Clang, among other reasons.=
