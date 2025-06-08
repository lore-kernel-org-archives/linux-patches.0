Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B511EBA14;
	Sun,  8 Jun 2025 22:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749421428; cv=none; b=i5AStNqb4PGM1iBMDQ5r2AHpaLy5YGFpdpArF6ZcNKHE27WWP1O2dehjnXR8nS3lTR0eIe/Y14dPX79FfTY/qkWAb6hcCsb6iNqQEPH39azvS+AGFdspwSWZjHCCDpUMruHOubIJdxjWjp38lKoa4nYKw/Ek8ZP05fnaFk+WII4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749421428; c=relaxed/simple;
	bh=pWb5bwbb1La5J1UCA2Oz5AMuxd2I0wX1XnOBbqjDnfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HDvHvJW6h/qiczs1M0U0DW0HZOlZ1ISHVUmSMxDrwuH6PiIsXDUnwt58mTcba3AUAysGVvw0qF9wo66T9l2ao6YnBI6n6JI1/M54o0Gspsly4RNfPwrPXCJpVW0+cteu4YKmjXFW3PaN44lXBFOBzwkTJTD+qftO32LdKz0LK5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CCOpihMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CCOpihMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75FBC4CEEE;
	Sun,  8 Jun 2025 22:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749421428;
	bh=pWb5bwbb1La5J1UCA2Oz5AMuxd2I0wX1XnOBbqjDnfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CCOpihMo1qxyc7FAIvfKSlBGPl+6xImD6JxOB1QIKn/UnjiWdSjAM/upc9Mqv4Jxl
	 6v9WwBw256xmMpXwNzWtDW/Gp4B/Trz+ibgU7H4n5c7eOymzpM/N9pZjUnP8lWBdlu
	 eF+k6kkmfbwAJk74J+Unnqs6mhBv75jLIJPfJ7HflbqcFY1hH8r5l4gGrO5/dHOqg2
	 AqL6Bg50j2qmJ6HZ14byKzbQdTyd3K92Xb5ykB8GnBSsw84Ue7ierkLqpITmRD/ExM
	 sW+MsdDVFEhjOdqY/NjsvBAnxPerzskx+us+/RDrxICRz8nPEUqi7U8HTe0TqtGQQY
	 bIBr/0W4n6Vtg==
Date: Sun, 8 Jun 2025 23:23:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 00/24] 6.12.33-rc1 review
Message-ID: <2d266477-5b60-41e4-8229-35ecc7ffbbfc@sirena.org.uk>
References: <20250607100717.910797456@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mf1P1B/aplUCzSYX"
Content-Disposition: inline
In-Reply-To: <20250607100717.910797456@linuxfoundation.org>
X-Cookie: The eyes of taxes are upon you.


--mf1P1B/aplUCzSYX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 07, 2025 at 12:07:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.33 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Mon, 09 Jun 2025 10:07:05 +0000.
> Anything received after that time might be too late.

Tested-by: Mark Brown <broonie@kernel.org>

It does seem a little ambitious to send these out on a Saturday for
review by 10am UTC on a Monday...

--mf1P1B/aplUCzSYX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhGDW0ACgkQJNaLcl1U
h9Bliwf/aX1a1rbIrll8Ejlyunz7lb+iUADq+HfIUGDgrl4+wWGRMtWsQ2jxxyuT
a7lXr0VhVkpBL06D3Wdqnt0VwN0LQU3nE0td6+Vwl3j83K0A7S436L948qgvcQiR
l1XEz8ZTttEv0675qNdWos7509//yz2IL3wt1LuOTOXpB9AyOW59dcz4KYE7Rfs6
ppjfPFjiBJYsF+uSiNSs212hBr1rOK2lP7xDDNpCmPmwuUomgLY5ri+4XumYewjf
9JbIgxifXOsd/AQU1agfyr/2lglvRGoXoP87BjcrT6b/Ex/qdZDli2dXJSKPHXy2
mDPiYBcckIW+Poi7oDCwfqwzLxzr7Q==
=Lr7x
-----END PGP SIGNATURE-----

--mf1P1B/aplUCzSYX--
