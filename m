Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DA923B607;
	Thu, 19 Jun 2025 12:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750336000; cv=none; b=G6kJMmHGsEKXeschc0peyAkV6VoKV3viZ7NQgO+I5CrOHjYTgRHDsYgJPaof3h/UfSGB0LMXkUATRHtqgJkYrHh5nbjifFaR67RTUdJc0AspZ7bKymAEIaW6qkNOwjcfiTXG0mhZqtClw4p1VQ4L33jGvHIe++x1dnW7ilP3Cxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750336000; c=relaxed/simple;
	bh=trqYLk6JlrcRlvPKUQFNKEIS2nYRl9ZjKWbw0aBzfno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WGOQ9GiWAVkusWr80ngfI1Yw9GGI5yzFRYZ414gUJ19IMKsGPOxw/8gpvhdL5C28wG4ECqtb1XAcng2IvpMIrHsifwAXqbRU1PXbe6Uh9Rp0ced/kD2t9JBUd6fMbs2cn+xOgy1LQ3zCD+raVHhP3xuAE4ArhJ976BgxUQzUR3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DqwIy/3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DqwIy/3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DF4C4CEEA;
	Thu, 19 Jun 2025 12:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750335998;
	bh=trqYLk6JlrcRlvPKUQFNKEIS2nYRl9ZjKWbw0aBzfno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DqwIy/3J2fGzWlHRjlYCXDSBYDFLf/s+qtS6BJHo8ilMCRiuG4iSIzuW47OFSOl5Q
	 YCSxHU7c5/3S9oGLTFnLDrQe88mF5W33Azjd/0UQQOJT9KQ3G/hSC1M3kBU3S55PEi
	 PGrSDunrH8Pe5d0Sm7q/Qdhz14xHumG0Iv5fTnssbUi0+6Twt4dxkqtIpk6naK5Kxi
	 haBoY9vp1j8wARNhNmqao0DMRyldtwbSSnkwr2vTi9BptEqDpYIKbwQvJfHGchp6Nj
	 qUkiTLqIvHh2vq2tZgCV04BGvSWj68Y0lLGUc86WcTbC2Lc8BYEsNA0KK2IQOfQy32
	 EL3tUduXNhwYA==
Date: Thu, 19 Jun 2025 13:26:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/512] 6.12.34-rc1 review
Message-ID: <b7bd76b1-7467-4d1a-889c-904af250e1bd@sirena.org.uk>
References: <20250617152419.512865572@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GJ9bzHeobwX1mbvu"
Content-Disposition: inline
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
X-Cookie: Reapply as necessary.


--GJ9bzHeobwX1mbvu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 17, 2025 at 05:19:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.34 release.
> There are 512 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--GJ9bzHeobwX1mbvu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhUAfcACgkQJNaLcl1U
h9AWXwf9HrqcagaLyrY9nBgWA2YhZdV0NzY2ifxZNq9O4ubzhPdSKWpIlmrgf/JI
z8D/2fIWO23snuSi5FN6oQ1aGPow+9gvWmpJ15cYcxr0U3ko2yAFA413WwVN1QH6
Hg/HwymZaBo7cmUTHuhaH1WxOs3XRqJ3QM5ScVhQU11qLaZc+xDFvAUP4oArmPTG
8OC0q0g95Y5887iQO3YS5KJV1ZdIdYs+RqeiKSJnEer7E4y/fvMlLwXO+uAzUb0y
QDdVfRN2E5qebeu9eYoWs3zMcmZ2m+n8cBvti/ego+YoSa33XU8fvmAjndYWrcwV
9NA5bxKjVbI1jAOR2RMqK5wt+y7vhQ==
=QTEQ
-----END PGP SIGNATURE-----

--GJ9bzHeobwX1mbvu--
