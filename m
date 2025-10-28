Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3082D2D3237;
	Tue, 28 Oct 2025 11:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761650082; cv=none; b=Carstbvpb7dVh+lEzir8lpiUJzivr9fl8KPLqU8TJ0Oq3IFPjT6guYJPLPL5BegB5IxsCI5ahayA5eYKT4k4ICYGfumqtHAHY+r3hv+jRY8JLYsCD0IVwxMjYALlbKy2f/4vFFwk6pZrdaUB8TMayI5Y4gAHiI3pLHtg2wK3e7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761650082; c=relaxed/simple;
	bh=qbNY12RM9R/yOPb++qJyjxEKBG7Wmz7YblSwu9oI/w8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pgHReZNxUIPPCs+1Pt7L4HehyL4LBW6s9E4H11lfobNGcITb0aN4aHyL1eZ3FcRg8XwCY94e3qEHvIajxl3OKhfLbxLqe8jb8G7kBVN/UFwaOJloLyBqllcmtBLdBIALL7u+FeLHl1OnsiEm6NoU5BDWXURBxyfWriaLrdyg0j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UaS2jR2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UaS2jR2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C324C4CEE7;
	Tue, 28 Oct 2025 11:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761650081;
	bh=qbNY12RM9R/yOPb++qJyjxEKBG7Wmz7YblSwu9oI/w8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UaS2jR2Jk/vuIARermmmh/ASSSZN+dCh5NfnvtvnLKf3Fz16Uy32xyMpwOGkMd/B7
	 E/046Ep4KRl3DfaUvX29dyZbHAdhs9+xzat1+p7a5VF5BU1lVgWyrifVP6yJ63QNKL
	 PeR0Tsa6eWOs9XImIcZMTlBwYsubZY18zqnk5247v5osdFh5+GFfyU5pfOuX3f9TZ9
	 oPxNrRRcv9WVMfpaRdXHCjP0+FLCipSDBIlKhJ44se/VttQ6358xzWhzCMt56h7Bsn
	 5ov496TUc/3TaQcFLMpdY0MBhRtFgi08YNpjHFSujh9y/h320l81VMPC0bED/Zc1bK
	 5P8izwq3qkSsg==
Date: Tue, 28 Oct 2025 11:14:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.17 000/184] 6.17.6-rc1 review
Message-ID: <34a468d4-fc65-4aef-8aba-3cc3441b501b@sirena.org.uk>
References: <20251027183514.934710872@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uVpYyaHvfHMU+Dch"
Content-Disposition: inline
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
X-Cookie: I smell a wumpus.


--uVpYyaHvfHMU+Dch
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 27, 2025 at 07:34:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.6 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--uVpYyaHvfHMU+Dch
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkApZoACgkQJNaLcl1U
h9B8OQf+LFMkxcBDlYqnazNf5ms9Bs78O4qh7m/y4UV5JzLXJbHMo0qQYwOvHwM9
4gpOh4PM6htEDpUY01SmJKy5Z8akwXcp76VTsPh+bZu50rhV2n36jxzVn1XceJ8I
IqMObbI0xnXeYstDweANvkVXzyMdL53NrX+qgdAB2SmoAjE1DR6hE0nyhE1mZ8Mz
P18f7kr9RcdEblY4+RDGAh9fikEt0U7FdLWzOEB68ZO2T3lxdvu0dFqrHdjQP634
EBsd491K4+AY1qiog2RzfvA7vs8GEJ+tvidu7jFA5Kdh0IVX9FIEvRSNXjYvaGNB
tNdTvQW/UZGy2F+J0V4UcUga0rS1uA==
=cRPv
-----END PGP SIGNATURE-----

--uVpYyaHvfHMU+Dch--
