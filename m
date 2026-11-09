Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.156
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794201645;
	b=Rgg4oZxrkqNSbDmGmNkeQi/lapFQj0w78t5UQtWD+4eZYIChuoPKy/+QoSPbSgw5lEzn
	 32q+spdgzRiRFDA8bd5y3xHCrhDtnTw4Hxqg1tgjU71q8Hcz08RLNhpjQ5ZhbpOXPuOQJ
	 7GZUhNkRlp31WzNH5rNML987+EJbPKD1j8ixyLeTvGCIipbTSqUsuQq/rqBpvd7WH5vD2
	 P6uZgHIWLU/c76OA+CRZuwVAsgYcWwBf+vCUhf7cx4crl621gUlY4yvIP8kKC5x2dKyIA
	 UppvgJpuHwW+E+AR9Oi/mjymMlExJGsNreEnTrvT7kN6g1UdFV38WigQBGYzh7v4sQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794201645;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=+Z5AeTikV6P1Bo6jjMySgK3YnbL1zfbL494WZAKZHgk=;
	b=shS/g/m75jInxcp9gIZketEWWHpG2tgll43G4rv8AtYkz0kZySkoILkQaDU8iKuyHi91
	 WvDPHpglEOcBT2sh+gltf/0riNfIM8x6PSAroGHyH6qV5amqTPfOUibRZMzccn6iGVLBQ
	 XiwZ25rTLgO/wDyRNt4fOSUrSzRwMcAAC/iLaI1nVkuQtABsHq4jKWmlp/DR4TZTpuHSX
	 gMzlwUHKzqmAnTPb7c5kor+wkJAPEogflM2MLSqdl7isV1Y15kC1GeCZ8RH4oToR3jWEL
	 PURmDIkY28/XKK0rISDO8uUQ5bW3w7uFSdTPANKPHM/bnTUdAey4a7g0uemnOVsLY7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=Sg2bp79R;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=zm7foiu6;
	arc=none smtp.remote-ip=202.12.124.156
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42861606A31C
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 05:20:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42861606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=Sg2bp79R;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=zm7foiu6
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 5BD2A7A0129
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 00:20:43 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-04.internal (MEProxy); Mon, 09 Nov 2026 00:20:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794201642;
	 x=1794288042; bh=+Z5AeTikV6P1Bo6jjMySgK3YnbL1zfbL494WZAKZHgk=; b=
	Sg2bp79RV+1Eh+8jeWbm/Yhmt9WY39CLJuafzeqEWPbjvsVswnifL2q63wrGzRqb
	9sD7I+ad3prxc47qReGPWgBaYWqJh3+WBAisBrokGCvdEJgZtcq5BFnySA/JOuPO
	sipAZdbERH9VxG69uuua9cX6MIO+KCeg3XKDZhupbuMFNY5Sb1IrmyLRK/FI4itI
	Cmfs8CMvxrVqwjjJ0Q0TlxkCkmVIyW9AHClKo566UjnfeRlSlZbYFULULkqvpyJK
	VGaOHIH8Iuyb3n2IUcsMko5GumoN4AEhWscRVjDebJRdgZfLH30oa/xzieh2baB7
	YjvsBO/rOe9minAsBqRRPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794201642; x=
	1794288042; bh=+Z5AeTikV6P1Bo6jjMySgK3YnbL1zfbL494WZAKZHgk=; b=z
	m7foiu65rP36ChsVouaCpafIOLWd7siVDRK82dkQ/ou0i1LPcUhrdrNvIp8WbsRK
	+FjUyBIU4O1yOf/Eo+jEnTY4y0wYPV1KAT70LBjlS2r7+iD+6gWgyEFDEoahad26
	s0KDKuIt9+EV6za12u9ttiadQLqPmXO3BazjP/Jrh8vgLEovjAoBJVXsmYd/7fGF
	bmg3EdCjQbFfZMkHO4tr3E9FqSGZe/RsDwyS927kj6NTdQpRWEd69OtJftyIqgxX
	Ff0o15ikExxiRulVvd6dMK1+g+wXOWsfsvIPl8T5NVZo+ypeHWTb1hR8NW/n5j7S
	pC5nnYPvCoyvi8RBB2dkg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794201642; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:Hl6igpB0wyBTboLUkHQcwa5BF5soX025V9cf/z2KWubragC
	SYYRx+xfsWgUZdD2eLhxslPDxv3GHZeKIef4JqHKAeU/JC5Q9aSjuZGT8+bQOpWN
	tuSdygLjzNFIF6/QEiWvK9xELupb7N9kd+OgS/uLElrbziAWt+rmTSw4Pteet0wd
	yUxeIB3yRqdxWsjCxxyj+8ZPxoAV1miGejBUDkdIxWoWecj80332jx60QIvzZ9HB
	IpeZyPwcEzBjAHa8BOG8wD0b0jp7H20cnebWnlgJKSW+8l86EkZjDYDBmq01vSwL
	YX4aEl0YGj9ONZRphwHB7eEhBe+tsgjpl66Rypw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:+QBrP130DD0/PDlu/7OMcxbsU59FzW70U4C27zWAYVY=:z9bSbprL88OoP4ToYH0ngAcLU++q4BxeIBM3FewlMO4=;
X-ME-Sender: <xms:KljxavvEmnqL2jngqPQjNz_sOax0AtNO6nphpgL74etNEOeEon5xAQ>
    <xme:KljxasWvRl4QW7L6BUOr2ZEdrZ1nVYPV5neXSuZXaHpzC-XWk7lZdpLCVWXYOx21s
    tCxlli5UCXgZWyGjwQZ7eje-68BONP6sJ0ZePG_yTNhH9uK5ENDrmM>
X-ME-Received: <xmr:KljxauS7s46QG3vc3U_HvZs7WuxnmfJv1mL7m_aFggAEQztF1zXORLgVbLmeqviNSYzUY2hJluxEZsvTP379BI8xhKRoV210>
X-ME-Proxy-Cause: dmFkZTEXGE0LMi7MmvLBKdPaqPq0Y0Ux/k/cc2UVdeIwHu9uyysaon3Kg83AXfHEzzXYYv
    TpPBlyn7tFwkLosuJTOMUcNjlA5KnOfxi6YYGQ7UhhbSirydp5h6WRA6kHg92KOFgcuvVF
    Dw+pU/ttV8QueykmChQttFD3twSjI5CenJQH4XH4fvG63JcM7DBHVx20bnWYScZUrpr9FE
    XxuZXd03UPvpytADP9s0SiTg6K9i16/ggSLlcxJ2f1QTEHlU0H4U1jSnItqStS7T9f+knP
    7v+d02WGJSGKf75dQQ/OuCkMf6NumNgBK+MJARFNBKAef6OC4jnN3R2Yt7r4+Z+/3B9FUl
    9g11GHCkxm0r5PWc8vVSnmSv3gKfcK0tQdFQoNFeLPm/Y1Ma90T5iQrzWUFnbDLXnmqAPd
    y6dRB95ETQ504N8frS9Gpg9bd9qoQtM/k1hEm1L+6SFjBkJnHqMCafSP368q45ZswBvOXR
    /qZSN296dQBMZvHYWM7yhMMiixYuZmoT9JL+HvrhLOS3FsxV5J8N1aPTcD8r4k3N7B6iG6
    QytMl/gQ2Pw3LQ9bMRzv2I5bT7nMRaSwiH01vK46jnw9E2AeVO5SFIPpQhnrrlkNZdV9kW
    jog35eGtXjzNcZYVZn/Jchi9zdmhROazL9cVbUFZy9FHhuTydxi/FI9hfF7g
X-ME-Proxy: <xmx:KljxaiLC-H7Yfqlk6MgKmjuSd3BuSfvvBNG6nlahjCLL0KgJLSzU2A>
    <xmx:Kljxan3tGH36r8UWfSmjkqJKEP5Y7VkG4iKAuRHlOJfnBhYLNA1u9Q>
    <xmx:KljxatICk76V7ZTeoZox_kIqua4dCYY0kZUYS6PEkNyruGeZxvMkEw>
    <xmx:KljxavkAg_iZbeUHYG-oLu7fggaTF_mxV_tyG0grJhAih_C6IWy1lw>
    <xmx:KljxaqCgvDd2JV8IMfo6Ns6OT4zT2kGYsFI01sQffco9L8M_bC8-qi4W>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Nov 2026 00:20:40 -0500 (EST)
Message-ID: <40c6b45b-1d91-4ac0-808b-a1771a24faaa@pobox.com>
Date: Sun, 8 Nov 2026 21:20:39 -0800
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
Subject: Re: [PATCH 6.12 0000/1536] 6.12.117-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261107134957.653319350@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/7/26 5:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.117 release.
> There are 1536 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.117-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I took 6.12.116 and applied the stable-queue as of commit
39e32a361d2fca269cec12e8669e2bd3b84844d9 ("drop 24 patches based on RC
review feedback"). So this dropped the build-breaking XFS patch, but
still had "smb: client: validate NT transaction response layout and
offsets".

Tested on my Lenovo ThinkPad T14 Gen 1 and an arm64 virtual machine.
Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
