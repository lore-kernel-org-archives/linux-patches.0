Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7F2174DE
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 14:25:13 +0000 (UTC)
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-34914064ea9so3143805ab.1
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 07:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1693319112; x=1693923912;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UJUbKroilkzyrqQ/wNhMzuPxZ1aCqcwh3ID9A8N21Sw=;
        b=h+kESRJR7EX2Lm3X7qOlFyuGak16wWPHO9UMMj4+e8vnSl7yh4yzTovZ3U2mWhRhG3
         d4KLUKylxTSsH2yty2CO0Q49jwyxyqiv2wcufXMoLMGThrQwig4CvDIiMloAIXoyDACg
         XhEBS0ErOzN24m/Xrg5lFlTEAT4nhG8qV0vOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693319112; x=1693923912;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UJUbKroilkzyrqQ/wNhMzuPxZ1aCqcwh3ID9A8N21Sw=;
        b=hxuKkNgWlVbT0byf2NcQhdcg+xG6H18EdHRIHd4rsCOz9iY3g4cznXhTbV7xe59LAf
         Bke48TfJtrY31dPSt20bTz+ClnDhK3ZvT0pycjs0w0BDDTb24u9PmsOkIxHXSH8zVgUF
         RETc/5FAy092PHrpxcb9SjliAzRAlO7IsTp7YXQnqHFBYlYljP4SLxVI5xjDlChczmFC
         YOYR+rxWSa0TxuIBgDEx/2zbPfpGjmFfgQRmljw8daNDmiA2k5ObL3UuJC1CA00QzQjK
         p36zq+iVedMTqRzDSkwvmJQfxqlwYPsuhXsT5vO45ellYgZP2I6z+mB7SjPUWxpn5hRV
         sflg==
X-Gm-Message-State: AOJu0YzE9PESl0XgAf5U5B6N7rcW6Nkt7tsSDKXXKvSNG5BZNLziiHAd
	e7kBA9TwsZ4pR3xxgNxAoQdXhg==
X-Google-Smtp-Source: AGHT+IGioKGtNYseqMY3QKnFM+wN6+jVP8+G9cx4AbkiotekfO41AUVYB6ybiKtuUIGn8RBVFuF+lQ==
X-Received: by 2002:a6b:c982:0:b0:792:8a08:1bf9 with SMTP id z124-20020a6bc982000000b007928a081bf9mr11373255iof.0.1693319112367;
        Tue, 29 Aug 2023 07:25:12 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id z6-20020a056638000600b0042acf389acesm3083550jao.71.2023.08.29.07.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 07:25:11 -0700 (PDT)
Message-ID: <7a4aa9cd-29dd-e1bb-3100-833e4a2df100@linuxfoundation.org>
Date: Tue, 29 Aug 2023 08:25:11 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.4 000/158] 5.4.255-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/28/23 04:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.255 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.255-rc1.gz
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
