Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E01391E70;
	Tue, 24 Mar 2026 15:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774366694; cv=none; b=la4vTQ7el/mIYWBFS0/BKjNU3tLCKJiRTT/1IC7TChgnHaHWCmLvc7Mw12IxsOfdFq95sHSWhR+YPNUtQogPAmOVs9DkCaSGxT62JlHMjdolwZTdq0uj3JxIwec05+FO3HtSRoY5+w6am8JBrGX+zE7k8sJy89dadvX22Gq4eok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774366694; c=relaxed/simple;
	bh=8e2uYP8s+Hj1T8q2jjbRjVO93B6iStdFrOBIc88pqeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rEuqw6lOBmZSrjdZLPDfNBLlq9TwmD2YVq6pffGOTkB8WrZAZoUKztWrUVF9ptNvAaUdZQBivjE8NNob1uEOkla5gB199dPlo4gsPOEu3gDSf0/df3BeV277NTHTSfldqSVhkXzz+U1M/HoHY8LM9Mm7sp1/N1BR1gHeH+Ma43E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNk7A6EZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNk7A6EZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8D9C19424;
	Tue, 24 Mar 2026 15:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774366693;
	bh=8e2uYP8s+Hj1T8q2jjbRjVO93B6iStdFrOBIc88pqeA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MNk7A6EZuM2547niGmXTYGixQrY85qJL3gBzxqDtRSm4RBEP3x8ENnGalR9llYFbt
	 MZijo0CkaO2drU7NO1spAaUT/X/yf6dj+Aqr4j8W6nyCsx5nFn3W67Bj8f+1wSKhct
	 1xulKdG5I6lQFXlH/QGMhyvqdMs0AjDqx/C7fFZfv72ojnYLlgVA5vN5gRWw4xIAAn
	 XHHUKkDByZ4cc8s/h9rLmnPc9c79q0X7g+8JDyYNEXA4vuy7tXmbWZD0ODZt0OXO4Y
	 Q8qsAItN0ViTVm8CxNxpMGWcZbCpfdHTvsvFlqHCPyhfJZNV5DuwP/qsZTn5XNDzME
	 20f+25Q+HRa4w==
Date: Tue, 24 Mar 2026 15:38:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
Message-ID: <26159b83-3df2-4875-ae04-dccff2e0ece1@sirena.org.uk>
References: <20260323134525.256603107@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="x5CUqyjC3YTWBCQO"
Content-Disposition: inline
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
X-Cookie: Forest fires cause Smokey Bears.


--x5CUqyjC3YTWBCQO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 23, 2026 at 02:39:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.167 release.
> There are 481 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Other than the ext4 issue that Francesco reported this looks OK to me.

--x5CUqyjC3YTWBCQO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnCr94ACgkQJNaLcl1U
h9CdTQf/Yqvyt7vPTBf2wX8iY/9TI7HZat/LgVqqUwl8ieAW/KFQ+TBe//o9IbPS
oV02DO+oNDu9GGbeOcWOUM0+r2haNTa6dldkNpwq1IsFVmvHN+M1tCmdTPg+eyWj
qQadSZipmF/hlLQIG5pQyW+99I2Iq1V2tEqEMidSIPy2mLRXVFK63wqZhwo6YgzA
vt6Vh8p+C14QOZ5fJ7cQa9IDaWP0BKV1rx1WoqxdjmZxPWWcpz2mt1rc/74GS7kj
48NEKOdmBdeJ5xOv38DqvfjTlody/jBNnAHX7K6xfKsDAu6YcND7CI65AyGnx2sh
uC5nnKEmSMzLZmdee/rxortTpjT5+Q==
=o2Mk
-----END PGP SIGNATURE-----

--x5CUqyjC3YTWBCQO--
