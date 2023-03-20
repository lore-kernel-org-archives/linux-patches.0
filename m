Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE7A7B
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 23:04:15 +0000 (UTC)
Received: by mail-io1-f48.google.com with SMTP id h2so2980953iow.0
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 16:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1679353454;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+yUZjR/qMJXhLe/J3/juEcp+ow37U+EJGerSZ99l/M8=;
        b=M5xX1vVFGXpdmwonnZsBel68/KmGTna+nV1/sEkix5WjqyckVYhqzPt++KEvWoruWb
         b3jN1dk1o/dnO2+PJD4yydMG+ffei9JmdnSUeEqxY8+tHLnUWIUYN3D/1FPgmipPQUEC
         mhqR4rMO63F3EYiDiFPKy6KdADejymoPMfShA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679353454;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+yUZjR/qMJXhLe/J3/juEcp+ow37U+EJGerSZ99l/M8=;
        b=azbSb8S8HFm0jffxOmpQ8Zr1M9cAdd5JRIwtV3BCRe4BsWgQPprc2tD9/S/fnL/LA5
         8A3eunE1FDZElSeqX72Z10/o8bVhKg8CcwP7QW44HjS47SDs5MFThhEXCd+q+Q/3bhCg
         7QIKLjvkvc9IsJo1wac9rLDsYjBZWq2fUZD9cTiKOcB7AwqPfmoL/yAliETXEjaulTnU
         D72UEZnE4b9gQ79kgg4OESaaBau+p3bJg9QpaArY75gFV6W1ZfDWpVHY5TkonZJIemnn
         qQvKJuCrjeSl/sO6LzYSs64MTZp/hYsjFv8kosQWSB/nFFlVo5mtoSQOgiE3D8KJjpOc
         RSrQ==
X-Gm-Message-State: AO0yUKV8lS/G4KNBPVu3tu/o43wash6WP7BucMWDP+z+851l3bZOgy29
	OTzvELtkmBGZ+evHz+Bd0Rt+ng==
X-Google-Smtp-Source: AK7set8FRrJRIFI2f9vGCO2q/0xoYAKI0RO3PmBHifIG/3tMLnp2titgv9yXro8S4Zb6MB3lpk9kFQ==
X-Received: by 2002:a05:6602:2b95:b0:751:d1c9:92bc with SMTP id r21-20020a0566022b9500b00751d1c992bcmr639690iov.1.1679353454249;
        Mon, 20 Mar 2023 16:04:14 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c11-20020a023f4b000000b003c449a192cdsm3496941jaf.73.2023.03.20.16.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 16:04:14 -0700 (PDT)
Message-ID: <de25435c-8478-7d4b-a09f-26294168b729@linuxfoundation.org>
Date: Mon, 20 Mar 2023 17:04:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/23 08:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.21-rc1.gz
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
