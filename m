Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC95402B9C;
	Tue, 24 Mar 2026 15:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774364587; cv=none; b=bwjG7buoVou0VzNPYduVL5G0H2WtTfBRg73384ahFVa8w0LtaX1HiPmUArqRY9+uq7Fqfh1LjP7e29bGQr0vNPFBDqwPuhZ9kMqAobT3arBq6jZXRJtGNT6YSlJd8EUwI1b33K1RxhiJTeZ7d4h1sjjxYxAJTmmUN3UVd0wVOwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774364587; c=relaxed/simple;
	bh=NQX133cNkUeBX2KYRN4dsN5boPR9kt+1twGrTejzxfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I1GQ3qW5BGV+szlyS3p03t2+ft11vTAm+dVBtzZ2lL8j44TQWvLAy/ErfblS/BT+U39FCa+ML2G86U2IuMM6LV8d7T/7AWHrNIGa4YlnedptrY/YrSYfY3GwgXf1dKGiHvzw5VcGsLt/q/2eSire8YWzeTQLPv500bWU/HUdHhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ewmkPnRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ewmkPnRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E16C2BC87;
	Tue, 24 Mar 2026 15:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774364586;
	bh=NQX133cNkUeBX2KYRN4dsN5boPR9kt+1twGrTejzxfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ewmkPnRlZMDtD8FGtnjvYBXugu8z4Gdj6J3b04+2OpvJa1czkGfnmNQYjd2W0G81+
	 mMJ1TdlGohRPt5Ot+9iYBJPbzPi9g7JCWkMFJo9xju5WQ0XHtAhrNpKeipnWIpvstl
	 EQfxTCc7DdAlCkzMu9xzPjtWFeJvXEXNvinQZOiZzWViUJspkfqab4s9Yn0MZD+/2x
	 8v0obXWKkd1fn3YF32KBz5Qgz74+NeD+UQU5YpF885rliOznO+QnkNOEpNK0qXZtUe
	 YvpJRa8ZV2mJgIPRCxBvjdWBfiG/DdO7M3D/UQqRsNC1BgKDDlzjZhpXI2cf9OjG49
	 Ihx95yz3umFDw==
Date: Tue, 24 Mar 2026 15:03:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/460] 6.12.78-rc1 review
Message-ID: <cc8c766e-a1ec-46cc-86c8-c64ec61b4500@sirena.org.uk>
References: <20260323134526.647552166@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gY4wDyy8yqrUzcp1"
Content-Disposition: inline
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
X-Cookie: Forest fires cause Smokey Bears.


--gY4wDyy8yqrUzcp1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 23, 2026 at 02:39:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.78 release.
> There are 460 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--gY4wDyy8yqrUzcp1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnCp6MACgkQJNaLcl1U
h9D04Qf8DIyJQyv+8+9aQH6S2AlygHVJuBCc7O4J1McM3XmFF19Lg67O/7chti1/
PsJUFGsWGEH26ipitNlvKzVs9mb6UdHkmgV/a09DYq6LYW37pqHxJE5ADFJmT/wx
1vy/SKBJua+FcwfEW4UJCAfYUR3+5WyH+39Wf+G7vuYsU0jGmtO0iBlk9BkTdqFr
JVf5D7Trc6LcX3W1Jd2lh7MbWIJw+CVo2euBCHKUEMz3r4USYvgt2oF+CrW+ZFIe
7c8LEmrQ9aDZkjQ+YQey8Lp6CXKxrQX9BEAfkljviULprovul1ywbZ53JjTWyKkr
aCIzuK01paKF1lZ4kKRAmqAeanwi3w==
=H8v+
-----END PGP SIGNATURE-----

--gY4wDyy8yqrUzcp1--
