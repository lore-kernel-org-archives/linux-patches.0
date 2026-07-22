Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB663126B2
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 18:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784744836; cv=none; b=PRi1qBmTDq9GzzymmvWILUDcb/VjTdOBz2WWtmr96rz+K1f49Sj72WR0/86JlxoBKBQltYOfKyX3DgclAlZd95i4cVEVJBCwWqpxzqutDBNwI8+oPiUtV38vsdT+PzPLTkCHTImCJr1CIbHiqkmUEiSLG5OkcmabSPMLTdBeIhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784744836; c=relaxed/simple;
	bh=b8oQii5Q+Nx0PHqHSC38aG4qaoJ0giOL10h6on50nxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BJG2LbKaiGYMraNPJga18H3UQfEGDCAdl4+AgRZSQccB0MIWhFEVVvMqAboPQA+7ghHNtoMtIS7z9KdUKp25rdkdHa3cu7Yuu/1iKCPX9K96k+tws1Bi7zSWx8eCByGIw7wHOUDou2D8Ydebpnyhr6Tmj2bqxkHAw04AEWZ9grQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=dnxH0W+g; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="dnxH0W+g"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 687EA11A3BB;
	Wed, 22 Jul 2026 20:27:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784744833;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=bDzAydu1atzZZTGoyo2TrHOpnj80gsmJfxhPjGMQUTA=;
	b=dnxH0W+gO9tjlSuS/vPiN+GGgKKCopHgdC3dgFJNxWE5x5yLYvhPZxYp/AXLm+zyayiFkB
	Rw7Lau0UaJ26RmPB8Z4rR6+LZxGJq6RQMGV8BXrHyHscTkIY4/XFHTYEBdMxV/Tvn5HNSi
	LoL/ctGpH96ig2RdTn7J7dZgXOR8RA2NswKazYt3SybzZ6/QbND0iNTXvlPlYSwvfPU6A0
	kVMHffuJt9aM9WHiaDzh4hCls0mcQrLEVSraesC0GXZC5sJ1tXAujezhtWcGh8hB8VyZVk
	6sUeCITP3SMy3Ma5p/idXWfhsCZI4vm0OrwXvE7UxCarPS6Q5hqI2RG51mv1qA==
Date: Wed, 22 Jul 2026 20:27:11 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 0000/1202] 6.12.97-rc2 review
Message-ID: <amELfzKm66_SuhaY@duo.ucw.cz>
References: <20260722142834.868902312@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nt4M9bMvN3YNrla3"
Content-Disposition: inline
In-Reply-To: <20260722142834.868902312@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Nt4M9bMvN3YNrla3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.12.97 release.
> There are 1202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.12.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--Nt4M9bMvN3YNrla3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCamELfwAKCRAw5/Bqldv6
8mdTAJ0X1FJM+XPToEMbxGLvCdS0QFT6qQCgnIfNNgBzDfo3oLcjR2xqKE82uq0=
=lYz8
-----END PGP SIGNATURE-----

--Nt4M9bMvN3YNrla3--
