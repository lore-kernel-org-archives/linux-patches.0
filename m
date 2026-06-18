Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A734368D60
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 06:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781764903; cv=none; b=TJV7e9O9BldzHE6RHEXL19eYxhw2vnmwYAIATZYCS5aWuOlMxs/L/R6pj7EFPTEavC2UxL6Po94/vnR7AX0Ujpv1+fpAF4TsxbP8YVfeGTEGrV0/4+yydDRAy0T81JygnqSW5QK8HiRKC/Ob4gcD6wY6C2YAVvtV0SG4m+ez4Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781764903; c=relaxed/simple;
	bh=31Eeq/d+zoGG7PIX4maJaW5PyAmcLBVUkPNF9YVL6V8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hdVJXuFffc5f8V4jAtfay1cOKm2BcEqE+rkb/tRDve3927ymdwxOmOfhGHVMGkPuLM0rTQVl/1e5ROeawN3TErqge3EPBWdcaPqlm2RAWW/YCujdEEpaVOyMrdB0NvBlGObZQRWuBjGbet9sEQ940a2XQldvnfq4IcckeLfP+e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=dhqenNOJ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hrMAQpCn; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="dhqenNOJ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hrMAQpCn"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 573BD140008C;
	Thu, 18 Jun 2026 02:41:39 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-02.internal (MEProxy); Thu, 18 Jun 2026 02:41:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1781764899;
	 x=1781851299; bh=qh0UhrZdUGSW+V4IXOhrzuQwkfklboAeynjwycY55hI=; b=
	dhqenNOJCO8fMvRWY4ghC1LMH+uF8dO5THidXy4pUrCgVEPuIT68PGnl6OveXmNI
	W+qu2Bxp0GlwsaOYqjMMzwiam78f0FeZ7LRxxluP36pyGX0/I64lBixYpelBfJM1
	iTt90abKQE8PMsZ4O7hYwYlUxrrPOFqHdEW/1d1oEJgbVhijxnU8HBziUUZYRo/q
	A6gx2mHRvDEca3hyvrQPlxr9726Gy14iIeiTI72urHJWCnl5qDSL40+zVcUYvgV1
	7OEEcHf78vV9F0h1eq0/w8zCH967pjgXCqBDMxNeYv8LR+C303AvheVVc00uUlfD
	ic7pUf7a6IUvPnGoVkBDaQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781764899; x=
	1781851299; bh=qh0UhrZdUGSW+V4IXOhrzuQwkfklboAeynjwycY55hI=; b=h
	rMAQpCne3mIGEsydU0ynpSKQ29JJ/kSw5KDiPWR+3ISdHvGJyC+GDZE0n4jOcKPf
	8CzaDmqgD3iz/ThbAhGjstbEgfOAvmf1JkRAlm37/KYrprmIMFeJFxeaX+VAjctT
	ttwI3NpPywg7dIJvc8ZEn7nGq7La9MnJf7Nhz7ntjmBxkth9ebiwDdJ7hxa9cSO3
	krF6RFLCcsIjcaPEdi14vC0TT4p+mpBvk43LIAF90jhAQN5KCsl9+khrpJA1kv1w
	EUq88RECwh4nm7nUxZywNs4VtZ2RHlXc37iOOqKuOaMf8n8SOt773WpwLc2+fLys
	QOFg1cr+mdW2hEdHAb/iQ==
X-ME-Sender: <xms:IpMzapUNmY4CQqHNwskIomRCCoZy29ccMYSOHCg-puvZAvzQ1jyc8g>
    <xme:IpMzanSNzv1DBnzwZDx4h1vSD6OtklfMEXamwsPkhcpEa1zoerXgIL7akkjoVz9iB
    Muf9MX8TossP9uwsf3mzTcp0vzmEeH3dD19cH5tu13-VccyKUDvp6M>
X-ME-Received: <xmr:IpMzanJca_YmTHxNk4DQj4eswRSDrueWAIJZFngCt9EM6fbyx_Y5Pnxm0AsMtByhFhUDKZJkuweberyIOby2LcWg4G1XXHA4>
X-ME-Proxy-Cause: dmFkZTFFpRbhVo/d1+Jw5wBo7Xme1b9KjSnuZhTvpq4Pdk+DD/1DZ3m1/X0J17Z8XAeNjA
    KfJvqT82W+sFp4jZBjST7SF1dlEBFHsKM2Ext2dSnjsibvaX3xTcWPnLiw6Q1RwHZQjQbg
    d8WvlRkg3kGbtj7fRSr9uAkzfwMb/Ht0kM1L+7prZiO9y5pU0bw13PBX22Qz6xoghn89sK
    SW7ujA/+zO9ix6rIGBmwIA/pz4feItr1FGSpMhQ+sUD0AOs36sy85H92gX7TVZTwGL42Xl
    oMBIF6Kkaam060fl47P3cPEfr5rHBNbl2VjtuD6ekpr3cxfku4ClosivVchwr8Aahw8TTD
    LooQp9MFSACOhWYTXVRfTzmwWlUhA+JzWsE6HjPWCPO2o0yRU0E9VGRukgNS2kIjSu5yVP
    fDmTM49Z/zORgMc5Ctnmg1N/flpB+wrNXOH4FaAwuQ7lURKevdSJVZeNMRnHZJOH0Yo1IN
    eWSDMXR0IqECQLVjz1e8XPlXbPBqcxjly5kGzuWegNUTOpUU/7TImT4YES1orlTJ4cRLg0
    tkxi2hCgtDuK5eZWfFOXatM3/Z5ZRjaQHzStH1qY6ZhyCwvvytKZbNR2lToiHodnkaNkem
    tBcmtTBHFM4hknVEVH+ma0HOqomkN/pTH6JIkFJlN3db39k9UCEUdCnj3ndw
X-ME-Proxy: <xmx:IpMzao2BSPFrfc8WDknrpNwE0S9wpVMKDkbgOfIzpTRuXLp68LL2Vw>
    <xmx:IpMzaqJtm1T2IQr-aVkrHkz5xbSGDwkfJv_XWJr0_9KZNLTLejM9xw>
    <xmx:IpMzaolbz0Eijcvs9JTAMmvpK4itEvwYnjm9sfe94M8Pc35VfT3XtA>
    <xmx:IpMzaoPD4UtXnkZApvhLUfBhP29J9h9bQC8S3mIkNot4QY2QN8beVA>
    <xmx:I5MzagMp1E3BWI-6-txPWrIYRD0DcRMF1B7dLGqEes-Di5h78GotYjGR>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Jun 2026 02:41:35 -0400 (EDT)
Message-ID: <6913f381-2a31-4ff5-8409-a5725bf5a650@pobox.com>
Date: Wed, 17 Jun 2026 23:41:34 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 5.15 000/410] 5.15.210-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260617080316.111043001@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260617080316.111043001@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/26 1:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.210 release.
> There are 410 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jun 2026 08:02:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.210-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on a 2017 13" Apple MacBook Air. Working well, no regressions
observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
