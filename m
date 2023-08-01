Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9D91ADCC
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 15:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748D6C433C7;
	Tue,  1 Aug 2023 15:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690905427;
	bh=Bm4/LLVahcVDIYf3Aw9PNqszqQAE9Vudt2kdKJVeHHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=erY5sHASijPs9dDACD5K1KOlv07LYC/Dk8Wz9VjDzrqpjJ/M+xRKWiVwkHmi7ar3C
	 Mvh86cPWVtnx4u6doSibokwgfGz5IJwAV0xErD3YFmphNKLsQBNjCnbP6Io07Ol8/6
	 BIh11AO5n4X9lsw0+mjxhGC0x9IIswP5NuTRMFU40kOls9AYMKH0zhjqszKGq6o4v6
	 WM0wOoo8m4JMwACCIAHzUnVZrcufrpSqmqtzgJBd/6oOy1hKfrzB6ztt8SyFc8oT7I
	 a/3PUvnD4KwBLXYgqMi7WB8ofSNFuVAkmy7F3C/X5jnaBVxd5NJHmHQ18CUgUXuWp6
	 R7/Th3fecC3Ag==
Date: Tue, 1 Aug 2023 16:57:02 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/228] 6.1.43-rc1 review
Message-ID: <20230801-unstirred-creative-0f195f132009@spud>
References: <20230801091922.799813980@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="u0H7A6VvctDHUeOm"
Content-Disposition: inline
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>


--u0H7A6VvctDHUeOm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 01, 2023 at 11:17:38AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.43 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--u0H7A6VvctDHUeOm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZMkrTgAKCRB4tDGHoIJi
0r0ZAP9IXcdVThLJGrFClO0sVGsF0den7siICoq5mw6B0l/4/wEA+SJDzbILSlr+
U8mxH0mgmWz9q/bCcO/d1OSTRujFkQY=
=80uP
-----END PGP SIGNATURE-----

--u0H7A6VvctDHUeOm--
