Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83547538D
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 14:32:20 +0000 (UTC)
Received: by mail-il1-f172.google.com with SMTP id y12so6230259ilq.4
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 07:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678890739;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=+sa882HWJ4UleFPTHPmttlCN7M6tCbr8bt+aCQ/0MVE=;
        b=Xy+ZeuOcdxzn1KvLO5FU8ZXKFUpQ2kieKEO5CQiZqguVWdo6eju6697yhHtMB14xjN
         iIGuqm0oRUvag+ZqaF07MbjJh8SEFIwAp8DSfStWJ6KNcUzDt7NDLBmVIlTM47Y6zHnv
         sW1fPZrv6Qub9xQPVgx2qtlF5Lkpu0AIeIherdwRfHBLOplxj6Rfcl8tq32aDx4IUtNE
         6n/JY+4zPlamkh7hGo+pcarPOWrnqw1/gHH4+5NNSe2QvkA2kA/KEEzqaDp0qDe7rNGd
         PK90PM0sb1U7YTtQ8zkYaYiRubY7fEg+Q8dUzoFiyWVOD00GUev7NmDcZvWZRCpbogFC
         amFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678890739;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+sa882HWJ4UleFPTHPmttlCN7M6tCbr8bt+aCQ/0MVE=;
        b=8H+az8m/E/3+DSOAY0NL/6UfrlUfmrAuzsUuVBbHvJ2awMgSjvedoAyqbsBoeeS4Ko
         Z4F0FRLpMiqhE/exV7QOK1TW7RLXMjH3alsPCZXL4QXrnGceoX5fAkHIugVXBD5cYQnF
         0+fWlEcnHjz0bhqNEQ2+x4lsqBD0quMrtSLQ1xOd55MF6sd8rKget8z6QkeiQbTp1KU3
         rq0/uMNJxMlKrpO6PPmnLLapvTBS9UMXZkyRn1UkLLnIXbwuxUZCs+DqpwPo/2pALsI0
         aTX89vmAqgSQQ/YtMxi5/x/Vk/oMt/EaAfBTiseUg+PGbc+yIA5Xkld8tzM5el9uQXr5
         +edg==
X-Gm-Message-State: AO0yUKW3hzCHz43osXtmRhQt70B5ub9D9kkwMmGBb9u0To9KxYORuT3Z
	7LhZTQEEFJrMd69KTmeE7cY=
X-Google-Smtp-Source: AK7set9/WSLL7bvG5rGW/c3DlwOa0kidp25js0YUNkQWc0Xt2Uxfp4+N4cxtgiYyWk4g15BlI8/08Q==
X-Received: by 2002:a05:6e02:1c47:b0:315:4a48:aaf with SMTP id d7-20020a056e021c4700b003154a480aafmr5058655ilg.14.1678890739490;
        Wed, 15 Mar 2023 07:32:19 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o16-20020a02b810000000b003eb3be5601csm1682421jam.174.2023.03.15.07.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 07:32:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <9dad73af-ce00-9c83-24ed-ffecaf9cae28@roeck-us.net>
Date: Wed, 15 Mar 2023 07:32:16 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 4.19 00/39] 4.19.278-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115721.234756306@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/23 05:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.278 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 

Building arm64:defconfig ... failed
--------------
Error log:
kernel/cgroup/cgroup.c: In function 'cgroup_attach_lock':
kernel/cgroup/cgroup.c:2237:9: error: implicit declaration of function 'get_online_cpus'; did you mean 'get_online_mems'? [-Werror=implicit-function-declaration]
  2237 |         get_online_cpus();
       |         ^~~~~~~~~~~~~~~
       |         get_online_mems
kernel/cgroup/cgroup.c: In function 'cgroup_attach_unlock':
kernel/cgroup/cgroup.c:2248:9: error: implicit declaration of function 'put_online_cpus'; did you mean 'num_online_cpus'? [-Werror=implicit-function-declaration]
  2248 |         put_online_cpus();
       |         ^~~~~~~~~~~~~~~
       |         num_online_cpus

This affects other architectures as well. Builds are not complete
so I don't see the full impact yet.

Guenter

