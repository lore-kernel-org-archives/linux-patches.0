Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6EC1537DE
	for <patches@lists.linux.dev>; Sun, 18 Aug 2024 21:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724016760; cv=none; b=FO2tO5FK/hO2zFHhtQjJxb4pSmbE9m5H83Vo0obuiX2FUuDRPSiZmX9SEm3DQKbKSbKqt/t0AA22rGhe3tQqDG/AMAyzZiUF9T/dhbZeiI92m34n5KAv6/yelnA6xsPJiZGURsTDHUEwENWZOJbCU4wq/PS1o8WsEph4tTnb588=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724016760; c=relaxed/simple;
	bh=ho8VnqsEKFFMaGaEZKuaqkFuYWqoFAgEJWsjstMltkc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cvo0OyajJEp/v6AU/2XN5TPJnwyHskldjbHST/9PedXcu/37x1S8A7hFzSiYAdk+M80Lh/oaZ6w4R7C/C7wu1IS+9AfqUXvgWx+Kwy5Uh23r7xEGoydgeUnIKNR/I3Ew4WD8qZ0XJbBPpRkAt59Yf9dIVAVglEstQAIDw64jBco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nguZ+lcj; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nguZ+lcj"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-712603f7ba5so2921860b3a.3
        for <patches@lists.linux.dev>; Sun, 18 Aug 2024 14:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724016758; x=1724621558; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ull0aFVTCH5dHxXF31R/BROXCPVceforOFPiRwZ1/6Q=;
        b=nguZ+lcjLwYM8U+BN15BFJmaQpCrv2GPy+TlFeyPEkLIXWhMgEIGhSdTsMmdIsvsUy
         UoKRyujt9og03O77y/tUGAtbtNxfFA+7d0UUBtgTkkrRARFFmjZ3pzGFXPq+aDd/xD8F
         zmHPLxzJ51feWKQc1LzLIOxR2z7ZKAKoPUpOe1+2Fmpnr+u0KkpqsUJVQOqcEcpC0Ebm
         yoN82qgjanJ8840tAGd5krUt8TLVAvqPJDtc7eXNjGteCiH/ai4dF6AvFAWLBZDo1/CM
         ivCpNUQeVhW2Z4uT9+0Zal7tT/Y53fXkK3vGwaghuFp6O09cAY6kqoFuCV0eM/Z6PCfF
         PmOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724016758; x=1724621558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ull0aFVTCH5dHxXF31R/BROXCPVceforOFPiRwZ1/6Q=;
        b=GNswPfMJjbkeK3GEV7CPQMz0VOmSpBylnFuYy7CIFJNXRRxYFmxMVUNtX2q4hvOMQS
         0bebwDzMny9v+yh48JK+m9rHmj9MbpZH0rFvztsrVGP3z3ERDYX3gLGHWdv4EcbaFps/
         h9NyMMFNOZvJp7KxWntiClPFypgd49pSQY21ftiJRqWipEFelWf6ZUMdX1t1vZcpAUJY
         39VZZ5L4MfpSrSkwtYItYu7TOjoUO9ZTS+P0gTdMRjIMARa0++qWLyKK+FOe7IjCPVgt
         a3b4yfvRNefzr8aMV7IqRoCKGJzJ3Dyb2zNnnlAjCx6XbnQFnr8yR+y1lfO5FOOnBr5Y
         qvkg==
X-Forwarded-Encrypted: i=1; AJvYcCUrt+rACBf71GELSa0rZ0TjcRr2YBRt7PuP1rPQ4rr6HU0OEKu4uy4dsdu5xC3+j3uCWv8/dBnP3ySW8v4LG1lARWTuwy8u+Q==
X-Gm-Message-State: AOJu0YxzBUIuxilb5DIg6bM9sVNs9H00B+0kCa1O+ZZLMZDLqS1s5bOe
	XzpjkH6YPrYbzbdKrPXPSnYQWrVhjFlddK02Z1Sf1WYpbyETgOmGJsj34SmthHXic2rXs5XQyW7
	gd2ctc2Oa9Ln1kVyhWqk/dtF6m4o=
X-Google-Smtp-Source: AGHT+IHd/SqDxbdpvK1IHyEAwLl44igeud2eE+bt8dWF8L/Cox5wyEBZnoJMM5JjApFdL43RFd7xuW9iAI/uLKH2p3A=
X-Received: by 2002:a05:6a20:d04d:b0:1c6:af37:edfc with SMTP id
 adf61e73a8af0-1caa371ba2fmr6789334637.49.1724016758315; Sun, 18 Aug 2024
 14:32:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240730155702.1110144-1-ojeda@kernel.org>
In-Reply-To: <20240730155702.1110144-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 18 Aug 2024 23:32:26 +0200
Message-ID: <CANiq72=62mXHyurwDkqvesVFy0FSW24o7hx=BJvY3X8p+H39Ag@mail.gmail.com>
Subject: Re: [PATCH] rust: error: allow `useless_conversion` for 32-bit builds
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Russell King <linux@armlinux.org.uk>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, Christian Schrefl <chrisi.schrefl@gmail.com>, 
	Jamie Cunliffe <Jamie.Cunliffe@arm.com>, Sven Van Asbroeck <thesven73@gmail.com>, 
	linux-arm-kernel@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2024 at 5:57=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> For the new Rust support for 32-bit arm [1], Clippy warns:
>
>     error: useless conversion to the same type: `i32`
>        --> rust/kernel/error.rs:139:36
>         |
>     139 |         unsafe { bindings::ERR_PTR(self.0.into()) as *mut _ }
>         |                                    ^^^^^^^^^^^^^ help: consider=
 removing `.into()`: `self.0`
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#useless_conversion
>         =3D note: `-D clippy::useless-conversion` implied by `-D warnings=
`
>         =3D help: to override `-D warnings` add `#[allow(clippy::useless_=
conversion)]`
>
> The `self.0.into()` converts an `c_int` into `ERR_PTR`'s parameter
> which is a `c_long`. Thus, both types are `i32` in 32-bit. Therefore,
> allow it for those architectures.
>
> Link: https://lore.kernel.org/rust-for-linux/2dbd1491-149d-443c-9802-7578=
6a6a3b73@gmail.com/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

    [ Fixed typo in tag. - Miguel ]

We can also change the formatting later on top of the series that will
enable that lint.

Cheers,
Miguel
