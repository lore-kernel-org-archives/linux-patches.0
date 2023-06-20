Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB0F17FFF
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 20:17:42 +0000 (UTC)
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-77e3c55843cso37289139f.0
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 13:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1687292261; x=1689884261;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7VUNyOpD7UjHXpWrEPFOTh+iR0pIdYAc7/OPkzR6Y3s=;
        b=R1wJLNcmY/vqUNLf0V9PdKWGFzljenfA/lhmc+IDxCQ0uDZA8hA87x21I5Y6sAaV7n
         mFGNl5p5dAgZlTINvK4q3xpxpWhjZUG1WOcfAPIlWoZ29i1HidG72N28FUITN8Qk19J5
         3Am0x+aYVN99Pd+TdKO9V7urBhYx9K7+ygXpQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687292261; x=1689884261;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7VUNyOpD7UjHXpWrEPFOTh+iR0pIdYAc7/OPkzR6Y3s=;
        b=Eql8LBbkuhek76Id4WYW8ftMHdqe/SQ6BIg5kWEay6H76jgkvGEirCEmI6Y/E1f5WK
         u2GPSjAj8rbJFb04NkNyPRJJf9LrEmhBgr0cOWt/ym3EmZLZI7CgfgNV9zHFlbXE7OM/
         iksI+/v+JZSQguWbqVMaKwN99IfCTuH0V52B6KnpWFKs5RmLGBIXLH+e2woWE5LxoKGK
         uIpDB3ORec4g0tvCEqrvEN9+E2SKPqr3ZkgWFcyX8dwVvmDFKOc396tgzweE2gPXQCtf
         sQwSrwfyOuKEKGO5hoYXhaLwYEMTI50WARKeC7kkD6ULzbftwcwdQQy1chNru0FgdX9G
         j30Q==
X-Gm-Message-State: AC+VfDxsDiwsExTK37WdpKuPRpCk+ymcNkKcZor7Dd6ZXFm2onHUBVJm
	RwUHpHd3PhHPKToX7jNEVJZL2g==
X-Google-Smtp-Source: ACHHUZ4b6WI3yGdHwyFzHgt/5IhDV+v9tOmhBgvZK+Z9ydxscF2SYMrILjsbDdB/094bq/mKF+PfIA==
X-Received: by 2002:a05:6602:1a06:b0:780:ad9c:ce57 with SMTP id bo6-20020a0566021a0600b00780ad9cce57mr1279410iob.1.1687292261020;
        Tue, 20 Jun 2023 13:17:41 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c4-20020a02a604000000b0040f91082a4fsm840105jam.75.2023.06.20.13.17.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 13:17:40 -0700 (PDT)
Message-ID: <31a77b25-1ecf-eb61-4c29-e0f9efbdc1c1@linuxfoundation.org>
Date: Tue, 20 Jun 2023 14:17:39 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.3 000/187] 6.3.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/19/23 04:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.9 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.9-rc1.gz
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
