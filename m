Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8084D15C137;
	Tue, 17 Sep 2024 09:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726566976; cv=none; b=Q/miWzHu2/vJx45RZ5hhz2aIRyohDJuwKie8dOWILU3ljj9dvoUd7KifO76OEQP2pv76HIv2Zkzo4+gofPYdwxBTBGaTVaM0ptBoJjR0bd99WNrInXYcwBaRJLamDvklC+HeFdhVi5GFjGsPmOg7Tv3ywvsNRM9Fe/3NkW+jbsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726566976; c=relaxed/simple;
	bh=+/1Jsm5EfZ+70W+tnarHdii86KgCFJlSCc02iiIG8qo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CDnUa3kghb1jutS2bxy801Zk3WqZbZyPLQlpTJwcTme2IQBLn2EGBQsni6NUU0wDhdIogB+oxfIY+PHRPwuydbOwh2FQwTL9Y6I1+MAMhJhzbqm0CSQVXhc7D4TcOw0ptzvgmHa3Pql016UvDat9LdWgGlpvoZ3W6OFw2AbR/JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IBfFc7Cj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IBfFc7Cj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB70EC4CEC5;
	Tue, 17 Sep 2024 09:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726566976;
	bh=+/1Jsm5EfZ+70W+tnarHdii86KgCFJlSCc02iiIG8qo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IBfFc7CjY6BowlUYZk19v6se9x/p006FROn6+NRQIyfA+vLQh/wWNfZgk2dRBXMZZ
	 nC0MlNXIygKZAt40HgXlGthdkz/97+J1bvgLbT/gz1HOH9PpbVbm8APcBdsndZ8wCO
	 FfVXJ47FcNSfDEM5yvSTlNf7TM9kcTqwvwK0JaB0Okubd29XqCIC4GqwOkHnDLHHt1
	 2i6HVUKBXEQ9opiUd6TuD3rgRlq6Ud7RB/rdEfBZvlDPMz8+2vcxdPtkFnECYw7EnK
	 02woCz3jdAup5lYgbasygQdAOpJBxWLN+9GPV5Y1d7EVzYoTZAGo0Zx3/+VtHnTtJB
	 hT30gDOOl9l/Q==
Date: Tue, 17 Sep 2024 11:56:12 +0200
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.10 000/121] 6.10.11-rc1 review
Message-ID: <ZulSPEG_BycLdDtE@finisterre.sirena.org.uk>
References: <20240916114228.914815055@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qQY3pwmha7VkpfRr"
Content-Disposition: inline
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--qQY3pwmha7VkpfRr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 16, 2024 at 01:42:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.11 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--qQY3pwmha7VkpfRr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbpUjsACgkQJNaLcl1U
h9AlYAf9F74CGgtiu9iyjIpEJr1fAN+uhIcG/2gq4eodTDEKl3sgPrmhEg4tdRZD
GAB8AlwIf5KPqQBCjm2EoT55ykaerwPHN7L1Dq2jWJ9WUVcLEAMH3RJvXD11zG+D
E2n4R0aC/xY+goUL/hbBNgnyUnsKVy8Hu75cMD0oA80vFW0hXGbINcl3+2QU/jLu
bDSCOOnllNRn+eJxUjcD03J0QOZ38hhmPPX0Tp8pIGNiiJpWxcUMg1tCGSfTj1cC
gTu3wHlY8cNjC4QcF5LLhoMChrEv7qEdVWkGPiMIeDuNf2smXY0MoYHlVbiEZYon
qW/FDlAF/iYOjr82ZMNDUuSc4MJrqA==
=XAZ3
-----END PGP SIGNATURE-----

--qQY3pwmha7VkpfRr--
