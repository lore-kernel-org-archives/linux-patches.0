Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792873816;
	b=mKwBgY0J7W1RDr0/+jf7ErQS7plIXzoBA3DW8mEA/Sd8ltgdD5FM3D1lCVEYMZebCRyE
	 0XcwYuTdcwuQzSZLZN7eDUg9o+pkIa4onFIaOB5bpbAr5tatuRMTF1K2fcCb4yYCVH+7S
	 eNAAEosPYRRrSGojxAevHDeLuO7bikkaeEKD9ebW7cxWaK0VMoUNCh3vxe0z7MHBpph/K
	 F+BRoi/M2U26x3p6Qy2gQ8AhfC3uCwG6GnSbG9RJBzfs3EJTLenFCpaRwwcY98P7z1W9Q
	 CjAq34sdkXZAy2LHzJpjily6pXcpAMM34O+NWTGLxdTuBcemJqhWq+TYZH1lUkAFfgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792873816;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=927lNsR4JfrRM6StnTic6/mHC7Xbf7bJRocywi8MrQY=;
	b=xBlgVcRmcptOoKXoqQN/myJtkoAGGNdUNSIqLmBmiAJw3tjwAPLb6w4sMTcuCUmnXTm5
	 b6sa1y0pPI+bzWCdXsq5X90pXtt0v6WBtTm3tyduK+RW/L6glHzFhISjf9/5HPttNx0ak
	 4yFzUj4fWTHfGpSd4SRuLQUtRhX9yvWeHOieWYAtszwF5eozPXqmZqiYj4LgpxnOZU1mg
	 sojOIb3mojRHlYapRDHRD9DnivRgkbhiISGaY2jOghdY1gLgnpEl0sLFt5He+ASmWRLjt
	 cIvhJ2eWUcGytN6KrEe+wKydzhB68Whz2Kf/RkFC0wlAQzdjej6jGB2XmOhORwzq8NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxtx.org;
	spf=pass smtp.mailfrom=linuxtx.org;
	arc=none smtp.remote-ip=185.70.43.20
Received: from mail-4320.protonmail.ch (mail-4320.protonmail.ch [185.70.43.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2122F606A321
	for <patches@lists.linux.dev>; Sat, 24 Oct 2026 20:30:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2122F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxtx.org;
	s=protonmail; t=1792873807; x=1793133007;
	bh=927lNsR4JfrRM6StnTic6/mHC7Xbf7bJRocywi8MrQY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=N17d/IrYU+4aHZVioxr2rndn49L8MvhODWPzbRFe5mzfZBoIEqkne/LaU0Pgsj+ag
	 NeoOYIihHo9UtElQD/VcQa/k6AFXe9YrirmnUGM+gUPnIRoMELXK1tn1PzwG221EJV
	 OhiRUL0aVgFHU/avdsSeR1SMGtKkGC631gnjmWVSpUCSpgxdqQqqMnVFVkXLPr/hRn
	 qFwU1I6zGKVvFdZytoUwvW2CD3aWtt8JCXhMzJZzZQB+6oTfjEgeBhKMYKsZxgsgsx
	 Q0pApo5hvUgReMliVRQNHW6AFDgZVFMoKkeJdESJt177k9tTf7LkVZZRSNmvk3LEJs
	 CiqX57FTMqesA==
Date: Sat, 24 Oct 2026 20:30:02 +0000
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Justin Forbes <jmforbes@linuxtx.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/243] 7.2.13-rc2 review
Message-ID: <kPklqauDGec1Ky9bhwYavsbiIootLwLitPj_dGqt1dluwnevCz4O5He3Zyvv2TTOa13j0ViBuSRuyent7DXGTZS5BMrU-sYlVHNY7IL591I=@linuxtx.org>
In-Reply-To: <20261024064731.125251200@linuxfoundation.org>
References: <20261024064731.125251200@linuxfoundation.org>
Feedback-ID: 225434474:user:proton
X-Pm-Message-ID: 5d4c16cc7fef0c8f749acfbf93dc1c8557222f3d
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





On Saturday, October 24th, 2026 at 1:00 AM, Greg Kroah-Hartman <gregkh@linu=
xfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.2.13 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Mon, 26 Oct 2026 06:46:54 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> =09https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.1=
3-rc2.gz
> or in the git tree and branch at:
> =09git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.g=
it linux-7.2.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h


Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,x86_64)=
, and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>

