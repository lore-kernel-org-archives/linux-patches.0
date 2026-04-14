Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AAA279DAD;
	Tue, 14 Apr 2026 18:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776190628; cv=none; b=SDiyE05bxoym0olNis0pRNgW4xUwybOAvF4G4XgdgjB6tbcXNOw+N8ZXSRTQ/M7heSFNyJUoq95EblAH0zDRhQi+vWp3I/72SDKFZxSLpymlFJzjgTDjMz9DK9iTdMP5ZznAkHP4yZlGFYxQKRxPEko739DXatoWl9mK7EdP1A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776190628; c=relaxed/simple;
	bh=VMCw4WRKouFDtDFyu6q21+kbyCheMHvH5XMhshwmxU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kxeS2sph9PAOGFxAwHMg8G9kVf6XhxuLbE5iQRctthzxsmWaKvRTynXOqPpjo1Yhj7FXaaEXCeFdH4vls3VyMmDWIiUq/KI6x+O4/iRdE6KnvhZTZmL0hazGFIDqHGFWmjAovBUTBV+MSOdNrO3HA9mfyGxIGIQp3AKXkXgrnLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RiwXrqgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RiwXrqgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6891BC19425;
	Tue, 14 Apr 2026 18:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776190627;
	bh=VMCw4WRKouFDtDFyu6q21+kbyCheMHvH5XMhshwmxU4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RiwXrqgfBA6ZX/X13Ax1Y+nUOP3iIyjclcpx4IfK5aVTHSex5/8K3K/YndlXsvi8w
	 /jbpuCb5Cn3UA3U24v1hehAdyv1ITBllhWn8RrSgW1cecRVQ5m+1JGOT9KSVIrWwE6
	 kiNR94+rhyyG92+QHvgDp+/OX+0gJJJUxTjRWMLNVLxqpnrfkdSkQx6sQuXw1GuV1i
	 k47FH6OwZbebc7u4B+H5hB+7kVy3/9BFisLfrZH9SgTiXLMge7XSK7dtpSJYzCzgrJ
	 ZQioGKjMo4+dL4ltN6FqGQPIcIdL8yd8mqlvANSf2/QzmuDWn48ScJJIefXwHdlqFT
	 481jcwQRDVJ4A==
Date: Tue, 14 Apr 2026 19:17:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 00/86] 6.19.13-rc1 review
Message-ID: <11de6f1d-91b7-4c40-a050-b344b43c06a0@sirena.org.uk>
References: <20260413155731.568515178@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jG3ZaAuOZUnqcCe3"
Content-Disposition: inline
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
X-Cookie: Academicians care, that's who.


--jG3ZaAuOZUnqcCe3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 13, 2026 at 05:59:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.13 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--jG3ZaAuOZUnqcCe3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnehJwACgkQJNaLcl1U
h9Dg0gf+MMBSj054DKG2RBR81ffoG2+f/ROg4EOO12F+vZh7b9xITPUW3KKXxOJk
VspSVerJyvL8eeI0gJOUd1koj7OES5Z7h65d1olYAJKTMVVuyyidR0mGkNTGqm61
SCDW31CfyKU+Igoel/p5Wup5gv1XMSA6e+QgZszy/jaYvu+0gchvDivUOnSCnGEA
mTtyF7afkfVaWqd1yNrTLrG68hOy8PclI+v4VKILz8ut7WKnnLLCxRLphVC2Hitw
iPeEQOtMxq5M+hFHcRnf73gvAfszGD43w+LoKFBf99P9PQXKszC47P4B0+isJYDu
2kwY0YcJnsrNB3VBJAac0U/WorUVgQ==
=y3xF
-----END PGP SIGNATURE-----

--jG3ZaAuOZUnqcCe3--
