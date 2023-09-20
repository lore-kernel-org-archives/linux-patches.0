Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6058341A80
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 21:23:31 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-79d27df62f1so4525639f.0
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 14:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1695245010; x=1695849810; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R+kTXKWF/KX1FezcljKFfED0Qa2CUlrf+Ao7Mn6CWqU=;
        b=G+EMCSntBi8MeIr8Lw6n22ZTghiQ96Diz41/pzkR/TEfe/4X53sKZauay33W69uVnq
         //5UYfDESx6PFNRndS4WHwWGr4v/16oTbJUND7GKzzk81BmPmTK72RkikPF1kcJMKMQN
         eXu+0FPgZJ760DQPmEgfHE0HxZqHj0MQJ210U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695245010; x=1695849810;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R+kTXKWF/KX1FezcljKFfED0Qa2CUlrf+Ao7Mn6CWqU=;
        b=jaexAMG5d/F61ZWjDyyrlLxf37etRK6fjzQkKyuHZcGzOnYosUXPjqDgs1i9CG3bEt
         BOICjwhSu2bIibzmpJi8xiG5pVG3Lx3EFg+bURLjdmblyzpAwz//AGoZ5XoZyecdqVWZ
         qJFeASIHChzKxPjto2RZRKAu+dORI1C0xzpGmJVBDN8e0vzeHZrmuESIWXJQ0brQdDlI
         q0msK+/9Z0a8EubhV9TkdCTL92TXT0BNuajjZecfk0Wert/UyoB1K9Pa5TsgqaehuE37
         RC2gl4AkHDG6/b1zcfWdomAdcB6H8twvIU8EUiQAtBEaX9a2DSBcAntYrfDCgpGuAeYV
         rKoA==
X-Gm-Message-State: AOJu0YyZm0xpKyHl6vaBWrCcVINkqqtAFHTMo9z8CBBh9oNt5eiLgtvv
	2tjSHEfG3OER40nlCXP4HqeNg3k8W5APcA1z7Q4=
X-Google-Smtp-Source: AGHT+IHKK0frf2smMGPMVw9UQ7ZkzFuDG6iiZ3tu4xgNQkwCux9hKlN41noej6BF6Bi5CAx1pWRvbA==
X-Received: by 2002:a05:6602:178e:b0:792:8011:22f with SMTP id y14-20020a056602178e00b007928011022fmr4163079iox.0.1695245010355;
        Wed, 20 Sep 2023 14:23:30 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id w9-20020a056638030900b0041fb2506011sm4265481jap.172.2023.09.20.14.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 14:23:29 -0700 (PDT)
Message-ID: <391f4acc-5e0e-5838-8ed5-bad58d2f5f84@linuxfoundation.org>
Date: Wed, 20 Sep 2023 15:23:28 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 6.5 000/211] 6.5.5-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/23 05:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.5 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
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
