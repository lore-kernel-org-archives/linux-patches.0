Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E07829AB1A;
	Wed, 18 Feb 2026 12:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771416011; cv=none; b=c0Pih4CKlObvUnt7F4fmcjjyzBfkEwGQ1hFf8QQsiAwVf2YmTHdb9JkJ2yBwAuqcAqz1egXd+f063Cjw95/YZ7CHBE1BWgR0jXJ1pI8fk3CUKXgQcp3YYBXiXuazC1BRD5BzJV3dcerd2xHHgwNYVzfkEquyUXelaBh7AjzftKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771416011; c=relaxed/simple;
	bh=XtlTEx7IOh+d19u0et4y7FAFzdNgxN+tZWO4OfA4eQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PxUVlvKIXiHJAIfyGaxbDJzAuoNIivi4QxNcu8uoIU5d1seXpk/xWpgJfPoJzhHC3UCBYfx7Kk+K/lA79mIx8rqJKgxQX0Rxh/LYVdkq07BEUXGRby9DRWfL/wN8aSfhWeUKCfA0L18DOXOJD/QfCVfMytbaEqSstj5DreR4L+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DT1b6n4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DT1b6n4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0844C19421;
	Wed, 18 Feb 2026 12:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771416010;
	bh=XtlTEx7IOh+d19u0et4y7FAFzdNgxN+tZWO4OfA4eQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DT1b6n4EihV3z6qThM5ygfkx9uYaMLbbXBtLed9ILCyp4LJbPx5NFTIk7BV2i5Sny
	 TNFqpDmV63wTP0sBb8GER3r1ZfVBqAV4pAiss1QZcD+eZqIVkYenXE1n+rSqTVq9/Q
	 Nr0gFJlUQOyB+IHP0o8Ydj0/0Nr1/8Sb4vDGN1SsLmixUuEwZMu79p6I14AwhhCpTJ
	 O3gUgNYKsL/Ew26FDILZzHVVCtJ3Th0WLWA0kPUutslkOLNtdR5JSa6/dmd+HuDUDn
	 5MFRlSFCIN2TciUGZQibOkKTzWSN8hYSBIuCUTWfI1SK8CSEXhh7qbOyCO29SH7CUC
	 JthhBvNbrBHuA==
Date: Wed, 18 Feb 2026 12:00:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 00/64] 6.1.164-rc1 review
Message-ID: <5de99313-fff4-448b-9dd9-0eb8ebb250a0@sirena.org.uk>
References: <20260217200007.505931165@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bayqd03W2SK5UHTL"
Content-Disposition: inline
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
X-Cookie: They just buzzed and buzzed...buzzed.


--bayqd03W2SK5UHTL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 17, 2026 at 09:30:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--bayqd03W2SK5UHTL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmVqcMACgkQJNaLcl1U
h9AM2Af/TkCfBUQYGW0I79UlHw0UPHGszHB/BBIto3EsxCZwMTtJEYxZwNuo2Sp/
c+Q3ul3jySSn8uJfH8puewNEZhwtD117rBwHUz7Qjo7oAvdHCH8u4RFwtSKVaMR1
ezFA9hmg3qAAldasq0WbXSXXXLfRXTPsoTIsbI6iulrhOaPhvg2kyckpXZ3WQUQU
mD5de+sK5RATS5UjCUEnuDLlv2keuoCRANjIM8/BOZ1Ga1DKaCVTwpXgHJ1H/f5D
VeWTWV5CEmay80UWnaljTszMkXXjGu33C9Bh6GoAfWRfMxEOpnSQHCc0h5FlNqr7
LITCp4p0Ak7JznQwOTALTcMjlFbYCA==
=xBKb
-----END PGP SIGNATURE-----

--bayqd03W2SK5UHTL--
