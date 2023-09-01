Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DF0BE5A
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 15:30:14 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-790b9d7d643so28063839f.1
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 08:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1693582214; x=1694187014; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AiNqQgFbnxq6FrJH09GmzjeX1g4Nw3Ac0YdAkmhUigU=;
        b=YM9U0UQxvtSyK7WOnSKYYH9MZUW98G+E4c8vCLqZDlkONbIYfwQgLiogn0mpcxV9sV
         jFN0ZaiJBZ+uO1MVlJ12nYu5+8qaY05BJwumfG8vHR9GCkADq3V5VdESyvORaJbrBwDg
         oUFCK0/YTcC/DaYh7blyWvyhw5QyeENUvf/Dg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693582214; x=1694187014;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AiNqQgFbnxq6FrJH09GmzjeX1g4Nw3Ac0YdAkmhUigU=;
        b=fO6lpOqpIRacChgAovpzfwpiA0O/upYDrjfCvXB8Rpb1WggeS1uDgLCl+U99iUyNH/
         zsu4doFM0JSB9XTXlELWc9JvT6r/LCSoj6I+7NvycoFn3Ux3Y8M2SpVkLj724kbMILJ5
         TusWyeGDGa4+jdBDh+HhFKTi0xaVDpgtZKx9ejYoGUN/oXN4ws2Ta45lb86o4LwY/xlh
         tV5EotFCo/jjEjY8JiRhzPpcdNex787vquBNA1SiQIblet0H6utsvvgXV7uMsiiqoXE9
         WGjtI6ZniHGcG7Wuuav5Y+yhSzEyw/J0bw5C3VddI7yJx/LL9jxNm2muA1HB3Ct4sDCy
         L7Mg==
X-Gm-Message-State: AOJu0YxmvZONukbDynj56/iaCziu6lH0RScNo6MQty4ZGlehIAuhyWgE
	mFZJJBRGW1lSwJvZcjeRYIBAxg==
X-Google-Smtp-Source: AGHT+IG9M+xHgmCy5lDFf7tZbtMhIWUBTnKbt8HK9BHpFZRD0iyJvCFw9WD9Z63nDpdojJjkC/C8jA==
X-Received: by 2002:a05:6602:4192:b0:792:8011:22f with SMTP id bx18-20020a056602419200b007928011022fmr2525210iob.0.1693582213821;
        Fri, 01 Sep 2023 08:30:13 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s10-20020a02cf2a000000b0042b320c13aasm1123350jar.89.2023.09.01.08.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Sep 2023 08:30:13 -0700 (PDT)
Message-ID: <afedcfbd-1f77-230d-27c1-8019e658efa2@linuxfoundation.org>
Date: Fri, 1 Sep 2023 09:30:12 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.1 00/10] 6.1.51-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230831110831.079963475@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230831110831.079963475@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/23 05:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.51 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.51-rc1.gz
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
