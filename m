Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5330F2206A5;
	Fri,  6 Dec 2024 18:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733508366; cv=none; b=q5sL5ulfCL4AXF4IKCvcDGOC+X6hf0BwJWpIahC4awI9zUfHgEVxsqhicMvkR0lh1mttBVg4rbT5PsPuRNgxeGGDAP08knTnUXJypc22JXukO5OEZxwrHivuJlP2SyemQ+dT3sFjSH5tghsa1LisE8M07tdxrQAx1+XYCpAJUV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733508366; c=relaxed/simple;
	bh=tDOBzYb2HXl7I0IlPve7Pi5OTtEoGEDn+/36WZdU/5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ECcSuEpGC9hUi7gJdkWF6ZKxHgXZYsHfeqwJ/bgG0ZUVTppbeziMclb/E26EgvpyudPXOGm38IVzNRe08yWO2g81Wz7O8G3GvBTy4spdCyJb2x+ofbHwcYE7SDNOZEq572Tkc2EZ3hMx297RLq6zRznIAxAbJPL3QdM31zO/LPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rkiOUZRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rkiOUZRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A990C4CED1;
	Fri,  6 Dec 2024 18:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733508365;
	bh=tDOBzYb2HXl7I0IlPve7Pi5OTtEoGEDn+/36WZdU/5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rkiOUZROLoI/GwGy/sWi/jRXc/psp/cNeKcHz9zpiBbjIHGigY6plEmKE0s94e+gj
	 5CNwQfZ8Zv7QsQakUZVooRk1WRoQN363STfiR2SOM989y4JuKmZolpL6exCEMOgHpw
	 AnBU5VGb09F3iuf+1uJ/rost4yYHkrxeXBVN0hdPGMK1i8J6fG1v9vd22QOVLp4GEM
	 IRGZryWBUlzTlAxLFE1bIWFd9PCkR9uGlpsdGE1qv/UaIF1+NFN7CtWYAYZUHaeK8O
	 +hgMzL2LqTKcrVBLRdZuKT52ra8302EQl5mjVFRzeLGbxFBcN9CiXzNdbxP/vpdhty
	 DqsbySMCEYR1w==
Date: Fri, 6 Dec 2024 18:05:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/146] 6.12.4-rc1 review
Message-ID: <f5a771f5-26be-47a2-a9df-ec901da6db1a@sirena.org.uk>
References: <20241206143527.654980698@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aEsuThH7BwHoOIz1"
Content-Disposition: inline
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
X-Cookie: Sales tax applies.


--aEsuThH7BwHoOIz1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 06, 2024 at 03:35:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.4 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--aEsuThH7BwHoOIz1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdTPQYACgkQJNaLcl1U
h9DBjwf+MqlAJIVrRny+siLkGs3mUfHlzsn5CNHVHXwJ8X0gUVkEU4TqRQZrW4es
gV8Krctq04k+8lZlrAiKghQpcbWt4T/izHhBbZY3W5c75Oa+wS1HDR+8oPwY3tPw
LvfZq76+KJ3Y+z1bwQLtk6HcEUTQ7hwNIZmbRMMyuoC6bObHAq9muaZso43Ak1V+
IfDVPhf1hWJsyftXMCHuU5mavAv+QwHSfkb9ch2VlZGbT0b3+mOScj+1x201YiF+
qf+CnnCeYOs9n/Jn5zEMvGTEounRgoGHSoDJpTR9b7Me0qfgIZM9/+72iKxiGCG/
cT4NQUaMf3TSuFvdYUtGRFH0O1QMjg==
=E8Li
-----END PGP SIGNATURE-----

--aEsuThH7BwHoOIz1--
