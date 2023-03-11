Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35C37B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 10:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4AFC433EF;
	Sat, 11 Mar 2023 10:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678531555;
	bh=lc+0yv4rho6a7UZUBR6DprE3NpKzJr4oqAxIjjXn0W4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MygMOAMirutacFgO5xN42i0WxjDnxfV/m6GQWSgk7QFmIPDHtUHNYDoRr2WUDIphn
	 TcyN/d/XmLcgh4Q92Sx57FzOp0XJR2JT2jSV5NmH8S6k63+TiDnnWHlZuCabJTqNtn
	 yPlsp13r9GDgHx1f9NpamYDHQR5vzjV5Vhz40MDz8MLl4LWbnizr5rLoUMcUZYfAge
	 as1Jyi7uy7kvlNLVzgldFO0YFBtCfZXE5CmAk4ZR6OlOTCCnOZrezF7wfNiAmL4qtB
	 IedZ9p/njTolSD0e7r9ZwgCPoUpB2YxTZDO4hSSjVu4rsY+yjq613TKaab0mF32H2c
	 xY8FB9qxP/Dug==
Date: Sat, 11 Mar 2023 10:45:49 +0000
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/200] 6.1.17-rc1 review
Message-ID: <b09f411b-0920-4308-b3d2-60390931c28b@spud>
References: <20230310133717.050159289@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="hMni/ZXHZPAAM9cm"
Content-Disposition: inline
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>


--hMni/ZXHZPAAM9cm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 10, 2023 at 02:36:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.17 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

And no complaints here either!
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--hMni/ZXHZPAAM9cm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZAxb3QAKCRB4tDGHoIJi
0ngiAQCzAmKRW8Ur6gMHZ0sFXYsiIVIkKZoz73m9GNwzKPMdrwEAx72Pcl2cqyZi
58+tYig1xSWYoyBMpXuOFzPkSq6Y7Qc=
=hGn6
-----END PGP SIGNATURE-----

--hMni/ZXHZPAAM9cm--
