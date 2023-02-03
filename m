Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CA62CA4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 18:41:59 +0000 (UTC)
Received: by mail-qt1-f181.google.com with SMTP id c2so6521410qtw.5
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 10:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cug0hlfDT36Dqw7jW/V5xSD4WJgWtg61okF6HbuI67I=;
        b=QVlAEAfi41Sh2E24X+wje0kCV9S5nVzwiYF1UyN0oKYqyI6kYUqZNp7PCls/pjdSpz
         IRbBLpHRcYcsk9yfCVwxUPBv1wgLjtQC/vivo7i2gwVFfx30NGR+QsyLdjft7yN7jDKi
         1iaOyC5ncB/B628hz5iW5J0EZiAHtaKxtC32NOEFoUduGVk5byBUDsXIguB9cnXoXIQr
         2QJKVgxu8Svx4yLSyHLos5Q+10klGsUhQsmOK+CBBvhg5ohhVPL9OwU7gUwg4CENI5Nm
         5Cny0E1BoXgl5BVxESR3az6Zdh2H4Zl/qXWOh8bOz5UJHqX+pYQJ/F7xWEkURKUT7lWa
         8d6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cug0hlfDT36Dqw7jW/V5xSD4WJgWtg61okF6HbuI67I=;
        b=JWaXGs8VC9pn/6/vTncx1tMIsFRzzV2+9alCOJ3CefUG11uIQTnGKgmCgB845hRpV8
         QEczOIglufJNetz9hFFfBl8DfwMnZE1GFlueAX6cvH1beTPlRds++ZQKgY42nQHgVxgb
         zDWOalPvxJfOiJwupUL2WFhTiLxxdW9igJ2aTTLQ31DMtvhFGjkYsTt+qMQWkDHpF5x+
         lCQJnX3dI9u3FPLHYYukVTomhIm4FnE6wblXrr4HApviB7sh4MXuf06AiOQeQeQYPuXX
         tuSCot+H7oEwJ0DrSs1S99poLfaCGl/+zMwKrLP7+z/JjUJRPSTAYJDv1R4jkuBe2aGO
         FVzw==
X-Gm-Message-State: AO0yUKXMguhGltOWwdSwjn06KwPrbw/Wrhp1C+L2fqKOKr0AkxlJuu5O
	dCxA55E4iVqUoswvFbj098Y=
X-Google-Smtp-Source: AK7set+yKBp9Lzl4KayhlSB33ocRyQjHvACLYd6X6UX7mV/n2SUrn2vJNFEpDouXWZPthOGFenA/cA==
X-Received: by 2002:ac8:5c48:0:b0:3b9:a965:7af2 with SMTP id j8-20020ac85c48000000b003b9a9657af2mr21237410qtj.45.1675449718550;
        Fri, 03 Feb 2023 10:41:58 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bk19-20020a05620a1a1300b006f9f3c0c63csm2352729qkb.32.2023.02.03.10.41.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 10:41:57 -0800 (PST)
Message-ID: <ca5b519c-c349-297c-1780-53275e0c8579@gmail.com>
Date: Fri, 3 Feb 2023 10:41:53 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230203101023.832083974@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/23 02:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.231 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.231-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

