Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B5A1F8ADB
	for <patches@lists.linux.dev>; Tue, 21 Jan 2025 23:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737502556; cv=none; b=o7p9rfuv0VfM6mQOGkgd6BEGiiBWGEygw+JIYo013Z4EfWkzBTkmuhrNVIEbYWfN2A2DgYmHPIR/EBpyuCs3u7gy2HQ78dONmrjWQHPjUoGdcEcDa++SfoEf7mIjWYzq0pzmihUr9PEUF3HqpYhaOvR1unWvsBx60uKZ2WIjdoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737502556; c=relaxed/simple;
	bh=yLIXfS5H6Vk/1bNoNsDwh/JheYT6goTBep4hSob/KYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TN+TWgWuyaoApJVbg0gC7+9msoOdVrYMozvIAYwIdoM6GLuGtPnWwHnQMWXmqRiKKpDQKq94Q+Yh2lqXtlolvgN/f60g2GIRYo5ozcQ0EPq09B7T6B5ZcIfG8G7lXiVhAvJvL16ZxPLkaJCKhqr/9InSPLYxOGvEZcMqOLrxXr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ebx99klu; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ebx99klu"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-844e1eb50e2so176298239f.0
        for <patches@lists.linux.dev>; Tue, 21 Jan 2025 15:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1737502554; x=1738107354; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CckOGRSHHekm/Lzdk/DPLRTj2pn0b7AArofEiAvn+6E=;
        b=Ebx99kluW1jc23ZvzXI/ybvLFDmxMBKJ4zFCX61PKUQOoFxX5heT53y5snMloh9pR6
         R4IdFDhemhmRik/9Cbop3sCQjX0mNzkplmcTkAdJvl7gprirXAuzLqOYvjy+cqKjj421
         QTaGcJ7f4D0VBFVq6fH7KXLh0M22zES13Dhec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737502554; x=1738107354;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CckOGRSHHekm/Lzdk/DPLRTj2pn0b7AArofEiAvn+6E=;
        b=DaeTRUwR5xp9a58UeknIOCoxM3elGWiaaCAf7mnCjvrHgee27Q7TbhkmoLMa5DPsm0
         w/SDQ4S3vQ9D4YM3MWRjCTjQNLwqMmtMgiwwbV+y2EIeXzDDufAiKrS1lR1ieqD2rPgk
         Ixij7v6tvmYhKAmsJGvunztfO0bSkHzUF0FxeSyowWdIDYUdh8kCbj9SA0nLzlE68nGz
         Q+B+Nia61xB5lBI0M9UCLXq5h9x45oMHHPtwgCQIO8CV9q+Iw6PSm4EvlT+NuAJcAdXi
         ylBirT5qNuW44fPdo5RbaFYbnpzpCIXZSsgRE1ew42E7EIzYnTB9ctSoEgLiIvIqw1x7
         FM+Q==
X-Gm-Message-State: AOJu0YwNpOEgfcB5ay7W+HGweZf3UdvCn/6E9HvpvbsA4mpcnz5+C/TS
	wkostPkj07h/UXCKzj67uIJmUi0PIX0kgtTyG0KEKA355g+dWIRZpOOiif0lnbg=
X-Gm-Gg: ASbGncvmEq7x19cHczIvXzbTJD3UpzgLdVwKFsiC9cI9qcIGJCVvOvR8Lpsls02lfI6
	0hpuADW7/Xttge8BQ+cSII0Z+nXJw5yQKooikml+SqzthqtyGlj+mjo2CRsXYXoRosod+3EWFyk
	qMP2tdpI54n8M+2w8G/OCmYUeA9EiugebHQgtUOTeEp5FBS10RcMElMFfbnR6taTSGnH6hHm7NA
	7W3YOp3Kd3akjFcg9popm8RZI9LAxhTqHxEHSuxJSwp58JaQGCqElLz2qa+ZrUeMuu+TWUGgwiF
	eeF7
X-Google-Smtp-Source: AGHT+IHLk6wwEW6autFW4DpcknpzfogCoULzAAsCB/s+J24L2Cn6np8HlrwVEM0Kl8iAOgijg9GxJg==
X-Received: by 2002:a05:6602:6c19:b0:844:c750:3d9d with SMTP id ca18e2360f4ac-851b618c3bamr1900034039f.4.1737502554171;
        Tue, 21 Jan 2025 15:35:54 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-851b021161csm345552239f.25.2025.01.21.15.35.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 15:35:53 -0800 (PST)
Message-ID: <41f1f446-54a8-42c3-89b8-9ff5e299b788@linuxfoundation.org>
Date: Tue, 21 Jan 2025 16:35:52 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/64] 6.1.127-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/21/25 10:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.127 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.127-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
