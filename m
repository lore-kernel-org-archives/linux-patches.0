Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3CD8F48;
	Sat, 10 Jan 2026 20:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768076314; cv=none; b=YfMMPhWQ01kLEgJnXrM8tsO0v5H6DuXRGPBNEM7ysbRRv2bCTaE/XHISrsVBFs2Zoq0a9cFxatdbmzvwHizNPkU5BxfwtCJmupFSFYje40MPgiGfgl24hvmLcx/OVqGx5YNhClZXPgwnKXqhZeDF9pjA7UkCfYJd53zDkfXwXWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768076314; c=relaxed/simple;
	bh=NV1eDSeJxHpDlVlanZftNaOhOEgpT/nDHEy7cIYXX3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UFY2N2e1DJREfPtnd8/UO63EAOrxANogqh7FGJZ8O1cLnQzxovGJj4zNkGkdc+dC6Df7xV2iruqaU9zQe0TF/RAcDmeQuVuhFX3esrzUkNOgvjTR2jqgHJJPam0t7sgWYJ8tCDK+UthhBmJ6GqqZcwAL1NQiKSKhjMERT4Jf6l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lIAyRK5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lIAyRK5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147D7C4CEF1;
	Sat, 10 Jan 2026 20:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768076314;
	bh=NV1eDSeJxHpDlVlanZftNaOhOEgpT/nDHEy7cIYXX3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lIAyRK5zQ18RHEFSMZSHF/kbIL+ZaYsj7+8ofLSL+L8XE8v0HB2L0BLLb+18GAJIR
	 UiaxC4Lf3R/4z/rt2RkSfiNbku2I1pshFEaTL+CcXysRuaqEC+RPvETz5k4tTU+0oL
	 Y2F20UN7qXx6cpbhcmgvI5TgzUf1r2Ggi1x2y+qXHskPIXAraA40mFBaS72QLtLa6x
	 HnoO+4MQHZ6PTPniUrUMMwc+jVaE5EeoW1k+oXzOSZBctwZmBO9GiYSk1LFWU85jSD
	 gFTcOJNi+NsYLLUhtJXDYqGkvQ04T7l1wZHxxw3notd3SZNxSPjMFjiRFxKFcDtFsg
	 lniZVr2BV7qNA==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 067761AC5681; Sun, 11 Jan 2026 05:18:23 +0900 (JST)
Date: Sat, 10 Jan 2026 20:18:23 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/633] 6.1.160-rc2 review
Message-ID: <aWK0Dxan6J6P_Ugq@sirena.co.uk>
References: <20260110135319.581406700@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fCWK9AbJaaMXIEFA"
Content-Disposition: inline
In-Reply-To: <20260110135319.581406700@linuxfoundation.org>
X-Cookie: Think big.  Pollute the Mississippi.


--fCWK9AbJaaMXIEFA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 10, 2026 at 05:27:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.160 release.
> There are 633 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--fCWK9AbJaaMXIEFA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlitAsACgkQJNaLcl1U
h9CUbwf/WiIXzpHCt4nkb+ifBlh7/cRLnDVOK8Vsatxy0NIKNb1THWqsvZFmY+EJ
aWu9/neOKj3lZcSqfh26pVC42meB6mrOUAEx6rwA7BblSCT/GtDP6+CPPoIw5AgI
3CGsXlutMvQb+hkDcfDKnS2cjQRJSlopi4XWqq97MCQ1FVaIPGH4b+cCQSwp4VSX
zuU0FomsDdu2iZj+JeOyVIpwzB+BxERIRb8ZtR6vcls572YXXdGpX2lpnlntice1
IiAIsXGsHKw0qEe6dfOb6FzKf1NIeXcbDyemMWty+ctFuBYwovsfCNACtzHg4em4
lyWSnSqEc/VvBi0967eFjGbDrF+paA==
=gE0y
-----END PGP SIGNATURE-----

--fCWK9AbJaaMXIEFA--
