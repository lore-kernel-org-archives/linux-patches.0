Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F311096B
	for <patches@lists.linux.dev>; Mon,  8 May 2023 22:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF77C433D2;
	Mon,  8 May 2023 22:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683584745;
	bh=CvmAZhQVoRHyGoGJ5fwdxTLzjL0vk9hx7okCexmPS8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AaDiLwKXpM4HTo1v6iJLrnP9yDGrXr1ZYhwv4it+gYDfjB3bAepKcNmnE3RI71rap
	 vGuQqWJwofq4Yg91rVk7u5NuFoYQJXf+DgCIX+Y6/haBDaMZSyICIqR63s9qea5NHf
	 hqrF1BRSa3XBHj/CIE4SpPZtGgr5MTwbcbFBM0US/Mo3TAXCbI2Cw7qnx4hPb7sezb
	 mSpGbWPan69NAsvYqy5prqhsnItJ//1mehE9H83DwpskXzmr0pGqUYFhnD5onVXI/v
	 WlDyeE5EKkYlDjXXrE29afArkQdzGAOdMHNmbDb1WnwF0JrfMR11f172ayUg4AG9RV
	 l2h+NkI3fcwyQ==
Date: Mon, 8 May 2023 23:25:39 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/663] 6.2.15-rc1 review
Message-ID: <20230508-bottling-rinsing-dd595259c719@spud>
References: <20230508094428.384831245@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Fgb9rn3498PUaa1Q"
Content-Disposition: inline
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>


--Fgb9rn3498PUaa1Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 08, 2023 at 11:37:06AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.15 release.
> There are 663 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 10 May 2023 09:42:40 +0000.
> Anything received after that time might be too late.

Other than the bcm63xx build issue:
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--Fgb9rn3498PUaa1Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZFl24wAKCRB4tDGHoIJi
0rAlAP9SdEwRTBofRPzjTdn9H3VfY5rCLLi+1jJmez43t5rb0QD/e9R8Poe+JuUk
duNqn0Mt7r68sAgiaS2EYqUFvTO3oQM=
=Way5
-----END PGP SIGNATURE-----

--Fgb9rn3498PUaa1Q--
