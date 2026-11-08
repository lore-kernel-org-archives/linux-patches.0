Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.150
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794179668;
	b=W8WUQZI9edyhK7fzOFpheWi4V5THR82VhzeJbvC71zm2pQVY3Uw29XQz0UPccg+Dxolz
	 SXdWp1RaPHOpDXFWlCwSOhU4GkTou0cvGRPzfgyD/0eIa3WnYk8qsy+GMEqs4oeIoUOLh
	 O5DwsNO4lUwYg9yNtIcUlFzlWHG0ExoNnWkKXQ+pXPImA2ETqoSPD4pnlYzmAXuFmjixE
	 OlSs3tDVzFmmyfAeQYbgtnqzra32Zd45m3WlPWsQgYDtTpD/XNKWYjCKRvdXPAWin9L9k
	 UmRddXIBam9pYfdKGV3V5tB7m1hy4C6kDqgL+lMwY4svPWSJ3rLDb0SQwVEjoLhpEIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794179668;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=aNB/opGGS4qMBZv8n499yIWWeHjKzqKUsbpAFqdeC60=;
	b=PMyu5wLDQtRDLYOnM6ZPoAFtUqABZdGIp1bcNHHmoL3rPPBeSFQab3WMohMaEEkoSD/G
	 2Qk8Ad1tSXBdY3qJUsKacVwbO8NnnSJ930xGXT0GnuSRo+qDHmRT+kPacnhCVtvS46EIb
	 7xs8M4aBJg7qwFb+16b7dTDvpclwK7aRL1gC2B8fDM06Vi6jppTYLXRP8R/6+UVKV0IwX
	 spL5yHbrBApDsl9oWLWITlBn6kJCUPspCy9ljD4Vif0unQ3SUOwpQ96DRMjwqH/07ZUqX
	 74jearP5sG9SltiQxpClWDF6iPqW7tvUtVbVfK+ybagpeJE+dSBj5jIBFLZ93YosqcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b="KwuWbxw/";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=X2P1bdvb;
	arc=none smtp.remote-ip=202.12.124.150
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAE1606A31C
	for <patches@lists.linux.dev>; Sun,  8 Nov 2026 23:14:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAAE1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=KwuWbxw/;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=X2P1bdvb
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 42A2F1D000D6
	for <patches@lists.linux.dev>; Sun,  8 Nov 2026 18:14:27 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-01.internal (MEProxy); Sun, 08 Nov 2026 18:14:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794179666;
	 x=1794266066; bh=aNB/opGGS4qMBZv8n499yIWWeHjKzqKUsbpAFqdeC60=; b=
	KwuWbxw/zo5TLrD2TcYvheNN/qkTpIVJx+2rHWLGVioQsfRkj685yibqOrrvSz0m
	40v9gg+I055zObbUdZTVm+XGeqqvDi6VxzpEPn5wNt17cxvL+tZLCWVomN2YuVYw
	9rGghAxaN0H82ZOmlyWdmma5ulGYhsKzG9wlZO7gPUQkulL3No5h1ar0f6QrQ0Z3
	kavXLZ+CILHL4N9cAEEhKlresJsgiY9VIOCt8UfqJ/hP1yXySr14AGZclPwhQJq1
	PZKsfUag+SHY37cJ1b9FWyt38Bwf8UNnY6MTW7AhWLVc7gUSLDZ15zvyDV27S0Cd
	tmFrX8i5EliZia0g0bzHiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794179666; x=
	1794266066; bh=aNB/opGGS4qMBZv8n499yIWWeHjKzqKUsbpAFqdeC60=; b=X
	2P1bdvbQyaENQwR4FX2wXrWhFGKkE785tadR6ZvnFQ6mNGlS2obqXaoU1J8+HR18
	K9t/5GWY5xM7QRabjotWO3EK5r1O2dDVXAG4kwZJslBKRCu5SJCPDxI7ySvlTn9N
	f4EfR/rCZM8iriHUBmX+NllE+7bdYHq9pNfrMyFOqCIt16dZlupEhYfF7afJ1Ede
	X+afkJpHFxQOOH2rQUZforbo5COOBvVqtWo03XvL+arNitQX3MRrgHnlZW4j/aXw
	WAIawD5IidM5qpQSJxT2vMJheQNMovOS/1xkmmtPlW5Bf8sW4pJHmo9BOJT0jNTO
	PZGBMPNKRkgz5yE9dccog==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794179666; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:b/SLr7Ssajo3EGopmNBYW2KHuPoEmc0Gp/RsXchn9nC6Jys
	sdorbIyJ6h7Kb9auqEC16Odg9CKssI3Dea57VCOXqx2HBHMyGfhTq0KGrI0esGHF
	DAyLyXLeN7rKqFDXpgd6ijoXPHwx15nlEyGSgC7F6UTKS1HfpVZAjTTjX5ZQjpX6
	65xtbvumu6CZ37Y0GtG/BwNzaavkhrhBlsPrUWVsTuEK+SmAMQD9rN+o2yvl2p4c
	4TwWDmwbqlyfJ0F8B+o0SysHQ35qCzBelcjhb99EcPy5BOW9/uxzgAFPRbPyLmXr
	YflLrkzhJAyvnr448TzrAWS0Cg7EyVGlMaISQCQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:wy5u7/1MaRfs0p+iCHyBGgZdTfbVRHkS3B4qkZoX5fs=:22a1v4R3sAKcl4JqYTnxduwYEnj56hUDUbWWFqEiG6s=;
X-ME-Sender: <xms:UQLxav3t0VLfuUkX_KpEq_uLQQq1ul4Cbz6InmOBeXBqXTQ-Py5MYA>
    <xme:UQLxaudWfnQ98waFXqnuZkV-XVCB045yUlQ-y3qKH06NEs5vuLkruqCh5px_jhZtp
    znt5AuRz6lJq04UFDbGiInSteypauxwEIne4al-b0L-N1CM02irt2Q>
X-ME-Received: <xmr:UQLxahCYjAnaYot7SSkLPTeeGfZxFtsdiziAwL6M2ELzmauHEDX0Rh3200ebwJ5CZVH4U2QKdIlRF3U9swFPNUjvV91gkOi_>
X-ME-Proxy-Cause: dmFkZTEobYK1tOekNqVcRoyz46yFPQttzPtHZOkE5HGQvatBgJILl7eANID4IzPTfJdUdp
    7lRTRVKafPfvdv2C2D5iL3BBGJcBS2ZS9uCCBIgy9W7bM3v+yU4vqBYLYdJFvxwCDN+hU2
    UhPeo40p9ycN04kyVW5Cpyt3vxYIyhVYaqhlMIh3b4ygMgrQ8LV9IehnFj1IEOROX9FO2b
    OID9LPD1Gejnf5U+TwOyql+xAwBj2z4gyJhN4Ua1RlkckZ1sIPOTFSuBufrXInWv2BFzTg
    5b+cf2SuERpEOoJAQ/4hTyus7FQtCAFqs1iffrupU5mMDAZ+mv1RF8IEh6TcNQWgSzMDp2
    t9PotslwPd6QXg/A09izOaJWVmRn8jN+bUcpb2RTgtynov5bm8yDf9kodr2bpaGmsciVtx
    clmCao4BHHzufX1ag0DS761SCVkXKWgy7Nm2+POjvCe4wFrJHbo20i5ysaxnj8lCRGuKbi
    VC0przaQ6NSu1O3a/RXvmMgjkAH9AsiT+0PPn/9Vtx0opGG8QekkJIytxz3QwJi09cdZO3
    gOoPcUF0HC2dCPPaVIU01M7t5nGdqnGwgwFAJwhZU5B49bk5OL4S+Et0ffH17aOiS69/9/
    QG9eGYQflUXIgURzyJQdjKvT9hXtspQ25iz+LqpvcJsMBWDI0t3ubyytNLIg
X-ME-Proxy: <xmx:UQLxag3QDA6k2_AhbXaFVBocCMQjZ8TLwXluL4IoWAhm7OZdRQ-CPA>
    <xmx:UQLxahNIiytpZaIIoR_mxe_D_17AZzx1QCgxOZ-czerH0js2AMnV7Q>
    <xmx:UQLxaudpTkMc6ZUc72KgfUBlsTOUe5WSkZ5V1dc7-vwIqu7X5Ay29w>
    <xmx:UQLxatM-olQK6wwhliSmIFTe83H65vJBMhhBQQOZ_5djk0pnQeSQog>
    <xmx:UgLxav-7w-Iu-d_gyjeD1lCT_SD5iLDvqMtwo8yztICtDV13zMwVtqKu>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 8 Nov 2026 18:14:23 -0500 (EST)
Message-ID: <e9380707-ba1a-4728-8abb-7b1e0335f3db@pobox.com>
Date: Sun, 8 Nov 2026 15:14:22 -0800
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
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261107134939.434104957@linuxfoundation.org>
 <f65916c7-470b-4f64-84d1-da8cf4c8e7e8@pobox.com>
 <f6e0e225-a80e-49ee-9555-be300f169503@pobox.com>
 <20261108-rc-reply-02-xfs-sched-ext-7.3.4-rc1@kernel.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261108-rc-reply-02-xfs-sched-ext-7.3.4-rc1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/26 8:44 AM, Sasha Levin wrote:
>>> 7.3.4-rc1, 6.18.63-rc1, and 6.12.117-rc1 are all giving me the same build
>>> error with clang that I previously had with 7.3.2-rc1 and 6.18.61-rc1,
>>> due to the same xfs patch as before ("xfs: cross-reference the primary
>>> superblock"):
> 
>> I took 7.3.4-rc1, reverted "sched_ext: Fix the stall watchdog testing
>> and blaming the wrong sched under bypass", and added the fix to
>> initialize error to 0 in xchk_superblock() in fs/xfs/scrub/agheader.c
>> (quoted above).
> 
> Thanks for testing. Both problems are now dropped: the sched_ext patch from
> 7.3, and "xfs: cross-reference the primary superblock" from 7.3, 6.18 and 6.12
> (it had come back after the earlier drop).

I took 7.3.3 and applied stable-queue as of commit
39e32a361d2fca269cec12e8669e2bd3b84844d9 ("drop 24 patches based on RC
review feedback"), and retested on 2 of my amd64 systems and my arm64
virtual machine.

It's now building successfully and working well, with no regressions
observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
