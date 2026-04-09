Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFA93368B2;
	Thu,  9 Apr 2026 22:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775773059; cv=none; b=R04UV+WqXEeaz8BuBcQTiCigeMxXT+210nHJoH+MahvOehiAf/0rPuquDOBHCN4twVNoTDl/Dl9nYFYTLlkjqZRxcK8PYA1xWYbIB+kHocCPzVOUNOspsMTdQVHwdIy00FJM8AI2LzwvIS6Sf0MpZSlEGFoGOYHXzwA8i5Gr/m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775773059; c=relaxed/simple;
	bh=pAsFdISmWbsRYsQ4huUESfCvXCnaR8hvqwkYDgkbCDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qx7WrkG9v6NZLCOLrWb6Lvr73pyi9Z0ExNIj3SZSU3F6PMkH4fNGx0Mo9bJt6HOII7RVnmr+bItkAJX2TpyQJayw9Vg9d+AfahEHpkwNj4n2VNMOstUApDRISov04VHd9G+SBt9GIDWx4hqMCOz6EB9CrL/0VVB1/BSXaApfDUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gw7nqfJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gw7nqfJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08DBC4CEF7;
	Thu,  9 Apr 2026 22:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775773059;
	bh=pAsFdISmWbsRYsQ4huUESfCvXCnaR8hvqwkYDgkbCDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gw7nqfJDjFTZkafI+ntG6HD4oZHC7j7+PxGGtIkFYR0YnwV333TXIPsnt70ZMgNS9
	 PqyTidjAo5zDXso9RiyQEF8Err0Sime8tC6GXoBtvAXse4gjR4O042M96hTpRjYHHS
	 ynhc5Wvgga1+lDlFk04KqabUx+zQY4otNXY+nciV3K/dbqFt9zch34qylBfC0EHEx4
	 LV+TddXDTfmduT3YdZtq/uGgfa77wVroDXRrpqln2vXrCpafAG5Yjc6zF7iy05Yw1y
	 HbdYgM/ntKKw/FJ7DAyVt3KWe/qHvNlzFnbXfpsqVJExQFk4K2Utsp/Yloga6EVp8v
	 0+GSJfvxpTZRg==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 20C5B1AC58A9; Thu, 09 Apr 2026 23:17:34 +0100 (BST)
Date: Thu, 9 Apr 2026 23:17:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/276] 6.18.22-rc2 review
Message-ID: <adglfvpKHvM8w4wN@sirena.co.uk>
References: <20260409092720.599045151@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="emSTwfywa0wALjKC"
Content-Disposition: inline
In-Reply-To: <20260409092720.599045151@linuxfoundation.org>
X-Cookie: You will be divorced within a year.


--emSTwfywa0wALjKC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 09, 2026 at 11:27:43AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.22 release.
> There are 276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--emSTwfywa0wALjKC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnYJX0ACgkQJNaLcl1U
h9BpnAf9G8AkSYyeQvm/hyEBu3scpMpDQNwdlcCx3DGMIXnDSowvJnG+n0PUU0A/
zB3ed7G2UDehmjSa+s1NhM55bOSbOVzXy/cxjKyCMKz7KpPR0NYOzJe9TCGIl37k
TMYFW92YtwL/iABAf7agF4DCTLhIHQgRKgYa4ZgDcLliijmhsoH7VsczVQrcRJvN
mUlNhMnIttLwjVlUfJsbZJwvjlXZfM5icgZR6PrMOy7hPYaA/k9PU3D66HVOz5pD
X8kOsOAUGBrvli85YSiv7v1LgmK9lBSAvAdNMKwRW8mVLBGd9Mk2ruV5lN66yhwg
25UqDKxDuIPdwNKx5KL3AOUJqYCKUw==
=cdDr
-----END PGP SIGNATURE-----

--emSTwfywa0wALjKC--
