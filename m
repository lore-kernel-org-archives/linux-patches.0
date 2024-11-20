Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885301C9B84;
	Wed, 20 Nov 2024 15:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732115632; cv=none; b=TyKHNhMFMZnbrk2lYJhMhRorWU7NsbJcipzFtqTl2n7yjDVgB5IQkoST1gKRaT3xak5kwrtC7zQ0JQ+5QwK1z/9aLVqFS3z/ylPaGBokb2U4UGU7FSxE1itdlyCKpgGoxorlRE14gubnouuIspDjbOK55VOkeScRenwziH9IECY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732115632; c=relaxed/simple;
	bh=uOwuHPzVcd6zYIYRf4qO/jqsh1MN5P9Nn03V801MwYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZZF0cJqEzpAevgbTboXqvjDd5TGc+eoCEBcukXO09WB4OimArziB3Bp5y5OUlRnLttZw1MWIkNT5vKkc6Wsr4sX+B8EmNuHwzRAiDUcS8xEX+5LjNHoSpakw49gJOaKQ9d1kM4voH6pxKRBa9zG6Euq6TUMKutpeAKVLuVV0S2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mmyRPNFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mmyRPNFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75362C4CECD;
	Wed, 20 Nov 2024 15:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732115631;
	bh=uOwuHPzVcd6zYIYRf4qO/jqsh1MN5P9Nn03V801MwYI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mmyRPNFVwNVuIxG5LxojcvaqHxzcKiH2d8HdpTa+to2OwpgAIzwHxp7R85SQ7mNdW
	 PpJBClRfzudMAH64Qmk8lwCHsXdeS2/RKnDyE7rw+Pa+uQyHy6M4D8D1Qz8stcC9Cy
	 dw/gvwBvkx6ozQoFbB4jvmSyXy5PUs1LLadiBL/vft64oP0q774DULlFwQGXykQtmb
	 8nKDF27lK31+wU/JoagXNIagxSeXPj0LDYf+gXnOVX57FkbIM4VcN5PbOI7aXovtwr
	 8tcB/l6TCQD7NJc1fFo4bI2cgsClvMy+U2wGuohewRkBdMb2jUZDeX/aPb5YvsZ81G
	 mWutrsOZEallA==
Date: Wed, 20 Nov 2024 15:13:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 0/3] 6.12.1-rc1 review
Message-ID: <d7bb7a05-bc03-4fa0-97a9-bf4425a38100@sirena.org.uk>
References: <20241120124100.444648273@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cixMipoW/OXll4DT"
Content-Disposition: inline
In-Reply-To: <20241120124100.444648273@linuxfoundation.org>
X-Cookie: Place stamp here.


--cixMipoW/OXll4DT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 20, 2024 at 01:55:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.1 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--cixMipoW/OXll4DT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmc9/KgACgkQJNaLcl1U
h9BTfQf/UC8j7yxJCYUhq/L1am+cUnPIjzGE7NuFZL1nKDt1kdk9JYamTtGpbRW+
X36CU83/yn/tXiRgEe6+2s4sOlh1S7XWQ9Hue/0kMj8lwk6l9yncNpWmcPYLVJX/
g6ZmgkumCAbEb1TMenck6qHsChVBVEYp/r0q/5SqW/faeiyuOOiLDA5CSddhitYW
uwSk+FAwSWBo5b9OgyX1PLuX6aZPMEKyEC7Eze1Oh7uTct3fY/PE2C40QBYVtznZ
DeAWWliduaDMXxH9z/McIqo9ZNBeb/iI1/2Rnb3u3LGf3M+rjr1KSGTGQtsGEYVe
gfLjGierUFJa0g/GoDrusJoYs201tQ==
=lgDk
-----END PGP SIGNATURE-----

--cixMipoW/OXll4DT--
