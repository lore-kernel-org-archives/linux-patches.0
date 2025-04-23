Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A632701BF;
	Wed, 23 Apr 2025 23:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745452397; cv=none; b=IzcnT7+0cdnZ1B/qY0JVvTJ+DoPK9y0wtIRKWt0kggbFAQbME39S+qluZnJkTWmjMcoT46Gid9uSSXjaTyFfWsYI+h2FG8P+xLMr1JGDkr2PGOZWhbbW7GnNjL560tqUKhW4J14zQ32f4G+/xA/91UtCN/73qZlVKo7lDWBbhyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745452397; c=relaxed/simple;
	bh=LKZ8WDVups/cSbg6PfhtjO/9jCUFWrVl4Ib2YrPjV/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BBs8VLWloogk1HJ5kuLOvwhbYwWgMhayVX7z1U9IgvgAjQ6YcVuAq2WyFytwsdNYIHUs1JZPeysBp7A6fjUlBlPg/VS0ULd8XSInpF0yBLanlfJCispciEWkvhzkOnmM9vpciBDudOLdKF6yyKKoPbvVKKvgTaUTtx8iloU5NT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nEXhUi/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nEXhUi/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DDAC4CEE2;
	Wed, 23 Apr 2025 23:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745452396;
	bh=LKZ8WDVups/cSbg6PfhtjO/9jCUFWrVl4Ib2YrPjV/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nEXhUi/w5lCf5ulo/WaabdxBqopRStRmUO/erZGbsfru8a97xcmIomifh0vkWYuU8
	 VEKfhYrTnSlSd9g8IOGz4V2LkBNCbtjqc4fo58Mq3jPmMEMVVofYqm1EgW1EpmrLxG
	 JfC07bNJkKHFvneZWdEUbrqcqRkUgb86zXqKh+5xEHtDBf6X4jaaJx527sm73jCa2n
	 uhObi4GluyDJlTi18D44HwJUBFBez5NpoSiExcgUykbwPpnAcs04YHIp5g8fQkXkKA
	 t1IKIl7pD0KYhwMPAosvdxBaE1EK9dkEnOj/0p/m8/vQoe/e7IQL0zLTUOoMWI5Fmz
	 Ay+fQBSQyX4iw==
Date: Thu, 24 Apr 2025 00:53:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/223] 6.12.25-rc1 review
Message-ID: <aAl9ZoXhgHJC9FIO@finisterre.sirena.org.uk>
References: <20250423142617.120834124@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="t5fy1SBapOVoPIRn"
Content-Disposition: inline
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
X-Cookie: Well begun is half done.


--t5fy1SBapOVoPIRn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2025 at 04:41:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.25 release.
> There are 223 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--t5fy1SBapOVoPIRn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgJfWYACgkQJNaLcl1U
h9ArOQgAglSXBIdE+e9TeIRpCr0m0FNKWnLt6lRXAPQk0XLRp5uavjUpTX+wqzZm
Yb0DadxxDpPGXaoGJNRlEO9sBwa+h6xsa8w9IGgwH8pLNZWu2yUCYOg5ie29Z1/x
LOb9dttQjUpEpm5j/Kv5EMU556cN6J6GEkiCtekjpCyphT90FU2cFPdg9Zs87pd5
gaBQNrPx4Xh40aqcaIVDy5uYcQgGsP/BH7TgpqknDH4AxNJuWk1trhTJvjW8AWXp
cNuXiZ4XLJBNUn44zGlo6uoQIEJWYd5jMjVZxiolBVajILGK8Lp7WuVGF1b1atsR
b2tCHhYScpO1uuGABnttRbb5xH4+HA==
=6gWN
-----END PGP SIGNATURE-----

--t5fy1SBapOVoPIRn--
