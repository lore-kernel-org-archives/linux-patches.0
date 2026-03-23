Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E13136E478
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 13:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774271189; cv=pass; b=D50vUAvSQgaow2nWdNkUHDjE8iNHXCPcGgidpiBMfuXKm8cYEdgsP1sswRWfSheo2lpRzqNAV88Ux7MxyzRIiM297Q3XluwjI0ckJtZne6wqzV1VuiYQ+ym1O6LvjtfujIyRDKABwRXvcNdOgB4INEJC5eAQ/4lV5DL0f2O5aQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774271189; c=relaxed/simple;
	bh=mpomDLO8ZlCocmuPtdKICwxv4H57ynvhw4z1RG2BH9k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=El9A/y9/MDfD8beu5tsgtoAhN5FfD42XKYSdZoO3ZNZ2xx2b2yl1lleR/d67bvSFSMpnxkd0ppla+/HuqWmKl38O2gx8yXuzDuGGU5qouUTdSjpIuxw+OiG01CsZixxFk5UWGFyh5POXD30fFHU3PcLS81MvYCWWhA3C3gOt09s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kuSIAhck; arc=pass smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kuSIAhck"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-2c0b6f22aa4so238214eec.3
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 06:06:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774271187; cv=none;
        d=google.com; s=arc-20240605;
        b=N81/t9bcgSznUnkFHFIsaTz1W/ESIx1/2DorbDx02EGjtrB7LKU8rwFoL4py4Gj/5h
         6/h9WDZ1mzBk7QlZ/qXfLk9UH8st49VvXBPQ3/ZAP0T09gJ5eQjX51A51VkDxpApITis
         3nDQSo9x5C6oZ7xZoOsN3SguAopepv+Ee/CFsMpBTzuYFJrV7kbnNvFnJiqvRzdmQN4r
         fW4bNpHB52t219PdTpualQ8yyjEZPv0O5iP8T2v1M9t+43mBVv310ZFKVa8MYKrTeRIx
         07Y0TZO393lYqIif18qSU7OVzpFxhWoQFIBL31mmDogqqiB4gocjD1/JySyUi6l8p3sZ
         YP/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZeosOC78tfRPtRL6p+oZtOws2T4Y/1DZR2wWiWY/WhY=;
        fh=TkHOr+TK/rAEjMeJn/Ex7Y6Cf7y7P1bgz3bFLEkoXys=;
        b=HZMe1M3KOcDgHJDFcBwUiHkow+7IZhXZS/0Ozit6+oIF4b2dfDyqlL4X6F49Mw0c4o
         dg+Gx2zdBhq5dqIGODycgXRapmf21JWPaRoTPKb8wH/kVeU3a4WbhoipgWEQcjSppMkt
         C0PSvlFODxGykX+RABPnAAtqwWFflu1KypOtsf8HMIDqEL2U2sBQIeF3MvrmnK+Dju+K
         dqRoQ49Vh7rvVIRRx50MSiG1cauzUwXLTo8d4Gpx+a+ArksxsLXEEK0VrLnnpSl5Xcyi
         z1hBBgoRCRI1JOjDdcTDJkzYvZVbK/pe14xoxURer7IFtBpMC6nkv4COMI6mYvsPWtHz
         zT3w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774271187; x=1774875987; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZeosOC78tfRPtRL6p+oZtOws2T4Y/1DZR2wWiWY/WhY=;
        b=kuSIAhckaeaKYiiaSQHGGdQiBIjCzMoc4vClkUtfwWsuojkT12tHkzs/N4en5Wn9UQ
         yWi+KMmnMhh4kcEqvLF4yBJIl21qOYDziv+hSHLm/b1WCNYJ2Mp2Fs705GUKZdKkcqPd
         hnsHfE6eD4NweRa7YDGUJBFxaE3XUPn7o/kmu3YY54V/I8g7yCUyVbL38t8OIiUWCx7L
         qxuJ7Oto0qUAhklOeFqljt6zrN40bua5Sw9O3w5mB8bXYx6vbDErP5++x4x4Z9ApQAbZ
         G7mj20wGkeXd/fGTJis01GAlympMy1f61ofHiiU5eFjo2+cvVviG95XZjRhQhRLISkBy
         afzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774271187; x=1774875987;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZeosOC78tfRPtRL6p+oZtOws2T4Y/1DZR2wWiWY/WhY=;
        b=iykBiJMT4rhfgmTrA2RHtEKCTcutn7h68wai7kWx5/0uTBqGeNYPQzRJi/p9wP3vKY
         Dz7cWeFanjr0yPIDLfEFdKStQsOEjDwf5K8CIZaI8OzsfWX+f9Xaftxc78/nW/R1VgML
         ArqV0y7mPwG/AV3oAkjPZOdq1kdhJptErGBP4HJ9H2PSFDN3IjRswGJv4By4VDWuzgw2
         UWNBHYFSI5segRDKHqXheQGX1NL2a6a+HNlcSRZW/XQDJSxnQmQJC0FBUGNonNv7cTpb
         5A5BH0xXpv5jYwPiEEPp+xAN4MApaTXruLC4tooTeLlj3shLUEb3qfFLjzZFxuYkqGVe
         TZ4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWuBkM5I+1x9NYU4lK4W0dzEyO8vfBO+//l60HMmDi6AGhEBVD+Npwxy0ByQY8IVW0amOyLRKqB@lists.linux.dev
X-Gm-Message-State: AOJu0YycjuAlmqfSgbt7D28VRGfbnJUwIziL+OCNi3QT+LqRO1vz62hb
	qiIlxjdm0a1FqMv7xxU4iw5qDZgx9uBZv6lRUFVhywbAFdtVgCm8sWyDnEEgh8tIcZxj2vyc0OF
	M341ZZYyfgq5Jrrl7PzIpdncrMkc6jIE=
X-Gm-Gg: ATEYQzzK2h3rZaqIYyMqqJ1OUJAdVM4nNZK+eNVNb/bfsY6WrE8AQVa5RXFbWU1syfA
	H0BKU2roHFdvwRurwHvjPPhXy1CTQ7sOmBj6NgaMjQ2QZX9F+GoGyJL+3Vcd2m7uEb3nuVW2nMa
	+/iNjsfvVZi7NVOIjmylbbtgN+v1e7i6gN6MBjUrly6ke4kb2u0eG1hfiLgv7/ySAjfNHr0+yqm
	n+NbMbBydYaiIXvkprFhGLRczcUaw51NxlwKhZ0g/4F+C1LrGL+PzLmTUshJimDQIb2faAo2tLv
	wz318N7CAhGtzJQrQBmfSB40AA7GAE+qvv61MWeb6AxDZyypTNK01uGbNIwUxjA0kBtaF61X1MJ
	jN//yIuFF63pB2G90t8WsJ+0=
X-Received: by 2002:a05:7301:4085:b0:2be:1f56:ed0d with SMTP id
 5a478bee46e88-2c109861f4cmr2413702eec.6.1774271187398; Mon, 23 Mar 2026
 06:06:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241119185747.862544-1-ojeda@kernel.org> <CANiq72n4Fw96hcuqQeorsfH7z4Tb+R1gdf80H_XkD-oA6z5TSA@mail.gmail.com>
 <CANiq72mNJrMMbEcfJMLT4kM-_iviM0AR6oeigCyrb5eMWkn3KQ@mail.gmail.com>
In-Reply-To: <CANiq72mNJrMMbEcfJMLT4kM-_iviM0AR6oeigCyrb5eMWkn3KQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 23 Mar 2026 14:06:14 +0100
X-Gm-Features: AQROBzDGgsUaXadH-7vInj5g5TFUGkgbxokPDq2lRRDY18_WJ88m9e2GeTeDbRg
Message-ID: <CANiq72nvR70EOud=4drW6gs=FAndv5o7+8n5NNRkAStTaSJWPg@mail.gmail.com>
Subject: Re: [RFC PATCH] rust: allow Clang-native `RANDSTRUCT` configs
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Aaron Ballman <aaron@aaronballman.com>, 
	Bill Wendling <isanbard@gmail.com>, Cole Nixon <nixontcole@gmail.com>, 
	Connor Kuehl <cipkuehl@gmail.com>, Fangrui Song <i@maskray.me>, James Foster <jafosterja@gmail.com>, 
	Jeff Takahashi <jeffrey.takahashi@gmail.com>, Jordan Cantrell <jordan.cantrell@mail.com>, 
	Matthew Maurer <mmaurer@google.com>, Nikk Forbus <nicholas.forbus@gmail.com>, 
	Qing Zhao <qing.zhao@oracle.com>, Sami Tolvanen <samitolvanen@google.com>, 
	Tim Pugh <nwtpugh@gmail.com>, Kees Cook <kees@kernel.org>, Nicolas Schier <n.schier@avm.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2025 at 3:19=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On top of that, backlinking the seed discussion since I will need to
> update this patch:
>
>     https://lore.kernel.org/rust-for-linux/CANiq72mwYbg_L8u9NEfRD0Fp9E_zh=
Ci=3Dt=3DU2jyjsZe_Ls306hw@mail.gmail.com/

I don't think that got merged, so I didn't update it for v2.

Cheers,
Miguel
