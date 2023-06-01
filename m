Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E0123DF
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 20:27:05 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3357fc32a31so36825ab.1
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 13:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1685651224; x=1688243224;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QWBKQP7vVkJhhBssZg4awleL2zGJW9kgrjr0/VfEE8k=;
        b=cWBGFQpN/mtiiE0qRp0NzVkvAC9GFTramLfyxZv5vxQ8dm9SrCS2C3hnG0Iys/eiLO
         707L5uSmdZhe0xS28D2gJg2eW8W/ULeHjPs3oR+j6dbfv/jxqgf/qRGIL471Sj+EtQ4E
         VZAL0Y6J/QWrpoGjFph3vDqdWeHQGI9ZJTS24=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685651224; x=1688243224;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QWBKQP7vVkJhhBssZg4awleL2zGJW9kgrjr0/VfEE8k=;
        b=jv43T464zPyTUwWwjBQxBNJF7EYKerFPyyRif7MQZ220FQIQPQwAveoyW0Fuc9lIdE
         ydVKuIZdVw8VOKf6f+du12DEWT7QIRy0tMafTe/VGkdZ+eMPDrfFE2+zL/QWXv02EWsM
         to0IaUEjlZcaICem9aEOVympOj0XsCuMQ4qPbVLKAZfneeJmcrsOJfzHjrRQ1aMw+a4F
         6l8702ss1BuHhCz4mYqgjLWQVJo8LBOYMvKng7FSMNzuHl3T3X957QawxChH5r1Pz5zm
         YUUEsfIenVIybP58hN9ci985Ix01iOW4yvKJoWMxIZrPDOTlOyz/ZoO7x2Q8EKXLqkjD
         +Kcw==
X-Gm-Message-State: AC+VfDxID2HYl4G2bbEMK30b+53b16b5inyKeq0PlTPWOUGsw2wnkcl4
	+mm6DebQo0w73OPyswaaOC1NCw==
X-Google-Smtp-Source: ACHHUZ6JlTDpujIStID5N1PWmlkzLws2U6mW19OXDwAS09wixvCF06e5l9QOZwBFKp5eTDQEbl7AGg==
X-Received: by 2002:a05:6602:2c49:b0:76c:5c79:81bf with SMTP id x9-20020a0566022c4900b0076c5c7981bfmr6465399iov.2.1685651224704;
        Thu, 01 Jun 2023 13:27:04 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id g186-20020a025bc3000000b0041643b78cbesm2547800jab.120.2023.06.01.13.27.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 13:27:04 -0700 (PDT)
Message-ID: <0fa8408e-81d6-db13-4f97-c975a4647aac@linuxfoundation.org>
Date: Thu, 1 Jun 2023 14:27:03 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.3 00/45] 6.3.6-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230601131938.702671708@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230601131938.702671708@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/1/23 07:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.6 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 13:19:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
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
