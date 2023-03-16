Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB62746C
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 18:18:07 +0000 (UTC)
Received: by mail-qv1-f46.google.com with SMTP id f1so1810398qvx.13
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 11:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678990686;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oZLGHJ6+3en7wcpDA1c5BiqkKAkKpDqfiHyz3caHyFE=;
        b=W8M9hEzvOYxxUxLe9cGr1pEw2qRyYlm3E97AOCY42wX1PNAxqD7g9VadohnIeVSLb9
         K+jUtAJmccpQDkK37ooPm4aEdsWvJ8kTLGTj2hYxSHW4/U/+DRQOdc87rfS8TnpsKe13
         z+ZfEdA+UNJ3tjQ44w2RV9S6KBFOsx5wSpFRkcQoBhJcouqPQl0vWQ++iTNewbaHMjCA
         kY8t9QyrSl+IIU1EPUyVtCFVMmrIe2W0SJjULxLqgYnzDrWNW1qyhddrOr6ATbwcJjXx
         tfYXd9Fa1gwG7yYmtH4G5s5m3SneLXZvguqz2JyEC/EG1+SQRwOb+HgleOkZm0iUMu+9
         MupA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678990686;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oZLGHJ6+3en7wcpDA1c5BiqkKAkKpDqfiHyz3caHyFE=;
        b=RL6r1jm9L67UQjk9Z1NKm56rz77pMap7vuDlJ5Uo3iYQR2yVePSqwjKInfwbj4iux3
         SwzOw7sxq4mCXNCJ0fXOpyijbGD/mGpIjMvlizaNDg4nvb6hhGuIDqwQNEkhJrYPoZ5y
         X70yMjtKj1D1uIz46oaH8j9JSoYQvNYH+ZGqwyCYT2bcvhRDTzBFX6kcKSXwCWrIS2eK
         7uZEIC2PxR4pSwCjqzi+Txd1aEF3+nBT33GynvH4iITdbKT7nZfuHhD6W32SoKUt2CtO
         k4w0fhLNS8fXfUOfXP/l9kLjitrJ9EHsGoinO8uGcAezGjygpUPB9VuWW3vao0UlqoLV
         HS8A==
X-Gm-Message-State: AO0yUKVUDqwtlO4Jqa5ziiqc6B7IWV8DvraNdsuD9FKNgh4ov94U8Ts0
	4fKGhjR1X5dBTat/1qO5qjA=
X-Google-Smtp-Source: AK7set+fEui6EyOvMdH0qNoEjcEL6H16nBqpNbg6DV9CrSS0yq6BEabvKSlFnSAwAyPs3j0qBXvSkQ==
X-Received: by 2002:a05:6214:20c1:b0:535:5492:b427 with SMTP id 1-20020a05621420c100b005355492b427mr33869325qve.28.1678990686077;
        Thu, 16 Mar 2023 11:18:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j9-20020a05620a288900b0070648cf78bdsm42704qkp.54.2023.03.16.11.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 11:18:05 -0700 (PDT)
Message-ID: <3bc1da60-92d2-eba9-5f0b-b6b7020e19d0@gmail.com>
Date: Thu, 16 Mar 2023 11:17:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 00/91] 5.10.175-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230316083430.973448646@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230316083430.973448646@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/23 01:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.175-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

