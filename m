Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD007F
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 00:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnoBTl0b"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3593f3ef420so485045ab.1
        for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1698797558; x=1699402358; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BwcL3Ik8T32BxWkj2vJ8XwaP5u8yJv04op8qbH8gSeU=;
        b=QnoBTl0bK5vDkiSaYvBYNU/uIsTWsnNjdQGeoALlUIpUBTUtCqlQf9rRUKKI5Hxrlj
         lqUcL20GL6gIqTqTf+hc4lXNXM0pXlVeS9+0lxMchYwAQlIsdGP0wGRlHXFPnJelY3iq
         JqnDxvjK8OVW27T+3Pn772ESyXUHTDVLWZt8c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698797558; x=1699402358;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BwcL3Ik8T32BxWkj2vJ8XwaP5u8yJv04op8qbH8gSeU=;
        b=F8WB+Spa4TxgPuPnpmEerE9CqBJaZwk9IuNQXs1ROediniB9bStLBxS0wpOTGcDspR
         4UuKtdNh6OPrFrTOol0N7e7gKRm9ISRukhxMwuByuqOSzCe7fMSnxxKgIpBZZ8NePWNX
         raEOBraovJFprjyxqrpqLgua5M7a0FSEOrStTbdzNKoGuHoL9D8NGhNH7guapllwUcP5
         yAQfLRdlka9oxRO3ILTmSM8ijF2Qrp20siWq8kr1rYAGj/jLuGfKG9P9RHz/OKQvmdfF
         Ie2ELkK6q4Aflo0zTGo34wZtnRKi/zi/G8fPM+7qLMfXOZkuGcyNZoBtkY0+75ue8rRC
         wAuA==
X-Gm-Message-State: AOJu0YxJSTObRZBqII4MTTDhhmYuDcNpv9uA9GTXV4Bclwbhe80kIRG6
	/NGvg5HSAc8nKaZltapfVPS+8A==
X-Google-Smtp-Source: AGHT+IHA08hW6m8f4biMPB2WcC+NaLNCFuUv0MuE9T71mbKNniGSDZQQg031gfS6dQ6dGWPLA01YOw==
X-Received: by 2002:a92:cb11:0:b0:359:3d9a:282e with SMTP id s17-20020a92cb11000000b003593d9a282emr1831910ilo.0.1698797558113;
        Tue, 31 Oct 2023 17:12:38 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id g19-20020a92c7d3000000b003590b126f15sm134627ilk.72.2023.10.31.17.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Oct 2023 17:12:37 -0700 (PDT)
Message-ID: <66a02bbc-0679-4b32-bcef-7c108b15b346@linuxfoundation.org>
Date: Tue, 31 Oct 2023 18:12:36 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.5 000/112] 6.5.10-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/23 11:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.10 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Nov 2023 16:58:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.10-rc1.gz
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

