Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275612;
	b=yHuRytksLtb3YFnub/nde6TS5ITFUOmf3JmaEND0ln2/R1a+94wu8dYi4IG+bzP1jfui
	 zYIZ3HikApMEr6ErfWLyreVhuCLQwjN06CMp0Y7PcsUzwHRUT1t4BIlaBwK82F5NTqMx3
	 fF2UwcDH+tTc5Y4ULDKPJM5wFVeiWHNPPjVQ03HnRyUUGnuoonYK5QM18NeoeTGRtGGhE
	 Ukvl183qgdMCuueTPyeoLBwR39ahMZZDW7zrpsq3RGHz0EbRdpy7+0Z7tIeuZcO319wU+
	 O217I60JgHAW9fcQsvCSh/hxrnLHbpFGt/5SYKwwTIyUrL46Jn6TxmjqzEfBRt3gGbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275612;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=sY2rKNC3gH39vFFkmqD7ps5PuFPsZuBp09gVSAmZ5LA=;
	b=Sue6d9WSTcCClWYegEhQUDTFAasCErF3cghJvLPksEZDzQ64Sj5uYQFh11uIBcIplIYK
	 K8SK9zEeMnLcS/+u8PAWuKmNbgKwx6pQqTYN5CyvcjS+SI/6wl+A3dHM4N6Vv1O8o/uxf
	 9I1YTFHI14czsVaLaNDaLP6xXGZMgalo/qxrwm66lVTnYMloqVV21xoZI1ChYA7lrmxQa
	 /vbIKoSIm6q0W1g+oP6vwJMYHkuaS2zc2aGxDiZmsC6HJvrNiEmHdPXasPrq09r66uu58
	 ++89UoG1CXSgXnSp0+jejIubii9GkGjGl5V2/6bPcFWDgUJMGYGhnZSf27U0Zq0NSYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=mBBGN048;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=ePXK4UwR;
	arc=none smtp.remote-ip=202.12.124.147
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CD6606A31C
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 12:06:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23CD6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=mBBGN048;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=ePXK4UwR
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 90CC11D0004D
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 08:06:50 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-03.internal (MEProxy); Thu, 29 Oct 2026 08:06:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1793275610;
	 x=1793362010; bh=sY2rKNC3gH39vFFkmqD7ps5PuFPsZuBp09gVSAmZ5LA=; b=
	mBBGN048CEm4kKkPOKWc9uWV3RJx7oy290EGxz/+mBRgzgAAg8milrXXcxAES5Tk
	JdL2pZ5ZNh5wFU+k6JKTMGsCIxlIcSUGQuXLa009uIXg4eaApd+mPrQWW/+vdxtW
	a6g2y8hoMUrrdOdEst4i1uKFXs/zDXBurETt1uHsnklYGDsgVQvevsFp2dZz9P9f
	16UcCOynZ7xmYminpyl4OnC+0KjmkTINV9hMDWpjhVHluOP4IxPj8JC5toJDonqK
	xQgFko79RtoAQzg2kFVT2IR01wz4lxLAm+gpNU+/g0Cv2JYL0gdQb4k4qRiDat3N
	psAa2GDIAFFhtNGyp/YrEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793275610; x=
	1793362010; bh=sY2rKNC3gH39vFFkmqD7ps5PuFPsZuBp09gVSAmZ5LA=; b=e
	PXK4UwRnjaahYcR2bKuL6/mLkDuZ3gkfLOOVGJHuukXShZWvH7cHxvHb4mDxiIoK
	bcjEh0erTkWaHj4B/hYjVhGClLHCqPhSj8ux15LQO0B58IRulsopqWBOgfB+oEUJ
	pEES7Tc1Vub8MxlleIUjnZD5YMeVsQv5xLg4UE+CV1NXiNZHrxR+4v5yg15Bwgih
	HESDWtDPfTTJvuhYSKLOAsTAumaOY2gzAy3b7kanbYWiHyxY+ijgYRqKHYMSQ4Od
	FZL4BA14X23H8Z2cxpc4hkjHCs7W3Y1m+TH4JERosfvzruiu8Fn9a0vGqws1qMeh
	Skf2YCyY8tRamKTl+Aa9w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793275610; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:YhjjjDKRZUi9yh/tQSadxWQTsMi+1n6RCzP9+7r7WF2bYum
	HCz7p+ZuZ5KFpvhaX/pfYtL5H7iXWaQxWptp7JWqgw4fn4yhO4/a+VQ4VQ2g9ZDo
	x6CYoTCq6suzy4Kils0ZjC1zqKBpCgzVogr9uQTdEPpnXgm1DL4Yho001ZyHAKT7
	ggrP/1bwRP9fusxRBD9fIkqlC/2ROg+iFqbJV1yYix1SI7mABQFoktsndffWAbld
	WbeXHT71nsK2M14y13eIEsWpsX0keCDmamaUAANLy7lVNKUfYq67MI5H6hnPrqYj
	O/LwjVpllXxp9KE4oHxmjDjngXPX9DlVS5I6uKw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256://GmuBmvKjboUE0R/U2mS4D4ztAI8uirXbNP+L+emcU=:0HaAqPCLjyrrOC4M2jSefnSyS506P2YldFZ6Gbybyas=;
X-ME-Sender: <xms:2TbjasHWStaJLPnYZ9i7Wi8apDrmCQ0mgpNw0_CRWgK38JacQ0ZeJQ>
    <xme:2TbjahMlvq76juSpDW-PLO_7gyhMQd5iwQ0LTwxLm5ETxpQ8lXmauwY2q9lyj_Zev
    TPH-GCOauWHIHRDbQCt8mheakgJ0Ih63GQv8_IxSejbqe0DCbaHsBH2>
X-ME-Received: <xmr:2TbjahrC3Ox7ki3A8JIXDlyCbPoEA0Tt5sLGe59VaDUcMPeJspbKC7nhEpEg35gGjdje-UigV6XnyklB8-g2tazRKaOObgmh>
X-ME-Proxy-Cause: dmFkZTEDXSF0cF7S4EYBHyYh2KvyaAszHep3m6mSejvPgHchIjp4HZgSk05tT7CtqkhPDw
    HIBpa5afmHcrhyFH1HOTUw1iKPSpGKTg8qw1BDeMwA9N1eyCa2nbm04GqdkfWe1FftVgZX
    oaAKPfEumuWwN4IVPBurSzO7g0lzyCKO+bBJ8Mn/rPQjDsVN4WysWBFsKw1zztvcdCjkur
    j+yzOalcQlbffdq27o9ku2FljVmV3+2PBmKKES2ekL+fnxHE84TNpKU/DbJFg7CbQgbgLB
    3Bv6viYatuKXvcTaBVR/Snh8KmEWIq0DmJSHjxFPOE7AHJkhGiX49ROpU/oUAZHFdCLpVP
    XFZJTLm/9HU2D2Is0PrABZRezAVsOICspVlUO7YgjDcNjpQP+JN/XnNmJalCfP1dqPOOdm
    ua6dhaSWWmyRXzWAfHJdDMUQjh1CpCpcD/uGH7t+BwV5U94jhNSheIfhQnyskRvXcM8ikI
    gro1yN5q7KByIOY/FfOrMfAgouEC7kOeXMxtjpvlWLa+pQ5EtrTHttLVfRnf1G2AoeUTxV
    yJHM6nDb1OPgIoBJqHOHpvn4BA9fGDjrLVwPmD5mjUyQKCUecN0DnQ5/Ly1Ls4jeILLfXW
    t7kgJM4EKkAOTmA/75EMbPzxqikhnrYNx9FZ6okLFz2ftHxArJi4sq4VHe5w
X-ME-Proxy: <xmx:2TbjaiDrzP_GzC2Swg_2STaEuCJJ2lb7wxgxNIaSfTpFvwJJzfkCbg>
    <xmx:2TbjaqOVagIrCMs2Bh-pH4cq9cisZwz539R1Gq2bbFbM1OII2eYJxQ>
    <xmx:2TbjagC_cdZtlDVUKIJO-Ym_boL6ifFoJrCVN1s9Db6c4ZQjXYEQqQ>
    <xmx:2Tbjao900p1Q8jNWUn2DK_DWo49SfJlMMTe080pOw8mFCMIoEYHuXg>
    <xmx:2jbjasYVUR9uOM6RAHWIp3h35nmEbQ15usZARHP6ONZs9gcB-gCAUa4e>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Oct 2026 08:06:47 -0400 (EDT)
Message-ID: <936f4701-df39-40c6-a6d7-55c1857031c4@pobox.com>
Date: Thu, 29 Oct 2026 05:06:45 -0700
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
Subject: Re: [PATCH 7.3 00/38] 7.3.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261028165940.394092994@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 9:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.1 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
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
