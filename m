Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F7B33508E
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 09:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771405908; cv=none; b=RnunokCtbGNJqPaMUg8zXylxLIcWyYBCsvy79cc3+CZGeKy/hPll+kAmusmLqdPm228jf5PtBCrdO4LaCpIATZmQg0vgrYuA6ovdtSjOSH3d6FmWQP2v2rVqvJ2N3yF+NU2Q0A2JQbbXioLB8g5JBmPYWOb8KlbM9oMVMiNkgvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771405908; c=relaxed/simple;
	bh=wYZ2LADSNKiMhwnaWmnBxJbsHqmDXIbneAc4Y5vv9aM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YGEDYf/O7OecBli1I18UiOV7xcdWavTemf6qJosJt9RaoPsJaa7dnQAIj6X0kQd82w218LgZeW2RLMRrrsHE0qguJqr2/6VkG1I3xNycIPNMDVt0CjciHO3dapGcGqyS3K4tkuilIkpIJ/wwPFO3kNBZiUqKtqowFRk2cgWSgWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=cGV7XgFd; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="cGV7XgFd"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2180D10E960;
	Wed, 18 Feb 2026 10:11:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1771405898;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=UmuSZAuR0c8ULypDyoU2TEtb4Bo3z7IkFl8Cyk98ysc=;
	b=cGV7XgFddRkAeA4mJ1gFH/8GrwD1SmNlOEVDJpmMkEv56wB4c6Z+ggLjNKkW3joQj2N1h9
	WtEshoeTwvoIkBh5wMqAA7d95R2fZ8UgQpslbnIgrkdFYRyY4t/kB8CEmtxcXhXMG8ZqcQ
	LrjaeHisnnzIJ6Jnm4iomVKkqylBJwV4xByt2PYYa2dZjIrRCBkPIQGp/OwftGYNI96Aa0
	+p2rjVVW8afLGAywicRJRgGtrEGzX8Q4bLux8vm7zpY3n5i9IHVZxeGBp/HyG9H8yOKhXY
	GKIIf7llnTXFfhDEhTKTZnw0fR3YWYMWRaANDrL2ooyWJ/kOVJA2hB+HeU/0xQ==
Date: Wed, 18 Feb 2026 10:11:34 +0100
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 00/42] 6.12.74-rc1 review
Message-ID: <aZWCRpHXAZc7Q73k@duo.ucw.cz>
References: <20260217200005.998240758@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ojMRsZ9tZQwOSBMc"
Content-Disposition: inline
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--ojMRsZ9tZQwOSBMc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.74 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel
--=20
In cooperation with Nabla.

--ojMRsZ9tZQwOSBMc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaZWCRgAKCRAw5/Bqldv6
8rznAKC27WGvCYXwwkggjBrwr7KYOm6ODgCeIqBEz8gWDEL6nnNOZiWtfoBabXE=
=wwbL
-----END PGP SIGNATURE-----

--ojMRsZ9tZQwOSBMc--
