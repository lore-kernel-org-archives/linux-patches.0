Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73D0450FA
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 22:19:56 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-34fcb08d1d5so1733485ab.1
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 15:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1695075595; x=1695680395; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iQtkVy0bBjiY++L4VDVGjsqSDZ1al4llsn1ovHo8nPo=;
        b=PYclM42bHdE1mxg349fgmy82NBPaWtt5P2MU1y49NUd7E1zCfTn8Dp1mAmdJNkbyLd
         5mPWuL8rjnhl8xXoRomvt8RB/Bt4kuFzE4qlaTHSYqskFGpCyD2rt9ddcT4rRmWIS5rq
         w2IrFXY9XgoOM6WPewySqb7JRB/Abz9E5qXKI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695075595; x=1695680395;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iQtkVy0bBjiY++L4VDVGjsqSDZ1al4llsn1ovHo8nPo=;
        b=qOEgXEPtMe1xz0E6NCkqkOAI7NKNy4Lv9w8N9eBMZCMWDDs6uusyT8Bq2jNQBe9HXp
         O8NKDXccnucQDRYoNi3kgVtVhfr2ANOV75KRCgTNHfiCGkW8ywssg6uKWv3Yt5byPc9h
         xxx8AdQ+KN+CE6065sSmBtI7Ku7lpkI859NRCM6ZDcxqehtrkp5yGXOovn/5r3qmqAce
         5Lvt4IeHfTUs6KGGNbBLmeZqeE3rwfQtKF9/4AS0ub4f25wxSqW20wdPufloIh6L0YFz
         gc71KeSS5i6JovLdqPj4HFOg4Gfh5Ft+2L0J06Cm1HM/EDLge5ZDf7UdEfV81V81Jtu6
         UL6Q==
X-Gm-Message-State: AOJu0YwcMEE3RPp+xDjzemD/b3IorLSdS2KcYP/UcvLNK4+OZv/Eq1+M
	fPPSPnLzVkjgd28hGkITNj2jVg==
X-Google-Smtp-Source: AGHT+IGhHG2GWoVd+m67RgtbSpgQz/v41HIUXEkQ9EnlB6GmJaiYZUTQduVR2tkiUNR1L5MrITSeCA==
X-Received: by 2002:a6b:5f1d:0:b0:792:9b50:3c3d with SMTP id t29-20020a6b5f1d000000b007929b503c3dmr11061093iob.1.1695075595589;
        Mon, 18 Sep 2023 15:19:55 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id dk19-20020a0566384bd300b004165ac64e0asm3250361jab.40.2023.09.18.15.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 15:19:54 -0700 (PDT)
Message-ID: <f5262d8f-82af-1f1d-b21f-fc95604e4b99@linuxfoundation.org>
Date: Mon, 18 Sep 2023 16:19:54 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 6.5 000/285] 6.5.4-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/23 13:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.4 release.
> There are 285 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
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

