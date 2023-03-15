Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7987460
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 21:51:19 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id iw3so4739920plb.6
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 14:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678917079;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=82jEHlqa7+p3T4PXm/DXhIjyHaorZWNXFDK48xpWCGQ=;
        b=DT3wYg0VhCTSvP/5wZxWxEu7rCG72uWIiCBdungFwhg1HkPaWk3sNR7SZzn1jrkDJm
         p/UFmDs9O1R6p+Gu8G2BOJXYjAP5hG56Xq2eOAaoiNJR+xGilUafwGzXeesz8lQNmFwa
         GLGrVFOns6wwy6qZSyRG0zkVPJ0F9jf7lGmHMCEpL8n5BYBpYTyYBZrL2fQg0EIjxE84
         5XAARiB/uIkpEKAda0nrUU3BK0njFbN057PHKca50D1vzoR10+cG6MnlWS9PXUtEs+W5
         yzFXyX4fQ5QSjQTz3bd0XO5aDvs/Y92zjArqm1v1Xfezc2D8hs6tKpC5pWaBvLApKtBq
         oAAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678917079;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=82jEHlqa7+p3T4PXm/DXhIjyHaorZWNXFDK48xpWCGQ=;
        b=JRv9uWnpM9UjwwHa3th7fOUtkmWgp3asir80Xwj/2FE4fKUgyz+ZsgxobLxqMXG7Jr
         7LNyHXycQBHiHJwYlWcdxDUlDaCYm2b1uqDkrVTtWZ8uPubQAsfqd3eLMEJopyO4mWk5
         9cYZDPGbY2yxBB+v3cXLmyXO9OsAIzORnyYeEk+Yn19uIaIFuwGI6GJcjqBqVRonB18a
         0QSQa7NckT12ZGkTTIhIp8YmeJdG20oKZNXgcnGvqyP2JFu+wVEGEG4DkBj6tEelG4dt
         7zoebv8Iv5cAPY5SmtKDeWh4DcqOWksWMPJR9IvcuQU2SNXo4FVRDfgENLHZurucAy9m
         Imdw==
X-Gm-Message-State: AO0yUKVJvO6JmaUSz4NsrQHOuecr00vI1PSPUeUQNkizna/OamCw2alN
	paGGBDOQebN44G82/dJnPyw=
X-Google-Smtp-Source: AK7set/1xWtTfnSy/FwXUduy/o/hkMEjKmcmH7L6HCvSuh2DpOkhGzUNT3bTzJAYt03aPb9xlF60Aw==
X-Received: by 2002:a17:902:ec82:b0:1a1:9020:f9d5 with SMTP id x2-20020a170902ec8200b001a19020f9d5mr138815plg.64.1678917078893;
        Wed, 15 Mar 2023 14:51:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q11-20020a170902bd8b00b0019fea4bb887sm4064576pls.157.2023.03.15.14.51.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 14:51:18 -0700 (PDT)
Message-ID: <cdd94943-fc3b-d211-b818-068888d82198@gmail.com>
Date: Wed, 15 Mar 2023 14:51:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/143] 6.1.20-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115740.429574234@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/23 05:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

