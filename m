Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430CB10EC
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 23:22:09 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id t2so10563308ply.2
        for <patches@lists.linux.dev>; Mon, 19 Dec 2022 15:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=92qNU0Pb2An2LZWcMglNNqJebkSusC9umdTJ4WDVykw=;
        b=pjzTUfJ46fLQi4dWC9vri+3Yn1OAC9s266Yv9Ns5Bxwtfw2TtPg6AABhb6JZcbvYam
         18ZqgY9J+IxnxZMKpU/HJlUB80YQP5ewnR2boqsMCy5lfaaAXnwiPdapfoNRCLfcL1rv
         zSsy8zNgp3094o3iwciKyFFe/mFKza5jdJE5v3lwn+9EZJN0FyUckgYevwlbc87wW2E0
         x8Yi3zbOrvxUNe6KXt/9KsHMp2mN7sNM0AN7Kr0Wk7gIRo1PqEuNNnt+TsWY0V1eDZx+
         8/jWt5ycHQ1TlhFuJ54l4BG2EB4jiPT5PCnriVT6CnGSSN0gmBeIu8xbFu4HXRrggXbu
         9rSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=92qNU0Pb2An2LZWcMglNNqJebkSusC9umdTJ4WDVykw=;
        b=KRF9Kci5n7tQNCQiEVag3W+pc46owFgPWNF/E5iBcgvCrypuuXB7mZ3pQLB457uj0k
         I5RwFvph4xO0JeSl8Gj/1s3s3PgwGv2/hXffei5yzrCtmDgpPsGqCcYOsVtxWq4c/pum
         6yrTBtkgXdif0XK5rv9Tx1WO5tKxNw0ZolcjK99l++xbGJSV+xnoJjgYtqohMgTJn1/9
         GJc3xsv5lt+cNBGEHfuZNRQ/wazjnqJ9FRxTGD/VcvzlxIrAFUJOmh+wqnb8XjIREwJ3
         qBX0gKT/+UpgGQ70zac5WmCjGAe/iP2QASW0XooKF29aKQTDukf0FjjI24EF9rnfI/JQ
         lZsw==
X-Gm-Message-State: AFqh2kpjpJQi9/sjuRxSmARicSuOcdhqHMc/KXws0abMG0BdKOxezXA9
	z+pXPI3xHtGE4B4IsEJxq94=
X-Google-Smtp-Source: AMrXdXsUNtrXcUDFBBp/ETSAt1qfFRJ2Ev7+yfubKUCERURB2rFZdvhPppebIcm2RnanK6C8hX+1yg==
X-Received: by 2002:a17:902:f648:b0:191:327d:ddc0 with SMTP id m8-20020a170902f64800b00191327dddc0mr857547plg.21.1671492128605;
        Mon, 19 Dec 2022 15:22:08 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b12-20020a170903228c00b00177faf558b5sm7677791plh.250.2022.12.19.15.22.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 15:22:08 -0800 (PST)
Message-ID: <af80e9fe-2929-d909-4c11-4fdcffd74780@gmail.com>
Date: Mon, 19 Dec 2022 15:21:55 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/18] 5.10.161-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221219182940.701087296@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/22 11:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.161 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.161-rc1.gz
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

