Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DC474BED;
	Tue, 11 Mar 2025 13:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741699496; cv=none; b=EvwF14v5v49pEwSBrVZN9qzBT7c6wb9sFohSHiaqTRBu+xudOl3qf3P80u3fnD/z2EvBM46rcjjzitBl3lBDPkpH8qscy68KjcdZIdDt3+AquZkq2ql2d9T+eMMMT1pt/X5ewqKDuJYucj6CxulVrSgKhfMn5xply67nStN0laI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741699496; c=relaxed/simple;
	bh=3U3sXolew/0p9nYG+5bY523XgOvSKWX4Cw5YTp0Qzx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=awUZjq5bubSwFncDc6grSrQ+HQrrxWu9Mil/q+DSSXHV3iDUUVxnOJ4u8LDrEMgoj13BbSb9l1N2aZn7A5lx4rawrVxZQhHwyg2if1zLsAETPyAPbkYTWeJMijGhEJvJ2Q0/82cDVgGKgv2zWE5eOv2qAEu/Sc0nXiJ/5pk1uD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M5NRkki0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M5NRkki0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A27C4CEEC;
	Tue, 11 Mar 2025 13:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741699495;
	bh=3U3sXolew/0p9nYG+5bY523XgOvSKWX4Cw5YTp0Qzx8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M5NRkki0ygn6wSg7TPl+Q530qmJcq7mlk0lGMS9dUKKY5jOGdGFlNeCO5PFfksT5M
	 gFMTMoKTUV3lYAXkrZcRi6Fw37VXM/SUYnf0erQT84bgrzxxxaUiBFoMEeNMFfFpPl
	 FDRceo8TVhf6h6S1jun2/+VQUhIUtX7TWa5OvRmfrWrEUqWrKsBo+niBVtNMTteUPp
	 s/CxkYevD3z2kYO3Jlb740pUx69fqnoev2M4e8iSS/vI+b3tTOJaVqrPVr4XYbJiC5
	 T8fjCl8Lc8I4HiaoQJZ8uJ7HpZiDeCn+xdgoYeYcK9NBWSTrrPu1gCsBGtiS27XfgU
	 fW3vXAKWWElTQ==
Date: Tue, 11 Mar 2025 13:24:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/269] 6.12.19-rc1 review
Message-ID: <228c1998-f3e9-4ceb-9c31-c3e1a632b872@sirena.org.uk>
References: <20250310170457.700086763@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HkjIJg/X01LzvYP3"
Content-Disposition: inline
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
X-Cookie: Androphobia:


--HkjIJg/X01LzvYP3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2025 at 06:02:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.19 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--HkjIJg/X01LzvYP3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfQOaEACgkQJNaLcl1U
h9Bvqwf9HUCUt3TxDeZS3lrbNRd8E83K8I7IP+2S9gpC8GKJ28QTuI65MXYX1Lv0
JmqExnxHLv+o+R2l3FcfpRzwqzxdJNplFgABY9WQihhjc5ZF6lI1OBk2a3N4zlVn
NFfEQKMegBGN3zMGlz3WCTaPQqgDKYdXnUwyG7tWb8PZSr9B8NPRo8RrFrkWWKBM
kYkVuGnLSHlY0XN8LBEwvqUGcRJCwT1EpVNOHG2o3tuDGNBS4p77QwKtGGNuC4Iu
+XflKpxOg/BXA5/W7gyW6sbCDmtEdOuSL7iZQT1ua8mkJn6hNPLHbOHN9PJGxnE9
e6NGPeYshiG1/iWTp/tsPwtv33b+yg==
=oYbb
-----END PGP SIGNATURE-----

--HkjIJg/X01LzvYP3--
