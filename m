Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3BF29AC
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 21:08:05 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id l15so1878531ilj.5
        for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DH4ZzMW8awqQxuBAQxxLlZXqR2ybYNBM+XjFbeeh7o0=;
        b=h8iXKK5fHOl+WByaijuCU0fFUiC4hSVkSil+oGdbQPlfFFJf8Z8u9uut/lzF+RDtai
         3rXgswpAJQYlf23//HSASL4VzGp2Q07IYk0nZQ/bjEaoCkfNBcZQ0SSk4T1GAknOiVPK
         NOvUcHExGE/iT9tTrHtmFNeVgY5lVJsNrcq4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DH4ZzMW8awqQxuBAQxxLlZXqR2ybYNBM+XjFbeeh7o0=;
        b=Ye1U0gRJOEYPgM9XR3sCUFGH6Fzjxwl1ao5PVDBMD3RfrbKqhKIt0IbLfvPS3ij/tR
         s/FgCqCPdjM9ICj8/JhJrt2e9Oug0Ymh7ea6HuqSXbBAeShO2NwgMTI/cNadyRaNxGKx
         h2igzq7wpOC+2aGIRW1jgnVfjRS9lIU+u2LoPjF7rp5yGO9Tc9Upr/PhVGl87+S3dL9V
         88Y0cuCVH+BH9kVR8oZpCetAfLc5AFCGBBuS3Iibv77bdX/xVHaHmvvOucGDploJmmyC
         TedGA4IBXczdnQ+HBcFKCTpsrYg/YPezwoF7J+estvSR7NcPrQ2CFu7+jEbQ7Ds4w43h
         wICg==
X-Gm-Message-State: AO0yUKUw+lbuqNze6I3z7QMSXACHvKtaWhqsxckoU3LUSp11hai9oMGe
	TCCa0dwZbU9Fzj14P5+dBBdEC6GL6loCHIF8
X-Google-Smtp-Source: AK7set/rSsu6jHZOW6SgU6bIYY7f72sHEmMQEZQrznjqoePVyzMyRFQ6MMSUFsMF0MWow+79XF9nJQ==
X-Received: by 2002:a05:6e02:12e1:b0:310:ff8c:6844 with SMTP id l1-20020a056e0212e100b00310ff8c6844mr464923iln.2.1675112884136;
        Mon, 30 Jan 2023 13:08:04 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id f21-20020a056638169500b0038a06a14b37sm4494841jat.103.2023.01.30.13.08.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 13:08:03 -0800 (PST)
Message-ID: <90e9f21a-5d6e-94fb-8996-46e269cc7525@linuxfoundation.org>
Date: Mon, 30 Jan 2023 14:08:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/204] 5.15.91-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/23 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.91 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.91-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
