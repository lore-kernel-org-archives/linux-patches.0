Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.158
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795230684;
	b=yK+L6MD2EhP8+JrEAZbFIh05mt0c4EvDnDvKzl8f5wI8N0DBSLvm8y+eK34KKaPtBG7C
	 YqDkqFQfE7D9JXRPXJH6sqlJqjFrZ1cSMvDMKBq+LsCGAzbC3cSxsJ0MgFcfZsoi0NU/L
	 9LLGuQdfWXlc+ZB4+55rV2w1IZorSMtMOVGnXFQQ12RpkJTqWn+NGKLxDLM58GsGiPMe9
	 nxpFJPpT1q9lttY1xnuBR5dWSL+pBNDf4mjgP1ij9LcYsc4lDF4VASa64UfvjOXYvZA4V
	 WwY+O8wt3aVW02B+GGxVIOkFmV2ehBrASJ9GJLnYQyvPKcHxTHoxt2MUM0NY3QI+7nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795230684;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=R8xhVddauQYCNhO1z3ZGmw22iFacrhkUe2K9cVCZ8Xc=;
	b=izSZtNt4m1DwYOlg75yd0QHRqClCfNAnKrOnJ4BwbPHB8tSDG+2t0mRahxwJA7ftkpUT
	 322NAR33LxGECVuArFAEMhhuSBuN9LJQErWmYAANj2UeQ1cCxAYwSgmR780CX6EUvpNbZ
	 eKynBssfsumPSq2c1PuG3MtVWdpofojzhJQly96I8MLS8XqWsvVoEDIF2GVNCw/QM/mdE
	 UbKFgCT3Slhf/SB2cMx6OhbqgzM1I/Er4fIsCQhx3iBX67+NMOlmDua4Fd2RJ0pWgKLBP
	 Moxi2DnlMTtGIC2em6AvPZ3Yyl86U/Rt1Xo8p7h64f8NeD7+55mknotyO/b+iYea/wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=iW8IY+Dr;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=urHHX4ed;
	arc=none smtp.remote-ip=202.12.124.158
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FDA606A33C
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 03:11:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2FDA606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=iW8IY+Dr;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=urHHX4ed
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 708EE7A042B
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 22:11:20 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-05.internal (MEProxy); Fri, 20 Nov 2026 22:11:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795230680;
	 x=1795317080; bh=R8xhVddauQYCNhO1z3ZGmw22iFacrhkUe2K9cVCZ8Xc=; b=
	iW8IY+Dr7HZjD7BysCBRzxseyllsHHI3VtylsFq8BjBfGuG/xgCYp7vnc/MEiHi8
	ORLDWydjogAclx2ZB77K6cP4dScpIHCrPvT3YWcOhbkrqTmf+KIEK+3HpsvFiURy
	PybByQ5zjDX2ZQ6myVmuw3jfrxNyFWhQq7fI87TAI6TC+6i7QgGm7kpfvdbYD+Vu
	0FI+C7R6jBHjRZefP5t1G/yZH/C0iv/1b5UbO18S6pbs9spTo08r+Q6JB0oD9hu6
	jUignUJhjMp6DPQEe1TeZyTOzcFbLe0BIO4T5dYxzbg8G01/0niMZBXYpkLVsNC+
	8TTIPeHnZv7dVViCiGmE4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795230680; x=
	1795317080; bh=R8xhVddauQYCNhO1z3ZGmw22iFacrhkUe2K9cVCZ8Xc=; b=u
	rHHX4ed5gaFqZHjb4zPYrTY/tjYHlL7+KqAKOzMwpsEYrSmUl+5YJ7BOxE9Pwbns
	pEUZY3uK9Cvq7GLkpV7LFlGBUe+FMyO+zk/oOsQifv2NkbB2URLRCEynQYRqnM9d
	0urLgw96nkLxas3r45aYtZGY7MmhbmhD7WDupxu2K1YAeeimxQX1xg36/kxaK+pf
	mPVQElndnJpfcK92+ewJtBfFd4h37/dVE/YcohFXY6M+/BL/FRx5gfJ7yzNS1xqy
	iIDo5BbczAGYm7kQ7mrq3nMZcPUNkFP+r6q16S9Vk5au5bVJ79h96IuWmbYhzFTe
	5Tj1susAmJ8t4cW2pcsXw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795230680; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:J98WKkkOz4x7Wgv3bgA0qw8x3vcJWcERcI/H1Xl7x8ioSNC
	Vw277/jv0FJZzDtyxfcoRfdOiWuS6ZKWo8EYd2rOKvVV6z+uHYI2dsPw1+pD8eYc
	kaB4tqPgOVVmIQqvrlIAaG5smnDmigKgkSxSKhzh2KdWFOTq8+Ex1YQZgIknid7q
	OdZgHMMrJ+0ZnoKkCz2TRDBuoCJ3US8JH2rq9KrZwYdC/l8cZ3sESUOzyZk7bzog
	gk7pP5lmSzxVcWkNMPSqenIy9tGSfXZHNMOxpFWgyYD1+HgZ15mA+DViJnUazvC2
	7roLjsnFblwIkjWRWI03P7U5mIYJ5UC9OL6t7dg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:Jwq6Ga0aWchymV9EQFFGRjdrMrtwwjxRHJuVwYW9e38=:UwHhF0XR/gykUXEqs5hr6zVsM95RsZ54NeguETZHNhs=;
X-ME-Sender: <xms:1wsBay0O1pZDI31hg8y7n85t5RRj2qeIhW2zDPCKFDcufHB-e3l1hQ>
    <xme:1wsBaw_GX31tnO9I1bh_37RtRLqm3jrbF6AnMu98AzeM3XmwkV0V9HGSM0oKBGIU6
    bvb8QpYHtBYA62LeWKhQuuqc9FIrtB-sUYb8nhncjdhD3EmruEKC8ZT>
X-ME-Received: <xmr:1wsBa2a1oA7fK4Wg_uR0KfHySNNIK85R6J_PrsxQU18O172aNHotjJ-LIgFn2XMWCeASOU8ZzOgEPlV3g8_Vfwc9O5pnbOLS>
X-ME-Proxy-Cause: dmFkZTGf4PqXj0leBYzwi7h6paOeUgcxnGsUESJqkMcnzwRNO40gtGVOPqm1qJZXpVRrOq
    wZY18N3/OXRFehtjymQ9Uhef22D9t2uu+yfrErjnJzcKzQLyLYwmgGEDVLJ8skRlnjdMHe
    P2vraea/4yKISih/uwD3VLZtuK3Pw9t+nCXAZfCu2GkKZf656il5D+mGelW/3vd1b2lxnt
    q+c0MSPYli5UDqwt+NuP6MEDASEw+hTfbpCt4he19kz+EQpl3UnWChyI7O7OHFcb2jTN14
    hoLAMtSa5CYnZLwdzc8qPleMXWiOZqBYjtLsJcDUnf0+jae23BydsaHpuUy8j0uH84xCQS
    fpQMZ1ZIE1mCpw6oRzT1CiCaCAY+ZyRFg9Geg3hHCvPtG1Vnu32k3boH8EJRPyjDGeBT5m
    olVVdzNAoPXUE+kmWusLvERTyrkSvVYl2C8JwmVN9DViBhfDoU4jBcarOUImgmsrk0Zfmk
    6QLiOM+A3rc9BMulJjdFxRYRikxtY7bVX8Gorpna2OxPpxs9VGunhChqxJmE36ngA3PzxO
    VpgVBCIcEndE7lrIVR3b+3jAxz6VNYxxba6I+94YUfz44wz2gLdVjbv1x0OcWRvK43U4xE
    hhNv86p1Yyz4KsR4rcwwGlGWCuxBNrAL4cLKmdEoDIfUno3ccjurbQs6dmfg
X-ME-Proxy: <xmx:1wsBa3zK4Z51Ak_0jBeqET3w6u3Ig3tWABhxyT3IeimP5_Mq8fNWPA>
    <xmx:1wsBa89Xyi-VuSRRby-UCAGXQwHS_NJyGZXnfPw3vR6UizoeHP2Tpw>
    <xmx:1wsBa7zzOlnWY_CWouWU1zYj0Sl7RpIkw9OzTb3CiAbJzPGGNj2I6Q>
    <xmx:1wsBa5vQLri8G51TJZmEMi7WVkf5kqzvjCmvGAr3-rG0fx-hvlHjuQ>
    <xmx:2AsBa_bAoMdg9ll0ZuylAYhJklX5vxJTJgGwFfhXs9XH_2TSDl-LYqTv>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Nov 2026 22:11:17 -0500 (EST)
Message-ID: <25582513-f75a-4ef2-8659-7b28d444e962@pobox.com>
Date: Fri, 20 Nov 2026 19:11:16 -0800
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
Subject: Re: [PATCH 6.12 0000/1736] 6.12.119-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261120054951.366579794@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261120054951.366579794@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/26 9:57 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.119 release.
> There are 1736 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.119-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
