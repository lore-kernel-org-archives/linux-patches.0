Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E4C7475
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 00:01:14 +0000 (UTC)
Received: by mail-il1-f170.google.com with SMTP id m15so4257554ilq.2
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 16:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KbJTu29H5LvMjbV+S5IPZzSW//JIIKSY3hH244NoMMQ=;
        b=KC/MBA066kXBOQ2o0ovBrA6dE7qLxhU/B8MxcfeuldOpCcNxBgNdcdA7B7pIwHjtWU
         xNfH54org6aMAvAEFciT4IPIk7z82tXPwMyq2EMa/eMIfxseVBd2csGbeAEEiUlHRfpf
         Jx4OcSDwiSB5ExI4q/EOcGTifjskPE7l46vxE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KbJTu29H5LvMjbV+S5IPZzSW//JIIKSY3hH244NoMMQ=;
        b=uWUL5FzRidbIp3z0C1rv93sD+xZozmd4ESH89ww616ksBD1OGnBmxElj6WfhusV/9c
         04BUDc/mm/qT+VtLe9tqsfcsvCCayD8liJBseyR/Aj4PbxEOdfYdlF9PtfNijRLAfJdZ
         UmFd1sl49HY3ORRmmoY2zeBSRrmmJTgeMg5qMXEZBXAx2d4fwM42iqkFzrR+2m8LG/2D
         g0EbrFFXyAZQ0hKqEjRzq5cuP41x8qsZb3ZNlMeAiUMhsFfLJJxYMjg0lD1DCmuKPrE8
         MmF2t6Z9FjsgiyncqHHBMaCn70S11yW7+jLgYJ2w08x389OiuMIIrJweIfEeLCYROUO6
         UPZA==
X-Gm-Message-State: ANoB5pks2toP3PcPOXHmZZV4Ad1DCPP2gSgi5yrk+yj3kIa9F3Ys5cy4
	eCVooPmSHMQuI517bvM6T23NXA==
X-Google-Smtp-Source: AA0mqf5lqFQO25Cz//TqyNNlbuqhDhkvB6Ibz7RaIoHWjCtc2/7uzFtg1xTZHYww4qwkKBKg9uaW2A==
X-Received: by 2002:a05:6e02:1a27:b0:304:b2dc:4274 with SMTP id g7-20020a056e021a2700b00304b2dc4274mr1287317ile.3.1670889674015;
        Mon, 12 Dec 2022 16:01:14 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x8-20020a026f08000000b0038a56fc3ca9sm359246jab.124.2022.12.12.16.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 16:01:13 -0800 (PST)
Message-ID: <59eebbf4-a706-7867-4edb-33e83e92a5d0@linuxfoundation.org>
Date: Mon, 12 Dec 2022 17:01:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/22 06:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.159 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.159-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
