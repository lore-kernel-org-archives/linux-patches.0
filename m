Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D122AD26
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 22:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B30C433AC;
	Thu, 23 Feb 2023 22:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1677190234;
	bh=suHqtof+rHlv8+ShZXwEQBAa8pFrP6gpYT9ct9HWSTM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JihsHmWiSifwyM8VJeXvqJYDmz0PXRFXiAAubL8cRklseU6XtE2vYVy1O8zV0qbFl
	 OxWm75mdk68iknnDyvyjnKGz2lyzQi2Zk3VhZjH4HVBSdvvVxJjfgzvLbrGtS9p0KF
	 v0H7b4MJ27VPbbEOfIsAZpaDyhDd2AHacPYyEjT18UCQdVrlpBxWQzhblr3UwK1b1b
	 mBaFBpmZsM6DAPOWeZgJ9Y8Dkh+5gM0HeTxlYWU7rA5/xCf/Lr7Ih/LlLNwWsL6tp7
	 AkcL4BRVKXSGK0E94m6KrXqt0HW80kUPKzkP0P3/CSo6iM5Q3tZx+axmCbXrL1fmw+
	 IhJaSK6x+AVJA==
Date: Thu, 23 Feb 2023 22:10:28 +0000
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
Message-ID: <Y/fkVLC7ogVuqFnh@spud>
References: <20230223141539.893173089@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="LaE6nG/shH9+RaLw"
Content-Disposition: inline
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>


--LaE6nG/shH9+RaLw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2023 at 03:16:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.1-r=
c2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.2.y
> and the diffstat can be found below.

-rc2 looks grand on our RISC-V stuff..
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--LaE6nG/shH9+RaLw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/fkVAAKCRB4tDGHoIJi
0qVSAP9ieM3QvKIuUM7d07imkGubmJQMeDrtz9zffcu+3FKaxwD9FmKfjoyAHzed
lMs9wUi2hL2fNgwx7KA2/iXEEH2Y9wo=
=Geu+
-----END PGP SIGNATURE-----

--LaE6nG/shH9+RaLw--
