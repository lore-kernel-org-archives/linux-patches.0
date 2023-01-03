Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625B3160
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 00:25:52 +0000 (UTC)
Received: by mail-il1-f170.google.com with SMTP id m15so17361422ilq.2
        for <patches@lists.linux.dev>; Mon, 02 Jan 2023 16:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X2bRqedDHz7W8LP/t/e8z/mJRrJLBwwXwuoJjeyrKPQ=;
        b=WRpqGYVNcjYj/JZxI+lIU5Mp/6pPnnamqt9IOpppL4UtcG4hEizNDdmi2yRzsOZFNU
         FLQy+u1qfwR6XxLwkVoe1vo01wLLgqwqDRtCQhxE/3sISiHkk4yK4IbYS8oDZInW9KOs
         I4T6fgbonmBLJSjL2p6ks+DX63wLfOEM9Avr8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X2bRqedDHz7W8LP/t/e8z/mJRrJLBwwXwuoJjeyrKPQ=;
        b=q+IRMb+vjgbiNJAJLindqiTXlMs9xmsT/hAwsq9DTqiTaMIo6uYhkLSso0U6YCsQQB
         wHO2Ycitt4tFZFAOo1GToVQVyud4mTtUJW6Oebz0jILF4OnuxysVqdLmoU1a9PixaE3c
         eC/LKc+UaW6ojtbydyBMR99coOo2ujHH/pM95ebbWM6m2R5G0H4tlLXWp44mDWFe2Z2n
         mYgs5GQ9U6fbTIl5djy7lRQ/Fw2xCOMIqgNRfunDjk32RrMaMYjq853vmU8rHcAtp3tj
         j664mKNl93T7DJlgMGTT0TKUudWIerc+lX2xVcx+0IDf6z5Tkd6bRx5edp3W5jFzDUBV
         ZIdQ==
X-Gm-Message-State: AFqh2koHMRBQg0MCbZmi2YE7/3BZbfwArjcHKga/f8Xafnmt6ObI4HqO
	Q/gNs/8Tmkb5T5oZCauVK0lDdg==
X-Google-Smtp-Source: AMrXdXvs5/vh8wOrYitaU6nwXH2xlsyKqI0lkqQSJoUKYXh1+FlKb3hOPwOzO8PIhXnNaOkhsJmSXA==
X-Received: by 2002:a05:6e02:12af:b0:30b:fe91:35ed with SMTP id f15-20020a056e0212af00b0030bfe9135edmr3789190ilr.1.1672705551299;
        Mon, 02 Jan 2023 16:25:51 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id l1-20020a056e02066100b0030bfd384821sm7609317ilt.81.2023.01.02.16.25.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jan 2023 16:25:50 -0800 (PST)
Message-ID: <1978c896-f08e-a397-0949-d66aedb5ae38@linuxfoundation.org>
Date: Mon, 2 Jan 2023 17:25:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/2/23 04:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.3-rc1.gz
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
