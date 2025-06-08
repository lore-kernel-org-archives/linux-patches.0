Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DF41EBA14;
	Sun,  8 Jun 2025 22:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749421367; cv=none; b=RONd7NGt0Z1Rj2WcygDAnbkJOYy3cgGv2htbGJ8W8kh7QJktdkdp5FUXY4cH3rNwjQBbXjEUM4jAHx80cigUGH7xAQcxxvcnauVIRSHiwzfrtIdf/q0CtunPbQkZ1AcHLVYf6E2DR+sFPaFktAl+MaK9aLMD2JCQ+vVM3h9cOcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749421367; c=relaxed/simple;
	bh=FRviGFUtuS+pcps0srRO33Vx+n9bUwSE/+0bo/8ut84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jaY28+d1O680sKaTRy4xJPjd2Sdb+aMnV+BRni9tMxb4Q0I5lSOwFN/40PgCTKv9ZNzfjqUBCa23bKvUDih1TaHXYxjbf4GFQ49QQ5lNz4f/9qqkJR7tSByAc4ZYjtlsQgQDMMDexZgcA/tC4dsO1nJxr2lb/qMicTyGXfLSg9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NnziB91r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NnziB91r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028E5C4CEEE;
	Sun,  8 Jun 2025 22:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749421366;
	bh=FRviGFUtuS+pcps0srRO33Vx+n9bUwSE/+0bo/8ut84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NnziB91rxKcv7UPxaQD1avsvOHH3MAahCe+gK8/l4WjlBVOJsdJuv6wiBijyAoxAy
	 n8+mtT6vCidpjl/PawYgR22kTD4xEIiWIWOrn0/DdJX755OqaDk0XZAF8c+OTjL9X9
	 Q6usIp8a43vF/8hokzy2NJ9tZz5TYTKuQR1/EplUPzJx0vwTY8TCUn1lAjHCbqSxC2
	 gmDBpMyXTWgiCfsAdIg022zkI2M/Sqs6A4pBVXPjWzKOeP0Ii5LKsU59VzzmY0LKDG
	 AdvcG5RYvBqKodByaAfMhpE1DHAVV5ZBcWDCpsfqvfOHxbp0L1sCt4fIcLCKYRUvPf
	 mD40gW4+VPslw==
Date: Sun, 8 Jun 2025 23:22:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.14 00/24] 6.14.11-rc1 review
Message-ID: <6f440c48-91bd-4028-8c75-2d5bd9fea6e9@sirena.org.uk>
References: <20250607100717.706871523@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HqlyhH0Bc/1wrJJF"
Content-Disposition: inline
In-Reply-To: <20250607100717.706871523@linuxfoundation.org>
X-Cookie: The eyes of taxes are upon you.


--HqlyhH0Bc/1wrJJF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 07, 2025 at 12:07:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.11 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--HqlyhH0Bc/1wrJJF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhGDS8ACgkQJNaLcl1U
h9CS+gf/fauQmVBkUC/SXhMpISZK+CXzegREOuxerIVxYEO894h94jkErRAkGs5U
Sr1y3YvzIKovqWKzzmKfhni1ReMDHs1VQGcnprkxu44BlNvYECpVuGdl++uDc/Md
mlBPy2LYEwwnLmBPj/CTUkQEsjcO3wvm6YY6mkwMdEub8nqq1/bSeqLzHzVcSL/J
r1ysPn+yyXM1k0AN8mQY91Iam3MYzalWUDvFwPsh0bkM6IQgDX02aVyNrepX7wCG
bok6C8eQXkHLc4pYGxsX+8+9TKvF9HudyzPAPNdYmJ05wJ98brpd6v9d1oDCbsMT
5n4SP4YXgEdu/6VWB65q04sdRqwZmw==
=kKGK
-----END PGP SIGNATURE-----

--HqlyhH0Bc/1wrJJF--
