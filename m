Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E82E315AB
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 15:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQjV3GKw"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3574c225c14so7955205ab.0
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 07:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1699372530; x=1699977330; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ov71WMP8hq2Oe42YqNoTQzgfuyyeCyevcpAmAeyvKjo=;
        b=QQjV3GKwyz3AIlT0vmLK+vzloeLQC96CeagncdSXRmRgFMKb7VRsSlp54UxHU/tPJN
         pU1dL+cf5QBbouDFgI2nR5ClagxgriyZsd6KoW5nacd8gcwyNbmb8IzXVGe7WBoN39q2
         2BpqCQEfad5BI26nGUCKa9bzItxEbhqlLsJT8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699372530; x=1699977330;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ov71WMP8hq2Oe42YqNoTQzgfuyyeCyevcpAmAeyvKjo=;
        b=WFNvAlygtK2H5ahgjI6ORi6Jj1p3bnUskGW0gMbPGlhiEr91XXgsH+Moz8ZFMjIWNR
         UJ1j2OPhErOjyUqi1qpq95rA6Fc0C653xBc01BwMup25bqxmI3uXqKOscP0uYaJMxFXR
         YiqDPhLYM3EMz9Sj8BZiC5RYrl52Ka5TpibuzF5pr8mrn/HiL4zBfhnkNTpppT5gV90s
         mNNZImMozpwDaSp+Jt4ZBKXBPircoYcNAPvUdgxgdJPxhLK+T8RxkAIqigk/F68rwOeE
         jD9Pa3xi3Sxgsi0JNK1Zo/KI7KU5C1jfsR8gcMTdR2YQCd7Q+SWhKz57vV6ZB5JA29vl
         AEig==
X-Gm-Message-State: AOJu0YzWLo0M1fU4/K25D95TECF807nKKh97l7iw1FumFmQX+P0/n808
	CA6PKc/u3n4uTiK/AgLFRxb8dA==
X-Google-Smtp-Source: AGHT+IHpUt6IWE2JUKMRqzmXV+OPPfruQ0l5K8LHQVnDjzc1ZoluSa72ODUxvOteKGchzpn9GQWOpA==
X-Received: by 2002:a05:6e02:330b:b0:359:a1d7:4e2f with SMTP id bm11-20020a056e02330b00b00359a1d74e2fmr9113913ilb.3.1699372530445;
        Tue, 07 Nov 2023 07:55:30 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id m15-20020a056638224f00b004500f7a5903sm2789264jas.102.2023.11.07.07.55.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 07:55:30 -0800 (PST)
Message-ID: <efea3d00-0b3f-4f69-a3c0-94c4837c7644@linuxfoundation.org>
Date: Tue, 7 Nov 2023 08:55:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/61] 4.19.298-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231106130259.573843228@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231106130259.573843228@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/23 06:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.298 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.298-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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

