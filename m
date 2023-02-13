Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097DBBA31
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 23:29:58 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id o1so5125601ioo.10
        for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7Cwe8TQmFe/rUFDtgs1SxhTk4ybDkZPmjcfR526N0XU=;
        b=dKFE6QdbXx1b0hQOma4xe41AtUH7NUWmml0V1/RkULxMVEi1aSuP+oCQTXhmiBzeFe
         1ocHZUIGkF4rNfhOReOh+QdVvt+nMA0yEewAYO/MWLO/mi3URz24drdNI66uOwHx75IJ
         Cj1D2tqxp6QN94zm8sMFjwvTWJZkYrmyE+4KI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Cwe8TQmFe/rUFDtgs1SxhTk4ybDkZPmjcfR526N0XU=;
        b=o9SiQJagkg1xERR9IxmpZG5peO3k+vZIq6FQKE7Kf/2QsymnfcijaRC58MPM2exleJ
         +LSJi2zQR21dBP4SZmdGADq3QhgI4nzYQJY5WwnSi8LDezdQHeTSUD5mt7LdQcc1ATwf
         Qd2E2Vq/4JnR8nC3d2dKrGisECc+42WV9No5oKcWlpiaNry5yz4kq+7NLTV9I1IbRShC
         qz2KdzJawLVa9EAIUIwneKPvQ0WmEZwkau3vsHSDbTpnYnXsBDcSFk0RyAbIvTLUF0jj
         QeeyUGCb8+a1uY4YwsBcQm0AcRjUgsj6T5ANs0m1K+exHD2qDPL8vfFAeQgl1OFwA82n
         O0hg==
X-Gm-Message-State: AO0yUKW9hE771A6Xit51bYqI077O1c3Izc8PIK5UPTh2oAfd6eBx94fj
	evPT6U7O8l+sBsM/uv+BOxGaQA==
X-Google-Smtp-Source: AK7set/rcIla65D1El+4zWMkyPxCuk9NaXHwE1vk7xxZgfms3UrRLruERPKtkpfhLZZofRuxj1Ov3Q==
X-Received: by 2002:a05:6602:5cd:b0:73a:6c75:5a85 with SMTP id w13-20020a05660205cd00b0073a6c755a85mr174928iox.0.1676330997986;
        Mon, 13 Feb 2023 15:29:57 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i18-20020a6b3b12000000b0074065ea4c2asm194328ioa.55.2023.02.13.15.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 15:29:57 -0800 (PST)
Message-ID: <8f76fff7-626f-793a-b7c3-fdae0a3d4677@linuxfoundation.org>
Date: Mon, 13 Feb 2023 16:29:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/114] 6.1.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/23 07:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.12 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.12-rc1.gz
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
