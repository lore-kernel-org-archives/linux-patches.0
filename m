Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA3710FF
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 00:55:44 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id g16so2798063ilr.1
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 16:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0pGOmD8iOI8HzwsY4SW9Fn2GAWMZfMvtWAKvd+ESNNg=;
        b=UBeG1iP/p20mEMf6AW4qQrHb3dgSXelmFPpyEWBBc22fYrnLuWN9tSk7FUQw965Iqt
         JWlm2CQXAxspSwPaAFxT6EL193tw3FefP+qLX5Kn/9UVCdSGXSxkVVfBqOAYj9Sa/+qC
         tiouERz/4hWM2dbWLO/Ucu7JU2/DtaZVE0VjI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0pGOmD8iOI8HzwsY4SW9Fn2GAWMZfMvtWAKvd+ESNNg=;
        b=Igg4gBlQnwf91IPDGefRS4blHItPdN6WgTVwTjFUxCU84Fh/it2K/qkDaIEbtrSGP6
         8Hjpgzcsf++AN4wyFPizGq0rTbVf8PcMY3BfLhD2BKmUCbYAInr/wVPHZ2B7hr2xbVlz
         DrvFcOZPNgaqKJzvwt9S9b6HQEhOY1k2uryzu+oDqllGGFAMkNQ2w34awSwA1SPLmeN8
         c2mhXcczOc8fDirMsgRykrRLmlIp5vvMO1FuZK0SVCtVg4q9xhfl+UkC23yQlrvcKBLm
         4evUZGx3nDykKrkUA7H/8dkMG5w3m6Wyf9EN1WaaNgL6p6IyMPb/DEpppV0pvwz0d8YQ
         dQlg==
X-Gm-Message-State: AO0yUKVwrstWsYxTjsiRRWEb3nGs/mxquBLzZ4QmEszgqbN7FXaiZarH
	CDeuyXKFeUpMnDLokPlNly92zw==
X-Google-Smtp-Source: AK7set/Hf/NYzhVNqxYJuB4Wqt3JA9vNvTCYKWTCwV4HUaPrzsbOxWMVVaUsfJnZHx5AlsR/jSdTvQ==
X-Received: by 2002:a05:6e02:110f:b0:30e:f89b:6652 with SMTP id u15-20020a056e02110f00b0030ef89b6652mr5836124ilk.0.1675472143182;
        Fri, 03 Feb 2023 16:55:43 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id y12-20020a056e021bec00b0030f46602063sm1243053ilv.2.2023.02.03.16.55.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 16:55:42 -0800 (PST)
Message-ID: <2cde807a-7661-6311-ed96-7b510f286319@linuxfoundation.org>
Date: Fri, 3 Feb 2023 17:55:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 0/9] 5.10.167-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230203101006.422534094@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230203101006.422534094@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/23 03:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.167 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.167-rc1.gz
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

