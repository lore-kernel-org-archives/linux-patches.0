Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4BD12E75;
	Thu, 23 May 2024 17:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716486012; cv=none; b=DYF47A8YWNO+xpJbt/rzpRW575o2McMss3NATHypEf8dxrrgaNpK3iCStH/czcOZqFsmku2EB+bM48UbnjpMbNxyajaRZTdY4fBhFUhVXET5g+Nq3+vm6qBXg1DdN6s7XSWe/Z2rhOdgol4vNEwpeDVoP6GoTYigPv7A3A1y/UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716486012; c=relaxed/simple;
	bh=awGoNhuONhvwplE/E9LvfYO45qmVez3JpHDk+oUhgqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kDUi5IwomqQDzr5BEmtHSRVKu35jdo2TgnfrJPFiHY7nSaOqjIllfbnvM6PQM4oIjxgD6njYgpeBlgseMaNp8Ydpm7SADVOGl10Scirsa7Qn05R+VdTqFcSjTv8nPgXvOgnUR75HE9eD2oNAfpTZDkyodMeAcs2kIMACsq2KN/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u0zkFhT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u0zkFhT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87F1C2BD10;
	Thu, 23 May 2024 17:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716486011;
	bh=awGoNhuONhvwplE/E9LvfYO45qmVez3JpHDk+oUhgqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u0zkFhT9yZFKRfL6LHmT5HRPgIhaO5/w9t9lBd5vLfyGjNyvhP+uZ0nbfN3ObcawU
	 E04ttsqNK2u5owQhw4htNqDMo4EE3BMXEQg+tQ9qZm7b45o9I1QdbjccF+3GdtYIry
	 EK0BXhqJg3ugPTTYK0+YVpy/kEtRmlSFYOIu2nLZ2+G5Tph0PMPZLeAwWcuaymomgm
	 bKU7w3cCrFTJFLOSsMYLM1AHmY3TpcbNY5NMbgCsYxRhyS64/AUEmLkQKPoJle57nj
	 sb9rerLcD8gepRTqoHzM0c+MofDB4MPEtTo8Tmum6vVEk5n/0xj5okg5AHjqn0TAJC
	 LtDbUlYmPJBZQ==
Date: Thu, 23 May 2024 18:40:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/102] 6.6.32-rc1 review
Message-ID: <2013b8c5-1834-4567-a1c5-afdfc70882bf@sirena.org.uk>
References: <20240523130342.462912131@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VJVhFld6tRD01AN7"
Content-Disposition: inline
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
X-Cookie: You auto buy now.


--VJVhFld6tRD01AN7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2024 at 03:12:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.32 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--VJVhFld6tRD01AN7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZPf3QACgkQJNaLcl1U
h9A0jQf/TzeDrVyzDRgg8cvFfDha4j9vanSVOhvavEd9A7+SsIubazw/u2UAPJ3j
FRSDDpDrB+uqiI+fkRtVwhx251ZrRIX/PbjDWpETWKcN2z/ku0OjOn/F7LVz0c45
6IvAV3k2WHEg24AVyw7iZEqqx58hOt1pW+GqhGd2EuJQIVT5WWgofMJG84WlbWBM
AJKbYJTRDWnE7Y9xCzQgJzVf00mltPQCert/Acld/Hc8XpsZyrPqVrNEfe0kcW9F
u/RTErp7gyVHqtOpe9EZ9KHcqicUb7o/7U3jGhYXTc48bf6cGD5tAGPIDiYrAPAX
mPxAp1RxYvjeaNhtFuzPORIbx/I2eA==
=FKst
-----END PGP SIGNATURE-----

--VJVhFld6tRD01AN7--
