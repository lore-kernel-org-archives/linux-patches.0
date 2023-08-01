Received: from mail-io1-f66.google.com (mail-io1-f66.google.com [209.85.166.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28B24DC89
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 20:08:43 +0000 (UTC)
Received: by mail-io1-f66.google.com with SMTP id ca18e2360f4ac-77dcff76e35so73439239f.1
        for <patches@lists.linux.dev>; Tue, 01 Aug 2023 13:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1690920522; x=1691525322;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hJWk/08ykvlArnbaiiPJv/MrXaekrWWFTI2d28oOw9A=;
        b=L/5ovkUyagKpcZSUhKykWeslxFnBh4iKCZVzSU0dUt7GoF7wnshiMY21AYc75rmLn5
         X080x8ndHe9JgHpM/Y76jyS0bIYKDWoXpcwwMUlSyP2+vYDWHxgcIkB3qaOpNsNR2Ktt
         rsBKIIXELrmYU5PSeiR2LBcLKPF76jGpH3pQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690920522; x=1691525322;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hJWk/08ykvlArnbaiiPJv/MrXaekrWWFTI2d28oOw9A=;
        b=BgRQ51ifgRpN+g7lHIdqHqjo+Jv5qDJDQtbQaSBYaOUYQbg0RzBIFLf+puaOGlldck
         0EWtKmQzPV0WFNtyWC8+z7rbY0B9TodtMB//vIfw8thPH7lZc7c5mkgbvyAt9HgiaUNl
         FXIWWIPGfbtJYjF+J3XivKdWyqVfh/5AalZP2Lh56j0BsmLl0LuI08Igz3djiaj8WOTx
         s5tMcqddy52eD6yS2Xc2DFyXD/mTeIJbEtOe3a7h9e0zbTxIRc6gijTbKb41HCTgznw4
         hQ/ggBUXYKz7U/YHKyHR79kdjCWADoiiDrgzMr/e5QU2GlnbyxENQKq1ybfFs+RsptWc
         mlag==
X-Gm-Message-State: ABy/qLbS2SsRP2i2tdXp4IofHzuZM2KQwbv0LamzRp1Hl/o4WRL2M7gK
	+s13aTUdWWiwhK+2Fzc5lddz0g==
X-Google-Smtp-Source: APBJJlEpDqBHD3fGrxb6cgw5TGR2+VWOGlEw24TNEFcPIC9wdrhEWZd1+XxYkF0V0kQF2DSOVUoq8Q==
X-Received: by 2002:a92:cd05:0:b0:345:e438:7381 with SMTP id z5-20020a92cd05000000b00345e4387381mr10710318iln.2.1690920522676;
        Tue, 01 Aug 2023 13:08:42 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s7-20020a92cb07000000b003487840f1d3sm4030572ilo.50.2023.08.01.13.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 13:08:42 -0700 (PDT)
Message-ID: <6b7b32b3-3c52-23ec-3c93-984170a42ba3@linuxfoundation.org>
Date: Tue, 1 Aug 2023 14:08:41 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.1 000/228] 6.1.43-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/1/23 03:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.43 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Aug 2023 09:18:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.43-rc1.gz
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
