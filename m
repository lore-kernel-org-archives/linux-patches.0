Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF51F291D
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 15:45:54 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id e10so5423708ilu.4
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 07:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677167153;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SvCT+N+hA/Qzqm3zOq0MLMVWGUsyfTWyXW5JOLtV5Sg=;
        b=c/5Ih4PLsaj2HNNPbTcRkwNj/nqV3rgCiNXkgVd+VGNJBXKu4g6uMLS9lyrLd1Po7Z
         tP7v22IBRm7e1SP3MnUNCH9cab9+p4H8aaGMaCUkk10dGMxGroLpBdO/TzSxhJAPmaUg
         3AXV82imm3VOwQZMb1lZPNecc05/Exyn5Uumo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677167153;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SvCT+N+hA/Qzqm3zOq0MLMVWGUsyfTWyXW5JOLtV5Sg=;
        b=3w3HZ8/BYQgXy8Inp1w/VN+AiLRsz8XZYcE8elodsHEViWzPJwnE9IQcrM4SgKsR3m
         x0CI4ABpnk7ZMkHcVf/SOE+bmUZNpea3s1jQqGte6Ykv2jICka97OAiDwohycuiIrdaj
         u87gQB5pKaV+k1in5OePiNxvDy5aLJwAaJClachQnUd2bgi7UZdZmrj8qKkk/b6cT8Z0
         YwPNVy9WWGUKJgdcQWTCIXytNAzaR7jl4x3RUHifzH6FEuur+HfMIv6+0PUvh+7KZQdt
         /77mKM9/+JZH81U5SuP3UiGTaQbY5UM3UjL7QoaUD1IXBm+1f2XwfVroLdjHtZ/vMipV
         n3tw==
X-Gm-Message-State: AO0yUKUdetNL2YvqtZXK881j2vto0DiJBPlvdAJ1mkS0v9L19HghsfYT
	dQNqJ7rvT1CNYu2P/ITSoTd6YQ==
X-Google-Smtp-Source: AK7set9WceE7Mu9chNCfREQZpv8uKvzcBdPDrJJDyqXN/PQN7zOHvO5SCRh8g5drK4GSIw7Ljw4AVQ==
X-Received: by 2002:a92:d186:0:b0:316:67be:1b99 with SMTP id z6-20020a92d186000000b0031667be1b99mr6922041ilz.0.1677167153647;
        Thu, 23 Feb 2023 07:45:53 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k9-20020a02c769000000b003c4f77e61d3sm2176386jao.64.2023.02.23.07.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 07:45:53 -0800 (PST)
Message-ID: <d8032a63-64e2-0769-55d7-60f9b2f46a01@linuxfoundation.org>
Date: Thu, 23 Feb 2023 08:45:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Nathan Chancellor <nathan@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, llvm@lists.linux.dev,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20230223141542.672463796@linuxfoundation.org>
 <CA+G9fYuhcaYO1m29-9vQr-HK7_xJYouAAkM=ouMYzOBk+otCVg@mail.gmail.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <CA+G9fYuhcaYO1m29-9vQr-HK7_xJYouAAkM=ouMYzOBk+otCVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/23 08:40, Naresh Kamboju wrote:
> On Thu, 23 Feb 2023 at 19:46, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 5.15.96 release.
>> There are 37 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.96-rc2.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Following build warnings / error notices on 5.15-rc2
> anyone see these build issues ?
> 
> scripts/pahole-flags.sh: 10: scripts/pahole-version.sh: Permission denied
> scripts/pahole-flags.sh: 12: [: Illegal number:
> scripts/pahole-flags.sh: 16: [: Illegal number:
> scripts/pahole-flags.sh: 20: [: Illegal number:
> scripts/pahole-flags.sh: 10: scripts/pahole-version.sh: Permission denied
> scripts/pahole-flags.sh: 12: [: Illegal number:
> scripts/pahole-flags.sh: 16: [: Illegal number:
> scripts/pahole-flags.sh: 20: [: Illegal number:
> scripts/pahole-flags.sh: 10: scripts/pahole-version.sh: Permission denied
> scripts/pahole-flags.sh: 12: [: Illegal number:
> scripts/pahole-flags.sh: 16: [: Illegal number:
> scripts/pahole-flags.sh: 20: [: Illegal number:
> sh: 1: scripts/pahole-version.sh: Permission denied
> init/Kconfig:97: syntax error
> init/Kconfig:96: invalid statement
> make[2]: *** [scripts/kconfig/Makefile:87: defconfig] Error 1
> 
> 
> Need to bisect
> --
> 
> commit 54fab3cc806aec70d7ce8440e511d56bd53a4081
> Author: Nathan Chancellor <nathan@kernel.org>
> Date:   Tue Feb 1 13:56:21 2022 -0700
> 
>      kbuild: Add CONFIG_PAHOLE_VERSION
> 
>      commit 613fe169237785a4bb1d06397b52606b2967da53 upstream.
> 
>      There are a few different places where pahole's version is turned into a
>      three digit form with the exact same command. Move this command into
>      scripts/pahole-version.sh to reduce the amount of duplication across the
>      tree.
> 
>      Create CONFIG_PAHOLE_VERSION so the version code can be used in Kconfig
>      to enable and disable configuration options based on the pahole version,
>      which is already done in a couple of places.
> 
>      Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> --
> ls -l   scripts/pahole*.sh
> -rwxr-xr-x 1 naresh naresh 610 Feb 23 21:03 scripts/pahole-flags.sh
> -rw-r--r-- 1 naresh naresh 269 Feb 23 21:03 scripts/pahole-version.sh
> 
> 
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
> 
+1 seeing the same:

./scripts/pahole-flags.sh: 10: ./scripts/pahole-version.sh: Permission denied
./scripts/pahole-flags.sh: 12: [: Illegal number:
./scripts/pahole-flags.sh: 16: [: Illegal number:
./scripts/pahole-flags.sh: 20: [: Illegal number:


thanks,
-- Shuah
