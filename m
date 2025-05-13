Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2745823908B;
	Tue, 13 May 2025 09:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747129547; cv=none; b=rjU7OS9es++Xom2D8wuV+sKXChuOngJMLs/6/WyHvk4Fu19KjA0d8UvHtCjOjRbEBIQzTYFQWn9yZ/bwfgT6nTQs4cxa2wHm4SFl4fjluuHh1nr1R243IrTH2CmgPLkI3nj+hOOohdU5IC1UjMYAnLIN3R+LLqXvQm4bwR0cVAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747129547; c=relaxed/simple;
	bh=IeWDuD9dKX9QtBBZu43f0psKXc2HLAkvq1p4xZVXdv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UnLCei61TkGLxHRjXM7Ti95UpdXxAoVtE/SiVWQWWmjUYW49tjRLsHMRocE+lD5ecmEFtV6PwW8cemdd67aesms95nQqm76pVOJ+0d0bp0mFevhitECyGYjW30frlPOaldx9HydwPudT7+dPo+fVbG8sJefFZAo9JeG1LgAuJnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cW9Pc4KJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cW9Pc4KJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DB1C4CEE4;
	Tue, 13 May 2025 09:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747129546;
	bh=IeWDuD9dKX9QtBBZu43f0psKXc2HLAkvq1p4xZVXdv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cW9Pc4KJpjjuI7IuE+SoY9uwkABOua6vHSSLQ5NxYMkrpFhNt+08cTnVxN0leIqev
	 xLaMYH8vyBHBIrN8gIVCJe4sZS/d8c324o7339KY/5sLcfGHqiY+ozwT+/h2rtGOuq
	 iCuptVBduJGnhYt7/I1fBFdtfuF11LXTxzKUjqnxCvTI9/kqv9Cpty+LpYVthfTP63
	 o44dtbg9s8iEcCdn/muQMnXUUDccesuJC0XEm0adM0Y1715j3VdUsjA1EP2MgQpWfs
	 oHjAhQEkoP9PZ6Jo/rZ1nBF+yshf37p3Hj9rw4yAtFCOn5LVGWOnS4NRvjLnqHdP66
	 4Jn/+LXaeqsOQ==
Date: Tue, 13 May 2025 11:45:41 +0200
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/184] 6.12.29-rc1 review
Message-ID: <aCMUxWRJo_jo79Bh@finisterre.sirena.org.uk>
References: <20250512172041.624042835@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aY8wNiFnky6aNEaV"
Content-Disposition: inline
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
X-Cookie: Well begun is half done.


--aY8wNiFnky6aNEaV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 12, 2025 at 07:43:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.29 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--aY8wNiFnky6aNEaV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgjFMQACgkQJNaLcl1U
h9A4Igf8CZzBSAuRtsqNcyXa0xTLVcNu+HPwWAiH0EqDQAp2lGfNTwcZBL4r29Fz
1DE8iUomRZO8SnPEpgMaGZZS6Sd1U3xsjwB05Fr2Sk+7RbkacbLD2OrvI7JLYRGN
xfwV28SJB3+EI7SJGzCj1aFLfKxKt4y5XRTa/nKMrIxNnYtUaJhcZmk2C2cltLwu
3KZv2r3hdPpf21PDEKeOvNotwt+YZ5zj3YguXeEvoD1N99/rL7jw1/Nn9tUqvk9o
hPqM2DG+oSjXmr5zWDJjUQGZWz2/6+mT8MY0cgFWYTqwP/vGMz4xuezrXsBp6Lfe
EJs8ZVvA5DrxP4idmeTFmCCDKZJ2/w==
=nnua
-----END PGP SIGNATURE-----

--aY8wNiFnky6aNEaV--
