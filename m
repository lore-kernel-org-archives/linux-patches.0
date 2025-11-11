Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDA420FA81;
	Tue, 11 Nov 2025 18:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762885278; cv=none; b=EVQ51bTtMlQLIamAUAULs6/uNMDLzz+9WFpZHMJSRcup/5wJgHhQjy9aNw1hNuxJGcCDUdxOXlcI33RfNh/OeHCsu4z90jZcIvOvWsSVUk6il94HYWnbLVFtHq7u6Jku4BSJmsTy0u5OhiGc+2klyGmlk575cjN6eWyedvw8oUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762885278; c=relaxed/simple;
	bh=e92g2AtYfV2iwp3wd5R+SkeTrcB37wAq+V40qAhUEIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bV61Lig3pvZksGEsX4UZj+F0DKcLKOTHtNBmQyocKoBSYCmqRFnJSSZ5Jlk8n1h/5c01nURmesIzxdHqk4OTgONOaD3cPH2HKFVlCMxoZ5n62bcxd9Ez2SHm6NJCnA98pvrPPa+d1Y1sGd9fmGKnwn0ujbYgudAxt+x1SwKC6Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EUJ655jk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUJ655jk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A89C4CEF5;
	Tue, 11 Nov 2025 18:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762885277;
	bh=e92g2AtYfV2iwp3wd5R+SkeTrcB37wAq+V40qAhUEIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EUJ655jkzg/gztoYJ/fm6hXVUP6jV2aiZrMF+TN+MrHpwzWGp7f79LSiQI/DujsyB
	 t7zeftuzBceajphtcLmJGBnH5qYvO9fwVzcY0PkL6UMT8ZhI8HDz5Gx4+asQl1WmNM
	 NnyIEU6tpYYb+nEkgdwA//9L7+cz0bcX5tiNZ5l51jHc1X1HajL7/vLBYyFfuU8fOw
	 N0dhd/y/VWy4vPzDHWtwad6CgAu3k8XoSoIGD7olI8DUAmzexIB5xmbNlD4nWWRG9N
	 f+6Qw3EuTNxaNDtpusd2Vohp8C6BGTphYFXegqv2NSeQO3acg4/8mQH8jV6u0pj4r2
	 SEvflFWctdGyg==
Date: Tue, 11 Nov 2025 18:21:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/562] 6.12.58-rc2 review
Message-ID: <aRN-mrcc-r2BM6SQ@finisterre.sirena.org.uk>
References: <20251111012348.571643096@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MrqEl9d5FXRAs9XX"
Content-Disposition: inline
In-Reply-To: <20251111012348.571643096@linuxfoundation.org>
X-Cookie: You dialed 5483.


--MrqEl9d5FXRAs9XX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 11, 2025 at 10:24:49AM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.58 release.
> There are 562 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--MrqEl9d5FXRAs9XX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkTfpkACgkQJNaLcl1U
h9DlEQgAhDVLA8f10hiyMTsxQFwRdbMqMv0DBMgiioIZwlHBMK31f9cM9XhwfmPG
RdFcsV6o3OmqJ1ABfGLZILaX9dsFcVaGsn0gfijYmn2OxbBcM+7y4AjsZA4T1RT0
wkgtNlJORblDnSv8jc5Mpt29qEq5hTjhwep6KuoYJKfMCiCTM5eyshWnyzlcLyrD
seog7K6+PtJl6mARY1YqYr53kcpEZw60OgcpJswbeIafdRIva6KElC6u/fnUIMTi
o+5/67G2LeydDlnizbfeTAxkchbtXleI5VPmFb9cAdSSFPhDqYoeXyBTm7f2uiNu
x1C4l13ZiOKyvvrsiM4uguByUQltmw==
=Kbzq
-----END PGP SIGNATURE-----

--MrqEl9d5FXRAs9XX--
