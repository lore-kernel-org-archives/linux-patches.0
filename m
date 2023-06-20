Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061162AB2F
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 21:06:27 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-77dcff76e35so63311639f.1
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 14:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1687295187; x=1689887187;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/7FX3ei7WxljWiN/f0vRH44gl13P4MQNxcfvKkmN450=;
        b=hl+HSCKh1jjpj7EVjSOdcH3FNkKmXDISO0FSTWbCfn4dpCn6jnkbHh//C2uON2Et5D
         bPxxfDz+QhWnCzonzREEGrUcI0MQG/k7AvYIhIeEfxy0JMZ+SAucDo0v2uaoJfwaNlif
         F3nj8ixRR5xYdwLITnF0ubkugPDIVaAZ+RUD0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687295187; x=1689887187;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/7FX3ei7WxljWiN/f0vRH44gl13P4MQNxcfvKkmN450=;
        b=dlQTcSdgseif7BiC8BZ/gqfhrVmtwpi1LI6/uar6o2pZBRt7ldtjDZyaJd6cFQeX4m
         4q1oQ/4snlVy0ffz5Kq1c42brMH2eov11EMBccQSKnZ4uO2NENHU8EXaK4iWctGiBZsK
         VWz6JJ8twwjV9VtW34Zbe+mxGibSfzBkReT5s0jRzQT8akCR7xFioUQKeVB34sZTMLzQ
         4eF71Piagwx7rSwe4A/ZyboObrNz5/On5bc2YnW3XNuG8RuqfuQuRVB5kemS5cg+Efwg
         LMSINiFJoXZEvzsWdP1gmFHaRJGiCt9OQbgngtQoqE/Uo8ARLMCOe2RQCM62iaoBI1wL
         vlfw==
X-Gm-Message-State: AC+VfDxzALcphsm8RLqZRfaF9YByKiPsBjOpWRMD2+SfpV0BsClhCku/
	9G4R7i+qZGRNYaxpI0P/5CcJeQ==
X-Google-Smtp-Source: ACHHUZ5ub/upUVXfagLIdSXqCeAq1WjOIQyGj28Ycc/XO8AfL1PFN4uT/IAL+nW4ERq301c21CELVA==
X-Received: by 2002:a05:6e02:ee6:b0:343:ce12:d51 with SMTP id j6-20020a056e020ee600b00343ce120d51mr1182393ilk.2.1687295186938;
        Tue, 20 Jun 2023 14:06:26 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k24-20020a02cb58000000b0041ab9b6f5b0sm880647jap.128.2023.06.20.14.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 14:06:26 -0700 (PDT)
Message-ID: <ccc8f0d2-d397-21b1-80bc-fe1002f7179c@linuxfoundation.org>
Date: Tue, 20 Jun 2023 15:06:25 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.4 00/64] 5.4.248-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230619102132.808972458@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230619102132.808972458@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/19/23 04:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.248 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.248-rc1.gz
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
