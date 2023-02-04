Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D9C10FF
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 01:01:49 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id q6so2605878ior.12
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 17:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Unz/hG5qpcSSbqIkSS3L9D824uEz62egmtqDeyQEHU=;
        b=RUfQIoPVMxhRIHryrxTInN6p/hOCXLZioYHxIcIcuMh0NkHx/2F70rPiiWBydebK8A
         ESQ6GURtQYenSyox8XDUmHfb7KCvtE5Lnc6Jw2N5Rbk+45m/lEwDFB6iOrhViYUejPAr
         CRcXRlHNMJtCw48NRA6zT5wpM4ORq6uPPpKfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Unz/hG5qpcSSbqIkSS3L9D824uEz62egmtqDeyQEHU=;
        b=aiEhxprUYttABxbygcZvfJAotFHIcPC3N8xzWOHDo7wt3300HL66jsQYVmI50G0NlG
         LEWnr0u/JUOgk6Ux9BRZ6ZIJcJGG78OG4YOQcmMkDZMSYjZRad2ZfUCyB8nqH9QPFKBe
         n/FWtss1j3rGf+MyDRxhjAhhao+eBh6Nbnt8vI+VejYUbUiB54RosqyMTzx3qWDj1Ufc
         2mCE8zDxaSdefwZeblqlt75LMSxbG8jsx/XCjL3lc3/dC01CaiGhxs+bD5NwaGV4Auwz
         AKUcceNmP3logfpEEFN9xtp6ZPCaMLB7QhmDv55N24R5Jnjt9hSrLi8IyUNS9Xvlkxkf
         Q6uw==
X-Gm-Message-State: AO0yUKUP5zUBjidSv3/OvJLvE/Fw2s/6ucZBrUUIHvElCE/bgDkf9A2d
	LV5ui3psDYgvhRNpUJwm/6HqdQ==
X-Google-Smtp-Source: AK7set8v3UKWKGyOPPYfH/GAscwCg9dIrW5FwRvuoG9gq36Mt9idw3RP6zBX/wREbmFMgB72uJzEIA==
X-Received: by 2002:a5d:954b:0:b0:70a:9fce:853c with SMTP id a11-20020a5d954b000000b0070a9fce853cmr6834281ios.2.1675472508197;
        Fri, 03 Feb 2023 17:01:48 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s22-20020a02c516000000b00389d02a032dsm1301499jam.172.2023.02.03.17.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 17:01:47 -0800 (PST)
Message-ID: <6e33743e-50c0-f6c0-42e8-e07cd7cfdd5f@linuxfoundation.org>
Date: Fri, 3 Feb 2023 18:01:46 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/23 03:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.231 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.231-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

