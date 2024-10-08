Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A5A224CC;
	Tue,  8 Oct 2024 17:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728408357; cv=none; b=d36tT4fDUHoybT/80jeWIUjpZx2N8L8lfRJSHLhIOE1fGSm8dC2hJMcekLt5RyOWd1uQEPeN/TrvQqRu2h2qF71H9yPCl5tGcmMix+7odB3yH/cS0VyXXT+r0BryZpgcC481VHU0/au5Sj50D3LLbRrzaf90XwtfTYqGLusUnCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728408357; c=relaxed/simple;
	bh=Hjz6XkiNgCb1MenPzZFmfFhE1r1HWM7T4N5G0KbzeCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I/lNHsgex+UwmknxH2zSN+M84KCOU+dPf1ZHwx4BaEuOJtTWy3kC9xJXCz1r8qig6hIL9qs8FTIkxQHM5CEDs+EcyhUB+8c0Y4XALxj6XR/LqsUeuC3lDsH42JK6fcrG6uvWh+bD9jPMFnxgKxOQjfh5qiwPNYxuQifEYf4Xg4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6IspTDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6IspTDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AD1C4CEC7;
	Tue,  8 Oct 2024 17:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728408356;
	bh=Hjz6XkiNgCb1MenPzZFmfFhE1r1HWM7T4N5G0KbzeCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C6IspTDWSxAImvLYaSzeJQnFJXH8eEZOfjMbLiY2gjujSPyHZ/wFoPEsK86l3Ke+n
	 5DYzneZMXandf/2loyeMIjyVrK+5eGn9Zp5GhhK0RweUe8s5BgNgktY3z5m2q/dHtn
	 /byC0AKe15lldQKdwFnAem47TXXwsfETQFN/3qFOkhq89xFm+iAAKwTHoXlY63/FjG
	 xFKB9odB7h9frlTen2QPU+nMdBCTM6R9jNd3I8uPPb/BD3dFY3+NZPaxu4Vdxnv6GH
	 Cu2VfAAan6RzbfCAhQrzy1HIfrZd0TsqpsdgYgU3/pYTjmBk5SYqDhEEmzSb2+IOQP
	 IkI5k8aB0n4NQ==
Date: Tue, 8 Oct 2024 18:25:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.10 000/482] 6.10.14-rc1 review
Message-ID: <ZwVrIReWuOEFZ4_T@finisterre.sirena.org.uk>
References: <20241008115648.280954295@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cdywWs774iHWwz0i"
Content-Disposition: inline
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--cdywWs774iHWwz0i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 08, 2024 at 02:01:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.14 release.
> There are 482 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--cdywWs774iHWwz0i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcFayEACgkQJNaLcl1U
h9CZUwf+I8l2eNJ+T7YdESoYLD0mqEgefYYc+GOuAgx5EwNR1cwnwzYz+Bmh1yHZ
9ZDRa7t0A3v6863i3hzceggGCD1eUHzxgCdRilM6YmglMieQFpTMfT22+g3ihHgb
AkJtI2VnP6LJiyyXSsKMj5TTQNYhzBFFsxw6mOh15SM8Y3btwsS7Rs4xRMa9J8nF
Q8EsPy+fxLe5DROEgI4ILx0cTM1/okAUwN9AOemUTY/r9bJZ85XyjyunNvU/9JRW
N9AjgY3B+V9YRaX1MKBlja41TsRMIoy0lYQfZnJR2HsK/dksC5DmjM/roSVa+lSw
Q2jZhGvziY+FNw22lPhm4u0WIzQZTw==
=GuWI
-----END PGP SIGNATURE-----

--cdywWs774iHWwz0i--
