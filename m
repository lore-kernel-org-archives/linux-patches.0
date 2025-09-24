Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D0D522F;
	Wed, 24 Sep 2025 08:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758703169; cv=none; b=qIlBkmE51b0tM7iXCMBem+S6j8Q/I7AtVDB37UpYakOlhcTiVhOnL9DX9C8zprTB5EfOdZzFFuqyZW/vYpj7IEbkmLigavpnX7JRxaV3q76LdTQzIyyj2D9jJ5d/VDzvBDy9RSIKi+xFNqQp+B0n6/Y+GvDgQGMB9xUspPbEnJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758703169; c=relaxed/simple;
	bh=v4R3xTy9sDHf/gHeoXga3Ab4tKHl7nz8GjOrrfNSOf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cjs24BN3kOYqOrVZNwIy04x+sT1IW5CFkxqglhYOm0F3pyA/5+qhfRKb/wIzCKhwICkymIKuORY0klTrlK9w7rnF08Di3K36l0IAsqxrK2tSJT0SD136McXTfWlzr4vvQLUGLBdwezkGk/ITR8VPAeHlrQ9Fq1Yl3cJ7D7b4V7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uG/dEQGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uG/dEQGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E1AC113CF;
	Wed, 24 Sep 2025 08:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758703168;
	bh=v4R3xTy9sDHf/gHeoXga3Ab4tKHl7nz8GjOrrfNSOf4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uG/dEQGj8mHxbjC6xz2TNY8JxUomoX3pJr3YmnQIBRhaDJsdKo4oPjnA3drDxVH1Z
	 9z1L+BEsZt2rGotpT1Z8vgKUOXPinkbiPRIXH5CV8XegactQy6z4z4QYW8QAaYCQvJ
	 hCZPReRqoT+p3V0p6c0jQMJzsqpTm4eY7a8GsDWz0lAMoP1TUc3IkW0BRmq8JXlXin
	 vKmZRPPa+rx/BzVXFYxYX5RfXds9QYJV7GTyBMNq0eXv84MZAEdkYvxurodgQyrKAC
	 ewLyhAC7vqCDnLNZxcfompKouQYT7HpfL6NlXq5O0olxZNskosHTzcgvhQEkb8cHGc
	 rZ/mG6FLZhVLA==
Date: Wed, 24 Sep 2025 10:39:26 +0200
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.6 00/70] 6.6.108-rc1 review
Message-ID: <aNOuPtJ2KgAenBpA@finisterre.sirena.org.uk>
References: <20250922192404.455120315@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CeKIXtBTPx+EATCF"
Content-Disposition: inline
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
X-Cookie: Filmed before a live audience.


--CeKIXtBTPx+EATCF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 22, 2025 at 09:29:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.108 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--CeKIXtBTPx+EATCF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjTrj0ACgkQJNaLcl1U
h9Buiwf9FWCY5Xuu9645hciY7WrTaV/QKeTOVt6lQF8jTx542LNY7ZaurkL8zFMT
zvk5+s40adPXejzzJ4ynlaCVBVLaYUf5UuMKxUOat1FMYiYvJ7h5Sa4zknQzEm09
eIUmCIn3Mcm090JMNJX6UTqivTSTRezcE0nDTZ4Aw/u8YIH5Xfmw2BOyaegM8TQv
bpCAt5iqwb5Ts8mPk07OkevB5zi2aDtA3bvS1xNwOIvEEhFVPTD60aEovS9pjugv
PyOCgVzlnzCCtnjHppl26wUKwaglvS89oB2a9HNXNzj1SXLOGuE5HsRZqwnddUXZ
H0TT1oZeOXkRhRJSbIETTQNTgYJB5g==
=APqa
-----END PGP SIGNATURE-----

--CeKIXtBTPx+EATCF--
