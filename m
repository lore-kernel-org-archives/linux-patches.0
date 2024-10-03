Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FD410A1E
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 13:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727960595; cv=none; b=DZKViKvVZE2+ZfOlKMY+ksSnKQUOcF0WtcjEH59m6Ua0njMQCR5HlvnIBWoli+D2pvW1PVrLibXmECEk8PVzS6wtTw6F/IftAsqPdrkz1ZIdyxyrW61a5iJvDMCptqlEkyOqa6O+oz/GKrgufGWBqxEf9PjorqT4sTF2xOv4tzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727960595; c=relaxed/simple;
	bh=0pjEEqKZB/jOjZ4/wQHEo+m3ps7ACgQNfifBOM3AuuM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZdUeAom/9s8EKk3Q2FWMu69OHsb9UPn54CjJ68nw55d7mOfShbdt4Kmf/dOdja6lKE/S/6IUkXWBNJrps/MJglJvVzyiy7cAnJgEZlLfQGyjEfZqcgNWOl/Kr8dC7nCZifaoaQGYRJTGKbSrncY28G7H9ItaySPrIxgY6S0/5Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LxjuHjDo; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxjuHjDo"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-53992c176a9so121196e87.1
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 06:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727960591; x=1728565391; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0pjEEqKZB/jOjZ4/wQHEo+m3ps7ACgQNfifBOM3AuuM=;
        b=LxjuHjDoYjxKoXKvF3g6GzxSPIjBjLgA1OPJurgjmG3S2Tf9AuDHXmUTUhq6JcKbuV
         pxRZE8fGjcInyuaxBOEIflZbYHjQOn0YjKy7WJ9lXrjEfZmhq36Mbj0CTUVQRm9p/bhe
         SjxFBOM/enrZht8K4KyACINNxIyE7HXSECnR0g18f9iu+M6O3MHxex6PfODICjpaTQTP
         Zr4JJSf1i/ZEk/eeAksIkYbRAQzIbAlOm72DZqJQOUINQsx/Pedcvf0kS98tZRssoQk6
         NOn/sakvMTnM2cpmepB3wU0GHTG4o+qy9YTra8tJLl9mfb2T7K2rxY6Vg5fMN++pg3Oo
         L7Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727960591; x=1728565391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0pjEEqKZB/jOjZ4/wQHEo+m3ps7ACgQNfifBOM3AuuM=;
        b=j7/obCCbAS6pCp8qhb+nGbtmMitnc/UQhO1RY5En7O1x4NzCYi/+vhNnTIPYBz6rlo
         k9JnqsKDsaN5US5PkIgHgH43B2tKVU2BgCadFILr+2YtHvSae24VdFYJx5dW+WZFjCBX
         c6de84YU6ywdRsgkshXUwDtNMPlaQ1phvc8qiNXzIz/aCSpaaqGpRmM/BtAfjT9hp7VU
         A4/4AHbkQF6k1fVIwjvUwRZLWOsJ5uolRVO12WGz7nck1vCuiGxuSp9yFVxY3PCYb+YE
         A09VFI7ZRqsGQawOpD2Q+TeHCZNVM2pUkL21QeafGQ7BocEZJe9Q49xqtm4tadgidN5h
         H85g==
X-Forwarded-Encrypted: i=1; AJvYcCWLbpm9qqJYu6LJx6U9ft6lv0jOCbROc/B7Y2zlQhb3J5A6pjVOMHBB35NSq58dHyHT2Wda/I4Q@lists.linux.dev
X-Gm-Message-State: AOJu0YyU/vI/jlCnNpyaryxtjs0WMaSREcqmMX/boS7BQvnNHQ1nI+dz
	8J+m0Lqgw8WB18A4i/a8wyTgHNGEyGAdByCzFFTnce8rI5UflLTVHXGHcPzpYd6Fi6CUrbadeki
	PwW9JUYKlksM0H5j/HMbdpFcz4ic=
X-Google-Smtp-Source: AGHT+IFD7y/g7S53GYq8SiQwnOk8qWSqXT05lzuITIkOIY2dV3j4VDuyIeBqThOBN0TfTDlNvXy/9tNoXVrAV/yNNmc=
X-Received: by 2002:a05:6512:3c8c:b0:535:4d89:5b52 with SMTP id
 2adb3069b0e04-539a065f9ecmr1045863e87.1.1727960590956; Thu, 03 Oct 2024
 06:03:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240927164414.560906-1-ojeda@kernel.org> <20240928193632.063d62a6.gary@garyguo.net>
In-Reply-To: <20240928193632.063d62a6.gary@garyguo.net>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 3 Oct 2024 15:02:54 +0200
Message-ID: <CANiq72kQ+E5-qQ9X8UdgcBN_P=7JYHo6Ft8rLNRwAXmxbMyeMA@mail.gmail.com>
Subject: Re: [PATCH] rust: kunit: use C-string literals to clean warning
To: Gary Guo <gary@garyguo.net>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 28, 2024 at 8:36=E2=80=AFPM Gary Guo <gary@garyguo.net> wrote:
>
> Note that the cast actually need to be re-introduced instead of
> cleaned-up -- `c"".as_ptr()` returns `core::ffi::c_char` which might be
> signed, while after my series `*const u8` is expected by `printf`.

Ah, right, in your series `bindgen` will point to the new one while
the method will return the `core::ffi` one which might be still `i8`
in some targets.

It would be nice to get a way to modify the target for `u8`, i.e.
`-Cunsigned-char` or a "target modifier" or similar.

Added an entry with some links in our `rustc` list at
https://github.com/Rust-for-Linux/linux/issues/355.

Cheers,
Miguel
