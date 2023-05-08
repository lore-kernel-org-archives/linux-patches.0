Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342E7111BC
	for <patches@lists.linux.dev>; Mon,  8 May 2023 21:04:17 +0000 (UTC)
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-76c50ad63f1so5361739f.1
        for <patches@lists.linux.dev>; Mon, 08 May 2023 14:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1683579856; x=1686171856;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GVXgA2/yKlvvCi/fNq3LAF2WhpqNYS7jROBS62P7jtk=;
        b=bhDFKdOYBkDlJlIyfJ6oeEaUD4FXDyCIJbqbPJuK3AbN3iPZe64yXwaqtenCwnWLHI
         UfIxT/4Apv8UEl/KUkBRBsb5X7IhBAsLs8nB0ahFeBDcPG0mcnYAkW8YnUw0DBJ9e16b
         Gg4bP7dpRars8SwZgt+nS9amSCPdkyXrLWBCw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683579856; x=1686171856;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GVXgA2/yKlvvCi/fNq3LAF2WhpqNYS7jROBS62P7jtk=;
        b=QvnW57aH0uMyS63kc9gTAU7rBGukNRPB2L+/r03dv4EQEoLSKDZBlwqp3jblIrXDt3
         RCWotOmEsZ4PcVzNz1p0rkaXieRRIJobhq8UD98dSTHOunv4dwri16NR9iaoYN3sVIiE
         rqz0Egyz7RD/E1ameSKCEHfQELFR5IoSZqOPzaY66jCJP98LHlyvEgXxFNu30OpXQUUU
         tIgs59ciizZ+GHcpTLaQxK/JLqlDQpGNVXOUNeMC6PwwOAwwWG8lL2qEyXEZQAJLu1oI
         qRd8AvjB5vbkkGVtQIOHEJTL0vfjuQDEFYAWtN0fsDQFba+ykP07WcrGRZ9U5PYlLQ4O
         P6wg==
X-Gm-Message-State: AC+VfDxJ1GkCFS7NwiOhlQ81ibEPxue+FcnkMKgC26XyYHRKK23QgkYL
	vHE8ApYLXMfaQ5ZcOw+JVkwg6A==
X-Google-Smtp-Source: ACHHUZ4t04uSHpQwGrXiKWff4IIvHQkJNAdWLVy7AQ3UmpbqbOY4HE0p5FbLVqTv8NnyYz/3+mUPtw==
X-Received: by 2002:a05:6602:150c:b0:769:8d14:7d15 with SMTP id g12-20020a056602150c00b007698d147d15mr8047686iow.0.1683579856123;
        Mon, 08 May 2023 14:04:16 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k35-20020a056638372300b0040f99b59cbbsm2299330jav.166.2023.05.08.14.04.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 14:04:15 -0700 (PDT)
Message-ID: <24e0163b-b7fd-e88b-2bee-479147a91d91@linuxfoundation.org>
Date: Mon, 8 May 2023 15:04:14 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/23 03:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.2 release.
> There are 694 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 May 2023 09:42:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.2-rc1.gz
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
