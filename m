Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9301C9E1
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 22:24:38 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-686bc261111so215521b3a.3
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 15:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691619877; x=1692224677;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BXEErU1EAFzIK7VWZ7YEZeKr+C1vSxWS6dUWwOP2Eyg=;
        b=aMTypv5TB2eU2ZhufmmWMC07SKzbrsSxeMJTTaSby3D0o57stJun/ajDamc5l0JRR4
         qwgx4UE+wT1o6LVWeT8Z9VH3AB/2sU12zc1XZ3y+jOqKAG87FGrSDccBjB0j5AGPgISx
         H8XQBhOsblvMqVlkwKxVRpt1BkzhWj4lrgjT6Z90nFH9YTINzsyVaYiWG6uz9e11bLoP
         RQsF5vta8BTz16NB4ugkumkYrEoi+dLuupGT1Bzk+WRg7nT8tsPcwgsqJPuMMGFQBLbC
         NYwJrei8MZJfP3QKXyx28nXzypM/UrHmjePub/Ly75BME3vTAtz5YWYMJ+OjTdLhcUuh
         n1CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691619877; x=1692224677;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BXEErU1EAFzIK7VWZ7YEZeKr+C1vSxWS6dUWwOP2Eyg=;
        b=WAg5HYy6U8ZOdONCKmcsXxuRfp7cgILwIf/hZCkG9FkthbvtMmT4qCvJrMxvfJCdMJ
         XtdlJZFv56KeTd4ZW87wgqOvlNrerzbChqwfpDoIQWlC3nAEgNn5nlkrIpnldpkJDAF1
         Bvn+BMYHn4LICNC+zBW+4RpzxO1o7flscsmOxX2s7Cb0XYRGYgaz5ijnM7hRvrvdCNnz
         ZgXZlecGbOtgKhrPjR0T6EtnrCg+MyI8qAhKJIb+be/aCTwDli7FiUcJ6dw4H8bseyeI
         lxDb4emuD6OiVMJNs/N4V4F0rcjoCyMSCxTn0ErkncQgrs1SOlIyaJVy+eZZslttSCI8
         8vMQ==
X-Gm-Message-State: AOJu0Yx7M9q9ZYsbuZtczZ1D0y5Eyp2bWmvAiaqaQZHZy9h50x8n5+d3
	o1DqP6FeDLnfh5AycFg/r3o=
X-Google-Smtp-Source: AGHT+IF/wuiKaV+WFKzntO3257Xvbw12LzunbFl1tnNBcC2t20ekI66/aAdzcjvyQq4w6z4iMhim5w==
X-Received: by 2002:a05:6a21:4881:b0:140:48d4:8199 with SMTP id av1-20020a056a21488100b0014048d48199mr516661pzc.24.1691619877474;
        Wed, 09 Aug 2023 15:24:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m3-20020a637103000000b0056456fff676sm99365pgc.66.2023.08.09.15.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 15:24:36 -0700 (PDT)
Message-ID: <9b640f96-deb7-c242-c924-8ce723ed9d2b@gmail.com>
Date: Wed, 9 Aug 2023 15:23:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.4 000/165] 6.4.10-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230809103642.720851262@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/23 03:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.10 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
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

