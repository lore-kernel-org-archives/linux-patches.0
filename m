Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795147089;
	b=Boag1nanH6d6xkqL/lpZdVDOHZ7TqFETGulC8811/oikJjVa98br8DdA8DMKp0V7g0jv
	 DorGvIHGA66I+U9jijenIFvQU8cWFpCdARxQbqeleAV/xDevhc0NTffisZiQwp9abwZbZ
	 IpWqWk4DgFt7JZgmT+JBB+04wJi06gpGfxq9UikOpSPwl/iOVWVcG2a9ZbqLUzROYaVWj
	 1KZupDLSTOHtwnStV8Rovpr61HRV8IBvd/ZXN/zTMpuQyqgT8LTOY32uMLKJ3GoRbX+nc
	 lao/w/OQinQdCTNEGni9oycmw1rPhQRpB5a7khtZjmAPRv8AYulg2Fz/mHM8LRCEYHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795147089;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=uLsKXEDhwGYD4vln9h1lh8iifiE+0MXQN0SUM4cCLMc=;
	b=DzbacE8gtZ4gdYSrYBH1RfGRzcXBZ7O6c13eut+hFqHDaUmOPdWOLVSiyQUu6Oe1d2FD
	 /aqbECHy2b5sRLPjqigUcs5Yayjdtf46gp+dSXmwROda8R4ccK8fpjTY+qxOwZzzvuvv8
	 nq32cn3tCZHcr3lJpO1JgUV5ZHPPvHs+w1M5jMIh/vaMExzCDGkn78spfkxIXVnMHeBuN
	 pbdw5vP3GO013y0QosMRw1hNbJ4JW+LTcVL1D3eiPvpeBh2eOSy/Spaf7MmkZLuainEkG
	 LJzQnAasI0PGcafYCTWpuGYLlXqOvYs+FehemleDXcpzitaawWRw1tyAAWxtFghD0iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	arc=none smtp.remote-ip=202.12.124.145
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B850606A320
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 03:58:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B850606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 156621D002D2
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 22:58:08 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-03.internal (MEProxy); Thu, 19 Nov 2026 22:58:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795147087;
	 x=1795233487; bh=uLsKXEDhwGYD4vln9h1lh8iifiE+0MXQN0SUM4cCLMc=; b=
	f9DHTC0K9e7U7aEPG4E7BiobwHY8HmqeZvPCGH7HP+cGDTiH39jRj+Nc4Xab1hiY
	XLH39oY+kNpur8kLKy2RRUjse4YUkRRF6hgB9YAM9QapJ24gzIqSatOQVivifp6n
	04Gg2NjWbB0aVg3WMwMfGl6kUf4w99rR35VSR9jFJ6rRg4H76cfTzQghTq/fxvD0
	cPPfYhOQKB2AdM9mXAc9fyQ26QIEH/FH+Trpdmo2j6q1N/C9iP1ABH5yxLt0KI5s
	pJfFV6+MYSZyYcUbHzFpBMv/3R/WCy4fZ2qUxH6dTmntfPspTcAYu41v1KmJ4XkF
	htrgkFyhB/oqAa7oN8mlUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795147087; x=
	1795233487; bh=uLsKXEDhwGYD4vln9h1lh8iifiE+0MXQN0SUM4cCLMc=; b=r
	PsUV/JIenWUfICsP0xqRw9Vd4B69PcTKzjY7sxRzSLqOCWBT0OSUGf1TZ6sy+X/r
	1YbY5lDMGoMiK1IShhE14ykjMdPvm9pRylFFkakHjgrD219rnv9J8RqwzR15bxfh
	+kYrIAXKQUmwSjekoMzVrUNren8YA8FBGBS1uFYzM+88JHjpuDGouMjKw73FM5Dc
	JmIyWwh++JgpKngeEUPAzqZCHjkrZccmVJj5I3WGyUHzkCXW/8cRJ4ojp4ceGzK5
	3O7T8CpJonOOkC4tOVyZNBr20fQj5lsMPAhYGShZdJE5Bl06KrvHaHq4l2W8lD5h
	Z/EAFIBw/1CMfrhyabVaQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795147087; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:FoDx2SfQBToTiQIGcTSkPMkCnNGIqujPr+m9EAcHY6twJwK
	4LxJday5sIngE+aZ77Niamk3kt/KdiiDGvSOMYIBqOHQast7tPTMkO7hEKO91hIs
	KxrsdHmT7+YcUZRhvTkUDfkKiQfBDNAjUg7BO0/pZj6vrS0Xryi8rju1T2cSAwz2
	P5Qo4b0mi4QdswXrZnluzxdf5LspkZudA2iy4OsK9di9dCdAs58HwFC9qCURLmbf
	IF6zncvdvaHNJjfwyLD1V5fg7fLZytTHDy17lRLSzdRUEjjaJtegluXz1+KRAxOI
	1/TOuKvDMlWcuVgaC7bNqN24XcPG/5gGIcweElg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:CaipM/szxdh5jNlELhKOkh0Iks+KbHBUkEqOottiWUY=:+hU6iUvmVtlhho0PKAKSHIC6/4zALy6S6Q7cMGRkSMo=;
X-ME-Sender: <xms:TcX_ar-eNJzNpLxp4R0OkC1XDe6a1V4rV32MfU0jxT87qEG9Zm5IRQ>
    <xme:TcX_arp4RZEI4RwLPc1p-AEf4PuNmuAuLDkvf6z9jfzmP3FnoclPBh3eddaWyJOjY
    DWiQeOHq4e6vLS5nhNewQWFzLbOHC5gnQh3ebdZ2R4hll5_TDp8GQl8>
X-ME-Received: <xmr:TcX_ahjDQCWTMIqsQkEXNOW8xyq_2tIqmLB46Eio2JjDGRnhAs6QpXljffUHd-LY_ZrkIX7-le8kNHN22O_FCs1m7p7TfhsI>
X-ME-Proxy-Cause: dmFkZTFDyfYCSEZ3aLEtRQuMdExUXBO/ouLd0M829jFBQClPaz8n66R9zfy6U9KeTTiYSS
    96sVhVREBicTnVdaRx/XDt+H4+mUbCnFaKHBStiqdidKA++nwEZOb/cipeyIxE1sTzvxIS
    8xUKN5dHngT1nc9oUZNerj3V4Ew9Q2Ox652H4mpxLkQ1Y2kx8Woy4Q/Prt2o3fs1SXSLHZ
    FoFYDHnLhKzFEYl06oRO5/ypZ8hHJDtVQ4fqzBlotRnyCMPfAxp1fBlbQEYLFXduLlZRgG
    rI/hvLhMAukmzcKtEQfz98FnEGw5g/F/RXGRpzQhaHlYGvR5aCgInJ4CaERbdEDU5y2LYz
    7UvVh9ufMrg9kCNbbUcvD3+j8QxTMRoYIPBrpH3ZQ/NnjEiK0KDmv4Hzg3jPOW/QCS+mfz
    J0W7V9e/KH34/PYL6awDQfmCA8YUHiyDi11A2n0T6LPKKqXgCDhA7MD6wLzlofu0njmz6V
    l7AgsfKXDJn5oJSC2UQLRYIbwgX+wNvXyHMrHjRGC6iY6Ug8pUBmKw1BRTrBNRdNsf7ai6
    GiuiI6qnzmW9mSAxzOJLdSER25cAU24G8FJ2jEAcWO5OZM/IQ/w1SDGe536JG9ToWIsTAz
    b8riGOrU+MU445Ks0ohaxR2IHvfCHgmuRu9jW54GUOTkmmQl4083J9k3gC4g
X-ME-Proxy: <xmx:TcX_ahCy1icLOSVj-mImtF1ng4RXEFrI-l2zOTWj4712oR7KZQj6JQ>
    <xmx:TsX_anuD7K_nM3j7smk8HJXl9TWaOEB8Y-jSv-50m-iJAccP_2gwcQ>
    <xmx:TsX_aj6PgURTPVCaZHxEPJYFYOwAew9ZJS5xHF5WbpUoIKwZHxRMAw>
    <xmx:TsX_apfX9LJt9M0qjAn_AuTsOvjzOgdZWx32q3ymYpYAmMrd3hTyoQ>
    <xmx:T8X_aiy-sJGJo6CyOT4j_cunB5PSFwPetoG88sXM0DIuZFFsiaiSRp5v>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 22:58:03 -0500 (EST)
Message-ID: <1b91d4e9-cfce-4974-83fd-6e2b72ce0168@pobox.com>
Date: Thu, 19 Nov 2026 19:58:01 -0800
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
Subject: Re: [PATCH 5.10 0000/1848] 5.10.275-rc1 review
To: Sasha Levin <sashal@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Brett A C Sheffield <bacs@librecast.net>,
 Dominique Martinet <asmadeus@codewreck.org>
References: <20261118145911.150052362@linuxfoundation.org>
 <2cc4e958-33bc-45f7-bbd9-c6763fa3a8d0@linuxfoundation.org>
 <20261120020908.2320910-7-sashal@kernel.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261120020908.2320910-7-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/19/26 6:09 PM, Sasha Levin wrote:
> On Wed, Nov 18, 2026 at 06:02:21PM -0700, Shuah Khan wrote:
>> net/core/filter.c:5867:26: error: implicit declaration of function ‘seg6_get_srh
>> ’ [-Werror=implicit-function-declaration]
> 
> This is e8b084646b94 ("bpf: Validate the SRH which End.DT6 uncovers in
> End.BPF"), which calls seg6_get_srh(); 5.10 does not have that function.
> It is dropped from the 5.10 queue together with 434324c611a9 ("bpf: Pull
> the inner header for End.DT6 in End.BPF"), which relies on it.
> 427e751a231a ("bpf: Update the SRH state if End.B6 fails late") stays.

This fixed the build for me. Thanks!
-- 
-Barry K. Nathan  <barryn@pobox.com>
