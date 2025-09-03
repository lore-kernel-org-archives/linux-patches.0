Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4E2258CDF;
	Wed,  3 Sep 2025 10:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756896043; cv=none; b=PgaiSa4qxZhCjTa7/A5N6UoHFbsJH31RyTWT5jpfmZHpFQ8HwwjP+6fDVmrxgfmUyRHBtvh05+yP+ZoCqSZU0GqzBO/AEar4e2vwsup7wCdXXAcsg1w57+RqjLQTSW4ZsFQevl6YTGjiyXL28AfHB2nYLi1g25RkACG9WsQYmPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756896043; c=relaxed/simple;
	bh=/GR+wgck7acbVEVzqzkAAZZ2N1TqJUrO6jmRcyYRTB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oNWaFqBlbSBHe4wr4391/iSDInTYbQknsryw/WGee/IFQ9JyKh+N8mqBQqcXYy8FMBUQLAn0K61z8eW/4XzA4TbVD28JAJBZHHYmoVkY9sStwfcewV9S8R0L1Ge5xBRK/dyYCwam+mX7USb5z2LP84DTD3024yEzaf7K+GizTug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3SVHAxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3SVHAxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C036C4CEF0;
	Wed,  3 Sep 2025 10:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756896042;
	bh=/GR+wgck7acbVEVzqzkAAZZ2N1TqJUrO6jmRcyYRTB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S3SVHAxiq6+Ko/iJlimGBpOLwMBzSmcefi1WYRoQzW0ry7BGI/oaJ1pOOkYXRtyaa
	 TK+QoDG2X9x6Fvv4ofdz+E6smjKQeIwojon4ymsqTc4lmFDXLi0yy4JxXbem+zfQor
	 yoaT/S2QJx0HFtgCBLW+e3j4fLtIGGu7NZZeqSigI9bmYEyqxXfLTQwOnQNapgYuNf
	 jj1i0ouSIus871TgQVssoGxIGcVBJDg/Ff8qPWLiAioKoqjZfIo7sK6cmf3XFq7BCH
	 vBHLr65vDTa6NWPxNikgqGqtpLf0rSNWhZKlPeY8AonKlUcOYwyCDCvTo4JFckK+nV
	 9ndijg69dWNxw==
Date: Wed, 3 Sep 2025 11:40:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.16 000/142] 6.16.5-rc1 review
Message-ID: <5e10902d-9058-4a7a-8b32-5aa3b30341ff@sirena.org.uk>
References: <20250902131948.154194162@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nnZRR2/MjgmjOnBb"
Content-Disposition: inline
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
X-Cookie: You were s'posed to laugh!


--nnZRR2/MjgmjOnBb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 02, 2025 at 03:18:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.5 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--nnZRR2/MjgmjOnBb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi4GyMACgkQJNaLcl1U
h9CpIgf/aSSqt8xsCv+deQUY4iLo4fq+w8kd/vclNt5W+bJE8tJjqDnQeQs6UpRZ
Ggn4/EoZIkF3IzA/enpua/f8t62JjRbNj3kl6J8Kh2RGPS7DMkAjEbnN+DLMG91b
RjczMXwfMQE0WO1U4BOQ6wy9UUoF6DTQ2ZXs4xo48/nx6GlsfdUDmj/+oWACviKd
EARhTtHme0btoEJuqc8nEDibtuj308VzK2ea/K2WdSUaX9jwOihZj9acRZqJBRnX
VErNSEFF2WnJKqCXkEGMuD4kFw9nNWEVKWUIER+2spLy0v+xdiLvi6wNdbLNZBDg
CP8InEPw5TGQ/WKDn4y5Pap0TUyIGg==
=juZQ
-----END PGP SIGNATURE-----

--nnZRR2/MjgmjOnBb--
