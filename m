Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842B81C68D;
	Wed,  3 Jul 2024 17:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720029021; cv=none; b=X3YP/gAx0+0qV1xkGAVN/NqiZkYH5Dr27KjNLNdLpweCucD+2bxOlg7g+SJqbC6heWbqwOzkwCRlLPgU2PyVK0RzYHUqfYUqcQQaQnLekcW9AE8yeZpcrjKvXHCfBbgUFVqFOnkNpFYOwYIwrguMf8RcSbCBPIKsVCYSi9+J1Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720029021; c=relaxed/simple;
	bh=8mRAjmFxiOe0K5EjHpFbL4f1QA8Jw0ijiyZy3dZNGH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SWRX2I3AzFahLr7J26zECmxVrVZwwTapp19ukNzmt+7vkw7yuQKnpJDWOUmQbyomT4NplAHweWqwoJlS+Lz2XnAUtiIEWsw/R6eh3f1C2q6W/X0DIEYLWlZ8rpu/W25h9d+1Ig3uPzSTu+Lqwhtl2hSYOH5GitL4pbLaP9zsZfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uv10sFrO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uv10sFrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADF3C32781;
	Wed,  3 Jul 2024 17:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720029021;
	bh=8mRAjmFxiOe0K5EjHpFbL4f1QA8Jw0ijiyZy3dZNGH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uv10sFrOf4ij2W0NECFYe9hijzP9jgmfUq4WbhEpzC7UPPoiRAuIFv3pYqB0khVFm
	 fbR0EvbwX/2ZiotR/gXBUrCnDsu/jEmGVx0GO6KVv2vKBbSk1Cg8hFsUMCycpcTNdw
	 SA28Nca4WIXVZAvAld9RRxOzJNvO/54cRkpvj0KDuEMJLejsc+s5g/ddK5z6hxV/IN
	 w35a/KH8EQzbLMlVMut3Ax5OEmP7jo5vbpg4dWKbIypz5zYn+WL4/9baM9xC9GyNT3
	 4qzrZ32TwveYbyK5ku3U6gb/MY8nPPA/G9p0z89wBdfoA6Y6OdMETe378QeeNs6U+4
	 u+L/FIr4TgsXA==
Date: Wed, 3 Jul 2024 18:50:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 000/356] 5.15.162-rc1 review
Message-ID: <7cd55781-2309-4d20-98f0-0b0deeae4c3a@sirena.org.uk>
References: <20240703102913.093882413@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="r2J5PUxETwK3dTEE"
Content-Disposition: inline
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
X-Cookie: There is a fly on your nose.


--r2J5PUxETwK3dTEE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 03, 2024 at 12:35:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.162 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--r2J5PUxETwK3dTEE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaFj1UACgkQJNaLcl1U
h9DvOAf9GbjWpc/nKu9Fvhb6Rjrx/Gta7MsxIMlMKMxKBwrxcADjCh6U5XqOx/50
0mE4bK0vGKOttMynGv53t4yX/SyXphxZcm0Qq9c5nhiawr5p9BCSItWbCq6FbE60
ScbHB7B5t8M94njvh5deKtx2i/Y2s8fpVRCVGfwDTvultYlCDsac2naExE+wkGKJ
ARoFcxP4RkeKVbcpyERFV6sugCUebZeJgJCDaeqo0bRRHZZ1NaOu6tty7QGifyFz
r8d89e7f8mp1NMHgBqVz1A1LkreHrr6wMabcs8jinjTW1jq5IGl+/+uZqAsWyzsX
EuVL0tqdsKMMi4byr1MWqROtkJ7vOA==
=CVL0
-----END PGP SIGNATURE-----

--r2J5PUxETwK3dTEE--
