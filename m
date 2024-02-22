Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3374749F
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 05:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708579087; cv=none; b=KNew64oUOHOAiYRrIPwFVq6Z6wG+s91oZi2tyeiGPifSla4vRWOsEMSZDKv4thOVH07wp6nJ2Rn8fbOObuLgmec5rXsV9TyF/UAd24vEo6NPQbF+hHP5+acNlqkR7rl/7EpkgIt/gvRYJtSjlKeuDz7ORETjcypnGo/o8PC1I68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708579087; c=relaxed/simple;
	bh=E6kxIjupRfQ6whETQdBAa7XObspVL8EosoRw1aQIIVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=snNlqTUoQMeYt9NX1Y5ScUh9ydz+3294biAkIKGD/2UQuA5EOxVF4fcu+ZGvVUlomhGiMPXUqskaIOjFmO2mtPegcne4qhySUF983BJ50VjYRE5livRBE08IOkMMt8x+kneYmGaRBC9cfNJgfB004Qt1TZZFB+VJtY4JRBoLV3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H1sd+ROx; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H1sd+ROx"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3c17ac08a38so129128b6e.1
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 21:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708579085; x=1709183885; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gwERMhLydUQbM63HHAS3nRnQy7Lq2lbonIyWMpCTEio=;
        b=H1sd+ROxn9OIMuPhqB3rQu5rrhlySCXvUYUpGtcp9fN/TRFbKn6+iQ1veARvnmaZgz
         ve0OOcJu6OpJPMqX+1rNVFYJhTGyHBsPf4Yk4Ms3f9QoDgyEaXmGj36YSeKSpSPUBXxP
         NDd4PIplrFG8gXXEEACbbcKBQ9GO4VnDQvlWzMOjbnd91lcrxpN7QhtYxl6YIB1aiGgH
         vv8bHxxd8nCT1yfUVURLNE2kBoj0gusoGr4cux6WBV2W2Po0F1iK+i8mtNoAvzzrzw8b
         K8neHm7nMxu+LnS/lNotefXK5jvRgVdvFCO4ViYDuZtuUgzo7kKwjSFttOyVesAO997V
         1Ozw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708579085; x=1709183885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gwERMhLydUQbM63HHAS3nRnQy7Lq2lbonIyWMpCTEio=;
        b=grbGeo4kU+FaOwgvSWBtY0D0URgo1euI8Z4K+KOprgctDmpaJqqqjo5D3ZuPk+vapv
         hufmHEqSC/QGPXWoj9pq3R9Q12sdrSTwl/kcVc2akMKXJQEqgHlyh2h4EzW4lpg94+Xl
         DUI3RQ9ZHXTtNjIwshskq5ZYENDssApkeVv4Z519Y3rlHh5ZUoCvay4atoyZhNuzI9lr
         gUdsrEiMhBA7HMz4hlpu9BgQDkN6z1oOzxn1q9jcbl0xI3+NCAxTisx+Dod18G0Yj14r
         xYflgi0f6BZLgL90wUdNZtQ9GmW6XjkFONHJ5aX0gnhhV6D/Zyxe25MUNXybvLZXB0zU
         qH3g==
X-Gm-Message-State: AOJu0YzBuNTBDLJ4Rwurbbn2pNnsUdYoijvEjCzYBxfqCDgz+CtJXcqF
	Pa8UX7G+spBRq8TtjL1f820doWeJqNIOtUkfWs7k66etYGHQ02K3
X-Google-Smtp-Source: AGHT+IEtdRoPxkdmxHgLnLRefjYoG5PSBEkg4YZ8kfOrcvTyfRPEb3/2j3ZwvzmyIHFUKJq6GH54Kw==
X-Received: by 2002:a05:6808:2f08:b0:3c1:7aa3:166e with SMTP id gu8-20020a0568082f0800b003c17aa3166emr1121361oib.24.1708579084639;
        Wed, 21 Feb 2024 21:18:04 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id c18-20020aa78812000000b006e1464e71f9sm7701488pfo.47.2024.02.21.21.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Feb 2024 21:18:03 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id CCF411848BD3F; Thu, 22 Feb 2024 12:18:00 +0700 (WIB)
Date: Thu, 22 Feb 2024 12:18:00 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/338] 6.6.18-rc2 review
Message-ID: <ZdbZCP-Tiv3-43L_@archie.me>
References: <20240221125953.770767246@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mGK27+qIopmdpltJ"
Content-Disposition: inline
In-Reply-To: <20240221125953.770767246@linuxfoundation.org>


--mGK27+qIopmdpltJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 21, 2024 at 02:01:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.18 release.
> There are 338 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--mGK27+qIopmdpltJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZdbZAwAKCRD2uYlJVVFO
o3GKAQDqIwME+Q56DodiHbWqEX1GMJbRA2DZLnntnw6o9SkpRgEAhKw/eq3y+H3f
gsXpYGMe/dxDlFCt4pNiQMpOwXT8CAE=
=ij2T
-----END PGP SIGNATURE-----

--mGK27+qIopmdpltJ--
