Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ED41BD9D3
	for <patches@lists.linux.dev>; Thu, 28 Nov 2024 17:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732816295; cv=none; b=INItF75Fx614+WmLTMp7Vw2UCafnzaRwG72y/IMGSzy7BY8jzb/y/ADBi9MRhOJOvzZmZ9UP+6WBj6vunTBtQAZ/7r80JYIVcywt8goAVf25xtp2jvpj9k9enj+Q4uc6RejwTyinAX5hCanoLTbvuPfGWWBTQZHl+/R0kzBLjcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732816295; c=relaxed/simple;
	bh=AFRub4DNWpHkWdxarW8hKPsXLvbIIfGQiZn/tpAUjkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BV+R/uv7NJ79fHAMSBbIZ2vKkZwnZFRcsuHhiZ6g46JibTjDz9gv2JSnxIb3K2ozClCCjItDpj17m0EjA5vSSWlkvHvc0pyzw49LLxDd2dPIR+bElcJU9Z2/5JNZUwwvncp98dh6GgNQmtvVSMIJWF3mEMVXkU6XPN8HapL9/Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 940BA1C00D9; Thu, 28 Nov 2024 18:51:25 +0100 (CET)
Date: Thu, 28 Nov 2024 18:51:25 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, hch@lst.de
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hagar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/110] 5.10.229-rc1 review
Message-ID: <Z0itnUnUNEfKNDgK@duo.ucw.cz>
References: <20241106120303.135636370@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+LGfhgS9ok2Olh9I"
Content-Disposition: inline
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>


--+LGfhgS9ok2Olh9I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.229 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


> Christoph Hellwig <hch@lst.de>
>     mm: add remap_pfn_range_notrack

This describes i915 horrors that need the function, but we don't seem
to have i915 horrors in 5.10, and I don't see
remap_pfn_range_notrack() used.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--+LGfhgS9ok2Olh9I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ0itnQAKCRAw5/Bqldv6
8qaPAJ0d89kcMwnDPjmOafVWVHJPnmTKvgCgjVgyc/xLHqCKLY9jCAbmKdOLGVo=
=V850
-----END PGP SIGNATURE-----

--+LGfhgS9ok2Olh9I--
