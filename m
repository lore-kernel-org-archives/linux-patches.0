Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A45723182D;
	Thu, 14 May 2026 01:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778721597; cv=none; b=DCejkbkzithvCGnGCNd++YQQSSAEy/nhq6iqf6ZBEXNQCsuBWdOjSkd5/uJS9H/Qg6s/B+/qMU8mHGmp9tPFVj2cRQNS7QW96FWn8UkPNG20UwkV5cFRjBYJdkV3xnqBF//6cFAWcH9C5cJbkBbvRFzAI1RE9Xr91rJMl2sLQ6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778721597; c=relaxed/simple;
	bh=T4sM7o01oyjdhgMoprS5/ATS4XPXZpkmBI8sJucYDcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HuJYYy8bSDsiIQ1JrQPgWjVrDo4yWJUIA4ipb4LCVA6Z0RvFWLjwiqmD9O5Cg9rK2zgUd0XHh9RXlnxH3YGSEwgmFVpKA26CGCc0XuWL8feaZwDpkL3kWgax2c/Mgob7rJPgrY+b9KjSrQv5vyYQHcB+ZpEq8TN23PMnF7IyRl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eqj7mc0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eqj7mc0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7844AC19425;
	Thu, 14 May 2026 01:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778721597;
	bh=T4sM7o01oyjdhgMoprS5/ATS4XPXZpkmBI8sJucYDcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Eqj7mc0w2W+2Po6AMCbDIOl7+Fv6w0OixZaRYwLPj7zzNHU0iPjyQW1OlljBNg2ID
	 YPAQsQa0uLyXgKihWgGZjm4utavsTMz+bCQexKS59XB50Gfdp0y9ifugIyCBG1jXgZ
	 RM45ro0+Kn7mF1AwBI7pbz41bcXOrOfqvmtt+WOAGM2ioUOBipMQlsSfdrta3jYqrG
	 29XWAtlSfzZXWgoqHuW/rI6fW2CLLATPeB+nVgQ08u2NdXXzd1BOvzrPELBKxj8cpl
	 W47R4tohSNbH48DvH+HcmNhkpbaKr7u+sFwOLruICWoWqPhib5ziWe/mTbL3NPKN3c
	 n8MvJnEdCAmCQ==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 34EF11AC58CE; Thu, 14 May 2026 02:19:52 +0100 (BST)
Date: Thu, 14 May 2026 10:19:52 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.0 000/305] 7.0.7-rc2 review
Message-ID: <agUjOL_tlgmOD070@sirena.co.uk>
References: <20260513153754.934923793@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FOkr7KFF9VDeahgV"
Content-Disposition: inline
In-Reply-To: <20260513153754.934923793@linuxfoundation.org>
X-Cookie: Truckers welcome.


--FOkr7KFF9VDeahgV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 13, 2026 at 06:17:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.7 release.
> There are 305 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--FOkr7KFF9VDeahgV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoFIzcACgkQJNaLcl1U
h9C1Egf8DeVDNbbTZm/IGklmEXWoc+Los41o4L5KFJCsthqyx/yuZ1MkujT1wUkQ
/AcIi41HBzp3EMiGcMV0N1/UH+35wuKz4MZNms7/+d1hDjora3UPYtH8oTry/kYb
vMmHznhC4OD8WFWke/LURfCvbUweEFg7Zj2aqRFv2+TwUbScbCHtV0/tX5M531ko
jP4oTB1zbRedA7LRGHo7vvZQbKRpMkBkVi9Dl4BsK06ysKQO574rfcvbHodQTVy9
iB8L5U7LnwcsV3d0gIF3iNaSHkR5bE4FC+uVv6OoLu6RTFKrkxR6VGwiu9HKuewJ
EeFa1VC9SSp3wWaT4jYYIW15PBp3ig==
=J5Qc
-----END PGP SIGNATURE-----

--FOkr7KFF9VDeahgV--
