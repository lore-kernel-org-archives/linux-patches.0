Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793332086;
	b=IpZc+sRyVF1Jh7eprqSzjqeUSoiR/VxbKFE1q8e89N04VC7L5wnpCrNvBwG8Ym7x4y+j
	 jUK7U44ScxplkIjdg4T54nHfNdQmc5kN7ob5Y81QnzKRKAxOcm50zJUulVG80AzylzkVa
	 FO3pOPotDQk/06eqdwVcbtfqLQ0mC1uXks7gxWt5Y59of9EsmfBbQPeBMmAZmy1NxTvLz
	 bgVeSACUn3Nlht5PK9wwJjAtVepKRdRGdJ1pV+F8G+NE7d1WAqfKWFfQtkFgfEvdQLiQW
	 X/YNKyJdC4LoFA36j9gNQTmo0JVaqiLqZiVPriExGsjgZjO4KZvX1Z4jeGr1AaTpHmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793332086;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=xjPgmkWmjjiepUEqVCYqYWCNkiqSqiBwJ+ovcaPQssc=;
	b=H3lmH3/jQQ/dYp+Q7Zljvid6KX6feooBTF6SBWMj8GG3odpCmhr6uKBlynFnAKlaDVxM
	 Bc5Q5SWDaNNzVnons8u9oee18J1jAvB5vUzbKGAcp214itenb+Om5NE5IdoI8qPNzGPCc
	 0v0f9QKVGXGc/uguuVcN0DOcM/on9BVxCM+0GNgDMoJllD6sQpypne/IVI3NDDiAXQ8fk
	 rGcq6niTnHDuDi3PrUFSHWE6i5BbjK6Dz4+lzYRcI2k5AfR05jaPMKN7ZHJeq10d5w1LF
	 QE9mlMGcoM4090DzJfzqNb5qK9AGhIgwM5JAJuFycUiyeg8zdGSW42+u9fITCIJzD/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=kJKdhpx0;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=ZSDy0WnR;
	arc=none smtp.remote-ip=103.168.172.147
Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FD9606A31A
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 03:48:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00FD9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=kJKdhpx0;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=ZSDy0WnR
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 387F8EC01A1
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 23:48:04 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-03.internal (MEProxy); Thu, 29 Oct 2026 23:48:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1793332084;
	 x=1793418484; bh=xjPgmkWmjjiepUEqVCYqYWCNkiqSqiBwJ+ovcaPQssc=; b=
	kJKdhpx0ffKjoem4/KiPylZjhTLf7l8f+7q7worlDSLXE3y4Yp8fKEYkQpB9jnU+
	Bn8Z/+al8vx9d8p6Cz8mFwkA6SxfkwOkeWEzUd5F1F7JP8QjQS/tUmoyDeBMbBqE
	7WYBevC2mvSZhOWIyMPgz05B3Qp2e6SOngtn9L26f7IeK81Ph6v7+VBCvpGNz/gJ
	UhDBHMasrRGfx6VaVyCBM6cBjMjYM7/CMOWHY8CE4tCZWa+B6i5HEFmFAcYuhIOs
	rmxo9mvIiNp8nObdrGCemKkZCM/6scPxCUzKHFDbKxBEVedAWI6EhSmy9xW/QszI
	Ey6gChQis0KUeTEOtZvAPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793332084; x=
	1793418484; bh=xjPgmkWmjjiepUEqVCYqYWCNkiqSqiBwJ+ovcaPQssc=; b=Z
	SDy0WnRCE+JFObsOaykMOWonYBGtlA5zJ7DofxJRf5S0tgSiZ3CrhOIXvdvtL7Bj
	3azxi7FiACWPHNNc+00glOM+8BVpV9oMroN8LolkbA6B1BfBjvy6Cat7LWzKad6S
	iF6rO5vyPxEK7vkUXn2rtMekddqigB+2Cj5T8kzgC5rFO85+72mK81NZkgDTWZK1
	Rg1eQ9SvLeFwaQD3rGur35UIpLnI7T7Uz63w837QuN3U4/0NtFt51tqXW2T6bNXo
	VAmVHD97Edun2j+IY68O6ammeHuZJ7dNDSgvwCVGNL3SIMqw+pUMGZQkrbrqZK0/
	HNHHSEcd8d6pFbgq4WsxQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793332084; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:K6o4j2fInVhre7eCgv0qxVcYzoYAOBqKnytKUCeUahK0MbZ
	E8iLrvfIV3ANxiTBTVcvM9JNV8XckwaJVffKr07pxOn3hcAd8o/P1a1e77XbIUWy
	RcZxvqziws+YK+H6TaMAeVKlu1a0lW0DBGSig1cpow6TFZsRwxsMTpeJ+t4DMU4V
	QJC4vbFDVh1j1yWrpOATRbibXK1fSa4xG5KAdnuUrgm6+FvcQYKPXVbqc2veIpM7
	ZFOyRWtedsUe2W92k7AvbBALevibWB1i+kqVjzGBI2d2F7OZEskKq4pwrPKYb52h
	SLZR6qk0pf4eU/gqdWt6xuyAKgnYVYOYtHX3uIg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:LbJBPO8stnTw1DJM0JWN8rWn9tnnRa5tvl/WdZCI/Qk=:C2RfkfL3qkMpLNuxu22mGeVII2PRWQNWXyvqFVBT6+I=;
X-ME-Sender: <xms:cxPkao5j2bmD4oCxuHku5vF2k11slswgY6kJbxYhRjAUyUuE018xnw>
    <xme:cxPkalxG7DdJn3s62iMK_bK0DV1eBabqPQl5G_h5NtTUO0V_JAOHoXEx-bAa6qk6S
    UJfPEg5hD4xzocP7SaYdghPVNCymarlRHNGNn5zt1TInG_qz-8LMa0C>
X-ME-Received: <xmr:cxPkai-EtMTiD92BHRqSEqSUp5ZuQXKyOMavyUIqdQLCT3bJOYiboFigx3ODCmvcWHQxXrSSkAy1PgbhEQdCezS2Ge4rE9r_>
X-ME-Proxy-Cause: dmFkZTGCQYDZhVNJFhaM6mm3LC/gLYkMnd+pHPOKmU/pIl7DcfHkEu90SW6zrD160ZojeO
    GOUGrXb43KdjTgMbkg9MkRHEFZD45JvKklzySBbSapQRSyy/s9+ltDhGJTs/ZeT77fzxeA
    xd9vq0x5gML8YSGUr3IdIGhW04YUVO/fGlIKViXwKzckzu8ru6kLKUv6JgDp+3c1TBwDbP
    fbTlT4TMxlwdWa45K6au6RUxV8QQDxwW1KBJB4RjhTdt1HrONv320H+Ho7wbcyxQELRIJz
    004z4wr/EBd3JGMqdkPpI6SvI1MNPNAf6Y+FoDMXAe1wfLRT6wdnTP4amMulSAPC8CACSY
    SzgIX45XhHfqys3RedK7DB/5d4t0rivy1HDxcbXnvLdqH7Da7PPufvh7Zo6AX0aGggmHx9
    9+e0YM5ljsH8XaRFDfhhtDjgYRGS8wBTnqsnlCRQFlXXM/HhiJ9EuISi11n5y6NxXScrtf
    Ufccvm6o8vBq2qtQxmoJqt9t9qyxClguoTP9FVzT8J9vO0tO2y2LQMyWmCg8Are9uly1X2
    Eda0udI7fTV9N/+gadwd6uWd0rEcVIQe1oqp5UsMt5oI5KdTyOSNQ/NsM+8nkXtR8DYY53
    lybIWq4xx3QPgFsJpyAKMj8LPaW+Cd9pBqjPQIe0pjjv/z1Pi2H1ysBbwINQ
X-ME-Proxy: <xmx:cxPkahFsZeB2L4lNYolOIkzOlZdlf5HBBXiDunTyVd38vl-gpTcUlA>
    <xmx:cxPkakACXoMAj53WzXcMPihFjx0LMl9Hp9cwHYYps_3kXqOLpzmMuA>
    <xmx:cxPkatkLaLiGAOwq25BACVtRvtNtUOFsc0FiRRdtYgUmK2UcyRXuXA>
    <xmx:cxPkavQiyCJ167hlNdD7qBjrRAJ6sv6A6v0bkNJVOCU4TBaVQQs_GA>
    <xmx:dBPkauPDUf-kjn851G8M_qV4b-OtgcueVKvlpCHCPXPf2XJ0q_-Rj2l_>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Oct 2026 23:48:01 -0400 (EDT)
Message-ID: <76d96a5d-41d8-48ba-8cd7-64c47ff0559a@pobox.com>
Date: Thu, 29 Oct 2026 20:47:59 -0700
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
Subject: Re: [PATCH 6.18 000/109] 6.18.60-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261028165942.357251485@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 9:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.60 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.60-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1) and an arm64
virtual macihne. Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
