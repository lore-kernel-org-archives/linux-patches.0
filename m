Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5352EFD9B;
	Sun,  1 Mar 2026 12:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772367068; cv=none; b=cJqpEzU8s39BZ0tIryW99JDSsbGDBL6L4yIwBk3qJDWx3RTroPuL4aDpGDfd5rHh+ImfURKrv809WiraHJcwpZOOrjr7IFI9CPnyDlXrT5kgq6BJvAT3Gn88AyTaIF/qsqh8lKLZ5CdPEl7ksxCW7FQ3mWsgouW5gF6IfI7Ju5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772367068; c=relaxed/simple;
	bh=V0BZvPGOue47VwghMA6cgQ0amv/2FuZYzv1oeHWj6ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eCxYrajZH2sLUDj5VAy3AvskIVTIl2JNA6fxFQxEefk+H+KMSpArX7Bnjuwo4BN+Bf4y7wTt4gQqngth9Bl8E8STbLAs5t4Qr6JP/UhUwNJzoNknCYTLEaMiW6o0r6MX4sXaCqWSeRh2AfxMgbR8KoxmB0Exu2Q6RRVIeQCr1J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GryP8xSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GryP8xSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6990AC116C6;
	Sun,  1 Mar 2026 12:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772367067;
	bh=V0BZvPGOue47VwghMA6cgQ0amv/2FuZYzv1oeHWj6ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GryP8xSptu0zXj/ES+gFNT551BQlo/TG32nzcNCZPcX4W4Hu9k9IQ4N2OkufNAks4
	 fih2c3d0DN0G8ipXN+JgczP+4mcny0JFiU9JEoyY955TtDRfG32pniQApyN60kxvfG
	 qu3xaYQ0JE2AoBwr/6dAVXvJEaw5yZXZfuSXrKXDkNHrthjtB0Sfnsc/AH2Ianjy60
	 kFJmkcrV8SalKYz+kYeivicxX+nnEmWTjMOjn3K9K4fWNGRGhgeexNAcrBhSCH7a5X
	 X2T89PCITjzyAHERoDfs2vIhYU3e1Q99JlcO0AUVrlLmljAbB5nwebc+PkZQ8Td7+g
	 2Ebvj15Mi+CJw==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 34DF11AC58DB; Sun, 01 Mar 2026 12:11:04 +0000 (GMT)
Date: Sun, 1 Mar 2026 12:11:04 +0000
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
Subject: Re: [PATCH 5.15 000/164] 5.15.202-rc1 review
Message-ID: <aaQs2EeOipjI6g9y@sirena.co.uk>
References: <20260228181458.1600528-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iWfyzNFDF/2K9AJ2"
Content-Disposition: inline
In-Reply-To: <20260228181458.1600528-1-sashal@kernel.org>
X-Cookie: Think big.  Pollute the Mississippi.


--iWfyzNFDF/2K9AJ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 28, 2026 at 01:14:58PM -0500, Sasha Levin wrote:

> This is the start of the stable review cycle for the 5.15.202 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--iWfyzNFDF/2K9AJ2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmkLNcACgkQJNaLcl1U
h9Cwxgf/feRu8t89wQyxJgg9xKuMld6mf7KMRbrJvcH7MC3f0p/QGuoB/YQ7NJhW
m4GU0MiWtJxPWUn6ZizgqjGlWMYHB1SgeOZ+ym25mFoDrvKk8YPCRDdj2CbSEPEa
xC1bx2XTySf65o43Rs+w4t7oau3mskNICGQdBq4qbMia1JMHKMc8jeID+XCj0I2u
83m5ApSTEt7uM+6Q9MrW0FzjlNORRcyQvDNpZ7dNVijyXDF5HRBdS+K3B8xE2dT0
dwAnCMe/Z9N2SUpI7005s0mOSRa1+dvf4tATfPb8+TnZFV17Gam0fzn9FFEkweeR
M19m8u1pWACjWoix6UUHGfJUiDsMBw==
=2PvH
-----END PGP SIGNATURE-----

--iWfyzNFDF/2K9AJ2--
