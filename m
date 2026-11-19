Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795111750;
	b=QIGi8ZzHD7QBdPBdRtHXXTLALa8VcGB/HlMUYYQ5dPEM6hOl5lAr4x0ou+6B89z3IiIx
	 Z6DUWMOlEAWWyJesqwJKgZ9DQDPoAJ4WTezrIapa/tapMlG2Z/hxv4LOUE77aMAZ0Ixs3
	 ZLaZGj+3mgXWc1Rl6kHEttDiB82YJmFZL24EeEuUEhME+9gtARpOvTEMOs+u9J/O1VzhY
	 VACjRpx80PK8IneW2Cxych6cIQd4L6kr0olgYQHLf8Z/SIhst78jM+Z/rhAb9tkoewnsh
	 z3XO3rZuSEv9JdbLiQuwPRmbEvRwRQwRgx4JosL/TPxvY0mEv92ffsmonjYK+e+wujQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795111750;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=+4eRzERlyL4Gy5rKxVPXgPLOnhYhfMOqFyyRiszmgR8=;
	b=tSxJAEJfkvv/aZqYh+0k2FstxgQqoTE+XaWEP/AV4rYx7ijNVxYL6gnDtRdxjQMJ5jzq
	 jd5zfnCDy26tsrHYwtPkoTyCYjSo5LrAqpLRIzjUra8aUgNRqDgiCYdAAW/ck2dscoJ0z
	 BPUGvCZymvkvAYHBMy/BOHs3wfGh3ASwnccPKJVcKlM6OZmyHSObrLbYOwtrzVEJCyzvY
	 6Oi3s/7Y1KiknklsGe46NIxKI/N5G+P62j+LVupeeuoeD8Kxws2Ox7PBKtso3YLV0qa5r
	 RkbzkqgPjQ4JdFs9MNSlgtKR+Be6sVlMPd9D4dpwFZx0Wj3e/1Ef8wIVLiiqTmPpOIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=SqBm91O+;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=NCHxG0UE;
	arc=none smtp.remote-ip=202.12.124.151
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E75606A326
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 18:09:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2E75606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=SqBm91O+;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=NCHxG0UE
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.stl.internal (Postfix) with ESMTP id 591431D002C5
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 13:09:09 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-12.internal (MEProxy); Thu, 19 Nov 2026 13:09:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795111748;
	 x=1795198148; bh=+4eRzERlyL4Gy5rKxVPXgPLOnhYhfMOqFyyRiszmgR8=; b=
	SqBm91O+lP0+gsBnyoixdjXmTTwLZs2T3qSsBWHMDWv9zT+BFAozNyCVakIOC97m
	CWVNQNJb7Ykiy4tW7S5vNvzBkDe8UpoGiuaSSC8FNq20bm7YG4MrI5GqEBvoBJAr
	OFZ3xGMsOy8LfqzJIrIeKtE8sV7jyFyWe1oRkJsX+XEDqMEJsWwajJRttW6Qo37l
	ii3txkxndQh67kqOWOafm9PexvldglPDvZ4SFr1ToacVAhFupcP6NDx1PTM2Vrxo
	+t4/oJqCJ7JP91XvmaSq/+rvX+xeAsbR+L/1pXkEY73SrlOgNMfbGXrYiZ2A71G7
	gspB8NyyM2cgp5V+pEj0cA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795111748; x=
	1795198148; bh=+4eRzERlyL4Gy5rKxVPXgPLOnhYhfMOqFyyRiszmgR8=; b=N
	CHxG0UE1py/mtAkRGPYRs9vLSYvKP+1iy2+QmLbqmEvP1I3rEE4CKaBEKVi8NSDL
	RVVSw7Z7y7oqT43q+ELw51vjiOaPY77W607cIIujuvP9+YN8nbpkFsMUDDCMacEB
	2Qm+jTBoInRmvkspkWb58Skn+ZGMVJ3nPboyLV6+nGRrjQraXLPybObsCobRc3zY
	8FofEgNUMIB18UYYZ6sAkih2W4S2iXdbhifx5NRnzqE0h7KSWchRB4PxQkns6Bmb
	0o7HTCl+AkRgnVX9v/YJVoXn0CI6jHY0S8jMlhj8rwVaFlZCE/VGKwPQ2EAYNalY
	0zz4siyFjnZUWD/xLmsYg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795111748; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:R2z1DHaF1hRbYL8BkCUT53e/RZlrPIH7wqI8MW66l8o9Yp2
	Lo72HGN+cMfAHbZv1q3Ai2kmRnrbFjd5F5/I7QALjBJi3C3LUoc1P2pf/ylxPX4E
	2h+/sHFXRv3TBMRzjRSU/IguwUj8VyRM/334c0Os4jl4/EL5V2Zt4WSea+3Mbbj/
	oO14cwntWakHqQCcem669QO8LkDQhrWp1JhJBPY1Gcx4MImYWSSCfzuR8RSVRxA8
	6Onbcwk3y+B3La7f7aPQTwRN4mDk+jTQ638sV4iVZMsaTQ9ill967S5h+O/zLlB0
	owQUaSsk0lHc6h90pNJegblGXNJ7Ml7p1oddS3A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:DBiyysXeh3c5Ruv7qum0t68PgBpu1m+BgYdalJ+J7mU=:baWaKOdOcLIRGOCrJ9MBilqhkD1lsr6cnkcEGPI1F8I=;
X-ME-Sender: <xms:Qzv_agPGsLutWPTzO0oMOR-AXXtKlKeUzyjZOwNH_n264itKmf3-0Q>
    <xme:Qzv_ai1Q8rxdiuxNChjuFRud7xLKndmBzP8TtXMGiEGoWHcX38wrIRVGsswfOHAnU
    HQqTkxZ18uU_UEBbfqK_5q98qPRtBYlm75Pa-qGwPKuvZSrvpx44qpa>
X-ME-Received: <xmr:Qzv_aix4xB8FDf663b7_KoTeK_ciWihB0RVFa9DPL4fYFHyzHO_wiFIPTfCq25_iq3oF-bpPqMGze1tNx6dikFNFwKkRbmO7>
X-ME-Proxy-Cause: dmFkZTGCbh3eUcpMmC+HGc/3W3sfQrJEuu0WVwf+7chX6bsEJSd2CtoeCQiLQCAst38BVJ
    rqp08lkzWflDLaKMxwKA07BA2W1yZJHsedXnKGHBLDhs000yZKFuBI9CDaoLw38NBB0TcC
    PJeYvOXShHphnwriWtuBC9iJH9vd+dka/xrQz2HnwZ5259z1r6/keY/mIl+59CaAj4mpc6
    rRDGTjp7jaddghaDZkfADNMsq5/P1JBlajWZbL8D2w71yAlX/Krf7+RGYp0zrV8tAhc/7r
    9kHp0/vplmqNrbOi2C4C30iYU+VeeTessG7XYCAtx4tx2Pn0qzfhRHww+P6rtkkJiIgFFH
    qOrwyBJlrRHdN7SNKtA2Bt0XDVe0X/DhE9ih9/w8NNEkX241svkpEUl9SGctbEg87GmQEk
    zWvbYITfdmMwzSW2ETdArrKTVW4MrjrFKd7DDjJrOqzxOR2+cXBKsNt6dAd55y1yWcBHTb
    jI8TkeL4z7PrM3rBGvCaHRW9bSZmc5xQspiOJTrLg71j+VaFT7ncrRgQf59lBtNFon3uie
    xjCYjeFAHoiqD4Zb8klKK0PkHGpEdvv4Kin6B46cMM8yWYITgmDZoQ/UKhyv3z9s4GF2Yo
    KS7VL4BFqS5TURtXFvCltuEPvHwnA77C40EUVqyZVoTHThtu1+pthCsl/iVg
X-ME-Proxy: <xmx:Qzv_asqcoU4IfiolIG5TYCxAk6ro4mzppz9raJmezvwZ9iQSPHhkhQ>
    <xmx:Qzv_agX3UN9zeasS-A9Wy_6BJt3OMiagAzFupUj_-ZwkL2d1doPBmw>
    <xmx:Qzv_arpBX6Kb4U9VMQkEPRl6b5-kkhsruKmXzHmRfrmBYzFIxp61Pw>
    <xmx:Qzv_asE53qSpnsnhNo38D_utQ3I1OlsYIKdEZXcWfrTg9dj4uIfhjw>
    <xmx:RDv_aihmTi5i8GSP57dImLskvHIvDn8d9psP9SX-0ytucB7LY0BSdhrI>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 13:09:05 -0500 (EST)
Message-ID: <143834b1-d430-4e5f-8140-3e17fbed3b14@pobox.com>
Date: Thu, 19 Nov 2026 10:09:04 -0800
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
Subject: Re: [PATCH 6.6 0000/3318] 6.6.163-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261118150313.527275416@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 6:10 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.163 release.
> There are 3318 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.163-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
