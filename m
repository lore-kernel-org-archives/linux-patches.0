Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91BD7B
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 23:05:49 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id h7so7320430ila.5
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 16:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1679353549;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KwJX4b+VPStuq284oz9cB+/Udp1QkSmbOh4T1cpR4pg=;
        b=CQQhyhzxFqeKEC8ObG77F4cyUsoPaWdJ+AO9fw9JujjKmlm9DQt9/DFZk7mp3y6t0Q
         17H5HCqlTMi+CCkfYaXyB0oh2DAMhbh64g78gKzJNcQ1yOLLqu0ggWagu9IKTvXZgNzw
         vzDmp6/MeVb2jowwPp6ox7eA0Y0Fke6GjcHYk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679353549;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KwJX4b+VPStuq284oz9cB+/Udp1QkSmbOh4T1cpR4pg=;
        b=PhCU0wfhB1iSNY0sx2CbIw0o3wHbo4YHil1lR8AnXeH/cNXBUiw5SEvQO4PjVRGHuj
         2NkvCyiqpQp8/i7AxY65zX93RkEdpLdA/c3ppA2zJ0gjBG2PwWktphrTIOxZpLb8WlXD
         IUb1zcp0letnBzpVCnaM3240FxklQGpWzwXM7V/8hLDeETynZ7o6FfnuZAQFBJIisyu7
         9AWq6/mWFW2/BTCJnuVs+z0ITM8Jy4qwyIGmrScWUGOwATXdTbSZyGeKbcZeQB4lD/PW
         Q8j5Yh3oTM7nCl2qlwyyCHq5ui4lY1N5jA7oaNsk2fEcC1N+a9cIp2wOFMLWvVrnzEoo
         YbCw==
X-Gm-Message-State: AO0yUKUNwJuBFw7LF8Yd2IKL1MYcYQgpfSBHBb18KDEyM6BS8Cpq3DOv
	ZWNli79FyDMVhJZfIhTc+FaBzw==
X-Google-Smtp-Source: AK7set+OCd+B5gc9ajXw1DDPfyi7WoLhrSHDcnF2ZsZfQucYQURr55VjtxQuikn+AYFRrV+b76DTwg==
X-Received: by 2002:a05:6e02:16cd:b0:317:9d16:e6c7 with SMTP id 13-20020a056e0216cd00b003179d16e6c7mr793903ilx.3.1679353548872;
        Mon, 20 Mar 2023 16:05:48 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o3-20020a056e02114300b003158e48f1e9sm3131882ill.60.2023.03.20.16.05.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 16:05:48 -0700 (PDT)
Message-ID: <2a7a841c-0f5b-9227-0014-fe40afd925f7@linuxfoundation.org>
Date: Mon, 20 Mar 2023 17:05:47 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.15 000/115] 5.15.104-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/23 08:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.104 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.104-rc1.gz
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
