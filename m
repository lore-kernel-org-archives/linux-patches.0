Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E48215066
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 17:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744995622; cv=none; b=XI39USBpIMTdB8ULx0FtGUddAG2MDcFtZU4XIqg7m/Odyyu2zmawRNnO2A6kBNMW0EP8B7HPiSXI532JHGl76wf9Gf2mXuymcYUbxfwdCND69jRjXBYrPi7eQYfFkysPiAbvl7xwjoj9onHShH0UPUfw/tZLxrfTO9F6l0coOt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744995622; c=relaxed/simple;
	bh=Q+BDfiFW+VoaSQMQ8aLv84jJcRC/wcDH4vCfEdzdhsw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hiFG4V0hp/UkYVPE9/Hf2XgUoYfmJbWUz8W8rE5FF1BTfGbnm/erMxSZrjKYs3BsARQ26I0nw30c1jK7P/6BgntmThFgKRvYg0WBwtI3CM92mMqWFh737qnZG2KbBnexa+lpam4L5NLxuGK0l//CthTQbLSLqjLULXMeBMVzNf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eE1O5wJo; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eE1O5wJo"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-86142446f3fso49618439f.2
        for <patches@lists.linux.dev>; Fri, 18 Apr 2025 10:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1744995618; x=1745600418; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=61d/sKYxMGCNUNhoeDAO2XryMeoJdihIOmj+N3+Z7lM=;
        b=eE1O5wJomlHft/KgQt3SNohoH+J7994gGAKxc+Str6u5U5kd0TkvopdkqaQ01jByFd
         in4jta1MQzM4G4U3KiwFzS9t7g7ncC1dkH+75ZkGMmjzRDTGEDeoTLlPvajV3pagUXFw
         pcca1MfX3cEgXtLQOAj8MLFXyHDRzr8Lr3+ZM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744995618; x=1745600418;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=61d/sKYxMGCNUNhoeDAO2XryMeoJdihIOmj+N3+Z7lM=;
        b=NBPeimpKlKQHLPH6UmKmG6do457n7Tt3tFQGb1w9uws+nnfCBY+BhBbwm5Gajvf1Cd
         NdADRr8VMPrOUZbQVj3hGw4bBJ/keVtC6Fxh1Uon74yBuZVOjsT8UiBFv+XtC86B31aH
         U39u6jCpF7EyjlMO8Qa6UuDYthWN3laRwgjRnITs6BIzN7L5qoBT+2sxY6el9CvDlTP3
         oJwbfOjqjIHxA1OBznCgYff3hejfmVeNdbI26PALNdHhm0iUR48XhVU4qm1I7ntTpzE3
         rLnG5Io01h92FeoXpVRWfkrRZ3ipJNnqJk4XABhbMCXGDSsGOh5+j59dx46qCzPETjlc
         HNaQ==
X-Gm-Message-State: AOJu0YzydIUFYUd6MSFk6tm8zNv0FuXekwWStMcsHCKtAr5tcoFy63sV
	0XBuRc18mpFIrOJ6ZJWtwo75ybbKSGbxOW8K0gvayKe+wfRHYP5FSqtRTLcCKYLhwi7qJcYBnXP
	N
X-Gm-Gg: ASbGncuNtauEImkIf1TDwbs7YSR0eomjF5PumT7ClZlZ52hVial7tUBVUZCCpvBSlU+
	Llyqwok9/BScx8id3FLTP2RVAg2QL42c3hxQWyoB1QqwIVcPoopA+SaMirVrKpSmnIh2LGr4EkT
	suAe2o7XC11HhASjcr93vaMM7spJ1bpwMmuGxWcKS0PWJLg/WRaaMKl1xDvdrECv5MN708Cr1GC
	SiT5Ss7KpU1I91YfFtlG1aJjy6ca5cQ7LP937QgcQwj2NyrYS8LM0OqDQpou5UnCqnAGhpVSdGs
	uIV0QZiGQ5fm3NkRTZgFGHD1nUqFJOGzRgB4ffktSv9Rg12V1QBmrL+tdFo+CA==
X-Google-Smtp-Source: AGHT+IEyIUcHLda0Oi5Dxfiv38uolw830VjeERY0b9n6LCLvY8kI6O/HApmGqXlxMWs/ME3XOMIDvQ==
X-Received: by 2002:a05:6e02:216d:b0:3d4:3ab3:5574 with SMTP id e9e14a558f8ab-3d88ed654ddmr36402815ab.3.1744995618252;
        Fri, 18 Apr 2025 10:00:18 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a37cb87fsm528003173.14.2025.04.18.10.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 10:00:17 -0700 (PDT)
Message-ID: <d1a6d53a-21c7-4500-a060-26c15c4f32c3@linuxfoundation.org>
Date: Fri, 18 Apr 2025 11:00:16 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/413] 6.13.12-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250418110411.049004302@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250418110411.049004302@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/25 05:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.12 release.
> There are 413 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 20 Apr 2025 11:02:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.12-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
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
