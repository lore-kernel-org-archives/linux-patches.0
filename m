Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94151DDA7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 21:30:02 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-76c56d0e265so1533839f.0
        for <patches@lists.linux.dev>; Mon, 08 May 2023 14:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1683581401; x=1686173401;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4aWrgKo0KCjqs44bpXAfvA4ZqQoaxuHBLhlatswZ7io=;
        b=bh94yh6SgENk3JX/j5hSR2YoTFILkcgMWznMypE2g+k1ZmURDVX+2Its+1G434XqcQ
         z9M88J8Q6kXsfJBKgbQNB5TGLVDk8NEQpX5PXJ32RO2ftGo7xkAmixc0YFtFTTRvOvhN
         9vUtJ4xgRMq+kc+htuQ6HgFusR+OsXK7w1EeQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683581401; x=1686173401;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4aWrgKo0KCjqs44bpXAfvA4ZqQoaxuHBLhlatswZ7io=;
        b=VuBNSEVysyeir9+cGnzSIjISxSroqS0hje9/wpML3tGBWYA0AXlSqDzqa1YnWzbxvB
         qmBxwe4m38kOh1RSqaer7utuUW6AyNYMkF2S6YZ/bvjowUd7PuP2R6ReNcl0A0gf3isF
         wW3uhQv5x5plIcupcHn7prodLOEyIEENACJW/xJ2g4k1IcV0XQzr9lV+aH4+Ds9sm3jT
         IqZx1wdw6pq2m5yn9ZR9Fwb/6FrKDaOQdujlGrSww4OC8aimRLT+T8jLmaM565K7J9K1
         u4OxPDyY4Ogjq8J62nY88C9mSEquW7UpCR0G9eisok5gV9WVwrtvii2uY7kbQQ1PcGz1
         52gg==
X-Gm-Message-State: AC+VfDx5ffrhyuR/vzJ4RrAW4Yy4QpF39U/W8WsP9Pn03kBo4lt1Vj6j
	kN8VIboq/tqxYLEoCwHMlWWxKQ==
X-Google-Smtp-Source: ACHHUZ5wg5Glntzt6FEJOgeM9pJxKb98jumhL21u83nHb2Qz7T8eZzlRBm0MyFziU9TYc1r9rfDrUw==
X-Received: by 2002:a05:6e02:1541:b0:32a:a8d7:f099 with SMTP id j1-20020a056e02154100b0032aa8d7f099mr5773464ilu.3.1683581401679;
        Mon, 08 May 2023 14:30:01 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x14-20020a02948e000000b0040fa3029857sm2308720jah.128.2023.05.08.14.30.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 14:30:01 -0700 (PDT)
Message-ID: <b23432a1-593d-73d5-6bcf-bacd16f0bc10@linuxfoundation.org>
Date: Mon, 8 May 2023 15:30:00 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.15 000/371] 5.15.111-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/23 03:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.111 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 May 2023 09:47:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.111-rc1.gz
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
