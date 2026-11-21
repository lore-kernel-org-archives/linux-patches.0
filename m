Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795299839;
	b=0Yk1JGzhHkNzN7rqsl1er0eEXIfcFZZjMSfahiEgcvjluC3RIIkjTmOh3jEaj9RM+JZf
	 lSOOsZ6UOaEoe8k5ZbWfG4tcMALy5wiPE0HEURPVvOph3CQJo5+pgszr5fEiHJsjVdIhL
	 W5KtcMTt0IMqkG+zpRmNJFrCn2M22Vn+/mxrmPlXYcdHFzzHUk3Cs5Vib6OHVFVun7IJ2
	 ub0b77RwtZkoQf/BrzlZ2EF+MzIekoXDtP3gp0Cl63l4h3mpoUpQhsqGIJmgeyX1mU0Re
	 RrvBZ9OHrojok48RpR3EV5KoB+mkhfbOVhgXwRRbGAsGIqNWE890/oyGesZNM7n2PuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795299839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=1ClmkSBdMqTTM2VLnmeQctVTtrpU5Zj3EkOTVngr9nw=;
	b=hRIHN0KDLZTslbZ2nNfCSM3yRy5KJblHS2K6wCT1XH8Iv1SocI06hY9YE3q54itcc138
	 i3leuvOK99Bvhi7cTGcqQHf9TnaAviJ/56aQsID4xTODgBuH7z7zw+2IpxAA5laGdyzI3
	 lthpSMkervM9FXrywTGYUW1L6tiutyxMUAHttNQGzGQ0w+Re1x6N3HQwxdUEVzX7iso+s
	 7IHRjBeyUDXkHWYsheuw9nBhdKioNSkv+NA8dyAb2p8rSqt/BE0qwollJ09BiASkY4BMX
	 ZOri6hHs1dvMOUVHT5g0UaIKvObezWVbUxQ9cWpAENCPtdQPRFxT+0xmMdIIgfw2AcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RSxwb000;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07584606A320;
	Sat, 21 Nov 2026 22:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RSxwb000
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67241F000C0;
	Sat, 21 Nov 2026 22:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795299838;
	bh=1ClmkSBdMqTTM2VLnmeQctVTtrpU5Zj3EkOTVngr9nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RSxwb000mXXxntfg6g9QMLdcHWhDdYYyE1eLL6zPNUrRyBADk5ozRhYq6aRmNST1S
	 yFoYNGWmkqHDyDgK4YmokwfgFgn3EKph0j1o2oBdT9bByBQnbbiSkI5tinZt1cm0QK
	 7CE0DMRDG7sAHivdNnA8sB48HlV4nBcytcOMi57M/KnXAeLGXJbaY7ZtJJPLZFKxD1
	 3WwjSCFHUebwkeuD8GEGP3HtgvdbuHTM4PKAuEhmBvBnkZJSCDyq4OhhfivsFesskx
	 5m+ugdeMl34WOgIwagkFpkJgMWL8PKtbK3BoXQHk23vmzOvUnycJsuV7318oH5lMHp
	 2A0i8NZr0wEKQ==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 0000/2812] 6.1.193-rc2 review
Date: Sat, 21 Nov 2026 14:23:50 -0800
Message-ID: <20261121222350.136204-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120055200.707545519@linuxfoundation.org>
References: 
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 20 Nov 2026 06:57:23 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.193 release.
> There are 2812 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
