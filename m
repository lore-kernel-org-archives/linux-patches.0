Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065688;
	b=eb3lq6ACLxGUBwFXt7UJwlPmgXJxXQ6rfMWmHzwEa25MC+ZrBayEuLdQ/vtDmldSOhw+
	 dYxnddSOjvwuyXyymlCEWENDnqIm+Lox4ffHAiY6BRvXw1iaJ2zpG3jIUP/k/VGgDobk7
	 Bn3GLIlG4V3lkXlycLblAnaemAnbDClxnf5kCsrujUzxzwjK++l4MADZgbaBfV8rezN5t
	 GCuSXWvb0Kh9K6iAIseF2ziS/+Cl/4h8KJmNedIXMR/qhqWzAHfm+Ztt4Hce7Y3+uVFWs
	 W0iBksfVz/ksNGRYcgBQUiqiNMjxWprZDXWd4vEXhx3NsWLtA+I4R1aNZyIfwUeLaeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065688;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=9NKdXwe9f2kW7w8U9lnyj2G4+uLMkRAnRlQTV8BMZWo=;
	b=z7NGIyYXpHD18lW84L/URW9teOZXzGpDSQfiFXRgbCfq4h11Cd9vN4zI5+QLd7H3jPXg
	 +wwL5nM9OgZxY2WShQ/xFfG13nNxoeCjtiI1gORCA2LhdTRTTlbC1/73gPSRnNlrCd5K/
	 xFTSne5WWl7B3Osx3FFWZ2+x3kEo4mwXAHhF4HCygz/7R8CjnNwATHOWDKEk7+17dqiPW
	 9toPY1dY7dvZfnVKTNrtSQTpYEnGgWSYFmn1AOX0XEyPywX5R/sxgA3VtFtuaPOSw7Ima
	 UvZGuHTm1x2fZsgDwfWBZrqdxwRlkha18Kx0fqp6Yo0ZOoXtwVTG8HrXKi5THEUwX5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.de;
	spf=pass smtp.mailfrom=gmx.de;
	dkim=pass header.d=gmx.de header.i=rwarsow@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=Uif2IOz1;
	arc=none smtp.remote-ip=212.227.15.19
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6353A606A32C
	for <patches@lists.linux.dev>; Sat,  7 Nov 2026 15:34:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6353A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=Uif2IOz1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1794065679; x=1794670479; i=rwarsow@gmx.de;
	bh=9NKdXwe9f2kW7w8U9lnyj2G4+uLMkRAnRlQTV8BMZWo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Uif2IOz1kOSSa9oCh5bWAc84+B6I4wXyzfQlXe5k0TQu6lbb8RJyyDphlMJqSQFY
	 6SeeEXiq/LDa6Xz/9f0fuoMeUZbYPw70xQHiCPCzPjpHRCVA/g8GcKZmJWrxebJVR
	 UOoeONBb9Y8AXPhHQvSisDBllLPhCLGVW6XMcDGPHn5/84+PTl2srKwkqRPbRquy8
	 DLVgW7cYrN7OmogdBNIChgjM4Oo0I5fnEa51EDfWUVkNQKkfajNw/O5h3DCe72bD2
	 ARibHTpzfjq9JW17UwlNmHmrdu89BT0Dy79vRfwNxEPcz2+uoWXLafW/b63PDwAXe
	 BnUxsF1YFTwZNtYvVA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M7sHo-1xTaKC3lUg-004yDd; Sat, 07
 Nov 2026 16:34:39 +0100
Message-ID: <68c2efb8-e54f-40bc-9c36-76c719a590d5@gmx.de>
Date: Sat, 7 Nov 2026 16:34:36 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 0000/1257] 7.3.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261107134939.434104957@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DvI/PqCXzV7eqtIbUt2lwRfS5hrAznWoqV6EyN0Rogxor9VxQlJ
 +WgND+UloTxs7vIMaU6OStB2jnkL3oSCInfMNqQEJ0G5b0ukvTLRD3QjjWXmzJ2SZ9jzeYc
 IW0HEA2r9jRRUUEuJWT3U9VI7ulfC3uLANX3LtLWIn3fecwovUyUe7jTi2EuGHvx+CIL06E
 ky0HP7f5SByNH1d/gTRAQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:2OCsrdo8xpg=;R6wMfPFiFRzykrWTmS2EOLjnvVG
 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

Hi

kernel build / boot test on x86_64 (Intel).

I need to revert (here)

1564da6afd7ce5297ba24f2d1e61d6a79a9ff6db


otherwise I get:

In file included from kernel/sched/build_policy.c:71:
kernel/sched/ext/ext.c: In function =E2=80=98check_rq_for_timeouts=E2=80=
=99:
kernel/sched/ext/ext.c:3852:41: error: implicit declaration of function=20
=E2=80=98scx_exec_sched=E2=80=99; did you mean =E2=80=98scx_prog_sched=E2=
=80=99?=20
[-Wimplicit-function-declaration]
  3852 |                 struct scx_sched *sch =3D=20
scx_exec_sched(scx_task_sched(p), cpu_of(rq));
       |                                         ^~~~~~~~~~~~~~
       |                                         scx_prog_sched
kernel/sched/ext/ext.c:3852:41: error: initialization of =E2=80=98struct=
=20
scx_sched *=E2=80=99 from =E2=80=98int=E2=80=99 makes pointer from integer=
 without a cast=20
[-Wint-conversion]
make[4]: *** [scripts/Makefile.build:290: kernel/sched/build_policy.o]=20
Error 1
make[3]: *** [scripts/Makefile.build:551: kernel/sched] Error 2
make[2]: *** [scripts/Makefile.build:551: kernel] Error 2
make[2]: *** Waiting for unfinished jobs....


apart from that no regression

same .config:
https://marc.info/?l=3Dlinux-kernel&m=3D179390956799135&w=3D4

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
