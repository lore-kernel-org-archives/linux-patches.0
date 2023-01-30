Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F8579F7
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 21:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DEFC433EF;
	Mon, 30 Jan 2023 21:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675113993;
	bh=69CmkvsAbzmB0w9yvusSxAkH+Iv9Zou02nNhg1UoZ/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hITV6zcJl+zPv06uNIW0x9+IywAcIYBAjrBbx3W2I/2dqy8rdHFJTutUU8oGN7nom
	 /88MKRM2FkTpq0ws5PRantg+oDmcStc28iD/FCtgzmg3p0O7zpi7v2qk2Y8sUbXTg2
	 LNj/f7/yRGNOsQFHUMoLciXMI5hdWzowzVagi39Jb0ur0GL7P5D9vWUOxvYfCFvtiY
	 pg7F+1aBAog2XzxRxnNsw0Geok6stnpG3dwZQGgV5KG25F9SeeoFpCoVsP14yWK/B4
	 Txqsc18rPAeeq4giQmEoB7gveDdpTSpW0Ujuh1vMBoseZNfOclAc/2W+ndvKSpxGle
	 AcS5TqoC4O2gA==
Date: Mon, 30 Jan 2023 21:26:27 +0000
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc2 review
Message-ID: <Y9g2A/z/onA/2qsi@spud>
References: <20230130181611.883327545@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="qH2vrN+ER9KGegbW"
Content-Disposition: inline
In-Reply-To: <20230130181611.883327545@linuxfoundation.org>


--qH2vrN+ER9KGegbW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2023 at 07:24:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 01 Feb 2023 18:15:14 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-r=
c2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.1.y
> and the diffstat can be found below.

Build issue resolved, thanks Greg/Guenter.
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.


--qH2vrN+ER9KGegbW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9g2AwAKCRB4tDGHoIJi
0oaBAP4yhrulYZEanKEByJMYIYCRZNQSuJVK/KWAtI6o9zcoswD/YgDyCKbCnLAV
A+eMZRiYsLIqRKcyK5rUL6d1MoPmaAo=
=3nEY
-----END PGP SIGNATURE-----

--qH2vrN+ER9KGegbW--
