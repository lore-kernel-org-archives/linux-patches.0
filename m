Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FEF23EA88;
	Wed, 29 Oct 2025 13:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761743953; cv=none; b=SCH7g1AkOhaU1LMkv/1RB0XkcfNcdo7BmmpJH8fKyi6YnEJgPOascjDHaCINQ6K4guF+QQS13OdiDxm6N4d1iJk3+MOJ/mbFKcB81uXR7b2vKp82+X2pSjQD9MIBVPimAlp+Ff7R1L38vz/JIarHcZggDOBjLMypm81PQvUP6AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761743953; c=relaxed/simple;
	bh=MmVfJnEuOIdWAi6CXLB8Tx+mXqdT60Ww7iA3jK6DaoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ciCl7VUqWYNsBHIVqQzbj/wUaeQQCU0berq8qoXP8H0GeAZr9vGM3fybjeR16uagyW1UvEO6ZI/ps8MZi06DoFyq4NadbJByZ8P9TLRoOq8typ6OWgCPhYoD/mPC4Qmr2F5uiAHNyC6MhuakwErrSqURnlygz2rqWAp6ez9bnGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l+IMYONv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l+IMYONv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4D0C4CEF7;
	Wed, 29 Oct 2025 13:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761743950;
	bh=MmVfJnEuOIdWAi6CXLB8Tx+mXqdT60Ww7iA3jK6DaoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l+IMYONvWWyduet0+X/JquHzDVSSUDiYuQkEXJ0R1yqfZej5SnCig0FS4o4/ZFlNX
	 0LyCAlqCYoVbxtGsf4jhW82ZcFClYHVlbEnF/0p8bie4imQycGtXNlwDWR2wQRBq5O
	 9uFAJyA+dgsjyKrBfqmAGIJc0jUaj+0iBuShEzlzyIMMcMS9UTXsTQgpduPpXXWeC0
	 NM14AoLH3ZijEa6oYtv1mmeHreABTy7okeLIRggHHfnNxSBQki/7422uS/ex8E574k
	 1l7N+rBonwr/L36fkiaqJ5MnqbKMOROjK3C5/fMK7C5JQLI3yPiSfGzrdfvlaidKcG
	 4bgl1T8TQWRnQ==
Date: Wed, 29 Oct 2025 13:19:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/117] 6.12.56-rc1 review
Message-ID: <5269d6b0-06f3-4b9c-8811-7833838fb155@sirena.org.uk>
References: <20251027183453.919157109@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TH2pRTaA67F582CM"
Content-Disposition: inline
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
X-Cookie: Goes (Went) over like a lead balloon.


--TH2pRTaA67F582CM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 27, 2025 at 07:35:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.56 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--TH2pRTaA67F582CM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkCFEcACgkQJNaLcl1U
h9B0Twf+IP89R3CwpBpCvuEpjZS2UYkqvoQxtQQypF9ax772/1AM/ETJRMEhbPjR
YJ1kbG2w0M6lh1xz4YoRzVvGmM4r0xoDaNaF0pwM0XutUj8O6amfCI14S1F/ofD9
dc2OcRwRdeut8eewP1tDlS+6xBYvtxzBF8mJl6yDV1o1B4eNvhCwwqOMBP6PQ96X
RgguJ5hm5XAebmHy8L+ZdDzjC0I1e2+VIYvwnxB8ClWeGI6WO7mhgKF5ThtDtV3m
JLjhqTO7n6/xup37Dv73CKWsRiO5+JTjWntY1LDNsjAb/jhgB55+k9+hwOLiRGvO
29BnfANJMHskDEj2vUsWOU26tAZC1w==
=3YKq
-----END PGP SIGNATURE-----

--TH2pRTaA67F582CM--
