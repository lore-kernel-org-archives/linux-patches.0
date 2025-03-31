Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B4B186E26;
	Mon, 31 Mar 2025 11:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743422335; cv=none; b=TECoeiBpDgpy4mCVe9yeXldJk2VHNIFko7VdGTzHCIWN0G8AJ3i6BzkXYhF5EgH7OgYulDjAgSbJ4UcScX3tw7gy+C1ZjyzWKaLA+l06XF/EyZTad5sCyCZFZ4jym4JStwIVFkH0fg85RZ9JUODxC9Ki12dGBEssSz+gknfHwe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743422335; c=relaxed/simple;
	bh=RoUnhbjaNYgHZl/Z3GXAaL4Alhva+vya60vU6QOyoaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mAx/ZhnPEiaCC99wV5LRWTrmTivfO1nKS1or3MngWUJsABJiUg8PI6Ara+zY+opE175HHpQsFykICh/a/jYxom502UoY6XgAxRdFMYfZmuVWHq81RKv9gavZ4PV6W+/Ticd2j/JK9pXqqinLlyuLo1PyOz0RmvQ4DbYYWY0tHtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T309ikXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T309ikXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F46DC4CEE5;
	Mon, 31 Mar 2025 11:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743422334;
	bh=RoUnhbjaNYgHZl/Z3GXAaL4Alhva+vya60vU6QOyoaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T309ikXq7aE+8/HgKX8jdcItIU88OnbtC4Wmm+oKUyEL1moZ125WmHXp/PYfGyIFc
	 sDwhsZgWPqEuhk8kAzUmh96Mj4u8ppibNtYc4KCPh4Itd0SpXmOpsPN8xc3djs5/0p
	 2QcHRbuNDqujW9uydsv7Q0JEoRH2GAPY8fuW73sM8cxl7PGNfr3f1WiYqSjY35Sd08
	 X0+FhBGET0QSXRB/L/x9rkde8QVUu5QnvrkpaxC13xEJdHsPhsEyt6s9eyXffq0Vo9
	 0CFFQ+xtc8lOLE2N7Fo5AKb9V0hC4lP7F2rUnHhckPeD5Sb8X6hiwuHxliR8oqzgzk
	 Wu3Wg6p/DNq8g==
Date: Mon, 31 Mar 2025 12:58:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 00/75] 6.6.85-rc3 review
Message-ID: <f4416603-37c3-4d5a-8aac-5b90d211a7c3@sirena.org.uk>
References: <20250328145011.672606157@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="60hqtlt4YgjpDmdK"
Content-Disposition: inline
In-Reply-To: <20250328145011.672606157@linuxfoundation.org>
X-Cookie: The Ranger isn't gonna like it, Yogi.


--60hqtlt4YgjpDmdK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 28, 2025 at 03:50:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.85 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--60hqtlt4YgjpDmdK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfqg3cACgkQJNaLcl1U
h9B0/wf/dKA62N5h3MlKo/2pXL2hAJ9Q4OZV5rRoE0QGY74OW06ipOazKDrW7M7O
cVrpsl/z0dFKHtzB7r1k31SPB1lYNhPbzl4GzKv8UVH/ZrpAoohh7fMFKI5+HJGU
XuIbEhqz4siWGYqGR3psEU9u+WVZU/pdnTBiaLbpFO1rzfDc9ifZbG300lLio6UN
PSmLxEJWbLFvSmaFEcM+ihROD4Um6us81YQhXtGfIYnWv9/W3iuwlgxng0TG3hyE
U2SII/qUd1Yrld84lHykfmuBEzwQPnMei743A1OHajDEunHBsHtaGtQ2VdbAWfI+
r8/xNa7F28k90glB6HNZbRFBjj25UA==
=9XO6
-----END PGP SIGNATURE-----

--60hqtlt4YgjpDmdK--
