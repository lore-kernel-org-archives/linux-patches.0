Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452C9224B05;
	Sat, 16 May 2026 06:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778913430; cv=none; b=K1UTjELOMjQ1Uj1SgOUf2vGn9kRzHWllj3Jv1KuhjH0L35uGF3wCZEWEZxPRHkrM6Jsz4D9diXmGA8YHZSeD6oAHxYdwo/D6pujN799CTy0TUwFiUvriNJl4P6rOuRP7MpO53Ca3K9+TUbDmQV5iHmqaizUAFaYH7+jTXv+hhIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778913430; c=relaxed/simple;
	bh=LWkWAWP6eI4XKXrrgtNMtmAL0dEIrzKzmOCmlNdbbXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXGdpaNlL1QedgJb+v8YTBqcPgnzivD6P27B35gisptE7DJI1ik7p/Wp8bk7orusWxrdrLL/FC+4YkSBovYfAL5IOCcx2nJKlsw+X6IxIUVDKGifarteqcUAV3+02+i8j0kCegHvBgjhO8w3CslZt4k2X/Ry1DITI+PUFNi63LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wm6H/cUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wm6H/cUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8703C19425;
	Sat, 16 May 2026 06:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778913429;
	bh=LWkWAWP6eI4XKXrrgtNMtmAL0dEIrzKzmOCmlNdbbXE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wm6H/cUY4Doa4wWCROy3X+Rrsi4SmOx0GYqiexHRDrcef8SoHHoChGftm5ZEPsW2c
	 SgIN1rrvW8dHaA4LHcQ+A8tF/zzSrWmanZLfkxGZvQpTEO/GXhotHZ5QQCR8cBLGjT
	 E43hMX49isDDCkkj8msHAX1Mw6910EIdnvXOOhM2eltMVF0VWB4mgfck2zhK9di2+M
	 RRgXWuxV7T7a5CjDvJx1qdxdvqxj3hLhTXX6VKcV8VPASoxD13fhsiOuTdp7Po9/CD
	 gH8dFi9RZ18bzdeYNayYQY2pcHST/8jdxFpkFKfkMKjwKHFFG3hCU4H7AbbEZs06Gc
	 2/ZqZQjn083LQ==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 5A0C21AC5A48; Sat, 16 May 2026 07:37:06 +0100 (BST)
Date: Sat, 16 May 2026 15:37:06 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/188] 6.18.32-rc1 review
Message-ID: <aggQkmBHwF-hvVle@sirena.co.uk>
References: <20260515154657.309489048@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mNe4kfQQe3bbVonO"
Content-Disposition: inline
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
X-Cookie: Truckers welcome.


--mNe4kfQQe3bbVonO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 15, 2026 at 05:46:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.32 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--mNe4kfQQe3bbVonO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoIEJEACgkQJNaLcl1U
h9A4qQf+NHTe5hCieVnxmgZx1bYEG0LEbaH/8ak1hJbEB1dWZgSjSlL4RIk7WGMd
DaoLbOzqwecpS6wHqYCJZeQZ+DLKX6X0DV2n6NuFFmhoHMi9joX7uYHqXwBjTp+g
qASeVm/b4z9oUwnSsovXaGWkOJSVwZQx2uHOkLvwfbFn+PuwAzHVGP857/DGmcPG
h1sEY4OsFjOSBGoMEFSnFnUBYt9YhCD34VvS66CJpegP5aWqdRaQfG6AlROjFKHz
R7Uh1Gr25/YlXweD9xoZTcmvBLK6hlXHsAXmmUlylSfVis7mHnBe9FZ/TXYmmjpx
df5kYKM+oNUaGY128I1StrrQscS2lQ==
=UTBD
-----END PGP SIGNATURE-----

--mNe4kfQQe3bbVonO--
