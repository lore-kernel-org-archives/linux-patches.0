Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A53520CCD8;
	Tue,  8 Apr 2025 15:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744124913; cv=none; b=laed6OAe6S5Hrfhxv7AXPZA/5nSJpcBh+iG5iAHWc+fquGRCx/+dLHN1iw7qbjeb4WVj/LBQOIDl8arRhVZwqkoyDreYKeV3wdxDgB3EKChSj5d7DbytFMKbX61NR4apmJ42hiExuokjWwjpk3NyDtY/6BjZSnDpUNXCV5GzzgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744124913; c=relaxed/simple;
	bh=JBSEhYTiF3dCbBssXzfhDL3rbz3n1CbLkfVob8lCBrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYrqmkcOyv6LD1nhc/DaxrGotakPn2XvUw80EuOKdyfL5l8kw7TC2dS9+I1IHu8UR4ULPZzeWiyNpMcZEFhShZE3s2hMDnljZpzf+s34gXp45rnfdBHAfX1IcvZ5M5X/sYNpOpjGx6cI5UW6DMTGBFeCZMY3Kv6hK4Ko6J5kaX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qatpTiUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qatpTiUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85F2C4CEE5;
	Tue,  8 Apr 2025 15:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744124913;
	bh=JBSEhYTiF3dCbBssXzfhDL3rbz3n1CbLkfVob8lCBrU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qatpTiUo8VYFEaWh/buAqDeMhBZSmJ5NIr1ZGzPzkTzCKkfkUAlyz3jhypmJQvl7U
	 qjlOU4MxBc6UggUq9IHdSpL4fCwgmpWrYM5VmnmsyDENFQwwLB5QWbCR3eouFRZ14Z
	 rZB/Ogl6UIENbhI8pssoskbkd/9AwN/IcMOd/Hbn/EX2yVSVKBCQIrSUFq0HBgZ2my
	 9vvOcwghJIETf5GMGKncxkGdOTcC95bHywqxX756+lcIpy9kASp3x9W6wPBjgR4yp7
	 NdZeuhbEr73aNcPFq2lFT4pIrDzpfDiVRYSWI5clHWLa+HnPQIi1xUhfINmomMMu6r
	 OQ+RQw3GvSDmw==
Date: Tue, 8 Apr 2025 16:08:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 000/279] 5.15.180-rc1 review
Message-ID: <6a7c376d-0463-4076-a0de-fd9db412b154@sirena.org.uk>
References: <20250408104826.319283234@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ImMI/PLx3ohRormq"
Content-Disposition: inline
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
X-Cookie: Meester, do you vant to buy a duck?


--ImMI/PLx3ohRormq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 08, 2025 at 12:46:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.180 release.
> There are 279 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ImMI/PLx3ohRormq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmf1O+oACgkQJNaLcl1U
h9DdKwf/cOe6mcLF85BQW2F+UuTZhL9RSao/tM9S/kriGE/cPlkb7NgtgaLAMmVc
srWc6ZA/OBLxZwwaN7L2dDcfa8lNMrRUFYG3OoDGfbU0c3mB4CmltRDcJNcpaV9u
LSbjyTMCBYetIjmIZFvs2fhTevvxG5wt308xqq8lFLAW4BiW0QZgHcxpUjbwef2W
tyMXj19hiUq1nODHe5IF49klG10IVg9yZLEhD9TBDYBBQiUP5DbsBxKuVScCVTzo
2xrNSbsr3YBsRga4St1fpCiT/oObO60fIJo7pez0NOg494/HuGkf0uTx0OTp0AAZ
JZOUHcDChaoxJu71ugYZMKivdrw3pA==
=PjrS
-----END PGP SIGNATURE-----

--ImMI/PLx3ohRormq--
