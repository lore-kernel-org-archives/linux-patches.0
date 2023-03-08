Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499537B
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 08:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68FDC4339B;
	Wed,  8 Mar 2023 08:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678263430;
	bh=/DmKvE64jy+VQaJF7BJjUBA7XhjwlHhUA/RA1GKDLlE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tsq5LR825UCsRWx880DWBOUIq5P8s0+0KUpvRKLXIycUa6DZ7Qcl7qwP7VdJz2LFF
	 C35KpHuHYZ8o8kIogOgMq1fJT3wyAc5xu12wDzcQSpqcBMrb78N5vkBYHIPPjA3sDt
	 h+RNz2VwWSIEOmk1QgxCN6GBjdDw+tkeSRMI4VE9GADUS0vcmt1bH9gXog2aduJzTJ
	 iS1p1LqBgCqfkrPKlXfPQJeQTRvs13L+dMX0y8+r+e6plLI/Rfdxw751vhVuZv6Xlq
	 fMqlKYMn2MiQgKLjmSgSYtGrmZlotd/+TZ3EfPsj0b1KT+Z7ltQdNvjzJE5cFNI8H3
	 2GyuitlKZnyPQ==
Date: Wed, 8 Mar 2023 08:17:05 +0000
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 0000/1001] 6.2.3-rc1 review
Message-ID: <2d40fc92-a4e0-48db-955c-edadc3ff12e6@spud>
References: <20230307170022.094103862@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gVp6IIn9yD+fl6f4"
Content-Disposition: inline
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>


--gVp6IIn9yD+fl6f4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 07, 2023 at 05:46:12PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1001 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No issues here either from my pov,
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--gVp6IIn9yD+fl6f4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZAhEfgAKCRB4tDGHoIJi
0lX8AP9XLKXjd6SdRxkTEm1orgTSQadbTqBVBTikZPE5PU0c0gD7B4B1ii8bnGmt
6rjFZSF5yHbJ0d9DZVmHu+hHHHngOgU=
=fJhz
-----END PGP SIGNATURE-----

--gVp6IIn9yD+fl6f4--
