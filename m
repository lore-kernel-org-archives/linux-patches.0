Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7431624F9;
	Fri,  7 Feb 2025 19:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738957041; cv=none; b=jQ3YxH/cbvYxPO2ez5rpIFWXHN56oLDymVSie1JhrY7sLy8qd1QBx4V9iOZsuebkJvWNPw8pARqen5cCLcRDeSx/ZJg290BZO+0WTK4maQ7R5id/AmBNCvFI2/5L3a+AzEz5oKWGNbRGHL9fvVy0vjxYOCjXPDaAN92GE0asWZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738957041; c=relaxed/simple;
	bh=H0jPLakvq5T5ncd1FzN8FTKf+fnTLAzFIyBBux4YSHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jWijyJNjwOsSY6J9ULUgBdKuK1HTOWbEVhXFTGzx+a3QgTm4FRsH4nQOUR9AuotG3h9ahnLehvuxrMiG2miEpJK0/CXcv0U/xtWYiixICbd9be3qgF1X+dYAjVuRbJ00BJSaXI+IHccMbCDlzOAJwsEnFOmnYV2iAV6d5qxuB4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hE4YOp2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hE4YOp2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2963C4CED1;
	Fri,  7 Feb 2025 19:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738957040;
	bh=H0jPLakvq5T5ncd1FzN8FTKf+fnTLAzFIyBBux4YSHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hE4YOp2DZlQVpOsin+B0g1pNF4q/zWKgHm1KuOolo1tiIDVv1LGPzNlovCfjV1oUC
	 Fez1N+7bZRHNDCGxObXsp9J4PxIYtQy5JD57zFw3kJ80LKHBUHShfajHBM8ITw9/mL
	 hi4qYerwbY+clN9zZKDe5LaCHrpOBnjg5ZQgdxmD/f4IE+clDRRSI4BfthFPBjL/Yu
	 FEysU5rM5kG9OYCADw1EXbo6ZhTqpok1RMvqEwptZkYsm++lxf/tR6HzPZ9Qtn+gui
	 zVWWr2V8eYg2j/zb8p/cBEGGZ/wrE93J3rDkelLrnpBu9UubStdBO7sUpTbdzTkzvc
	 U/4Wzl4CkYhWQ==
Date: Fri, 7 Feb 2025 19:37:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/389] 6.6.76-rc2 review
Message-ID: <bebef95d-d79a-4d38-b1ca-04fd7a0c9cff@sirena.org.uk>
References: <20250206155234.095034647@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8DwE3z0AfIvqv2ap"
Content-Disposition: inline
In-Reply-To: <20250206155234.095034647@linuxfoundation.org>
X-Cookie: MMM-MM!!  So THIS is BIO-NEBULATION!


--8DwE3z0AfIvqv2ap
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 06, 2025 at 05:06:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.76 release.
> There are 389 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--8DwE3z0AfIvqv2ap
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmemYOkACgkQJNaLcl1U
h9CtYwf/dAEQBiy2XnJRy4joraUhC95H3xjx4MhiOomBFoJGnJzmhtwkOKFyCrr+
tlx8+crPMAhJ2vcGM4BScQkTT1o1Wf0txDeomwSAj3cVdUHrYLHFAzXUmSGu/EhS
Psf6Cb8+uVVlMXN6k/Ibm5Pot475K8Fym9JEpCxfw0/0RdwgcKMBNubScXw1xFTC
ZSxV9QWBmBcp9OieYzRMRLDByd70YM/dCoDOfnNB7alDVodc8psWFSjhZdQ+MhaV
q8316HpGXq6i1ykw/bhsB8HPM9Q/k1jfB/OXG5Sfalt3ykEzRnwPGSDj9A8JaYXw
E8pqvgvvCX8sG53aRI8K/yqYnSAe9Q==
=DwZv
-----END PGP SIGNATURE-----

--8DwE3z0AfIvqv2ap--
