Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BDA18AE0
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 22:20:55 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6584553892cso1144209b3a.0
        for <patches@lists.linux.dev>; Mon, 12 Jun 2023 15:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1686608455; x=1689200455;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BOwPkRnj0a3PFj3/ABjurFLJ13yHy4X6H2letubj6Tc=;
        b=FVb62amnTOscjxGHR7Xsf1KyYoJz2Cnz07bNZuJ4beo/wYwVzIxJPERqFBwSlJ+uJ3
         fBn1/nyspXNTg0uRY4YFX0o6aOLCd6MphUUMJjr1Q/JJZ6IdDoc1z83ir6IDx+AIF6sZ
         +R2ia5+3YFAJyNEQimIRkS0DuM/1JOI/Z+J2c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686608455; x=1689200455;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BOwPkRnj0a3PFj3/ABjurFLJ13yHy4X6H2letubj6Tc=;
        b=ZdE/fr24j26kxVZhwATR85QOKffkDY4eOzXHP1siXa1TkaK/g7tmgMlBlQAm7zkr0u
         CFgoo0JFlh6OFPWcwnTHxQ1n9OVhghVwHNonRN5Z4Jgnn7IAXcn7TekSFnusXuNpoTjN
         mNL0BwE0av/uFN0eK8l8AsmmENWq4f03HjrpPhDFkW0TxJnekXhQMGnHWZx3XqXW1php
         ucLe6t2iVEQ+g0NfX5I8RRf1tcTjb4lO+ZD5H5etvlY/ARnXn1E/+r2En+YMo5bNbqSU
         yBijWAW2uHCjxDweuG1IxI83kKQRN+5ZpsSv4j4TRbs+Al7HmTVOoNKmDZnGwp3W2JAK
         kaEw==
X-Gm-Message-State: AC+VfDx1OsUZ63gzXiIFCqRiUPH9jUf/3bn6eC0Q/gLi+K+Pnh8A5pNV
	jd/HFh6GC4AgGpKg7VRM8FAirQ==
X-Google-Smtp-Source: ACHHUZ5UBuCT8z71f85BHAqgRU97eprvZncKWLSUCI66wSvka/j4eyECqcmtyi/Kfr1Jj20JLOTdnQ==
X-Received: by 2002:a05:6a20:7da6:b0:11b:3e33:d2f7 with SMTP id v38-20020a056a207da600b0011b3e33d2f7mr4007558pzj.0.1686608455480;
        Mon, 12 Jun 2023 15:20:55 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id f27-20020a02cadb000000b00416789bfd70sm3054788jap.1.2023.06.12.15.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 15:20:55 -0700 (PDT)
Message-ID: <225a4834-fc8f-21c0-fea6-9a7bad29d2fa@linuxfoundation.org>
Date: Mon, 12 Jun 2023 16:20:54 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.4 00/45] 5.4.247-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230612101654.644983109@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230612101654.644983109@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/23 04:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.247 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.247-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
