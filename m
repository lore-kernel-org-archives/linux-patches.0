Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5570828AAEB;
	Sat, 10 Jan 2026 11:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768044505; cv=none; b=j/r4iYc/bEr9iVSHlDeCcKIkYLJBVUl/AVnzLkqDaH6W85pY6RdlTURXrmAk0Bo4XqDwWk6Drvt+BOYnatXiR0pzjR8wY5DhhONg5xDFteJuKleMMnZLzeh2qoA2LRwTeQUdT35QliWPch+NAgiuClwv/je5CqNWb7iwFVm7u2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768044505; c=relaxed/simple;
	bh=gjAHM77RzStc1lfZQMYItdzqJIxlyKzpNDnq++2T2p0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Il7o3AawlCrQFmepCQVMGrySUnWgK8BWjK9kjH4ykxJ+YRTnaDAAkd6lM4Z8Tc+51MSf6hhGAURbCgK0+Y/UTF30Zd8kqoBxaA3yKZNqr1DKCf3XZZh7SZha3AKKNwsjYyTsE+E/kUv1krZsIJkIWh0OobWnY5sput0PCor0U+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dLkLuYC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dLkLuYC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F9BC4CEF1;
	Sat, 10 Jan 2026 11:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768044505;
	bh=gjAHM77RzStc1lfZQMYItdzqJIxlyKzpNDnq++2T2p0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dLkLuYC/dCV8hW5x5n5Wek9Ldomn/hBUtQKZRUpYjasiHAOZfM6Zfcu5JAPhWrpY7
	 a/e/9QZdshxhqXtDNHyt5DTiBYmIzGzL1ovWsvRkwTQlwCIyo+Nrj8yFhZTtxmGVuy
	 Q13JP+x8PHdpLERpPJuv7PHEEq4dT1ElhwOneJ9ILVgJwLVwcG3O2YZYUS330MCddc
	 0hmmLFTVuz2EwNZQo9V++y6QyATV6uyNeM5dSp+mC68aEz9q5SDuiHPi2wp0sTlSf5
	 0/2WCpjNT4rs8d8EmLD36NpJ49KXoUe8SxFEHfQwbL0ahVgik9nR7FfVqOQ69hL0YG
	 V56J/+3qgBN2Q==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 661791AC5681; Sat, 10 Jan 2026 20:28:16 +0900 (JST)
Date: Sat, 10 Jan 2026 11:28:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 0/5] 6.18.5-rc1 review
Message-ID: <aWI30BsOMTeniGGk@sirena.co.uk>
References: <20260109111950.344681501@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zzN9G4l6rXXeEnsc"
Content-Disposition: inline
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
X-Cookie: Think big.  Pollute the Mississippi.


--zzN9G4l6rXXeEnsc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 09, 2026 at 12:44:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.5 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--zzN9G4l6rXXeEnsc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmliN88ACgkQJNaLcl1U
h9BfyAf8DjCrHbbz++82Gpt9TSZEsrd1E9DTcfZumivQ63c9yJfyVO5TYlr2KqTF
DNCyMVmRLp8mkgE7XcDgHnR1r2BpZt4e+cpGXUk3mCsqatOco3u1/LktDJElrwXv
i/BYw9w/hDLMW+OnUBPNvhKBbx+CMSbeXmDsIIqUWK4xIoi21ou6yaOz7fuHceLY
QKIcF8x7a/PVYo8m/Ksaphr+qsKYLRdZo8T+Zeau959W6+xRY3UBMOw+gqiI6YRV
qtRYrSwpwtmOb/qAotIaNgjP9BVJRXKBkoDewQrOhwVLj3RtLgqU66lyDbKXf816
L++0CrniFh0+0c+cEfOMx+gBg3MY3A==
=4d1o
-----END PGP SIGNATURE-----

--zzN9G4l6rXXeEnsc--
