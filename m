Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6F540B6E9
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 16:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775060362; cv=none; b=KKNsC7bXVr3Y2V+Cw4M1cNGrQcs6LRNmhScVGUtaCp5ldbD2J+YyOFqn5NaDN9yzJhsL6dDBxPdn82bBq14k8ARgmz/7JfVivAmeHkz3mGtcMxvIGKCW8R+DfDdX3+AmG0QYWkjA4yZcX16v6Iu5XvJkGA/yLqirarO1XXseBgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775060362; c=relaxed/simple;
	bh=25LG9q6Aiyfv1hJPJZPXPUkzGqO9cJdGQBOemEyScVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cq2c0QwiTJibjfRFArBhPAr3T7JF8f54wrCgY+v70iMd9HOfK8IG4POkR2zWdZmesU8ZXtbX/WqeAEpTIGcpqOjz67C6Io7SR7PV6IkADaSP4fImx6aDh6bElzHH1t8gLNrK1HT4nS4ZO46LITVIMWR10sf3QNoJTc/Oqfv+BrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cW061/zw; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cW061/zw"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-4673790ab85so4215076b6e.3
        for <patches@lists.linux.dev>; Wed, 01 Apr 2026 09:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1775060359; x=1775665159; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cMNvNaqAMcEfqob/rgMLpJZ2UNEAnteY63/EMPMRj/o=;
        b=cW061/zwTvl+KlDyKEQe4CyK9ixqJKPOChQAZL7e/cvRG2r/Bdh9Sv2V6+5QnXkSsj
         XS16s1dyGDIRYEVpumWCEingJOeL3MW5i3xlLBiwb23JLp5SehubVt2Je3+c3VOE6Bgn
         pdNbtULWcOtCNBVji1Y3bcokhP02HHjGrf6Ck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775060359; x=1775665159;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cMNvNaqAMcEfqob/rgMLpJZ2UNEAnteY63/EMPMRj/o=;
        b=dn80CpWyXxtqT7h6Z5rWqUERzkVWcJ3bsb9lyoz5ToB++hr9sN3NM5CvEFpVGchOW9
         WCXZWiCOe4uxJ91hujQ2V6cN9UCRBWdnnh6DBvQJDLVZiqd0Hbm2q/vabRe6MoCFgNFg
         2t1Ufj+HoNxOAfJKPMumObv2FoL+TpA+4wVnkxazaOYXiNjjk9F+ZkKGAms7eLh4gAS7
         sLWexbj/l8ksoqoIKZaO8/FaYS33Cf4YNmdMhF3NC5hJhBo6Dpd4tlC/KspwktH0FKzg
         45M8S+ylj/gSPUNdeHAFQefiv2Iv2Gx/n1lnxi21Mzug+8jp56UanEWsqBdn3H94EDsS
         SF2A==
X-Gm-Message-State: AOJu0Yz8GBsRI7uLxfhLek4yoHwsRRJUEAM0JiDIVrjfoHRdQwuNwMrW
	bp+MzPQJfxMwLgT3+TjBtpILHzzLpOdpKPV/sMLsOS21PMYx1r9LXs4hBBM2LnmQuBs=
X-Gm-Gg: ATEYQzyq4r2oinb9Ds35E89tYDxV/LVWsNak9cYxJV4ifYOc5cGUramQ9Rzg5kSjqUk
	ldmBO/Tz24koEppURi/2/fHmPSxsHpugsUW0Uf3xokfXyj9RM/t3dwmcuhp/aKn83O9ibf5CRoG
	yPQHzjVVWU8mR0pd9oH0Bm8zCUKpevv+yK2NCEc1QhRslshBs+9+C2G04dwsqI0y6/Qjcry/9Og
	2C97X4V8zjMFYZ7dAuTiFcTBdrj+blwbdHXo64lXVeVARlpFXw9wnlkkk87GCn7H0aCGB5ApI1D
	swc9UrzB0jzo2ri5Dm0pwBYfUtLSktwy4438PwYkcYkMhgpHu7USwT+7yT1ysYgtuz1gNS+9RSf
	EnMFR6uzeValNow5X6OSV5dK9GUEUE6mIgfF2UB3L2WP6YLOOaUnLpBHpb3SQcucNi/udGt+0fI
	1FSB/4H+1UZX0EMjQAPl5bpy/bvcIsymCKZXOZ8vV3Y+J9lg==
X-Received: by 2002:a05:6808:8958:b0:467:3f4:9075 with SMTP id 5614622812f47-46ae0217d37mr1973511b6e.54.1775060359214;
        Wed, 01 Apr 2026 09:19:19 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46aa03656e2sm8795860b6e.11.2026.04.01.09.19.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 09:19:18 -0700 (PDT)
Message-ID: <79bcfaf1-a242-4e43-a091-6704c89de8cb@linuxfoundation.org>
Date: Wed, 1 Apr 2026 10:19:17 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/309] 6.18.21-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/31/26 10:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.21 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
