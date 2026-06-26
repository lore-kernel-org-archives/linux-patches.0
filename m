Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A9F3F6610;
	Fri, 26 Jun 2026 13:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782480430; cv=none; b=ShnCjsCIgjft1lWfsY6ihlx4Kvr6SphvXbBv8CpBb3+daO6yFhbmozVZmxtzjv1KI0mw0CBiwiHYbza7z2WPNC7FyAkDoaA81cz3qg0u8kzt70+TgWYRg9/1E+L8/KhYK1MaluUoOrov5z0pIKWBgAuRriPddtV3R/NXilEZVKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782480430; c=relaxed/simple;
	bh=ArHm9gCwmJ3kGh2riTesYtLivEt1VqnJ4mJHDW/iaPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q1pTqBlB66CkPhm2SoMaxsxnVQ5yJ+vrSg8dUyz3hH7+bLKD/XTmBGnQUVMCn5E/gaRtwIwgwe3a5MiGTqLNMMUrDqQMJYMFoa7g/GRV36WT+bwGcLSGM+FClmnzgtHRueeZ2WC0P5+ROsPuxGjfTAHwyjvqmno91Ye8YoCMZyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WvTm4tyn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WvTm4tyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DDA1F00A3A;
	Fri, 26 Jun 2026 13:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782480427;
	bh=84l6LhSsdq+m+63CWLlmgKdSCmNBK0k0rmGZAgwBjoc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WvTm4tynnvW5vIWDzIsRIKYFqfCn02TImwcAjnmbg+4+LiPrRPWja6judkkuMyMcc
	 9QK00F4qhUKTockD43SBZyLGHSrNvq4uYtNy8arM74MArc6A2wyu8n2xiDmKuGPSZZ
	 k7Dy+euS0QLD7mylCJok7VaQN9ZqnbCJHdjTYmIKgPhDVgSXxBIwJsCjnH79IceZYq
	 MsnU/QoGQq7KHrqzOpyplFNWdw5oWoqagWYYSm3yzxFkzQUyTa+wL5CGenFrVqmNGe
	 mvJlFcg/tbFxB86vwzqKpFhKkqLJdVukAQtSIcEbQXeWX0H+6XnGqU/fdBeBR1CPAN
	 45aS59lUkXi+A==
Date: Fri, 26 Jun 2026 14:27:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 00/60] 6.18.37-rc1 review
Message-ID: <f5afd75b-0665-4eca-ac21-f309a5cc7070@sirena.org.uk>
References: <20260625125645.554579168@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6RFxW+SZwle6fOY3"
Content-Disposition: inline
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
X-Cookie: A company is known by the men it keeps.


--6RFxW+SZwle6fOY3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 25, 2026 at 02:02:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.37 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--6RFxW+SZwle6fOY3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmo+fiQACgkQJNaLcl1U
h9Dm0wf/eY0BnQffJK3WWlhYnqaIEkrX8sAE+PVBf+j7SRUJ1uZ+RPwbdPyXyzpq
/VjgNLXak74VRgxxl2YfTdEygFnxTBPFJn8pqF82gcv5FqQJZkd2Ag/WP/nUFlhH
2AWASn0geJRqss5cH+LzdKrhYLgKbgj4qBDrDrecxVdLtjliK/HbbW+rLeIlxwBy
zHwN76gLoQg4BIjrVBys2kTrXUDEvjBuKG29YEztc1KipXKYn53TumS3x/vfrv96
CtOVSxDVFCRLfZr7/7omeP9Q5ofX+VNu3F4yE3UH2BMSlfgq1c9i6945oc6wJJQw
3HV0QNO+oWLj7R6OakixdIOzTTe9Ow==
=Tr07
-----END PGP SIGNATURE-----

--6RFxW+SZwle6fOY3--
