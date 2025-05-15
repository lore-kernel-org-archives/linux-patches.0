Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963D9201268;
	Thu, 15 May 2025 07:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747294130; cv=none; b=gk0r9lGZGX/5O3+3FlbD3GhG+/fLYWSCxzNAcJ4w+QKhQR1hTrJnrN5yx36z+Y+BPGmaw3FUGbH/oenz76XtK2tRD5HVYViC0l3ta4S+5sI9oQrOT6HQD4slcreghWUeRS6f2ZD8RYufUO1VkTq34fVR5L0zAsiTstvvAkTYIdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747294130; c=relaxed/simple;
	bh=hafwXR36EMxvqkpSmEhncwunmZ49Lryi/C1Hogduf4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iDTE0zd6jM7mF12KdaBocGOjnPMrdVfETmGtphYrncahdmYwF3PSjq+8kDpDdFMUAYcs0QNmMC1PGo5CZxB78zGe+JKH4K4wjvj3p7OsZjwzK/6l6xKIXT4YscucWIvzC80xHogx0gLJHaCeHLDmby+Axz93ZUKPg2FAU0twNJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eutej4SB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eutej4SB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D70DC4CEE7;
	Thu, 15 May 2025 07:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747294130;
	bh=hafwXR36EMxvqkpSmEhncwunmZ49Lryi/C1Hogduf4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Eutej4SBJkPxuFpGx/jIjCG1gaBbVHCuhUsvfkHqQvOTeRPmom/ea/icCCM62vpsL
	 M534gxjWxV/n1NlzODc+8zgpmHVJMElVw5UfNDaouptuLzjP9siATGlgvlsRkoOl4z
	 lKeLOW8O9wsAO01XqXfAe/TGLPz9O6niNllCAcosBGy2V05eTuxbwNuu3rY90mTbmG
	 6lWPNNHMo5Hww0o+MmD3oyIuEL+guCQwyRRDfw0hnjwmIGmmdie1bvScFffbbxT7Q8
	 jGVj2Mosvsd+J+klGPHaSYsF95MHlS1k6Zq8Ay8lZcmy3ENJ17afep2f/hOboxgDHX
	 KURnUOoyfIgwA==
Date: Thu, 15 May 2025 09:28:45 +0200
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc2 review
Message-ID: <aCWXra9vbzSrtA68@finisterre.sirena.org.uk>
References: <20250514125625.496402993@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XhpwyD56vIH6YWQQ"
Content-Disposition: inline
In-Reply-To: <20250514125625.496402993@linuxfoundation.org>
X-Cookie: Well begun is half done.


--XhpwyD56vIH6YWQQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 14, 2025 at 03:04:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--XhpwyD56vIH6YWQQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgll60ACgkQJNaLcl1U
h9BExwf9Hat45yE39oBIYCEZc7Y8sYT7ch0RwgPKCYBfjJzaBzninX3AXhQ9aNJA
3FNjuv6UDGAFkrnEgzMti1l08j7AG26ISF/qYEru7zhQr7cJnrCvi8cSAKe/Ngok
LXiuielkWgmgQSiGCUIuNc4syGHHLY0H1edgWM4dKC7Lo2+5EwVV4rMusyHFAag1
xywvInRXHX38OlvMPaxgTbc7fb7Smyd1/KE7NE/Qt8iR3ukgT2T991nz7YHHFSta
+Bt+M+99AzEqbtzzR2yG/7eq6/cSaS0NA9foaZCn3i9wT4E2qT9VsX0QEUWN0IbN
Pfpg1Bj5OMkX/nT0aEptI7i7aHSLBA==
=b+qi
-----END PGP SIGNATURE-----

--XhpwyD56vIH6YWQQ--
