Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532844C9D;
	Tue,  7 Jan 2025 12:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736253226; cv=none; b=IeZkMQ5q1/rXKlAOP2Rmo0ty0fGamL60CPsWpDq+wm8gmQwtsjZGbaitEBYksxg/OugCaxu5ECTE80sSN/6SBbvi8X+4VeL7PK1/AXR/vJj3MC3ll/7CT+mVXUwZf1nCa3PXM5h4XSf9i2sIu7ry7xZp825uDO4yaAaO+OMKR8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736253226; c=relaxed/simple;
	bh=8LIgwIc7Wv/Y2uNXYVA7x1XcLyf5X2cFylSE2+l2K2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B3eNWa8vgOi8K5GYDi+L20v2cvZ33rFOYP8/wsYOghs45tn/iKderkwafSzTgPzIspOoGqcMrlOzWC/sHOvcZKSsb0wW4Nq56j93An+/tjKJxrQJh448WGEeL/ePGtzV2XVHz2lBQGAdSuakwH5pLtBE/JY0zMjyH8v2W2LDzvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iZen45ON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iZen45ON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A22C4CED6;
	Tue,  7 Jan 2025 12:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736253225;
	bh=8LIgwIc7Wv/Y2uNXYVA7x1XcLyf5X2cFylSE2+l2K2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iZen45ONAbpes39v/alcCfIeSe5ypunZfWl0KekJnfjY+V6nmueLn6erco96j9dbz
	 WFrL5iqcfqPw3vpJevWUNGjh2iqsHvqkBBh+0WlD7Qip40k0jysrFbpFdpfhcYnlqr
	 ipLJZr3k2y4UKVTLeFyqeGL04mffqyujLgQpuour7FHMpZiZ5GZEVKM/9njx7xE0bZ
	 fpISzDDviMsf+zu9y7VA3kZxdH3/ZRn0pNiqpaT6tQ0YQo3SUWmZdP4RsZeUtjpg81
	 JZjNxecEpPEt3Kmj65N06YSfbZMS7hCmOKKURfJbtFRQ+ddImghmx1qKWKHsUmnXCb
	 i1olnKKtq9qFw==
Date: Tue, 7 Jan 2025 12:33:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 00/81] 6.1.124-rc1 review
Message-ID: <8aea5b5d-0008-41d4-b7ee-3eab3ec060c6@sirena.org.uk>
References: <20250106151129.433047073@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+xWFvHOtKx6m/rZJ"
Content-Disposition: inline
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
X-Cookie: PIZZA!!


--+xWFvHOtKx6m/rZJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 06, 2025 at 04:15:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.124 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--+xWFvHOtKx6m/rZJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmd9HyMACgkQJNaLcl1U
h9DbIAf/R0Genw9mAp6oCRivOFXuovg0XQNQ64pz87C4UGojJJt2sq1d2om+8MCY
rtFRvFgteNGnN9KoD8OmWhXEhQY3haJl9eQY+NaAqjpTl1/0nJ33TqIHhFvJIBue
RpF2hNMb98bZpOI/0zHwgttXFyS22QLvCQTkQyzgPrTcGCqcIcDps2O9X5z3qpj4
AAxJic9o26a9GYypMy8/0wNsw3IL/QwsPKuSa1sf65+/juhCPgGCgMJ2HX6TC/Sp
0f1ndASvI0uSs5lkTnNq8i7WCLKmB8KTytF8aj9K/Q7p/1l3EDKy9YYLfJiS0ObX
1VJDan4HMOaSTBk20UFYIj4s3oX9gA==
=ISQQ
-----END PGP SIGNATURE-----

--+xWFvHOtKx6m/rZJ--
