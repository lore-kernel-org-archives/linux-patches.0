Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0681A1EBFE2;
	Thu, 30 Jan 2025 17:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738259815; cv=none; b=BwhtSUOekS20kVDUoy6b80tUOuq+oG9dDvFab/eKod6xtofH2yJOs6YsJK7OiyTI1SMHQFtYD+Yc3bqMUGYaAcjwFmuasS4f1eYLGi/DEDtbnP+frj/g7kOzJAcZCodsRphoVgmzBTyO1x2F8+3muS0CBET8PFLX3qsuvUtAuyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738259815; c=relaxed/simple;
	bh=Dk3oD+0b6J+PCkTG4WPoTGs90LkDDKIjHV0xGebl3DU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UFQs4q9fldiL8tfbIfCDcZNHsPF5afvfzL+r0hRpGQYgbgMCLC5YD5TXtzEbMh1/GwELHMECce0Va7mwIIkfwHwOjjUQgJrsSkw3trHx7GapF65yidK4qeeZlm+nWQ2GlicGVBjEdwYt6+utVhLV2QRaqiTTt4qMOMtqYDtfkcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OxLd9odX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OxLd9odX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65F6C4CEE0;
	Thu, 30 Jan 2025 17:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738259813;
	bh=Dk3oD+0b6J+PCkTG4WPoTGs90LkDDKIjHV0xGebl3DU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OxLd9odX+Ervm+9tVe60csJIFIU6EJpZm7lO9nWhOLGOpqxS+Ye/l6fIudO8brL1a
	 xuufxBEv3vhhpcVqTb7+QoWU2TRAeDxtkLXewHlySI9JbduCepjA/2u+Fpjo5awfrK
	 s1WuzAooddq9kVm3LMdlnOZvjvAgmmTrQsq9fSozEIAtEMnF24Kj0gBZJXbvh2cc9a
	 kGkFpjNEqWoJA7BC5W6v2Ouu8xXex/Q/myN5r7Dn+sQPmYaIawA047UXbgY/Y+skLO
	 HaNttBipq88A0cyN3F5E9pfo6FoKBNEJMjf0nVjMzj9Dg8wDcyHTtM2X4ZYPCNzmPv
	 z9o2Bd0RLdN7g==
Date: Thu, 30 Jan 2025 17:56:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 00/43] 6.6.75-rc1 review
Message-ID: <3d9a42f7-4082-4c72-a09a-b9335dbf2e0c@sirena.org.uk>
References: <20250130133458.903274626@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oDwOdvXmL/dJe8sR"
Content-Disposition: inline
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
X-Cookie: Password:


--oDwOdvXmL/dJe8sR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 30, 2025 at 02:59:07PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.75 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--oDwOdvXmL/dJe8sR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmebvV4ACgkQJNaLcl1U
h9DRjwf/UjIeBm14O1O4gtnykhl4V90QgwrUAgzSb/4kLH+fGd/nl99yXvdWXMe/
mMdSEIlw1dyNnBidvhQCkma0Qn8GNumOhFEr20Grvk2REXV70Ua8+LE2YzUfHdbs
7f6QGGooAscar6+13TCFcxU2W2a3Rb9+d5gnruJ6vMmT4mJ5dsFQyzmsiYlT/i2k
IWHNrPllmEkfdfWvclIjCD06hqeVf9XLg4wF+L6gADTdnl/aw5psIkYjNFyO6hQ0
vpCQLqDGqqNwG+E7Sec3l8KfFrA+KGClu3ho9hGdMwxsNNQApUZlF2mKmWK8ILaa
jBG092nCzbzJnz59gw/dBmjFnFW4UA==
=r3Zr
-----END PGP SIGNATURE-----

--oDwOdvXmL/dJe8sR--
