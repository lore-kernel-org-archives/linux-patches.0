Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B60314D1A;
	Wed,  1 Apr 2026 17:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775064912; cv=none; b=EI5z7vEwVinWQHl31UxR2yQmMhU5NFG0NAE8pPdwh0maem1jqwNTqFUddcfy2QOdEO/rloiwjKhXJm/UTu4Z70/ghiQS3T6PHh/UfNjLNuT23XIXtUlsXyDceKrXgYisa3dvxFnFMTLsPBI+xQdH+rfMwZBe9apQCf6UpyZYqvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775064912; c=relaxed/simple;
	bh=j5mT9KtFjIFVCDpPQWXEfoZimvSQRFa8OxWKIhLqOiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fELbVwudsbfUUK+u5QXRWk3EvpVeKlKLZAXxhjoonnWsrL9dBu/+Z9Y+F3uUDzGgeWAJQ0zZYTzX+QooGjJkAg3QNSeQPKYveuUJH895BBMl+Z67PAw3Fw129n2Xo8NU0WVLn+nKRLknWs7eeJqEHJEnUBANgIUdvAhdIYpKPrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2api+Gt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2api+Gt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC37AC4CEF7;
	Wed,  1 Apr 2026 17:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775064912;
	bh=j5mT9KtFjIFVCDpPQWXEfoZimvSQRFa8OxWKIhLqOiU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q2api+GtJocvt/iei2Zj/1BN0COvjoKxS8Ybyq60CjR+LZiXdTtXQNZ9MlZ10c0vl
	 z1K/fsEjd3KCfePKVB8iR3Vxx9CrYKUZLXT+I11ohkhZlISaxAtFzqBvE0i8/YLMe3
	 9Q7KSE8FHDvu6l3kMu9G4NUibbAQry792Ml3VGf0GASgk2aMpRJt4yYubGSX1wdsQz
	 jyI53rpGMsAATgJboOvDkx8Xnz9PPsBkvy2qoOhpJPVo6krEoeSv7Cm1sxJ4fPQDUw
	 UAxCNf+HDjWU3qm3y/hJKMaOnNfjc5SKjUUCfiYGjpwESFuqpj8ttD4Y447OpVAIj+
	 myu0FSOZuk14w==
Date: Wed, 1 Apr 2026 18:35:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/309] 6.18.21-rc1 review
Message-ID: <94429ed9-b76f-4e08-9428-4897a81a81f9@sirena.org.uk>
References: <20260331161753.468533260@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1V59pTMIkSNm4VzD"
Content-Disposition: inline
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
X-Cookie: "Yo baby yo baby yo."


--1V59pTMIkSNm4VzD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 31, 2026 at 06:18:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.21 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--1V59pTMIkSNm4VzD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnNV0kACgkQJNaLcl1U
h9A7eAf9He7EhftlN+RNsrq5WRcid2tk4AAi0rIliRQYUrtQGFlYnlz9Wcw+By+R
Ra5Ycf8rPeCSD9o1EgmyqIkwEL5fRVXL2QYjZFUMBkV0EWzSbv5u0UGczbN+BijO
V3/tMlGvqfgEuS5AxIn+7hYgmerS9ypFGnecj8KQ8gQHw+7SgwT6LHnzydLjdxhp
8toaADrYF11fYFEuig2kNZ2JvnvyrfkT/pSRIaVPsd117qPdCzVUadNMGHbx156q
I2mmpo+eXion+eqHvZZEdGEGDV5a2PKqiNWwlGMeVvk0xvu6q0Z+F2TFwIYLE74S
cqz9RaPacVW5TZSp1C7FZnc7OEhzVA==
=OWxl
-----END PGP SIGNATURE-----

--1V59pTMIkSNm4VzD--
