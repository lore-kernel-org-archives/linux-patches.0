Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C9F17E2
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 02:50:09 +0000 (UTC)
Received: by mail-il1-f172.google.com with SMTP id s16so5975815iln.4
        for <patches@lists.linux.dev>; Mon, 05 Dec 2022 18:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iMpQTicsa0g7Lorw1se6GC+CBOwJ0Tti83kJiz0vrKE=;
        b=YPKqCzIbxCFpuPZIpFucvbbIeZF4SOCGRnDny64EdVfi0aCWUHbSJjd3TJcsqEAdVD
         KtrjLhB0WdRwmQCCdKC7UIo5gpYLWppg3tedZons8ioe5kZteFjX6++HlPSx9c41vCvy
         SitQkL0BnF/2oHU5emrYAGEKywWtyGvw7+vQs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iMpQTicsa0g7Lorw1se6GC+CBOwJ0Tti83kJiz0vrKE=;
        b=hD12z3InqW9FNnTHugt/6PX64xpUDRTGb4C3zhDAQVTizrHhALaUOM+RlkwoJSAE4l
         gScT6RvV9mTcXO9I7jFyaR0sbGof1Zsu42JmHwC3ig0nh9VsZMvMEE0ppwPtqt7IDv5V
         3SUUSz+Xw+mjHngVJLJW/nBTcjLlpP1gAiWZRQAIiIqFvqXyoOLoDYMI3Rhny10YOUp8
         cDDAgfxIf6CZdfl56/T4FZKbvkoROUu7YOmm1fSNthZzV2mOA9ki1YvMMkfKBKtsx5cQ
         jEYohzTHSzX+W9uT8VmZgJLw/Z/3m1d3UiJ5ldrUB9HjD+i+/VcqYkG+42nmzLtJBMCM
         YTOQ==
X-Gm-Message-State: ANoB5pnpl6Jsc9/LcW5QSJsXUI0jEhzbi3WhG7bUdFZNsVpxSoSlMESo
	Ku7oAkXalAU4hlWwE2bs9gMMrBkOSfKKMyWF
X-Google-Smtp-Source: AA0mqf5GTKuO1UebtKV9X7SdykSWAk5ixXoxIk1I1sErvsM5Y2dukjprFEURzAz4510Rf8F1F6tECQ==
X-Received: by 2002:a05:6e02:1d17:b0:302:9392:5a01 with SMTP id i23-20020a056e021d1700b0030293925a01mr30649901ila.268.1670295008485;
        Mon, 05 Dec 2022 18:50:08 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id 125-20020a020a83000000b00372e2c4232asm6195306jaw.121.2022.12.05.18.50.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 18:50:08 -0800 (PST)
Message-ID: <59828df6-dbf4-4bd5-b165-38ceb449dab5@linuxfoundation.org>
Date: Mon, 5 Dec 2022 19:50:07 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.19 000/105] 4.19.268-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/22 12:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.268 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.268-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
