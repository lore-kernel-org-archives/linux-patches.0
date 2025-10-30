Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028A131A812
	for <patches@lists.linux.dev>; Thu, 30 Oct 2025 22:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761862027; cv=none; b=hwrp0f9hOh6mYJXNYwkiEcdqLSPRKi61wM9YFEU2MgtvIsRAYf3WOmwwGJWHmfSpoBzqAM/+Ipga8p/qa+QJC/Lzl2k+vy9TUj2PY2jN6lRVUuSEKr7srhlZFMCL1uT5LF/M+Gr1qcQz4ZohNgxmwCQZM3OIG0OUyUYoaNqHgeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761862027; c=relaxed/simple;
	bh=cM5UgoO7go2rE7T8BZEbNJTCGD0wetmJNdz4fRUhSBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p/sVVHjLllxautILtyO4BK6lQlzVKfRXpk6rY73kBRqRaMXM+B/u9t+kiwD1V09URoqkgS8MLMxAyMctmmBsSvee6ZzlRyKXXpR4ryDMhJozmjrg8YsBoAdwFNDsGZpRYCxWhremqeq0dVauMOX2ybyVMU0BVwk9sQP34gxCCBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=s+0yPT00; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="s+0yPT00"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b70406feed3so226646466b.3
        for <patches@lists.linux.dev>; Thu, 30 Oct 2025 15:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1761862021; x=1762466821; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R7VDAtmUsZqMlwI/PTPaPA8FAzUrtYhiM6kTYyXudhE=;
        b=s+0yPT009v6FOOKnWmDN5uFBQRcOyrIfNW8Li8btunqQwvaGCxDDsurVPMJFaENBuv
         BZmZ/GbSj3QuYD4/9qcZCUhNwy6USjfF+YkxW4FSXrhB94TUYtiHMmMaFni/h7/rnNcd
         m2IAHM9vOnK6EBIHmUUNF2W2MedIMdlO+qQiWxg6RlO+bQC+fdfDHDpmmRTcbHhVG8cn
         +MBtgrhsnmwjHSMUGG5b1H+FMMW9iuSTQciWRZ0dNB3iOEEICkZQn9ABDcNDs39vnVPp
         EG89pVCcyIR1wMbTM/ZgiEwZMkEJPKfAOPvefGSENaggGrPGCIRyQ5cq3c0bVjepLDEF
         mBvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761862021; x=1762466821;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R7VDAtmUsZqMlwI/PTPaPA8FAzUrtYhiM6kTYyXudhE=;
        b=RX0TCkT1d41H2AkI4oOFh3/jdFipdlD1HADQy09v8I4JiXvUo2GRmaBdpWcJV2cFKc
         9RuWsMcvI/M5Mjxy+VoYQbzai5uKHgyUUqdd8FnuMacvL8jC6IsKkXHuc/5S7nTxtA6d
         H96RoEdy0NMOVKkryPL3AMGo389nnMmbZfH4GTgtJX07DTlFacO4o7bABNwgNfISEHX1
         zg4L2++28XiACkgX+Vorb4ZDZ1PwFeGxjZvdXm0v0qriTVUKdCYmvLCOBwyP6dVsUCqx
         FLfiUSWccbmhDFiyQieRralVSCUM3S6jwOmNfNq+DZAKFaVO+DZIOV4XIuIE2R3+nhPA
         va/g==
X-Forwarded-Encrypted: i=1; AJvYcCXl5NR2K1vdT0hVGsBaCopfWz/ckBTvt7ABDF8uPENzzAfnti3iNDaKt8L81u4WQTviVb3iy+ux@lists.linux.dev
X-Gm-Message-State: AOJu0YzV+Y/rIlOleExDQqeP2kmObPCtCvsf58yHjOdk2FyKh3IBkULC
	1IfWa1gKAwPb9CCEcVeZ2swf7/6zTrUKg2PaYDoaWCQutalQBddk8mQ1mb+e9E9qAvk=
X-Gm-Gg: ASbGncut4KN28+5HMOk9LedwgZpDxa8qPmEjG4gH+Is+ySLv+cxLzMONy6D9om2Wff/
	tHLWDF02KSIVHkwgNUMTRYLyYEh2y3EAq+6wZRguyaXlbg4tk8PScYGS210qUa4U+ZalTaRRhQz
	yp+bN8IAWXt9Ws8bcBcXGkGeR5j23K6Hrh3lokFv7v5KRk30cRnGDLOrUakW2h7mmgaSEArMkPp
	Y4ubGJbZINA75MZFFpwk2oMwUeGYaFrgsLtF3mVyxUXTzObyzUKQQ8+07Yz6EFSu3YHyPuewhbq
	3eH5SFKuwxgeO4Y+NxWQcMKkKPdNBsIHl8Z7CaJXM42D7x3a8eeSyOKcWnz6/vpAaRDOImykURu
	LF9/KBhq9UPTXTV9CSw1ldcic8H1303hrWIMM0GmAHBmIzUeF8YBgEgTqVDVdOVdDnZWTz3AZ6c
	fxdN+vvw==
X-Google-Smtp-Source: AGHT+IH9eCQJTs+bhi7CI6SroWMhn/3mdEfGkB2E7DEbuVLquzoetKoSMx33oHVxd2NAWHRemdfmPQ==
X-Received: by 2002:a17:907:8693:b0:b6d:2f32:844a with SMTP id a640c23a62f3a-b7070188912mr115508366b.22.1761862020683;
        Thu, 30 Oct 2025 15:07:00 -0700 (PDT)
Received: from localhost ([2a02:8071:b783:6940:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-6407b427fb9sm41824a12.23.2025.10.30.15.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 15:06:59 -0700 (PDT)
Date: Thu, 30 Oct 2025 23:06:55 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Michal Wilczynski <m.wilczynski@samsung.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, linux-pwm@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Subject: Re: [PATCH] pwm: fix broken intra-doc link
Message-ID: <7e4oucjmnxaike4jnjmsdvwnc6hif4koww7al6cxeymccb3rn6@5blaoo4k5pfh>
References: <20251029181940.780629-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hug6oxx7fhrrhezp"
Content-Disposition: inline
In-Reply-To: <20251029181940.780629-1-ojeda@kernel.org>


--hug6oxx7fhrrhezp
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] pwm: fix broken intra-doc link
MIME-Version: 1.0

Hello Miguel,

On Wed, Oct 29, 2025 at 07:19:40PM +0100, Miguel Ojeda wrote:
> `rustdoc` reports a broken intra-doc link:
>=20
>     error: unresolved link to `Devres::register`
>        --> rust/kernel/pwm.rs:722:11
>         |
>     722 | /// via [`Devres::register`]. This ties the lifetime of the PWM=
 chip registration
>         |           ^^^^^^^^^^^^^^^^ no item named `Devres` in scope
>         |
>         =3D note: `-D rustdoc::broken-intra-doc-links` implied by `-D war=
nings`
>         =3D help: to override `-D warnings` add `#[allow(rustdoc::broken_=
intra_doc_links)]`
>=20
> Thus fix it.
>=20
> Fixes: a3d5a2b8da94 ("rust: pwm: Add complete abstraction layer")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to
https://git.kernel.org/pub/scm/linux/kernel/git/ukleinek/linux.git pwm/for-=
next
=2E

I don't consider my tree stable, so if you still want to send review
tags, I'll add them.

Best regards and thanks,
Uwe

--hug6oxx7fhrrhezp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmkD4X0ACgkQj4D7WH0S
/k4eFQf/ZjsorP2D+YGhhk8euCCluVFbuQEubtS0Z3Je2gFlkvzRE0D18hod09MU
TwAYRoSCd2wfs2EEB2EKgUBhXF8pJS/19uXB6SaM8pMR3FSgd2QSB5ciZXB3qtH3
edtBZAhbnVOXdT4bNRC/qUXXtXKFjZdJXTDkuREy8pA5NX6r5qRdOcgodUGXyCpA
Jv4uUNhZnAlUsRgcHmg6bFmPFSlW2rEEpfEH5dTViBFp3SsdkLROP85EL+n0fX5W
Mc3ETvq6/pbBddJH6IJ/lHj8BGryCPxlp88e4LGC0FD+X3utOfjZWt2IR0A3k4Ds
+9crP6VCHVDWLH9EFTgTAUFRpjOy0A==
=SgWV
-----END PGP SIGNATURE-----

--hug6oxx7fhrrhezp--
