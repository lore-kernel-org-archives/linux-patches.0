Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A1420B218
	for <patches@lists.linux.dev>; Fri, 10 Jan 2025 10:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736505898; cv=none; b=e2WAf6L6vu/95oIxIKYZURVzuUlp1Qerjl5BuvCDnlL1sLXBmB1kwdx8jR6dOqv764U02jooUGdIUO/ubQxih4uDf9k7ITfLecAUEH45hpgd2IERhbogPssC2JLWRqIWJjkdDqW+/c2m+1NBzLd9yXjEqDbUfNN28w9QV+Cb9wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736505898; c=relaxed/simple;
	bh=fOv7coRlriT5GANzBwoZW5RjAdJTGUO0YETEjUTqeco=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GxgkNx2Ww237KE+Ge9X6ZiQDKdg92ZjKxShfvEzK1fz3z+cve3P3Eno1BndhqAhzIGmacR1Lg+vU1cm1B1cSCTHl4qy2wurwL9UTcnPaMqu4eNBwVfAPV4wMeX4QHOZTeMNPPaD43nrvnjLAAQ49TZiDG/1cCU38BFcPi4MgTTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EqAY1qTX; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EqAY1qTX"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ef6edddf70so370466a91.2
        for <patches@lists.linux.dev>; Fri, 10 Jan 2025 02:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736505896; x=1737110696; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fOv7coRlriT5GANzBwoZW5RjAdJTGUO0YETEjUTqeco=;
        b=EqAY1qTXWdFrqRW6Hkdh2aWkILUCOiOmVU47cvavYqwttGPTlXYV+rTWrS0ZnvAdGN
         OkLKCkQaqEvVx90EIlAJFnJf4XnJJxGalhX4L//D1U7L/OzrmiPlDAo8ZRAuZvbzwnXy
         o9M744cpwAHmH9dz5llnEZRqNKlCHqQxy2TUenohIY/G5c2gDKmDonKGYEvo/pZeCEO1
         hzCM5Jlq2/vXfdwFZhabOxlD66PjSmQoDz8bRR+CB3fREeO9Y68Xbk8RDza5+W1JrVtk
         cEDbmgTkKjt5yHC34amvr2rKUD4gxoj2Y6IWZnXqtvPMxQ09TOwrrt0gwwSl1zFvghm5
         ll2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736505896; x=1737110696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fOv7coRlriT5GANzBwoZW5RjAdJTGUO0YETEjUTqeco=;
        b=PqycvwJl68M1KbTdz33KETiN6e5CTTYrR99wezYxtYIUR1dybWg3XyCAOSdakGDMo1
         bqptznaM1e7kAV+l+vzAXvMDxIX5qS0S+UZaQ11Eehl5IxRcAPb1lddsgIsREElL77ZS
         Pu2+2D1oeP2ij8JMItoBZ9kY41nqlG7nOpmoveInHrZDf2ltupUW+M5s8prRI6bHj2w3
         Ns0wcdpFI+3iUATOf1JuylcOqyB92GE0e/2spyaTlIrfGYAsCmurEjGsA+8YOUVfBCKM
         aLRAHnnA9D/UCTlvToYIX9XXtEVIu/QbyRfnSTUow6M7iFVZzUc3kVvJNTZXb/xSghuG
         +F5A==
X-Forwarded-Encrypted: i=1; AJvYcCWRpaGYxfRUeMGxd3u6RAjcnkSQeq7mLgVQ6H5S2HBw/LMvdj4NhC6JcD3oh8nX7FhNRcHZUodH@lists.linux.dev
X-Gm-Message-State: AOJu0YzUbGF0qz+fhmievdmwUUX0/p5w3HWyfs5q8jDKx/1Gg5BpzLUe
	4iQI65i2a28isR3vFreA8ew1/emrG1XNmET1HzzlDhrbn007GwFjlZgvtE5w+3WJ1yzWeVVF6cu
	u89eStgUJlKJms61kdNPhDV4GCL8=
X-Gm-Gg: ASbGncuNXy+eTObCvPL9s8zt2bf6vzwaeCrMqVyONw5GnZ2UIGCPLESkCoHcxv2jVQN
	liyWbs4YurB272VLTthq5iPsgPJ2f9erxNltx0Q==
X-Google-Smtp-Source: AGHT+IGNLLtPuhByhtmusmNLB2QossNQCJC7ro42TnrIvXjLtSadskn5v/LaUt8bn6GUFk6dcNI9dIANJeOAzCIQUOc=
X-Received: by 2002:a17:90b:2808:b0:2ea:bb3a:8f09 with SMTP id
 98e67ed59e1d1-2f548db69e5mr5302153a91.0.1736505896347; Fri, 10 Jan 2025
 02:44:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241123222345.346976-1-ojeda@kernel.org>
In-Reply-To: <20241123222345.346976-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 10 Jan 2025 11:44:42 +0100
X-Gm-Features: AbW1kvaBvWqqb3Lx-vPEwf12VHqF1zxLTLPxMzQsbxNmtrbNwtOPae8QLNhIWTA
Message-ID: <CANiq72niw1ZU_97PsfGB0dgcRQNCo9LiFCjaHWCTY1A3qe+O=A@mail.gmail.com>
Subject: Re: [RFC PATCH] rust: give Clippy the minimum supported Rust version
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 23, 2024 at 11:24=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Clippy's lints may avoid emitting a suggestion to use a language or
> library feature that is not supported by the minimum supported version,
> if given by the `msrv` field in the configuration file.
>
> For instance, Clippy should not suggest using `let ... else` in a lint
> if the MSRV did not implement that syntax.
>
> If the MSRV is not provided, Clippy will assume all features are availabl=
e.
>
> Thus enable it with the minimum Rust version the kernel supports.
>
> Note that there is currently a small disadvantage in doing so: since
> we still use unstable features that nevertheless work in the range
> of versions we support (e.g. `#[expect(...)]`), we lose suggestions
> for those. However, over time we will stop using unstable features
> (especially language and library ones) as it is our goal, thus, in the
> end, we will want to have the `msrv` set.
>
> Rust is also considering adding a similar feature in `rustc` too, which
> we should probably enable if it becomes available [2].
>
> Link: https://github.com/rust-lang/rust-clippy/blob/8298da72e7b81fa30c515=
631b40fc4c0845948cb/clippy_utils/src/msrvs.rs#L20 [1]
> Link: https://github.com/rust-lang/compiler-team/issues/772 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks!

Cheers,
Miguel
