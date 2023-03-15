Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D5A8F79
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 23:58:29 +0000 (UTC)
Received: by mail-il1-f182.google.com with SMTP id h11so90053ild.11
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 16:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678924708;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M5n6N4Kf45DWAUdDU8gCqH2UU9H1ulFevAL57GqiUGY=;
        b=YQZ4ieHz2aKd57VRKTQ4sWESTfrAbmtJdoHpYHJ4jvtSCLizGwFyFHimUIrCdK/8/0
         FW52raga8m0fMotiasW7QR7mEzzWGNtttaNFs69zX3X6oecLaK3aBG0t4gy+sR75rAo6
         eGh1CyhhELLVhhf0Pzs8Kz9v4qC5OIzD0NAYw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678924708;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M5n6N4Kf45DWAUdDU8gCqH2UU9H1ulFevAL57GqiUGY=;
        b=NgUouEOYwoUdnpfV3gWg1Aympd96MeCerOhdS6U/Ez0rPlvgSsU9MYpbPoygmTH/8g
         ph98nSlMYCygrUmxo1pTFKEbAAo6BToH3FIlEhvH67xPNtCKlAV+Bu0l2Y+rpGS8HVFC
         pJNCRvvRC8W0Wn8QZxjrQuLXHQ/b+F2Qpo/tszC7PGIa4joTkUNhbq+5PNskvQ2i7wyZ
         AsNMphwNdqyj+zJ2jOvWEWBkPH/0WpdE2SJLptsn8Bw/I0uNB6UtiJlsB7oAAGEMjzvB
         QQTSMusldbZOjo1afXbzQ9K9NOk4fMmCno9bEwQg/omiROlj9q3n/pw5MhfTPZYH6XL8
         zWSg==
X-Gm-Message-State: AO0yUKXclwtANPbAnrNpzWmrFgncLSQiAVZDkXXBdlSZQTltTpoLBk6h
	sTyybqoAJvUQYjx5wBoUHAKeZg==
X-Google-Smtp-Source: AK7set8FwaNdZ8lL8DpYpHdbxVeHP78YybZ7hV6/c6EBv03k5UuiYpwi2muQLsae8M3A0FVnVs7Zxw==
X-Received: by 2002:a92:c547:0:b0:318:8674:be8 with SMTP id a7-20020a92c547000000b0031886740be8mr654138ilj.2.1678924708259;
        Wed, 15 Mar 2023 16:58:28 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o14-20020a056e02092e00b00313d32f8345sm1979717ilt.66.2023.03.15.16.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 16:58:28 -0700 (PDT)
Message-ID: <ceaf4aad-d6c2-a1c4-22a9-193a60f29fd6@linuxfoundation.org>
Date: Wed, 15 Mar 2023 17:58:27 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10 000/104] 5.10.175-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/23 06:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.175-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
