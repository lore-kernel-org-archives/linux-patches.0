Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905D9481FD9
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 07:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792393258; cv=none; b=nr8WOo+c80eCeZmRBajeWz1YxaQhDw102WHvdPZ+CfAIpkI3T1CjfIi+xcoBu3qzZdYc3byu57HG1laUD1DMcaqYq/xUreeBP6jyszh0bzL1kGvEYhwY38B60L4AM1hF4VC6QXanNQ41ewMfxD/cBwo45LAf+7SqMi1X3E+iQ0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792393258; c=relaxed/simple;
	bh=1STDMwj9uzR4WBJXtTWOS59DAsb5w6o1AuR9iCqD5SM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L4L9oLm6Q0An7ZcKVEFBpoQFlIoNz0vX2I21718a0n5s3hTmeyyc/USCXFfl1R7MVNwsSYz4zoBpUMfRtIm8kHk0w5HcfowgoKGJOjCTfLZAaRRh1bemhn6wLFB1REJwmp5vi10kz7wwki9mMG1lpN4XVlujhygpAyhcDO/VSjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=lk+JC79s; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=tN5jOPig; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="lk+JC79s";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="tN5jOPig"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 0A6C67A01A4
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 03:00:56 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-06.internal (MEProxy); Mon, 19 Oct 2026 03:00:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1792393255;
	 x=1792479655; bh=Y5bYXGYvPJN6inJuQQBnrzR/y9AUfMwo0Jm7CFTezwI=; b=
	lk+JC79shz4VjjsNJgTV3aFzHYL1Ej+g30U5gwUVmku2N6dhgP2KUyI4bPVeHb+j
	P0hVGcMfjY8wOhdPONWYgWD+x3GeU36ca082YATE2kVtEegxFjN+oSdbziVwWHR9
	yNcttgTIqUqUFOu7rSABg4sSK7uXZhCRZfkm7Xg3FbVparcHiDVeqB777tuePepo
	FYrQjz42iB8vyIy8WkzVZQQTHUSi7R0mNkGgM07BZwT3OE/sriLJDIR/j7c4zu4J
	of0Cc8F4N+glbBL+FYlFPHSpQ4Sljg30wwsjG7BMpv8mogvem9VHMjnxHKVpNQU6
	LxtN0iCVvUUKRF3FUS61Qw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1792393255; x=
	1792479655; bh=Y5bYXGYvPJN6inJuQQBnrzR/y9AUfMwo0Jm7CFTezwI=; b=t
	N5jOPigHk13gNkGnJ/Bop2O8tkQNSk3sCDlyy4kGZ6FkNXlG4phctpkLCzhWZ7To
	+z4iNpzIZmEsGBUYvPKPM2RkHLI2yS0X1RRQTceM9CyE58ajmDh2STGyog7Ia2Vx
	1yTYFqAZ5zeIiuZvvTaMWMnuKLHNH+hjPsfclNRhcVWae7kGrHC8gfApHTYvAOf6
	Pu32o1u5bHfnl2lRVdXvBSm+iDGIJxageAgcjwNg7X138bmCGLkgcn+aBSKa5TMS
	Ra4C0NnTfQR2PcCZ/w970ZeyIqkJcYBckVKVx0Bul3UkBuyLjrqRsihoanOhfU7E
	3dRf/dAiv2sZjIF8iUFTw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792393255; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:W4IWcFWiMhC8QroeJ6w8HoTMhiIQP/xY33uHGXAlwlxY/mg
	cmmRf4PUwOjHRNILg0OndgwHe8uKBL7btu8wQ8hn5ryrdW840b51+vtZBmLXAEhr
	WQkkgLN0HqTI5q9k9G1wau35A6ITRJbqPZjcBJeciigSs0KgqHvuxUdPo8ymJunP
	T/aDEEH8Oz7uatj86528y6oBbdjLC1djWpGN5q2JPWurevuZsUY/pVwlBycI0ybB
	/pbjGH2J7p1nPNetoYW+wwqjE2ikw0TmfuF4XImtx9yhuo/LM5VDTozUKdErtIjX
	VjPQLAecdAkkc4BCv6t42ev/ReAbD/gvKFyKkfA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:93ExNsgr8vl+BBDk1et2SpthhZjc4BdlrKa+VegUl8Q=:1STDMwj9uzR4WBJXtTWOS59DAsb5w6o1AuR9iCqD5SM=;
X-ME-Sender: <xms:JsDVang1mhd0HqZJK4EsIUqzmglVlkHooXvvMLqv0Cd6_um3NStCFw>
    <xme:JsDVav7iVc9Kxw_dRUGsMVRs5GVkG4ZDyLPxaro-2hH0lH06HmrCfIVYspIXVs5eJ
    8IWk9B3JqYvipzmZgoFzjDQ1VoGKH40IoXxqY00AaOGi-3_3eJWqEHv5A>
X-ME-Received: <xmr:JsDVainBvQAYdPDDNaQ6FeUXaUG4D9vKbDFTC493iwBk--y3FCtS6bLV9ClzgcmQeFL8Ilg3Dl74Ji_GIuduYExsWrACwY1G>
X-ME-Proxy-Cause: dmFkZTFNv/uwNiMnP3PRAagtCwdDJWac+z/MN5lvwp+dBuvYxTK61HfAu3IcgWC8djDTKt
    rpCOMfi+pp8mQwnDoFr1s98ozL13LNu2n7LJ/+gXO+hKGai1M/KTaNhT83iQ2LEwSY9ATZ
    t7E+yK/QTHSq1ktX381YJUE9ENtlF2KwH8EMFuVyb7TMLOBnK49bV8AfvofrFYoZMQiyK2
    sPZJTma681pRr1F+sH8PYeAvSHEEkmxN5JhSxMtuo4jsUpt+tG4m3i40E5atJVuM0JQa8j
    gOX2VdCDZTHjK4GfuL/mgylmcdNwSrKhqoTh51FmRT/9P6GiZDUWstP3/6vk0FODmQWdRt
    NTGa+45lwJMFa3L174bLUb4t4vPNodN0xo3vI36kyCIu0M8DZjcs7/B/AzevMulYYI7mM9
    H7MMF7YL1noaHxl2cRu6SDDYkric/VnzknSWgDYOWds2AP/rb+XIcAiKV+7NPJWuN0lYW8
    bATGufHdqa6qx/BQqwZ5HMST5A1NrAF5KuC8EpJL1x02ver7Q4BWsbAV090uLolr0F14zz
    MR4I8SvpkZrE8rqaC1s7R7FSZAgwR7mXNC7NlzkZVYRzN59cozKRqsHHIYXwdOJtfh8EWj
    2kQv3SqZM2tuGfN5rEQW3KA9SF025KP69NQ/doCoePKmQAEAslOmCf3esCqQ
X-ME-Proxy: <xmx:JsDVaoP-lL-ZPjHZqM5x-uTzddaqXcQWgvWWJhdREsAMouG5wx1gnQ>
    <xmx:JsDVasrISSXCj_TNUuZRmhCeON5OslPUs6TgTkrjIyu0aPLmd2GhFg>
    <xmx:JsDVapuQYzFuq1JrgNfIAtksvJJP6HoOb_N2pZ0Ac8kVdJsxh_GCIg>
    <xmx:JsDVao71_T2NiqcBXsT8XMjo8sqS2HrXA0-6TP355uYPZLS2XwtA0Q>
    <xmx:J8DValUeHNOTG7eiiycPGqrGGoZamb2JV_CChSXbo0IqFQdKWW63XlqC>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 03:00:52 -0400 (EDT)
Message-ID: <01358de1-7f97-4bfb-92fb-4ed97ebbc29f@pobox.com>
Date: Mon, 19 Oct 2026 00:00:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/52] 6.18.58-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261017155104.830766652@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/26 8:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.58 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Oct 2026 15:50:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.58-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
