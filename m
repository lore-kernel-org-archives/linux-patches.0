Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F472820B5;
	Tue,  3 Jun 2025 09:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748943816; cv=none; b=LlYEHvk4mlwAT5oVy1LHQ79068JteNt7uYE6xf61/Jm9AxawS/a5z4QAFkY3qVAij6LEUs9PPJOHaB+UVuPvYJbRESsN2TsHJlG2Z3CTbfzxrXZb2pqgMxwXHUr8FJUpLDAiKQUDfT6aY+UOR6fvgGK2Cr/NOGOkqg9E9uyo8qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748943816; c=relaxed/simple;
	bh=31pIEHa2Idxs9LHlFCUwsetTyDoUekPPlVa9Y7yJ3jY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yejxm+RuKkpRWUSaAUziFCpTPqyS35GL5YXYI18e8+lpnE8lDksSVeSCXpB8DNEa45h/z9SYSFtsW3dCqBkDtPRG6bPI6w4nbqIqTdoCPFYjHdPkrhaLO3UJr/aIhw+wU5lpE7GjM/rFxUx5y4fRaG0BQsB3VjGk0GJVi3Vqo3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9w2DS1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9w2DS1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DC3C4CEEF;
	Tue,  3 Jun 2025 09:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748943814;
	bh=31pIEHa2Idxs9LHlFCUwsetTyDoUekPPlVa9Y7yJ3jY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J9w2DS1vq5R8VjaEy4sKadz88Dyv0/GCgQzuogukzWnjJCtzVaakn98hW8YNezP/C
	 gju3S8GJz4FT8lp4o/KPY0AxXPHcT3Ko605aH3rRIl4jfHNK1et/YCuk1aNeiCdJWU
	 M7vC6xVB79TfSp7tu5DzY2vTS3GJ90HSamk7At6NUJOwrcUoHQliKq1d+9VEeG6SWF
	 XB0pRmxkYLlXBrct1+pmjY81Tu0EBJ6nSKz6XV9CCrplVUMmZdJL+8fW9kvuWplKRE
	 j4HTv2PP5EToO2pBcnPEbFIoSWEr2RIZ5x5rhiIqu/BRJ/JlH34rTWySlT8Z7zGl88
	 l+WLU1rAkJkTg==
Date: Tue, 3 Jun 2025 10:43:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 00/55] 6.12.32-rc1 review
Message-ID: <698172d7-6531-4989-a6a9-62b831155721@sirena.org.uk>
References: <20250602134238.271281478@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hRfw/P4giXKukNbe"
Content-Disposition: inline
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
X-Cookie: Avec!


--hRfw/P4giXKukNbe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2025 at 03:47:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.32 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--hRfw/P4giXKukNbe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmg+w8AACgkQJNaLcl1U
h9BbFAf/bWPn90WfHW2Lt8XrrtUCKvMgfoeN/vaJI06L5JhE2qZh0UoRkz8hnpxW
q2a9PH5rQ5nobmr8M7S+qr0zCc5Sdcd/PlFiOZTva5vBAoTJhYNzkUd/ShCl00K1
E+ulfUEhb9mOPPK6PnXH0WUnvLmRL4gSWO+OYp3h1Lh2nlvPhAUQ8SC3LBj3bPOW
UFoCcl9XX8eDyoVvYCSjIydDI0rypdNHM2aU3j0+LkToTNBY/WFdOMtQ4jhjmyhq
S3mqC85a57g7krAjAStGP2iLsnre/ecxUbNxwbZrpForR7aj1OH/T75wUBvtxmYZ
O1by88WSacLg1hB5hn6sZbT/I/pfNA==
=9Zjq
-----END PGP SIGNATURE-----

--hRfw/P4giXKukNbe--
