Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A686532D42B
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 18:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789323581; cv=none; b=BqHv61UGgu/26ojlts7VcnsaDd5QhnNYLFmUmiVbTbumAKhhAcaVREl2KE0isFcT/TwdoqrDuHv61OP2dfaRooTmF7xMzlqD5CUcw/WNgiaeZI/s3fEgPCC7PCprPadszSXRnUukyJg6BRCFMHOUVQ05mP84/dRKOV2nNCHMcd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789323581; c=relaxed/simple;
	bh=p1h05sLqiUMH12fkllX1CsrbInUrqKMFt4kPBqvdxPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WJvIzdDAPcAeai1IWs8YEoMiGtviMHevVA55EJzqXzjNp8U2Bj7TK3+reOhnZU1KeVzV8JHWSHdRR3V96ik2kOMSpPMyDrsyzscl19AlMmdKAxLRhSkGa7unJju1jZDaDtyqeopRGiCz3i1lml2YGUpSLhw9IbiGwsF0xC+5S0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=s5BeSu2B; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Ur14Yuqo; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="s5BeSu2B";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Ur14Yuqo"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 1B92F7A0096;
	Sun, 13 Sep 2026 14:19:36 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-05.internal (MEProxy); Sun, 13 Sep 2026 14:19:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789323575;
	 x=1789409975; bh=PhpdmKFF4GKf25MNWIgC2ATD0QnH7wyB1H44aYeETLU=; b=
	s5BeSu2BWQTE8yrpV7b6cmbzU27xv/tmm8NwcHZFjsIf5b+m8bE2P30qMa0MDQ3o
	lcbBnU9pWfZAlCInmMSIJ9kmUta48QjhglNWXI7+A94rvmL+M5cRUU5uE+Bt7YZu
	8U5qyZS+TK2C8xxRPNUyQx9eKNwX5CXDLXjL9N3oR0+GUBrvZ8pY01IHus9Qrqho
	GUSzV3WEWtcqZ1f0RNTauRI55OQSzm4i/GDTWsnouvmXVQsBhrLax+6Izjk+RTbD
	z0mAxTuxzNqA3XnsdJk2DosrVH5Ytl29xEktVc2nIzAOK8LCgo18HJWS45H6sRg4
	a76pqzIkKs0yYZAf62iTAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789323575; x=
	1789409975; bh=PhpdmKFF4GKf25MNWIgC2ATD0QnH7wyB1H44aYeETLU=; b=U
	r14YuqoMHmHzQE0/AUVofjjJZHIUxdk4HR4ZsZxa3BbSsvRKmVyYx4gbp//QQ0SC
	zbWq8pSyHLtpAo/LKthOV7aQuDmuk3kjeOhDsWbgVd2Mvpdepk3d6FATT1hT5gu1
	oCL5GVK9MkGcdvw2pQw8bfzyklFMKRqAxC9G4pE/0ohE2et6vpq/i7E0MAUo+G9o
	fqxpDsQvJWSWkY27Fa1F1XBgY7p1XFKWnySdl83mHCl+VWq+MPlSG0XytXR7IrvS
	/x/Nl2Ivcu8PKrnZYm8/P5l/J3SFhgZQTzVXF/bWS+LgICpDrmuvoC9JX8edRrt/
	PqZ8AIGgBZhr6C3WmieIw==
X-ME-Sender: <xms:N-mmakn2hRixtB958whhZY5pcAhaxIqgHgwxzGllZrQTuQq4Ez4nVw>
    <xme:N-mmavvBngF5pfYiSPmhDgXotMtiKR3lBqsZEhVOCASmt4CK7wbygOh9Qj8i1cV7z
    m9Nn5JEcfAaXk5uNu9ijLSzg8O7YSLoGGxlhAB2zofwwz5aXmD1Ojc>
X-ME-Received: <xmr:N-mmauIAWNnTsrFQP1qT5f_tcqlr6EtFwV8-IjXB6TkEJFgHS9bWaGzVVK6ItHY-uxyY-bf4x2Ed4WliACCBEFloe44iflA_>
X-ME-Proxy-Cause: dmFkZTGVIe2lg9RCSkygrajC88+qgMM5GByuT+fLtPL9eQIqzjvQbPcRbCtHdceXg15BId
    21NxmSYn3EvxUtTwF7Jh3G3nXAa0q/qrRrtqZlMRUcB51rC5wKrcez9J0Gu88Y4K+pAMKi
    B5ULlMOYfnvYs8/4csWQwOBiZMXwIikDyips2EYA6cxXzHJCHKlMEgyarEl99QoGC9tThz
    SseXnd0DNgFqwpiXgjUWsBTM3EtW6+j4HoWasrrsDyVwNUWZ7gkWfjykkQyKW+qVISrosl
    1aD3xp8PtvhN0Llky9kS+ItxcwuDmrAYJ4QpnZ69MfkpWpVoB3JBKlMmad6UNYorPLx9k2
    46z45FEngR/amAlYBSLC0btDp7O1YjTjvmVIs3NLMQOB84pepXb2+QpQ2aK4/4+tTFKESu
    k5RUCc27vCKZCKclBRVB1BVh9z6azTFr26UVWd+tXhpBQX4Raw4fOLboGhGDpcrrsQuUWM
    lek4Ws24saxPnzjYa80+Bu3EV7cai5kHGkGx+vDcEVGANRVZtuz+q6v9+CcWozHWYkyAqx
    TRyY+l0xCvyBYhV/VPcshG8awP39EAuVYXVYiXUDwUcKq+YPonF4/sqcrvRtOr2hEyXixC
    bRN5F8Yh5a8yYq+09pXsbO/JxPOP5egcYkKoU3Nd7HzEoTK5UFrQ3YfXuS2Q
X-ME-Proxy: <xmx:N-mmakhWDrtDrAfxzlyQqKM6jTeabOsx1XZpWfE0-Y7i1TE_AdFjFg>
    <xmx:N-mmaqsla_zjyPV1IgH7zI_eGVSjBSKFFp99ibAlqyB41lojCvlK0A>
    <xmx:N-mmamhCdoGV_N21jjoLOVQW3I7NQks3_YZqKDouN7_JlH-AzzSVwg>
    <xmx:N-mmatfXrdAoIHn6FSLDQ3Gil5-P8NbovF4QGX3ouZdZ-j5mfyV6aw>
    <xmx:N-mmaqJ5kD55Fhxt1pSPXImW09ghDJQM-F1ibnMqDQsePfVjRzj39yYF>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Sep 2026 14:19:32 -0400 (EDT)
Message-ID: <75359a50-409f-452b-a455-780de8344a01@pobox.com>
Date: Sun, 13 Sep 2026 11:19:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 0000/1815] 7.2.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065648.999753832@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 11:29 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.6 release.
> There are 1815 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I tested 7.2.5 + stable-queue as of commit
5bd01cb1b5d8bdc0b5480752350d2b0f2d487986
("drop 3 orphaned perf prerequisite patches from 6.18")
on my Lenovo ThinkPad T14 Gen 1. Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
