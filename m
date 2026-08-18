Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DAF332EC8;
	Tue, 18 Aug 2026 15:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787068289; cv=none; b=W9WkVtULWgs2isXtrm7/mxwVgyyljRGje38lgHSygrQQYh6SSFn10WuoKhhLcwSKELIWmuVNNj/EG7Bv/KvFdtA0s2nYIo0obs04wVI0SuZnlVOnZGxeezqgzayEF/XCs2pEgC3wMtxsqOVayxJv41YetL4VxU1cdkuJWTsrpfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787068289; c=relaxed/simple;
	bh=Uc424Ig3xZxjpBwoQgZKsFm3kgSkPofk4vgDch+zVZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FkrRM2DH0i8Bft3fFiKlmox4T8eJNGNWGmYy1nFGdaZx5W5AnhGMNIfWNhwmrhv0pSCMnZG1w4/Ph+LaB+ESnmEFDN/EB+hkTTi2bljyUfe3gm3mmz8kRV7TJm0VTdSnWBeAnyaudo0HrfmwZhxr5wVoY2BcCVigksggJsqdHIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VKYq2dJp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VKYq2dJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC68B1F000E9;
	Tue, 18 Aug 2026 15:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787068288;
	bh=oFgje19bDU+PCeMihEc7qTV4tjvpwf92Zh/6IfL0ngI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VKYq2dJp2CD3GHD1Lb+S21TP2AOBKe4fbLNzpa9/NYxG80lRRCxnyceauxDvFFARJ
	 UKtO7W24gAv0UfdNjG/BXZx+Kvs46IT3GjEr+3rTu45O8nCNVqtrkXKhrBjAZrzUqZ
	 QZJ0CBiiDIUBkUVaIWFFNCP0xKaaPezqFv0pNVR9IojrXdsMZ254EK+UfxfWM6QBss
	 3ueGaxBPwbNU5hepT9cYCBGtwqRQGf6ishwKC1tlv3Yxs8t+aYd/yqpy1cHicOZ6Lg
	 qRivkvVhJzuFEUwwniUo+1Lsn9XAN7gDc5FYsn/YrDUtIngn57zY3shWYqTlwlkIsu
	 8Ol02rwVdkzRw==
Date: Tue, 18 Aug 2026 16:51:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/181] 6.12.104-rc1 review
Message-ID: <ba2aab20-d984-4367-81d3-d7cf3d5232c1@sirena.org.uk>
References: <20260817132535.394764707@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vphgpMmuZeebT+8+"
Content-Disposition: inline
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
X-Cookie: Smile!  You're on Candid Camera.


--vphgpMmuZeebT+8+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 17, 2026 at 03:31:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.104 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--vphgpMmuZeebT+8+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqEf3QACgkQJNaLcl1U
h9DoPwf/RpfvIXa53Ji9HALD4an9dSXmreCVlYMwnkYqKdZXkK8yeeNttPyf2eUw
0I0n7Zht7MGHTssO279EONN4nQCXr1jY4xj+VxOcS9c4bbQcy8PODeiCuXJeMMQ+
+72piQm4/XL1WS137qXxwmJC4f4/ICMFLueMuJ1y02XrimO6etiGbn8cTiME3/qL
ABqz+ozX2HBTjjdQdLXuaBg6yQFuC/uxGBiZJbRfsw892iSlx4oacDJ09/NGMS22
KHuEB5IqfpnzP74OPLIcsxliCkN8+3k8nvNLUl70plbb+7mbM9hBbgj8a2H+xQYI
4FSTw7OS+h09L45oKbrp7fbw8nvXpQ==
=Q3KG
-----END PGP SIGNATURE-----

--vphgpMmuZeebT+8+--
