Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AA41DA23
	for <patches@lists.linux.dev>; Wed,  2 Sep 2026 00:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788307867; cv=none; b=WhGNeJh3HiVFkaYJat9M0VZV3Vv7nXgSyMSi+UOaZODAsG2mi/q4Ek5OXkfACPTUHAi7vMGqG4yKh7ayH/FqZL1nsj1k0UAExvat33B4ihNBE/s8JUALe63putzNFKPSY28CS7NtrHX9O/zjD9LKKeehGyu2KweWcydu7SHwtOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788307867; c=relaxed/simple;
	bh=zmdH0AqlvN5wMc9YIV1EI2cpUkUs6zchCsb/Rmskhb8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eUlwu+NsrLrGoNb11ekzRmXo9BhC/iqcgZzQRy7gLS0lUWP+t8VY5uFoXRWi2VmJddTwzhTiWGIeOaXdIZB6VuaANW285Zs/XMI5cg7miIC1W/AWDTFUNoKnNnayK6WXKxFFNGFLYr8pH/kD5R0PuR8vXIUTCmt1PM0gK56pOxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=Ks7qdpP3; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hs2c1WeQ; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="Ks7qdpP3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hs2c1WeQ"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id BA3687A00EA;
	Tue,  1 Sep 2026 20:11:04 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-03.internal (MEProxy); Tue, 01 Sep 2026 20:11:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1788307864;
	 x=1788394264; bh=TwchAukQ4Brb9+ah5YdPzAVPIKT/cfxOJOONG0fOHWQ=; b=
	Ks7qdpP3syh+Fge0NBu8RINppPftmqexXkHMVRqa1H0j3ZuzeNRoOPiYm605Ep5z
	FGXa5trN8pvZuWHq7YmCOx1Ps9NxY9732V8cQeBwHdMN1RBthONM5FOZx5iwbLNX
	FLcNc11P1IOTlk7Fwt51A33LMhd26V676tmOAk2JRSOA+SgdzIqKSKd5JtgvIGUB
	xrwdNKCueLSYCctLerV0ErkKfqu+/0jJr8z7GI9TBOypHIhsquiHyaRk6S/cNBL3
	25WkwBHk4FVCCeZ5K1EjGsnsS2dH5qaKUo/sabrRYpXcgUVOE8XVYglvsH83Za91
	ikc1SgURt8jfMk6zMHjG5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1788307864; x=
	1788394264; bh=TwchAukQ4Brb9+ah5YdPzAVPIKT/cfxOJOONG0fOHWQ=; b=h
	s2c1WeQ/SH8nRGu1sSGarDR5x296JEKt027oHQCLhv7JKlUnTHaFzu+1OXi84Mp9
	K+i7kta8Lh9PP85xwe8vw7xtn8EuvxKQz6k1/vQnvFDvE1B5d/sZSqThfvxmL3xN
	C6dQTQqVrLQI4/MECEN/s6ba+pLdFi02W7ZzglJA9Twr5nB/DE/9RkSyG6dPZDKP
	BT34jEdOHmKusliab5JT1BFwqPtTA4H33Ndcr6mSrx1kFAKJCBkUiYz2IjMjwchz
	8+NVetfVcH92hgJV1ZECAYlAyEQHC7qgB3kNx2QmGhgce4thPdTiksZkbdrOjP1L
	KwtxNUWc5J1Gb2x85GevA==
X-ME-Sender: <xms:l2mXapVdQdGl3XsVtTzZ0l9BMAUkSHgCyCORwLWBJtCsebmo9QOJgw>
    <xme:l2mXanSdWFeUlIpiOlz68w1wh9ftPFHNspWjrW-MlQ33iZteqDQ4MBH3OgGIFDkk5
    LE1aAKxVjNO_icf9dsKtn9HFr8ABFMukd5rxOLDUdanDEzrFphv4rY>
X-ME-Received: <xmr:l2mXanIslOCJwePLfL_lXaRsGb8q5Ah1yMiJF3Odpag23jSz3IxcCqWa1_ovI7UHPa0DTCZDBWH-KcdLTGEe47Sp9cNhWppe>
X-ME-Proxy-Cause: dmFkZTGYdGidO8Q0P7qKujsswTs0FIRBy4QOv/JCLoTTtEO3LidJVwgN8tFrG8mcEgpPA1
    IhaK7pdTzG37xH286YWUBan2Ek6NSM7WqpxgTLbb1EAJuE3LYYQMMIU4q7nXwMkZnQkoSm
    ncs5oOW2p7J7bNwKAdAMLuuiI9tHb5Yfe1EYN9ePqr234e5LaqUlBejcvw0CaEoA2D9KZp
    XwVXcKhZIUOF+T9fHZyYBUHhV1JEVb3ZYyx37KWlUfjvrw+/6FzZyT67m/AemMbNIvKYgH
    pgUBVOr2xq8aJyGPlRhJ1D40XKmdN8S3Hr4BAnX7Hri59merZfcVivap9TVuEiy2BVDPHv
    kR2tVm08o0w4RICgXfpobRdNy8wIjvKv2Emo1z4WUt09XFNGQZXWcE0kWb4k64s10ylIoN
    tuTp2uKgnJtBUhjqHuGkk0QaVa+FNAOOQfoFxdK3zE+XzYSC5Zuu4S3QBl8Cg8+W+FiIcR
    AmsAnEj5LlviUwCsL5qx+gOws73FB0EeUWnvZFiEe1XHTi/91BWrEzZRheEFdLq7ne/lKW
    V8Z08WFL9N83z7BPPnOa1bIc+9xO8i8Ts39ih5HFBbV5lwYpvEeA9SBUc/wORW2IDIA1SR
    989SR7rEPu9acR6h2y8JQCghhFqpqfkxZQdscbc6Qd1AJ6zitFRVRLFMkdWw
X-ME-Proxy: <xmx:l2mXao0RiQ-x1RG-Z_HvUopUMGhFXUAKaUsGcuOBmbyOoD0oSkfH5g>
    <xmx:l2mXaqK9ePe3MkwyYk8pJtC0suB-2k-YVIujsMslBNP5-lAcExggbA>
    <xmx:l2mXaolr6i9MV8wAdteAzEPQTsPJHtKAvEqdfeFhu30end0tSY_MLw>
    <xmx:l2mXaoOTx72Y-FyGcJmtjGhUx5xNYBpFUrMoDpaJFxAJ_A_Tfudtgw>
    <xmx:mGmXasGu8b1pTJgmB49iXlmH3wxegGn50nQHx6lW3eJt9GL6qNi5_o3R>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Sep 2026 20:11:01 -0400 (EDT)
Message-ID: <60981792-3ac2-4811-87b9-e0431037b232@pobox.com>
Date: Tue, 1 Sep 2026 17:11:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/43] 5.10.269-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133358.571886287@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 6:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.269 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.269-rc1.gz
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
