Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00038F47
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 18:27:13 +0000 (UTC)
Received: by mail-qv1-f42.google.com with SMTP id o17so18006364qvn.4
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 10:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DPjL2DQSLlszqw4OiVvbsdD+JxAFXBGfR8THZOT0Qic=;
        b=nRUxmkVmBZP9/mQBq8rGwpgfeNsx/BibdY+eDd+QVg8C87tH24tMxOgIM4YK1UvVoq
         hFMe9m75SK5LJIxUJn/JgbRt41A0mBBUBrfqOZMsoOYvXlJBSQbzypPHJpWT7lNmiYyp
         VTzHuTN8R/ZEX1Ih1ImwJ0JkP1ERvWO/20NyHpGA7oMPkplybv6gNpCYzhVybiLcXp16
         gU1MZYK5w3vyW1uusn/boLxuq4zcHL1J4H9ZQdsMstiryZSwwvqPxJ/MH6iLp4bk5fCh
         1bld3qNaXhrjT757mim6vtiuWGOmM4fUNExOjzuAAoDhsJ+tL+ol6iYQC8vinz7hXxM7
         jk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DPjL2DQSLlszqw4OiVvbsdD+JxAFXBGfR8THZOT0Qic=;
        b=QJyDx81l64iOHnbuMCf57WD3Q6YjIlHfdJHp5TsIIxvUjRo5sdUgbbZCAbyNPezEdP
         xlsXyK9zJGfNuvne938keqqaNoJb5DpQ5GLRHJLSEQowNoQOkpn+BmAXtpC8BIIe32rg
         Ne1TwMHMKX2Z+CPPwxjzyaaq4bVtiesbzQFrD2LPhuLD+5E9H5bJliDUjZ2IaGkr1+WI
         fsYve1WdSJdlZ0Z+LpfL9i5YVEiKiYH+kGPMZY5qQtE2SSGnIXjgSO8/sl/TF6mWJACP
         Q39KbkLAf/PYgHkNzf4wDlwIDWQglLx43RBuBF4NJ8Y2vyq+xxCkOMlgbAEK7exW/yZj
         oBew==
X-Gm-Message-State: AFqh2koKrdxU8/7/lgctmwJ8QkbfpaMbAZxeWi/4UqXciyjOwRS9UwyD
	ucjnxZSruObblkxkhy/O5gk=
X-Google-Smtp-Source: AMrXdXszGK+QQ4gGy4N/pb22uhf2admBnpdD3b4j7xxC/55IaUnuPnAYy0JxYU//O3wCC+z9YYuAjA==
X-Received: by 2002:a05:6214:390a:b0:4bc:176f:a50d with SMTP id nh10-20020a056214390a00b004bc176fa50dmr66266818qvb.3.1672770432433;
        Tue, 03 Jan 2023 10:27:12 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pj8-20020a05620a1d8800b006cfc7f9eea0sm22142411qkn.122.2023.01.03.10.27.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 10:27:11 -0800 (PST)
Message-ID: <581e7c54-d10a-23d6-96ca-f6ec6a4326e3@gmail.com>
Date: Tue, 3 Jan 2023 10:27:08 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/63] 5.10.162-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230103081308.548338576@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/3/23 00:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.162 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Jan 2023 08:12:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.162-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

