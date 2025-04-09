Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD938BEA;
	Wed,  9 Apr 2025 20:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744229356; cv=none; b=ajuHNqgvlD0QJDrhTtQA8hNAgwX+9hctYz9skokKW1E0O5OhSLk3487d7VIPUpzQl1V+UfmF5cBAqQjmMwnf7N49iE3A4dYKzhfD9APoGHI8MyawQsXay/buD4bq1iiMjPZFaeKEMnSOU/IOT0IQ4T4eycPJAlFW8Hp53BLvJ0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744229356; c=relaxed/simple;
	bh=AL9UFcokgjfPELHcJzM5JZxaLe75v0m/iB0h3XQL16g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q3c49UA0Mldm/g6k/xw8wMpEY94ZEhb2iGTdr5XAvYmlNggXPQEEFiw8PlEDS9Nq/S0vqiqMYHgivP7LG6I+a12Hr4LWNIz2W4OoQZ2z+pwvVYrvID7+VRTFiidLE2BGsKjBbWfwusD4Fauu85wpRhLgFNl0d0ypRvopyGoin0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IGsM4yUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IGsM4yUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9404EC4CEE2;
	Wed,  9 Apr 2025 20:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744229355;
	bh=AL9UFcokgjfPELHcJzM5JZxaLe75v0m/iB0h3XQL16g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IGsM4yUB8Sw7wv0Wm0L2XLM/dOWadtw/1f7WTdD8dZTBmcB/n4A6A5uv7HBfKfD6O
	 rgmwINSMBpQVfATKF76ZO6w0uJxvT9ySc8NlHiJT7gnVjlBMHRgZfmYiamC6VPFkTe
	 SfAMwKj7EnjiXItM8IyMvLtf1s5Rf7ZCqsKpbe9coFNc0nDl5xhtEnYKGVJEXUz8OJ
	 khHYzjj0Pl7IMUvPpY1f8oLngWbIJNPSHH+U7WLWT6d3FGwc1ly408a/bWPmsH1Fkr
	 weuzqGHHJJt+BEOQT4w30zPw5X2C4fJyIsg6ywKtweBcG39IFds43h4WbHnP52OCHh
	 tBn5cyp5wsVCA==
Date: Wed, 9 Apr 2025 21:09:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.14 000/726] 6.14.2-rc4 review
Message-ID: <e7901b34-01af-4d44-b46a-6c667ac61e84@sirena.org.uk>
References: <20250409115934.968141886@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0x4lunevLq9vpRKD"
Content-Disposition: inline
In-Reply-To: <20250409115934.968141886@linuxfoundation.org>
X-Cookie: Words must be weighed, not counted.


--0x4lunevLq9vpRKD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 09, 2025 at 02:03:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 726 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--0x4lunevLq9vpRKD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmf20+MACgkQJNaLcl1U
h9ChEAf/R3PWm7LCy8kvqSTjTcGkE8hJ/QmsxtMItruK9s4hRPif4oI2JTPj7nF/
z+IfTioX/7I/sXcUEPq1In1qR1oMtPKHvU74dZwCKiB2XlxXlNU6LmRCs3gG4lOA
rOrCoTqcEj3TVrRM9fFQ4fhP51psUUMYixAOmfycDrlp2seKXwmVdzJhTLMn1onn
DyjeiZ+FbJci3DkUV7faZKzPG/TFiUbNkUK57sLsD/xel7xUJcSoT1dsNQ6JmPfR
qNOfnYqBZP0zX/I6ln7FuqRBBcSPCiBF1ETGX7D6mcG8Zxh+67ndZ/A5GNokJ+Tf
pU7J5vtli7GtJVdwKMBkSdgxUZzOGQ==
=oqop
-----END PGP SIGNATURE-----

--0x4lunevLq9vpRKD--
