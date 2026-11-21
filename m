Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795248067;
	b=2TokZ+L39XjXQ/Tit/IuW6OklREg5pcuIRtZNu04ktuq4j7Iv9Y7uXYEdSCLLvYkUfIz
	 N/i4zN4WY8tExjD7D0kGNCaY0+9Hliy7to4IuXBWc1VS4kwQavMiHj48aW0p9HuBa9mdY
	 qaZAGZjHe5C7OUJqpc71d5ZMhNxnwRuR2cYxvKIEukQtL3lYtu/2fFCjEaaJ6x6F9PfmO
	 WeHhwcatCjbQXvs72Moc7tr9iIAE1J9LzIM+/d4FVuvO88NKees8AyRUauETbBpWV0PNl
	 c9Ci0VVtG7gercWS7kEux0fTURYSwI3JJCZKPvKi4uoguhR8LR8lMqG5s2qLLbaghQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795248067;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=PffWv6+YUHHcok31J2UuOOEjqWyo2w3KUslXYa2N0D4=;
	b=ZaYq5f8+gQE+bpYInlxfKYlXUTxOPlgf4kRPIt0ZlHMEIHvjdd7GacpqFxqd9/8U87zZ
	 dMPorNb8kdGJpCLGeTMDW9Ik+yS08o3e63LmCLlHybkCHSIjqAsEGWdr57SGckgA78ouA
	 7vthGRth+ujD1gvHod5dLSwdtRltQ+yQaK1he0oR04gPqbnjTaXEcfPMJn/OwGzkXgJ2j
	 8AJrmkDk5hWtflCOLAhMplHx06kLS7hvviauouT2J3X014XWSGm7r4cYPrubvKvA+3xSi
	 pUROL8KXqxsXIjmKWmlekjHsX7bvHh22W2D0RsMyvO8FAjNZYCAqArJhNnWaiBSc5Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=FRvzMYNr;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=J5A6RNF+;
	arc=none smtp.remote-ip=202.12.124.153
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA55606A325
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 08:01:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BA55606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=FRvzMYNr;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=J5A6RNF+
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D7FA17A02FD
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 03:01:05 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-01.internal (MEProxy); Sat, 21 Nov 2026 03:01:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795248065;
	 x=1795334465; bh=PffWv6+YUHHcok31J2UuOOEjqWyo2w3KUslXYa2N0D4=; b=
	FRvzMYNrh3eUdREOvv3W0i2S+SDC+/+81e2o4kMkLaPj1cAh9C2uR1P7q+mhVTh3
	cVbxBXcF1RKwOthCwbua3CfxwyeHs/1xk5u77eSHC+Y7vzwZ6xY99AjmL0qxlmwn
	eooLoyVxBVin5F/8RahFzAZBu6XHtg3sQT6P4Zu8wA5Tn10cJuedU34f31sbc/I6
	7nMc/6au6tfW0V4CQHMNlEiVSqf7XKGhqwwqRU2L973hs+pj3vokSVOaUaa1Ag79
	NOXIPTd/PVjutdVgjFLwtiRZfAXPhJqnR9O0a9eF64YnL3YwVaClRyb3GRSYKE82
	T+FGmM7Pso4IorlHn9i7ZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795248065; x=
	1795334465; bh=PffWv6+YUHHcok31J2UuOOEjqWyo2w3KUslXYa2N0D4=; b=J
	5A6RNF+XjdatSDLKp37IfTSog/4N4jsla7zlHXcPtRg75e1NDY4Uubf6WnZjlSyJ
	5HCDRT4RzreHHe6GqOAYyK73+1cS+L4fCq+iX911cBjCPuAHKNPnl0bFZoW0tZm5
	uinOF9gxeWPQdQ/8DqAN4Ya/kxMQaaaiCSTi0FvqsNbjhreRbgQRqqlboaHexsYy
	9SHcOci+oD7PXXLdNooTvpRvKAPMkIRgkrXPE6WT2I+xM3CaokU9+t73PRwUU/9P
	a42vj27C/9syD/q9ucK1hazIqTsbSx2vlQU5JM6hlMVJoTDfkoHWKkBOQE/4HdZm
	V//XebFlSr+jtO5tRPaTQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795248065; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:WS2+wKE1HCMXV58BTvuG1xSEs22wjEVJ1G0iBa9blni4hyV
	oQgtItbQAXm0uvCMee/qpFV4tuOgTQOn7/LjZ0Qn6aEOm+N0+brM6K6t5N6+XTcD
	AG3VfFUUKXqEeExUZu/juOdFWWAySmaoHzTW6Ez2A26W/RvONjhuSZYPYjPFPqrY
	8MugvxV1+usDYTn13Tk1qZou1xG+kC238vibPOwz76Dnf1UzHKyEeHRWrrehtxTc
	2zamUmZSMOU75FvOqsL5uXu30cTp9brd5xdDgM50gY7GJfO8awNI4IUn0P17xjNc
	0SvMzmm3/92UT/siI+PUdBbiA99Pc0GSpqZDwtA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:i+QXPEs0MRPiOPcsjBN0YrAQ3sJkUTSmj8BA+SSwO3M=:ulyu3f5OdmXBIoGwTOoUtZsK1JnCHpefXqGCBmCUJqM=;
X-ME-Sender: <xms:wE8Bayjyy8xrmtUavpFVC1Vy2zCE4uThWejfTUbbBu9y3Jv-qKQmfg>
    <xme:wE8Ba-5ZSTfMwjhgodSSd_4xZ84EHqwlWUaM2n93F7jRUxQk3N8L3N1sBTXe42xXq
    JUX4DL6pzhpOFfjtVO5b0_evatitV9UoW0ZxcGSCai1cFu7ybEMt4w>
X-ME-Received: <xmr:wE8Ba1kFg8Xf8MGd0uBtVK1L2gWpJXizMDIN6YYlu75iMTcaz2x1AlKwkcXKlSrAR88IJmauPZFmzATDJ2Neg72K9wzPqB4h>
X-ME-Proxy-Cause: dmFkZTEf7U8oxoU8QhLJrSFZXuzPGT4cfvjlOjsUjZrkYniHAqk0qh3llwueVv7AmnMlV1
    /0P6p+J2klLQAvjvp9izGsExVveH6iPUBs6XRppxoIWzOcF7TPVvDjkHoNJW9hALU1wUno
    6XtfssAKk9OYH7az41HKoBGQQV4FLhq/haSh2maPvC18Kp6+xmE3yKG2JPIk5LrSjfWWoB
    UaeFOyDy5fg5JahZG3no4HlsV2yIicFtEGW8N0bPw6E3pwEj/ZYUOOuLrX/uBZWzc1d3Hx
    gFfPRokSBJJitgHcDPLxFiAu3leq/liuvCQUkbGpQRVTdIM8k/1MTNgGE5Y/T7uAjHWzCb
    WlcA94mBZ0i9TBiKCNXGu2If24CDwRalRyimntMsSSJrx3uELJQY+qhTtbyp1zR+lxzETj
    Un/RYIW7IMuPfEuasw+/St4hA/aOy7k657t0ll9c0SAzxf8EJKM437y1OdohH0mV17Q6/Y
    9wweopZW2eJghQNiRdF4rNoLrz/J91/YX/JKjzQfG82zk+VPT7dljzYGdaC99rgz/s+3SL
    D1B4Q78PlenPDUQjzp8jssP3zPY3pG036IF9MkAGXJu1GALr+PaBzBEryZR4Lz12L4FeKT
    O/4QM7RF84Wyape1wdnigMUB0owN/XAevoBr/g7bmvANh/hheervi0LSxg8Q
X-ME-Proxy: <xmx:wE8Ba_MmFj9JJtuxWJS5Nx86OzYaYnNBQnXbMF9PVhCbG4MsM7q4Mg>
    <xmx:wE8Ba3qg3OC3siZ-PtNRgsDfDvVMEf-2epzPWNY_bgnqmKPsK_PtyA>
    <xmx:wE8Ba4uG8XLQ67cgGLJw2INpMM26NZs4JYrrZxCDley7LwcnTD1EIQ>
    <xmx:wE8Ba75MpYsSsa51S_MLRFexS-iBXkDPADY4uXZ1E9CZPtcqo3g5iA>
    <xmx:wU8Bax1lGEPRRT_Di0XlNSABL_lVQ7Y_Use4okngHViaqzaq-auNPbl6>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 21 Nov 2026 03:01:02 -0500 (EST)
Message-ID: <36db0135-e58b-45a5-ae95-b8e425419ed4@pobox.com>
Date: Sat, 21 Nov 2026 00:01:01 -0800
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
Subject: Re: [PATCH 6.6 0000/3308] 6.6.163-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261120055324.975889935@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261120055324.975889935@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/26 9:57 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.163 release.
> There are 3308 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.163-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I took 6.6.162 and applied the current stable-queue (commit
3dd4b2d3c1f7915277082781d6dfbe71d7d41800). So this includes
the changes that were made after 6.6.163-rc2.

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working
well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
