Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF5D1990CE;
	Fri,  7 Jun 2024 15:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717773901; cv=none; b=URbu3FLjPCKRhpwVofbrhnLEAUnIpOTikpu5JRxH8norSDONQ5D1PgFzb6Fzzca8r0c6vQSRSe1Vi+rnwl1VyQCyFlWRgs5NHTZmxaQO4khXXqFKJjyobobHbXn7U8nC0+ffV4z5vHDqsiKSgYVhkqymy4wntpmbrfyV4Vw0CGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717773901; c=relaxed/simple;
	bh=cDn0B8Cf4qrHCc8K+Bf4fdvPV0Lpo7tGIWXpE91On1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ubi3W2wNw23Ds6DDa12XuSRP0OopkKNteROcMkdee1gb73CPg7XD1+NUNF57xINyuk85Ni0qHuZmaky1fS//kuf82hcQTKyUNwcO4N5cFyNiLewPxuLku83YioDCkqm6rhLcswnw045fx7q1BKcLmeJeok2Kg5lkUvXpqgzbtJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZRJZFNzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZRJZFNzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8203C4AF07;
	Fri,  7 Jun 2024 15:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717773900;
	bh=cDn0B8Cf4qrHCc8K+Bf4fdvPV0Lpo7tGIWXpE91On1Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZRJZFNztK842bugi+T8JjADH862nT+gmeHHlkohWrrKMH90W6kt7WPu8bOS2CoKgH
	 J4Wqi+twOS1WjbjB32a7mBw1vc24/JajxqUJjABIZtyVGcE4lRvTiyIzHN6hT+t7DC
	 3SgKF9MpVJw1kffKILjzH8ULeI6UmtVYwqkFQVF9Vj7pdK26q8/UoJO30m/dicJCr6
	 mXq88gacGCDa3/YHiqq+1KbmEIP8Ubt5q7+GE0c/JUOBmAv9hwi3frtUCy/oZLj1h+
	 ZPjbkAsg2119dgwnyI6+pYxY68SM4d/7dt1CXK2C6tKKuJyixpk4rRlqp3TG5u7E8k
	 OtLffifjlq41g==
Date: Fri, 7 Jun 2024 16:24:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/473] 6.1.93-rc1 review
Message-ID: <ZmMmSYqryQ2ufmL5@finisterre.sirena.org.uk>
References: <20240606131659.786180261@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SVN2U3jxq2+OcCc9"
Content-Disposition: inline
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
X-Cookie: Your love life will be... interesting.


--SVN2U3jxq2+OcCc9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 06, 2024 at 03:58:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.93 release.
> There are 473 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--SVN2U3jxq2+OcCc9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZjJkgACgkQJNaLcl1U
h9CI1Qf+M2U369e8fh4c2+j8dLtSDa/MRhbvbimqFtc8apjuieun9ck/iGU4wL36
M7FB/Sx5cOsl/ym+e96JEiTDmLXrogUuNzoYpRNvJXhpDjPp2t/ol8O1oneY5570
O7bltmGbf/iSosg7i3RpBNRp6x7gyw94reua4zM/lCLrN5qi9oI/2VasPG0dEsSF
VB9gIoc9mSymQdx5aYNP+rynx0csDbN8t4S7QHj4saMvoi1bHSgKNt9fyPWDXNxX
7fjjzWgz5n5WcrilsYbrdVdIdI2ss4IHDTK4KnVT9XWeLFY4ToNaBvcaTmJEmrY9
aWr7HUwFIYEKYUegQrtsaY2uDBFsOw==
=DmHT
-----END PGP SIGNATURE-----

--SVN2U3jxq2+OcCc9--
