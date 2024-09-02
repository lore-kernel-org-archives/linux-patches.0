Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D761A3027
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 17:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725298780; cv=none; b=GeimivlJM7zOip51LbHw7m7Utr7MTbXGRaVxI8tXOFpzkbCUfAZdv27lsDhMKknenLtUx8FUNbTDjdt284Tl2DnRVpWEIlKJLnTFu3vSO0nl9F8FN4F47Nn3sndIoOODIS74TCIxcmXQEog2VnyQ28TAQdE4/xX9hRC+AbTeGg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725298780; c=relaxed/simple;
	bh=vRsL+CTH8FgQo0m3Ab3RyXO5CQ+ueXWSiw9o0pGnwFQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H28rEGrgPiWtem5S/45zfeQJcWhw/Kw5mqWCuTxcyor4ORUbWycGc7plOsHS1iIARPJXvnS5gFwO9N48XUu3dpThdSRrmrVmSzgSTnRsNedNNFNGnSax3Msyt+I+Ohxh70qtHPkNGz8NvzfCuThX4y49VZuckZi6pI9tVo9lgkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lpbyxojm; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lpbyxojm"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2d8afdd62e8so345293a91.3
        for <patches@lists.linux.dev>; Mon, 02 Sep 2024 10:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725298779; x=1725903579; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vRsL+CTH8FgQo0m3Ab3RyXO5CQ+ueXWSiw9o0pGnwFQ=;
        b=lpbyxojmaCORefnVjsBXsJ1e1McGx6Asq2eyplhlqiPdHLGIvNQJauiCQcBpg0DCsh
         GgTEUJoRtklrp+WwsS5d5yYiqaagGgnWHL5ZN1achIC4T36m1E4eS+nkGKBOr2S8TRLJ
         pmNFHWh/JQ/OYLjHCb0oXFAKhHULuxa9EG1t6eG9bM1KpxWE6M5sTNQXNL4DinyBHiA/
         NXWmn5Z0JUxpSmV0GpN0YJXIwNDHnYVHxwXZXf0b6wvjNMGZeOKkGvkLmhynlKDhPzKT
         FH8psrNkJuvZcD079xv5HJ0Xqr0eA2g/w89VxKqsEKGO5C0Bcck1GP1uYHllgKmSqlNb
         yaOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725298779; x=1725903579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vRsL+CTH8FgQo0m3Ab3RyXO5CQ+ueXWSiw9o0pGnwFQ=;
        b=DxcphJf3ifF9WTfDh5/3Ss7MxTt2MKoM6bqcYTgHeLPoXBcSsTYbaoMgJ4f9X3AOPe
         1YK94KDGFFB0G5IGUqQ8wEllqVUUBj4JQyGqZwRML89nI51nPN6xTXUI5UT6r3ki0czM
         q/UssOuFePxPNmO45b6Tg7nFPhbOWY62rsK537ZFAoiA+qYtu7oa19S3OPTqMswi0fZM
         KE3N5uRhhng8MM/P0vXY0z+dCq/ZhSMMNoju3CdKNRboSBUbiOERcZWRQK1QGVcEZ7ch
         AoMOPvewDw51399D9wCi+9okJ4w2NdfhE5bfQO0nZ4te5ufdwuCuL6JlHx8E94kNkd/0
         X2OA==
X-Forwarded-Encrypted: i=1; AJvYcCWD1xVyDCEz2mMmMQpMicTufS+UhxP9HbF4Qllc/CM5BsVXX4ywXYQu4W6widwoPpg1TUrtn59X@lists.linux.dev
X-Gm-Message-State: AOJu0YxrrcKw4JlehAoQGMZ/0WWJz4RPiW/jZQWJMQrZB7JzDXLZxs32
	HRxo9T0sOXE9CDFab7zttXYqMdMvv3IomhefPEJcXuCofk1/EN6Gh9oCQvF4WQpYb+migzutJaN
	qZ7a523eWogMHpZGIlBIDkRxpctI=
X-Google-Smtp-Source: AGHT+IHMbFVypuwpNLgzoZNYwy/0pWWu1+U7M+48C1DByfr2vsGWPNCJMV/6P3ZmCAweLqH3SeVl5Zd7y/J8Mrgy93M=
X-Received: by 2002:a17:90b:1d88:b0:2d8:d736:c35a with SMTP id
 98e67ed59e1d1-2d8d736d451mr2343394a91.3.1725298778681; Mon, 02 Sep 2024
 10:39:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240902173255.1105340-1-ojeda@kernel.org>
In-Reply-To: <20240902173255.1105340-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 2 Sep 2024 19:39:26 +0200
Message-ID: <CANiq72ms9dY-7ZKCs2B1t5nwvkDVbo-7iAPcmKn-xzFUiZCVNw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add Trevor Gross as Rust reviewer
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 2, 2024 at 7:33=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> In addition, he is also part of several upstream Rust teams:
> libs-contributors (contributors to the Rust standard library on a regular
> basis), crate-maintainers (maintainers of official Rust crates), the
> binary size working group and the Rust for Linux ping group.

And just at the same time as I was sending this, Trevor is also now
part of the compiler-contributors team (contributors to the Rust
compiler on a regular basis), so I will add that to the message when I
apply it. :)

Cheers,
Miguel
