Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935B113D539;
	Mon, 28 Oct 2024 14:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730125278; cv=none; b=O7uElijDv0nWoE/asqoWMH960wgkoiPP7gTulVnKqRpGGNOldoAxlF4wus0jXmOpy4qhG5ZdG73WA+cXnboqQKoaXaqwLHvx++Z2KauDc39ai7RmyeoZ6BruriqE1xYz52CJIjjeaBQKucIv+SAZgWdoHBm0TTtwwju0jGCdU00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730125278; c=relaxed/simple;
	bh=JwAO8gH2EA6ycwvrjhszF31kYoiniTcWI/cg3hr8X/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZmBKx0cc80IDS5ZAUeAOqYW8TqHQst9fIFWfolv4AFFVHKDuHsoxgK1tZebjnEcYPN9LmuRfWttB0cItgVXSqEjoErs2s7F6xM8p6EOVrKC2q4ymHkcEBsaQs/WABssquBn4kQ1b2MkZeT+tycEKald9gA82wmyNog5kZrhb0Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r4eyGjdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r4eyGjdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C67C4CECD;
	Mon, 28 Oct 2024 14:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730125278;
	bh=JwAO8gH2EA6ycwvrjhszF31kYoiniTcWI/cg3hr8X/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r4eyGjdl6vnBoplLE7wNMgU0V4ik2MyrIB60G8Kwz7yi8McZB1O4vy5lCGYGdPddk
	 JylMk7hTNcievmd06y+kNguW0NP4yb4OMDcuqWIQB8N3LDpxOicRjMpK9mnkGQX24C
	 9Veetq9bYthLhVscnLNm4eRHHKoZ/ZToQ3eg95Wvjffzmxe49VIDYIU5Bif6ctMTCl
	 ebbeQt3t8tWiO3cSRlFckHnRNH6+zr80pu89PVIM4pq+MAzbr9anwVaWFF1WyZ/a5v
	 rOewCCUBIZGhYRw4iSiFEgKbngd9/atcON8G9MJPy7xr3jfdtrF7u/KfRUKiR2JHpx
	 z7vWFLnYjg3Kg==
Date: Mon, 28 Oct 2024 14:21:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 00/80] 5.15.170-rc1 review
Message-ID: <e2f651d0-868b-43e8-93b3-73a29be64ca2@sirena.org.uk>
References: <20241028062252.611837461@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HJ+8SAmaqT/wMof5"
Content-Disposition: inline
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
X-Cookie: Remember the... the... uhh.....


--HJ+8SAmaqT/wMof5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 28, 2024 at 07:24:40AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.170 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--HJ+8SAmaqT/wMof5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcfndMACgkQJNaLcl1U
h9DOpwf/ez+8bEZOH68RjrD3j4fJoLaOpRTO6IBkddT49NOdbdGKk4ZFkPeVHxIX
cMGdv/rE2SCr4MYfHpfWs6U9xNg4L/0jXxs+SMuNbC6BFlYonWmk1/1B6dYxqUOl
jy2YPiClSi9dmjH8qaViT7ysWySctL5vR/iOenvWH0B7ywFvNfVczyizQnx2e3s5
EX1h6RhmKCnY3V71zcOAlVhckLyerR1YIctaH74/KbfYh6hju7MvJK5S/KShQ1so
f3s20plHHnVRbrWyKxbxBXD1BnQ+RTqAH7PgOsOOQ9SjEzgqO/NSoCQgTKSa92w2
Qvs6gi4fg3ebpgZuv8I0FgRiOpk46g==
=1HYm
-----END PGP SIGNATURE-----

--HJ+8SAmaqT/wMof5--
