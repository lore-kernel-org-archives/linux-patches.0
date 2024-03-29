Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18E2131E59
	for <patches@lists.linux.dev>; Fri, 29 Mar 2024 19:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711741746; cv=none; b=a3KzZqzs4krM1yIx52VZ/bNNZHxmVeZVTcCCadNlwyo/WYYP0JoGehWYmRxZmtF4K1kWmTRhqWR4BPdtjyEQxOnipwE6KHDFW0mW9gz3a/ye0cOTA6EDUW4nWSqPlybnGKPMZPyFTGeEGtRnu/D6aqgDH4ToPNev2CkLwG+YNUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711741746; c=relaxed/simple;
	bh=W3HYFvglRKdilk96vaAk5kw+aBWJdgn/FMqCTcLa4R8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AM6DnlWYweWxt9kYSq3ekQ3XD3SxCJdst9I48DIFr93AWuThHSjswoPodUO9e5fBe6+3IUT19ZCuTdCNbP2m6lpH6Cdykeo434XoDgePAyQANI8l4Y9AJcJqM6IHnVX6LWY/pM/nQltd2kUpY6L7cRP9SByAaLV7F8g48ua3OnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JHZ5V/iQ; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JHZ5V/iQ"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-29fb12a22afso1728760a91.3
        for <patches@lists.linux.dev>; Fri, 29 Mar 2024 12:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711741744; x=1712346544; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W3HYFvglRKdilk96vaAk5kw+aBWJdgn/FMqCTcLa4R8=;
        b=JHZ5V/iQRizHjrsC77XGHz7uAfjfgpWac5ztBbCHzHEEhur3teQGudOPUgt/cKpmIt
         pKEoYAKfHI56NsKYToY5CU462WdSO2tQQuqHebXjS+KIdJOR5PmonaMarUkyYVMUnJ+U
         Jo6gSgluQCfs4QUsn8o+3Jc6jOaYfK9kt81PuH9RvHppYt466OlVfQ3OYq+eHjL9uHCL
         qbCGaussU6wLXVg0+CjPQDdIjYqNaZEKMQgi3zgsOnb+i7/Xf1/eeIjTFPBz3xBItfMa
         D2Ps1lCSt526fqT7Wd3YoPl7iqlmWh1ilK37y6LqbvJmDVcIIpY6sdQ2/AzSW+AFKyUO
         469w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711741744; x=1712346544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W3HYFvglRKdilk96vaAk5kw+aBWJdgn/FMqCTcLa4R8=;
        b=igdGE/ZoeLXGAAt+0GsorTIgm2xXng3jfknpHP6eEeyNPS9+Qfz94Eh5f6oAbfun6o
         1XVdAtH8PO17SUMhn6gP0C+qiWX545tzE5heYv4ikWisNL8qzyJxYSgBH79SQxIoP+ml
         mr4UJ2OuOHsvFKo9zlBOWDOiyujMcu1REEefi9XzzFLnhh9cfPXKK4FoozpY/dUo3TiO
         rYuPrytYFRyR5MOJGZ2z3tzeIWDy3KpvgRn1N/o2fimE51w+y+v70Q7XaQUrWU9UXt/m
         wshsM85cwkAdOvBEUSUlTycAVskDh0DH4DN+r2LkMtVDOP/+sIKC2gRUghsrx/Ez7P9q
         UQ3g==
X-Forwarded-Encrypted: i=1; AJvYcCXikVVxLy+M25YpXi7dqk+wD+8ufNyAp3mnfgNRjBQTTVMhwcgoXcucNI6rCvwagnRefzhE8Tfg+TkfyMmJvIS48px/wlhMyw==
X-Gm-Message-State: AOJu0YyIpEbpBHX/Vr4hGgYwwMyBLiI2S7GmaSG4bvL9D5h3RV+o0Q+8
	C6QzgGXj7KMDp9FlZcTvkUtkMCHnqrISw6ux8Ql9uIGdLrntg00eammwRBJAhrQfTJOZ5wYWaUl
	X8D46A+X+QdOF+MlgPku32OZ1FJE=
X-Google-Smtp-Source: AGHT+IGEy6+3uxyFBSJbr3Fn4p72c4+8xBi7LoZEISiKilxJyP7xbAbgAPG4swR5ei++MiSvRWyZIl812IgvpWiaf6I=
X-Received: by 2002:a17:90a:3ee6:b0:2a0:3a16:7489 with SMTP id
 k93-20020a17090a3ee600b002a03a167489mr2889022pjc.44.1711741744273; Fri, 29
 Mar 2024 12:49:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240217002602.57270-1-ojeda@kernel.org>
In-Reply-To: <20240217002602.57270-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 29 Mar 2024 20:48:30 +0100
Message-ID: <CANiq72kuaEtsf2i=wE3H9sEzDAa9864DXQN7nJuO3nPs8fFSJg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: use `-Zdwarf-version` to support DWARFv5
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	linux-kbuild@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 17, 2024 at 1:26=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Rust 1.64.0 introduced (unstable) support for the `-Zdwarf-version`
> flag, which allows to select DWARFv5, thus use it.
>
> Link: https://github.com/rust-lang/rust/issues/103057
> Link: https://github.com/rust-lang/rust/pull/98350
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- please feel free to still send reviews or
tested-bys for this one!

Cheers,
Miguel
