Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68C01D7E47
	for <patches@lists.linux.dev>; Mon,  6 Jan 2025 11:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736162997; cv=none; b=J1TZ2PtWQVF+OBM6t0VC1Q3qYDBwlsLLjGD2avGDUvS2ClItnqo6ntI7vZoJtHfK5FEVeSMfRIl6xgYLysWQ0tLP7PRDF70TjHouXYwLXI1laqzIDUoakjKK4h2ZWpvs5DrTHoDIW+1cplafouKx3ZPtEVLsge68x76UMAD2CAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736162997; c=relaxed/simple;
	bh=/ix8w6evDkpmvVwP9VPDJapgMSv7jkFt0DcdOyafdaw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AKR5u7zEoyuIJrt/L/8ILWoBy2xmj9INom83Q7zQRAJsZSCWOKNPcQpOxYg5pHdRB3cd2LWgDRdkDTjI5bhNSl9xllDE+kyw2vQUy41rKozdPxT0mO2477X6qgyWUNMWuJRksyBgf+mnxvMmZ54aS74gQYJn9rScsiYl8Rpz4Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iBGAPifn; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iBGAPifn"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4361b0ec57aso142126315e9.0
        for <patches@lists.linux.dev>; Mon, 06 Jan 2025 03:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736162994; x=1736767794; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ix8w6evDkpmvVwP9VPDJapgMSv7jkFt0DcdOyafdaw=;
        b=iBGAPifnrU+mCwRsS2Gk5Cm+mEkhcsA49Kty/RSpDwWR5fMcFKB4Dlborf2sHCihUv
         9IuH1mVo4x2NFVL3XP6ob0ZRhGxpxgFiiE9nLU9wawugxJuzW7T6HpdzlijkoeLjgiNB
         C32mKDm7peylrqdcj9wHwiK/XM03WHLXSOjJy0SDYhSv9B3oLf0o/EXX7OB38LSPm0gX
         A8pJ0qcTtpI3lKnG5uKnSjWyhMwXyFHrTU4X5btU+KEL+9BFNwi7cxsEKTB7OOi0KrjD
         h++CXmyhy2YvWzRvcpvX06Xw2HluaXZxy3s2IFgZ+83ELQU+lVOkjV2zT86codXABrTI
         EE5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736162994; x=1736767794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ix8w6evDkpmvVwP9VPDJapgMSv7jkFt0DcdOyafdaw=;
        b=SY9MpRTR5aS60iN6j0yaN0x5X2FO4ZRQtlJSH+obFKvyuqlidqNNRq7T8vyBkb9xhk
         8u0Hx2n9KtsjyUVdvWNI1hBu1+WmwpAWsTDWW6uYxEBqQLPWZaeNvmVEylIj7tDfDPAI
         VIMMzj8QhDb7iM3XARrHiU+kutwEPsqyHPWzNFHCdPWdwkO3C7t7nAP8lBZkcJO8BVsC
         6Y56ZUe7Da6xSxlkNoueJcDMB7aROn7qX4JaeT+Ti4EpV62EfgIFWAES0ROy47oWOENk
         p8KsB4ocrxZimv4Y+DqOkxtWjQbh4WRzvYfZXtOjlGYfK9YrHrtVOKtbMpup1qQWZtZS
         EZIw==
X-Forwarded-Encrypted: i=1; AJvYcCWL5aXeu17p6IL63ovHhlRFzNRC4DejdvbRUmzcP7luBdTHr0B20t1Ky3aF/DQ249X8jfYW81N+@lists.linux.dev
X-Gm-Message-State: AOJu0YwmJqiVADfNVclDIH8WNqDp6iMv13xtETB8mZGm3jLrotwLe1gt
	o0WFzwdCddu7ddA2JhpGHJrgTLh9RMTdKg09T67mr+jqcfGVdvKZE58L0YheP1/rw94yPrqwxip
	rkaXUMiNXaobK8UGg51lbfAuNJDEnWP9uz0Wf
X-Gm-Gg: ASbGncuIwDKZvMcEFI4PWsq8aQYyuiLgzEysGBpwKm9spilPIlDep0YGhgWi1kUF9Kb
	b3eE3ajiwrmAf55icNe1miSbAu2VGX/CZjw6AcOJ4n9E4YF+SAP0lfO2MWCOHgwabw4vW
X-Google-Smtp-Source: AGHT+IGTT0LIINTWIdyF9Q6iSt+9zlbm9FIaGUlaGzWUY/mlvpmOx1CHT0JCs3L/lCr045YwrYpusY5N8t+aTanjbI0=
X-Received: by 2002:a5d:6d0a:0:b0:385:dffb:4d56 with SMTP id
 ffacd0b85a97d-38a22408d23mr56344251f8f.53.1736162994156; Mon, 06 Jan 2025
 03:29:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241209212544.1977065-1-ojeda@kernel.org>
In-Reply-To: <20241209212544.1977065-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 6 Jan 2025 12:29:42 +0100
Message-ID: <CAH5fLghR16z+2MVToPo8e+Cw2E1dBPSaNHN0jf8R8DuXEH__Wg@mail.gmail.com>
Subject: Re: [PATCH] rust: document `bindgen` 0.71.0 regression
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 9, 2024 at 10:25=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> `bindgen` 0.71.0 regressed [1] on the "`--version` requires header"
> issue which appared in 0.69.0 first [2] and was fixed in 0.69.1. It has
> been fixed again in 0.71.1 [3].
>
> Thus document it so that, when we upgrade the minimum past 0.69.0 in the
> future, we do not forget that we cannot remove the workaround until we
> arrive at 0.71.1 at least.
>
> Link: https://github.com/rust-lang/rust-bindgen/issues/3039 [1]
> Link: https://github.com/rust-lang/rust-bindgen/issues/2677 [2]
> Link: https://github.com/rust-lang/rust-bindgen/blob/main/CHANGELOG.md#v0=
711-2024-12-09 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
