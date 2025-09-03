Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1943832F775;
	Wed,  3 Sep 2025 10:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756896482; cv=none; b=isgoyhfzqGD0PI58fIaueZBOSkHCOBi7CQbrhpxB+ElmdwmT6WzslEQi8m20HVQsd35HEQ9ZWBZbdRyDCVpIz4jSYDwwo3pO0gjOGKRZh7Gzi7lADkpJ9Hk3CRQMaQJbLvJUIQG6g3PfIWxJfJOr8YEPB5PaGynXYECX6L0RKJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756896482; c=relaxed/simple;
	bh=9E8uz9hErWiGZiGJ3tOitH1ZwLeJgIIegf0gm8dvS7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AD/TMIMXy1JM5xhNXFAF18f51G6/kwKlwFLjDQG2YZEOe7dqouY3IuhnjHdVzjRbcFL35BLaXOZR7y033nhdlg8stEItXNM2+5PqOoQATfLzhBAQ+l+YoyeMcb2BgQmIYiKDDZR7aoNjlEVGhgmj6M9DYbvl4tYSibGoqQFNUk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=twW78k+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="twW78k+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05594C4CEF0;
	Wed,  3 Sep 2025 10:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756896481;
	bh=9E8uz9hErWiGZiGJ3tOitH1ZwLeJgIIegf0gm8dvS7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=twW78k+CvOy/N9EV/xc1gRtIPzLTfroZHkK6EMy7BYIggGlk4/LkYuWVBZmMgMoAK
	 akLykghNstzS4vFP84h9mMNuebn2uVX3H1SFeYs+apupInxspXhZmQFue2nO6Uq6rr
	 ZoizepwkddQtRL6rz4L9IcjmCW9vNjkK92W59qDutLD9ZKATFAcI5BPhOiDbTlgVhb
	 y0W8Z+jDW4VK8UzSIdoaOW2LZ2kXcrWDC3OJrSp4ZRcnfzTgniMdINi7aSV+DohXDI
	 Jz1ee5N/u57t8GN5Q262oEosH1BeXSnFGBJBS6Yr20YJMAur5nsc5C0xFt8SfBs6Ua
	 J2DCcyAEYRORQ==
Date: Wed, 3 Sep 2025 11:47:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.6 00/75] 6.6.104-rc1 review
Message-ID: <1a62df91-9477-4750-b29f-c44e04e58eda@sirena.org.uk>
References: <20250902131935.107897242@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2lS6W2fvcdob3vnU"
Content-Disposition: inline
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
X-Cookie: You were s'posed to laugh!


--2lS6W2fvcdob3vnU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 02, 2025 at 03:20:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.104 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--2lS6W2fvcdob3vnU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi4HNoACgkQJNaLcl1U
h9BAjQf/W3pGtBerM6E92ZAmqsWtYXaRuOrcZGDHlHQxjlfN1eHwZjVremJHTp8G
FS+nqCgtg5mohh/gNGEmJ0PAPeeoerUw/wSOtDuQ7NAGOViwiKaAmNmrvPa0/waj
iUa9DxgVJwEFY81R3sHFZdk9NkoN7jmvz16ZceK5PAouixb8Ei4MIyDPFE9oCszL
lSB2t2NAy+59F//gZu+wY36cclmfuR4+v6TMIhoPJ1cMkCDyeqtLm4fOvjlhMwYU
3Gq/j5SqHLhCQcWhQdgU3DY9MDhV/xIfkEMw0yMLM/nP+K4iuHu1tf/X7A9XJUrV
iauXWLeG5olqXf89ByePuYR2NEsjRg==
=2DlN
-----END PGP SIGNATURE-----

--2lS6W2fvcdob3vnU--
