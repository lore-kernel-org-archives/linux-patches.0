Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D803DEA1
	for <patches@lists.linux.dev>; Tue, 23 May 2023 00:21:09 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7747cc8bea0so3404939f.1
        for <patches@lists.linux.dev>; Mon, 22 May 2023 17:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1684801269; x=1687393269;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CRFXlgXqQMif9nrEGkoBNsCSy0LwutHy0WRVkrR+E6w=;
        b=WlcUP3WVgbUHJQoC7PtFlFyVnD5zH5f8zdyRMWatTe1mFVYOwK7qeYbzVBQdfyGGQI
         rftjHNbopiQKa6nsWV8ZqMUUMyOzSFNwkkR5h+1SUVZUa3k1TfvVS/S1G6YVEuHmKO4S
         gf+Ac04PFHqb0PQDIyC25HjOebLwsF/+mLgXY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684801269; x=1687393269;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CRFXlgXqQMif9nrEGkoBNsCSy0LwutHy0WRVkrR+E6w=;
        b=BMNCm1RiEvnQ+/JmaGXp6QKL+T5uUJsc/i7cFf30dDfnUXOb26zR2wRGBoSCRK5+CX
         JsgNgvG55wGRWXoxUOupTH6M1YKwKA/PwfREMlj/6PL1cAg0RKMpeJQsdYekVsKudUTg
         GDq5OUYS2FSfuvC4zZQ5MqsNJZ8A47Fnr+Znk2Uz2lijzlNZfcq1Rab8ju83o0fbdy6t
         8dmnnZAaMi0Lyg5r32qYnYs5L1uZ4xEyo9wflpIK3vLVmZzqOqz44Tf5N5Oc0qocYgv9
         ho7RWP8SeMXkDnxB4h/0t+Mv3uNoTMR929qQvFWH22+k82h4JGvB6kWw17DmLEG/lj8h
         wExw==
X-Gm-Message-State: AC+VfDzKqcW3lKJMqLKHIXeadX0ybEeupd1e3JAw0THDO2pLZT0c3p2g
	OqJUcez7szvyDu3ZCoDcYspXfw==
X-Google-Smtp-Source: ACHHUZ60Ia7zbZE8PgUpAPNdPWJiuAdXYd7zgT7guq5W/LEHzbR2z7He3IYx2okds6kq4Gb7OXySpg==
X-Received: by 2002:a6b:5a0c:0:b0:76c:6fa4:4df4 with SMTP id o12-20020a6b5a0c000000b0076c6fa44df4mr6196582iob.2.1684801268807;
        Mon, 22 May 2023 17:21:08 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n13-20020a6b590d000000b0076c81425d9asm2290113iob.49.2023.05.22.17.21.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 17:21:08 -0700 (PDT)
Message-ID: <a8713c0a-8fe1-88e6-107a-fd9a94ac7e78@linuxfoundation.org>
Date: Mon, 22 May 2023 18:21:07 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.3 000/364] 6.3.4-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/22/23 13:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.4 release.
> There are 364 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 May 2023 19:03:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
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

