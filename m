Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2956041A87
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 21:37:33 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-79d27df62f1so4734039f.0
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 14:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1695245852; x=1695850652; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dTMZOz7zfHEZnxo271y0b24B0nwEkFYYZgLSU5ara0Y=;
        b=MtRQ4V4EwDkrDk0Tc68KRxkyXNcNPYduJl0avsssDVyy/qrcln+v6YmhR9yd+Httil
         HQmonm1PfVsniCb12QLFn2tM4HtR6EK6FSOhwCien1HBwR890XKPfmTFpfzNJW+Lr6KN
         ZUsuBhiAEkON0YKPrPgQt8XOCl9NPXvwYEfZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695245852; x=1695850652;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dTMZOz7zfHEZnxo271y0b24B0nwEkFYYZgLSU5ara0Y=;
        b=oqPYpistjRLPprmj8gzkUSkOcbLUFPlBjE4+Gtr/G+Ge/CZrbuuj6URyQ7RBY3lTF4
         tf0Rp5poFMi5s0f/pBTw+0mnIqgguJqg6InySmkGCVEwp9+YjnmW62RIuEAhdiVRt7tw
         HqeCT2vZsPHMmrfYdGeHQm6bZ8xXtORk+vWNb/qIOUjlCTnUU6ZnGVQE2VjCDIAgbaVX
         2yvN+r7uvhFcDO5RYJN/pwPQfPtCVrrMSCLE8faJQaJvWeV+hcuowgj8apcA0cbNDcHT
         2jyAqb4BKY1vTr5X4pHM8A/Aqj9cb3pa9al+LsfTwo2zHLoetK3oM+Hc/7S6N/CIN7oT
         ndgQ==
X-Gm-Message-State: AOJu0Yy6FLoFn6GFDtHoAyB779/LL2z9wjMptagFZ1q4cK2+qtDYBVGb
	LOQQdh0BbqAk7QwLFdWrVcW8nfBplX0DLZY6yvU=
X-Google-Smtp-Source: AGHT+IG+gK+YYQCk4IAiV2PPKsJx5uyC6ZxdPHbNqGW18/9b8GKsVSaBcs6rXtre0KtZ7uGd7+FmAg==
X-Received: by 2002:a05:6602:121a:b0:795:172f:977a with SMTP id y26-20020a056602121a00b00795172f977amr4007024iot.1.1695245852407;
        Wed, 20 Sep 2023 14:37:32 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id f5-20020a02b785000000b0042b2f0b77aasm4203305jam.95.2023.09.20.14.37.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 14:37:32 -0700 (PDT)
Message-ID: <96958c2b-bc0d-72b5-fcee-51d86bb5f7de@linuxfoundation.org>
Date: Wed, 20 Sep 2023 15:37:31 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5.4 000/367] 5.4.257-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/23 05:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.257 release.
> There are 367 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.257-rc1.gz
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
