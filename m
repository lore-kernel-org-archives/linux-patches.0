Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990C13D8909;
	Fri,  3 Jul 2026 13:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783086984; cv=none; b=WBO8i3w2yXQnbyYLBaEXHEoMJIpIJ8kr38eDNC9eUM+nZQ8wptzOU6XZG/jcsDA2+z7r9k7xqVdsIUWIE/GcBKjfl2kcvNRNwmMJNBxm5Y+89tUmoFe1bdvKw3I9XK1yKuqddlE9DO7m+o4dF32owKf0VA0VFiimVnx0VKlFnYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783086984; c=relaxed/simple;
	bh=YPZdfbp1waqnZBrRki+mXPeyVy5JgFIpXYkWpBTYSEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b3PRuvzt6LhSGf2DEZDlR4qu+yjLqx+3Woxt7mrB+OQ/uV+U6PldNU+5rvNyIfL59Lr+1jWhx4ZAB+DyxQlbrBg7f7KTvReHHhuBIbU/ylWZZ0qh8BqRF3lHYvHqO8dHtwuW96Lb97SBuUq9SmGGX4WKWBNBK+38QUJM5QlmlGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hmAql/s/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hmAql/s/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC591F000E9;
	Fri,  3 Jul 2026 13:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783086983;
	bh=FTOQ4y0QRMFE9XJVWqlCgNsY3R4ROSrfVmhOoYVofbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hmAql/s/NncF4d805KRl1gDKwXnt9KFSxuW41HF1isp0+SR1+nrK/ESsbuThrB7IA
	 lhPNDR2eROomGuari4CsuCulR1+94j4RxjBJmRgsdFF4YWhcScSgpNnXkfWb/g5qbp
	 +lQHZvau384jsTOWoJWcKa6NgG51IMw7lBalddDWMetURsUr+SULkw7r0d2HaaglHl
	 06uCFz7m1bGN+yhe5EcT0U2ZlEU0BdNhEb3LgZBnnmzx+J17O7SDjdQQ0J6Vl1g+gb
	 4fJyTG6av/Wsdm7HroBwsdmBIDilBSyn96/FT7ZIGEAZVLo5Rw+OJTiiQ/UNxwlZAR
	 edd9mZumeFSQA==
Date: Fri, 3 Jul 2026 14:56:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 00/95] 5.15.211-rc1 review
Message-ID: <80a5bfa2-145c-4ca8-ba35-19f9870ef822@sirena.org.uk>
References: <20260702155109.196223802@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lJnslHdZZxGPh8xo"
Content-Disposition: inline
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
X-Cookie: You will contract a rare disease.


--lJnslHdZZxGPh8xo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 02, 2026 at 06:19:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.211 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--lJnslHdZZxGPh8xo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpHv4AACgkQJNaLcl1U
h9Bwpgf/QDlpG6SBv8WTTPUuucaSbYsRxlUJc+Gn/eeBB+yHDh2uS3K0kaaHko+N
4Db8AfV+59aryJZB8I0jfReivQECE8YYVjTjJV4TCEuQKFKkwSMjcDgbUfaFqBP5
nzfkYWLbRp7oFNOM2EU2bnTxw8xN5JnnfdJ64GkRfQ+rVwx5rpO0P7wvPNjNwiiE
elqUP4nx4L46qx2+VPLyLfc2yv/vMpLnVvpO2N0GPqen2qLAomxLESofnuCsUWMm
vhDFIKghYEXUh1tRwi+ilZ+lYfdu8x9BkLxTDquT2i7717PnC0k9l1u/kh0+oyxH
0aGFMp8CMy8bfxOdvSaR5xy7UeMgvw==
=KAyP
-----END PGP SIGNATURE-----

--lJnslHdZZxGPh8xo--
