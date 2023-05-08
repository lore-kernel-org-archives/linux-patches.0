Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED87847B
	for <patches@lists.linux.dev>; Mon,  8 May 2023 22:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CD4C433EF;
	Mon,  8 May 2023 22:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683584909;
	bh=YLErWiO67rCOF3C7aewUGP9j3H2s5a80TaR7xABdUvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lt5G/T6qN01xsdTV90eNTuyZvkQ0UqIp96LBtvn7CJrONa5pIF+DAgWAqIdkcOf/v
	 OkLG70AU976JQGiUDx43UGk2LGb+AWJIPa5GIR++NOMqF24r6e0WGwTK639G3crd74
	 JVahwFNucBjMoAE70+uvpGtoPAc/EMoWPnIsTnm7WibdBmLyo43p6zzO9uW7U/8VfJ
	 n4EPruOa1PTqDVgY1k6kzKmuZkvs2Q4N8GL7U8b0ZlEDrRakmvNPTscbtFqJ0ylMTV
	 MfAnTvXBv0txCIU3HFdLERtnH7LIxS4nYd9rzkUrCpCO5q3geu0SUHNg1fJG4LnAle
	 xfQDvD3VgoCOQ==
Date: Mon, 8 May 2023 23:28:24 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/611] 6.1.28-rc1 review
Message-ID: <20230508-widget-radiation-d4acf2192fda@spud>
References: <20230508094421.513073170@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="AtKzXF1T8O8D6nJ0"
Content-Disposition: inline
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>


--AtKzXF1T8O8D6nJ0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 08, 2023 at 11:37:22AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.28 release.
> There are 611 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 10 May 2023 09:42:40 +0000.
> Anything received after that time might be too late.

Other than the build breakage due to the bcm63xx stuff

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--AtKzXF1T8O8D6nJ0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZFl3iAAKCRB4tDGHoIJi
0tF4AQDiVnuSofK3ADTs8iiE1zmosnK+OZ2MuD8ilCrrUz0SQgD8Dw+HMtgb6jmO
BWYAvwI2oXDnVgucsYT6ElzBOzrfCQM=
=TGsY
-----END PGP SIGNATURE-----

--AtKzXF1T8O8D6nJ0--
