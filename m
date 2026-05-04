Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D993E2756
	for <patches@lists.linux.dev>; Mon,  4 May 2026 18:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777917774; cv=none; b=RLRLFpNU33cH4EusQyp7GY7v/SAJYhUAe5G7xXTS923jFfvGrue54cw2k9ezANpENWXFfqdyFS2p88FVW3GUW/CYZtm9O+a/4sk8jxBy/mvn4l2wUVfl1y5FbJpt91VHk5BMDjpg8kyKF84RntHtAgFxl0Dmu3MH80qXoLy24M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777917774; c=relaxed/simple;
	bh=b+6/rGO6hGfP2yHssh0BZSHnfmh6bMHtEyKCdstr0FQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PFk4njgOiBNwYReIEygtf3JBV5biWBgdBKkZbPfHT/xEM/iOozwIHB2CP7em4s3lfzari41uvCkY5Lve5Tc4MYHH99tMUvl6d25XR76CX0SxWyaOgSk9dexiMx597lSxvm4a+P0KwdKVadvCkfz+H+R70D7tGM1v4X+Cs2ZB0F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cgqc+E1t; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cgqc+E1t"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2ee990e8597so4143515eec.1
        for <patches@lists.linux.dev>; Mon, 04 May 2026 11:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777917772; x=1778522572; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3wu2ryVmmLae1CpmhJm2xyX8P/Bqv42shsFrJAWP/0s=;
        b=Cgqc+E1tVUmrSLnULnJqVvSkMCmZeekjKdX3dW3xSRMKh1xkDfqCfmRdPKfyyQs70+
         zdYmDcbwmhJ1KWR7AE0oiA9YxbPIM2FDsUWIGNk9OzSeqTUko58mEqQcF3y+asDYzAFa
         u1PaD7VJQ1wJM6Svh/GMaUnknQtp2jwf/4g6EY59hwFohdtEWMiyvVyeq1JABaMPddBc
         53NlqPmLks5Dev3E362xSCJAe3PVfwarprIZAIvVSSnaZEjV5FcM1Qe7Iv34oP1t0UiO
         dxTH1hJuSciACqvjLRQ2IR9HfZJku/H+FIrF0COqFm6odGNulc0Ju429JaR4jKX4epM6
         2iRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777917772; x=1778522572;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3wu2ryVmmLae1CpmhJm2xyX8P/Bqv42shsFrJAWP/0s=;
        b=racSTGX1RpS+a6YMq4YZCQKhuSUSP6bb6cLr6F1PIsyyJm/LrvpALym6ftRztyn2QR
         2kafasg1OQCRflOZ9PPV2TujMjzxJF8kYgxXpK63/UYJ0CCQju/wDmo73Mhcw7gxFNS+
         xXyIsKu6YidK08nhT+W/kKSa1nrDTroeXInVQwzIqj2mBQn8NZhCOGP/kSZeqxGStCVn
         gopL/t5VnI8n9VExHx9Fim8bhcBWiYQSNIgJAMZOfPqGysHobRluE4LE8gg/NdzCbhy0
         9ktnQEvi0PhlbblbjX12Gbd+k0XKgk0E9/UyYMSaUM2FKo00irYCUq9cUwD3TvC4DSGf
         Cn9g==
X-Gm-Message-State: AOJu0YzuOuWW4FIyjG75r2P/6lG6HW8DeieF+LwKBRXL49TFAkEMl82K
	hyLCfvCrBN2RA/cBvZc0B/7GDVbvNW2+23VwREbklo0iSaiorxd6BwcM
X-Gm-Gg: AeBDiesDakA49WUFin9+TJkzWE+DgfVVH8C2YTyjrmjwJapOeVcbmUvTsNVVImg+m6X
	7UD234chciIrlWOg5IpkubiozcwQlQdfdXvHZKvtVzTDh8lGzMZYqSu07k4T0J4birSvmPcp5wy
	8zi2YdgoI4KLmU31t1d3ubvr/3R+Y0Xf1cuxjZ6S/yauqDtEY8tHLxI2qIn53HtLjC1sFcC4a6x
	ggH2yNkRkGAdx22s8rExptA8rhL/wLMDLI+KJv4djU+vCY2yEywgTvjptJoYbjbXvfZ/o2glqFB
	SBWwSo52pKz8+yD07KrCPPEAb0VPWWurRbYWfbOZgE1znVlzZmUSpB5oQbA1SwE3BcTWwf5GVDa
	UsWNlQU2Y1oR2AmT3JLvE0sn/VcbG4zPZhME1TEKBuwMeuZpRr1n0z256x8Xix+dgk4QuLoA/l3
	azOx6JIrjA/LVhdQLQj5rxotCj2upQZ/8cQd3dzi1loFmTwtbL2TZUnqWAAUvW6ELALHZOyHI=
X-Received: by 2002:a05:7300:2d09:b0:2da:10f0:a8de with SMTP id 5a478bee46e88-2efb91b393emr5186705eec.8.1777917772145;
        Mon, 04 May 2026 11:02:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ee3889d657sm16993427eec.4.2026.05.04.11.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 11:02:51 -0700 (PDT)
Message-ID: <14a1466e-688b-49e7-bbd1-8d1a87e1bf99@gmail.com>
Date: Mon, 4 May 2026 11:02:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/215] 6.12.86-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260504135130.169210693@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/26 06:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.86 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 May 2026 13:50:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.86-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
