Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFEADDA7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 21:29:17 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-76c50ad63f1so5528439f.1
        for <patches@lists.linux.dev>; Mon, 08 May 2023 14:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1683581356; x=1686173356;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H7j3j99LnhayE2tjFufPEFdNc8DYyO9ySk1bd20eGs4=;
        b=EcmO0t+AT4stpwhfKSGaH5aY1gmlk67L/84AUvUBymhE3/i1mqew+1VU3PhmUHEdOl
         P66vitqhRWIbVQl9Mn6FLhaJAQ/oK5rO+AbM0LExBdAtQeOvX1oNEre1YMa1Zai4Fvrc
         aJpqHV4yF7LphbeEyra52n0ugfrEoqukkSljE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683581356; x=1686173356;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H7j3j99LnhayE2tjFufPEFdNc8DYyO9ySk1bd20eGs4=;
        b=kh/TaGdsBuxLFSgMsEYq2OagmyDSWCfVTccpIRM6/S7fMgrjPf/C/E2ySJpsVYcdlO
         c1Ykq+2je1nkpjpuTgDpOnzyK3Pc7WoQm0xQh5NHPWnc0dWkbsE0btogsJjo0Z/dKsxy
         vos0KPHjkwnkXUPb/2OOV4wD8n0cvMwVpXyHkAT9ESkSpjxbTg8AImjJmcg7sMv5rbZN
         7XJX1kzhMtwwqie/hYhp31ZSYM36b8PG1fuPCCcWLhGeJcVPm09tIHWnZb9YeLx0+iMX
         n4kyi30Virco75Kfb511tUT0MQ0UwSQmdRRjMDWRU7J7IPiAEKPJZtAjqqLQ6/FSWfhi
         ipUQ==
X-Gm-Message-State: AC+VfDzmCTAxuvjQb1Ln4YomA+ldT0DdwXAqD+WD71otFrV7FFteM3EL
	mofNvSfXXeOo4FL2g2I0df/MIQ==
X-Google-Smtp-Source: ACHHUZ5pnEXjGo7+oJPYrQgNCtPh8fY5eYaY6ozuV9aPsNmizygrFjxKt7uk9B/IaoWJOOQxIg3+lA==
X-Received: by 2002:a05:6e02:cc4:b0:32f:1232:f5d5 with SMTP id c4-20020a056e020cc400b0032f1232f5d5mr4885399ilj.2.1683581356456;
        Mon, 08 May 2023 14:29:16 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id 18-20020a92c652000000b00335717785ecsm393780ill.63.2023.05.08.14.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 14:29:16 -0700 (PDT)
Message-ID: <bb06bab8-d906-108c-c829-cec82bd5d35c@linuxfoundation.org>
Date: Mon, 8 May 2023 15:29:15 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.1 000/611] 6.1.28-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/23 03:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.28 release.
> There are 611 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 May 2023 09:42:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.28-rc1.gz
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
