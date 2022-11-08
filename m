Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37ED8A460
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 19:52:50 +0000 (UTC)
Received: by mail-qk1-f182.google.com with SMTP id v8so9737963qkg.12
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 11:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SpLo+FtLOtXVUj9eAqOXEISLFfayu/SG+63qUPT7Ib0=;
        b=keJ9QqkQPzzA8e3k4bP0nMeEXEsEZfwO8T3+0kOO3QFCBR/xARbfUgc3yXAY9kjkAD
         m/AH5Vi376o8IOFS3Hofka85QJ6boMKRN6gAXTsO02+fmX2cCOF/rA2gZZAhBypNbtJr
         daZN1n2YAWkyQjulfazux7bHXVxHTM8O3KjWoNwOsoWxz4ZUCj42YsWAi7HXoshR6mei
         Dsa7UTIQpP5lwF+gGR2a4hRZUdr1QrIhyGllmFWEtJLNqqGpNNL7pKYWTmzyUQwf+ggg
         EMepwyb3Y/eFycbxXbxsbjWKGR3dF6UD7yTWvgEgPKGeVdVoDIACtjX/9Sp/LLPPVNSR
         17Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SpLo+FtLOtXVUj9eAqOXEISLFfayu/SG+63qUPT7Ib0=;
        b=Zwq6TOJFuN6kZC1k+Q8aoFs2i+sLiOUMEyfzF/owCSp7V9Xr4c1udeHYYW/yHULtrp
         9YI9kR7djKS6hSxJ/Ke37p9mhxwg6dcgXX7AAI+lKu/xrhtjLuUEI6Fj1+bO/A0FhSPM
         44WMoIFrQ5Vh1JLBwhgsWhEsYTlEjZZB6tWRH6TjceAk7AS2RAJTVc1EmWQ2tzObmjMW
         XRsrjVbB+AFinEPKBe51NlOjmZUMgjvBKkRtowQx9CUHcY32xH+bndc/aWbcqjpIhrhb
         oek7yREPcp7n+p+qZXVn2Vz1A6+X6ivsIW/INJ/zKYM4jB09nFxhRBYnCsXXlUa5SZsE
         cYCw==
X-Gm-Message-State: ACrzQf3I9c2A4eVCm7KXdln3KmLBv+aOjWchpVi1wLPfb4/sPlU6JKAz
	5vmLqlSGFw6E/GDUgqUqxZo=
X-Google-Smtp-Source: AMsMyM6slPKvCmNk4DEwjJ7J6+KITm9nxPExMpF8HaJ/aoZOkeNoO8L1WyqRmfcr++PImzVUC0BUgg==
X-Received: by 2002:a05:620a:1597:b0:6fa:311a:933c with SMTP id d23-20020a05620a159700b006fa311a933cmr33000318qkk.741.1667937169135;
        Tue, 08 Nov 2022 11:52:49 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id az8-20020a05620a170800b006bb87c4833asm9721021qkb.109.2022.11.08.11.52.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 11:52:48 -0800 (PST)
Message-ID: <f648f524-8b75-6cf7-ae4a-fcb5d09e993a@gmail.com>
Date: Tue, 8 Nov 2022 11:52:46 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 000/144] 5.15.78-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221108133345.346704162@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/8/2022 5:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.78 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.78-rc1.gz
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

