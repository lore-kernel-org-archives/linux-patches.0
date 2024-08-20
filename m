Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7215910A24;
	Tue, 20 Aug 2024 18:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724177079; cv=none; b=LpOR5IsjQrmDyb0xas+llpXLCEnYcLHErEpGgb/iGVf6mc109/tPiCNMzHoWjaV7NTnThFaQrpM3+HuhQiEQiIQFQAcI4oG1q3FYKYqriAz6hfytgy76QZzb5KlxVPGJCsXPPpQw7btX/zblCDZqMCiDWO/5bMoSVPYvzp7Np2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724177079; c=relaxed/simple;
	bh=utxJ+2eCJj9Yna0s4EpYW2QqkPU5ieoaQRJYmJW2V34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gr/7xoqO85lg5kehr4c9OwT8UwOPR2ujvuMCCceMKLOD52JXEqmvBPvjKD7yDbtRT5+2uPDUkoHrCH4vCTRnjlMw3XNLFMhfx/HZANDOJrg/JBwxDgqoKJ9DfC2Bx8sTILUPvlFD524A0oDPwOMNYCVZoTyLGS9OI7zaB3SgrZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jE0dEnNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jE0dEnNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB2CC4AF0B;
	Tue, 20 Aug 2024 18:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724177079;
	bh=utxJ+2eCJj9Yna0s4EpYW2QqkPU5ieoaQRJYmJW2V34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jE0dEnNAAdN2WXJ0fP1gZH3ATQ2pFKgurNcVv6Wrg6Gku3Qr6VPn2hU28IJJ1ut/i
	 M2qwSJRASGd1z+SWfAs44eGQemPQAjvClmH+9HVxWHb33/0vG13HQFW92w4RLxsw1V
	 rJ1QxTVUgAtNE9iHn80l56oAocT1GQsUZXmuJYscuqFtrEJm71+qerpVmCAsrcjt9f
	 dmfr/LqrdmmUy2QMKV52y2BLQ3UYQdzitcmnF97Cc6IRue+V0UBH0MP7QKxs00A627
	 21zzFqdMEdQ2G4mHoj+sSibPumEUrvcGMRRb7shYweR4m9O6Vxvd/7/q2Es+YrzksS
	 eFqPKZwN5Zi9g==
Date: Tue, 20 Aug 2024 19:04:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.10 00/25] 6.10.6-rc3 review
Message-ID: <38b0451c-8cbd-4542-b778-6521bd94bc05@sirena.org.uk>
References: <20240817085406.129098889@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BOdFR9S5y4v3cz5b"
Content-Disposition: inline
In-Reply-To: <20240817085406.129098889@linuxfoundation.org>
X-Cookie: You are false data.


--BOdFR9S5y4v3cz5b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 18, 2024 at 10:53:45AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.6 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--BOdFR9S5y4v3cz5b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbE2rAACgkQJNaLcl1U
h9A5AAf9F60oLX1oQwM2HO9wEd8ZVzAauI9tdX53sUvHIw5gMZSbjBuSzB+5LQxu
hid2NfId7S6B4zYVUzvPR9HJTPvoyvOJ/uS0vXf3B0qlQtNqE0NpippphPskkLMC
wwxc0SPPyLtppqEwv6CkaNTluFpcqqK/zPEsIzfxar+CS3BecvZTB7hjU8crSSkg
EyZjYeIj9VcsFFiMgRwxLbX7Xyltkky/jmp6Tz5JzmcjTX91AKDNCTcdCdiW+jfE
vGpulftaFWFa9jVrVxr/RgK1dKOnDKuGw+kVbpkzKy540pHhSy5JLGkFLlKx/GZY
i4KwiHY6XrbflkiVs+6yzxGIFIQq4Q==
=iXLt
-----END PGP SIGNATURE-----

--BOdFR9S5y4v3cz5b--
