Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F746329E6D;
	Thu, 22 Jan 2026 13:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769088600; cv=none; b=koxsLcAEbZcLLBjV6+dmoQCT68ZBhzsunLzB5zYpLT4c/wgz8fhryVAIcHtOtauM+K2UFZmUfrJ6ljmCDgzaLH6+W48dlyXsGF2sK5S8NdHFVjgheX9XzyapNyLyop8BjGqci0zB5anUAHSlWt58o2cqFjDaVJsTO51X/H+AiUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769088600; c=relaxed/simple;
	bh=j16OdxVu7cymtCh8dnQR++a6SNKxWgDVaAkhwyd3QF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I/4hN06TXwEuSZH6bteMklM1XL5Do/lXBR0kIu6HxHO4rKSvpWK4n8cRLnBgObC1m/n83r9AJvhBypriptk7xUzRZr5gbkRvLSKpneaDNT21l/cVgKQzdx+tUmM/QRpkHk5e9vBL67I+Uqbq9WiGyTrTYrF6+KJS3wdyTAn/s1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BZqz90LK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BZqz90LK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D30EC116C6;
	Thu, 22 Jan 2026 13:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769088600;
	bh=j16OdxVu7cymtCh8dnQR++a6SNKxWgDVaAkhwyd3QF4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BZqz90LKsHdKl/22TXo6iQ+m4JVqGgCNpKYrLQZhVMYfO/V7uN8s+i7ewXeYBPc6k
	 HZWF4oIyaL5gnw3odAK9FN0U6zph3GkP1/mWXRY/6RrgRjWGvA7mR2bb6/HkKEISfz
	 NaSRKjbRUS4gbXCFsJYQP1wCOUDgnGf4ogQxfFG80fcwU+9k/CwHRA1/2B8g5jARm6
	 Q/X6TlDhrD7bGvsrIKy37xsJPR61jg+SHxlVjxnJg9dBGoWcMCuarNhqjNPeezWSJt
	 KrjKl5Nw/IAWlEf0owpT1OCwlGy4AT1k65zj+s7Yobz0tv4HLp8stlMZiKV6LBsFk0
	 bogd2y77+QxvA==
Date: Thu, 22 Jan 2026 13:29:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/139] 6.12.67-rc1 review
Message-ID: <4f0d9d57-2c0c-4e05-93ac-01d3ddcf5dd3@sirena.org.uk>
References: <20260121181411.452263583@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HFsI2e+kDhQet7m1"
Content-Disposition: inline
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
X-Cookie: Don't read everything you believe.


--HFsI2e+kDhQet7m1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 21, 2026 at 07:14:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.67 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--HFsI2e+kDhQet7m1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlyJlEACgkQJNaLcl1U
h9CzHgf/aiALH26UlJr/7pcHx1qAvRguvmmRNaiv1cXHwB77letexjIdF+W41oMx
R/mzyirDKKGplZKfN4Mg+6hzwVbjSOyGAE1+54+2T4eW5zk5sCLBLgSz8MGR/X1s
CSfzJC1uaxWfn+TGRQYywuc4YW6lFnZAbu/voz27Qm41z25vvB/yq2rPDwmsFB1z
pLW/1an3Z7PgIyFWmyD7TtyB3YpwcshbDT8wSwnDCiDYJiA9WPmnFHTrOHUYQWsw
tD+GgEBmup/TpP2dd/RapgHYQld92YMYAdmBf63ar3oHvnWeUAdOxmTmj/jhKU/1
7BArTZe03k5/l/Ixrk4mhWYffiedBw==
=B/To
-----END PGP SIGNATURE-----

--HFsI2e+kDhQet7m1--
