Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DBF1CAB1;
	Wed, 17 Jul 2024 13:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721221447; cv=none; b=NTiFoUs9Ksll9W/A8fune5S9cLcc+y1uiBeRpsRpHwXAhU58hwieOAnPrWHvE0cDfAMkiH0mNL8Xnma/CMxQWuYxNtgmcyRpErHyxdCpfTYq9iAawsvS8H0yzA+fDC428ZQJyoFUDcfgLX9hHaq0ML2NofCboNGqxS526WRlvBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721221447; c=relaxed/simple;
	bh=EfoHhC4alA4XxntMcJQyaAM8VObvxJBSY7iPEZH4uIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sLahA//dZSs54LLr4Q7svOkUsFKBaIs90EtxfancrOs3NruF8C/jLeyfY19n12k6jQy6918VDRp/+wGSGnbb0KpuedBjz9dyOLJOHXXDVdK/zWRm4fx0zZm0ctdxZgn6Zh5nIi+QQWM9vBP1MUeJEyMmIaOtKZCVO/Wvh9oddL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/vOHMVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/vOHMVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F9CC32782;
	Wed, 17 Jul 2024 13:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721221447;
	bh=EfoHhC4alA4XxntMcJQyaAM8VObvxJBSY7iPEZH4uIY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T/vOHMVXpPhqSLsxa7pB3G4AQZkv1NesJyiYYJ2ttNX0S/KERDCcST/YaGAE5PoKK
	 gyrRiugBwxN56YN3Yb3p7TG3ErVgUW/n459omHn1/oHYwY37rFbac2P5fHmm9KkLkq
	 +P+s0F+6S6JVPigyJTBgjo8TNb34eYQGK0XvGCHZFz3pmToUmrHP0EAq1NE8+3quLE
	 k8mD/8xhNzCzoKm5JkW5Q+At9NDgoTS/6QNpdLwkMZwPAj+hfxLteLaEHouOM/T4HT
	 egVzBcEZjNae1MqtpK7jLUi/dRp3hLa6btgB9q6+VTB7wybWPg+3KkcXIKQ+8VfULi
	 tLzveoWNS2CQw==
Date: Wed, 17 Jul 2024 14:04:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.9 000/142] 6.9.10-rc2 review
Message-ID: <75062431-b23d-442f-966f-8efee24ebf8c@sirena.org.uk>
References: <20240717063806.741977243@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1YDpBjWSQCMZHotk"
Content-Disposition: inline
In-Reply-To: <20240717063806.741977243@linuxfoundation.org>
X-Cookie: You should go home.


--1YDpBjWSQCMZHotk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 17, 2024 at 08:40:00AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.10 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--1YDpBjWSQCMZHotk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaXwT8ACgkQJNaLcl1U
h9AF2gf/ccanwHYzDMwyh5xIYAvI/FyN2rpCFJgRQCSuefYMccMqA9vohUgwMYvb
oyxXPrA7kV8AjGK2+HawUv3ZXPicKxI7lA7JOvBRzGSoRZroFEI3Dwhz4hyPtPnb
IDeL+CE8ZOaWeYekfW7ey83JRd5mcMkBfO7eEBPtPNad1NsqHyW61eenGUvTiZC7
MX9fyR4iaIAGU902YYJjobnZL9E7l0arHRaJkgS/GqEtAKRyuKDiE2Ky2+2th0Yr
M/0+TKI7Z3LT93HP6pv8EvB3g3UWIHTfzakzuR4ELDuQPd5+xVhA32q2cTwhoMHD
wCauy7NmWzwlBGDu7iaOVM/lpXB4+w==
=P0Xh
-----END PGP SIGNATURE-----

--1YDpBjWSQCMZHotk--
