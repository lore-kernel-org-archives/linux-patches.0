Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=80.241.56.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207009;
	b=qmveEQ/9ejJLExh2HDOixm/Y0wjDqSWgffNcEGcpGdkH4yRZ8QE5rLLA9cL6ifAZS86Y
	 NzkyZM3NXyaxcmKX/TARhF6aKajirI7kHwFIy9hX66YbSRdhjH8AUwNsEyEn78hE7tJQv
	 9oMbAS8wLvmX6XojM2pph8u4PsG2UjSnmfId+RNOKBn2ryUZn9jT9zKNHiFIjKOM3svvi
	 gb4eIOwwmI3nfXp/BTX9VAyWERCJGot/BZ3joKBjvHe+RJnWvME1W7vJntFLhinmE7Tzh
	 qw6cXjxAZNT/7Vq6ZNuqJY9FDo/m9bCiYknUkuLXe/7HI4t/ryNZNOVvA4Erof4Fj5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207009;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-Rspamd-Queue-Id;
	bh=NaPReRPJ1oLYrJ6cWmfrT2XB8nUvdUbNMjhFYYlgHCg=;
	b=KW2EsFQkpzu3IqaSvLuvL5Hq3XXUiPExXeoeOT/ZKWkohQTQjO2pZgIZfLaSC+tQFJR3
	 +T4JTdcpSH6PC4rIfEUJL6IZzr2UJjlZFQy4VHD+SU5gf1UDPvkwlf9vI+2fuDO7uycjG
	 Vgfsa6ppLHOe8eDESPS1hWEIAo//QSsXwCfDo+MjqFpQy1h4BfEBYyp7L0Bgx7HfEJAkz
	 t4Cb3TLia3XQlHru1wnUwN+z3Jxqm/UfruOD4uLngDk8HlfjutWMwHzHlp1MptjcW9qN6
	 Foy4bu62PqruJNf/glbhN64rlvcs+ycG0ODovl3Xyh19oeIyp+0O/EHM5jMNKzwD+FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=steffen.cc;
	spf=pass smtp.mailfrom=steffen.cc;
	dkim=pass header.d=steffen.cc header.i=@steffen.cc header.a=rsa-sha256 header.s=MBO0001 header.b=SN4eTt1h;
	arc=none smtp.remote-ip=80.241.56.151
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C25606A6DF
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 20:36:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35C25606A6DF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=steffen.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=steffen.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=steffen.cc header.i=@steffen.cc header.a=rsa-sha256 header.s=MBO0001 header.b=SN4eTt1h
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4jWRvZ3970z8vVN;
	Fri, 20 Nov 2026 21:36:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=steffen.cc; s=MBO0001;
	t=1795207002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NaPReRPJ1oLYrJ6cWmfrT2XB8nUvdUbNMjhFYYlgHCg=;
	b=SN4eTt1h8lCCIob+lm9xaExLasOJ/vJ4P1xR2KXWt+x6QlsKdWM/7iUynFmbp4s5FBJXl3
	ALxFw5fRFvvhRzwOL2CvPeIMwc+/Wy68pxMo1UR+5JVKTa15nVo5W0KnAkCeZ0J6QTB7Ax
	xpXseGy9yZovQMHVNpHy2wsobdq267vQiRDlGOeqtt0ug1/CXdvJv4SmG8oupGxX/gssyF
	ahilF7aByTejLe/n5R0PgAudR3qFrjWjAcN3hVG2pVwIZRwjGXJXCV1n24od3T3Z2eiJLl
	gMYeyM0ukAe34Gwb9o+nbjIm41uUlCM3pkEP5kstNgUtGig9r9VuHxgp6P/5mQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of lists@steffen.cc designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=lists@steffen.cc
Message-ID: <78dafd3129be731571810229c6ec8b2ec969625b.camel@dirkwinkel.cc>
Subject: Re: [PATCH 7.3 0000/2642] 7.3.6-rc2 review
From: Steffen Dirkwinkel <lists@steffen.cc>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 	achill@achill.org, sr@sladewatkins.com
Date: Fri, 20 Nov 2026 21:36:37 +0100
In-Reply-To: <20261120055248.913352689@linuxfoundation.org>
References: <20261120055248.913352689@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.62.1 
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Rspamd-Queue-Id: 4jWRvZ3970z8vVN

On Fri, 20 Nov 2026 06:58:20 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2642 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> =09https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.6=
-rc2.gz
> or in the git tree and branch at:
> =09git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.g=
it linux-7.3.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

Tested on 24 device types (booting, general system tests, rt).

Tested-by: Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>
