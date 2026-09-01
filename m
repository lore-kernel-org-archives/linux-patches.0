Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722604CCDE5
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 11:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788262609; cv=none; b=aPdV+Foqv4PiY73cPBOvF0ZTCMsjBdki4vonfucqGieKPLGeE8uXuQUHKOXkWIX4U3BYFEp9MIjmg1H0mRx7+FZlh2vAxNJbcx9d5OjSXzFEdWUUbS64PqRxPt4NUq88nH3gDmhAlu9w7jpUZQQzaH6MNXjmD/QFgQh6do2eYn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788262609; c=relaxed/simple;
	bh=gLelPmLEsoPnFKYlhDICAWSrN4O91Vosg3Qlv++Y3Uc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FUkRzlw9K+yHl3XgoRIjk+G5YKiVfDueTy8CcHflPC28QlBGq/K+S/Wl5IemsLjvuMXzB7MpIiT/lx4gGZh8doPUhdQ5DyS/+I+llC1QTbFJhDjNUDyEfRe8Cytyswjiz3dR0E8xhM8/O+DJGeYq5mjLiEM/AaDqRhhu9rAyxnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=pLtzi+c5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=VINdCKvq; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="pLtzi+c5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="VINdCKvq"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 4F0AA7A00CA;
	Tue,  1 Sep 2026 07:36:47 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-06.internal (MEProxy); Tue, 01 Sep 2026 07:36:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1788262607;
	 x=1788349007; bh=WWI7sQp77Sgm7AQWiGIdwkiJgyJusLyg1xrSIe6m9uM=; b=
	pLtzi+c5wrp3Ey6nDEkU1sm3LCu6IUQMeN33Vj72OZD2LeNgmetjiQQFHADbMNvW
	he4ejVPn7K4TcAJQtI72/OmEi/WVoDHfWswXVeDJWXvoLhwmIQOXacXRhMDWtrFv
	mc42wU0hl4cMNPxPhvCVi2mvdlGSuDdxEqyLB4MXkE/XA+f2Hv1Zn/eyqHyZmho4
	ZZoH3EnTPzAcUupNjIisXk3vim1VBcuOMHnrJZseIG/CqAx8ZD3U+3+JatK7je0l
	inEhshyX8vE8ywEC1irNcOQmiHEN8SdoLBkDAQNAGHu23yDz/iMRLzfiIdRcWBGt
	8Td7aNDM7npiYbji0RIDUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1788262607; x=
	1788349007; bh=WWI7sQp77Sgm7AQWiGIdwkiJgyJusLyg1xrSIe6m9uM=; b=V
	INdCKvqxil5u6CjoxuQerWgFO3yS6ZKGeH/AJGcFFh8fPINlTKR+dWkJDz2xQ5RE
	XV6uGSXF869VF8cjj8TKSUhK+dJxXppirPXF6mBOeZjQXqoKinV5EHTAYxDOSp+k
	jOUPpf8tMjvz0L/IXJaV0rkh4UvvKryed8NIhtoEWTHc8JG91er6R1hmhjwu4sNw
	OCBDX3X9ZotbCFe0EAUVyPyHwHDqvySA290c+P53GBBn2wJ8dQ+dkTBONJdyLzin
	gBCJpabvyEV887y+vQ7V6U4p7S3P6Pg5v488Yc3HbyiKA6GSgGkWViMyrvyrBsEj
	y+/ofzX41o8UYUz/hgP2A==
X-ME-Sender: <xms:zriWatTtoGnHyrgjMNBiUrYyhLoj3D6eTTHcfa3sVAN_-ue54KMkyQ>
    <xme:zriWaioKpYIyS1jS_fhfm6ZyG0kLDVaVnWaimFZ9-41-rUazYjZaVg7ckygwUnDLR
    kpe56TA27GHl3ULzhZMztuBemH_LW9zyH53wJHbA4q43Jzv738ZEiA>
X-ME-Received: <xmr:zriWauX2MrvCaDXiEaY3vb49R55LPenzn1RHKkPqbnA2hJhOOVxO_3ZAndLuFiEi4N4h6AptK9R-I_mWyRCUW_93UldKu88Z>
X-ME-Proxy-Cause: dmFkZTGS6LjT42RS79EjSyV0exP8rl87LIYwE8D6UfM99+DHSZKlC08qTt3wRDC2E7w3kq
    MLrMKYWa0eh5yk3yN/Gkw39oK8CIj8nQei6hmbRId0TEX3MNDpbtNv9uNPqdUS8sauVC94
    kKdVRORy0ENmJrvNoM1+gtOmkIpPy7/wH2yGboyAHUKHpn7R+QcjkibzizoLIfwsWta1CY
    9c0RXYsrxIBrj0b2IfJt7l9vDe8aGXM9m3BNjg7nm4NT4fdlQFAIMrs2w6YurbjwgQiLZz
    efoig3r8/HxLkXz4p2+05202Dl/SK/dl8ymHDmQIuv5BcYv+ZYMN/hqNhrH8PFy+EUNAkM
    oHNa2/qFtZ/GkBnZrW7tkTjDYP0YoZDv5bi9t8PpRrr0g3T7R7e16yfIaa2WwYaNl1HNg7
    uu7e/LPKLkXQJP8VkUYjgkoldRjt5aN68XXIxFNqJt21Ex4/bka5BW8/6nJflFWn5bH5Id
    b3c/2uMXiQ/la8f/lOqsbnpQDlTMWVc+epM+Lb2UcR36bD5XRml0rhnaMTtycuhJZUJe0g
    zVQFKVMVqxVlgb6k/lNok6iXJWBi/ayJaFFPQCxuxzODV8c8sL0Y+8NrM3tSHNIAFRkYmE
    OawOy0cRedq9zQHP1aqX0Py41hUFyoWxBmS+OqetVfUVvye6zo0eDKBILdNw
X-ME-Proxy: <xmx:zriWao_HEwMpsgxspEEGEegp13zXuLHeCby8VJlp2RCG3mVgNTBDWQ>
    <xmx:zriWauYq9okyHMI-afSo-GDcHGQY_6Q6dntSE4t-fsi4yeFRzxiCWQ>
    <xmx:zriWaod-vqhg0sVTJ0EytwEyyMkMPFReha-wkK_BosSdbLcBEG7xOw>
    <xmx:zriWagpLB7-57BmZfplcPDmt_4qV6jxG-lw0h3j0mfom8yM5U38pNg>
    <xmx:z7iWagEBW41cq6-T2T1TyWasimUIbZRu055RwETFJ8Fv2Tz4Xuh88XkA>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Sep 2026 07:36:43 -0400 (EDT)
Message-ID: <9a2a3d7e-0792-4fce-8703-05b183bc133d@pobox.com>
Date: Tue, 1 Sep 2026 04:36:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/92] 6.1.187-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133359.482388899@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 6:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.187 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.187-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
