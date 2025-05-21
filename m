Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEF82D613;
	Wed, 21 May 2025 14:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747836253; cv=none; b=mtwAQpjJYKwDMrG7ORqivM5U8UqRdFOGlPvQvFDv0DOheYlCTN6RXkcadMum3yT9EV8SIrLT6ToQ5JUoYbSh9CfymH6/+ba0i1kEEhvyHTQkTzLowgzhCTV082zWsOPNx/HLNrJUVWx0XR1OcJh5f24Q0o+fvgbKYvBw+D1h3mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747836253; c=relaxed/simple;
	bh=6AKjMOjmScgj0MR5KrRqNeLWQ4oWfHaLl1pCMRWSQ28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zd5kUhKZ230aNeRdtyFKm4up8LfLDqe7n+ewpb3K1Qt/gPnapmNLkIjkSvFrBUViiqNJfKkaYf6NRs9KsWME7GM3C/+oUGKiIGthKSHMck+Q2A5w/jrWpNmeO3aMhCpm59H6mkZ/u++8ekxwC1A/5jlMZNgzdGIcmCiYaMXYy9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K0u5njHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0u5njHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D417C4CEE4;
	Wed, 21 May 2025 14:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747836252;
	bh=6AKjMOjmScgj0MR5KrRqNeLWQ4oWfHaLl1pCMRWSQ28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K0u5njHGINmRPOp1PuuOxAMelcAEE10xMPdKA8y4YkfKqxBZkF0EVIGkFc+9XjGuC
	 kr2O20GX+4/IzCpuKoVVDrbeSSCqAuw7I8f5/jwjNFmNqI0oxJaXQfjb1HVCn+EDIj
	 fjhDSGT9SXni4XMp3le+3TOwdcdrGNR5f6VVlVQ3Qk8wYurs2Y7iB3u1wiq8j87VDV
	 C2QIYzORjtHVP6OmWNmBVCOKLuCJg+A4EePBPOId/eENOaMAHqqIyxCk2y90syt6i+
	 lrIfA0Hyp3SymQ3Uvha6oj63WjNHJWRQp1V7uZHuFpYKHuF+eX+I0LczEbJG8rdaKu
	 JDdb8psCrcXgw==
Date: Wed, 21 May 2025 15:04:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/117] 6.6.92-rc1 review
Message-ID: <c961b54c-2e30-46e7-b66f-4989a77a69e6@sirena.org.uk>
References: <20250520125803.981048184@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fXGRbk4OoPxVlYMb"
Content-Disposition: inline
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
X-Cookie: 42


--fXGRbk4OoPxVlYMb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 20, 2025 at 03:49:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.92 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--fXGRbk4OoPxVlYMb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgt3VUACgkQJNaLcl1U
h9BkpAf+KTRiy8i0SsOJWzPLQG5HOnjl1u/hbEtu0GFkk6sJcJf0P8r3matAOE1v
KZkGwkYK5cG0q1eRiNlcKvPu54/JDAxYnhuJv0SpvWihopiVMw9CfLA3Fnit16O7
mj96nQ1/z3auAYcf7/ZcWA13qHD4aVjrb3wjCMonRRqYJMyh9hR1oZfSUkemz7TE
Zn5NSJzguAso8FvbgiJh4iUDIiG3CUAyAOEEbaOrCemhlecFFOU3A8mt3RDlSkcw
Lf6vBNXBgx04Oup6sxwTtBW3IB+FQPxu8c6Q8SPYe9Pq5FC6Mxz9cWPymD6/LpZr
jtli4iHRLLhGU/oI+EGR1tCbfdV1Jg==
=sqab
-----END PGP SIGNATURE-----

--fXGRbk4OoPxVlYMb--
