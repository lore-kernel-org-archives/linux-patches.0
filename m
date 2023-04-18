Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AFA2904
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 16:36:58 +0000 (UTC)
Received: by mail-qv1-f45.google.com with SMTP id a15so6898261qvn.2
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 09:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681835817; x=1684427817;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hQMVNzmxnPRhXRrnZUKXabKxB7Nk3knrEnVbtcVAOP8=;
        b=VOrZYJCnwn80hQqcvXOCYGccfqhDTKL0ub4IWpYiXqwJ/RGBJYJUnxv9JgxNCeImOc
         SNwvE09BBjQ2abSV0p/eLWx+xehkNYr8ytDYZlH2QT0+5h2gz7Der05xJgEktoiT7tgD
         Pzdmjpyety12X+iS2OCc9bof/E1OXftfSg2QUbIYS2QI10s70rcjoqBmnOYD6KRHhw9o
         JFmMnFRuzqJ9VQUwig6YgKp6QLb2J9Ly1LYNYDdVCDVKmDwLTIfw9qR0jE66f0OQmReA
         5khvxksPlvw6vng6wKQ038NIrkC8xgnMEqVUud7MYlT3dDpLRE8tee5yjud1SaQcioCq
         ipXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681835817; x=1684427817;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hQMVNzmxnPRhXRrnZUKXabKxB7Nk3knrEnVbtcVAOP8=;
        b=MHwVZIhcHWCrbEaskg9k68uJ3+cBzoRHOoZAAMNzamhbCRfav+S8o8g4HW9gUnq3ul
         Us8kw5tkukStuV5hObwIrm0flKH3jUVpvbIajm9NECLZmWSK4JzEr46icz7lucXBWnie
         O0kNxMpDmOy9zCUJq7DJzY9m5sEiq9Cs9rgpbxtQUjxiHMGO/xAXsyzcyy8BElIsTzbl
         3FTKtoAlulSNKN5qnPG9SsqLmVViKxD0eujPHS50q8XeZpHDE13uUmKx85hlGdkTcEYd
         bMs3Kt1QGpw8EV61w77C774YS7CEhnXl8xj4M0bNXffHLGpmIX+y8oChoXYWs0N2d2cN
         Np8g==
X-Gm-Message-State: AAQBX9evjAjzBTnWvnGrycPx5xUd0nfTTvflKqXgmF12qHc10zJrpD8t
	jMR09xbM7LF30BIYJ1ZKwj4=
X-Google-Smtp-Source: AKy350Y/U9ti+MSNkNB4Qy3YiD8IYL4EXmxxipaFWCSPTzlw+kEQDz1DGjxWyzuJQ4gMSHpePurdhQ==
X-Received: by 2002:a05:6214:412:b0:5ef:56e4:f614 with SMTP id z18-20020a056214041200b005ef56e4f614mr26473744qvx.34.1681835817590;
        Tue, 18 Apr 2023 09:36:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ne3-20020a056214424300b005e8f61012e9sm3801692qvb.26.2023.04.18.09.36.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 09:36:56 -0700 (PDT)
Message-ID: <5e902e3b-c0aa-9d6a-0418-2e27f5081190@gmail.com>
Date: Tue, 18 Apr 2023 09:36:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.4 00/92] 5.4.241-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230418120304.658273364@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/18/2023 5:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.241 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.241-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

