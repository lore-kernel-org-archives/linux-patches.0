Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E983430103A
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 10:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762769973; cv=none; b=aNQF5+juI20miqcLLdZO2EkFyn6WV4CO8m3XL/npTNjKQsnPFF5Rd47CFheeD9fI7KGCaySIqHy3hXMOVfJnJKGbAhPaB0RdwDvfhblF+thXk2UFXGje/lgAodPSX/whbtVCkK8MQTKhfOBiIa29uO+ANxjhNitSqX/xkxBfSg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762769973; c=relaxed/simple;
	bh=2GGpzP3+SpGhGrCwsh+gDg6Isv8qPzoSRYTGoMRT1HM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HbV9elgBzXVCSfG5AowPBkQqW3G9+j8Dl4nnhg8BRFzAsYDFSgwczdgAIL7ypgyryTLngxEdrHIU3eGxL+Ree6exHXlCdn9e8jpSnI3QQaXBEM1IZA/BFjEWJ+H7eBL+5nkr0ieB6TfzlGmVKdE13/OiFq+NgzM4fYAdhGv5kpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U+ek6z4j; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U+ek6z4j"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2952d120da1so1944365ad.3
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 02:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762769971; x=1763374771; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2GGpzP3+SpGhGrCwsh+gDg6Isv8qPzoSRYTGoMRT1HM=;
        b=U+ek6z4jva84v5IcPmXkwysdU+BA/aCmAXgMdG4/r7sR5ZQcH7HMc0dfQO+QRDDqNY
         m7qK6MjaI2+Q4bJiTsLQXpjQt8z9P+InlocMfrN2JQ2JdWP+HiCDPluYH2HRfcCcZHOB
         mh8AMrLfBkFFOT0uzbwW6BwNVKAG4rWWY+wP1Ee+snEg/hUMUlHKBmM8nrnZ1wqi7vn9
         1BB6GpI2B0EgR87A9u0NIxzxXEkSkmiS3E7LWzfknuyb8aCckBSluF0Lghax654NynE9
         K/sX0Duj4sFzgaZE867t3QmYqFhmMYAltyYyrVJ9jO8RLSBxpX0Eui8VCY2pytRAu/sq
         DpUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762769971; x=1763374771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2GGpzP3+SpGhGrCwsh+gDg6Isv8qPzoSRYTGoMRT1HM=;
        b=djRQYx+TsS1C/2RP/EAB1mbfHPF/1YOsnPnu2jNNwO5ler+Jd4DGf+kTB+i4Bqo2RY
         Tm84ani7EVdgfhLJVcKiX2odl+dse5TfjOtMCWPSmVKKZRaAuChht23zujMTMFYOtFyj
         w9KOmAQkT4euT3weBM74x8E1fh5xSB1zqR71qCGFRHeI1c2/t6PLhrhYBDof8DHjBEgR
         gIIRX9nuBsmjM1xHF+JnDb97zx3zjHdaAt4HxZZrWCXPHfJLkxWF3jHu4vlHs3vx7Mos
         TbV8DoWIqntegGw/U2j32kIQpVXHpQuj+FZp8HGoY7xFq3mX8J/9iw4L0fMgVJd4PRZo
         Q2wQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSJ5/3YRzhqEoU29aJ0L2R0ocW3P9gv5ln+F5ogb7RzbF3G1O4sKfo8SL+4gGblJWIXodF6QI6@lists.linux.dev
X-Gm-Message-State: AOJu0YzPJmC2mixtxwdV8j0kQ39/16BlAX7Zq/M4VeWLeArmg8ggO4+m
	jSqTXdRp+a8Dnq/wW6Aq10sghgLecd4a9eiK5KhIp1KYGtc4KKr+JAgdZ/1jP/LQMutZ3zN7AWw
	B+jVqXDlXjseYJwsouVEx1THuqCmYXtw=
X-Gm-Gg: ASbGnctlsBfBg1HLp85MvfI31g/mQU9UBwxCgUT6x7F6mdWjkU3qKHueGPlHDQTC3ht
	S6JfDpb1PzE+wbhXU76hE6EYUS3PKUluquQxzavmPqj1GEuHZTEKs8jSxhfbECTnyuo2YUhFnIy
	T4pr2DsuxI96KgUo8wNSBYDHefqHtgjCNjeZr/z/V4hRZQhE0TLD8yaQIpotPOnsCWC6IPGSlEk
	LoimNlbmHFtQOlPNbUYFn7v9OwJ9pfeteQeOouEOLapHOpZrARKfCOZmXMaTjA2Li0AZGfNosFL
	h1l++xhH4coaMd9Bw4hklGaV1zd2I2IT29n3R3A4mrgvzoAHVN9+tihrGFZdDnXPqxpEKW7uFY/
	/DY/NNgkX6nQFQw==
X-Google-Smtp-Source: AGHT+IFdFdVhwPLfh+yTbdERl64DQLjGM0Rh3dpM34UNEX4KxB1YYZB8zJPvvmK5YGpWecjSiRSDrXRu3SuqxEmyZWo=
X-Received: by 2002:a17:902:f683:b0:297:d825:bf22 with SMTP id
 d9443c01a7336-297e56831acmr54002375ad.5.1762769971269; Mon, 10 Nov 2025
 02:19:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-3-ojeda@kernel.org>
In-Reply-To: <20251110095025.1475896-3-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 10 Nov 2025 11:19:19 +0100
X-Gm-Features: AWmQ_bkb3t3uALt-6fRzPMlQAGQiJXQm8chK-T8Qof8lqrSz2aUgJvRPu8rtcUQ
Message-ID: <CANiq72n2TDN9oa7Yu2otk=HfpJQ7NA_X=up4uGO=JszGvaGspg@mail.gmail.com>
Subject: Re: [PATCH 02/18] rust: kbuild: introduce `core-flags` and `core-skip_flags`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 10:51=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Thus do so here for `core`, which simplifies a bit the `Makefile`
> (including the next commit) and makes it more consistent.

We may want to eventually use `--cap-lints=3Dallow` here too, but the
skip flags here were already feeling a bit more than needed for the
series.

Cheers,
Miguel
