Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7366541A88
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 21:28:48 +0000 (UTC)
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-79e27406225so5422639f.1
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 14:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1695245327; x=1695850127; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+2tU7WgIdeqMFoUWsvwgrS0UpcgpoQLXurBiEI1oqgk=;
        b=OyaV3RQKLuC1NDJs0ocIm2p5JeGXifBbvJNeoWhnTZ1DotDi6FUEhK4NzUkwYO89Ba
         VjwjR9ylzFFQ5+Wymtbpb/+H2L38/pR+TxrpB6u5udICnunR8WY2ipPIQWRHUu51kSfu
         H3YZ2nHC958TK8u4bdLl8Gw0G15JykyMSxKdw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695245327; x=1695850127;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+2tU7WgIdeqMFoUWsvwgrS0UpcgpoQLXurBiEI1oqgk=;
        b=Ri4qN54WEFi78n0taf2uFnmP7YsBPC3s4t+KDokRuVMlnOJ2yJnB52NSJsWkuAIdP+
         w2jGau/5gus/JTdqXKMGFmTEbyYTOtVQOt6Q9OMdtHB3P/9/z8r6C2uIbKnxrgoxEqUy
         06SOV33T/kRi4xfgwK/qrXYIRXa2eo98pjxvWtKbrJuwP4q9rzh0B47F3lELIq8BH/BZ
         5hM9lIpfbnxjtDetIcUGLKS+5cNJDVQEC1d6BagcSQcLNl+eE4M31VyrnQr90XunH8jE
         0bbf2YU13CqsfAWj7f4QYMfoH27pzGl2aJ8S+u0el1SvhVGuO+Erj/adnzhBPP0Wd6lq
         KRMQ==
X-Gm-Message-State: AOJu0YxYYjAftzHrWUMv1SdDzKhlQCmgU2jw0KvnSmuRoSkDdVOVryX1
	h+9+Kb+zv4mpqfoKrxWophofFA==
X-Google-Smtp-Source: AGHT+IHmFil7972NKUJ3vWb9mLeobhcI3iGZsatlWHXlyJS/jrbNxe7e15O42qmMG1XTDBfTtahfSg==
X-Received: by 2002:a05:6602:13c2:b0:79d:1c65:9bde with SMTP id o2-20020a05660213c200b0079d1c659bdemr5568258iov.1.1695245327395;
        Wed, 20 Sep 2023 14:28:47 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id a31-20020a029422000000b00439d4db47b6sm2362220jai.39.2023.09.20.14.28.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 14:28:46 -0700 (PDT)
Message-ID: <1e76d4cb-aa5a-4e8e-7019-2095d97d3fb8@linuxfoundation.org>
Date: Wed, 20 Sep 2023 15:28:46 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 6.1 000/139] 6.1.55-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/23 05:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.55 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.55-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
