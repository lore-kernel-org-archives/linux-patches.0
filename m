Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9A413C9D9;
	Wed, 11 Sep 2024 20:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087102; cv=none; b=huwPaGQAXB60ZWEGy9LktHLcRYCsow32wBE1/HEJw34QeAbqfKko0iPhUHr7xhSqiado+PnaDXeUwVtguvFuW3ow3FvmmI6ZfGMhSRbe1VOa4mCsOdMxmWm+d2QpaUGfRqipdrD/zhUpEfLiOH3urBnzLXFSq8DQX9kBx8Ubsg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087102; c=relaxed/simple;
	bh=0CieCh/PRVWepJqHilCqHtvlIDtbUv5z8HwHfO+/tsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mEYwcA6nb48sHKOr/sWBHg2UPxxP8Md7RyZtfjYC8ZdXuW+gF1oRIOC/VZRdjZhl9WjMJIFimZzVNUeUEdlzFy8imvvhnKkdfq/imP7vE6lIX3byRMq5Mr2ce2JWH4SFhwn4i/GpTdVNPtJKqF6QtIJMyXo5XJzw6l6XC7Sb00Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gbqz0Rci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gbqz0Rci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8D2C4CEC0;
	Wed, 11 Sep 2024 20:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726087101;
	bh=0CieCh/PRVWepJqHilCqHtvlIDtbUv5z8HwHfO+/tsI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gbqz0RcieNaoo7Tu1ZHX1kW0jHrorYgjxEXRQbuDcO3B4+FQsA86o+AbP5LRPyr72
	 wDdp0y1XWKNwaEqzzeLBC+rPzTTP5mE6bOzP7uUdYF1ZFTFtWfncb3P78MEDsIOnck
	 d8gWLftA0GN0BYDanwXFHa/g4NP9vfN0/M2oYvOVcfz5N3mozcnNCcntrZ1z9F+75t
	 xddaCGmrVjnF/m4Hk+tpr8777wLQyREsxWTq/bEa5nnPxRG0mFAOBnST2I/K4ye3kO
	 on7//EFr6Yff6oUXkvrnK/zJrNFhIuW3/Rr8krZWSkKSv63wUNwIgvkPHCy3apE7vB
	 acQeBtDri7d4w==
Date: Wed, 11 Sep 2024 21:38:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 000/185] 5.10.226-rc2 review
Message-ID: <5ce1c1b0-1227-4b48-bada-64257d708e34@sirena.org.uk>
References: <20240911130529.320360981@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="I1qTWh/ncxJMQZNx"
Content-Disposition: inline
In-Reply-To: <20240911130529.320360981@linuxfoundation.org>
X-Cookie: No Canadian coins.


--I1qTWh/ncxJMQZNx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 11, 2024 at 03:07:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.226 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--I1qTWh/ncxJMQZNx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbh/7YACgkQJNaLcl1U
h9A33Af/TYinfZryKB41DlMoMzTjBufhjyzRvjOuvLq5bhYkJFN2OUbxzb9JtSTQ
TWszLV4dAYELQR0X2+QIvpTam25XFQSxMlA0BYruhf3QHjiBpjoUktPddaqOjH7J
XuPfdc8F5Z3Cr2Cqfp3Z+ZO31svLlLNNOxeeGS6II1RkW7byCXC1Dw5yQ7GxtRKL
j9nIOXshENzSwDV3IUsn081jMGhZBbFbg4fLCiwsVXP0dsOO9f5TP+6VXfNRbelx
xvVwyk3qMZ91ToEKd2ZSMkbTaiqncWI8K/oQb7HX+3zNnnV3VnSSiRSxAckTKJBu
aw5OfOQ1LpOgVWiOSqlcMBJyN3BiXQ==
=iicD
-----END PGP SIGNATURE-----

--I1qTWh/ncxJMQZNx--
