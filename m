Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF62274FD1;
	Thu, 14 May 2026 01:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778722922; cv=none; b=R7SrdlfOUuY2/yPDwADpcGlj1aS9bjAyS6BNSu5/JjCpt4WFyIPdETM9xuPl4/EyUiJJ30YmmEUXPzh0qR6TfqtwSKp8g6yN+0TQ7CXxvU4YFrGqLQico/r+zgWSSFZMwzifTf8inVsiUNfInDAUD2s4MDfD6wPj2idS908paFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778722922; c=relaxed/simple;
	bh=z3RkUrNFA8q/xJGsuqQX1soDolJAmGOn1Lcnat5Y16A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cPlNlWsCA4rjQwvbBpIaYdUGSk2ZwkfvIdTz6QqPOcEHZ30yqZ28uRwiqZC7MCngpUlb2SJbS65JmX16jLJ1IFV/oh2fRm7E/iQX5FQZirov8TzE9dm4xu1SS5nx3HOwp9MpyYyAZNmR48syEhutZoUonWOZ/6I1bfiPFAreLOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cq27VkBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cq27VkBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9F0C19425;
	Thu, 14 May 2026 01:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778722922;
	bh=z3RkUrNFA8q/xJGsuqQX1soDolJAmGOn1Lcnat5Y16A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cq27VkBCsZ4pIUSdzQEmIjYvSzqTGG4hRyi0Y1jk5pHO4h6xFiXV96FQh3d+5in9t
	 An6gBExYL0HnCk2fp1MeLC+21ppqw0/1UAGyoK+dS9lQnbtnKJCGQb3gSJieqyuBoo
	 XQk73aUoikS5VNT3B2T+xAddnWYPY7bBGPXSnysfb2Z8bP6osXl6XULBa5UKpMyVJm
	 0/jPJwMoX89BJLym8kBj+F50axGsADfz8gWiur6TbI49YGrCzROXnA/i+xr5Rwe6KK
	 KQ66wy8MHinx/tROPpqKjDKDNapEyqylZFK3kEviOGPFE3sKsFZ/9tVhd5dhLL0wlv
	 q6ONUH1qjpN2g==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 8AF451AC58CE; Thu, 14 May 2026 02:42:00 +0100 (BST)
Date: Thu, 14 May 2026 10:42:00 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/268] 6.18.30-rc2 review
Message-ID: <agUoaPPjm3_EFc58@sirena.co.uk>
References: <20260513153744.746440810@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XKdRSNYmLGEZsB2/"
Content-Disposition: inline
In-Reply-To: <20260513153744.746440810@linuxfoundation.org>
X-Cookie: Truckers welcome.


--XKdRSNYmLGEZsB2/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 13, 2026 at 06:17:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.30 release.
> There are 268 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--XKdRSNYmLGEZsB2/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoFKGcACgkQJNaLcl1U
h9Ci5Af/bjmubSmSGyRfYl+fY1ahEVeWR3dzNIU44Y9fI7W2zENBrlkqjbG27wco
WaXD7Wqzo39gaQINydjjAfOJrzxNkQyWP0YjTP3PGyGZF1hXvdNUkl0+OL4wgU+A
98WGwpW0GmNHDyMYGYhKohyZFmaapdoVMQCy2iVzYzl/Kdn013g+0fA/TlgZjtE+
6zbKPEQ2sEHqvh9nGH0L2y8HDyweO8JsBkLi+krrradENFaCqxqUlENCEsbNseDn
4rrz46eMomctCad70zRPWpADLGHNLIfcv8i/Mli52socrjRNC2fi2hNFlRHtUIym
TnWYxs02ibFmuKLrrWTHkj2KAOB6dw==
=5LDP
-----END PGP SIGNATURE-----

--XKdRSNYmLGEZsB2/--
