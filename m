Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764E73314D2
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 01:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790905517; cv=none; b=O2Xma2PKKnsBZdEExznNWOI1zYpvtqSNlx1dwkkjuoGU0we06Fa29FnTJjJVnHvyPthPBW/SV+TjHcY20jMZfITMEu2P3uzOs/WMEYGByfdekflV1cJUrijs/SiAU0nP++yHwOiqj6XVeZm7TS4CxkYND4v85qtJbggckD68SaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790905517; c=relaxed/simple;
	bh=uVd6WCgxUTM3MIHISAwRh/gKReQcoeye7LHKidxnr+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oNkOyTYShwQSBaPkUDDezCh/egU/oVp70uBX4Yw5z6EpvRe3XxbsONdykgaeDsKR6gi8wsqSFpRLEeIvy+C9syJHur6gkzCx3DA0QpDe4+0x6gcT8lbEvuv8vO5MIWdfO6rpCNBJHc6DlLsMcGHZgeOcLF25TtARaWEhyefLQPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=VFxXq9xa; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PkZ2SWhu; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="VFxXq9xa";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PkZ2SWhu"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id C65F31D000E5
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 21:45:12 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-05.internal (MEProxy); Thu, 01 Oct 2026 21:45:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1790905512;
	 x=1790991912; bh=ibDMFjZJ/7ikBKNkg6ePvPzImXzoSXzLTZPwFbckOM8=; b=
	VFxXq9xaIYkauNK9m9AilEqCK6sdtNNJQeDRoWu95uS4JlmddPbdmFaYd/HU4757
	cQKo6IcavQi+moAzLbm1jKdn1gdWwZcIBu5Bzc/nKjNQsup1QhHF/LOqgVMBgSND
	j5E7+T/v1RkvNMlvWqEjhg1oA+8OYRaOXing6+3NJJ/0zIVPe8cihBzDghwggy2y
	AoMmGVxajWhz/fzCjhpvdCmnSF604wHjwizK9UUoRImGInECANiI4v0OTW2PBt/c
	lPUpIg6lvHG/w8UnUm0gV+8+zQN15/M0J9Nw/p5Pbyo3MSHg8K+2UNLAFXLNg6LH
	Qu6n344QqI6rU0ZWXvRXnw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790905512; x=
	1790991912; bh=ibDMFjZJ/7ikBKNkg6ePvPzImXzoSXzLTZPwFbckOM8=; b=P
	kZ2SWhurEGKFhgy7goZjKL5kraXdj2JkMroUUZj8t/PZgMkhygTvmtxAHUdg+tkm
	wh3K9QSEuPTLbb9lfjOb841gAL6bWrPCO/bAmdZKFiQqwwWvsZlb+jndIW0gUks5
	ksS6FAjD4XYIUmn75F4V0TBzjjhW/ae/9HGBtOJDQpvXXJUJyoEljJKZr6oKVw4r
	r9e4r6SfV++4aa3Kg4DC2CCGKzna8fZtbECAVpatYt3S+lQhtr3hvit480+2M53u
	NeWNe7RKZoaM97ZJK7q1Y3CFjwA47TLRiQC5+aStEmq7AZXlzNitwSYIy2YKvaTm
	58y0+pJYuj8MI2Gfmk7MA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790905512; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm3:rsa-sha256:U36UuQ9g9BL89Uupf5/q2lHyQBm+vza5fGhL+SxIl1scWbC
	xabslYbN9rUVjqAh0QmKCF8ao5Bxd514DVqPuMLyJ0j35TisfFMkTPmbjNxGgwQI
	BpXLdm1SwlKxKnEUDSMz2FqJndgkEoL2Kepk5pr3t/lTSPrcIDfSFHFFRemtEkWg
	Q98PXmbYO8quwNeOHoKFyC+TTbq17FwP/R2EBiXyvvINodkbYtem3tvnKPII4mev
	rapZWp0FCk/YFfc0kF3sOwysu2m/3SgnDypCOffmU0nxkfg+5E2zLet5QVV1tMdt
	hus88/KI3cghbEfpd2v6ppbMcOfD3s60LazGTfw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:4zbySHQDQJqKFf6yuLh+r3MoJV33v5t7LtAIEs9iFDw=:uVd6WCgxUTM3MIHISAwRh/gKReQcoeye7LHKidxnr+c=;
X-ME-Sender: <xms:qAy_aosWA_enGDo3s0S1qA6WnDUGOklrLWdyUV9_nuO3Ih4lZGnN9Q>
    <xme:qAy_ahXKuCBBJE4vkqOW6va2lDplp7bxIZvczAtDdJFbK3d2RUXOZd50hSAGX0tlf
    EIPWLvVg6DiMALtUH5Fme6xFB_iBIzrZC_-vI77BEjPvGf6m1w-T5Q>
X-ME-Received: <xmr:qAy_avTPrH4g0ZrJ9r5zmpQEuHMunAuHF58lQlFAsF4grRTqni0W-xXZrsXuu9G1zWICpSc8AcQbJPo8-6dUDC1tij2qTgI_>
X-ME-Proxy-Cause: dmFkZTF4V0bz4r7E8XJUN+K/PO3behlfcfAC4qFQy749o/EwNIvur4sMR2gyQvMD7K5tqp
    MS2jKgCVOcZH1q/tiMiLvR0Y+XNuIaNBpRJHXFJD48lH4lFG1+K3hDAYNIdnd86vFzHJfq
    mdB3rBbx6hqPB3pzrfoJEtsOsubU2DxJNuKmGRaIZ9P1bexgJR6NRlaREAnyasjKpFChZF
    ZzpKkLtdXltCNqX3aZoB1XCk0ryz6B00PLEG9oEmnc8glm4kdSbjku96SRG7Z3i9f38taZ
    e/5BaqrFx5DXKVFyyp374D4a4WkSny6B5OSxXeNltwUEY4fhgK+8qBT/8lugxjH2tUmWF+
    FTfw1lBPjDAxhDbzVpDMUWEsOWkq3kQ+MEo+I5qGqfnQDg+QDk5eszwtD8B5YgSfGwbs/m
    p6UQQ0A4PqJVhiFs0wfcIhh1rcGOPjU/UH1BWGVmzVveGUFgCFKmSd27N3CNZupaVS5w2V
    iB6qpw8kThll9BbsQYg52tUEYTCCVS8Bsn/fT94bSb/jNDVVjoS8E3NANfELv+AQnXl+1Z
    B89pc5NsOxII0ZPGLMX5T6AZlbdJkMrzm+f+VM58VOtJr4+VOqV7r7oh72uq1wXsm3mjw1
    xtWg8MXz8ouc3bv+BY3vPFxETmcoX/FLsYy0/a7cfpH9cu49WegBUL7IcCOQ
X-ME-Proxy: <xmx:qAy_avKszNLOvUpinlN9HLP5m6_AIZa1n0ULGQmIgRrWWDde7SWRhA>
    <xmx:qAy_ag3ICmsNkNoewHKJ-R-iOJDFqwFTlXwN7jM0-yhI31U6TRbt_w>
    <xmx:qAy_aiJyqrX5f3tMJFr4HvboOTFbCFYHzw36NoDJ6Pt4yIODfjm9aw>
    <xmx:qAy_aglGPzm4VsovzZ4bTdHnwlC_7LOEmBV9kPTzU0yJwxhbBd-hzw>
    <xmx:qAy_alzse8IQgzNIw3wz1MsxmtwEupMBlwt8U4RI_sY5M6I4-9N-qLjN>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 Oct 2026 21:45:10 -0400 (EDT)
Message-ID: <6d1227d2-45c7-4e64-bfd8-fbfaf1ec5c59@pobox.com>
Date: Thu, 1 Oct 2026 18:45:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/395] 6.18.55-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260930152340.591469096@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/26 8:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.55 release.
> There are 395 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.55-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on my amd64 DIY NAS and an arm64 virtual machine. Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
