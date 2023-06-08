Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E8DA42
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 01:22:09 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-777abee746cso91239f.0
        for <patches@lists.linux.dev>; Wed, 07 Jun 2023 18:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1686187328; x=1688779328;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=96LPYa4rPY61ZT0Qle5XVCxhRcsZk/6e//tpKYlqeX8=;
        b=ak0C9ZSNtWRAsQH9s15NmoYCsH3cCKTQQW+lUdAJgJU0HqfQfolHg7/BFoFYM1ri6r
         99G/x8HuHeNTpgDcBcCT6ZOOJsn6398hq6BMCBvalDQNySQbCqzu344jIDdgGi+92SZS
         yt54g8852HPYcIuU03+qSyC21Od/RAq0VVSMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686187328; x=1688779328;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=96LPYa4rPY61ZT0Qle5XVCxhRcsZk/6e//tpKYlqeX8=;
        b=jKZe527vkYLjdWM+lkQw7SkCZIf/FIbD8bnAAFVR0kRb2h1ZZNKx67tVKfjCgFk2aR
         kwAHBHc2k/P2IPA89+rMyZFwsBT3srKazwWnwVgcweRB7SntS1FZb3nvr7SyiFXgcLLa
         LSULNMCv3/ruidBXhTFe+hcaMATcnTi/3EcxhcEs0czKcS3fICyZczIhjQPRAmNJ51sN
         dPftS494FA9AFRPuRF5q7cs9tSGhPT8RMQSisBYoS3Occ60f0F3sFX0X7R+wzvtNkddK
         iELlF+ivdlUStOCYU1dxRK2XuHfy5aas9NuTiaJBaFEkxvcLM0hv3ZekkVVuXGd3SkHW
         E5Qw==
X-Gm-Message-State: AC+VfDwdv+TX12S6EZxZ+dua7yhO8qhgGG9HGzKkB1sHGR4TcC0VG3Ys
	7n3kDUCMcubFScA/0huncnXv75FewnerFu0ek68=
X-Google-Smtp-Source: ACHHUZ5O8eRRXv1pKn7duaMD+ut6V7e8TcsdzBtuZtExJKd0hsR1DkMzLOvbfhjpeqMqJir8cigMog==
X-Received: by 2002:a05:6e02:1281:b0:33b:3a14:c14c with SMTP id y1-20020a056e02128100b0033b3a14c14cmr1926474ilq.3.1686187328555;
        Wed, 07 Jun 2023 18:22:08 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id w16-20020a029690000000b0040b1ecc3ec4sm643834jai.11.2023.06.07.18.22.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 18:22:08 -0700 (PDT)
Message-ID: <204fea70-1021-f6d8-4fee-589f85533bdf@linuxfoundation.org>
Date: Wed, 7 Jun 2023 19:22:07 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.1 000/225] 6.1.33-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/23 14:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.33 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.33-rc1.gz
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
