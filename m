Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1280126CE32;
	Thu, 29 Jan 2026 14:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769696030; cv=none; b=E4R4tKkMo4SzjSFAwQvdeyPBbJbGyc70rgCO0Snr0DyWqg7BKosO0jntMGk1bFZEsOJf0/jXAUxUwMuUHK9fnYNzd7D+EIWUpOMxzj5NNlQSEWc5bab/teQ1RQZr8i8SeunYsjKZ+EGZ5n9LmqYG1ZFl0k0VpIK1TBew25zcT4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769696030; c=relaxed/simple;
	bh=Hq2Vpiy0GSkZPJbZueLObr3TtGa7NiSLSIE/ZQxX+WM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KOQm6DKRL1FaZzIuWu54oGbVlN1DAqY7RWnWncrWsGq/RhttYY8opZraOcd57YSntgC8ZAXLzXnPM1aWaRxUFnDzFgL380llP1Lvcn4vDWo713eyC3sjmrZ76F2uuiFj0faVSgF+6tPy8OCmySqtmaBKh2BVMjoOnh/GU4ZFyaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j7Zb4fOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j7Zb4fOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284FBC4CEF7;
	Thu, 29 Jan 2026 14:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769696029;
	bh=Hq2Vpiy0GSkZPJbZueLObr3TtGa7NiSLSIE/ZQxX+WM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j7Zb4fOsffuJ8ishTFh6Exd49h2BPVCpKdYolqhp/BYhL9o8ud82EhumPP/zAMDZC
	 sL+QoYzARPGZ7+SjidOoyTtxlz7b6q9X9E5t4bedIkwdXATGC/y+Wt2FpN2H5ahYJQ
	 dm86KsaE4sVmleRQTTsVhGuvHEqKjmHhoSDundua1x5QJSAMmuSQPFwfrsHn7ekhe/
	 lxJQ6Qh/FBZB2eClsiV2s3xaoM6xeR6bau0JSS70my9F7HXziqN785ApeXW9pWIoM9
	 iTLQShdxg0leYpUX9P/vN/MUo+XktjTV54pb+hp8YawBn1lLnyyj5DFV5/ij+OWqc2
	 nDKcJZG39N3KQ==
Date: Thu, 29 Jan 2026 14:13:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/227] 6.18.8-rc1 review
Message-ID: <1eee350c-314c-49bb-a8d4-5336c93f4171@sirena.org.uk>
References: <20260128145344.331957407@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="b9F5Nxf2e5QGaNLS"
Content-Disposition: inline
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
X-Cookie: You have taken yourself too seriously.


--b9F5Nxf2e5QGaNLS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 28, 2026 at 04:20:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.8 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--b9F5Nxf2e5QGaNLS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAml7axYACgkQJNaLcl1U
h9A14Qf/bMKI9bDuq6QibCRW6QofOHgpH1iOaN2W4ctvby16hcIi0rwVTA8+M0Dm
76GPzJ7vEmFoZQDZ5/GFjJIZoyL9jQLCEeZr2IWonugvefmzOuXOBVQRWCpomCLt
V3y5pk4EaJRw7ApsMWDdBk/SVUpqXcI3uDculpwMkHC5duWZpqkrQAsKQU4G1k9k
7F1X2kfgbX4CX5gAfLbqtxsACMjpZkXi2pwZLdP8pPf+F8+NfMsGzPJ/WL/szXGl
B8U+AF3d1WS7+F3gDOE7OTAd+EOQ1y1U8CXYOPQnmF9Xo7NipqUgVXuT8NAY4VVy
OsPEWf9i5uHDVBk6DsF6p+kWwJD5eQ==
=E3+7
-----END PGP SIGNATURE-----

--b9F5Nxf2e5QGaNLS--
