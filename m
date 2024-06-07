Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F046190051;
	Fri,  7 Jun 2024 15:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717773887; cv=none; b=F7MWxlcxKj9EnZJSF4jkPxPLC1dG3uXt85IzsEWwrYSECp0O1OO5c+W31H6dwbIvYu5GZuYQjkgFErFB1iPYX6Mr3h+4dXU7xj6RYnaZz/jhYJqRU2cvhzGyQPHBiV7MlYS22S6ZueaD2JmzixBQSi/jPzj2WeXUdvpSbF85xnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717773887; c=relaxed/simple;
	bh=53iTcvschw33V2pPsZxOGsJw8ikJERGWK6ovuQvXTzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V0BLPihriwFwhHQqSl1fb8Ib009iwYEyCUKvQ8s/4XEzEGgUKTBhIV7Q87+9kZg9t2iWC5Lrp4QN+S2rhygbrvJddCSBRJ0Q/JL88rLBVS9w4+agTAZqgoy7XlKOYkYOJEjSazADBVTQpKlG+0w5huUDYhwMUE+sipImdp5SVxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jtxZzYGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jtxZzYGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DFCC2BBFC;
	Fri,  7 Jun 2024 15:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717773887;
	bh=53iTcvschw33V2pPsZxOGsJw8ikJERGWK6ovuQvXTzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jtxZzYGW4nisrOD7UeUhsgC9ay0/sKPrV7aofCIKrQH1Cr/z1ejgU37fslqza6vJ/
	 EqciMGHGJY80ApR03Vvnto/gAhOF/MxklIaYkstpAy7C+J1CH4pnk1FHf3Oy0bNsar
	 axECqAX79BOq2dwdHvrPRrK1Cl0Zfx9hpi+mMQ90NmEdYfTQNi4FIny7lujyf4fqQt
	 z2RYaBqCgOPAOhEGKrqx7GpV4QAF7QAITcOPipf7UX1oKD3pEQPnQi4b8wdqhhZNtA
	 yijhSa6cFJSswnV3WsWZ85KkNmD4MJVMTYuvQX0bfKq2sSIcIyhHfA8xF5+meWuF/Z
	 ID+trBdP0I9GQ==
Date: Fri, 7 Jun 2024 16:24:41 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/473] 6.1.93-rc1 review
Message-ID: <20240607-tremor-delivery-d7b3604704c1@spud>
References: <20240606131659.786180261@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zFQuTIs/hVU9ra8B"
Content-Disposition: inline
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>


--zFQuTIs/hVU9ra8B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 06, 2024 at 03:58:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.93 release.
> There are 473 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--zFQuTIs/hVU9ra8B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZmMmOQAKCRB4tDGHoIJi
0oicAP9ytLc5h7aHGIxT6te561SXEFfirJmNghFzED5QPZKshAEAzV5jQLdug1tI
Bq1ToARf4R5D2+zd91TYC9zZcLHVNww=
=oYFB
-----END PGP SIGNATURE-----

--zFQuTIs/hVU9ra8B--
