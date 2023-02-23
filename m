Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929442F2A
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 17:23:20 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id s5so13758027plg.0
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 09:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4X9XPUluho+I4U2YTl0MMSfrwa5zdjEgqCMtE8mvXv0=;
        b=gh+VZGdKAHENF5w1fy6caNEhvYRPbgD+mn/rC0Kyl8Regya2mBoyKQoD4ZQoPQK06Z
         jCtwhGwbsRibxW9U2oIbd5nnuY1oN76EnBddzfQLvP1vcZfXcwaEzKJoeF61+6rUTPz0
         k9CMne/R1oS4lkKKKJ9ZjYE/2IEPf0PydUhXU0hUWa5pnuo9obox8Ba1vsckhxqu8J44
         2T0q13SG3oegxDDZfn+feYdLaTPx4fXZYb9TC3RaaCR1SMqwzdq8flGQHQsCSLHVwTHx
         EPjUShnrWecq/MJcrqAY14q6xY3PIp/GjGjyM/yMZQiZxeMwoKEAiymQcB7pzNoCt2UM
         Urlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4X9XPUluho+I4U2YTl0MMSfrwa5zdjEgqCMtE8mvXv0=;
        b=ZwutuJYgn+XL7XWTgDXxIkglm6HXxwnwAGaV27pNR6a3BnzUKzgk7lsO1ddApFCKfV
         5Jx06yw7+pSfpZ5SMbJeH1T8qQ1UopVWgz91FXp5FqkDTjeosmWPsq8K6NNZFIRIG70i
         FhIP9eOOo4lEG33sJaXIrLrnTrGz+q/nNKjrbm5hcJ0vPMBm+dPw7JW+kjoQ1qeY/GQw
         5kMfKvkXsVQhgUVAEwGpdNyk3T4zQ5pD48vfouro7mRulsr19HWkF7AsAbh0qr61Yb72
         CBkgIQ2vJ0rgCYpcg6R5FPc01NEipM/SwEBrSoNgIJGHw/M77C+52p1+0SJbmT1tAkE/
         SS3g==
X-Gm-Message-State: AO0yUKXTDC+msYVejjhjNiqzns0YoP5rkIWdgdt8eHma72qt3i7G/OMX
	9GOmS6rrJBtzRJInuxml5AE=
X-Google-Smtp-Source: AK7set/K4BBwjvU55dIu+6lZsRHoNjZpmTcK22Pfl06vnIwEZdIRSLiFDIZGZcdH13Kd98nUMMz50g==
X-Received: by 2002:a17:902:e1cc:b0:19c:9420:6236 with SMTP id t12-20020a170902e1cc00b0019c94206236mr7798946pla.22.1677172999883;
        Thu, 23 Feb 2023 09:23:19 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x20-20020a170902ea9400b0019cbabf127dsm1941061plb.182.2023.02.23.09.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 09:23:19 -0800 (PST)
Message-ID: <6c19502d-4303-fb8f-f2b7-9061a04b9a15@gmail.com>
Date: Thu, 23 Feb 2023 09:23:17 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 00/19] 5.4.233-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230223141539.591151658@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230223141539.591151658@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/23 06:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.233 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.233-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

