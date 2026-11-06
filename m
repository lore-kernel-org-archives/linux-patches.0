Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793977529;
	b=yqLaQKCl3gwfcZA/Lzu5KXNkGqizMH42qrLRZKVCoSOndk7c5c6nGqVpOfCKgF67nhNU
	 i8XcsDOxuEc+dZ6cGS9jk8x1m1kKO1s3FYlH2W8d3iglodmDsDF6H/ltIW6/UKO64ajHr
	 tqqOC3mZlAUvfoE50ccRl/LhXSiRHnH8exU9VV5pGYPNgg9VXpDN8YQYuJDaLMAUhrT6X
	 YhB0Aik9V2W4GgI4GxL21AJqzKvZ6kL9j5/uGNnLDqPtkA/2XOfdq5lwbM5Du9z9OePsN
	 KYj8RQYRUM4x3QuYAfkOKk8EP0cbxzDc2xvLIHgRyD6ggT1YktRa95qFrty8mlZ29Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793977529;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=tWIw7GbbZmwRZyzRRDz9wqzLXFMD+qm3Vi2BTvOrqMQ=;
	b=FYCyF3MDFqeBkWN1K4GLlXsehbmUoUsUstUcMroi9IeGwluhcoXFrsIsGQz00MNXqB+h
	 0qOjPPDZUDOmi8YsTaTjxE5E4tOs5NSKYmaJZonyZlbUGj8fcT99yfUpgLDTm+CY6X7u9
	 FE1oP+8C9LD5Nr2DRTPlMa57DM+CRDf+QEt5AFKMbu4iWk3wetCX2Vt1uZQW8kn25lsPW
	 tpgJQlFFEJ/vMmTKHbjioPRW0LYezcan+k5yfNshI1oU5OFzhzbrviSBKbG1vR0PopwmE
	 ZrAC/188N02Y0Xs8qrF7nR1lYbl4jMmCVxfhx9OVdcnXEgacIgo6n4BHRfmcg/uDvog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxtx.org;
	spf=pass smtp.mailfrom=linuxtx.org;
	dkim=pass header.d=linuxtx.org header.i=@linuxtx.org header.a=rsa-sha256 header.s=protonmail header.b=DCiOmy+K;
	arc=none smtp.remote-ip=185.70.43.17
Received: from mail-4317.protonmail.ch (mail-4317.protonmail.ch [185.70.43.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D980606D804
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 15:05:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D980606D804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linuxtx.org header.i=@linuxtx.org header.a=rsa-sha256 header.s=protonmail header.b=DCiOmy+K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxtx.org;
	s=protonmail; t=1793977520; x=1794236720;
	bh=tWIw7GbbZmwRZyzRRDz9wqzLXFMD+qm3Vi2BTvOrqMQ=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=DCiOmy+KeCLdEUAFGkNrrmfAN0ExNrQqMZe5BtEro0hVg4MqFiBFbYp067qVcRFFQ
	 RdN5IuP2VnNhRpREIkbok9nPnjTtwgRYsr6k9wEBE2KpxTRKS5a3U0IEZyDQuvRkV/
	 f9Px3DzcYdMWptLpdM8iVbRvnUWTeoTht2Rj1Um1fmAjVe39qQO7Yvu577QLUSICST
	 ygwPOxtQ56yDXA2vCPYzRjm4EIRITiQycRFOVQ1sDu9n48uIrGTTlu3QzCR2COalzF
	 XFZ/BF8LqoNKT3u7awPdHJ7fN4vEctONlSoHnJ5l9hTY/fMDIInlkotqqoV87AJnkO
	 AgvWzn0V+6C1w==
Date: Fri, 06 Nov 2026 15:05:15 +0000
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Justin Forbes <jmforbes@linuxtx.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
Message-ID: <fa6VXGlKXtuVlSLWkggGaz2OVaAuB8DLwX4RhY2VNnz_BS1U7Qn32A2ihaYdhplnk8dNpDG_4ZVV6Zs4WigyYBl-mEb1I-cmKlES5Bchomw=@linuxtx.org>
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
Feedback-ID: 225434474:user:proton
X-Pm-Message-ID: f82d7f49348ffd00d56e54c3a72d3058a0984ed4
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable





On Wednesday, November 4th, 2026 at 5:40 PM, Greg Kroah-Hartman <gregkh@lin=
uxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.3.2 release.
> There are 547 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 06 Nov 2026 21:07:23 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> =09https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.2=
-rc1.gz
> or in the git tree and branch at:
> =09git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.g=
it linux-7.3.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x, x86_64=
), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
