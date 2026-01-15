Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754752FF172
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 21:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768512965; cv=none; b=hmxtVvMTydh3CS4cHBauxO2Eu2cHZMZT61xO5RJtG2s3hJTbne0dfXqpwlqDT302RVPAnZ5yxPMUHis1udw0C/Hhjqbjopz9VnSkvMAuKsiP9WJvC/vm6r9CDvwRlULdx5MPvUM48OGcaAwvmqWEPfgai9YNazTfFNlUDZ4kIa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768512965; c=relaxed/simple;
	bh=0sQoRqfSY+hyeYi/0+boEYgQ1XLwmvKzG1pYcjamd6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qccgDtCVUJLyf2Ki7oyXU3p2ZSJvQuppjoc7yT+GMfsZQ0b0VBnpHn2J/rc7O5IlPLdqTSdu/l3CwePSEIz5RVTYI2H+PfEtftNPtUqXRPvm7oAWXm8ZxwS0EuHfqlg1Q6tmP/GXgFGSpU8nRNefWj+b8pcyRronZJYWle/9QgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kaa4b9MJ; arc=none smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kaa4b9MJ"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1233b953bebso3456434c88.1
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 13:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768512963; x=1769117763; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oOX/JJI7Q1z1KP+63QYnKl74UqM6Wtg0qo85jQYwjQk=;
        b=kaa4b9MJ2YYyiiK0/fTnNTScjm06w1Q7kgn1mPkEz+awwEPP8a/vl0FyxaFrx6pjlz
         ry3n0ET/zRJYgF1vQW7lpnl46qopYUCCgoH2a/6upzM/p9oW/tSlFdGxmAaylEG+2Mvv
         lyC5rI9JtrjeE538+QCrBX9tGtoMcvnQNYBWpns4/gDuh7Cz2WV0EC/RVyhbXHg58h3+
         8U2DCHHOgKuz4bnEgW68PdfM5Tey+ojy9yx4l3Tv856eJLgniWR3DUS0GC/Z4rGTiISj
         f+hv9G7CLYF7ZPjS2VTjnEV2sEtsAtgdOQKFbTwZi2j8cirq3PgZc3xIyrQxvuCGvTCx
         YmTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768512963; x=1769117763;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oOX/JJI7Q1z1KP+63QYnKl74UqM6Wtg0qo85jQYwjQk=;
        b=fnU5SalJz23XcoCRxT5JjukDosoU57VWAO33BAcMWdz6WAxdUczdG7wKCR/FvqSpzP
         AOrgBy4eJ4RTgm16nlSFr6nvhGJHypP7+ZoZ5YkPj3MPjLaFNPXYdGyn4y4kx3WCM8zv
         7zfnLoyx+GHLxmFmIXUNYyzUbaso6KDrkt85cMe4Hr23YCjImdm8FHvUL5KF2cUynyho
         RHvo9xil4W3BHSuZ445bzRlM1xfLPwgbLQvRph0yBgQvdiokKcaSp7VT97769+jNM/1S
         LpGPUp9MOWiGgzMIfozkxzmSnhH2GXRnl8ZcF53sHYuz8g45I5iXAsSuEI4u73FzCheZ
         9P/A==
X-Gm-Message-State: AOJu0YwwUe/LxXsnDamhofV2BsIZeCvoTqklGzWgM/IUralOZLrybQ4c
	LYBHqifT3thhjFt1JUkrJNLeRGzabQdu/HqfUkDPq3zpSn16Ygqjod2V
X-Gm-Gg: AY/fxX4B1CChz3JLT8WlNsv/XxsQovmp7GpFgl/POskTjW15EBtpLXAKglWZZ2R+23W
	cb8VPxE62UCsBKYoFD2t7wTXXvqEb91bfVkwqPCfhhXryAIaaC+At80olJdUAdslc6w+bFoPSr9
	EBUR8dFderNJyOqUWvMlxC8m6daW1TMX5ywc6agUOFFRVd9mm4sTBmxjHw2tLsWwrp2Vhni2JDL
	rUtH3xWavQ6Vg+FPK1BZFsHmOnP5zt/PT68q1AmmTbktngrIkPLqTGbvReoOB3TLVMDQSYQqcc1
	LnOvcaIj5097/s8UBWdiwajcLw9fd2UIWwZNk2YkLbb+lDBmJrqiNWxu8NaYeAWFiyx1oIYUYI5
	y3W2yhCipVhbYNJdfgmnisW5p0Jj988vjXY0W06QHIxDPhtMWxodE/5AG5iaud54EDOxbsXta9r
	Cx0dwhRtXPPn8XxBGg9pklUSOyP+UgiYzAdixxyg==
X-Received: by 2002:a05:7022:619d:b0:119:e56b:c752 with SMTP id a92af1059eb24-1244a73c91cmr1270516c88.23.1768512963424;
        Thu, 15 Jan 2026 13:36:03 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1244ad72063sm763558c88.6.2026.01.15.13.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 13:36:02 -0800 (PST)
Message-ID: <9092c7be-c691-40ff-a1dc-561662feb56e@gmail.com>
Date: Thu, 15 Jan 2026 13:36:00 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/451] 5.10.248-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260115164230.864985076@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 08:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.248 release.
> There are 451 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.248-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
