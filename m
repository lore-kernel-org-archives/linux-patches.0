Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552307F
	for <patches@lists.linux.dev>; Tue, 22 Aug 2023 14:07:34 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-34bb33a3cf4so2414035ab.0
        for <patches@lists.linux.dev>; Tue, 22 Aug 2023 07:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1692713254; x=1693318054;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NBfudvUcA90EgP90c3v1NclyXmUuNio5tYlPAp81Sm8=;
        b=Kk7aV1ur7Cvckuz/Bd9P4BhKHhmQAiMPV+fMlwGEi+SxBO46i1nlYevp+ubhEycSuA
         MftJWe25tMghZ2NeR2w/i5uPhANZRgn6QJ1N99FBB4+97S2f3O1NXPtmADQ8xwvxoTJa
         9XQvFibSYrNXk207p0x1xJLA3Ag+gyyUta74c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692713254; x=1693318054;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NBfudvUcA90EgP90c3v1NclyXmUuNio5tYlPAp81Sm8=;
        b=a3F70gRoy4Pmnr/L/okdPH8TFkexLP1UJv9R9g31S3i9brjz9zQR85JLmZA3iFeKOG
         bM+kfqxdq1Vr6MmxpppgGbKLnsDV5KOsFqlnK/TNIcHrWLGoLp9UYSQC4526bxLMjT3r
         JI0H+u8D6vXasxAteyptSyPYE7IHD7PWavo40YUIvb8NHSbBkp0GH9QAQw6QNIdisTeR
         L1p+5WX98O0aLGus0/dQGOgcFP6bKppHxniAZS0fhtVGAhoED+YvhdzXlp842aphboN8
         vijrP2vpYdxK1l4In2h9pFN/++8jv5ZQq0nuZ/Cp+znbfcZNUK/a0cEvn+T/I6T1A97P
         0x/w==
X-Gm-Message-State: AOJu0YztdeWqOWOkIFToJSPo38oLAnvinMGBfBPqyCd5Ben9RWQ92rxt
	oW0zpF4MgD0/EMWxgltuQ5ONZqFrDIry6Rapm5M=
X-Google-Smtp-Source: AGHT+IFqxwZ6HMNcGjtgurzjJ9aQjSGsn+IK8C6z2Ox189KEayPWkHyTWSET4e2Tn+VGomzJbkvxaQ==
X-Received: by 2002:a92:c6c7:0:b0:345:bdc2:eb42 with SMTP id v7-20020a92c6c7000000b00345bdc2eb42mr10961930ilm.3.1692713254147;
        Tue, 22 Aug 2023 07:07:34 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id e4-20020a926904000000b0032b72b5c1c3sm3137113ilc.9.2023.08.22.07.07.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Aug 2023 07:07:33 -0700 (PDT)
Message-ID: <362a75b9-4790-e7f0-fe13-4685e04cdecb@linuxfoundation.org>
Date: Tue, 22 Aug 2023 08:07:32 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.4 000/234] 6.4.12-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/23 13:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.12 release.
> There are 234 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Aug 2023 19:40:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
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
