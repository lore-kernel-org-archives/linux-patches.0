Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4ED7E
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 01:46:08 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id iw3so29879943plb.6
        for <patches@lists.linux.dev>; Mon, 03 Apr 2023 18:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680572768; x=1683164768;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TKc+EYx7SwEU6/Vyls1s2GPepAFxHA/QgAomLsWmEzI=;
        b=KVhv0/uzhPIcfjRUIbVX/qmG88E8gr8GAfn7UA5ccwrxjmTtnFNeEenhB1ynKvv9/+
         aT0RnSdTEB+pAUFqnFFiTDjXhDaJW+9I+1VX0PmkODRazjswWQpRelBWbla2ZRTEg7a5
         C4K6VB2WFem20bDLNRZEoiPNcCTaQJqwFh2pMz6nLPyyO14nyh14Y1uvr+MY7EBpZHE6
         WpY/RHiGugQ7Xp3wVRQ9eM/kI5pkmFBgqoNouDb41eJxWXtFOBXGguxdYPn+RpnYjHzd
         a6ZxR08qsfh22yTr+lNLRzY9VAWkw/JdoEmkX6pEloOREsIC5gVaEkuCPnjRs+zafa+h
         X8Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680572768; x=1683164768;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TKc+EYx7SwEU6/Vyls1s2GPepAFxHA/QgAomLsWmEzI=;
        b=3QmtO6tH4r4J2J0kFR4jNJna3CI2rR6tNk6u+yT+/ODNNrVCXQLJ/rHV44U/jmiYBy
         DNIYtf9ecrL8f79kWaaTP78q2Dwgp0Rtm6BWLeUW4rCz/8doSJfdrdtBm9EpoeWdx9+s
         kv46us3I3/bQaekw56ygW3tv+kVAhEfObcSxcDQgCoW51woVRfF1YgmvlyujcAfIa5Y4
         yLpF1le/HVw6CJGVTNdHnSUeoDWFF2vm34Qms3Gu9hdzGC+2RQB/Fwbb5sB+ecxNaOEC
         vVQQSkt9811XktdzG1hwz8O6UtlXSLd7JKfJIIg2X9z/S+nkv6CV/CwzcIsmEnYZj2i5
         RN2g==
X-Gm-Message-State: AAQBX9fZN55ty7qeVJ5SkgFv8oQYmk/gJSpj6tPuCK/599jTiklTdKfc
	xAR4aMUZtC3xbPl3zna2L4s=
X-Google-Smtp-Source: AKy350YloTfDcwXsjgzsf/hxAZHDhEOEPl7uvuNDiA/ljjv3lzuY6HBD85oP6HUWQSFKkiV5u9IHCA==
X-Received: by 2002:a17:903:2803:b0:1a2:7d:17f2 with SMTP id kp3-20020a170903280300b001a2007d17f2mr788467plb.69.1680572768004;
        Mon, 03 Apr 2023 18:46:08 -0700 (PDT)
Received: from [10.230.29.214] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z12-20020a170902834c00b0019ac9c4f32esm7138071pln.309.2023.04.03.18.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 18:46:07 -0700 (PDT)
Message-ID: <213a416f-3182-a4a6-7640-c8a385d91d68@gmail.com>
Date: Mon, 3 Apr 2023 18:46:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 5.10 000/173] 5.10.177-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230403140414.174516815@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/3/2023 7:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.177 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.177-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
