Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8E36ABC
	for <patches@lists.linux.dev>; Thu, 15 Dec 2022 23:45:26 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id h6so477930iof.9
        for <patches@lists.linux.dev>; Thu, 15 Dec 2022 15:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/CC64YfJSCYg/K7qmsImuayWPAKP7dBE78VMBC6wzX4=;
        b=Vm9qo1fTOm9PS/Ef1xv8f0hcXZE/fHPnWP9c3yXChNUfmpjXCFZuflNYbNW9LEBObP
         YHxqjy+DUJikhy/YyxEuaTpFlnsgNuUOXR1DWBf0UBvMBoNsBLT025ENvKyKrEN/fotn
         sUlm393euqw1MK2AqHTfc/wJTz0I2HtNjmZgA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/CC64YfJSCYg/K7qmsImuayWPAKP7dBE78VMBC6wzX4=;
        b=k40gQHH4ceoOziw28lcCkOYpg3umV7/PV79CpdNy6V8+VI9J7W4HsIu7jyn8tV1pD/
         rvbN7e7ez6zUHeHduPUfZdO4qmezgV6Yldyie47AxDvgVfTpFPqHnhZpbtbN5FEWzsjP
         k/FK81xyjnSnS9HwB/geBbFqR2IfCx7yS1/IUFy02V7lPldCMkt2kbK3o1O2brbr57lW
         cs39j1BvsAN83r7YC7nZ7WyKz8j520QXmPsSbX6+f0ZB5Kho8TrafKx6MpJY1RMr5lfA
         uazJZ2BooNWIMzdiFMZTDNQW88NCZ5rqd5SqoT8xCavnU2EYgn59UUklWN56mRHbOh5f
         7/sw==
X-Gm-Message-State: ANoB5pkWwFJ3niRcnUG01PLf++Ap0hH4OCLRsUotLlAdjg+yUD547NAn
	JHjAn99rSjpWRo8I0M0ZMl5MRw==
X-Google-Smtp-Source: AA0mqf5dtrTlZf5vEfd8yJ8MW3l1j7t1YAW11Rs/G9Fv5y9lVHj2cVPukHtqRBxuaiBj23N74DBQDQ==
X-Received: by 2002:a5d:8b06:0:b0:6df:b991:c03e with SMTP id k6-20020a5d8b06000000b006dfb991c03emr3045706ion.1.1671147925872;
        Thu, 15 Dec 2022 15:45:25 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id z21-20020a05663822b500b00386dde027e7sm220197jas.73.2022.12.15.15.45.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 15:45:24 -0800 (PST)
Message-ID: <3e3a6157-ddca-a705-351e-a2514f5af29e@linuxfoundation.org>
Date: Thu, 15 Dec 2022 16:45:23 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 00/16] 6.0.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221215172908.162858817@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/15/22 11:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.14 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
