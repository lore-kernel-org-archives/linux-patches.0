Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18728883B
	for <patches@lists.linux.dev>; Fri, 28 Apr 2023 22:33:15 +0000 (UTC)
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-760dff4b701so2626339f.0
        for <patches@lists.linux.dev>; Fri, 28 Apr 2023 15:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1682721195; x=1685313195;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G8jNhWuB6QPfRL2uGVj0UCIlGE4abIZaUuGliYF8a2I=;
        b=V48gAT+ayqif3cVBazHQl1bU2l45V2Cs70fNluwtcAOTRecCsW5srVFbbmu7kXG5lS
         7WXsunlPU7FSGMaYDQQaLknVmfujp5PB6Or8FMmwhdQgeZCY4QYvc7+nYxnO5y+6q1v/
         X9n1/M9nJPvkyIck9q+otbXuHlQmwuuVtYncI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682721195; x=1685313195;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G8jNhWuB6QPfRL2uGVj0UCIlGE4abIZaUuGliYF8a2I=;
        b=dFPoJGaHkI17Prp+BGTNPilAnQAclzE7Xds1w9lHb2fYUnooWLeOHlwZcZfZztFWdj
         pJuKHJZ3o+cczGrJ12B8gd4d+qm+pZBT1DrqpyL2XOKZdlY72qZIfmwpsKPczKqHX4Vx
         QDFfAqP0kdLuPuA83MCo9bRnntH+O/+DZEp7mW/adzb2wC6jpjs1LE+Jbbs59UfE3HEg
         OLpgje/wGEK2Y7/fsX280mum08FStxURG/X7CKY4s5F3W46qGD6kMdCRRAOYxa3tFy8b
         t+q2OMkvTFJONRGqKRI25lNJuPE75/YTrQesVmFQcic7VHH5DvhfpMwNxyRWf1g6bO+S
         P2cg==
X-Gm-Message-State: AC+VfDwq/doOzY/fuwFSzI90fX3+17Z2sdRnCCnDxriYqU4aHI4sPPnE
	NgUpsln7Lm7NSLhODH7uY78sNw==
X-Google-Smtp-Source: ACHHUZ5i6Ry0f1tvWmLo0dYlF6FrrdM/f8TEuP6XPURp6wNHyiLrdXxbcBuQbdy/oNZPWvK9rgGiag==
X-Received: by 2002:a92:cd82:0:b0:32c:a864:6eb3 with SMTP id r2-20020a92cd82000000b0032ca8646eb3mr3645130ilb.1.1682721195091;
        Fri, 28 Apr 2023 15:33:15 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x6-20020a029486000000b0040da7ae3ef9sm6758782jah.100.2023.04.28.15.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 15:33:14 -0700 (PDT)
Message-ID: <9c7ca752-e11e-2aaa-0362-28d5c195e549@linuxfoundation.org>
Date: Fri, 28 Apr 2023 16:33:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.15 00/13] 5.15.110-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230428112039.133978540@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230428112039.133978540@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/28/23 05:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.110 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Apr 2023 11:20:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.110-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
