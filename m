Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAF58490
	for <patches@lists.linux.dev>; Thu, 15 Dec 2022 23:50:05 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id z18so500378ils.3
        for <patches@lists.linux.dev>; Thu, 15 Dec 2022 15:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SfR4cKiYRNDI8PwCEga4FkweP1vMW8KeW1ae9VEFMT8=;
        b=hEtXEt5yGYSMvMmCX1sggivIAhx5xVkfPU2c5zFsR9zA0ghrFMw5IvgXdTV+45UkE4
         LLw5tK4omPuV0L+IyJ153Qs5eqnNOaXes5KjTrjFSjdaw5e+FVGS+sKsocrAvw3JrF/n
         eNEPkcicgLwphnHEg37kcmnQ+AUrhMzGIqwoY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SfR4cKiYRNDI8PwCEga4FkweP1vMW8KeW1ae9VEFMT8=;
        b=Zxp9ziNH0pr7J22qMVcLmyXu5GRcTvYHIyzav9VhhWy3nKc4s75tlPIBNiAVRPYyYZ
         2HNH48jHJHU4eRXWIBXiXYJYFy0pijqJ6k+FXVgpyLP/d9aGX7K5ajyVSwg2cLLereLz
         2zzKf1EOm/r/jVzQTwdm9ntTcEb2EsU45oQS73rpxczVXgit4nL0GL9WqMQRUZHFQz2v
         QYng9+3N0hjO8ZAZiRiOaOEikeguN4BA+ZDP97CfNLcNB/kQxZldyPhVLJpjbnBhmV2I
         PPA8GwOfifaP8B0IEGMteo1BYnPn2scKw5Fej3OkCSbNpGfWiLEJSTYOwoCE1b2Br1TT
         7Ghg==
X-Gm-Message-State: ANoB5pkj/XCTnmpmltaXqZaBOTH8HqwEiNJ6q332wjS4tO/Hse/YPIP6
	lg68lvW4HVv5x2QJewaPGufjeg==
X-Google-Smtp-Source: AA0mqf7VfyE5+D2eyauI2p/Y2zRBsWM4cCQNgOASqdZ/r6m7NmaH0xGApzD30g+nRQ7nrW5quhTrzQ==
X-Received: by 2002:a92:cbd0:0:b0:300:4c9:f52f with SMTP id s16-20020a92cbd0000000b0030004c9f52fmr3224688ilq.0.1671148204339;
        Thu, 15 Dec 2022 15:50:04 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r14-20020a02aa0e000000b00389b6c71347sm235679jam.60.2022.12.15.15.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 15:50:03 -0800 (PST)
Message-ID: <d380ea35-668d-f553-0a07-939bda7086c2@linuxfoundation.org>
Date: Thu, 15 Dec 2022 16:50:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/15] 5.10.160-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221215172906.638553794@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/15/22 11:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.160 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.160-rc1.gz
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
