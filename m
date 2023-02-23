Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE2BAD26
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 22:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A56C433D2;
	Thu, 23 Feb 2023 22:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1677190290;
	bh=6Fo/aX3D7XeeUb2/Gq3OaitlraFtpkIcWjvJeEn4WLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EPTmaID+CnnFH0HMorR2y68zp40Ug17MItP331iWB0B9nTwQhGotGe+Usk0F2gPf8
	 W/wlMG5aD0mJpCf3pUksTqE+vqUSaZbSoZ+BFxsRbUdR8+4aQuJtcJYurcEJ9cDe8q
	 DS+epYuPUKgFZnRihGigLlNjGMiolIEzJzYFsTcAGGbjYWVxCJ5Q54feBbRTSuXWMA
	 QzZT1b1XT0/c4wRfWz4P5Cd9Ml+nsTlTiMtwUdInckch+55pa9oSvEHa9/SHDQ4gre
	 XY/suw3mNhTpejtPLFIY3/6/ii1AHjnPlF1CqTC40m9/cS4fZUOwqj1O5oxb/jbKoQ
	 zHPdMeQ2Mtm9Q==
Date: Thu, 23 Feb 2023 22:11:25 +0000
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
Message-ID: <Y/fkjSHZsdrT+7CR@spud>
References: <20230223141545.280864003@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Gr10yJ3llyKsuq8h"
Content-Disposition: inline
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>


--Gr10yJ3llyKsuq8h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2023 at 03:16:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.14-=
rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.1.y
> and the diffstat can be found below.

Ditto here, looks grand on our RISC-V stuff.
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.


--Gr10yJ3llyKsuq8h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/fkjAAKCRB4tDGHoIJi
0rakAP9yX9ZiCtx4ncej6MoRpLhwF54kr64BSiRkso9Wq5BRiQD/Zz+gm14sPybJ
jRMX6qmHP/GxT+GkkhGoktTMKNcypQw=
=2uQf
-----END PGP SIGNATURE-----

--Gr10yJ3llyKsuq8h--
