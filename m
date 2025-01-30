Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC998143888;
	Thu, 30 Jan 2025 18:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738262833; cv=none; b=Rejvuwry1pzTaOTkdzSk9zhGtQHy8wfhjzCC7Guh8QYwTmwMM8nqEwVj9hjzN4vykOxZbuqmQ/+vcIIemErNtEMHVk1+AZfpSoaAq1k6xUaVn2vgQHyG8KTdh4ERJttVEmhj+qO7gfIKwpgCufOsogKkvcy3gNftQtb3fx1BXg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738262833; c=relaxed/simple;
	bh=C1nHOf5t0zUMv/Hk+SBcKgD1paGQRD2KErACyr6DYa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YYwCXSN0kdNxme0diRQEsHXTJbZrkp+UfYI7tZJWOY3PWyAbwaha3FAq5uc4eYjmqpqkuXzC7AABNuMH6ZGKu/seAP2l8z7hVpkMbM2lF05Vgu6jO+CSL6Z20wxmKFpSHq6xw6c6gEqchBpg9tcfDpziM1T8tSKmqOwWPm9JEUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SDDD57y+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SDDD57y+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB79C4CED2;
	Thu, 30 Jan 2025 18:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738262833;
	bh=C1nHOf5t0zUMv/Hk+SBcKgD1paGQRD2KErACyr6DYa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SDDD57y+w4ZHoXjQseTzy4clblHLGirKYBnOommxFDyMXd1Jzqi+Vkous2swdTCON
	 +0lf5MVkObDFGTJlsvgz+WNyBNfNEoA0j3cSLI56qK8iK4/FGq37WzbR1UI3eLZ3xh
	 maeVhtTckWDdLIs3myYTEZ9q8vr+Mw2pycPBL4DQwUUlrsnw2Ob2zqVX6XQ1Aya9ki
	 6eUUKpHX+nNj3aBxXELentNC4L/nHg+JV0kvNFdFNzEpFFeoXi8DMXhcyeRSxvunJy
	 x7yFtAVHV4+lJKTRazIp679m+OqWaqO2hC7aYNsfi8XYE9EpkDe/RSQXxQ3mlpPhPq
	 kRGBxyRSPhwWA==
Date: Thu, 30 Jan 2025 18:47:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 00/24] 5.15.178-rc1 review
Message-ID: <b88149ad-6d28-466c-b056-9f7cd7697d40@sirena.org.uk>
References: <20250130140127.295114276@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PNLyRf++LI3myU6K"
Content-Disposition: inline
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
X-Cookie: Password:


--PNLyRf++LI3myU6K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 30, 2025 at 03:01:52PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.178 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--PNLyRf++LI3myU6K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmebySoACgkQJNaLcl1U
h9Dhcgf/X3zMwcFsxHokjMeVMgUDCr8U+YVzwLqMijQsfOy5oNmu2kO49UDJpOEO
/9SMK0CT/qpFYi00Dqx0uPNPNRCvR5ITZcFgWlsLHxBM97MJwzZWX/ciZRmjKSH2
dEm1DyRiyp37IlIxsBxe1sG6y0c8vPqFRGoMlTTED6hKn/ULym3eMGMNWQWkhUOa
UuYb9RfowNorFy0uhhwFd5lJtaoXLMK8Q0Lhx/98MTcluo0N+r0artibDq5Aa0pI
RuCENcoHxxX/9RBUmbVskfn24o1tyacKwMPsnN0Qr/2NUOSGXhgZWpixqD4J5/dP
B4XRJoYn8MXbqMr/bRlNZHRfzxFmng==
=a5r4
-----END PGP SIGNATURE-----

--PNLyRf++LI3myU6K--
