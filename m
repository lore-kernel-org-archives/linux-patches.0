Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21901397686;
	Tue,  3 Mar 2026 19:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772566640; cv=none; b=pa3EeVTyx1KjTH3sgqQ4ynjlXl01Yxfwuob8elRxltPohtsDvmdNKA3y1FBc+TI6FSp2URS8PNTt8cqX5Zez2Mm/PpjS3rpkwGS6P6PBv0BrU6v8DTSC49sFIB5I2VTl8pv9CEwjXiAwTbxo1UGD31KETqDHVJ+UvKnDaOZ8Mjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772566640; c=relaxed/simple;
	bh=b2Ym0ZBWgfz/FbvAxbcn771+2QInOWAbl8UH7i29p0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TTSoMQxZTHByDyZVq4Xx6iwxFAkrUhxLqD6cBCUhqQEOO3oI+bCS6iOaiuglm2oIUbiBkEd6+unj3cFW3AE1UiJlW6yCaKbs+oXkUCbZ/ZsmIM574MYZnXVnQM1sKi2yYk9rcw+aNYXcRuWtF4J76ucuzcuHqKCnNGhxoKbCcBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oh23rtJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oh23rtJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6344C116C6;
	Tue,  3 Mar 2026 19:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772566639;
	bh=b2Ym0ZBWgfz/FbvAxbcn771+2QInOWAbl8UH7i29p0w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oh23rtJLM4fJwRYjDnjNcTHmtA8ZZ50PxKlv4TNHOu/4gq2jVP/qKBU2p8y6ccgGS
	 cCBJuuiBYj+JbpGH9L1XBEF6dIb19kMGNaIxO9H3jldGAh/xDy6dsht4gRyWGf8OBY
	 4pD9FuEaOiD2m0qjSMvV973zIdmR1TbrDi8MHeX470ie1E5Kdc+HazZW0Xt1Lp9GYv
	 I3b4oyy+I8OGFmFfulFQQrUHatAqr4uSDPfDJ6LXRqV+sCh0h88xQOsbrUUt8kvhau
	 b8cXtmtb8g7oAKeUIpAwVMF1Yt6hbhPBjmkcNoFyUBTWVOlFrRhFNoyb0mxBv/FW1b
	 MedS+24vSv7WQ==
Date: Tue, 3 Mar 2026 19:37:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
Message-ID: <6f65be2e-8bcb-4b81-a4d2-6352ac239c24@sirena.org.uk>
References: <20260302160943.2522184-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6n1Z8q6OpHx1meYH"
Content-Disposition: inline
In-Reply-To: <20260302160943.2522184-1-sashal@kernel.org>
X-Cookie: Use the Force, Luke.


--6n1Z8q6OpHx1meYH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 02, 2026 at 11:09:43AM -0500, Sasha Levin wrote:
>=20
> This is the start of the stable review cycle for the 6.1.165 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--6n1Z8q6OpHx1meYH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmnOGcACgkQJNaLcl1U
h9BUcQf/a59SLF3U0bIXYmafkp/ZqZ7N3Oxa9q9nF0HGfrqyfZVJAglZhW8sCPOA
W8TsSPjhfDRS/yAnpHOuBjbiR2bvWYXfmhZ96VRXCPrl+t5ymUGdoDJtS8IOmL+i
BIrSA9K3Vfq833nk80kCLsP0jmLO1mYzfc15d4ncseA25hkjqKZ5fGYsy+dTUtlt
YTEoJLwK9G6tDbakcajy74NdMsszy1a16XgpChwtqiqkv6sifoEV2Cbk9NjX6wqq
GtXQCJmEIPostYEQL8+iZ1Fivc+AzWLa1UnSK49cRo5jqPEi8Qs6F0GeQ8DtzsdG
AznYlScHnZtGyjR+nIUOF0rowB0mXw==
=B6y3
-----END PGP SIGNATURE-----

--6n1Z8q6OpHx1meYH--
