Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA19EA5;
	Fri, 11 Aug 2023 03:41:46 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5656a5c6721so518741a12.1;
        Thu, 10 Aug 2023 20:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691725306; x=1692330106;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=C88m6BSZNPuD6FftOJKIQOMWbTsafU2w98EiCulz8z8=;
        b=UBkEsZ9t2fviTSAOdn3PSAv+ZJZ/dSw3ffY2/SpPMH4uoJrCq1Jl5ZRS1jix1JDlPz
         pEzUHbI2uxd9kVtRXZtD9hP+AE7cyI/QdioDDkPKLbdkxUU3oj4GISDKUa38X9c72tin
         g+sGlzoi0/cOImHR/I4swTxY2EUbmqRBbL6VL8o7pQelgt90eiTn7IfpO0RV/KsehiAQ
         xOYE8qZweqX2VsjnF13uU3lHJ+x3kiUYsx/R1QzH4c4492Sm39AvBV6+ukRhmqn1IALO
         aHvKfkhNZF8+gIbtM39kDfs3idi3TEv6kF7JgLMpik44gSCCDOxuZvvw2BXJSMeV5oCq
         hROQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691725306; x=1692330106;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C88m6BSZNPuD6FftOJKIQOMWbTsafU2w98EiCulz8z8=;
        b=D7v/cdzDu3bCXWu352Wepo7zbM2gzYiBCsZu9q1LFI5Fm14y3tH6a6XP+Tnd5jsbuH
         RzAZcihhCZ882DqC+KFgR8PgkGp9WpkTis6ha+lKjwSIFm2TC1Nv+vmonU+3Dy8laETc
         BK4Bb2uJIbXP7hHB1bEOVyDAzFSSuMJvH/BdTdj0LB6RwFp3tx9CdCnLQ8ATqCCxgpnl
         YnG2gVzXEPZy41mWPhpFlF1ZxlCiEsSOfUTFYcSUGQOtwOdLDRHSYwTRMJRd62HiU/jQ
         hyFiyL+1idLUUsJ0P2cats2KuSIECIakg6ddO5ZFGb3O52kWxGw5WYsmEmlX/XLYgRTC
         LKdA==
X-Gm-Message-State: AOJu0YwMEr6Nsk2AhnBcbZyW460f6ha8mU8VFVAfU5q8XLfxE5IpDGsz
	1YdVjtw54jS9Zbc4EaobOXJJ1YrffP4=
X-Google-Smtp-Source: AGHT+IEIoW3fcYR5Pj8QpQ5chayYxnakttvjecPpoFfOWwDLe1zdj8UuQBejTnLwU0y8zs4Pist13w==
X-Received: by 2002:a17:902:ea03:b0:1bc:4f77:e34f with SMTP id s3-20020a170902ea0300b001bc4f77e34fmr859315plg.27.1691725305771;
        Thu, 10 Aug 2023 20:41:45 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w20-20020a1709029a9400b001b7ffca7dbcsm2588799plp.148.2023.08.10.20.41.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 20:41:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <078d6e3d-9572-a624-2c5a-e2d58473e6d0@roeck-us.net>
Date: Thu, 10 Aug 2023 20:41:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.1 000/127] 6.1.45-rc1 review
Content-Language: en-US
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 clang-built-linux <llvm@lists.linux.dev>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, Sven Volkinsfeld
 <thyrc@gmx.net>, Daniel Kolesa <daniel@octaforge.org>
References: <20230809103636.615294317@linuxfoundation.org>
 <CA+G9fYvQdQqTqCgbS4sit_Y2AtKtDiWMOkGZjoeSEFhc=M_jKw@mail.gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <CA+G9fYvQdQqTqCgbS4sit_Y2AtKtDiWMOkGZjoeSEFhc=M_jKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/10/23 20:22, Naresh Kamboju wrote:
> On Wed, 9 Aug 2023 at 16:21, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 6.1.45 release.
>> There are 127 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.45-rc1.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> 
> While building Linux stable rc 6.1 x86_64 with clang-17 failed due to
> following warnings / errors.
> 
> Regressions found on x86_64:
> 
>    - build/clang-nightly-lkftconfig-kselftest
>    - build/clang-nightly-x86_64_defconfig
>    - build/clang-nightly-lkftconfig
>    - build/clang-lkftconfig
>    - build/clang-nightly-allmodconfig
> 
> 
> Build errors:
> -----
> ld.lld: error: ./arch/x86/kernel/vmlinux.lds:193: at least one side of
> the expression must be absolute
> make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
> 

We see that with v5.10.y, v5.15.y, and v6.1.y when building ChromeOS images with
clang/lld. There are additional problems with LTO and the built-in assembler. See
https://www.linuxquestions.org/questions/slackware-14/error-building-kernel-6-1-44-on-current-with-clang-4175727865/
for a summary.

As far as I can see none of those problems has been fixed in the upstream kernel.

Guenter

> 
>    Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> upstream report:
> -----
>      - https://lore.kernel.org/llvm/CA+G9fYsdUeNu-gwbs0+T6XHi4hYYk=Y9725-wFhZ7gJMspLDRA@mail.gmail.com/
> 
> Proposed fix patch:
> -----
>    [PATCH] x86/srso: fix build breakage for LD=ld.lld
>    - https://lore.kernel.org/lkml/20230809-gds-v1-1-eaac90b0cbcc@google.com/T/
> 
> This patch is yet to be backported and CC to stable.
> 
>    --
> Linaro LKFT
> https://lkft.linaro.org

