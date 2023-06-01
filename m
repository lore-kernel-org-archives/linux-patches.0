Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0107719E53
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 20:33:14 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-760dff4b701so3914039f.0
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 13:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1685651593; x=1688243593;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JScrV/DfmhXD4Cc+NO+/eWA9oBP4RYcaj5oTYmiq9uU=;
        b=VANfQGUPrn2LjGh3WXPaLhUGVrHeDJA1BmHsYoN+YbXi2+IsS61LorFtjzyKa6rqvf
         2vx9K4IodE8poKBarRMzSjqGOCdfU5GwHSrGe4VSMRTLxEkYa3/0pC/bjD3Hdrz6m69O
         3L87xd8ZjIwKSM+XQRgFTYYVVD3af4K7KnYsw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685651593; x=1688243593;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JScrV/DfmhXD4Cc+NO+/eWA9oBP4RYcaj5oTYmiq9uU=;
        b=ZEMr8RleWGiM2bZwZdHpOycg50aZTYUupH5eKuSNC/VDoOPaEJg8eAx6BA+oBwFFNE
         JxaUymQSHkSEIWk0RkaIrb4jAKWFGf2j4U+iyiWsqG1DMs/nXxUjRcm7RRQU9Q7TvulZ
         oMFx07b+kTcqBXoxLGdBJYOTImMPqKV1bcRN0JznhYDtmsoZ5pkGfYWb/5iRLjxKsHS2
         MofAD5YY6anNk/OFlndaWsnsBs1v59/E9m0Lnp+oHAgLTlJTNVrGiDvzkqqdFdOCDTpX
         bXK40O1Ais0UbK5L92M4PKUwNva73G67GdRiwMz/7v6Z/JTRWDlvPwT0mLKOTH6zjJB3
         qbmQ==
X-Gm-Message-State: AC+VfDyRP85Jl9DNcJbd0JLs83ng58Ac6xk8j9WIxXU7TdTjEbLAXfcg
	ph12ZnfW9A1tTS2RpaazHnSNUg==
X-Google-Smtp-Source: ACHHUZ4NNj3n/x5UEY+zKRzcFDj/gAh5g/StyAp2V6buqjdeuW86xM1qNunh1nKn56anpm08EPHwSw==
X-Received: by 2002:a05:6602:2d8b:b0:774:9337:2d4c with SMTP id k11-20020a0566022d8b00b0077493372d4cmr8449059iow.1.1685651593717;
        Thu, 01 Jun 2023 13:33:13 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id cs22-20020a056638471600b003e8a17d7b1fsm2571360jab.27.2023.06.01.13.33.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 13:33:13 -0700 (PDT)
Message-ID: <24603c92-1736-4691-435a-958a30d4b7d2@linuxfoundation.org>
Date: Thu, 1 Jun 2023 14:33:12 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.1 00/42] 6.1.32-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230601131939.051934720@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230601131939.051934720@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/1/23 07:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.32 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 13:19:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.32-rc1.gz
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
