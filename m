Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963641F4FA2;
	Fri,  8 Nov 2024 15:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731080835; cv=none; b=rpgmfs/GawOiQGd0+Q05cuMsiv2Pq6YFVoZpF2ehM2pbR/RK4Mjo/7TgHmnT1n5K1m6W5msOs54Vjb4zIdmRxrOUe4nntDI+gER4IDmWWIEoFofxoMrX1fersXYSFxfjaGyeOf12xRxvSbDHhuEtvwhN/WXpVwpZ/dR0oWUvSPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731080835; c=relaxed/simple;
	bh=V4sN8c5UMc7TF/GLnT31+BpkP2tlxqfCtebPqzVlW6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gWEfhQwDUl9rmRx8gNan4DNxgWBn4mGgQfEl1sbYCWC4C4ARiSDdgEtg63RrpeElKYoK03/IoVGlbcyenVcGFrDN7JS3I9jRxnS5j4f3ubQg8dPBefJF9jGHvmqC/bHD4CBJDIMQjbudlp804npAjySKdDEshlfhcMH0wBCb5t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+AZ9eV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+AZ9eV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D4AC4CECD;
	Fri,  8 Nov 2024 15:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731080835;
	bh=V4sN8c5UMc7TF/GLnT31+BpkP2tlxqfCtebPqzVlW6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R+AZ9eV1312iFUV6O1Jc25xaZTip6kKMBnMb5xGabvbu1iDkCwWMPKzSXfoJJlUmU
	 6kYwUt0lZXmij6GLtgvqYh8Eadp5Em9eCh5ZkiKY6UzdP9LQTKcUmD+U3eAu+6rxTg
	 wZm1j96WHcpBYKjA5csgKtVYVzmQZAdXJUHHyd8zrEME2TD1/OfWGac2raiNfrBXqh
	 JgC2kzqmre3AET1FtPKYxtr0EiQePDePiVyxf0yEy9AYuxn8lzZmuSIoJ+969r+dK9
	 xFrW1AeRtqQ75wwMtfZwl9gnrQrT5rT108f/fE70YP0DRdx/N6WaoqskQzY2pOxuZd
	 jI8IqTRfH7ZUw==
Date: Fri, 8 Nov 2024 15:47:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hagar@microsoft.com
Subject: Re: [PATCH 5.10 000/110] 5.10.229-rc1 review
Message-ID: <d74e3e72-d264-4824-8d4e-f6e762eec1de@sirena.org.uk>
References: <20241106120303.135636370@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tJJd7voXMsJzlhc+"
Content-Disposition: inline
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
X-Cookie: Do not overtax your powers.


--tJJd7voXMsJzlhc+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 06, 2024 at 01:03:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.229 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--tJJd7voXMsJzlhc+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcuMnwACgkQJNaLcl1U
h9BkQQf+JV+iOsaQS4jDnwiP0KTx2bAQIP0qxlx24kLBE8f2Lp1xdQVnnQV5SEMd
2RvZv1dp+G4h9uGhrIWVx0cxVuN8nXtxsW+NMboguRjEzC7wSD3+zLp6immYHqoo
9ehZKzHW6aXjfP3cz008qAQRVRfjZ9+T8y+bq5CsHyqY/xpoMjbrAPUAc58xKJ6K
EGi9DoBCvL7vllypQeCvwag54B5wEKKl+uznVn+Q8Lj3Qw5j8e3lJInw0csO6JlJ
oy4lBiUCU7a347RjcOLNXBZ+4nlboiwd0UODnV3RRF7MmrFma0hhkmL5S7/2/+2Y
/0zlhZcJlbgh2V6Hp9sGtzANlJQkcg==
=pxoP
-----END PGP SIGNATURE-----

--tJJd7voXMsJzlhc+--
