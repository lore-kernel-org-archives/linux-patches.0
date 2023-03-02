Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C18EEA1
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 01:48:42 +0000 (UTC)
Received: by mail-io1-f41.google.com with SMTP id k17so954879iob.1
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 17:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677721721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LI9ktTm0KAROfKF+Tom49bo5EIIc3UNFtFo5FidgKv4=;
        b=EXm7q/w3WIA/IVlRBLgD33z8jF6s+CSYYB5aCHm3zDGtZf3MGjK2ECk2IL5YzxCnu+
         FTx9bVN/jce0Pqaj+P3BNay1BGzI1ELULYHdJ5LpkkghCEc7AbhkeQ26HetJgDgwz4/r
         jMSyh64zUHBUWzXEty/pkQtRZFaovNJhKPq8E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677721721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LI9ktTm0KAROfKF+Tom49bo5EIIc3UNFtFo5FidgKv4=;
        b=JGReByQgXNO3SMAMQU7TwNOmifgP9KFU/PEiqRukJ1M64cjli1JXE6B1RKEqIWQzvs
         xRLplzxGG8Ye/XBxnrvVkWhIPu1xJkM6vpmjvcbSv6mM9um2hPU8YqXoSgdO83hGb3hf
         clpyqm4a6WdL9dqif7HGD2GesM60Meai0yoD2JBKAMjpNYXH1Lwj17ojWagSSoaz16nO
         tVc/m3bLwF9bUJbEmaQcYtwMv7YaDgPWWw/WI9pDtkzhKxtT6bNB8FEa0KoX9dGqo7az
         4cDnMBCzav8/o4Fl42vUGEJBcYoCI4P01fbvRIWkX0LI8KAYJIW97+iBeTxcSKqZj5f5
         ukow==
X-Gm-Message-State: AO0yUKU9a46JC0xaM8q8oHslqKe5Gh2pBQuOzW+vvUtsxMFtlcpAFgPa
	UqetLM+XEbswTrNrSf3EQHQkH+prtkl0dPDSYF4=
X-Google-Smtp-Source: AK7set+h2Hmg2PVUhZc4ZIVCAowgVdcDj1RupIMahDS5XqhSqWrSaeoXudOk78dxiEOrYNpYK/pfzg==
X-Received: by 2002:a6b:c80b:0:b0:715:f031:a7f5 with SMTP id y11-20020a6bc80b000000b00715f031a7f5mr4751655iof.1.1677721721616;
        Wed, 01 Mar 2023 17:48:41 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id m16-20020a92cad0000000b00314007fdbc2sm4071526ilq.62.2023.03.01.17.48.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 17:48:41 -0800 (PST)
Message-ID: <80f1631a-52d9-b576-ca78-5809b74b6da5@linuxfoundation.org>
Date: Wed, 1 Mar 2023 18:48:40 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 00/19] 5.10.171-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230301180652.316428563@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/23 11:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.171 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.171-rc1.gz
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
