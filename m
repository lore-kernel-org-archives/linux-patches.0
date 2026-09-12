Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213C339022B
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 19:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242810; cv=none; b=KVMpS4StazD7xQFs10DtTtqgZr/8YFKE3k9Lmm2Pbk3NCWOUvXUW5ARZLqhQn8sC/6wLR2ykz54Mb554vYCrnLDxfMw3dHelPlBti+8OifIby0S5XG6WetGjmMWKOdbNlAVTwDGzlwYlguBwstzii5MApK/UZhC6glvFDJYvrsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242810; c=relaxed/simple;
	bh=QhujFu7ub6IE2ARBoi9F5M8+TesNlF+Y2RwfWxY4jrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HFwxGcykiUISaQgK+y46kZLKlCLZHq0tZE/YJhY8u3lHNw5fu+slATbV/cTIbUigZYGjt10y+kYpDQmFSv5w8drmnHoJsF0H1Fg/AX2tedb0ONokNyM5b2Jgm4cWF5GlUO0zpssYLi5XyFVwGMFMuas38ZpvnMBd0BPF5A7P/k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=xLm/Jg8A; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=sYKaSbh8; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="xLm/Jg8A";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="sYKaSbh8"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D9EFE7A0060;
	Sat, 12 Sep 2026 15:53:27 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-04.internal (MEProxy); Sat, 12 Sep 2026 15:53:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789242807;
	 x=1789329207; bh=efb/m2639qqsMfy0Z+NNVp675M9BqyPP9yCBlatIUIk=; b=
	xLm/Jg8AYbR2plIHf3zJzStKt0QXXLZ2SlmuaFY0+u15A0suJnbRO7VMXxeetCkb
	WXzqBx6KAM2BEYjPhZbW/C6n+8SS1Wym4ewK8a9SC41Nj8vjF0VZhArGOHHw5PXV
	R2wP/wXZWmJrF/ayLbKjE2iRCuR20spj19uRICKMtBTSeoi3KMpSdzV8kwE5XRFh
	mP9W88CQlppi95qmgTjv5TVZe65+klmE3NvUOBYNWpApfs/JqOsZrrXq+FQkQ4pN
	Z9XSQSdDhYfBGoXYsZ0YNlXo6yaWfwrXhOmNV+BPinIo4cD6TwSvdjedBzg96yvj
	CmVwrzoqvSTBc+33UjU8yA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789242807; x=
	1789329207; bh=efb/m2639qqsMfy0Z+NNVp675M9BqyPP9yCBlatIUIk=; b=s
	YKaSbh8f916j3qp+ZGNNnG7duHmtKStTvguaUJkgarkuO9wVqYCAwQvCoXxbZwsz
	TXfORt2QnZF5tMH/Uc3bLagxp7AruFwu54HyuKBjP9AWwaTP0pby3SnsfjYrNcWv
	z4unqMVfTJGxOMrmpHmkalR4GPucqyMAyFolO76HQH2Dt36rwOpNAj7F6uU77g28
	WFDgm++23RWKU986LU3i2KCo3ZalHY/WeGFwMsD30SnCY2KJ/HxmqaHRWpLFm+wx
	NmbxfeeCOFDDIXPBUppOaRuk4a3ntleGrmjzORh/8hJXN30WnOdqb0BkO33dKWJm
	RcqvyL+jU6u/uyZP5A4tQ==
X-ME-Sender: <xms:tq2lah0HfrWA8nlLRsG90lfJlirBcvClPEsUxArT5ZGH-MmJN1Vx3A>
    <xme:tq2laj9kzBHFlQnaXTXpcNf04tBMfLutnbr3AbZ5aESbUPA44a2x8RvzKHtXjWwuO
    Lh79wIpI-NQKtBFNpBhiLwLuLWRaw__kr_moZtvLP0OQVP4gC65sOZm>
X-ME-Received: <xmr:tq2latYvP0uepwOU189t3X4R4EVJmuO4sgLuRLTEvagn9uHruBd9qrqyB--l9RCXSaPft9K1aKBaQgcdwizGVuHayJM3DtFO>
X-ME-Proxy-Cause: dmFkZTFqKHF1MLRkXZv+Inqzg4R1iNe4F2f6ml6UjMyB4Hcg5L8p9eE1ahvGmR0DuXZGcK
    415B78+Xk9kIzAOkxvYjYOffLdehC0FaYnd/t7+aFi22xsEbQziYt7XzHQ3y8f2Bc8B5pa
    IIz48A/MOGzGylHgDuanjF9qfgNF3TefUpIPHLQI8XBwusdCHw/Q7/7tc+22DZHedTXSxx
    VRzuCljitYWek8AtWv8tpPAnk0GQmfv9Wn6uAkJk92FMaaC8jTkYf2VcwpmRJs53FBv5s7
    FGV9jccTzRMjeDbYZCNSUR6m1GsVRCdqLISySfG5d0Ix1p/9VnF26Saly/qwgXbPXZlLk7
    FdkkRFcq9RX44/V7WYOBG4hhBSHqDEodfyyRoWKSlKAPUYegnCatJqJmv0O92gjN80fulq
    dLkKoVOqUM8fHaY3m2AlEMQOeZvaGZ6LwPLm/CDAeGrbXy3LvhvNqOr7GasTU22dp1TLwZ
    RsEooKf1aGlM2lIiuLX3wXL3QqjYRg16mw6GIGr/0NiGSgjxaRwj4N5CtiXC6ow1qGmvnR
    0+VyR1i5RDVoJEX57yMX3fhQrJ3/E3IlR9sqPtEuSv2v1YcfBBOjSldLCR/aMDTbSZa3fo
    Z0p4Dr0Vklp6yEFsObozitbbAPldzXpUW6d/xZGwsOeJ4B7q+WzoghRt8itQ
X-ME-Proxy: <xmx:tq2laiyMnM_uHUDQm0fzUNJ0R6VizZFUxRo8yxg6H1XpC_2sYWMGFQ>
    <xmx:tq2lar_vkudWGi003riIR0M5vFBwwzGmB6js3Y7N3LQmsYvDeKp4IA>
    <xmx:tq2lauxEZQMaSYgi-DBTkkMfo2_JBODe3WZWEP13A0ioJPV-ZO-v8g>
    <xmx:tq2laguCZKkZ6YMAR59mptObQ-Wutbe3c0bRcDegoOYn-zgy_UJpSA>
    <xmx:t62lauIhs6aCGiQG7MTnmaYyiRSbCHJEmUUiu0NnTq8Y_KVDFBmh5liv>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 12 Sep 2026 15:53:24 -0400 (EDT)
Message-ID: <92ed5ad0-2336-45b2-b9da-d736b7629985@pobox.com>
Date: Sat, 12 Sep 2026 12:53:23 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/798] 5.10.270-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065516.948645775@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 11:53 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.270 release.
> There are 798 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.270-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
