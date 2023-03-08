Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BF8647
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 06:24:51 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id s41so11412496oiw.13
        for <patches@lists.linux.dev>; Tue, 07 Mar 2023 22:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678256690;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5X5KlJGh8wmufQGIV2D/tgCOyLpAoiqef77SrBzKk+k=;
        b=ieBDziEaCEOU5BTCib18PBto1Gq5N8s4DoCs5oN8h2hdjXaemKKmCueAMJzohRt9yY
         /Gei/ehKN/NcqqFfZGgtuEWlmxkNbDgWV4SjU4QlFSOwuBDKPHV6YWZ1fH5032apXv3s
         87sXd5enefs6y2/+peP4zA6oHoeTMjvEgk2A/1a+TuBN1t93PK3mh9Bc2JKAe612cd18
         v5NRaCvPyqPyNpgrsULfjrXvoREpm9wUHegUVNHt4VEMITEsJZy2M6ZwmvRD4q+YhVhS
         hqOpwZrzBvrOSwNJdaTp54Xe+izDIIHc8uECIphieTuRcjj0r3DVDnoTGLYFu206Oosc
         fpOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678256690;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5X5KlJGh8wmufQGIV2D/tgCOyLpAoiqef77SrBzKk+k=;
        b=bdcau1dD8Ii2RBuikjedF8uzq+HxORisJ9i9ZTF5DZgemdG35UIb1F0oLYyPLSYoOc
         PlGmvYF7EjqvnDsN911nHOVaa795aGrVKOh2tJ1DPs9wy0d/AsAOfSB9TgPHL21N1dDF
         TRiH/QpSfB3mgwzptl1lx9n6HRbddeSWBWlv6W1jxPgIb4HkQMfSZQZ8l9hErM7A6i9B
         kFAqrPbDSBg/fX/jzKV697yR/KkFUj6ftG1bSIsBQcWSqNhO9QiOoKqnG0x0K9Us5BAY
         eeEV+9i49nVnmd02cKfPW5PKMUFXT4iRYFqCsnAanbAfHJxVXWrct6OjatgMCFd3Ia7Z
         JveA==
X-Gm-Message-State: AO0yUKUP3til263AUnZIXGEnVns29eMEuCxz7XW+Gfc7fI/LyNXXy7m3
	lFt1AmHjN7JsrbwqcnWZxjDbpg==
X-Google-Smtp-Source: AK7set/IqnTdfkK2/5VmcLj+50JMgv5m//T40wTxcdYkzR0RXiu0N8C4nqtywJqs3YseiF8959OW8w==
X-Received: by 2002:a05:6808:5ce:b0:383:b777:8518 with SMTP id d14-20020a05680805ce00b00383b7778518mr7587929oij.24.1678256688725;
        Tue, 07 Mar 2023 22:24:48 -0800 (PST)
Received: from [192.168.17.16] ([189.219.75.19])
        by smtp.gmail.com with ESMTPSA id s82-20020acadb55000000b00383ecd10ea6sm6016159oig.20.2023.03.07.22.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 22:24:48 -0800 (PST)
Message-ID: <4ce8fe57-53eb-4a83-a468-ebfc98fed496@linaro.org>
Date: Wed, 8 Mar 2023 00:24:45 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.15 000/567] 5.15.99-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, peterz@infradead.org, jpoimboe@redhat.com
References: <20230307165905.838066027@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 07/03/23 10:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.99 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Mar 2023 16:57:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.99-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

A new warning has been introduced on x86_64; we've seen it with GCC 8, 11, 12, and Clang 16.

   arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x54: unreachable instruction

Bisection pointed towards "x86: Mark stop_this_cpu() __noreturn" (upstream commit f9cdf7ca57cada055f61ef6d0eb4db21c3f200db). Reverting this commit did remove the warning.

Reproducer:

   tuxmake \
     --runtime podman \
     --target-arch x86_64 \
     --toolchain gcc-11 \
     --kconfig https://storage.tuxsuite.com/public/linaro/lkft/builds/2MhGKYH63pYIllJIDAxH3FsvakK/config


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

