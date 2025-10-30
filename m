Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD1530C37C
	for <patches@lists.linux.dev>; Thu, 30 Oct 2025 22:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761862227; cv=none; b=bSFfUAgFxEapZH7Lp5Hcc6l07ljyr5YAi2/F9/DQxB0nGiWcpozHGin/lA2+6hDlN/Eb7H9xXlfBUPwgEwmRmbDseKyYb7Ste8Qx9khd0O9P4+gvpm47qlL4F0jaDVH4Hrk+d1HzflRIcSX05dcCSyY9uRskBjZddLnOqOagavw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761862227; c=relaxed/simple;
	bh=yi3VN5iGYK0efOoeR4bO5a0LbuJ3TDjRF5ahHiHQFIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y6PT1pjdEHRIGdsJiB5Qaf9nWbwn8wWSu6eTY3WQYoUjNNmQ7CyQpLV0h811loWvvdbUVzVa+bLR5i3ZuDDezz7adKrIS4Uf3lNdH6tlY7zg0dYat1Wu0TuO9ep1b3IZvyA3a4u9YY6+MHN5hdual5/g3fsPhKRS5oDU+9eR1rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=u98WwqQ0; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="u98WwqQ0"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6406f3dcc66so2152416a12.3
        for <patches@lists.linux.dev>; Thu, 30 Oct 2025 15:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1761862223; x=1762467023; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yi3VN5iGYK0efOoeR4bO5a0LbuJ3TDjRF5ahHiHQFIw=;
        b=u98WwqQ0MN50qA2B5sXLMhsY5L9lxGItSDKPlaW2kKgvZXiQw8hA082q0tMn/Lalyi
         zC8/H24aHNJ5bjWy4WvTnAGDHoTUYUeCVHugSSIVTRLa2SevdTdSp2cE1ZkkP3NG8tit
         LHI284gU51MoRub6bsVOq/RV72jZrchNgEXDrWnu/K4YlV5JzBkdX+PptX2y/2ejys00
         X85ie1wPX8dfheAo0YKbbpr3SNxAwN5oUqosYo3G7kIlUuqTLlALB2u76KrIf3C+OOIY
         TNPtoSwHOeAPVcwQpNODuBem2fNY7fY9BD5TQNiJuHx7FSXwHp5g2cVNWlQ74aeK/LCT
         z3vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761862223; x=1762467023;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yi3VN5iGYK0efOoeR4bO5a0LbuJ3TDjRF5ahHiHQFIw=;
        b=jcnX1AqTwISmh8Er/OAa4ilcjAzOytrG1SXfL5x+/HgPyFDi0nozZOSZ5xkV77hjdS
         nA2o2GxCdO4k9fYM0M5+u6zStHt1jmCSghjuMvDooI5DMEpHq7+M93ZMRIycxkulg3g4
         M2SatAUJ3jbxeBwHlLgNAbQO0h6S2uELJyBOdMFXoPUEupgTgw0d6/vwBl4WK4H0Z/V4
         6TLE5AquYR9zcfd3rg4onHLSlC+z35t558NhJ74vmmVaK6NL0lZJMsv8swCyqoPypK3v
         8D3cy7h6aTcJkW7lrGa5cvx3pkT+kUic2/5Kb3XrapcB/4XWX+ItwFuvGH3g3wKnDcSz
         +piQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgnEd6WiaVdQWf8BvCvfbNPaPh9rSVrjy2WJyMtC977lt2jTGekPmjiLMvRbjG5Sf/HPwYqM6J@lists.linux.dev
X-Gm-Message-State: AOJu0YwyrOYOjAESfOQ3bZB4s+kzhMj1oWjQSnJ5pDjiTZ7aM1vLU4S6
	pqIj/kTuZvj04iADB5ryDzPIiJ1KxE7DgL7ZM3qcM2tttdSXt730D4WyDZ1m+bn4E7o=
X-Gm-Gg: ASbGncuiwP8lQbzHMZFXFr4uzdajFnjSgmzPwydvjQdGusnDs9t+fSRZx2S0MFN/FYp
	AI7LBUZZDncE6sNCfmXqW3V1f90rcqFhPH9Ke8cOiF/d0BdTWhhk1103liGvfMdht0ZCOELZXRF
	SmEGFTr5Ia9gWgMhvws5+WQo5LHlEQylQC5t98OMkQvNl/wvJ09lA+4B+vhxhcSa68lwtr6AMJ+
	bu29icoeqNXCOwhANLGRG2WozRdRQdU7t/sqq7t18X7GBugYhFnwT0yAernlo9qQK7rzXTI/APs
	8qBUoSPVLTVX8wxGFvTD8F6rBf53vLeJaJ37qvCnfBGwig46Fq6L8YwzIPlg3gXalMmoI7Hl2mI
	dx+ZrOP3Up6eI2UQX/V/3JkbOiQO8fxB5gzPLq7NLd+76+9oMy2gCIXUjrdeF6c8y5x8XBkJY6u
	1Yr72iGw==
X-Google-Smtp-Source: AGHT+IEr5KfO9g5XB5M1oZw7bGno87HZnZZWw7Q18m6dtyDaC7sCL6xNw6zqoj036IrByLM0+eD+5w==
X-Received: by 2002:a05:6402:3596:b0:63e:b49:c9c3 with SMTP id 4fb4d7f45d1cf-64077082133mr839973a12.31.1761862223219;
        Thu, 30 Oct 2025 15:10:23 -0700 (PDT)
Received: from localhost ([2a02:8071:b783:6940:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-6407b390d7dsm60738a12.10.2025.10.30.15.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 15:10:22 -0700 (PDT)
Date: Thu, 30 Oct 2025 23:10:19 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Michal Wilczynski <m.wilczynski@samsung.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, linux-pwm@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Subject: Re: [PATCH] pwm: fix Rust formatting
Message-ID: <m3shamaznoachabbsxsknzk3snp7nrkmkwqmnfibbwmdfbhgy4@3seayfxsb7kh>
References: <20251029182502.783392-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="stxqejammn4geqdw"
Content-Disposition: inline
In-Reply-To: <20251029182502.783392-1-ojeda@kernel.org>


--stxqejammn4geqdw
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] pwm: fix Rust formatting
MIME-Version: 1.0

Hello,

On Wed, Oct 29, 2025 at 07:25:02PM +0100, Miguel Ojeda wrote:
> We do our best to keep the repository `rustfmt`-clean [1], thus run the
> tool to fix the formatting issue.
>=20
> A trailing empty comment [2] is added in order to preserve the wanted
> style for imports (otherwise the tool will compact the first two items).
>=20
> Link: https://rust-for-linux.com/contributing#submit-checklist-addendum [=
1]
> Link: https://docs.kernel.org/rust/coding-guidelines.html#style-formattin=
g [2]
> Fixes: a3d5a2b8da94 ("rust: pwm: Add complete abstraction layer")
> Fixes: 121931a7b4dc ("rust: pwm: Add Kconfig and basic data structures")
> Fixes: fb3957af9ec6 ("pwm: Add Rust driver for T-HEAD TH1520 SoC")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to
https://git.kernel.org/pub/scm/linux/kernel/git/ukleinek/linux.git pwm/for-=
next
=2E

Thanks!
Uwe

--stxqejammn4geqdw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmkD4kgACgkQj4D7WH0S
/k7ZFwgArUy6vPY6bP//G90gYhm0oJvRmV9rUOHtEWSHy7Y+GEm32WlMa6z3ojWB
DHu/TuxL8wOTYetKoEyYOvVeP8RJuRB3y9PX5FUJBUKTan2TyLB6UglIsCOYmICn
KHSXiLmsiXBkCwCiNZW7v/3kFsfBbzL7oGsbGEUOuV9V53F6Eg2vSkmWVQ4TgmpA
IqUvkgohJ/HvrJcXJhy8wrCvKVtpkaTnA4rEtJPyCeGm3EJhitm1NF1VjVg1aT7U
iPgPBELbJYM+X1j9V6lmfaLGNo1wJ5ubgmXzyAnSwuaS5Tj+XOFYkhAwynjOyQS3
L3ute5H0Sj2hyzf7FHvWac/JBcO9EQ==
=IT7F
-----END PGP SIGNATURE-----

--stxqejammn4geqdw--
