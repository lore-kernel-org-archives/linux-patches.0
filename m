Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F38364
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 01:59:38 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id n191so250099iod.13
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 17:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PbW75S+tRPPiGdyoY3SVPUPsbPk7wXUtzpehNZARJL8=;
        b=JlFStz2Zk0UsrmExFMWCby9tveb5FxDaIvBD0LfyI3hofXqZn2f2nFBxZK101BqrCP
         XcOT8QhXuRt7e9pj/59OAiDVHEGlGeECKTo3MmLl31E+OivxAixW9C02zSb5B8GcKcPU
         Mnq7KzhUV+8AHus6x9vyqfPLobuJOt16PODKg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PbW75S+tRPPiGdyoY3SVPUPsbPk7wXUtzpehNZARJL8=;
        b=Vv8MyMuxEpS8vm97I1zFaAyUaPCVYvcA7t4SSKxx/ytWVtqJ3ARLqTNEv5D9ELtfV6
         Ceav2DLfZE7M5LH9v5DpC1ye3VgJToZXDI9bWvKLeIIWhk4MaPOnA13FEWRTwDjptmyU
         brlB7vURfoB3R09kmmV/VJUf0OBithoPtX5bORZWirtsIXbOdaawcSPxKCva4/fPkzFd
         MLFmrVmo9XMRMfyvHbgnKO7QaXCwtca1A0B8eW8o07hS9EW3ohmp5DmHMZ56J1zmb5VJ
         3TbWXPxydvloLvaTcQosfWNKlx9Hnl1JUelEd/9X8W7oWCWnsj4jHDyQ5Nmuvq3gOwsW
         7scA==
X-Gm-Message-State: ACrzQf1XFo2jYQmBySQ0UEZJFZBd0O9MXm2rrD/gCGE3VbxdMzBZxWnq
	dE9nQhl91Thk7gk3JE/OEhucGQ==
X-Google-Smtp-Source: AMsMyM5c3dycfwbkRls4PsSnfsWYdiHC1WLvxp7ggFmrJlbC3hSbBdKVyjTWwpvjnUyCS003J79Yeg==
X-Received: by 2002:a05:6638:1a8f:b0:375:1ad6:e860 with SMTP id ce15-20020a0566381a8f00b003751ad6e860mr2538742jab.191.1668045577587;
        Wed, 09 Nov 2022 17:59:37 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n2-20020a027102000000b00363ad31c149sm5284887jac.110.2022.11.09.17.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 17:59:37 -0800 (PST)
Message-ID: <613fefce-632d-be3e-30d4-d1c5a3cf2618@linuxfoundation.org>
Date: Wed, 9 Nov 2022 18:59:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4.9 00/30] 4.9.333-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20221108133326.715586431@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/22 06:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.333 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.333-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
