Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3147B2770A
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 21:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fW1J5Bus"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7a2874d2820so61379039f.1
        for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1697491772; x=1698096572; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HU6bIZBhi8i2WibR+y6k+ai10NOUUy9bmJLqs7d2ouM=;
        b=fW1J5BusQzwcScrp3fIHhnpgpMaJrb0039yB/CZMavA5wL9pEjiD51TNt6lJM6EX/h
         FntVM8YR0wHKgD7xWI4P5b2sRsxvBZDqnotjImB2FogtxP5TgCoUEOKmnzoGzHPGq2nw
         CajjKv/3ayDav96G2p3/ax0QH723XynrYap8E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697491772; x=1698096572;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HU6bIZBhi8i2WibR+y6k+ai10NOUUy9bmJLqs7d2ouM=;
        b=Oe3znsyafI8iPT0krjBUz0RLoY01qlai80oXnlmtOgDGZiCh2oiH1vvj4ueMD7GGO1
         igpIdJcIYrAAWMGEgB55XKCoYwaN8lqkFf9fwUCgL8/3UdFE0DZxDMz1P+1LB6x7F8/i
         GGHTCgqT+QiU1paOnPNgjjpzLC34y0m9aqqRL1QDbzbCM19I2MGC2sumNzwpRuy+UQDf
         EGIw4pQhO3C1W8xoWXo36gOOLHFuzls7EhCM762RUJnq8kZAt0me1woCGwHX1mzqEyAH
         WeX6EYa0IxQbBMevQEtq3+ED/O1f59meghMPy0RrIGkcjVf+HO9EL4hSolNIlGuaCet+
         60Eg==
X-Gm-Message-State: AOJu0YyZ8Nnow4nNzLE1OnExPv2sFrecA8CLjsy5U0KHvAesd6hF1oFC
	2zatsMa43UuEwlYU+QoZqZ+S1g==
X-Google-Smtp-Source: AGHT+IFxb3vyzjYTa1G5fOh2PN6iZFgXoJJOqvW8aozl3/Gsg4KT86tYe7aAO0iisPm/+3gsC/Z+tQ==
X-Received: by 2002:a05:6602:340f:b0:790:958e:a667 with SMTP id n15-20020a056602340f00b00790958ea667mr505494ioz.2.1697491772257;
        Mon, 16 Oct 2023 14:29:32 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id m9-20020a0566380dc900b0042bb1c9b59csm53403jaj.126.2023.10.16.14.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 14:29:31 -0700 (PDT)
Message-ID: <70f9dc29-aaf1-4626-b478-87c899f267bf@linuxfoundation.org>
Date: Mon, 16 Oct 2023 15:29:31 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.5 000/191] 6.5.8-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/23 02:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.8 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Oct 2023 08:39:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
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

