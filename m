Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7569BA92B
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 19:06:01 +0000 (UTC)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-4b718cab0e4so166453467b3.9
        for <patches@lists.linux.dev>; Tue, 10 Jan 2023 11:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XCwyXZ8v69nxWVcxtEAn9KfGkzaGevR3ns9wimMR6ic=;
        b=eU4fQ0MJtrWbl3qlhQy2aBeVqq2XfAAjP/zu1rSqBDiC8+s9bNvLZHkQeGRIOSrvS7
         eovdtjLIjioi+z0bZKbBVXdWZF5i8ZUoJGEGpeeKtpaaEovFGzGtKx3U0ln5cqQRgwGT
         qLxxVjC/hoCabkqKbqUqYY4xP9TWhSTwspE7RNLJAN4Hi1SEhx0vyQQ9oWSRPYzW2dJ1
         SijK1NM2QcGcc0oxno1o4BHcEh4f9OamTG8ZF39yzOfOVKFES6A5uy7yA2tiSZugQm+E
         AXKKioAy9DfMCNBAyL1lQlPmQUEn40zIKvUZEKU6r4CDduc4hyLdi/F9Wul3WcU3WZ2l
         v8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XCwyXZ8v69nxWVcxtEAn9KfGkzaGevR3ns9wimMR6ic=;
        b=O65DW894b66SAM0lDmdlIuLH4VVkPGudVpJhUqwJhgBqk7vBwQHxdvvBXvA28GFKsv
         Msq1TieHoueziLZjXjT+VUOSxdbyWEUrI1A1xPc8qz/mRX4JYbGfn30LWDsyq3rpMJ1X
         pRiCWxHSMSpjIbZfJskMyVWjmnNqS8O1nVLDHlL3R0q7A9vLzf08tNAhKat7aAfFOFOw
         0K6TGTrh6r671lhYY2LOVidLeCY28dmGNjAdiW3cK394ryGmo1zrSLuzi8wjmzj947Ks
         Oi5z98HRLzYwCYlosRj8/xwGjhf1Xr+5vnRc5v3dseJ1A0lHCQv1xtlQu2zdKmMkOC5o
         PQVA==
X-Gm-Message-State: AFqh2kquw6lCfg8UaHItWLNm4vpCmF8n68SpwSv+9FaTsLHj5iTRN3VF
	k6CTuwwpcM69jcVdzoFGcNM=
X-Google-Smtp-Source: AMrXdXvDZdRsHQJY+Vh2CB3gJuG+irHektVvnnEDMARBodrGh7SNo9Ps3Jh+DMszzf0T4+3orlPglw==
X-Received: by 2002:a05:7500:438c:b0:ef:9e99:331e with SMTP id fn12-20020a057500438c00b000ef9e99331emr3073619gab.55.1673377558193;
        Tue, 10 Jan 2023 11:05:58 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c4-20020a05620a268400b006fefa5f7fcesm2880802qkp.10.2023.01.10.11.05.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 11:05:57 -0800 (PST)
Message-ID: <227de28a-5f2f-a6f1-6e84-e0d0d5dc6bcc@gmail.com>
Date: Tue, 10 Jan 2023 11:05:51 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/290] 5.15.87-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230110180031.620810905@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/23 10:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.87 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.87-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

