Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668D61A239C;
	Wed, 18 Dec 2024 12:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734526147; cv=none; b=AQYTr2MdH4F6AGLAnY/jNjnhjLVSIg0qdDBYeuLpg07wClDSSNlQJfD8xpWeu+R//ZJB+/5C/hzR5bgavRNPAioUyqCfkG4U36fUA16uyFAUCXMNuTZN15Wf0Ujg8UloJThK8JeIfR1ASbhf1ICunsTtwSQkFdXw8ySPxMy+Kuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734526147; c=relaxed/simple;
	bh=mBQwI+cnK1k1uEuUVT7gERy7qo3RvlOkppqHmLhL/Ks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tdcZU4E5Hau6IBIyOge/jQzQfnIW/UUjY1stVnUJkEKULuZ92GIYOxhKJd6OkciMZ+BwSX6g8KmIX3vTw5ZHG2peouDKLxcdadm8Z0c510gi6vpMRXZdUE/pJB3pcH3gdcGDFQfvcTk+/6b9HhGGsyML5XYlEvwVqfmDEWTKLfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=esknDwA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="esknDwA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DFDC4CED7;
	Wed, 18 Dec 2024 12:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734526147;
	bh=mBQwI+cnK1k1uEuUVT7gERy7qo3RvlOkppqHmLhL/Ks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=esknDwA0TuRRB8DK8XkDQX1JjdHwmciz1624ZXMQ6f+yRLb/3sE4MJxm1qMqYEInH
	 yCJBDuam0warigGHMhkIgn2toYGBgK2DJ1rbcVjzRhYq4mbkrFNwSjJMweE8vI99Sx
	 a1dlNqFb1ykHECCt9dD1s5bLr3g34G48DUlp/EDXksx/6fVXmmBwLzHxVtdjEFewXp
	 zTlZS2nSMfpLFr2x8Q8OlHxddaWIH1caT1G45awuIcDQlxn1YJuwTQ5q34sRkaC7X+
	 172XuDG6DAJS4xPu36UTFCkHml4Y5w/IJscujkoUx5+iiNTg/7taf4RQB7nrOPC7JE
	 RIEP1Vd8Wjl9w==
Date: Wed, 18 Dec 2024 12:49:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 00/76] 6.1.121-rc1 review
Message-ID: <d0ae20eb-08e6-4c91-b1f0-09cef5aba9e8@sirena.org.uk>
References: <20241217170526.232803729@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lcG8jNfFY07Alc24"
Content-Disposition: inline
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
X-Cookie: The heart is wiser than the intellect.


--lcG8jNfFY07Alc24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2024 at 06:06:40PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.121 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--lcG8jNfFY07Alc24
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdixLsACgkQJNaLcl1U
h9D8lgf/XDQ2/A5TG+hDDWFlRE6ZClCqdSuWC7g+T2reLbiMhS1+dIdqGDiw3gCg
rLkJaD+b14Jbb+U0SMjUgr10hUf/atdkMJvkJEcWQlZT021/LxVx3JfB1RxiiFyV
1P9KIT0GxD6LYOwvC1pbFuazHDxY0UEczk+OU/nVUWJYv2xZJTrJlkVL1nBJICD+
/k9Latk4InpcxbIVgQ1kT5CIMworflmMTvdWitfAEGhWqrU9iFxc5ZTAap34iEcl
q+McKJBKDpLLnOv/tntVbdrjdBXmDWGGdPh/36U6UMMSgox/Gkc4t1pDO1VZyCZU
EQKIu+VtpN+mz5J0bK7DFc3+0vdkFA==
=e7D+
-----END PGP SIGNATURE-----

--lcG8jNfFY07Alc24--
