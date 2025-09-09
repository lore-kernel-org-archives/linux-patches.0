Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DAB31B833;
	Tue,  9 Sep 2025 11:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757416924; cv=none; b=pa1ljUGO7QCnCU816ELoeRjXf7lQMHSnY8+WeVGUuuBaz0BOHBKwdhCPL3xYXpXKGZMKPPzl04lbGXNuNUDXqmU1aipzLotKOWyT0WRTbRs35r+VbW97OeCy29Ay0LYat+RG3I/11yr9FIBHnCUZByT7a9+v2OBFvA2Jmq/4IsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757416924; c=relaxed/simple;
	bh=0G9Av7ANIO2fUWuPDj0VHtC7wbKj6xDsSLiijqjtmYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9HW+zxSjK7n37qjGB9JxI/kcsWuKlU/WzGHpOQ+V6ftbZdqsnGjMCGLmqmG7SuaoDf0tT7EYz2A7i4wu2tWv/sdoPb92O9rsf15CQs7OksuvyYIVU9EOSYtEtSvcvIUqelfnZ1/VB0t3iyBc7jkpcjl6eChzcrKufe/5kW9NvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=glUFniJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="glUFniJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537D6C4CEF5;
	Tue,  9 Sep 2025 11:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757416923;
	bh=0G9Av7ANIO2fUWuPDj0VHtC7wbKj6xDsSLiijqjtmYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=glUFniJeEhLZD1YxKBvf4pFAF/AAejsrUDtc1l7ovHctHOc8IRnfddYocSCTW8lGL
	 nCejM5YKqMTKeFVHYj19Ia+NqxnRGxkM1FY+VMc15OEck+ePcBraN9CRdmYytBXtw4
	 yt+FB9YfHcKhVtmyAtfN5tyb3VSaC1cp3MjLjVpv9Umk1qqFjwm/YHA14bP9lQe+CT
	 CcSZwXiK/D8AXKWSSgHYrQIKeb/wk9XbPqwjWvyf09wlJmBlEZQmwFNRL0wgLa/zrO
	 glcpgYWKuAzhuCpPqrUfE2E0FaYWYAWgKZ99afXCcU1At6VO3y87qAlkh1VaTa759d
	 cxSVG0KFcReJQ==
Date: Tue, 9 Sep 2025 12:21:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.12 000/175] 6.12.46-rc1 review
Message-ID: <f786cc74-8fd2-475a-aae9-bef837aa09af@sirena.org.uk>
References: <20250907195614.892725141@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2qE3M5PPISUPH2Qr"
Content-Disposition: inline
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
X-Cookie: Ma Bell is a mean mother!


--2qE3M5PPISUPH2Qr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 07, 2025 at 09:56:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.46 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--2qE3M5PPISUPH2Qr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjADdQACgkQJNaLcl1U
h9AHFQf+LCw2ijwrndK6hoHt3E/FqdgcxQUPWJGtmZI6WXZjM7/xevXsVHLT/Np1
ZfkHZ+drpvLr9w9BEmwJsKHv9vXrIoexlZ9FOp/X+gO2QFcVmjfWqg3ySjAlRf18
1P/0S/9D/te5DisgFFda7+nhjyt+KaFQoh+F3TAQk7cV3gPDWsLnzg4TYnC8EbR0
k7mxmsY/z9c8EsYYymKAUnIoN6wAqUQma9GmezOY9gJ0Wh9BYStslLAt5CidWiLE
3gg3uHmyii2RVUB1DkkWs6D4eBP3WNQ2rqDdb9MaWLUgP+HPGL1gm2mXVPW+zZ/d
6s13+oGtS04jH/qwCbYMfwn7yJtKyw==
=du1U
-----END PGP SIGNATURE-----

--2qE3M5PPISUPH2Qr--
