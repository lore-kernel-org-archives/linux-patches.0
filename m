Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADB7BA3D
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 20:09:01 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id c2-20020a17090a020200b00226c762ed23so1098522pjc.5
        for <patches@lists.linux.dev>; Wed, 04 Jan 2023 12:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UMWHrF0/XfOeG1CXIwzjSceGj1ferSMxrkHipfWDqB0=;
        b=e4YVXucNPMPkk8BQv0XVWpSYCAh5IChMWylGp5stDe2ZlkO1YLf/sQG5KoSDfm7JgO
         qMTQM82bTjQ7x4+6CsfKGUSh7TiXo6ee6p6wULesgzqGys0Q2/v+nwvb2Zh8L+7MUpfb
         y8J/ri/OU7+0VdBrgnbcBv6eelz43iCqSJCHqEe/dlGZax6NYq2eM/r/FfVAqVFt5ibW
         hwuBd4MDfP7SWq/cix/ZIPEYtpfG3LSjlko50EunmdX1+tIOzjUdlmGc96GOqqUhZRwS
         B0yEJXiPtdpfFuSIPnkHjSqM1XNsNItSeC2SCtKNek/O4fdHPY0tx45GbbMecCYDZt7I
         ymPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UMWHrF0/XfOeG1CXIwzjSceGj1ferSMxrkHipfWDqB0=;
        b=VNaJhhL/bTB48yV7ue9uzFWQbAriVFpX51+e1NQXW98aJ0VupMCJLAgQNhAQX/d/dK
         HPMzhbDAE2ypI3/uUicaAkSgliZO9BnMpxhXIltx1Sv2/xtpCIpUCwih1aQm55p0AhnZ
         Dpm3u9rW5IKkv/tC9aHQUDoDUsTYWYIyBEyk1mZnMvIEVSqkIe5W/hhcblO/8RuGvHvT
         oR4vh4vMvUi98TWiRa0xJvXZVTK8syWpwhepQqG8hsltGPrSE8fFE4DtJeUdxfZB6c4p
         Lu4INts8Ce5QgDegLdfhjvYsKu1lxr+PvXsj868isWiCWEVtDKUA10TthDETqT+JNJNn
         U47Q==
X-Gm-Message-State: AFqh2kpXKzac44uZ0Ph6giBvxef43WykSCWi1e8mhCvxzrhAtYaGeEh4
	+9oY8R0mzv92DIxgP+OsxX4=
X-Google-Smtp-Source: AMrXdXvZ+bAPgOIV0REbDfAPvqzjHXbJBXtzNNRKMMwm5WRxmgk4RtO8ftfCcp7pGN6LjlLBJKsUNA==
X-Received: by 2002:a05:6a20:2d1e:b0:af:6f24:b154 with SMTP id g30-20020a056a202d1e00b000af6f24b154mr64018840pzl.60.1672862940560;
        Wed, 04 Jan 2023 12:09:00 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f8-20020a655908000000b0047829d1b8eesm21073037pgu.31.2023.01.04.12.08.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 12:08:55 -0800 (PST)
Message-ID: <d725c96e-4b74-d5c1-e25e-1876e8aa40d9@gmail.com>
Date: Wed, 4 Jan 2023 12:08:43 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/177] 6.0.18-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230104160507.635888536@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/4/23 08:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.18 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

