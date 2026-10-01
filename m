Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE30435EEA
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 05:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790832336; cv=none; b=Dc9ABakn/QzjxzWCM1hF8u1Ev/NPWOaAdYsJkrhW7/7MNa0uwuhHzT7O3T779s2eBH2DtgsS5SCB+6fEWx906sKPKA+ce20RYk6faw05aO/47HM1xOHM4aQJbl03JqQ+v6sgfsJ9xNYKfBuwEf5rItDMXisyENmvPY/ci08yTUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790832336; c=relaxed/simple;
	bh=lsQMBdLcRX7PmWUQ5J/QEEvsnF/ZjUYdTGcRytEQyO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QuQ40UroyamA34wspaH917057FjAZDBsTr2ILqHSW6wgIHU8Hpc1oRYPhmnK0H83vxhMULB3YZBGrMtHTcAl/gNLg8oVU0/TAaIKTh9nYoBPci3AVtgme+luI92cdfQ8dEy4a6JdIcDmja8k8RHCHXjVPl4Z0rTbfATqjcsGfTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=IyyrDGRt; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=igN0LVf9; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="IyyrDGRt";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="igN0LVf9"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 823341D00101;
	Thu,  1 Oct 2026 01:25:32 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-03.internal (MEProxy); Thu, 01 Oct 2026 01:25:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1790832332;
	 x=1790918732; bh=DYe71L+mDbbwttT1897OI7k1IUNPmXiRDqp4jV2KsIc=; b=
	IyyrDGRtGugT5+TdoGc8NhL8YxZrai4YNFuYN3dLoa3iiAwfjIj0dhcqNOKN77hx
	q3XGEMPw7/KTe7RT5aLSUmFJbMvdlIWVWBzjDuVii7TCR50+ux3Q25cpU/vtJtwt
	dcD1tnh6NzHWcuZIw2lwL61o0K6CdLFkjaq44mt7M6ojOQmgXePYvgom0y4dHoP7
	YpeF3g0dkVZtgv28f+X3wwVNp9rDpgAZIWFRXpVEmmRTfe8aypYUTfRNjmSOfBkl
	MknUKENJrfY8cWtxlAs+utcF/+uUnIe8kn3+Q0IGUkwK/AVOUPNyZmQsELNZ8L6i
	S3XsL0kff8xDfAHBmtwiSA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790832332; x=
	1790918732; bh=DYe71L+mDbbwttT1897OI7k1IUNPmXiRDqp4jV2KsIc=; b=i
	gN0LVf9I/weJaTJw9z144q11EHbGOcae7ScFsT1r5tSTJ+yuDNOeBql6fldoCj0W
	GJEH+01l7IozyzefamETMCXVhtyPfScRTnDLR7rssZf1YSxaFKusEFB4p7Ayu/58
	ftEMkbyNrSRKqmT5CT+ecR6yUvpKLMjt5wddgRZZ9qIrt74MvUeSbv5xO9QmDz9I
	p5C6cloH4IJofE97EZTI5L9DOiarstZQIp+wlYuxANm6rgr4eA1fLsXoXnRfHLyN
	R0xiMS4zlxpcDX+2pj0KPYkXLpDfirlrwKWyIpmCwJsQ9hFnWqlNz1dlb4B9viv6
	v4vAMcJKGms5t0INLsUqA==
X-ME-Sender: <xms:y-69ahH6HDwrbJW-OL4lbdBN8up0LdjG4YFVEQDl2CBzP1m6Sj3ifQ>
    <xme:y-69aiMOscI_aOFTOr_ykSN5qPpLoE2A3GEfddDn-ntoDfwedFc7DOKXnVn7YgRSk
    2WTS18pLJ7LmPSQrWhxvL4PxNW-RJFWK9PGVlOX8nTo5dg7357YhJOl>
X-ME-Received: <xmr:y-69aupdbmMe9KAmBI5cLuCoXH4FIeaJ3EFH3LNu4VVanBVGqsKPA8SStmqoa9MXUj_B0i9QXE9pWgPZ6f5s_6wx24YoIKb7>
X-ME-Proxy-Cause: dmFkZTF8BPCiDwND0Mh4xnIYhVyPpph8ui90Syrb3L0zQW/6p/684YSFsNUG1NlE+RIwBT
    wDek5GsYyShQP6dIqOcjpWV5ao615gK1zACtEWiWfOg45Cyp4jBI/UPGsM4nS2zOre+E91
    wevRW4Kzocgrx65HoYwAqbovvLuWy4Eq2qqXseUq/UfeXJy1Fh8S5nQXyvzUcqK6LCIJmO
    lKz/3eC9qx+wO4jOge28wmpdkPv/2Ji9vZil1/22zGQKFb+bdlg6WN1GrWLh8wurOcfbHr
    VXF+HcWojgFXk/4ijv/f+dHFIRY/QsT5n+l27ntLEnMQDYqeij7kfBhG2OzVNO6KmUBZI3
    gJoeK481E4jObwOqhcvPlodJnpKxyoZF4Bz8IutjB8cDAaZKh3zvo/4ezwxRanKboLjQd8
    2wLTpmx3hQp4Vgs7Fw1PNSNhNZoKl0q8kSwe+RktWo3tHp/Flmas4mOKrRU7LOln3/Gbxw
    jBfCMO1+xDRFh/NFQD0htt0+cJouH4WILsbHzpzCgTacV0BbNj/yEqgKSAOTtbkr3ALL1/
    9QApYGcvNQ/dgs7fweNiWjCQo//CNjEHflDPsAzfC3ndKtDZj2nZGOYfO+s4V9p4xRnKfG
    BhV4/XWnm3Z4ecUpEiSRV0dhRi8kPqL2aiUAMkgiaeEkRg52EGYDl9hX2xWw
X-ME-Proxy: <xmx:y-69arAiiVH47vKuSL_1d06DRUFqDdyGlTFMOLKu65WIyJbPH3XNPQ>
    <xmx:y-69avOdOQK_su9g_OVQtVEaRLn3htwdRQceXYpnpH0jVRlaxsvQXQ>
    <xmx:y-69ahAp0Mwu3bWm7tNO5RWTZKx53JLWcNO79EaTBpWEA6IaWXaK1Q>
    <xmx:y-69al_9D_6qzhWAg70B1ptC7b1KgTw-anZHT2AnbYwCwU2FOO5MYQ>
    <xmx:zO69akqMf7-z9fZQMsru6lITi9wKoK-z-RhjeVav6hhZrKDmSUsUu-Jo>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 Oct 2026 01:25:27 -0400 (EDT)
Message-ID: <4f1487f4-872a-4c54-b367-cec8ab5a6621@pobox.com>
Date: Wed, 30 Sep 2026 22:25:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/877] 6.12.112-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260930152414.738996857@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/26 8:15 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.112 release.
> There are 877 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.112-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
