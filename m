Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1D717165C
	for <patches@lists.linux.dev>; Mon,  1 Jul 2024 21:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719871113; cv=none; b=XFCLu/GA+wIuQy4qBUaZlEzQQ6oB3o9XPsaIgUPhszyILBzZJcEzjVKwrbbOMqRVwzGR8ovfkTEgqHxs8q6PzAD8/LQXtivzNl6l7VxMAFHqKiEunC+imuHC41txS3PGHWMbuuthJF0vIK1VoZjzvmgISPWROt7ujgcgHRZjWtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719871113; c=relaxed/simple;
	bh=tlQGRW1IcR2XLrHRJ5fJHNgvknF+VsqTTtXrxqai0CA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GIvb7XCExxnJMHvjrP5itxnDqHd1yNlie7YY7rYYBX5KRoDDoMn8dTzW+wIO+FpcBmMVUFm9GILaOQWcNoX7vGfxY/GzWv95RrMe1+/zlW/TsbXSE0FFSPSZb1A/8iWW2V10EMtKyvyp/9jb1ubqJQs1tYYR31VL6bMIcgG7uQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U7LMP8J5; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U7LMP8J5"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2c80637ee79so2315703a91.0
        for <patches@lists.linux.dev>; Mon, 01 Jul 2024 14:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719871112; x=1720475912; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tlQGRW1IcR2XLrHRJ5fJHNgvknF+VsqTTtXrxqai0CA=;
        b=U7LMP8J5U1TsPrA9AIUjIuV1HgvluXltyhYHUAtjoedk5BGd5UnhhosKwbtlaGFXHW
         UQYfDYxIPWd9CA2+h/V55nkHY0bF2yxP5Yb9ldY8e0d0cDy+ZzHungIpLhILlw3jynCc
         i/mFwLSYufN9SundObt5UsoC+4JdHdcb2eRTc/OKaBAEB3xhLGVxSGoJvNwpliHdBU9c
         Fl12NWcuTm4iXcTw2ABHAWyk6jweRPkvUcSw9koi1h1jWLVM3n9gIcia5bvuLyJ6POEU
         531hV3N7idycM3/+VF59iM44dfv0Ls1gkt8mL+bl0bTe97YkEOyulywfbQ6yMSqENbKJ
         M7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719871112; x=1720475912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tlQGRW1IcR2XLrHRJ5fJHNgvknF+VsqTTtXrxqai0CA=;
        b=A00QvRmPsWBfMwCT+ScuTY5MMyY5BPVSZGfqhnScMtZ/GLXodvHi/O7dDzmHD4/k6l
         5uMYTh7/iNbM/uCEhpc5K6jR1DxSeCnS7E6YWg5BkW+5GoJnNxCMdK1IJDYoy2DofZ+W
         AEEkFl9Q8uGxM48dacwK09naTG1v6aaLK3xX6FPQdFuQ956CFK+k19LSbKlB/UZZiSFi
         i6aVW97HaYkHoJHlaWVmFo7V6l3Gn2MJYOUj7AD5kQsm8jn+VjSI/uEbTyZcLorgyvEZ
         a8XYmAbj+zQ4nJJ9AR8SiVSyNS7qA4uugfzFUoK3LNNUw+dEe+SR2zgtCFZ878d/1QI+
         10lA==
X-Forwarded-Encrypted: i=1; AJvYcCVfrzc0DvPlJCE7s3KSI1ATOt2ByDISixg+iHy3rDbCwsPBF0uJGDyL50fsR3k+iWKY820GCpYakljUYxCZ5ixlB/IEhrRfnQ==
X-Gm-Message-State: AOJu0Ywx9GsmgmWiZBlZdnnsgVF8F4uajNU8Gt4A21ck2Kgr9yYaXYav
	z6a3Z1lluIr76FGoTmJ1jGrW1CXGCo48/3BRt2xdp1MQ5LjPJ3Z2IdyJnBEP7MOUzPiyApOX6j5
	e54WnM4Rto+o2AggudTIdK1QrcmA=
X-Google-Smtp-Source: AGHT+IFrP259sfZ8yGRxwucM+31Wr6lNtpD3kv0GbUgMjP0oJ5e5qH0ThJSRx/+w2HTAmQtLrbU7L6R2M0upQgm0mj0=
X-Received: by 2002:a17:90a:5890:b0:2c8:5cb7:54e5 with SMTP id
 98e67ed59e1d1-2c93d79abaemr3418146a91.32.1719871111661; Mon, 01 Jul 2024
 14:58:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240701183625.665574-1-ojeda@kernel.org> <20240701183625.665574-3-ojeda@kernel.org>
 <ap7u5hpgfdzYgTkobIleYc0uolBIsAVbq56CwMJG6k4x57wXeEtu4fpLpgSOvQtbJHvB6D0J1wlBaqDV-xt2owlVejhfABUv_ivILyJ2J9o=@protonmail.com>
In-Reply-To: <ap7u5hpgfdzYgTkobIleYc0uolBIsAVbq56CwMJG6k4x57wXeEtu4fpLpgSOvQtbJHvB6D0J1wlBaqDV-xt2owlVejhfABUv_ivILyJ2J9o=@protonmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 1 Jul 2024 23:58:20 +0200
Message-ID: <CANiq72kMaPm2OsGb3o0VUtdoMhSUoo8QEsCFzVjYFtCThvNJ1w@mail.gmail.com>
Subject: Re: [PATCH 02/13] rust: init: simplify from `map_err` to `inspect_err`
To: =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 1, 2024 at 10:05=E2=80=AFPM Bj=C3=B6rn Roy Baron
<bjorn3_gh@protonmail.com> wrote:
>
> The formatting here is a bit weird. I would have expected the ) ending th=
e inspect_err call to be placed on a new line given that the unsafe block i=
sn't placed on the same line as the start of the inspect_err call either. T=
his seems to be a case where rustfmt mostly gives up on formatting. If I de=
indent the comment and unsafe block rustfmt will keep it that way and if I =
add a trailing space to the inspect_err line it will keep it and emit an er=
ror that it left behind trailing whitespace. Maybe add a block around the c=
omment and unsafe block to make rustfmt work again?

Benno: any preference here? Or even open coding it.

Thanks Bj=C3=B6rn!

Cheers,
Miguel
