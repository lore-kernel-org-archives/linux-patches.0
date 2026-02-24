Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C98723EA83
	for <patches@lists.linux.dev>; Tue, 24 Feb 2026 17:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771954244; cv=pass; b=B4R43NFnbNcjbfXntCBo2pygOpJB+Pp/rSiDfhoHn3SHbtIIvQ+C+/CKT2SmXT8O0pqSDHXC3k0Str5FbJCr39uLr3mM1Xlb+SSv5qZjojkoMXH2VBN97YR/Bsc7ducHH5DY0GKec1CiH95luQ1bOCyaqp0dEbbMdN1UIcIqANA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771954244; c=relaxed/simple;
	bh=hc85fxZzUnttApa9NdPqidKuo7OpFu7Ke4r3j7ibou0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l6t9FwOLB6tPJ8d1N7UUVFfiDyw5hyAWOzWGi3i6Kkb3aw1a2OJyeBsPYuvaoteEob7NxoiNwSklQ5F7/N/J5mUyLsv1pL6R6uxxYjN5+AujCHE9o+vG1zlEJQSgtHf7ywB/IQERdnMqr+9TebZjkAvsphn074ac41Q3VzoRteo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=npdeo2MK; arc=pass smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="npdeo2MK"
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-12739fe9a0eso323579c88.2
        for <patches@lists.linux.dev>; Tue, 24 Feb 2026 09:30:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771954242; cv=none;
        d=google.com; s=arc-20240605;
        b=lZLV6lOUXr6R2VNy4gw6m6AueMkYIRncXc5LTjxhG4W5fKWKm6ip3CQt/XTscxLGDd
         XVAGb5UNgVCJgcoORsPsYuBgzDOVcaIMEUVo+uwRQPSjdvweSnrCK76HTn/M0xNdadbE
         Qkb0rSi8c+VGJYIi1keQo2qRDzM9uksbZMdhfAcxg5R0XDwyVKBFfjk0jW0UbpyEZWMI
         F/R6uMWr1SJrP4BrsaIQcmCHtNhkkt40FX9d0IxwONvW1fw6t39F7QMMQwLlLm7FC3FG
         8JnsYSfu+ddQI5lDzS6CzK09B5VgDFnhytDlRd8qobmbE76ymg1E43MhD2D18v8sZ/tW
         JmzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/a2JzYiJi8j5HoSY10XGkri0uRla1KOV5s6Jt2sDeKc=;
        fh=QRcClapHE9Q/JwqNPJII5fxFsJJB+EahHFhwnQGzfck=;
        b=hVmo6fjEP93atLXcbWCl5Ei1WxiZDZW6/4kJq/cGO8t43hyTn/fhxr08fXTz4wds4T
         v5Z+ITAjiFyj3JkXiL5W5trKlHf9yDsE/nv3b93oD2GP/JtE1U5eKGZrJ9AwV+pQMy/b
         Pn+9O61SWt415TUB9PG5Qb5BoZvdkv3cm8VokmN3/sQCWdwRogLlomF28e9Qig1hWm+T
         X1J11T+EhkV7anO6AWXp/ScGRDxxnYXekk6zixak7pE72+ru/umrfhcJRODK8YTGHtZd
         /3XOO1vndxI6tVi1z8yqRgdMhOmlyGR1UEn8Xg46Yzrw2cW/enb8lAghiYTqiZxgSKrv
         q5CQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771954242; x=1772559042; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/a2JzYiJi8j5HoSY10XGkri0uRla1KOV5s6Jt2sDeKc=;
        b=npdeo2MK3dne2Q3kfNRzCovDBM26lruwK1InwHPg7k3lQq4QVL7f8cIPar4DjTHgIZ
         Sb5rZK1f/9W8c1gLja7Ta426hG/ECXv54LTf9tMHqWD0Oiddkj1Y3FdD3+ZLEVCFcFaQ
         C8lwG2gdMq2DzQa1oGnbsbc1zeF+zgqVDXSyuMEixVDFuYePjo14dEOehAxwC9m7a3sU
         WVsCb+INEBAtpwb+5CUAhtfaC4U+hLMQG9sB7tzFbRe/TgaKBArE4XykUTouqJinxl8b
         HN1adt7eG/X0Ztv4b9z5NWazsd5MzAyTKw9N2f3T5pCKzkVNg8x6WhucAwBmjj4aGvHI
         r4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771954242; x=1772559042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/a2JzYiJi8j5HoSY10XGkri0uRla1KOV5s6Jt2sDeKc=;
        b=eyRla/uPnx/iJ3dU+u0ERbjgfgWFERkafzblHuK5KE6W31qa8EQoZCwUPR8yTAHVtp
         eu8KztGpQSHWqL9Nw4toxFgIN747NZCF0Xh6TXl8t5fmlNuiUsJ/2jyL1axu77Tl59zb
         Gquy4zgByM7MpaRgnaga0DWTzgYGs5KoShv1kdPKue/gEAbkb3wZNY7AMzFKn9A4GdEI
         nD6OqVifReoVPn94kwFZsfZjqolfyodzSsvgu7QKJV2p8ZWtmoY/ez82Fl/f/Q6+6Gpt
         y/cqKqAErD8bu7NB0sxfmPm3geMI6zlgLjtvDZBC/qc1id24S5iUNt3Ly+bEdthmwLS+
         NJgw==
X-Forwarded-Encrypted: i=1; AJvYcCX6Nh8oU+LMRgaH8sIwi65CTkwSI0UcM7KWvXNXNpPgoiHNsInpvTsgGAhhmywazwtTKhINt3XC@lists.linux.dev
X-Gm-Message-State: AOJu0YxgP/eXkGYqNAUZQDPcbTCtBksD38YtZH/6MZKLMGTcHSHhIK2i
	XXhz6torgRzeGoCs2iYaaYTVCh5QmoHX7ilkS2p8cO8Rcz7lJhPu6SziOOFhaPllfS63FQ0HEaX
	RUhlI3w0CPQQ6kj8sVdtHfLVq+08IMCM=
X-Gm-Gg: ATEYQzwXOGY5PlBvjWRjsmnhIaaZsQ2V0ufZLY9LD1K87Lm411tbGwFD/DQ1oekDl7L
	RTP5iTPboHRGS2rcP1qIP5CErVmqjSEhpoCoXoVu2FgH8I/PF/jhmpJkyX0FGxXLLPbaHG5/6Lw
	bFoQ+pTbKITPd7+tU36zTOtKxyB33UFJvEFFZ4mUhz2BjyyoCHqizYOMwzC5oZypDo8+tiuUuIX
	575UF42y9PljaV86B0zvX0JNo7fwCnlfngknznLu/nzniEi/TxPTX/yavk2RvokfMkQRd8j4YTh
	Ey9gkLKPdFYT4O5Skbqia1t5jspIDLF2oJULabNutn3kWiktvA4DH5q8ItzZ2nCbmt14F+IZSHA
	nGsyyERbPqkLF11ZlydYb80wXvEO0
X-Received: by 2002:a05:7301:3e09:b0:2ba:7d2c:1468 with SMTP id
 5a478bee46e88-2bd7bdb1e3cmr2638165eec.8.1771954242093; Tue, 24 Feb 2026
 09:30:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250325184309.97170-1-ojeda@kernel.org>
In-Reply-To: <20250325184309.97170-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 24 Feb 2026 18:30:29 +0100
X-Gm-Features: AaiRm51wD0fuBi0zdmWx-qM10gH2hHg8jiZcmf3ERejosyAQoJRqHDpNFa-s4Vs
Message-ID: <CANiq72=MT5V_rNDBTW4UY3g6vuZ1TQA1pk3kLERg1auDHYsGsA@mail.gmail.com>
Subject: Re: [PATCH] rust: workaround `bindgen` issue with forward references
 to `enum` types
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2025 at 7:43=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> `bindgen` currently generates the wrong type for an `enum` when there
> is a forward reference to it. For instance:
>
>     enum E;
>     enum E { A };
>
> generates:
>
>     pub const E_A: E =3D 0;
>     pub type E =3D i32;
>
> instead of the expected:
>
>     pub const E_A: E =3D 0;
>     pub type E =3D ffi::c_uint;
>
> The issue was reported to upstream `bindgen` [1].

This should be fixed now in:

  https://github.com/rust-lang/rust-bindgen/pull/3346

So we will likely have it in bindgen 0.73.0. Thus, after a couple
years or so, we should be able to remove the workaround.

Cheers,
Miguel
