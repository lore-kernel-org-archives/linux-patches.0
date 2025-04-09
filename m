Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF0625634;
	Wed,  9 Apr 2025 22:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744237482; cv=none; b=g3ac8D5ZOm/ZFjNv72F/rSy9wUsWGpDLvgXFEzN6TN6hLnCvN90ko9+V6xC172aTekYTwbFHzzpK0QkVjZE6Hkr9Q+vNmiHaFtTiDkqjfDnRS2A/WJBJ2E8nu47SuJnk9a6OxH9DJJG72tWYBTk3KxNRJCPmzt2m3MrNLKKUuHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744237482; c=relaxed/simple;
	bh=ilWu5tFZEgxc67uSHENETQEIxwi7Hb0jmw09SgHfHE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RDVnPJ8ROhIsTOssSm15IqeFNLtcKvcbouFRcXiEUsv4UWb0dZF8Qc+0zDAi9clLsAX6vJA6gIMe9Rc5D49zfcM49nCyWFtCFvMuWXUhgrusmKJhRWl+0I/3hsp3xk/ILjfX5BQE8e1RXksN0ZQj8NTz/+5vzprsGTM4MwetU2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bj+5U4ZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bj+5U4ZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EF1C4CEE2;
	Wed,  9 Apr 2025 22:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744237479;
	bh=ilWu5tFZEgxc67uSHENETQEIxwi7Hb0jmw09SgHfHE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bj+5U4ZEWPVPk+lVL5gqamLCi0XLmGkIaEol/zKzZ3kmUpOmBttgcdbh2T398Iko5
	 hBdec1GpIIyoQr7kXdO8LEMYhY/DsLXhwaJcZBnUqKLJVPqND4je9Y2udwKIqCRpLA
	 yMs4THHtY3JSAFuigTCRUmdKC36JXBxHYc5MiaVa0WFuj9dIrGr/4G5niNqsu5Gud0
	 ImYz2M5mWY9iZvkD3UKwBKd43MoT4nXNr/VHMCUBbwZnQvAqcPzuyLwxJS1NZQD9TN
	 +HE52KDT2Z3gOiopLHj+1/tRidj0Q8X3e1SprUFORvHIteGVZ2jDfOXsB22q0rYL+x
	 ZQY7AvniCMhTQ==
Date: Wed, 9 Apr 2025 23:24:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 000/281] 5.15.180-rc2 review
Message-ID: <2cb6df15-c4b4-441b-ba94-f4f5d34098d3@sirena.org.uk>
References: <20250409115832.538646489@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eHpJO/m3Yehu6ufz"
Content-Disposition: inline
In-Reply-To: <20250409115832.538646489@linuxfoundation.org>
X-Cookie: Words must be weighed, not counted.


--eHpJO/m3Yehu6ufz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 09, 2025 at 02:02:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.180 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--eHpJO/m3Yehu6ufz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmf286AACgkQJNaLcl1U
h9BPHAf+IOK6S97I/g41KlBxA6sBDsY+sie13lVSyQTm/Y+Mnkb9sfjohIMGujyI
VEd8uF6rf7YZNYZAbAfXjSZPyalX/fut3wPGbQVhnc6SixbNBZh12yeVsU+U/ikK
I0LEJYKamxs9Cw4XPS2EOPPLB7o6HyYITIjyXSgUxxqLGdi6GJkjrh2cxTXA5Oqp
ZQUZJty9K0mwSsUJz80Fat6N7ThIihgknSUBgjYLrTTIsiQFFPY6LHecI8+ZZCos
inAOVFmDqNSvRMy2Yj2CMwgTyxkcXiY//XAmD6KnZPjQPZA4iqISHPGynkdn7cGu
AIIYokXVMGAGw49mqBbGMS8omTB9Fg==
=W6Sv
-----END PGP SIGNATURE-----

--eHpJO/m3Yehu6ufz--
