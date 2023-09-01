Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9A323BC
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 15:57:26 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-760dff4b701so19385339f.0
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 08:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1693583846; x=1694188646; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hOp+ssdwZ/xOnIkHfRtIS6twREd4m/QNPQ7G44ZlNUE=;
        b=P45Q0ws8LH0HycxbgVnIvfHW9hKgC2T08xXynLsPm3LYQEDmjFsCkQgqKpfLf1sBtO
         CPGNEuwzudwo08OvdnCdxS+sgRgYBekn6O6r0pPKB/oivJIxzVi5DcieTkhPJY+mpVoC
         yCvThMMQgOXOgZBl4IC/qwcmItLYtt/5y5wfo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693583846; x=1694188646;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hOp+ssdwZ/xOnIkHfRtIS6twREd4m/QNPQ7G44ZlNUE=;
        b=RY02iSUL0jstrkcmyxg2+0AfsOe4qpF3QSh7omjpAYSxPuTmOkjdte7dbypGMU3La3
         Vdnd2Ivkvp2qrzDZt03qECEc8vN8koZE8g6mXJpdV3jazYhIfcaWaBBkGgjsgcOUvfkI
         HAb0yUZ1fihMwwB8rFVhZ8DRhKtiu5O5vQy3e9+FNGntGqpLa1UL+5c7EJ/h9uKWfD8i
         t/CUVUV/FYo/O/cOXEBEneRAkTwVMfaqOB3UB8hkE89MBoqSPLBbQ7//vdWqRrof++EA
         ASowvHDRVq0moy38hBdhF2c2madBpXg6acwoJsOAi4I5M5j/2CMJgCHOoCJAI0+KBhum
         cRdg==
X-Gm-Message-State: AOJu0YzlYLrfatNB6fa0rU83W3xBOUAVZH7t3Ob9Z/ET6puq/a2ETNUc
	zpyWNunfF1FKHMaahIlj88YvwQ==
X-Google-Smtp-Source: AGHT+IHTa0lwsPdXjEpij8SAYIZZAr2aEeR5h/sXDMXJWU2TlwSmPVMkbRDd5kW55hisyEzDnIAx7Q==
X-Received: by 2002:a05:6602:73a:b0:794:da1e:b249 with SMTP id g26-20020a056602073a00b00794da1eb249mr2697575iox.1.1693583846073;
        Fri, 01 Sep 2023 08:57:26 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n7-20020a6b7207000000b0077e3acd5ea1sm1140014ioc.53.2023.09.01.08.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Sep 2023 08:57:25 -0700 (PDT)
Message-ID: <ff0684cc-30d4-47a4-2a9e-684835e834fe@linuxfoundation.org>
Date: Fri, 1 Sep 2023 09:57:24 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.4 0/3] 5.4.256-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230831110828.874071888@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230831110828.874071888@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/23 05:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.256 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.256-rc1.gz
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
