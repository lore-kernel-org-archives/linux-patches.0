Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4841F1F5858;
	Thu,  5 Feb 2026 21:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770325909; cv=none; b=lcEyu1+vnbva9dVgbBn930DQwZaEMQoQtJnRRUa7G38x58Nytsy3zgYdLONj/+tAitCTDMigDnEtszkucbZTJKk9cKViEeZqPqqRBSvG9PveNWVh0vgy4LugVIARNw6GGveyLnNNq/iSIm8KxZ6vrXcECeD9tf+mXIJnA/4Gkvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770325909; c=relaxed/simple;
	bh=Nh2RHTu7UMAO4Pk5aFN9sYMQZCXfshgSgUKAOYS0t2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k3Wta6bNHgy2Mm1KprEdeAyGksIsLsnXkh4V7beQ5sUaa69tF0QH6xKKPujvQcgf7eFGugdU7CVTGTvQcAyoPw3AJk0fSzYnOQmxWLk3HAQK3rJ67HNhQBJ9juNF4zeOPdxuTzYQnH/oSeHzJ/NruhGOliHAgW1d4OLuD6aa9yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1iB7d7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1iB7d7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F1DC4CEF7;
	Thu,  5 Feb 2026 21:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770325908;
	bh=Nh2RHTu7UMAO4Pk5aFN9sYMQZCXfshgSgUKAOYS0t2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d1iB7d7my+zJyJVabj2KKQMmBrCW9mzbmJx7nk5qYHfGmlaJ9CwlbGFuMeweDq1KU
	 V+b8pASYYJARa+X6bSHNSlSPOvvueSPWuox3UCX1hCZed+VpCocmVt1AOjBsk101QC
	 nuf+WoS++2Fexw8iWd4z6JedAlVOxZmhL1wvppxEA1GBPPecwKsFGMJ/tsLkn/iaRV
	 mAvWpieiqSTofnmxrSDKGFKnUcfBbP5LhDR/V67SkYuJKIIMd8Qc07m4X8DdG5Yjox
	 d6XR6WioJoPa4TivyVRLYNB/wNoubb1BZ/qiWd6NnuIh0zPHLQn3LqHGQTORjHp0D2
	 a/6NDFQ+x/mPw==
Date: Thu, 5 Feb 2026 21:11:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/160] 5.10.249-rc2 review
Message-ID: <b78f5e2a-7de1-4e19-822f-921a7e2251a5@sirena.org.uk>
References: <20260205143430.733102763@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RW7mH4S5HPXe7DvV"
Content-Disposition: inline
In-Reply-To: <20260205143430.733102763@linuxfoundation.org>
X-Cookie: Non-sequiturs make me eat lampshades.


--RW7mH4S5HPXe7DvV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 05, 2026 at 03:44:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.249 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--RW7mH4S5HPXe7DvV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmFB40ACgkQJNaLcl1U
h9Cxbgf7Bpr/nndo/iKL59mjzj8OzYOYM1K+LEXNbPcmgkULu3DmtAfz8cGuOhxP
DX2a7AIHLvIE6SubmE3ESsWpnvLEvYVKSNPCpQh8s5YdakXcFW+bHrwaYsh7jHsZ
jlcnD5PT+fprB4VKQhTMV68hnf2056g4Tg4U5EFqNg7wuTxUXNklq4duHAxqrj3d
4tDnmf92xJAnn4ekc7ZfICcAFsEs5cjW5HQNLQtTd9Gnb7DNK6J817nl6rdzZyq1
79jujnKDwMS+vvVtL1THZHDFQux0HmMoYFNwsETqreYA6RGUEPtXvAhIVUtXJcrH
w7BEypRWAzKtyWrYOtamuFr0zP09mA==
=ZoS6
-----END PGP SIGNATURE-----

--RW7mH4S5HPXe7DvV--
