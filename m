Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EBA122AA
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 20:55:23 +0000 (UTC)
Received: by mail-qt1-f177.google.com with SMTP id e15so338318qts.1
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 13:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RYycDhbuHQh8p8GW+UONgFPTOdE3a8n45OrXqMo9C5k=;
        b=BiCYuJrP+N9tJFYpz/8kPtms6xQoqLSI2xfGLGTlQ8Ibq3MVOaZHztTSjdSNd4e3r0
         kBMIod+ECYvETJkSelTo/DN0gA4uAkamRLjkw8vlXSGP/pVIGlPg782Anqk7jwC6FIh+
         7uhHHfqpB6F9UD5oRPagKuKg+nrbrHxlhWZdesuEORNH7oSu3Gpy7RC64LI6cU/ngoF8
         Km5j+JtfeEUsQ357ra/u1xYRhklwymKJZp9Vu2TGwlAiQCn8gJKO2f4kNWvB//dpN47h
         yHgJrDMRLDFjGNHNQXXik9yATKlQA87RQy7E6/+m7mqeYRYIJfHPrs+UKl/r7Gx3onLl
         sRpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RYycDhbuHQh8p8GW+UONgFPTOdE3a8n45OrXqMo9C5k=;
        b=zWW09vEK6qBvopqw6Hmp54xjIbBcQ5u28G4SkGtm9i6OSm0XALOAufR9uxg5IhqTpI
         /0lSHhSWNK3/2bA2jNhCZRS6TFbDLjYyN+Db0L7LbwB6WVX85Wi3HJLPKGyU97liP8ee
         6Xfy1gV7d0t/GNaDCV+1ZkC+QJltcyQ7gd2mBs4AsuRTw+s3cUXj4ckzHN7E/Ab8caKa
         2h7KvJGgwL416mjX9GbQp+C96a+lNxPyC1XbJq3qFjnglDzIPrncFhA2x/YPopcSKIYb
         mp6lHRLO9PyDLKTISC4vDxGl1HHWpU8+LvlbQ/E0VLD+ryNyWnYGwbdrqcO/An4lYBba
         R95w==
X-Gm-Message-State: ACrzQf3eZP9WlAcssHSmTMqI67Zb9+DYL/oV5u45lBFVZ9KCgCm+0otJ
	zaw+PRd+CiVa4q8uH+cyPk0=
X-Google-Smtp-Source: AMsMyM6K9ov/NtC1jJuoptk1NaSA5S7LFc3Mip5j4V7vj/9+ocEaUC6Fu0sgVoHB7y2ctI5Y7+vVog==
X-Received: by 2002:ac8:5707:0:b0:39d:c40:cf51 with SMTP id 7-20020ac85707000000b0039d0c40cf51mr1276287qtw.102.1666990522699;
        Fri, 28 Oct 2022 13:55:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g19-20020a05620a40d300b006eeb3165565sm3687064qko.80.2022.10.28.13.55.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 13:55:22 -0700 (PDT)
Message-ID: <461060c1-8d5f-3585-1e3a-43d0e0c5e87e@gmail.com>
Date: Fri, 28 Oct 2022 13:55:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 00/73] 5.10.152-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221028120232.344548477@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/22 05:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.152 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Oct 2022 12:02:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.152-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

