Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB38F3F413A;
	Thu, 14 May 2026 01:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778723137; cv=none; b=Rgpvx7XHTVgVsmeNO4qkMT/IdL0pNxuFrJnSu1Ien5st3Gs13aLBYj92uyH4x95+XRAaOiZEiwg/hraJzJ97aaptuFcAv9zpGpXKYA5WANNhtnHwZSSigGLxKCmltXJ49ekHw9otfoYELInJjYwbC/aN+LcUxpZ/VhPrRpnkFhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778723137; c=relaxed/simple;
	bh=dxBcxxITvhijt5ZHP/U//u+5Nw1Jusa0LShIzKMZp80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HQ1cwAgiXp1OiWqWieiud9V41TKI31tQeywDTiXVzkZduaQZvuKliW4QL2GlHR89Li23dyvc3mH8dITfAY+rhkxAKwstzjnKE04gkz1xEdSZmUD2O17LjUC6OhSvW9/6kJRON1et5Nqd+c5hawfz/Lqa6aZb8YIvtCf/BgkeLaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZBkIJUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZBkIJUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D626C19425;
	Thu, 14 May 2026 01:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778723137;
	bh=dxBcxxITvhijt5ZHP/U//u+5Nw1Jusa0LShIzKMZp80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jZBkIJUtIc6bsJHX/qEJhMZhw3Yn0olGT8kF8PXyXUFp4aWGe+X7rz4+zF1fXPNOa
	 GL8wscUwOcLKZfPHlssVeMzwwa+NyIjaOP131VRHP+MZSAjGAYESEOMmndYRdhMW8s
	 Bibg5IO7ySkL1jWpvuWF7AXGGOtiP1jv/ik5IkxNL9pbjoZCSxWTHdbkIpJ4ik9yNJ
	 X1QTgrDc1fq+SPvWeyIz9UALdAftuWRXwcCvxmOERp49Doso1uLt7INiHQ0gEg8vKq
	 BQd8HVR/jRwdzEN8dq+MGZ+ZPM8e6BzKMU3byLbMpRVXe90RJBb4nNxPUrklpCTaF/
	 N+MBdpQIDYDRw==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 203581AC58CE; Thu, 14 May 2026 02:45:35 +0100 (BST)
Date: Thu, 14 May 2026 10:45:35 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/202] 6.12.88-rc2 review
Message-ID: <agUpP2znM63xEtvZ@sirena.co.uk>
References: <20260513153743.326058350@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uTwJHE8UJ/2gMKc0"
Content-Disposition: inline
In-Reply-To: <20260513153743.326058350@linuxfoundation.org>
X-Cookie: Truckers welcome.


--uTwJHE8UJ/2gMKc0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 13, 2026 at 06:17:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.88 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--uTwJHE8UJ/2gMKc0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoFKT4ACgkQJNaLcl1U
h9BpVQf+K2vjfVtE5bAVTbXc8QiV+gF1nC2cpkVjj/gOMuM0GhdgXP7CuPA418M3
lmyKCNz1DVDZuYGNL8JT1sJvahI+ch4KZt19EWAgJjqdSmmKOi3NReRIddL2tJDM
b6AzPTpu9OehwZUdcRcpj4wAnleulp+w5I1KpDDef9O4vfWbT5OY+gWinIoxDAeI
Ma98sJsb4B0y/cgKGsIfqH2OSrZFwvfIZdvczYiLyErENloPDRJil9q3D9XY4KBK
F2go/wsykBkeG8NeZBz/nn1jJTn/ctY2xQ5orDpLkpCrxpaSSqoQWe0DUOxRXG3y
9B/FVvTir5x+JWfVhosQIHaFsBheQA==
=GCS0
-----END PGP SIGNATURE-----

--uTwJHE8UJ/2gMKc0--
