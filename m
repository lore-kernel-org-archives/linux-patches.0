Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02D71105
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 03:27:14 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id r130so16313205oih.2
        for <patches@lists.linux.dev>; Wed, 28 Dec 2022 19:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ume60yuS4x+mE+BLhmcB1fRz1PiHMSqP5MxjdySEIJo=;
        b=Qsxuq2GoXCMpJrHvOFEeW67cYFWD4hm0rATXL1WzQ2zZSm4OCRcLqpnx0OMkf7GTu0
         bAW7RKOd67aY0K3osSexeAVlF9ygVFwvl4hPuOoGFCgpRCYFTTPH6q2f7Fi0pvNdWyW0
         mVFbarT0PQxaaqr3Ls6rpnR+A3PTR1RJdl7KZeXFNIJIb9cQ3dbkRCpkJK9g/pSY+XGc
         6B4dTCrq9SMLDdHs38DX6428gyW8EQKEcnwMJFqnQ56q/s401wiYtRG1bmqfOgM/VC2B
         3CHa16nrcInu4Wsesq2WqHIf9nH/Xs1p4EnUsKFSxu5v3AdV5/AaACxKDQmgkX+SN/hX
         Te1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ume60yuS4x+mE+BLhmcB1fRz1PiHMSqP5MxjdySEIJo=;
        b=A2fjBhMSsPGsp8dzqtGAdoojos01QXuBYcjYKWQavDk0jTYLcXmS/7CUJOuaxOfflO
         2/uVHewRIf7uOGED9Mb2Ap4T4BMtnx3xedIgw4LzfXPAcyIXj/Ve1lHhoZAYeMgiagod
         yCdxhTwQNVOtcqz20POqkMs4LqNNurjg4MoYzoH0ZsBrw1v5SY9GckgoTHz1fINX0B4O
         EdKPrhpTyWNZGoDziF41SgYB3grohhmVb5+zFzVA0SqavkomEPVEhS3cfVLabkuOQJGl
         udT9JQb3+HsBlyrCeMeh2Z128FlcfL8xdzDaVaD1qzjDgTKRGiI+1pTlBuNVjZTePiuh
         pcJw==
X-Gm-Message-State: AFqh2koUj0y3YweKKVq4mxb9Feug6FPCPytbRuZz3eXtQNxpm/FHhItr
	4HHMRH+XDzKJ2j0RDg7LQVYLpg==
X-Google-Smtp-Source: AMrXdXuCg8kFNsWR5lvVSgV6as5oJfuYPEbVQyU9jccM+jUhvdTCNej0glEW88K5/gnhQBW1YvDVyQ==
X-Received: by 2002:a05:6808:1993:b0:35e:9090:2969 with SMTP id bj19-20020a056808199300b0035e90902969mr15074149oib.13.1672284433908;
        Wed, 28 Dec 2022 19:27:13 -0800 (PST)
Received: from [192.168.17.16] ([189.219.72.83])
        by smtp.gmail.com with ESMTPSA id z10-20020a9d62ca000000b00660e833baddsm8630907otk.29.2022.12.28.19.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 19:27:13 -0800 (PST)
Message-ID: <c3c2ef47-b46d-b446-5475-366867954528@linaro.org>
Date: Wed, 28 Dec 2022 21:27:11 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 6.0 0000/1073] 6.0.16-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20221228144328.162723588@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!


On 28/12/22 08:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1073 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We're seeing the following problems, as with 6.1, with GCC-8 on allmodconfig on the following architectures: Arm64 [2], Arm [1][2], i386 [1], mips [1], parisc [1], sh [1]. With GCC-12 on allmodconfig: arm64 [2], arm [2].

[1] Problem on 32-bits:
| /builds/linux/drivers/pwm/pwm-tegra.c: In function 'tegra_pwm_config':
| /builds/linux/drivers/pwm/pwm-tegra.c:148:53: error: result of '1000000000 << 8' requires 39 bits to represent, but 'long int' only has 32 bits [-Werror=shift-overflow=]
|    required_clk_rate = DIV_ROUND_UP_ULL(NSEC_PER_SEC << PWM_DUTY_WIDTH,
|                                                      ^~
| /builds/linux/include/linux/math.h:40:32: note: in definition of macro 'DIV_ROUND_DOWN_ULL'
|   ({ unsigned long long _tmp = (ll); do_div(_tmp, d); _tmp; })
|                                 ^~
| /builds/linux/drivers/pwm/pwm-tegra.c:148:23: note: in expansion of macro 'DIV_ROUND_UP_ULL'
|    required_clk_rate = DIV_ROUND_UP_ULL(NSEC_PER_SEC << PWM_DUTY_WIDTH,
|                        ^~~~~~~~~~~~~~~~
| cc1: all warnings being treated as errors

And [2] problem with qcom_rpm:

| /builds/linux/drivers/mfd/qcom_rpm.c: In function 'qcom_rpm_remove':
| /builds/linux/drivers/mfd/qcom_rpm.c:680:19: error: unused variable 'rpm' [-Werror=unused-variable]
|   struct qcom_rpm *rpm = dev_get_drvdata(&pdev->dev);
|                    ^~~

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

