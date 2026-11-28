Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.156
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795858535;
	b=eDwiRUB/2QEHTAjvxed4Dq+M8C9dub5qTWfzoGpoveGwVG/FXSYzOx+TgxXzPQ69vzp8
	 C63K6UCjj3JhXqb7Cjv8IIIh54QRjXtZOKRTmJvpJzOnJSxQ6FtCodtVktNBQanz/g0UP
	 v5NOORDdArsHNWcn8md1tqao7RA+oCQNjjXzjEdZTDPCPCA12Ga6Z+51ydwlw09dJxq/P
	 8v7AN/gzX3Z5bqHFQIwXCA9NtOVmIPddVFyxFjH4/FqiMLDE98WqVJ2asTa1OS1J4Mhsb
	 2URVswiRjB7ohDu7yZI48+Gf/5bgpapG3riKm3GtftPLsGvSj9vsVybiLwu5yKagXHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795858535;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=zicrRBvId4YvApKpJm48X0ZTwOkVDAdh8E0wrt9dEMg=;
	b=YEwELjPtlEUbd7VVFMdsMWD4t5Bi0pkG3LocpTsLoDL9Fu/qu2KB015+b+wd8Z+YiXpQ
	 NxW0J1tI7uh0Le4G+9dezsaTz9Uq0vakHMrZsYnXpinQGy9UAN1u4AvMMZaignLGPOcjj
	 0AQL+1CAyvFWK066v6Ym32DC9LfbDcBQ2QUsiWsfJNCAnG+Piipu4oXCWX5IPf7lQiE85
	 evIVlgKx0FtbicuYqpb3jZyPVK9VGnnRDE02HgvvOWFCRZoujhs05sDF6eyJe8Rv7j9XP
	 BdtEHAyyJVFS2zL3gL93bszv0A5mzAODW9VCbzLPUtIkCePQt4+oYp1GKY8tStPPZtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=RmL6cBI2;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=tx31jsWF;
	arc=none smtp.remote-ip=202.12.124.156
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91145606A31C
	for <patches@lists.linux.dev>; Sat, 28 Nov 2026 09:35:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91145606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=RmL6cBI2;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=tx31jsWF
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D2AEA7A0559
	for <patches@lists.linux.dev>; Sat, 28 Nov 2026 04:35:33 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-06.internal (MEProxy); Sat, 28 Nov 2026 04:35:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795858533;
	 x=1795944933; bh=zicrRBvId4YvApKpJm48X0ZTwOkVDAdh8E0wrt9dEMg=; b=
	RmL6cBI2He6Co4g89wDHUOeavPsLzAgAFAvFSnh7pdsbPkLCcrpAihTkuTDCK+n3
	un9fm5VNsGnCyH6MsS76w5KzdhXuXM1kAF1kcdLhGYBJkHXCoyPQShsTVE7WEALO
	sCShVZv0Ee5i+XTL0hkBap256Q/YikyluFxMj88t6ECyXCQZUwEm9AfEc0C9BvEu
	Gq61osyj0DJK+iA4n9FOVHwVeFRnhzGwGhGvuxtVmiUrfs16hTkZ+Ad5hHYgvKFj
	IYYOE3ZBXGGTKPgWcR1k9XzbNncbgTHHKY9tre6l22wD50Z1dd4EHbO5SQsnFObJ
	FwXb2VCTgky1thCoeVpN+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795858533; x=
	1795944933; bh=zicrRBvId4YvApKpJm48X0ZTwOkVDAdh8E0wrt9dEMg=; b=t
	x31jsWFMsoUo5dwgDYNCw0zekt3Qem1ueANY36yvulvO3dHHVMfPHqnhdby6F7gD
	8bJ14kf2GqdLfpicgm5fhCYoJDiVsTekqYEIUp5AFZ9cxOBFhP+L7MKSDFvX+7jv
	mju2fLdm3J+TrCBls98fz3psuXSfM7OKFptzWDVg5eUp9QWcnwd99sG2TSEEtwbD
	rIZTj8kKm2tmBsZ6ygU8VHZsJps1ha5vlvsCogiYfL2gt1RyNXZQSY+Ifmw8uaxo
	/9nEYodeyOD2ESxwxeqs0+klQkWLi6P+sAnO1PA5ncSrLuB/BiVZcNvymXB+Osu3
	d1Eq4zsE2Aig6CPd1io7g==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795858533; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:Srd1pDb0ALEKQvzAnFPO7lqIGFPdQ7+xucslGGzrzrD9uxi
	njkNP+CEr3SJ7eEbOqNRD4x6q+zbJz8wKP7knbUCcgxFttDjL0G+HUt/JyVKdt3x
	CD27sKfalOWvrNe5KLG1btDsTwUe+/W+BjWbAenH3s7EkqPyiPowNMxCtwCj5lZ2
	dum1av+B1E0hR/1fjvApNSauUI6wkDtztY40kWet8iPxmmstL9NQl8+/2QX+cyB2
	Ovi9OI7+GhKLBaABwzEsJwp6pFOMRjDTCOUzadk5PuN+CHyUQwc95c2utOF2VfJ+
	09BVtGYuglHObhu8axKxdDKvPcd6i1Ao5dsGkuQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:014xzjofYLyKTC2FEPI6l3AJteYL+UWlSylf2/3rwnU=:+TuYX39J9MK5GgWXhfX/MUZpw+eI50zC8N8dm6MRU0w=;
X-ME-Sender: <xms:ZKAKawiU7OLMAGLs0nyYtpHMFDbYXnwkF80_85K_7S9BlVSWIhWgRw>
    <xme:ZKAKa06GHW-LUIvF5AmE73L5KbB6FBEad7Ga33rWgVXbt-JRHUVrL4RKeM_5HNUnf
    bJm4mqg4ivOL4pWNHyj1VfIA2QGNdbF2iamPKfXH0qhiwvPo4o_QBTs>
X-ME-Received: <xmr:ZKAKazkqOFOPeNu63yp0SpkR64bsUrl7bxWY7zmS8eABuMF01GGiIaPGgi5XE5uS-UOnYKRAZiyDxilit9bo1pXZdMIkL-zX>
X-ME-Proxy-Cause: dmFkZTGMV3CUim2foI4ZzGFCcoTLNyXZ5phHEtfa29Af+kPYAcEX6mgKV460NgQY1JflaC
    AdpzyxlAuM5K3J55EGFMpNp6mHJ5kC6agKoTrbpgF/pjYbyTL9qOILlmwDpNPS4PD7Fpcs
    mA6CY3h5GhMbYdN3rt9hRLhyOc8PDEoff6FDl2EUZo1aTv72qNhd7rZtQ4Catg08VxkU8L
    +bvS+W5mWk1nyTDoW82JYyLmjmBX48vAWUhYmN8tLWr0KkRCG945CQXre26LhAMybC1bPJ
    LYexQqWt5MBIr5lu90NdCW2Y+JOJuHKN1DKgP1MXy76ZutknLgeqkHHo1TrqDwEUyA6aZl
    wfT132sjzOHmDrEaj318nLw5TKhCQykQUZaYXKbrFDH6ok0nQGH5igHCZjLEvXPqNOf9ti
    eUtgrI/+4r/m/RGZq/iIo/CCTNPLAIyJoptC0/yEh8gmFhF/jL0n+HvK2vRRzsLdZ0P4I2
    OadUnGxDTuWTFXMfMgzgubP8tPrXHbuYYZX8pJ6ToZbuHV3wXeeTCNlr1M4tgBLVVjUF5B
    YuB2fLEj0pjfrQJINkF7MmIAfqmOAwBW7fhXW3cAe3Cf2J8kL5JtHpNJfdcW1pQQsJLdon
    6E9P2sWwn9ZOl3CFkqQr6pDBV6XdIOgd8L3Du+Sm9UgiQ7RIJB3xK4ZS947w
X-ME-Proxy: <xmx:ZKAKa1Ma2JKdUMLE4lVrPKonrMIpuqugEmKjxX0_XGFE0qC6LDgfoA>
    <xmx:ZKAKa1qAmWc1BlYHiylL0cBc6nq31z-BxTZdiBosUAdwmlI5nBkn8g>
    <xmx:ZKAKa-sYACVBfoEPYTZw1-_sN9nsFEAKJWOrvAWgXONmt3pUUVCu5w>
    <xmx:ZKAKa57f26Pcu9cUYWVdw9MAKFr41nuPk-FVODp58Qc7vspI6NlUSg>
    <xmx:ZaAKa_1UyzaRavElIPs_71OTGqCi4aIDQibHm9EGw_zRas8urBR4Xq-h>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 28 Nov 2026 04:35:30 -0500 (EST)
Message-ID: <aa7d8770-787e-44c7-a3fc-20ebc3db8af2@pobox.com>
Date: Sat, 28 Nov 2026 01:35:28 -0800
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
Subject: Re: [PATCH 5.15 000/318] 5.15.227-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261127052515.841545444@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261127052515.841545444@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/26 9:25 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.227 release.
> There are 318 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 Nov 2026 05:24:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.227-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). (Also briefly
boot-tested on an Apple MacBook Air 2017.)  Working well, no regressions
observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
