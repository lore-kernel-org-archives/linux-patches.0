Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAF112C7FA
	for <patches@lists.linux.dev>; Fri, 24 May 2024 14:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716561259; cv=none; b=LjhzOVB+4Z8xLuEsGhulrz2op0oDw0AnutRUuJu2vaJ4igbJTzfrmtglV9cTgU7o9p/0n+EsDSl4kyugJGCT+ssTvT+KpmiJnZTu6fLsaNhJefuaDk7xcxQkCVsVGUpv8XzfGa6ksKGhGqQhVz0SDV0uPhUNj5BajjP74OvBAkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716561259; c=relaxed/simple;
	bh=0LW5kQpkKcNA01e08onMNUViqKVomd1eBF+QginYHSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hqYLeiR2j/yx/4m+ZF/wYAzTuI3KwMcRHzbzSQmVM1NB6zStq0m44+NAN9TU0ja9Xe+TEgXt+hssUrFJFGyr8037PXOahtezIJRfrX+k7vaI2bdyVmA2J5Gjm//neVoZTAtL/dlvmGTmvtCyjcbqu+nTODXJPwklS+RNzTVZ8MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aocPyxlc; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aocPyxlc"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7e24aa659abso28649039f.3
        for <patches@lists.linux.dev>; Fri, 24 May 2024 07:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1716561255; x=1717166055; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IU6lh+O/rhQRAe/th7cj4rZYezjTqNUFq7EDizlAG6k=;
        b=aocPyxlc3OQOCKB/BMgRBjfwvONiJtAIeI+/MUIg3KQ9/GD+zv1dBvBjDqVYhYsDQg
         N7MmI0PSR/4hYdbv7CkyHBU/laRlpLRftl3rQfmXbSiFQ1Fm5j0YbtLPox2VuXdpfXm5
         tBAPvf5nHITS+o8YE9Hifgtr0x23YxJ7tW1wM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716561255; x=1717166055;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IU6lh+O/rhQRAe/th7cj4rZYezjTqNUFq7EDizlAG6k=;
        b=wBdsxLIrWa9Xa/upxs+iHWatGth9lFI0PA3Hcn6EuMnYicS/F5QXnFeKGH//r5mGUe
         znDfrXpouLQQHjU3Lidqn30boViwA3uZJprvhPy3EriuD7CshlOLCdb+Q6pA5KQColE0
         nnQQbxaBO0aj+FqFadWSesUAWwcjyR2lW1+Dv4yFzLldgLlNtSiZDYBVt7k8OCF8Hq0z
         rvT9dXJsD9tbhaqNwXgItwE2w3cm8uZil/eC4c/JOLRGss4qnrfygYuiaPf4KTg8TUUW
         bxW55zuXvVjmPIRlGNYOwjpjuXs01M+oHVWuWUmkc7poy5fENTAYxeEUyerOnfm5osqO
         Tglg==
X-Gm-Message-State: AOJu0YxHos1PgZxdJWN4WPZyIPdHqpSewpefFN6q5EqVKh3lfXVPR/7X
	v1y+MyxKUIH/K2N278hg0cWrCp2M6Q/r1M6BPQ7GrG5Sh5MVXLc4RNhYtVLPd4g=
X-Google-Smtp-Source: AGHT+IExzU8zbY3DeGKVrh+NlSIqHpY29IJlBPp0jT/XzxP1MOnFoZUl/sXSGgwPcNb5JNNHmGTscg==
X-Received: by 2002:a6b:f70b:0:b0:7de:dc52:18b6 with SMTP id ca18e2360f4ac-7e8c6650f02mr288446239f.2.1716561255536;
        Fri, 24 May 2024 07:34:15 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7e9041e7657sm38068739f.12.2024.05.24.07.34.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 07:34:15 -0700 (PDT)
Message-ID: <5e9f6cf3-7ba9-4d74-815a-17d2578548ff@linuxfoundation.org>
Date: Fri, 24 May 2024 08:34:14 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 00/25] 6.9.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240523130330.386580714@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 07:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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
