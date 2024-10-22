Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B109D19B3C5;
	Tue, 22 Oct 2024 12:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729601950; cv=none; b=YwRMvG+IndPasZmIqOR0jywdo0ekSmET8CIQF4zx8pIkyh1NPfUchHkN/ACjQ91EfLrekNOy/K+Vh5os/+DfDH7aEi9/9b4gSEVXDVlGmKosYOH1dsPtIR18GKtisEjqSmtyPNY4ffh6Zhh+2/Czx1ynVJnLUp0pK7Ng3IMxDUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729601950; c=relaxed/simple;
	bh=QltnY8b+sKCcHJYbEzq0Rl7I0k6qKbrvzljGV7hjcRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mIjgAifQ7PAa0Eq6uV7mXDF96hD4j51DfDLqGhpUamLRpFMH9QYseQuI2mOBKZnF/NgCeuLpC2O+kLoH4h8rn3kxpll2b/EvvxmjTQIpiDvA3KBjFq+wpFUiqKHLHwG4ydLephux1bepG2vyc9430u7t3Xn+uxWKCW8Jho3pgQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RWtdAUiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RWtdAUiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D4CC4CEC3;
	Tue, 22 Oct 2024 12:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729601950;
	bh=QltnY8b+sKCcHJYbEzq0Rl7I0k6qKbrvzljGV7hjcRE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RWtdAUiJScBquUYaDsWaZiv4KjzKETQMq86+XzJqEj+0lKvcVjJ1iE1trYZeNVNrM
	 dwiyS7CbWCuaTuTxJnJv61HEUhAnBI8qbH2HfI/BmRktPvYiWmxwjg4VV0Auidq6mH
	 JgMl3asiG4SoDwFYyomDGTFfI5ccZSXmzNLeKYtB+x0nzZRz1HFiKQlUD/acIPCZl0
	 apAy4OFYif+8Oc7aYCr5snrCwZFakitHzqWQNGoLZR4kh8ZHeqwDDVKqsWUPEcSlAc
	 ykyNvrl53rGNxGJHMH8oJg2WYM3Lt/n4x+h4vKKKgC9DsXZfd/s60YVlhVyad58jje
	 Dn8lbHxJ1XDFQ==
Date: Tue, 22 Oct 2024 13:59:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 00/91] 6.1.114-rc1 review
Message-ID: <91987664-ae1c-4988-ad57-173feaec7f22@sirena.org.uk>
References: <20241021102249.791942892@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VLFODlk/eWlOljIN"
Content-Disposition: inline
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
X-Cookie: Surprise due today.  Also the rent.


--VLFODlk/eWlOljIN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 21, 2024 at 12:24:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.114 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--VLFODlk/eWlOljIN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcXoZcACgkQJNaLcl1U
h9AqJwf/TW2J7NbpUm2qM1C7r0KwbC+LaRmGmnkJ+ZUCdFa093hvnC8Kg/Hr34Hm
PUMQQvh/GRfaqapapEJ2MszaKDlflmaZQp90CJG3jT4fytTEETxPDXfdxl5b+TfE
26alTEhTiy6vbJ3b3yZ6x/rS6I6+4fYHBlUe2/8Ck0VWcSRcav7ahD5jDVXvNGVc
ac2bPiwliObnm+5QOmZsePxxjfEHP967p06AeDqyXRPCGWac/dYa1K3MycAmleD3
EfjxDo+01p1EwkmJWmdesGuF7BdpDRAvLNtcprGK5UrFOwoN4571X4rDOyeIaEMy
o64CDqQdx8D9p6fE/yDC6kQyWIuPzA==
=M2qN
-----END PGP SIGNATURE-----

--VLFODlk/eWlOljIN--
