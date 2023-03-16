Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8104DAD28
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 20:18:00 +0000 (UTC)
Received: by mail-qv1-f42.google.com with SMTP id 97so2063327qvb.6
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 13:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678997879;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3hSQqmOPjN3PoBEQpVeufKdChsynQgIj6cJH3e5uFEI=;
        b=UTdvpLFs42Cwb3ydTv3z+AT96WfIYlpo7rWEOhYhRyOAYzJkExAHsunw40mo0AcoEZ
         EBzOBGpgePHFlGELL2r6u5ruhr6QetM2/uzCzPoe+bf115dYK+QT1NGA2MP7G9zMU5P1
         5Lp+Gzr89M//HmJC9xiiNjEEv0RefsAdcvML44kNrYaKKCcNlUxmxPi+7gvMMLe8iCw/
         LdP6U3jcl6F5ASdy5LZ0dZegaI+Fh+wUZFclnLbFF58ld8pU/daIF2gvRi1Ibsgr9KYv
         gbldenQTT26fkCqiDtc6mJ75dcvf3osQIr7krbFSFg2xYTjoSwZqntBTyN3xv3gFRfuj
         C+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678997879;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3hSQqmOPjN3PoBEQpVeufKdChsynQgIj6cJH3e5uFEI=;
        b=EfbOa4ZzR4jXHaSGnah4kJBHwQ2dGNn0Gk1m+X1qQWCpI1oSRjQFOdtebFTzoQcumF
         dR4IIPy7kP3YLeu3NRa02PIU0dXhsbvxhzdkW4pjvdZd4p7lCSp7iTFX8JvzGvW/XIAx
         FGOY/ppfq9AfZhBdb0cYOU1tFEFDf1GOkCfj47Xsg87teci/txDAKnHft5A6D/sQQM4N
         MPsY0jr0OAq+K8mwKMwllFP1gAfyUBQb3EwHtJgBvQd2H5t7JkRLI5Wy2wnlYe26hJQH
         /pXtYnrAISYrDu0v6JsvXtu904u0FRFFbsZIdIUtBndhIQYR8J3tfXEY69O6dUAQynMJ
         WCUg==
X-Gm-Message-State: AO0yUKW897RhAaDbEAKVLZvfO8bzQzaVN5lEgMqFLpNdtJ9jdV2BMv+7
	gdV4l1CIfoapUsJGNyhhpX0=
X-Google-Smtp-Source: AK7set+hpP78ijCJqK4lIgvUx76VikcSG1ESncgtMNADZ9uOHoXBbCkjOUd4zy9xUJKN6QTZMlz6DA==
X-Received: by 2002:a05:6214:1c4e:b0:5b9:2e5d:76ea with SMTP id if14-20020a0562141c4e00b005b92e5d76eamr4380121qvb.6.1678997879372;
        Thu, 16 Mar 2023 13:17:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o10-20020a05620a228a00b00745b3e62006sm242069qkh.23.2023.03.16.13.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 13:17:58 -0700 (PDT)
Message-ID: <58bcb53a-1a6a-63c0-bf69-627c3abf483b@gmail.com>
Date: Thu, 16 Mar 2023 13:17:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 000/137] 6.2.7-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230316083443.733397152@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230316083443.733397152@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/23 01:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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

