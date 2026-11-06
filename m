Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793959937;
	b=gObkL/UkfZc3FkjG/4OKwY1yZNEUY2qR6rSzPcKM19GN9Ph0FOfJX4G8iISsULMK5F0p
	 JnjAp+uYVTEX7ZLpZPVTgL7dUe/2p7p5btotDTuFV+uljLVSIqJ/syKspFJuH/jhi0xOo
	 rQg8AG0OvVO2tfme4001B7Y/+BkwOAjxBGa5+2NdLJ2+zyanhx1numun+IhipYeCviLQo
	 JvZxJexiwtA+iG9hfOZpukDdzLXuOIPqowhTzcphSKZmUv3OnBa0nr4Mw4sHmiTJAaL6A
	 z30wfK9Df7+Jmp6HkWaoZn8MIIf+vpvm4MVZL6aQggW77pGJrCYCLnZ6IY2THYHB5/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793959937;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=BoJHi99guAl+SLvHXlExOFrj9K5CUgdGPI4NEL98/hA=;
	b=Dqd5h8yDKNGMDsrJ+Eb+RTHW4MRUqusDELeaFTo42eGgOp6a85JQ6HITEzE+YBztGFkS
	 lotj11F+Qg0dA1saP2+TyCJE98kQgCNNqk1kuPz+CZktRMOJyyOz/KHHdDVSEuUiRO4Js
	 Us3RpNU8EX09GJ/i+mB62qeFrcaLp5edbcpvQcw1vn2mG83Hd22Ff1FQsc3JS9MQMM0B8
	 za9vuL76z2ObAQI3pmUmj3DFjIo3o0/BIxCUEZkYKNkCupuw1+dwoyhwtMtDQS893OZ02
	 pzvTuspCUSxgrgqHfg+8Pzc/c558QJQJW5179ggyje3UllrUBWhHyQEqNit+dxxdFfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.de;
	spf=pass smtp.mailfrom=gmx.de;
	dkim=pass header.d=gmx.de header.i=rwarsow@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=XNgIDZ2p;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CCE606A32F
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 10:12:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48CCE606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.de header.i=rwarsow@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=XNgIDZ2p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1793959898; x=1794564698; i=rwarsow@gmx.de;
	bh=BoJHi99guAl+SLvHXlExOFrj9K5CUgdGPI4NEL98/hA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=XNgIDZ2pBq5avJ2t3en81ahXIU+qeLlR9nRU+WAwmuyjwfeZ+J/Tct1bWfie+8X6
	 1Lb0ESFye7WGYvZX4S9bg8xbjDx+5Jn2Jc4vxsRJsl8GMbQmBMlaSbFMPIryJpXXd
	 qZ15Lky7tUVeNHYDFA01JYLhQWckiRK5sEHSWbPleqtsbMrSpicKd6jCIwhPG6Sfd
	 UxcULApnUgOj+j62Gs0HAkJK++v+aGCLd+cNZG8Mst24OxVxo24D3sVbb4i+ztx8j
	 9mOlWIOqPh7aOPanvqKGk7vlCtqmFVIiKtv22MRAKRrouarEcZ0e8oI35JMi0YzNn
	 E+isSJm/dCSwg7tU/g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MxUnp-1waM5I3egb-014V08; Fri, 06
 Nov 2026 11:11:38 +0100
Message-ID: <ebebc4d2-c2e5-4f48-ae05-d048bb350755@gmx.de>
Date: Fri, 6 Nov 2026 11:11:35 +0100
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
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
To: Jiri Slaby <jirislaby@kernel.org>, Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261104211038.406938024@linuxfoundation.org>
 <3dfb9b8d-3bf7-4fa2-89ec-6561c1b7b70e@gmx.de>
 <2026-11-05-1-daily-reply-0007-7.3.2-rc1-wx@kernel.org>
 <3d2ae531-b076-4dd2-8afe-2f30c7c1d928@gmx.de>
 <fb15f855-e306-4b08-87df-f31a6bbb2a51@kernel.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <fb15f855-e306-4b08-87df-f31a6bbb2a51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BE8NssGNblISFBQFSz/ZiMKrpJP5y1PUa2pVe2J8T0tuqLySTPw
 uFP2GbhAzTg4J2rn/BqhUF0bQeNxRSovyY1ymwN34Vm/tvHfoW4MSUGGAe9bSqIKvrf3Lt9
 WoK6bic64UFmmCsq12LxV0f+q+XdbWBm+mLAZxdYSqZQT5jFFeMyJLiBOjlJOOwKbcaxSO+
 Mml8+rwIYNFTpl6rhgcKQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:humt0+TwIE8=;Xh131h9zoVKfgj5knetk89phQfs
 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

On 06.11.26 07:26, Jiri Slaby wrote:
> On 05. 11. 26, 20:58, Ronald Warsow wrote:
>> On 05.11.26 19:39, Sasha Levin wrote:
>>>> I need to revert:
>>>>
>>>> "x86/mm/pat: Fix effective RW computation in=20
>>>> lookup_address_in_pgd_attr()"
>>>>
>>>> otherwise I get:
>>>>
>>>> [=C2=A0=C2=A0=C2=A0 0.108037] ------------[ cut here ]------------
>>>> [=C2=A0=C2=A0=C2=A0 0.108037] CPA detected W^X
>>>
>=20
> There is ea6fd393cb9e6811a748c7551de0dd3090f9dcde to avoid this false=20
> pos. Care to try that?
>=20
> thanks,

I'm a little overwhelmed and don't really know what to do.

I don't have much experience with Git.


regards
ronald
