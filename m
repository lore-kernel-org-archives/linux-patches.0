Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62942881C
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 19:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12D2C433EF;
	Mon, 20 Feb 2023 19:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676922492;
	bh=qGso2fu1xfsy5UflBkmdGkvK1AUQIwEnb9gODUDAMhs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cRrrLQJvlJXiiGfV851nor5FbSzHu2RGSf3mFLMicId3NF2NNakvR+qw7OIZQ+wzx
	 pCnqm+06GlR4kyq7CyiqwInCzGwoAP+59WEvLt4TeZl8CU386G2H8qZayHDt8Q/we4
	 Wgd8ZH2lENilK1nHO0Uu6ZDxcVNn6ldtkZi5DNiHJ+gxnkmH557pLazus4iqqtT6g+
	 SRXhD+WNUbRGQiRAZv9sB7u5BxBmUBldLVWfKsY6OxPira73tVjB4GNRqT/ek0+iqO
	 ij/UKqQrMQKZMJsE2sZuLo8ALKpsKS6sDZgt1U05SJw9h5xuYe4AdJ2VGs1kazW8Vn
	 vGIWIu9C0ZOxg==
Date: Mon, 20 Feb 2023 19:48:06 +0000
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/118] 6.1.13-rc1 review
Message-ID: <Y/POds3fNP3X1Nn6@spud>
References: <20230220133600.368809650@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Nc6lrbCff/UUHzQN"
Content-Disposition: inline
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>


--Nc6lrbCff/UUHzQN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 20, 2023 at 02:35:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.13 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.13-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.1.y
> and the diffstat can be found below.
>=20

Nothing untoward in my CI..
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--Nc6lrbCff/UUHzQN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/POcwAKCRB4tDGHoIJi
0hcJAP9lu5l2aJT2+t3fAPxfd1UJQvi/7cXWGpscSrkkLi+dDwD8DqE1lZsBbfMC
L6T0YrD1/ulGNf6FnYmwvzSpFurePwE=
=H6jX
-----END PGP SIGNATURE-----

--Nc6lrbCff/UUHzQN--
