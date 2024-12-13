Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54083383;
	Fri, 13 Dec 2024 13:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734095941; cv=none; b=tavHyz4uP3VtMkR3hhOR7TXdPlOKxOm4T7V5lR99xnxPYo8ipySX4BZG6dU/hYJb5E3NReYWNRPMuaAxPQp15mDJfzYk+jLpiudfoa0ATkwurTfN0OeEShCIO2ztf3Kmr0gIRwEOTseTRnV/t4lr1crqkL2wpTWDFzCnNGFxjWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734095941; c=relaxed/simple;
	bh=jaA5ktBleW4NLvPsGKpAMNdG5nc/qAtOEusH+yvCunA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfUSsp6hs7Ux3dTpneWfB7A7VPH0Z7A4aD3ufs8tK7BI0eFcJ23m3IEf2wD3hM36Ph7ctaUm0E4BgXTyEvx6D2ehP4Yh61+Fc6C5VVEAgPdiv3UCXdvL9vNIshTnERIwOKddgFkKLwf/zzGJUQljzJKidW6SyvNOJZ1m8HdmVXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G15D2AUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G15D2AUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F63FC4CED0;
	Fri, 13 Dec 2024 13:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734095940;
	bh=jaA5ktBleW4NLvPsGKpAMNdG5nc/qAtOEusH+yvCunA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G15D2AUeSe42ITVggRXYveSiySjIH6/VkL5H5Fl2YuTlKjgol/sagsBx7uVEkSxFL
	 cOxEoT0XAzj1PvQl0MVsldqwFpP5qjmrgzxSJegQ5s8tNNqmb+lkfd1e45LIJljZyG
	 6xfnvww2bZPpLsOQBUEkI7p3QfQYTT/1QZUbK3u6gMCPmg5UTIwwPf5J/7TK/s5k/x
	 J4cFnq5wvkXwiZskz/USBm7z+Lw6BERGRnSAXM2WO3ILhFoVZAzaDvvutX6eKxP+XS
	 PFKKSWB0bPa0r+jimgr16SsI3sexDiW94uVzWrrLsCLqwgwqTcwn7GFAeGW20vf5rH
	 HNlq+OcBg14MQ==
Date: Fri, 13 Dec 2024 13:18:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/356] 6.6.66-rc1 review
Message-ID: <47630e19-4efd-4918-a738-3aaab0f9c5e7@sirena.org.uk>
References: <20241212144244.601729511@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5jKmm/3/j55ZHj/s"
Content-Disposition: inline
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
X-Cookie: Not for human consumption.


--5jKmm/3/j55ZHj/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 12, 2024 at 03:55:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.66 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--5jKmm/3/j55ZHj/s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdcND4ACgkQJNaLcl1U
h9AjxAf/V93G5JUEw2fRvntWUxzSOHVabrCDfVjiXdeDwySNfWEfu11Y+F3Ci+/Z
zBBH03Z/gDwffudSY/3Gp9lxyEUVSwjF/GW8o3Cyk3cNOoEcMjXtZJ4dxGcMKWJ3
XvEMUgwrm+YW7/Uo+B6A88IHv/mTOE6Eb6XzprmawfcnI6Ff5sbj02WaSt26Cp4d
8YgeSo5J9YDgkQA18L6uwcHP/aTqnIgbB3ZiQ0jXyiK5XLN/Xoh5vKbXegkbsilr
BkjYoaXJ2N8lZTNIbTmfwAVBL1CvEObKZ2OZjbSZYuxqpvYYEeZ/jCFrmnX8TDzc
OmtnqO9FcMS1a/28kjhHtUeUQ3zDMQ==
=x2K1
-----END PGP SIGNATURE-----

--5jKmm/3/j55ZHj/s--
