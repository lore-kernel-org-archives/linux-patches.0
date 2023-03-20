Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90F6882D
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 23:37:47 +0000 (UTC)
Received: by mail-io1-f42.google.com with SMTP id o12so6222106iow.6
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 16:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1679355466; x=1681947466;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wp9Ma1tXiomJIM+Ccb5K6YpKhjZGXmIfWaW8gLzKl4g=;
        b=TSCG4w00s8YBocOWIS/OSfGK5YDIOxqBQSsMdSjkkDqW7ewwapjebWaer+ROovpYRd
         fnCRarZhJcNnT0is9osGV/8Ag8cmep3HwlVSeJvufRU4yJbzhh8rQpqn5B1indKbpCFj
         SI7OsSPUwdr/WUeMCOIQT5p8FDY1prsKl/OII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679355466; x=1681947466;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wp9Ma1tXiomJIM+Ccb5K6YpKhjZGXmIfWaW8gLzKl4g=;
        b=vUuZzZI7kVCl7aQlstZRoogOX5m2p673r8qxpq5RuEbFxJOKOhyycVMWEWqclHjAM/
         qe63DZoP6R4HzRtbMvTF0aaQHKlMCkV0P6qXvuUmSoMZpFkW0PyCTpf3nKqOtuxhQ0pK
         ZuIl54UEwpUMTEzVKj1o44i6ormUdqdXWGpZkmFmMVerLbB82PD82xkAnkrxBoqsXWwO
         2WDVxvYohTRDDm+HLb+2+cBFK+A0sjIAdLrZ5WWj8+ZPRHlk5fcOtkes8ym1AM3hvJCN
         74QEDkcLRj/Yyk7QrQ8u/yCj6h6HZHS/q7sZqL+HUE0X5qlUvpJ0NUk3XtiHON7xW50I
         xLVQ==
X-Gm-Message-State: AO0yUKW8OxTc0So4o63Z/uMauQPUUd/qhXok8iosOKwuFT24Gadu4vpo
	g/Rm8p60qKBmvEDIPXsLxRamTw==
X-Google-Smtp-Source: AK7set8Moq8n0zc6V1xmmUneG1NxstA85I4Vn/TRy5EEB/7hnIYvN8eu2kK+3iSaCeF6YF3ViKlNww==
X-Received: by 2002:a05:6602:381b:b0:74c:9cc4:647 with SMTP id bb27-20020a056602381b00b0074c9cc40647mr700120iob.1.1679355466696;
        Mon, 20 Mar 2023 16:37:46 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p36-20020a056638192400b004062f11d2d9sm3567013jal.130.2023.03.20.16.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 16:37:46 -0700 (PDT)
Message-ID: <bc19a75a-3c1a-db02-155b-193fd400e9aa@linuxfoundation.org>
Date: Mon, 20 Mar 2023 17:37:45 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.4 00/60] 5.4.238-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/23 08:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.238 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.238-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

