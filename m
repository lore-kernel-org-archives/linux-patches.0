Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792852374;
	b=IuIM3lmzfLR5UgbtrmZa4VU6lUjO7lUKkGwzEz75pRXKEcKhpgrlPoKkLDOaQnx3mNOm
	 3BRb23Z8xUOdk3fF3pnypVf9s4GKcztEG6ty34L5bP+wuu1opVoR3y5ufs4d3BpqDJEs0
	 CNEseZOgpgj/Yp0YXyRiSAsnGQI1nxUvUmcgjeaLypuHVgIvAgrigy85FCaxJ3uMfX72R
	 XgIfZf4k/WRMU9sqwPtz7rUmPpM45EllnhPvLHjf6LWmXohEgGGjA0NDUdde7fo6qrqet
	 UgA0X3jVaHPDP+ZSSf+y+l2xOH/bb1YtGGFq6Dh955htbncrC/b1o/x33WDld/mMtow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792852374;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=cr/MFgzbfp/0PfqFMYRD0aoKwz1s9qkrZtvNnzoLhtA=;
	b=Xqcb4NAo58ZwVdn9l7Rl7X6fYnsLpFhEwZ0QZ3kbe2GqqeDSESrpeTWNIteCeuvICsdp
	 Kz4s86H//4k12GwWWnUbqkaVHSBdh6EuG5aZpPtV0Q17wQtpCH2wLpeWUSOQXxapMKTLh
	 eXfxy7m+GRSy6kAODdVCGvMU16Z1ZY+ROb4vj7H+FAgVwp4YvZIZx2nEVXkvko7NcTw0x
	 9zifxGAHaEd1fuc9REMLZBD3xMkbUQvlaNRtJC3Wm6lPSPJ791NQbePD3czb+Y1rDEUKQ
	 beZNWJWSCIXRW/F3awVsr21Af47czCvx+UQTETBMLcYQ34KlMZ3amRQOOYn8zAptU/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=SVed4wJe;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=dUPUTpnt;
	arc=none smtp.remote-ip=202.12.124.153
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5C9606A31B
	for <patches@lists.linux.dev>; Sat, 24 Oct 2026 14:32:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF5C9606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=SVed4wJe;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=dUPUTpnt
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id F2D767A00DC
	for <patches@lists.linux.dev>; Sat, 24 Oct 2026 10:32:51 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-02.internal (MEProxy); Sat, 24 Oct 2026 10:32:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1792852371;
	 x=1792938771; bh=cr/MFgzbfp/0PfqFMYRD0aoKwz1s9qkrZtvNnzoLhtA=; b=
	SVed4wJeH8EArNTS0lkYD6f7S+eogkv+YMT6pnZH+qjjRvp/nP/QDuDxcYQqxT1+
	46ngOr6w5uj0AO+8gIxXUt0lgl7qgnGtSUx93NQVcKjNKeYjSJgOiuBJlYjb/pYR
	LVQQImPTrT+s1UhTdriCU8VqhdxWk5d7+zL3/my61HLCZGRbOMwFqawtcbbmjJZH
	ZD1bOiP0d4xLZgOKOhmc983z77jT4/7ys0A98v1EWQejKWef5L1bUcxMpwh9nER9
	lybllWtnXKBaaFKJ0SPhaG6+BeL3jD0igDLVyLMwXsGVLDlTEjOmfBsi13S43Zh0
	nDwIImx6l5ZNwuZhPeTWcQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1792852371; x=
	1792938771; bh=cr/MFgzbfp/0PfqFMYRD0aoKwz1s9qkrZtvNnzoLhtA=; b=d
	UPUTpntDYbofF8q55TnR0nMguffhZK0nlckfMELr0MVwHzqxRcFg+LPioj6AcSQj
	OFGGwOU6QWltJdCrLvsqY4bhB4j+kMAzX4b7Omvab6D7YQMyOCwQBGwyTOW+1wXJ
	bpzDcy27mSJxpjY1va2gFfMfth1jeh66U20VN02xDdHnkL1+eGMAg1LaFfhQkVCu
	zJGwVeqa5yJnvlFljnfmeyavxKvcmFY3KQb9V9aghFQEtcV+ubmqfJpoHjFRKQQ8
	7ABJ1voIc2uhWHu6DRF7pMv+X+ilKv8fibutJm9azqAGJxLcvCYnNRcwXrdUo3kM
	qnHgjmlZzC7SaQ5b2ZrVg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792852371; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:gQcLCYpCQ3LkOzZxX2jZOWNFnIvZDxxuZpjZDz9+9aLAoBU
	bnOt36a9kjtcqhMu8LhsnqI6ryh/o9xDU/fDnJ+tAyd+yzqW/OCUQ/6L+7dxKLEg
	RWxDe8HC/sSecctN0AW4salagfcGsTQfkpLq/KGuux0Ma58uIKUPw6R5clJLFTVw
	VEHWkvlMHdzJgba1d137+DCk+oY5c5YXu67zw1cR4E9vakLfxAoYp5UsnXeDipDC
	HhErZIaSoSpGA2hiblMcF6gJ09/8KnGAb5uFJ6enwMCL8Ye/zai89/Xv3+iQv6jO
	MrML5ARhhatvZp/2EK0MFAVJ7hVv1aeplm9q0iQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:BjxQt+4SdIhaqvtXVdWCuC/zBi0EuYMXQgW581w6nvA=:d40BirmOlgNKOLeB42aieaS8xJBMHGZGrbs2wVubY2E=;
X-ME-Sender: <xms:ksHcakS25xizakwyVmPzoQJeDKoSe6H7oqvpy3qsBrn54XViSQkNFg>
    <xme:ksHcaveZLdDCOq4U0PrvEDYcNPTIFtVnazOzNL-y_ta5ZKHW9kjihnvwxcUlWASEh
    gaChvpHTVXV-EIeYo56TBEp7-2zE-nzgeSV__DOVVs5SERCJ4MsSbg>
X-ME-Received: <xmr:ksHcajli5RCcyfE2FCYuuKQIfaS-HJ0z_FXPt--N9oEf8lkk7rI8ykH_Gbbnveit3FN8wC8riMTvO9wB8G0-qjNQIa0dwEsX>
X-ME-Proxy-Cause: dmFkZTGeuSSSqsMHirgeUUS2dLnv3QuEFpJ1nBOCCe0kzLiaaEeWj3xoE1nar82Jfkyhjc
    tDOdmTIZL8yrkwarxsxd0BIJ5HbPwo4YBqU07rspDfc29FGDHOJIkm9yrOZ9Nc3uY46rA8
    uisoL2Rry4J0GScyKokyZ8DqCUM0HX3gT2F/FX2OBnI1PMI96mR5THTHXiXXU2kNPEssTT
    F6BI8/9CI/a+s8OclagmcRd84BEASIfyOjld22vENACDjrT3oyj2j/98Wqx98oqYp/7Bzs
    7MyqEZ4MxAdZt+wn+9Wm8MYq/twlK/HiaQlQEO0NfBkK17XDKuNcSOGRfZ/ZYXHdHLgeHf
    2uzWoLF0BuLd/0K5P+bkLg3KRNOgfEzxBvPdydy3teoBOuoUY0yMNe/rIGJuLlDsn5LZ2V
    O9rXHRPsnBNAA9uPJMlQ7DJwzLpzs/LnRb7MW3N06HWztdMnXrwhQtwMCBfrCjWzy9CIb3
    2JZ/QR589QZXYyEd77PWETnaR/VtosLyB0i6+kyHlJNrlRbXLypZ8pTeF0OJB2Bus0o6Al
    fGdMrz3bn8U+HqhiqDSnlHxpGA1hPj1237BrB2c0M5U7GcA6p2dDOXnOtP8A6M/qGcmJIb
    Od6e8Jc7uB1jeM1v2JWIGWTK0Wb6Va/Rmy38J2LzGFmCBUfhN0LNwTdBJYCg
X-ME-Proxy: <xmx:ksHcakjB4b0juonzTjkG0oGN3RDP6ivxCzFofYtcQyERhiFPF-Cxsg>
    <xmx:ksHcakGSgQsvvEc4dndRpG9fowoW8_CKM_GLQF4EsspvEHPMtHEFug>
    <xmx:ksHcajzNR4vWVlEPo7m22EguQ4i-g1ZxjBJFl1YsTekD_Fpl_ZluyQ>
    <xmx:ksHcarr-VNUK9fGBMv3JliTCqm9BmXdSVsg4mt-cqmwB9ok_REE20Q>
    <xmx:k8HcavssCJC9iHfGBtvT4A9TdfYP38ebVpAhmeY3ODR9zGIbePRV9M5l>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 24 Oct 2026 10:32:48 -0400 (EDT)
Message-ID: <a65e25c3-b1ea-4b8b-bf3b-c5de0d069b22@pobox.com>
Date: Sat, 24 Oct 2026 07:32:47 -0700
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
Subject: Re: [PATCH 7.2 000/243] 7.2.13-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261024064731.125251200@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261024064731.125251200@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/26 11:59 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.13 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 26 Oct 2026 06:46:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.13-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

With 7.2.13-rc2, each time I go through a suspend/wake cycle on my Lenovo
ThinkPad T14 Gen 1, the following line appears in dmesg:

(NULL device *): Direct firmware load for i915/kbl_dmc_ver1_04.bin failed with error -2

This is new and appears to be a regression, and it is 100% reproducible.
It does not occur with 7.3.0, 7.2.12, or 6.18.59-rc1. I will start
bisecting it shortly after I send this email.

In case it's relevant, my ThinkPad T14 Gen 1 has an Intel Core i5-10310U
CPU (Comet Lake-U), and it's running an up-to-date Debian trixie.
-- 
-Barry K. Nathan  <barryn@pobox.com>
