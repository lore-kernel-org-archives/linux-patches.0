Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F203DC4A0;
	Wed, 11 Mar 2026 12:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773231414; cv=none; b=KD8a42Pp3i4VuHb5kM1dmvlroqIDcL7Zv6qRme+ISeDkCoqLaP77OtCkhuFsByR4gEHGywW3Me8JR5e9Cm9uwqf8iUSXJ7BS8cukqOa9OySK0n3jSmt+5d/DqpXcIqAr5AZ77I9IjOUJPAw2EhT2ecbUnPRzD0zs9OiCYqetgOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773231414; c=relaxed/simple;
	bh=SmXYTZmw9uD18AmTBIXtt5N4lKV4LJ7gNrLpcpneXVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DiRdICSfttoWekWSMcrTwTwrFI13+KXnqMNHUKkiuBEJJMSt1P41F8M8ndp255h0F2vryAB8xIjYBccV9d4xpiJTF6XP0PvB8IGiXrq1zQk+hG3kinfKAHI0/yfLolwKnO5PUX8wMu2yMyDczXrMp4fVorHuj4dhRB59O6R+sBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BpMjDCH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BpMjDCH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B199C2BC9E;
	Wed, 11 Mar 2026 12:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773231414;
	bh=SmXYTZmw9uD18AmTBIXtt5N4lKV4LJ7gNrLpcpneXVA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BpMjDCH3xUvq0m57S+xaOUNGIa/WVSNe8ablEir/ODL9YqMC4ugqtwYCxvj2uXEDt
	 kJ4a+IZdQSxxjoiRE/SiotkRrNWu2miEn2++hOCjBW7sC9tOu9G4cqFfOgrmTYA3ic
	 lzUp1J5ML/KQU2o22b75sb9dxECvnwu/S2v4MWR5XemkD3GagOlyUiHaKEBXxGkOm1
	 IU3RnFoeKod9SkjBtM/4YFEXSehSFn/nEI5LxDTdBjUMt3TkW9FXqb7NNM/Erp4tqh
	 iiqomvKJtbhgEsmQ3gwr/GS7y4GzY+8WLT/9bFhltkeQt/15ckfPiakyWza6FQTGBQ
	 jiIFALrmj+/NA==
Date: Wed, 11 Mar 2026 12:16:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/314] 6.18.17-rc1 review
Message-ID: <9262b75a-6b9a-49a9-9145-9fdb3535a765@sirena.org.uk>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9lQIC4N3CwTxbioq"
Content-Disposition: inline
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
X-Cookie: When all else fails, EAT!!!


--9lQIC4N3CwTxbioq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 10, 2026 at 07:19:29AM -0400, Sasha Levin wrote:

> This is the start of the stable review cycle for the 6.18.17 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--9lQIC4N3CwTxbioq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmxXS8ACgkQJNaLcl1U
h9BEWgf+JhjenWWEaj4IvInHoAjLuhCD8Ymhzpu9onZ6ViskMhuufY+4MudsRNEg
SqzOclKV49+I1KX5EhwBzCHVEJu109Euz27FunSCY0itE3dhW9k0PYS7Er9gqdq/
r14FDdO1RLmdW7ijhxLTC9QkTiIjTI5QNpf1+buY5PpSHVZNcTpoap4YiTBmJcaj
DXDrZWsTwufr+E2s8E76f4MtqOcSKdH6sZQFyPVEPmqsBzNVPw7DxpC08AQ8ztiw
bwLfyw2LWzz4IV8+B8yGu/ZyCo/m0+ldCHXKVuzQZfoe4Pkfw+UPe+pTNP86xmYu
6/hYAqdtgGrXxV2cb1BMjnSx+srpZw==
=eira
-----END PGP SIGNATURE-----

--9lQIC4N3CwTxbioq--
