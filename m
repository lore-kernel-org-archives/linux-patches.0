Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193332AB2F
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 21:04:14 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-77de8cc1370so57943339f.1
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 14:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1687295054; x=1689887054;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gjrlNog9VUmWQ4CeTJ0zT3GopxHeGj3HfK3FziRfHlY=;
        b=AiSFNVi74b4/QYZ++fP27D6qMecoPP9WELi3ff1Q2o9+DCQogAAyxG66lKIKFcVHKs
         nytMo+5R1dIiwtoPClgLLft/vhlnEFVC4um3B4FMQchpQqhbeggkLpX6rBaLWQCJrMHI
         nNu2vQK93jk03Y+mVFkt2YWFGAhW9i7nXFp6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687295054; x=1689887054;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gjrlNog9VUmWQ4CeTJ0zT3GopxHeGj3HfK3FziRfHlY=;
        b=YGOuTE0oyDpPrTLywFtSnf8YI3/TZf2m6INgqY1EkfynLtIde8cS3HzeeLJEyeOHLY
         Ma7r4nGfHBmJgR7iIZR2xMsj0SouFgj9LifUC8tvHsFflgc6ZqsbH/2iGZsTq9X1Jyj8
         rBha/6fcZra1fIUdMf45CxAmxjGENTKoLlq2k6jKTXm6aXgs2KQLgHUqLV+OCkJ6mHRp
         B0rcqFpbvY/Jsk2Wm9ebwrVQd/gLR0PRxFqZ1nTuhYUSRmtjXulrLMnxaenCCG88QKtA
         7h3iv6O27ehukfFsx/R+03biQxCUPDgQ+TMFys7tOAtTuP3M+XTmF3kWm0pNr4dBm6tv
         yMRg==
X-Gm-Message-State: AC+VfDz/zuqJkjwFB0H06XYv98PQLHJtT9CUmHTtffw0LdexVlsZlQtN
	OEAxO0wn/gAHZczD6eK8fYQTqw==
X-Google-Smtp-Source: ACHHUZ67pM/+HD6HxI1DKWKKG34tNljc5QMIctdDs8pRmiKA5LIWM3veIBSPKOLJ+4RyySUz/FkMKw==
X-Received: by 2002:a92:7c05:0:b0:340:ae63:38a4 with SMTP id x5-20020a927c05000000b00340ae6338a4mr11589087ilc.2.1687295053815;
        Tue, 20 Jun 2023 14:04:13 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c5-20020a92d3c5000000b0034202d05fadsm831865ilh.72.2023.06.20.14.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 14:04:13 -0700 (PDT)
Message-ID: <f7bf3aa8-f1b8-a1b5-8e51-46d51d002633@linuxfoundation.org>
Date: Tue, 20 Jun 2023 15:04:12 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.15 000/107] 5.15.118-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/19/23 04:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.118 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.118-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and boots, but doesn't get to login prompt. Keeps running
into NMIs and watchdog detects had lockups.

I am starting bisect and will keep you updated.

thanks,
-- Shuah

