Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979C62C0262;
	Sun, 23 Nov 2025 11:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763898800; cv=none; b=eiNKTbm+WzeYTSVY9O/G9Ea1ajfFDLJv+fUgkmfx7Z34OMD24EK611A9ejEAGQFWDECAXelUL27M+Ip4Vm0zRD0uCx5/jUKifYDf+WN70PZWw291UsYhi17qQkPumQd0mxc7+Y4GbuGCfWS2CoZ6XDVXYSfy/BoHpksv5cF3uFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763898800; c=relaxed/simple;
	bh=Kn1Lh+nPXg66ZJG7bIT8W6PbEwGRgdAWWh53sbxT2gA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IULe6YPc3NKYlvdfFm4+VYLXCbKlZ2pkIun25RJ3QqeQ5R4uzQL/+JUMc+VVL7P+A+n7GFd3aoPZH93ecTwzxKF/e5mWz+G+IAKrFcvmpLt5vGIxm5u9yIqKA54pI+7CTkNB02VoO5ihV7HYOpsFSQDyExf8hriJzc/KWADgsjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IVubgEDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IVubgEDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE145C113D0;
	Sun, 23 Nov 2025 11:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763898800;
	bh=Kn1Lh+nPXg66ZJG7bIT8W6PbEwGRgdAWWh53sbxT2gA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IVubgEDdd3tqzdoUMxKyeJu8pRsE4AwqcjEko2eT0kORzdFV3qdnr5jx9l6vX+4zP
	 ln/8hF2dJqqxjWu/oFOAdjw39vkIrZv8+AszhuK/h0RLO4xnk0m4Hwymvr7XmlwrnS
	 LYnaIozJxBqRIk6CBiKqiE9oAT+oQLGuxTK1wWTUNO+CLFdrBjU0Md/gWFsowysY8P
	 353vfWIGmSp+NNE16ZT7A4woiQ6fvCSooRSCudaIygSWmYAQuhYnK/bWODja/DGXDk
	 UXzsifjY1dcY8yf5gPJrBT7Sl09Ht2jLpX/WJP57iaofeg8O9vzetIglKC8bruIDxH
	 w/6PmWfcd1TXg==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 190BB1ACCCAB; Sun, 23 Nov 2025 11:53:17 +0000 (GMT)
Date: Sun, 23 Nov 2025 11:53:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/185] 6.12.59-rc1 review
Message-ID: <aSL1rdyJ6lJixTxs@sirena.co.uk>
References: <20251121130143.857798067@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6nbrxRfyEQK/Ugwp"
Content-Disposition: inline
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
X-Cookie: It's clever, but is it art?


--6nbrxRfyEQK/Ugwp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 21, 2025 at 02:10:27PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.59 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I'm seeing the same regression Naresh is in LTP listmount04, bisected to

[c5d44c8b2ed1fd6761bf9157d2c5b887a4dc78cf] fs/namespace: correctly handle errors returned by grab_requested_mnt_ns

# bad: [92f6b4140c17182e28e19312fce7c6ee90cd3077] Linux 6.12.59-rc1
# good: [7475d784169c7df48b0c55525fb862e06674d63c] Linux 6.12.58
git bisect start '92f6b4140c17182e28e19312fce7c6ee90cd3077' '7475d784169c7df48b0c55525fb862e06674d63c'
# test job: [92f6b4140c17182e28e19312fce7c6ee90cd3077] https://lava.sirena.org.uk/scheduler/job/2121934
# bad: [92f6b4140c17182e28e19312fce7c6ee90cd3077] Linux 6.12.59-rc1
git bisect bad 92f6b4140c17182e28e19312fce7c6ee90cd3077
# test job: [c16418189c97fd90c46b3b00d7d7224711d49e42] https://lava.sirena.org.uk/scheduler/job/2123608
# good: [c16418189c97fd90c46b3b00d7d7224711d49e42] mtd: onenand: Pass correct pointer to IRQ handler
git bisect good c16418189c97fd90c46b3b00d7d7224711d49e42
# test job: [9c7df79d445495aeb1ea7fae6bd5e6beb5a86ea2] https://lava.sirena.org.uk/scheduler/job/2124517
# bad: [9c7df79d445495aeb1ea7fae6bd5e6beb5a86ea2] LoongArch: Use physical addresses for CSR_MERRENTRY/CSR_TLBRENTRY
git bisect bad 9c7df79d445495aeb1ea7fae6bd5e6beb5a86ea2
# test job: [4e681269759ae153055fbcffeadd611a7b15df84] https://lava.sirena.org.uk/scheduler/job/2124890
# bad: [4e681269759ae153055fbcffeadd611a7b15df84] strparser: Fix signed/unsigned mismatch bug
git bisect bad 4e681269759ae153055fbcffeadd611a7b15df84
# test job: [fb4fd3fb2f254aa4ce76f70e3f3a2e1fa5dd9031] https://lava.sirena.org.uk/scheduler/job/2125058
# bad: [fb4fd3fb2f254aa4ce76f70e3f3a2e1fa5dd9031] HID: playstation: Fix memory leak in dualshock4_get_calibration_data()
git bisect bad fb4fd3fb2f254aa4ce76f70e3f3a2e1fa5dd9031
# test job: [ec7a798f14ae4058e88ebe088e89ded5fe17e312] https://lava.sirena.org.uk/scheduler/job/2125258
# bad: [ec7a798f14ae4058e88ebe088e89ded5fe17e312] netfilter: nf_tables: reject duplicate device on updates
git bisect bad ec7a798f14ae4058e88ebe088e89ded5fe17e312
# test job: [c5d44c8b2ed1fd6761bf9157d2c5b887a4dc78cf] https://lava.sirena.org.uk/scheduler/job/2125373
# bad: [c5d44c8b2ed1fd6761bf9157d2c5b887a4dc78cf] fs/namespace: correctly handle errors returned by grab_requested_mnt_ns
git bisect bad c5d44c8b2ed1fd6761bf9157d2c5b887a4dc78cf
# test job: [652ab7b107fd7121b28113d0e3ba63b7821ee36e] https://lava.sirena.org.uk/scheduler/job/2125457
# good: [652ab7b107fd7121b28113d0e3ba63b7821ee36e] virtio-fs: fix incorrect check for fsvq->kobj
git bisect good 652ab7b107fd7121b28113d0e3ba63b7821ee36e
# first bad commit: [c5d44c8b2ed1fd6761bf9157d2c5b887a4dc78cf] fs/namespace: correctly handle errors returned by grab_requested_mnt_ns

--6nbrxRfyEQK/Ugwp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmki9awACgkQJNaLcl1U
h9CfQwf8Cef7USiKiQl7vJomEWDZeMp7/TkF1vB697WMbPgpfyESOluSc5pdBXoX
i7yY9ZJ3vfysaVxsRWnKDbEPQy7a+d7WlKiHPqS9nd3XEfkhvRFel//VbDy3T/7/
O2pT0U9qKMXnxGs0/MNuYKUKL7YEpMZrLb/nbizG1LQRnr8NW85dxmQI48LikgZm
vnivMdW+9nM5n2EBr7yxjt07U8RtGfbnKsAsgwBrU/xp/h4EMy11iStN02fnjsS6
0XJ7atp5AT2sqnwD6u4NpmjQsh24W0xrDVgzKp6TN2sHhu4iuBvVG2eRen319B1Z
0gPW9vImMaluBxytk3dRQ1ICJFw+7g==
=q1kJ
-----END PGP SIGNATURE-----

--6nbrxRfyEQK/Ugwp--
