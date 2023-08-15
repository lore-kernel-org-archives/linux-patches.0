Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D81625
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 00:48:03 +0000 (UTC)
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-77dcff76e35so51785739f.1
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 17:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1692060482; x=1692665282;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ukogAUa4ocH8ByC+yfaWUlJyirwsSGA/r/2pc70jO2g=;
        b=HB4+b+sHrTF6qOQjgz0IL9t5QHSzfIk4wpavGIC8e/vJ9aAwxBosFQxh8cDyO8yl9c
         fCgfE4NCWOMAA5I4KUaEMsap6XfUswIyZV+urtLoiq30nYKlmvM9plHLTRnfMBWBdvk0
         jkmqZ4ixVPzn1Xm+kylG9lxk4Mr55F4dwZY/c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692060482; x=1692665282;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ukogAUa4ocH8ByC+yfaWUlJyirwsSGA/r/2pc70jO2g=;
        b=IkVaEH9JFo3K1WwaeyktxpBRIchtu9WMUYsmIDBY7bgVEXrIqIs/VjyYxG8KfRj3KX
         pl1EM8OYGIqXXrmdq8o+d2mcFPUxTwmXK/3zVV9I1I/zJrA+OUQvJVnbGrAm+9mteyGc
         c9SDbz7wA8r7jxc7i/8ONy9zQWigJSmYboEyqcfhD78waQazjsIoVQabIJiIi67YSjHm
         qzF0vhkLdAEW1PVWR5QUQg6dA/Sj2YFTEB4rcaZq016tK/GkC98+Xf0f3Io7cC8jhMyt
         WFmG1hdhlMd2Z5o05xFH3Y0bUmXBu6cZRk0IW5yyLwBxnFCTCTJbCl3SsywnOtZ7LUVZ
         KNvA==
X-Gm-Message-State: AOJu0YxF8GdVKHSSNg1RI+YtupDmGLobzjIWKHEWnOgK2OF1OLptAvXf
	mnnebJgus/kRRWGQTl7ZCYCipw==
X-Google-Smtp-Source: AGHT+IElHmrz0ZozMelXl4KgM3inJg7xAE16vvhdPbsnqAtkfank5asX6xxKIeVMbsEyihL/tfpujg==
X-Received: by 2002:a05:6602:3a13:b0:783:63e8:3bfc with SMTP id by19-20020a0566023a1300b0078363e83bfcmr14241537iob.0.1692060482678;
        Mon, 14 Aug 2023 17:48:02 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id em6-20020a0566384da600b0042b0a6d899fsm3363834jab.60.2023.08.14.17.48.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 17:48:02 -0700 (PDT)
Message-ID: <a2b84aa7-dc02-dd98-9a27-e9969c8f1824@linuxfoundation.org>
Date: Mon, 14 Aug 2023 18:48:01 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.1 000/149] 6.1.46-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/23 15:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.46 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.46-rc1.gz
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
