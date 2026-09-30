Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B505B4FECEE
	for <patches@lists.linux.dev>; Wed, 30 Sep 2026 21:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790802815; cv=none; b=qEEHAlmDpo7WlHxpaDAfqca/tt52MS75oIxfCPpJevzscD+6jfoc3R17BVXjpB5tl1b8i5MMAgJnXwLg3gZinm5HDjYXoHMCY8j8sv3pv6QA/KODFEDB4rHskQT6r2R6kAO0kAcBflzm6ezKsvNhqEnEXB0SmRZBVoMVVF9F0iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790802815; c=relaxed/simple;
	bh=o4a0qUdaCSeRTwNJi1IOPcOPxBAbrFqAapS0BQWB/no=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F9sxDxGKUImpLDF2s7h0dmK7iilLaQGYIZ/qb7aVF3UvDnDf2/1Ihp10e5cy0Z46Zick4zEuUBaoq4v8mjU1IZlub1ZSisZ2Pd1XzJm5Biyj5OYCTBQ3u8IJRQ+TaEm3jhCCCBMt4OeVjCBo1GA24e4k3ppeUuuUnk0LM2uOgTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NIp3foIn; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NIp3foIn"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-343479e6005so159001eec.0
        for <patches@lists.linux.dev>; Wed, 30 Sep 2026 14:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790802813; x=1791407613; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SP935/Mgxo94G/ukIIaM0Nv0lGPr7XbT3BTHdxiOkHE=;
        b=NIp3foInr8Mtsx+j/PcUzRwEjitrHppAUeDTDxShZZofeM7fKUQAsQVEDs23H7bimz
         9fpFNx/yIpMLKip8vdbTeV/JrwNkNXpUeMRCc5saFgm/uHWCxuu2VuT2YHNyyvV5SI5d
         lVudDH8aVOyHwyMnSYDx+68xObQIgdy4PiTFpHx1T0nMC6BNol5S5P6jVqqNSu64xtDD
         kFx0SEVo4hv81riuqDWYIiQoOib3NA1r89OChScDCHgDYlaPj6g0Bb2LS5F/pRS+S4zV
         NAoDlN6z4bvG/SR5FTBNIJsn/jx6qjDTz7qLcSwyUqCctttr9w7pchusy+kklhOUGm5Y
         kw/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790802813; x=1791407613;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SP935/Mgxo94G/ukIIaM0Nv0lGPr7XbT3BTHdxiOkHE=;
        b=qL9sxAqj5NSzCIfcEyEuUQei/VNloa48o61KoVEvo0KBmau+IChZGuFm9waAC5hO2I
         rEWBb/x2ZcBBqcUZ4xDZ8kJQWEOmRUjP2eFpZJjNvICX4aeQrSNujCFoc+xsZgWQl0zS
         5+OCwdNp2mknqiZwrOR8YP0RW0Vq81Zd9Z8EUjKfdIkNkJqJ5ezqs0sCB4B6kF0Q4XNV
         OgwEPPV4SHXhSNsMdY0+0HZ6p365FWHD2vFHd1j3qWynWSqwT+asYXWJCHw0Lca8I6Ql
         ARNqGdo6nSTPr930HmH1m2iKc68kvK44cFK4G4meMXNLfclXKol3ff5t3tlYFcfUf5hW
         f65g==
X-Gm-Message-State: AFq9FYKMToKpg8fv2stiLHQhvGW2YcYmaK1cX+rPFPK/NqeWAJin2G6T
	m2x4sSFZTLytS7ErtVhIBysJlu85eo2vClzaS2jRUl6RbOVcvsedeh27
X-Gm-Gg: AYBFou3ctRR9u5CkxVDDOErWrrB84qqu0eXdWPP+BCkH6I16sgM71E1baU84DFerNFP
	TJmkjTe6xt2ccEVkCQq8rxn1uLhk5VirP156WTuYdDX74Pz5x7AgTHXXj5kWYMEuweD+ixT8UOV
	6ITkItHw0auqdu7h06iBh3NiJioA0b/YxInwdj5ImbdlmMbdow3Oaqm628BdAbb8bIZgSOqvUe2
	shNnBnLPKyQ1ZIfju22rcCB5ALsmA156vJbMniALRZJPpsJpcRKaADW0jgbFuqe9ojdMLSj9fmF
	Z7fodrHeWOYB/5oIMKpb/++mO5TYBB1hqttcN5DJp0Id6eg0cbeWMEY51x6VG8fLz2Zz3so25t0
	TsWsea3dJtsQVQo+Uppm7a2bENXe+bEHiljJ2ANbq8uJRNmgRbg0U0wvR6yFemGDTGmWindfQNK
	z9gj7U4GwR3iLJIIqierZJcTss/k9fAX503v9K69VdUw7ZI1IrHJiA+uc+a2Ye29UoARj7Mblf/
	apjJ6RSmBp2/1QIZb9WICzU2qTu+WRRcy2xxHg=
X-Received: by 2002:a05:7300:f282:b0:341:6bbe:b9d6 with SMTP id 5a478bee46e88-34db13785b1mr695867eec.1.1790802812513;
        Wed, 30 Sep 2026 14:13:32 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34db31623b6sm1428918eec.7.2026.09.30.14.13.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 14:13:31 -0700 (PDT)
Message-ID: <4e73ef22-ee24-42ab-8e24-5f6d911bc5f8@gmail.com>
Date: Wed, 30 Sep 2026 14:13:31 -0700
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
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260930152340.591469096@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/30/2026 8:24 AM, Greg Kroah-Hartman wrote:
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

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

