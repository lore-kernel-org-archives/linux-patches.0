Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A797371076
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 17:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786989512; cv=none; b=gCGa7v7Ay9RixXC6T/5VRwfvdPiC7VdWcn8sM9xGzZOmAprALdh47LbvtBpj/R0a+QmBdlqTsmIcbQjmkH+skiJ1K356EdkgeLHsQnaDqk78/Nf3KUipZNFwrG1bFXzkiKosXVo8JBVmTtbu2DUjwoq5EMn/aYvkHLeOdGr7N3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786989512; c=relaxed/simple;
	bh=O/Oddo2VnBJDUHU6dED7l3bQTSARYwIRgO69FXj6pZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e6Cr36Lpe7ICfhjBOMOXOhfGe6vdDQXEQOFVqg8LHItea2LKGxdLyhLmIZCp+VYsDrkvRTYGsKvPV14jqj/BPE2sScB4q45DrTdYLLcVsFQItS1JqGWq6lGRwf38XsKDbAC/3Jue3QN7QKlVNbXfK5LpowXTooqJGzFCeSh0gyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=K0Kf3+nr; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="K0Kf3+nr"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1B3D211B608;
	Mon, 17 Aug 2026 19:58:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1786989504;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=yphdnLrgje+xhQb6Yj566dRmYOYxBTCy8ZbNKumgTOc=;
	b=K0Kf3+nr/piPZjm54TN5ZkXKEcm8XYCg4vrElhfWfgqDYCRSWNmCZd48vmLwMsK4PHZP9M
	d8BrguHogUX/J6CUASIT0+bEX4e58xlPMZsUyX/NtQETXhbKaXcAwtTjVMYKFIlhd8eIuw
	ycuASn/SGhJqaihKbNYqd1+h7n24Zl0HD/sMZmZQNNs9ECdPWjfF+Y/nZTBjACm8WDVb/B
	0A2JcHTMrG5PSJRvuEliMH3Co+uF0j/8rF4W4zsuFyudcg76knQaiC4lEWzBqZCktH9b85
	kXAbManp0L1zp1owOlEAmvYryuXdUIUak9xQMm/xsyRJgw2mb1UdxmBUCA6g9A==
Date: Mon, 17 Aug 2026 19:58:21 +0200
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
Subject: Re: [PATCH 6.6 000/156] 6.6.152-rc1 review
Message-ID: <aoNLvZvn_21S4XUW@duo.ucw.cz>
References: <20260817132534.666299318@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eyyqG/WnGnrYolAS"
Content-Disposition: inline
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--eyyqG/WnGnrYolAS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.6.152 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.6.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--eyyqG/WnGnrYolAS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaoNLvQAKCRAw5/Bqldv6
8g++AJ9EsCLR9aqZTNfxcADY1gfTal4lwwCgtL3YZKTKCGkBKhXt1xi99zOnt6g=
=LfTP
-----END PGP SIGNATURE-----

--eyyqG/WnGnrYolAS--
