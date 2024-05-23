Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A828328B6;
	Thu, 23 May 2024 18:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716488442; cv=none; b=f28cKLmSbAfnoYu0+odQCd8+xNNbXNVGCJMT5Uuoy7xMAKQ/p9Bf3hiNmjPDD7D9BG+CoUV9RHgvRO7eBuAuXA3XW9kI4Ip6b5js+nXtzW+W8khjv3fMedEd7SM+o1DbkkJTjqtDsvq9ReC+es1Pkkv/M+m52cRr7KSvoQotHbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716488442; c=relaxed/simple;
	bh=yAoytzSnxSRY1TWnLtcefslq/J38cIV6iaI4Lz+5Opw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TkN1l1PSBxwcD1pATJsUWE+Up68cD0bLkelblRarR4ln9K2ISiD1+JEozowbkwJFTeeKmTYHFUBrnAAhq3CyGRn2tBTm81eEyRl+Pvvhu1GUnZcdn5flSGJJwC53d/m55girO4f+tjKgtNwmbsTlEEFQITe9m6TkAr9+vlRDVyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zy2I72kY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zy2I72kY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496B6C2BD10;
	Thu, 23 May 2024 18:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716488441;
	bh=yAoytzSnxSRY1TWnLtcefslq/J38cIV6iaI4Lz+5Opw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zy2I72kYQjoUNfG5Ae51T/JjnA2Sh42qtoeMOfgentP1xzphb1hAXFYdPW937Ybou
	 tk1tnkYX+xQdER9QYN+ZiiPCLf5Kiz3yRb+sATbZ/2Z+At7BtjpBZuQIlvntSLtGmw
	 a7YTCiS60fNhhwx+CwJZG74mQuI5C12swQbEg87ZjqS7q/xYWG50ChpXn0BLY+cBeY
	 Vpm0gJhjwTtCzUPEOL5IkAu+IZBR1zLktb60yFq3FXeQ9QQJluS4Q5X34MwFnkN5YG
	 Qxf+cS5GF2v1HX8VwMpKnkT4Ay8NCTw1lIX1zWMQEw1SzIM69naFb6mqcx11R6EsWb
	 rcRUGpsEzGlpw==
Date: Thu, 23 May 2024 19:20:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
Message-ID: <81cf0a48-04f2-4d5a-8106-a4267141f45a@sirena.org.uk>
References: <20240523130327.956341021@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TFymFfCTEs9OGmFX"
Content-Disposition: inline
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
X-Cookie: You auto buy now.


--TFymFfCTEs9OGmFX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2024 at 03:12:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.160 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--TFymFfCTEs9OGmFX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZPiPIACgkQJNaLcl1U
h9APOgf9Hi0jJaqLWgZKjbrLvYmagl6xsio6nG3QKvLFG6JSBtfjxnlD0dQMZ9vH
w/+xPGsX7WNN/u9UvFHmPhq1gCeORMhLWBq3XXmtB2L3kbJ/Idgw1t7tGpQzy8Jl
G2+U47hu8PGywnx9uT2H+SiGYGC39pO8WR4NowKVA56xv4szlJplpD+jsO9IKFKS
9Ya76COGwLUVIYzIJHLqWNTce0kZHC/EVMZKmKHL6o5ISgTjVPQw4vb9REO41TYD
peCktbke9AnCcViNmhiCBz6XHNV05c9Fmyzn+2G7CnM8bogKu9SnaIrschBcmlBu
X8KUUvw5v/917LfNZfXJ+qeRSvLDEA==
=NtsD
-----END PGP SIGNATURE-----

--TFymFfCTEs9OGmFX--
