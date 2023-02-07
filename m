Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802D28BF1
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 21:24:28 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id z2so6623215ilq.2
        for <patches@lists.linux.dev>; Tue, 07 Feb 2023 13:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CwNrp0wPjawkXQ4pgo3vF34Zz65SWl2SKe6RPVCwp40=;
        b=JnfWNI9WF1Og9HwYdC10DMIJ/Ubmxm8HFyfL9slftQIAv4nGypDARzTTUqvwkXYu6w
         W1DSBjnMSDr/ZIKXhvY1iLX50rH7rxP02a+Jq6vEfKJnlrguwmyjgTLPm7iqHpBJR2Gb
         KjGIZfUzn5KUC2cWDU2DVP5/FNaa31RJIH2aM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CwNrp0wPjawkXQ4pgo3vF34Zz65SWl2SKe6RPVCwp40=;
        b=JU6E7SbIUEFRuntnWgWGYnmYSDpBRSe5/V6XpOtsV2Y5vrkqAyRBMoP00UF6XOZiXC
         3IQDEKYa6kikIhJ/K4ZO3+s5yYwSYbsceVRFfHJzjGFSiSFwR7HcEz/EHFJv5rKGni80
         j/V8IWftxfuyHGsZQGDJbXo5OYSSpK1/vuLvrOrb6s+zIOgj4f/WJPnWfTtEo1DIKoYu
         Qnkt0NPBgJzkG6n/dqNNaMXnXhaWqlBQuOp1aJQVbTtyzDnA6lpDb0TL/VrXBIwaf7Zi
         82WGMVFS6ZB/QEtgfKfgfKP5X0a8YatmR+6AnR0FJZ18vXcLlQBNOhOHHhAMkLrSMiF+
         PFsw==
X-Gm-Message-State: AO0yUKUb7yuuB4LbblX4iq4BBBCRgxgVXN1XgaYKuP/5/PSmLlpYkaiN
	Vayf5GQHZ/G1qNYImjv0LFf7Lg==
X-Google-Smtp-Source: AK7set+kLYg29Y8Ds31MGdldXvAFpoUCi1y5hm7b3AqFWhM1L9Q/UeH2A1i6HoKOTpUCJIEDG0lHWA==
X-Received: by 2002:a05:6e02:216e:b0:310:cc70:a152 with SMTP id s14-20020a056e02216e00b00310cc70a152mr4700440ilv.2.1675805067511;
        Tue, 07 Feb 2023 13:24:27 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n4-20020a92d9c4000000b00310a40e669esm1715750ilq.11.2023.02.07.13.24.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 13:24:26 -0800 (PST)
Message-ID: <1b7d164f-8e91-c178-9d83-98ef1987b3c9@linuxfoundation.org>
Date: Tue, 7 Feb 2023 14:24:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 000/120] 5.15.93-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/7/23 05:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.93 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.93-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
