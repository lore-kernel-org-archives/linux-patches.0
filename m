Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA264A23
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 00:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768003528; cv=none; b=Zrm+8w/KPvM+R2kgZ7ypNVb4g3IHo06mvYbj3BMDpwx5vJNPYL/q40xWdm7fIRT/6DLASF+VYsPW+oGdlY5i0qwoSrtUdAb63/foYAluExILEH4AZl4JBHCY6+VGoEULCpaCCJYTIFz9t2ku6m85oRDNN9ZgQ9vD13N9HA6vVdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768003528; c=relaxed/simple;
	bh=Zkx8aKglAxv43H/X7SQikRjKI8tgqe4DmKCA9DIlbr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JTtfpQecIu1Km38k/XVCkCc0Bon9xJCwSXzgmF6XPVNoXuSyvpHpJeoWUPy/BuzsmRYBXVQYgKHyNI5h5UVV9YszDPFKZ9ihFhc+BtdVmZqv1ZO6RXq3DRT21xSmpn+hRpUhZq9tC8SyomzEwZVR2oEki9URTfDHyzd08PdjEXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYmHUxYz; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYmHUxYz"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-3f5aaa0c8d7so3635901fac.3
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 16:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1768003525; x=1768608325; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hAAYXdsHBcUohYb4hUuO3vkL32uUYUoNKXR24qxKhWI=;
        b=YYmHUxYz5g90QHPkBHulwsF7mFiZ/wAQmcqlHiU0VxfXsLAiYKE10qPSfW3Cu7ohnm
         n/kmATjT2mGGkmescHsWRNZbnxLa7eEqClNh7jbUnCLM0Lrc/9wn5J+Tug3YL+Lpq7mX
         JqM9bBkWycI9quAsz7dXDj4lZ0C7L9fzh8mak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768003525; x=1768608325;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hAAYXdsHBcUohYb4hUuO3vkL32uUYUoNKXR24qxKhWI=;
        b=O/fTBrjW5ENITUX36oEZ7FFzHa1xKJFKdolwlOpuZ3KJy95R0IVZsqm83gPnqfgrbe
         mrfU/wRfV5SDKLbf8kHrnf4tIPncmlTIoABPTHoMCOYOsTIvOcbEVAL+sGrqgdkz3jw9
         jQTSd29vUt6y4VlyUDvbAh49rhyG4yzsnnXYbDl07yJT6q/es7qVOzIsWIa1+ybrZQwi
         IAsttNaYDai551kQTwracKm9/3ltY2iJovTTF4dRYCNY3RyJWDpIsB1YjKEumXGIRzPt
         UNpemB/puVQYX39284XnPQD8Mq+rId2QK0enNUMcnDEJgjsZTyPTbPT7+XXjmn01vIK5
         zInA==
X-Gm-Message-State: AOJu0YyLS31mZwVWlQpZAi9jaj7JvQGrs/DNBLVB/mzfGkTZZQawjgk1
	ro75/2MoHSn6DH1q7PuOB6iN/GJ2Y0BUIqjiT8NepiFMqdqcuy7wjee3KgJunLuwcIM=
X-Gm-Gg: AY/fxX5LodgJseT2rsn5Axa8qvnnKoXW6ZaaKoh8Jtu4xOsiff8qPwgumS8TLhydLeS
	XHapKWPSWeo0DfeEu/FzbykU70ee1nLxt2HBnkfoGcjdqcXdYZm2Y0I8jO1DJTDaGQmz2Lx9Ydp
	bAxEDcImCtZZ1+LlWGIqQswalpaCRIAOk9qzHpQp6BfzvvEOxKU5YSvyHOi8dgvFUX9Anuex9WE
	FGOJNPSRFCMUAZRjSxxKQKFERko2s2IIkFUnoHZEQWjDW1FxyNeExuVsVweE/0FZ92I7cMBpGrw
	9tmqotjyHDaGVOW7VMyEN5e3XWh4x3rpZhCynrIBVSYki1IotKgQrkIIa56x4RDG63dPcq8KuX1
	6li9e8SvSxFbJTOzBq0meDLN18p1x6erXlhkZAduo4rKZvd6fHPRA8Fs1o5xGKAcSjOlgk3c7Bo
	mqv0238F8tX6/PxqpR4vrq10E=
X-Google-Smtp-Source: AGHT+IGchok5FctDxwRe/FzfwKv+YVctWl0Umxq0cTtRxabxuoUsm6UeLDuSa6l3PGXJ+PUn7QNpTg==
X-Received: by 2002:a05:6871:7407:b0:3d4:b76:5078 with SMTP id 586e51a60fabf-3ffc0b948e7mr5457605fac.39.1768003525321;
        Fri, 09 Jan 2026 16:05:25 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4deae43sm8122639fac.1.2026.01.09.16.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 16:05:24 -0800 (PST)
Message-ID: <b93ecf1f-d655-479f-b869-7021b0681733@linuxfoundation.org>
Date: Fri, 9 Jan 2026 17:05:23 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/634] 6.1.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/26 04:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.160 release.
> There are 634 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.160-rc1.gz
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
