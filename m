Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00E91953BB;
	Wed, 16 Jul 2025 10:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752662329; cv=none; b=B+yPYP3bubHJQkp1EVsRIT4NYDrWRlmDyRqn/j19IMOx3kKtjixklZncvXMWWYdNRtbmfdQ/wx8AR/LTS8BK1qDjymtwlC0kNbuUQYjzzMBTJMOQj2Un+dMxf7Cc7il72XFas+h0ghw8APa1RgL/wnb+tFrcj9ncb5qNSpybU8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752662329; c=relaxed/simple;
	bh=fm41am8bS7JAz5WSDFY0s+jI2IxX56QIa/SipxHtsTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uAIuSTbUG6VlJukx4vZRrLGiJ97XzAZlteNVaRK0E2okOUEeg6zyUkE2nunZWxgkD7AFO//DUyPgZbSfk8NoHHcOy3BtFflIY9FAXRZ8Xec7tvV4/yuDJRjvzCqxyrQ8qxVaBciwn/fQ8KmmRhpF9J73cOf3TFfS3Fb5Jc2yQzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f8sqdu4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f8sqdu4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092FFC4CEF0;
	Wed, 16 Jul 2025 10:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752662328;
	bh=fm41am8bS7JAz5WSDFY0s+jI2IxX56QIa/SipxHtsTw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f8sqdu4DEpfdiNgd7e+4gbVO8qsx7carCmePIOuTIKqSDeo995aLsEjwpRacQVpzy
	 h4bQO0IgNG1Q/A0Te9KKrVfjXIDGLPYPVoixJPMreFbp9PGPiLDndHh14UbtJrXL2q
	 LFanqJ/XMhb004D6epMTU26kb5HLWjd3l42E0nkGIyq6697W/O1ulbXjN3vPTbm6i7
	 gQq0t1Vi0ts0IFR/Oj7zzsOsvCJI3kF/skYcdEmqGEfzh6EPZQeW5PMULw5sOT7kOe
	 HOujRknSwvzNcsySOYcrzI8s3bVBRc6MJkHG/CCtrmVREH3dKQKd2DQ9LoOK5WHXGI
	 HMXDsTrtS0LJA==
Date: Wed, 16 Jul 2025 11:38:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/165] 6.12.39-rc2 review
Message-ID: <ab5fec36-edf1-4534-8306-3a6ed7918e86@sirena.org.uk>
References: <20250715163544.327647627@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6OICdHCv96k5bUwZ"
Content-Disposition: inline
In-Reply-To: <20250715163544.327647627@linuxfoundation.org>
X-Cookie: osteopornosis:


--6OICdHCv96k5bUwZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 15, 2025 at 06:37:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.39 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--6OICdHCv96k5bUwZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmh3gTEACgkQJNaLcl1U
h9AxJAgAg523/sMc9hVhZsnelbk5SvSu0g5nwrgRo79k2R3mU1TB2baw7znXaPQw
w5qk813v6uv7pP+lmsyojho6COotZW3J1r4d77hdL8h8k1+eX/ViKKXKzslT2oPX
w9G1XFHKkq/j7+J/YV2ewg1PM1GmNg17bOUmsCK/NOkUIfME+UL8XQsYG8a0qSMZ
/A/thg2j/Y/6wsoa6m+LZlYTy+ENwsAqhBbzxVhUY8b+mvisnofqftoDlrvmRiHP
/FfxIL7H2iBGS1YH6bIHxq66o6n60hwJ/ZhvIjJH5B71C/iOqqR5UVD3IC0J4vQ0
eYXXjt1rjJebd4cJpcw7vUsoUZ/49g==
=S89h
-----END PGP SIGNATURE-----

--6OICdHCv96k5bUwZ--
