Received: from mail-il1-f193.google.com (mail-il1-f193.google.com [209.85.166.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D65C1F186
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 20:23:53 +0000 (UTC)
Received: by mail-il1-f193.google.com with SMTP id e9e14a558f8ab-34770dd0b4eso5925625ab.0
        for <patches@lists.linux.dev>; Tue, 25 Jul 2023 13:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1690316632; x=1690921432;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ekXDyu2W+pCKzA6ZAQknA6XM9JTHKiWVdWhsFDDvJUA=;
        b=QboRsgZykf/WnZjlKNFIN/S2pglH2OzfBn/nsy42tx+qUli5k6sEBISiUnQXfCbAuw
         z69x9S67FxlW7gseYBqznVOtt/S1w2cyuzBosY50bZ3WYntpUFv4+j4JzW2dKxFyH7kS
         BQmO9NK17KswAr66QwyyOsFuP7EqdfWX1qjKE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690316632; x=1690921432;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ekXDyu2W+pCKzA6ZAQknA6XM9JTHKiWVdWhsFDDvJUA=;
        b=CoESv0KJ4Tw+xpWMrIEJzyWx83a6aobKex8TXLM4/tKpsFtVE9+KDMTmDMvCpZ1MqN
         O5ojxCQECDLDhuJsSka3RlhyUx2+qOvj+HDBYHl4Kife1P19OaaFORufg6sb3+CKt0ho
         4o6utJrCuTMc79dwcMEUv1CUiaZCgyAXppBM0bmH1marG0XM90vPWzoCXpwPW85umqzc
         jocPYmdbzlJZMp3xtmwCM41IZ5O0h7qTnmr/NrgklNTjbo+/p1SUqmsOh2Oi3U9GJPT9
         5jNjbKTQ9TKGiTPq4Opz7ZTe0zDqZ/joAIgkxqGrj2uWuvZ0GnHTycUqI8Mpt8yGjHCc
         rG/A==
X-Gm-Message-State: ABy/qLaBPx3Cs2XcAAYrhZSuHflW7kLEXWxhTGltsZGIbbnb6XOFGy0I
	JVrvNjOQCnnj59JjzyebKAtkfU39VkT0rADCetTS0DAs
X-Google-Smtp-Source: APBJJlFawHnEv9Uo5PwnXb9VgmrQbNuvCV5tcjp+P1JlUsIYrHnf20uurj9FhnExYC5nCVWA284fLg==
X-Received: by 2002:a05:6602:14d2:b0:783:6ec1:65f6 with SMTP id b18-20020a05660214d200b007836ec165f6mr16017816iow.1.1690316632219;
        Tue, 25 Jul 2023 13:23:52 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id m22-20020a02c896000000b0042b37dda71asm3609505jao.136.2023.07.25.13.23.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 13:23:52 -0700 (PDT)
Message-ID: <2f5942e6-8f10-e785-bdce-f1ce4bb1f131@linuxfoundation.org>
Date: Tue, 25 Jul 2023 14:23:51 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.4 000/313] 5.4.251-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/23 04:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.251 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.251-rc1.gz
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
