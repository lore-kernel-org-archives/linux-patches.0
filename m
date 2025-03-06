Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9475025D522;
	Thu,  6 Mar 2025 18:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741284529; cv=none; b=Q1N0/Dku6aFHe4VjoAU2Pw6Dzr6cXDLAwfQNpGHnfTQan+zkaeRzsVkHEcPhmNQ65SjtLS1zh16AxzPt84Dz5MHXyinqP3K8k4+/SmIaazNo+ldSDmi3+0OCLiDHhQppuS+/RkJUMuRu6j7BwyGByMKlim2FBy8qJHC8Jf6jdrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741284529; c=relaxed/simple;
	bh=d2eCD3b7fszhhH1ta4YZmj8OeQupKmh2L4oVsn4oPwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=skwPHprlPmbBZAM0iSdD7UbpO94S3CWspIF2gnrJtHSSukJGgRLdGZBdF73+Pql65wN2f26qppuZKFcAtdXOIZ4fH29t8z9UbjeXzzP/Xq+htYrXprDhIbWIYafPb+oeUcEdyhnX1TckC5TzdTC5D49ooI5HUmD8Rpq8N9Vkakc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ml6KAuUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ml6KAuUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A50C4CEE0;
	Thu,  6 Mar 2025 18:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741284529;
	bh=d2eCD3b7fszhhH1ta4YZmj8OeQupKmh2L4oVsn4oPwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ml6KAuUYK+OIy+JkP34UJdkwwoulwBriHhag+rq8WMp/a9i5MbcQLhlsHggeY/Fw3
	 USN9FIawLUA7qhWcvNf088dAgtxZWkP6RFgMeilAu/baa21ydoZmvYvYBieA2IWCXj
	 Z/SzgQrh0SQcfUNrPYvwBmC2NvhrsFqGiG1HbKYxU9lf/RqSBFkMcQ0uDIaddSsKiI
	 3CY67nNQDvclN3PyX1Zg3/fUzlmMyD8rOK43NVQLmwaMQThvZ5zKT0YqJymXcPxI9q
	 NUQwWlq3KBkM55bsx3VM9OHqUhCRlxrcyViIOiXsMLrQuGVcslb8Wnde9AvXKQfZjB
	 cV4euPmWiI30w==
Date: Thu, 6 Mar 2025 18:08:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/148] 6.12.18-rc2 review
Message-ID: <085c982f-7c18-4e0a-85e7-324c81f325ab@sirena.org.uk>
References: <20250306151415.047855127@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eGsZqkyCfryNDjq/"
Content-Disposition: inline
In-Reply-To: <20250306151415.047855127@linuxfoundation.org>
X-Cookie: What!?  Me worry?


--eGsZqkyCfryNDjq/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 06, 2025 at 04:20:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.18 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--eGsZqkyCfryNDjq/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfJ5KoACgkQJNaLcl1U
h9B1lgf/Y3nHrXUKf41MsjiU1dQK9IdUpyAkzHmZ7+Nmivn/VYTWZKJ63b6D5qSo
ACbnawOEkLkj82dvd2plsOwTH9lIl09ljg73UeIWHvVonK/KGiFG4IzIMmQgdcNs
8o4xofZ9k8rwDQWUq5CjUbm/phvH5oVfztyv6/ss5fVXBo12N9SgaC1xU7FNRN9f
XpUCPwl3gxrqjyGWV1VulrLEumK2D82lHicD3NYDb2Xu9HHo2il0Zkn7NLUubjO9
1g9ld8HGq3aFdjS53poSUcl80hdCwLvxBkRuTzLGAkcnQYT42MpZNBZ6oxGUDjAd
NP3ekiYUUgZyOdd80RQhIO+Fd+H+fA==
=byYf
-----END PGP SIGNATURE-----

--eGsZqkyCfryNDjq/--
