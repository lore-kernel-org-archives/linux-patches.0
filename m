Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B34156C3
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 20:06:46 +0000 (UTC)
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-77dcff76e35so56719639f.1
        for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1694462805; x=1695067605; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5vdcOYkDo7YYgDn3y9MlkiRl34kpqBQNFGUopW9ZjvE=;
        b=bY6HYCrKlMqLKXrrSOdUoImlRm73KSr+4+fHDzNefKNGyv9yfael5PtI8PG1mM2nHS
         ixBt9V2E/BI6upRdFiZ62bSZF5RZlMQon0DRvXihuXyZ1Zh3VOy8Kz/XcvFCAMtqK2sP
         BT2N0ZCyeBXYcYlBkCvvaVCKOum2SrwoNZoKo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694462805; x=1695067605;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5vdcOYkDo7YYgDn3y9MlkiRl34kpqBQNFGUopW9ZjvE=;
        b=DjckiGTTZX2kpcSvP90QhuLAcvgki6e4whaOpz+z3+51ETMQUYz1fM6Nt3+uFhus1i
         IQrGybqX5HNiRyieEJsKaSy5zs2yepanLebba9SKbV5p60olD8DH45fVl2PUDpaxUmyq
         EoIh7N3trCOfFKRl7MK8aLbH0WZPye4p0QqGZ+Rymc9kCjpjHZPlFdPJFaTIn/3oTt7w
         4qJSpn6PUaRNfCGg3ObMnIuCCZ21rI0om+BgeZWpZuhxok9nLlc2sWBR5bzOru0/cq2w
         jFpXHW6QwCQAz6Wu0aPNtob7RcsA6KYb1My1/uyCAXPuUjxq7aql4P+zCHGVN97AtI5p
         2imA==
X-Gm-Message-State: AOJu0Yzj9CIuBNO/sW7k3N7TmBXeeuKQ/MKzAZP2w2J+HnR6RqBPHsdT
	+ZXHhBraJ5Ah0I3nipq2Dmq9HQ==
X-Google-Smtp-Source: AGHT+IFWyI74g4J7b5VMjPOyOMsyz+RufAkrXy81JLdc8QUB4IHlAQwhWICvcnTmDPRDlM0vPfHyVg==
X-Received: by 2002:a6b:c810:0:b0:794:da1e:b249 with SMTP id y16-20020a6bc810000000b00794da1eb249mr13694459iof.1.1694462805495;
        Mon, 11 Sep 2023 13:06:45 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i3-20020a02c603000000b004302760aa6bsm2333572jan.4.2023.09.11.13.06.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Sep 2023 13:06:44 -0700 (PDT)
Message-ID: <a775025c-4e66-f414-5475-76698e30accf@linuxfoundation.org>
Date: Mon, 11 Sep 2023 14:06:44 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 6.5 000/739] 6.5.3-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/23 07:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.3 release.
> There are 739 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.3-rc1.gz
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


