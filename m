Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DBC3D16F7;
	Thu, 19 Mar 2026 12:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773921973; cv=none; b=q2Jgom0aA6cfsFL9zwssKkfNhrSHJQooZm5wEsyoUVdEkc39wwpxbER63N/DAtnoIoIb+d3CMZBO/YJuaF2IPsrQnl4e5qN0lsCvsKU4MvP616q7WJBh+d4XtiQzjgavfy+8nDDQWWoLWR1bKWlOFAoinOZ/V5WBvTSBbOHBPok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773921973; c=relaxed/simple;
	bh=iTkE+K3nUYUQ+3z30Cr8X0Bzm1oelJd+pJ9uHSVtPsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CvH9vxytL74b/8coo8Irii1RpWyiB5hodoG7CfB0+KIzz2BP3H+ut11umjbVihWz+oscZoDYkjjicn2uOR11QktlZzKLnXlLiOJhPRQrH0dUl7nGfzRw6zYXqTneeQV0aCJ0sQesClbjwWlwLmlohq+x4w8aPoItZZVDjG8yhmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIggeOtj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIggeOtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C498DC2BC87;
	Thu, 19 Mar 2026 12:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773921973;
	bh=iTkE+K3nUYUQ+3z30Cr8X0Bzm1oelJd+pJ9uHSVtPsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jIggeOtjYgmg6CcxAIYms7YoIXuBO6Cut9QuitgmStN062OphWNQQKKQvIKWrWnIN
	 yWMEfMfYiLZgoPtCyaN0Z28vj729qREeTlhUE4f7KLB3ZSd8P54k8teLW64SdwfwMP
	 oH1pXopUAE6I5vfbJkPcP1gVpBPQ6xyrgXZxXPkEyXva/d47nklB5RQMaU1P0Gvs/L
	 zlOztQsI2dKsXweh4inYrO1QA7N7Dxkv+GBM043Y8vWZcWwgTssBoBVS+AX1MWRict
	 cB+PwxxRGX8Ey3y931YrVj4vzcj+fRpMbk9DN2eoYtOtuR143MF7saNqZjKwlTbnT4
	 rep2Hi8okvXlg==
Date: Thu, 19 Mar 2026 12:06:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/335] 6.18.19-rc2 review
Message-ID: <70483da9-089d-40a1-a8f4-94a62032028e@sirena.org.uk>
References: <20260318122621.714862892@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hCdT4vb5e9UhsWH4"
Content-Disposition: inline
In-Reply-To: <20260318122621.714862892@linuxfoundation.org>
X-Cookie: Given my druthers, I'd druther not.


--hCdT4vb5e9UhsWH4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 18, 2026 at 01:27:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.19 release.
> There are 335 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <brooniekernel.org>

--hCdT4vb5e9UhsWH4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmm75q0ACgkQJNaLcl1U
h9CAJgf+L5Hc+n5x75vqCr+nlldZXGB6XRKvrjjTofYKactKH6MV13HJbkrgbgU2
w7KAIQBPgxu/8FFDpHlSbFZ6gJ0btCijOsF8P9ffV/TvaPj3ppMyLq7zIXunC/je
zA9Q0ODyObymxe62LnQJLF64JBLXiEmHNhOP5eleau0WVqhgDrG8AC8zSqNi0rto
TeMOyX3doS/IdTZwtDuEhP88Bf/JXqaLLwm0eXJRpeqJ4ZeGGURH8gs12lcnofB/
PPJBHd3pKZ/z631BHHzfDxGa+aaj5+wGq7udqsNi92aM9AgTSgdvDTvM93LU0m85
uDjnz6cGT3gLNL1EzewMwf7jwYyWdg==
=SyZs
-----END PGP SIGNATURE-----

--hCdT4vb5e9UhsWH4--
