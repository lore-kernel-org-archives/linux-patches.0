Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115BBAD20
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 23:40:21 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id l2so1315218ilg.7
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 15:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SL0z9x2zUIufYQsB/HLcyg5XTH8HaFTQReJij2yCEP8=;
        b=SJzCjQBQU9Z5SQNuvDZSHLS4thJUMrfncnBMPYjZ3APB5RlSqcj7ebGh+MjLUzWMTX
         xnz1li7U6DY6lddE1ItjW5Qlzuod2X9K1C3sK6IeAtYhjKjFvdCxYJhiH23gKo5WlVHe
         Ck+ZL4TAA6dC/7bJvunZ9WbtWpIG1QMT4lvY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SL0z9x2zUIufYQsB/HLcyg5XTH8HaFTQReJij2yCEP8=;
        b=sFgRKbs9HDw8fNnFHI+LrXnCHSPDDJUhRjGdzpps9EEh2WWQhpgxqZJ54wDRaa98VE
         +iFkbTYbpvL7mca2cGVl8wy0eOPOA2ybMOOsj15wNxhHz8amZFmogPt9uOXfufUymLQm
         vpZpGQoy4nBxt25uRXyDmUmgcxYD78PzeHSRysMyDHaPLWgPW/V5t+1MgLyZj2NI0eS6
         TXX5hNmOzOjmekcijNqL6+3tuKxt1Ygbhxu1Y+pkppurWDUoi9rW5HgeXu9H6ydu01vY
         lnJBQk984MBUqFIFyAd23x31UldZQDwK83k+iDhrfP4OwD0Y+FvGjIRt2U8DD6cPrz73
         /Sgg==
X-Gm-Message-State: AO0yUKW2BK2sELr+2nuYhxp9Hatz48RquKvztKAhVQIMPYlIc3V+Tb0e
	6Mi5J/zndF/yUbJSwdBiTvVWvw==
X-Google-Smtp-Source: AK7set+UY8OPToN1EOx5FzoLtfSuFrXICfON+YwtZjlyx391Os6zmh5lO/NypWAW1Ke38B3k4UckeQ==
X-Received: by 2002:a05:6e02:17ca:b0:315:5436:a632 with SMTP id z10-20020a056e0217ca00b003155436a632mr9360401ilu.2.1677195621066;
        Thu, 23 Feb 2023 15:40:21 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o24-20020a02cc38000000b003c4eb8f862fsm3123944jap.66.2023.02.23.15.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 15:40:20 -0800 (PST)
Message-ID: <e5155c9d-b142-fd3f-0198-3fe4db83b350@linuxfoundation.org>
Date: Thu, 23 Feb 2023 16:40:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 4.19 00/12] 4.19.274-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230223141538.102388120@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230223141538.102388120@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/23 07:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.274 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.274-rc2.gz
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
