Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470FCA937
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 23:52:54 +0000 (UTC)
Received: by mail-il1-f171.google.com with SMTP id x6so2743740ilm.11
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 15:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JtxbGmpRXGP5UT9vivOAauqxrXOfSxdlO9oNFYJkrvU=;
        b=VeYVI3vOli00dAdnbyDsGIOz0PzOTmTxOr2wosdBOkL7d2QGbVl58hxpQbIPw5FDMj
         Z2pldzCxEIgxcV4w3eDwJ2Hzu65PujM3TMWtLoBhxBjcAlsTQuLBUD0FOBYwerCSk+rB
         md38G5IX3EOD8cue9hcTWywwz2p8ePJYMIgJU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JtxbGmpRXGP5UT9vivOAauqxrXOfSxdlO9oNFYJkrvU=;
        b=k03vor7pHuz7iYBiqomhpQaT3Kna9AEeqqxiBrtUwC8i/rW8rlcRfwt/VhKM3HImjA
         nA3UeVtE34r+M4nQ8inhGIix7WwBZS7YPAPWWskLlV+WYgrIQQVb1Ru2rzNvZ1QFiObF
         FD6KIRPtsp60bapF61Vpx5GE/kMy4aeOGDbp7x/Is8XopMBjUWwetFzJM0QjAIIZV+qt
         2YEJLhetaDSsxNuZ26aTTz3ToWYMxXML4G6VnutAHqyma3PVtfUyi87C1/gSkRtTKB30
         /j/tuCyDh3TgfJxH0hkM5zIomG3qFEC9WwxI42syCxsPYEC4MtpgN9vwjqjDDxysHPsO
         DzjA==
X-Gm-Message-State: AO0yUKVG0lnNQ4KMpP8P1E+BnU025r7Ba9Hws+ZmhYriPgOZxj5pO6WO
	Mt+jeI68o8GItlodb3nrRpNslQ==
X-Google-Smtp-Source: AK7set/JE+8ksW+C5Uh7uxrvoQ8I21RBYceGnUP6xDBNQzjMl8gph078tMFbjEeysOHvvBFnTxJR/g==
X-Received: by 2002:a05:6e02:174f:b0:315:e673:e7d6 with SMTP id y15-20020a056e02174f00b00315e673e7d6mr4135976ill.0.1677023573217;
        Tue, 21 Feb 2023 15:52:53 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r5-20020a02c845000000b003c4f7c419dasm1678549jao.128.2023.02.21.15.52.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 15:52:52 -0800 (PST)
Message-ID: <4e0583d2-d7d1-9e35-37c7-34c9a64b3707@linuxfoundation.org>
Date: Tue, 21 Feb 2023 16:52:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 000/156] 5.4.232-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/23 06:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.232 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.232-rc1.gz
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
