Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B25D625
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 00:43:39 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-77dcff76e35so51729839f.1
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 17:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1692060218; x=1692665018;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DAYgtqtFlXMuanMt0aSeLkbo2rdSbbquu73bSO8WpXY=;
        b=aQ9zDIL3heW76oPbXcDCX7exO8ID4/xypFluVNeHftImJRQXkmf7NeLA21FzdfdA2i
         mBhYHLwCYTgbrr11Mw8iHFEGaneqgA13l4TdW9hN3K4IbVmMvjx6XluknR+CeUMHrbyT
         J8DQslafGUSAW4kDpkqQzakN3sL4G2hN+LR1I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692060218; x=1692665018;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DAYgtqtFlXMuanMt0aSeLkbo2rdSbbquu73bSO8WpXY=;
        b=ih/RdcgqVsHTKqqzKZlwqUNe4zskpYpZaIt6qzxAnV5QS5YeWKT9vdMh2qvr+ve3g0
         2MSBla8KjUl+Q9Pcfkp713JKn7Auztos474fcXGMQ8jKYHhudhfo9XAHJ71m5QYtc5Kr
         4e89r1PQ6ZreBTn5EFW5jbFh3ZiyeDBJcmzPTJTl66txIJmAxhuCALsaVdBvyMehnEIv
         Xd1AG2d/aM2cngfFS/v0WENMz25K7SEWGYvDaXjNBVdOMpebUIksP+3EaYOV7+9Dzx+5
         Jl3dRGlugYMLeSAw8FVJuiDV7DlmBnuHg8NWuYUUJwd6jtJ9qotAJlhwvlchVprBSmwS
         SB7g==
X-Gm-Message-State: AOJu0YwyX09oV4obveWKcyTaZQ1dTw+/RgNF4oz8BF6r/UFk/kRrzzgM
	BzdfDbTD+rSDSwpJtIMe1A+mTA==
X-Google-Smtp-Source: AGHT+IEk9i8MDdEc63ES7ceMJszXgiYN0a+PV/YMT1ZV1Dm+wLYaGfJ8ZvhUq/V6fWh+SQ06q2oHEg==
X-Received: by 2002:a6b:1404:0:b0:790:958e:a667 with SMTP id 4-20020a6b1404000000b00790958ea667mr14056122iou.2.1692060218666;
        Mon, 14 Aug 2023 17:43:38 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n10-20020a056638120a00b0043166f90251sm361860jas.77.2023.08.14.17.43.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 17:43:38 -0700 (PDT)
Message-ID: <44c5d828-9b47-0876-bb9f-13ec90c81285@linuxfoundation.org>
Date: Mon, 14 Aug 2023 18:43:37 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.4 000/206] 6.4.11-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/23 15:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.11 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
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
