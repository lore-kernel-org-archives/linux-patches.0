Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9691E0DFE;
	Sat, 11 Oct 2025 10:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760179872; cv=none; b=M9BLVTruU5Lgs5zTPi7wiCoZKKIpm1UoO5eZvn5rNcbVWt5jY07PLgyZ6czIeSdrit8hA80U3ZIi3vN+CkEdANqgt3D0Dd6ICU7d5tWzkbfTnlaUo/iTcqydXr34LEDPTWIBQ/Q9Jz2tvqZd0Uj2GzYMTB3cVRnKlt82yadMZ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760179872; c=relaxed/simple;
	bh=dH/CE1JCJeeInHurIyT8g5JfPFP/te4/rK+4SlLWiZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EyycXHIDfUJDHxL3fTeY4oenBlLEDTHuecw0/CW4offuzaAuiIFJKaOVSVCvdwMyT7K8KB/Ne6CKJxgyv+YolS4vsSL+H1a6KNrWjAEDiIYnlArp8GFsiP55xJIXGye+JMTGsiOF876epUwj6eHbN8HcEeNfW8pVKjl2sbFFTqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=spGNO+ai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="spGNO+ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7D6C4CEF4;
	Sat, 11 Oct 2025 10:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760179871;
	bh=dH/CE1JCJeeInHurIyT8g5JfPFP/te4/rK+4SlLWiZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=spGNO+aiHo1wgFIJVpm4LgueJQTytgQpMP7CJLOo12PuR5J9X0OO+wcQabmTqYJcX
	 fnN3I9H03Y8BMKtZl/vxcLhH1vNeKkQ2pLLoVxHWpxAaNoYIch8yvTRoBea64aOe0H
	 yRYR4H/sCK3in5xlAS/FXFAYeMqqCrnKJ5nmov/yCS3r8qEsjiXoO3IL7NM4+saUJD
	 wQExxhMNv4y/mCTHtRtTNTzaN2BtE75lJF5UmOQxxsTACNlgLzrAF7kS6jxHjGqKPV
	 um0HjQpVqQaSoufw3yHHvynAPBdij6LvJc+LfC5BsO45rJpa70hDSumJIM3GawBPE3
	 /nEi2j1oCx7aw==
Date: Sat, 11 Oct 2025 11:51:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.16 00/41] 6.16.12-rc1 review
Message-ID: <aOo2nDYi6xV2d1kG@finisterre.sirena.org.uk>
References: <20251010131333.420766773@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KD0xSQXRFE5bDqJL"
Content-Disposition: inline
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
X-Cookie: If in doubt, mumble.


--KD0xSQXRFE5bDqJL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 10, 2025 at 03:15:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.12 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kerenl.org>

> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.

Late on a Friday with a deadline on Sunday isn't the idea way to get
tetsing...

--KD0xSQXRFE5bDqJL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjqNpwACgkQJNaLcl1U
h9BEEgf+N/zjX0WzacI4Rr1s+MXvKFmCkYGfS6QcA2cU2l8h/ihkjYrB8e14XVHR
OVMwX+NRnAuZwJcNsa3zpJoXtKEUc/IxFzZ0svgLYyor90UPHOMk7ZZ+ZTlvI1IU
j0EKrKMVYYmDfRm3e9+Emprkxa1CeTFVodZjBlIP7ELNp/pHLjHcN4vJbgfZSzfZ
evdeqSK+zQdwxzYX+llavc1ItvaiYQYleBpQr66TtsJimrnq6Ipdh/uD2ugePQ+5
zJRuJQT7w1rzqhNl62sPWj81ANr9JWc5QJ7cKgHuoRl44U50a8bp26Us4IP0G5d/
KMoj0P9haZcH+/EVndUeqCBImmcflA==
=2Glt
-----END PGP SIGNATURE-----

--KD0xSQXRFE5bDqJL--
