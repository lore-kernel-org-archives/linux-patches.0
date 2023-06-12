Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8248118AE0
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 22:17:14 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-777abee746cso44151039f.0
        for <patches@lists.linux.dev>; Mon, 12 Jun 2023 15:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1686608233; x=1689200233;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=turarmRsZsKnFTASVKXbLd/oQFYI2Vru5D/pwWXxLfc=;
        b=Fv4uU03lO0dwiallZIjzmXx+z138lR+3e5J6GyRz+Fvl9Ff9JsjmriHTETcky72Gbq
         BZGc8Ftx1HKLQ9B5x/5DI4tNbP6OgwmsjFg7m0I3WRXJZeXWpHPbKSxzOd9Y/le2vh3l
         po4q0roSYyIyb3ohJAe3YZhjM4HlKgtZsXoB0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686608233; x=1689200233;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=turarmRsZsKnFTASVKXbLd/oQFYI2Vru5D/pwWXxLfc=;
        b=eVk9Xwr9cBg6FklrxMIKhT1IybaVxAdKQELBjK2JSAlPDM913yTcZ1X7v9HFpVnPqK
         pxeX9xSGUucG5CIX92CkvcpFEvx2c8mQsV/wbBm9p7RCXP8tgB8nva9zxv8eTBGBbbRU
         CKwSCExawlbvfsyvVwk0tCluz8pvu5dbXsBERhnl0QjiXxcNYQp/cZvThzFqM78ACl20
         Tq0JR9FjmqV6JllGQGH/03q5sIWjK4Hogztoef62jB1PePMz4Wcddu7aN8k/NsSual4K
         L8GRcdakBRttUONt9t64NfcPZpaM0lBKZ5qfObmbErb6bqsw8XGk10+yj1Y1utpXnin3
         z9aQ==
X-Gm-Message-State: AC+VfDzcenRTbxd4s4L38g3dLCdLmXE31I0WjZdwmuAS43FkT8wy7giM
	szdRPkn0kgfXOQCse63NV0tF/g==
X-Google-Smtp-Source: ACHHUZ7ICV0+J7+a5LSH67kSoE3rDJzDTt4KW/USTzZKC3F0s5HN/hqcP8mdiYd+82J4lI6xoaoPbA==
X-Received: by 2002:a05:6e02:144:b0:32b:51df:26a0 with SMTP id j4-20020a056e02014400b0032b51df26a0mr5650839ilr.2.1686608233372;
        Mon, 12 Jun 2023 15:17:13 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o14-20020a92d38e000000b00331a5fcd648sm3477499ilo.68.2023.06.12.15.17.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 15:17:13 -0700 (PDT)
Message-ID: <7a9f55bf-8fb8-d953-42ee-fdf49171cef6@linuxfoundation.org>
Date: Mon, 12 Jun 2023 16:17:12 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.10 00/68] 5.10.184-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230612101658.437327280@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/23 04:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.184 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.184-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

