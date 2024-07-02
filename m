Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C796201279;
	Tue,  2 Jul 2024 21:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719956356; cv=none; b=ZEZj4nskBS9gjYgcM1vqxaDgr+0Mkshw3ocbXChR7QrXN8FAwYsVR8eqRaezrjtqMjFbw6EM0zdXYdSQQij7jTIiyAbiV76kdWsTwaL787n6Tw0uumOK9tsnZ8YGNAafWM9aEYN2yE+kndsMsYSt8W6mTds1x/RRqgwnTlVF8fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719956356; c=relaxed/simple;
	bh=yhmXJTbkrrMWvZUHv6TNPn7XDDifEJi4Vj/IN2OOqjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=peLl+zG6j6Bub6F/wr0EVN64snOXEUJNhk6V75I6zbI3zQV9rUg1N1F4bPatDDA5iPDeYk0gTw45BULma4bpCGPpxqH6fKa+ox5uUD7KUCPuR7207M+p8qXuV2EBb2K4XgxGxBSjMPqhyFb9CpwNl8jwl1v5GANt8/eNRx844cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAOIucNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAOIucNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB52BC32781;
	Tue,  2 Jul 2024 21:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719956356;
	bh=yhmXJTbkrrMWvZUHv6TNPn7XDDifEJi4Vj/IN2OOqjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hAOIucNTlt+El3HE7zv12g/VbAu31FonTbyh8tact72p0+cJzqI+e4mlxr6nkVxly
	 NoYU+ElO7mDq0E+6XwNEtWrYp9LALe8kTyZujLkCtn+2enR3dK/uzS/+HivRREoSHR
	 Bcn1ggH47qr0MhblvwCDMm7s6fclNzDFzluzYlbAvpMcBKuGXf4gPAqTQ4W73q883J
	 0OQvqZ9D+RfazYnZhCqgigpSZLR3umgDUNtUEze2BBIMByn05YnZlgDE4JMVfW4d20
	 IgczyumGV7a62fupcm+Mb8DizTiP0dWUf822wEAPHbXwQIUKRovdGuxO0AhskYOB0L
	 Hy3N/PvygdOhg==
Date: Tue, 2 Jul 2024 22:39:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/163] 6.6.37-rc1 review
Message-ID: <6986fdc7-2958-4c2d-8fc4-40b4b62061f3@sirena.org.uk>
References: <20240702170233.048122282@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6Lgj+0vCkZSvkiUH"
Content-Disposition: inline
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
X-Cookie: Phasers locked on target, Captain.


--6Lgj+0vCkZSvkiUH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 02, 2024 at 07:01:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.37 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--6Lgj+0vCkZSvkiUH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaEc3wACgkQJNaLcl1U
h9AIQAf9HiR/ZnyvU83fM4tUp3bI9d6Ottt5Jt+TQDKbeBhXb5o0oySda7kfvr5j
0QdTT39uOwNWSPpQcz4gXIZt1ISNAYBH1yzOEc9zMR/og9oe2P563bJJT+JCcrpI
hWtjP6N/8f7Tjt1/zuI3OQnHNL1UCTnVB3O81HGYG1HMpmqUoperb6Bt88+tZjxE
Udr6r81TdZL96WldNBNunIuCql7/1YnM3cEQc2sdCHv+E6qWAvi2Vx/8RwoQoBZk
a48IrjQvkpIYWrjDVXsSgsPcRQz/BnpFGuNjKIbb7h1x6ta/wLhdKQCUVNtRgjf2
CMB29KqBqdla8QIQF1/3hQRxTFuMHw==
=nzr7
-----END PGP SIGNATURE-----

--6Lgj+0vCkZSvkiUH--
