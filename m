Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16FA2E4257;
	Wed, 23 Jul 2025 11:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753269307; cv=none; b=aK7/1Y8wnIVrLxsns/hTLpby95p/l9IQwO7IiXUhNGCG+aV9A4SMH5GFr5TOG5FzKHP9Nai7hXzBlSKLOw6kb9jJWuApq8FSoU49iqTBAGaGWoM/KnKSEvaJ5/8WrnIThM9jIDqSMbpct1LOBYjz9aU3SO0DTuMe9jG2g5ziD7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753269307; c=relaxed/simple;
	bh=dKAjneFMzMHV6ADO7jAIQ7puucfCDQKrQoiKVcsttcA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mx1+Kq9IvbQHUfGUuYCAxoP8oGjPyQZmOv9VM+uvWZldxvtDe1J+qfR2FgiOMRUlo7kIPChNs5UIQm0ehHEr/3nI/UaMyxoEZjKIxHCit3VA9DrQjd0akhzHh4bRtB4Rzo8OvUuarP57YlmpSSfyC7+MWU0/1v7IQGyABoLJ/N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aAeLUYnT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aAeLUYnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A52C4CEE7;
	Wed, 23 Jul 2025 11:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753269306;
	bh=dKAjneFMzMHV6ADO7jAIQ7puucfCDQKrQoiKVcsttcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aAeLUYnT0ZRdgU8yI5+VRgRtpVtre+7vEMx6i/q2M2yMeE3E84CCPAYS58FWVI5Co
	 CS3amFoIzmeLyY7RWB9uUPoBvrhyWKo+j6QXlqZ1NcDxFJcYx7pRBZHO3mEg04jh0O
	 cW6CK33BLuz+52bSdWc6+QkOV8omQzbo1iruSVCB5S811eg6icxc14AUPof8aebcms
	 EeEPSwq6wtPzpdbHmL2wO8sLjhP7+bSXFlhaLfI+B5ym135qeddlvJpZm+3M8QMtPK
	 Y10rfF5wl+1aBEVirKG3MGSqzyEUolJK86ThuxRb7YVAzp0dfP57G8JTmYBpKFTxaf
	 P4+mgmiTuGxug==
Date: Wed, 23 Jul 2025 12:15:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 00/79] 6.1.147-rc1 review
Message-ID: <86180bd9-16b7-490c-a574-6eaded0fa232@sirena.org.uk>
References: <20250722134328.384139905@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AWXlMOCO9ZOHt7EA"
Content-Disposition: inline
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
X-Cookie: List was current at time of printing.


--AWXlMOCO9ZOHt7EA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 22, 2025 at 03:43:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.147 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--AWXlMOCO9ZOHt7EA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiAxDMACgkQJNaLcl1U
h9AF7Qf/Qt6GTXO433kUo19v/wO8sjgiy+hRFz1IEitQemMwFb41ToAIMYr5JCVj
ALqw9suJ9iQblv+Tyk3sfXPpA1leMitq8gPO4IK/VRIAhG5tPDbovzELSwdTXrTR
n9+pRTePKlC5T3HZUxiDI/y+3zbxU0QencgeDua4Xac/rAWmIsv3CZZ7Y0tfuO29
TlaKBam7ehJT89HOKLGKCO/m1e6YjhAsjgfZ5xgIJABs1TpU6ibAFXGyLXmM1mz7
TIH5TZcUKqon9ZHR2p3EDaYQTeFg9c5n18tv4nTHbQ4fOh+Rm8X3e/c3BA61T595
QPYbQbR8sJyY1de05J2Jq0VrrVG7GA==
=/EOg
-----END PGP SIGNATURE-----

--AWXlMOCO9ZOHt7EA--
