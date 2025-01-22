Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046CB170A15
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 09:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737536993; cv=none; b=EYhphHueB/fI9Jt1/BmksT+s+K+y/on8YfH3ayeF+YkZIgvrI6+Xc4XC0B+CruqmCOArWKn2NU2Pryvkek88yCVd6npbTqQVO4J9TBf0sQPF4Ew0Bag8E6J/7XVgkLt5fy1FoCQU0UFd7tGPpL8erRrrTpBjINrhVJ8jL3n5R0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737536993; c=relaxed/simple;
	bh=2WAv1fZWi6FSo+sNAeuewqpsZCPg9rKwCFH+MiQwAa0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PH12b7ohjIo+cNaQcffnlCESv8wcz0k5VLaw+koU1sFq/7rmvkctGeYVE/NVWayYk+2vCMlwe65IsUtFgqstFeq6WCHw2fTV3k7qTjx8omJpGxniFnPnkR+ileL4Hi8ZKHMoG3rveJW7XAPAKHjuUn5u27qmwXCyIV+l7kZzjHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rfTNYQSG; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rfTNYQSG"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3863c36a731so5561045f8f.1
        for <patches@lists.linux.dev>; Wed, 22 Jan 2025 01:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737536990; x=1738141790; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LAtNzABgivJyMHl67AxVlrKNNT4N7NGsuX2tPsVc4oE=;
        b=rfTNYQSGMJ2iGmcXvhNns2E81QtbNLWuI9QwtwPqGzCgNHtWXjtCoaoodtBPX+6knA
         T+DqanNofJjoqTYBTtnTRWZiFS6GbhbcHFVMj7WugH6S/Ca+evZ8AFOMbwBHvoLtZXDd
         YDD+PPVMjsq4fppXusUp9+AC3ry0ekK26GcfKDYLUDWsG4xDNSD1ToQmU8h/9djG8D2g
         htfuPv/zys3Hosx+hwhiDq8SimQBLzoqP/QH6c/29miGYc095RI27MvH0PItxdkhngF1
         Op1cvXb/YnhsFKNGShSifTwwQrKLGd8EfeNwjJTw0jVz5p6ZkwdDzLlw1A2bzWXBzObF
         Pk4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737536990; x=1738141790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LAtNzABgivJyMHl67AxVlrKNNT4N7NGsuX2tPsVc4oE=;
        b=FpeC+HnjtA3Zq4jM3wSo2srfYAfnTWrdnzNLWPtCAeTBYwOB5dv21nP6HQDQy4nuFi
         jGqT6VhIQgZnC9sAljPb5eh2FTAn0NgEKul88aJkz5mhSm2DMLXxrKJSlBDn5PpgXEIp
         RTjR716LGCTvrXmjS3VC9scDjFteOO07Opwsu95c5rIlXW6RLv/nX4+NcVccQRBeEVOT
         EeWr3Qn2XJnk48UHI2SLKkrG+d2ynZZT1t4+5J2A8Rr8t+p+0nkyt/p4yqC0b16JcXoq
         oGfyJJDPQ58RioXIUwGE3TolMgCReIRx9jrRjReV/StHwX8CQmUCpyeVlTL+M3qdzTVM
         1sRw==
X-Forwarded-Encrypted: i=1; AJvYcCWLF7vFI/Vg0J6NVFw+7bI9aLz66evepN8vMD2azWeM84zAeqFUwDu0P5UpIM0maDctUOUkDQKV@lists.linux.dev
X-Gm-Message-State: AOJu0YwhU/HYl5ov4AKQPXOnMtobfPPBPcztiK1A44cJ9EmsjeItHAgx
	KCLsw7kHwA6mUEEz+s+QbK46WG7sPbmBYi1IWa2DWNEfr7tv5CsDSxP11+kmfXpNhkYUHvdJleh
	+eZYGF1p9eSCoOnqjzTdcmu6IxqeEmd30y5aw
X-Gm-Gg: ASbGnctvI3MWSyvBQs8TVrjW4PuzNV/2RGv3VdMG7qJQxnAxhKbB+hGZpvqBN9oHPd2
	xISeTue4NuddWvYJdy6jJPmUKaOteiw0gGzLA9gBGGNeXDxmUb1ikdtR6zzqs48Wh2RqUiZ1NV8
	fAmA9f
X-Google-Smtp-Source: AGHT+IE8sISUJ0sbUjuJ5vU8uBRJi5Fk4KbIbU8O3jiSMDOjh27QXtxILwzagCqnqCojBFBUcdB3Q2ffYFEPyhRlpFo=
X-Received: by 2002:a5d:6d82:0:b0:388:c61d:43e0 with SMTP id
 ffacd0b85a97d-38bf59ef478mr21993524f8f.48.1737536990282; Wed, 22 Jan 2025
 01:09:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250121200934.222075-1-ojeda@kernel.org>
In-Reply-To: <20250121200934.222075-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 22 Jan 2025 10:09:38 +0100
X-Gm-Features: AbW1kvYgEPke0Mm4asQAeuWGL9gs90635G5kOjS1vZYCD4ylQc7U1G4SnIpfKoA
Message-ID: <CAH5fLgizcjPgnQ0WcZ6q-pjzxaJT53cwsFh0r==m6pmnfYObeg@mail.gmail.com>
Subject: Re: [PATCH] rust: init: use explicit ABI to clean warning in future compilers
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2025 at 9:10=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Starting with Rust 1.86.0 (currently in nightly, to be released on
> 2025-04-03), the `missing_abi` lint is warn-by-default [1]:
>
>     error: extern declarations without an explicit ABI are deprecated
>         --> rust/doctests_kernel_generated.rs:3158:1
>          |
>     3158 | extern {
>          | ^^^^^^ help: explicitly specify the C ABI: `extern "C"`
>          |
>          =3D note: `-D missing-abi` implied by `-D warnings`
>          =3D help: to override `-D warnings` add `#[allow(missing_abi)]`
>
> Thus clean it up.
>
> Link: https://github.com/rust-lang/rust/pull/132397 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
