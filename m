Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7501F168
	for <patches@lists.linux.dev>; Tue, 23 May 2023 14:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC2EC433EF;
	Tue, 23 May 2023 14:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684853646;
	bh=VG85k3UmDA0cBr8ib9xlQ3gxEXwGIoprsHWZyuLD+34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Son2xWpb0IElMBJO2MkFdV/bbY0MXj/ZYtwCfSegNWucxK+7L67Ind5JbMwtNXGAJ
	 gDoY2p37RSGNe8AeUwIKzPZq0Bs0T8TPKdoEQIywqRjkhiKkZudC0dsWCekXf6XEOi
	 x3KnxodKkWF7kkkEyuI9x2rOLitMpTlTAn0sTD44IBnlv9jefcIBj0aoYDbjuYFErO
	 xjqc2IQtCgssxXL8uGFnyekxIluuXtQhRxa1WcgbIU6sLc/BmITUXpEJDXRKggaCPt
	 d6JO/UsLjAcG87h3RzJwkswU2GLFeJo99/amh40bIp7ULl3W0JQJ91TDsRqtpK8VH4
	 QBPz4hibwXQfw==
Date: Tue, 23 May 2023 15:54:00 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/364] 6.3.4-rc1 review
Message-ID: <20230523-preflight-outline-c54237967fd4@spud>
References: <20230522190412.801391872@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UmTNjBIJ/RbTUjkM"
Content-Disposition: inline
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>


--UmTNjBIJ/RbTUjkM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 22, 2023 at 08:05:05PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.4 release.
> There are 364 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--UmTNjBIJ/RbTUjkM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZGzThQAKCRB4tDGHoIJi
0noUAQC3zBOdWMQfDf02EVlBpaGq0TgjUFmdOs6c5euEi++TnQD+K62VkuBLPsLB
q5VY54OL+4v5d9ZR6uEYi/L2ekw5DAo=
=IWxF
-----END PGP SIGNATURE-----

--UmTNjBIJ/RbTUjkM--
