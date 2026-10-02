Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787CA33A9E2
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 01:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790905625; cv=none; b=ULYkiFDJyEc0Y66TusQqLy/hNTiCn8vVt0t+5A7M1Itp/WGvsm5svVh3xbHjdb0SF/Auhzstt9ofUipTpH+dUqt56UIt1SLx4HnGU26na51qCQHSsxr+tLJ9mLGc2Lp3jrmfSaOtDPtB0XQfUJCtANhJt80ANSfe1iuZgHdtLAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790905625; c=relaxed/simple;
	bh=CKI77JhgN4DNbeVFs9I5IJHGYZIfdR4R7EszDtpuNUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t2VnB3TtecevRrIrWrL8XKKYi9G584xubrCNBHxSQMpFuYVNne8ZNz3U+oH/2YbrxFnleoYS1jv0M6Q3NAsJ5KLCqBDq9Gxwmv6y7hKp/39vstONR2sPbYZzjYea4IYH+MDWcqWw2JOx80ribDULCYylgomnKmyaqQHltIqr+lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=Nm+EDUwR; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jOT2TIXY; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="Nm+EDUwR";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jOT2TIXY"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id CD1841D000FD
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 21:47:03 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-06.internal (MEProxy); Thu, 01 Oct 2026 21:47:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1790905623;
	 x=1790992023; bh=UGZD/JMLwguZ9NcqBhxtwjcUHVAGm56JMcwoDYs7uvE=; b=
	Nm+EDUwRLobteZmxeU9gIPYP9FEobAJCKZpPN7mo3AiippMPIlJnhxVFjieIUqWO
	pvlyIHdV+z/pMmU/TPc+sQuqPt+cFeSDgcFAy1hB1tpy5qPRKynR+Iuy5VOA/dXW
	z43OKD8jhJH6k8CYlP8/RRwtsvCuSbwUrhKycnXF3EUg4T2c2BXRGtQGy60xrI3R
	nrtR+ybwgApwubRURyCJEZKtkMMHY+buVMjAUqisUYdcymaBJX6t7A+Dn0qlJS9/
	WyNGtoU537Cm0VvP1an8rKyOFsSP+nfOIlj8ZWRNN4ypFX3TK2Ry4NAhHvbbRNOH
	wgD3j7MFp6yrjXMRDXGIgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790905623; x=
	1790992023; bh=UGZD/JMLwguZ9NcqBhxtwjcUHVAGm56JMcwoDYs7uvE=; b=j
	OT2TIXYzmEIBGGwruP/wdJn4sErQLfdfef8Ow1MjT3vunhCb6OVHmFCHsNq078WG
	eUyz43+rhMuvJsdSnfGx6+5DmP6dbo9rpyNoD3jJIJ4vzqXYh9wsLC0gQKb9oX75
	34WCDjLbwh61RNmR/jjJIMOEk41rsrBdvATkLzKVAvy9/WL6hMXjfo3AwRPq+NAu
	cbvPyoJjZBS0K0doheeoq6qUOHmPmTlzdjFofnSL+/jL3ZLVhCtVnCqm9GTNj7Vd
	SHPxcJAYPdj/pMSdy7VsyEOtR1rUo1xNU8XIeTRCjPc6c5huYplfDxnsylFs/9Xa
	02P87O6ha3hxHCZv7biXg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790905623; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm3:rsa-sha256:Ah4w0yRwyq/RFQ/11clE/lMDKQGzd/iolUhsZNfe7k1GaiS
	Uy8+hZ4jwwh0yfWXfkpyIgkqhuoeR0rcx1Kv/y/294J5+ZZNo4yIa8DFh0bnvn+O
	l/yWLT2bJGwTjLQHiTIK24mnrTCjZLIFf3lpDZeTQ5ifz7y2nyBHrV6e0DOPqCgp
	sufcXoost31Qb8KY+beovP28WxmD6EM+rtujzeC2e9whbRQqJyTsUwrVxt/Yozyy
	aGigOlJFkmmIHZLoxclVQNicyWTfCQWxvniR2FZRTma2MOAxBZJ/TYodfiP7Ccvl
	TvbmTsBqRTM5Zv0QUtD44N0X1HHu8n6lktupbBQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:jZvbvLKW1u/hs733udIzBIikxyBWmLeqeHLMJbRKgoA=:CKI77JhgN4DNbeVFs9I5IJHGYZIfdR4R7EszDtpuNUc=;
X-ME-Sender: <xms:Fw2_atsvgSe35MoembzC5ver-vKex6S9_j-hzCfDOLYiFvGlsEUv7A>
    <xme:Fw2_aiVx58b0lvVZQK0_X9ZIlv4gT39mhYbWftkpmeSk7bMmKcLicCkilk1w7f26y
    m7nEXWCjyXSx-vjpdU33wAsp0oR9q1TOs7qlZEHS6qcDXM0QZ7qfLKcgg>
X-ME-Received: <xmr:Fw2_asRRYg3vr0EBx9yIDnVom0xl0ZgwRUC5OqkPwCfURuJ5ZqsWdQF6fG4ch_WUDJDds8kS4woIHUX_Pl2s_wCIl-NHDIwx>
X-ME-Proxy-Cause: dmFkZTFCSwxkMYstzt1jw2909bjG5+qkTSjt6kEah2kA3X+lvGNlcaN7EPtXCx2J7RA7ta
    cDHrC7XkY0FtHYk1jP+ajL6USVgarglsx7O/VEavjowZkNEpJH25jWm5n7xWgolUk4EsfN
    iYV5XWQyZwN6InPRmeBWAKD+OSs7MeyVwmlXj1TTcSKcqC32yI4Ps/BPSJTLuUzOVGG36a
    gfLHCKZJNmzTs4ylBb6/u7SCfEOf/jhHHenTHgrFSaxEQbrLo1BQhAahErsisUMxKhoHOy
    nTKh+OVpUzl5106dWaESwj2+V5lvEaAsvGD5TRq/b+3gRAAeAArVLOT9+mNBF1DI7Tf+O1
    iXrdMWm4F+ElPL1R/MCC02TEAlhcZuo0r16jJwYQSoMaZLKqgR9M2no5GouljnGQ1lqN8s
    7X6O/RYrXNMdLMMIo6Ce1iUvmvs1/od1uFLEyzhA0ngQfgmtnvn9Q5ck3nOPGeSZ06ehry
    AiXPAlyu8LPHkizTmLxr7hygUMpdBW1heyxnY6qfEsdsw+7ct6oJFpc5NffrhtIs5XWRSa
    cQZNp78ZR+xZFEVKZ4lIRWitpXPLk4swCjgbw61Sh/Gpyr9bxcc9asAjcYttIAT6D4riEk
    ULbKdrzfTzJ7u+IwJJ64egXml9wN1uE/KOwH+lgiFtRvs7tDpUe30pltKusg
X-ME-Proxy: <xmx:Fw2_aoLSdbQAVvtOLk7s84W7H0xBgtJFuagtlTt6407HAOKh3szsyw>
    <xmx:Fw2_al0mj_j0gQxDGfeVDxyGhQCqZVDQGaAUUT4kAKZSEo3p_sApQA>
    <xmx:Fw2_ajJ6gjV88eFWj6JwFjF_62PhGO5fRuy4L7xfprbh0JLAUJ6Mnw>
    <xmx:Fw2_atkUOQ4Zbon5xj9pNLVzi3DWoYWR9JHmJqsxYwUan5sb3gsR8A>
    <xmx:Fw2_amzsHJILSR1yeVDCKN9vLNgGWkA5PgFZEfeGpc88bJYIhuLfhUy1>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 Oct 2026 21:47:00 -0400 (EDT)
Message-ID: <f00932d3-0b21-4b6d-90a4-24efe21b94d7@pobox.com>
Date: Thu, 1 Oct 2026 18:46:59 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0000/1193] 6.6.158-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260930152434.301151190@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/26 8:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.158 release.
> There are 1193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.158-rc1.gz
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
