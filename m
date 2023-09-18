Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB1C450EB
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 22:21:35 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-79d1bf17505so35486139f.0
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 15:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1695075694; x=1695680494; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+0YhvdHFMerPFgTasHZONWV02qA1rGQ8gwzTFXSB750=;
        b=Ms+HZIBVvCLlPkwrr8xG0aq4IuLKeJm8buOHtyAGkYb7p0Js4zJeSwpMzSbSj3S/e3
         iRkfrb/AQNoepKy5t3kr+YNghESCocc7PxhhFdqfNZbIQgp+XVl1dLKn5pK5aWycqO4+
         Cfo8QoJAgmeRKg0RmsJTBaAKgzjIp56QS4Wok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695075694; x=1695680494;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+0YhvdHFMerPFgTasHZONWV02qA1rGQ8gwzTFXSB750=;
        b=MaV6Umj7sV9iScEoDxOK6igtIHxyIapf36zIcXAniTjTj+tatVMlLGSyyQFpiNtmnD
         XFOtgx1bM+HGjxkMnvWvT8Fn2l1F5SLWK+NkkhJ3nA+Df5vWDnKNTp9GzEVWmGPJP6pZ
         7PDBj4n7yEG4LYeEcMD6P1hIeDSEnJSHbUPriYzOV/6Zmqh6K+Ksc4EfSPj00xOfNXQM
         y62ioWYdx2KIGWTN/D01TUrBGsLL88m/UnVrgdIayu1cyVZ7AvZu1xewHljNy0gp6qq3
         7oa5S+G8WJ6qgptfVDRNsqnwQnRHw2GUpAsO3w030p4KjUilhI86WR9ytvIQVg46xobt
         S1Hg==
X-Gm-Message-State: AOJu0Ywc92OWtnx0aNcnX6PtTqyycuZP3cbVHSnH2Ii6dN0kNBfOBfZ6
	PGsDbTvPcc4gIdVw8WgB0T00bb6X6iGrj1chzNw=
X-Google-Smtp-Source: AGHT+IFM5+C8inBth6aEvK356DZMrK/A4rOkvCd+6QkQFdSUI5BGN3NxFIV+oJEKDQ8JCYJYV2wwlA==
X-Received: by 2002:a05:6602:3996:b0:79d:1c65:9bde with SMTP id bw22-20020a056602399600b0079d1c659bdemr8027440iob.1.1695075694407;
        Mon, 18 Sep 2023 15:21:34 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id v4-20020a02cba4000000b0041d859c5721sm3101989jap.64.2023.09.18.15.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 15:21:33 -0700 (PDT)
Message-ID: <ff41df83-f4b1-a557-1289-965676f8978a@linuxfoundation.org>
Date: Mon, 18 Sep 2023 16:21:33 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 6.1 000/219] 6.1.54-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/23 13:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.54 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.54-rc1.gz
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
