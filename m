Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567556D24
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 20:04:00 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id 20so3530460plo.3
        for <patches@lists.linux.dev>; Wed, 28 Dec 2022 12:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D9hw1tyF2xNwFWyPmio8njtMOWA8uIyfYQ81GU7PQ4g=;
        b=l5hSqSw7DhDVM2wKiPZ9RYMs20w2cvUUZhLOO00+ql252Nm0olrX0Rv9xmU7vqHR9O
         LIRe6eWgrqlHrYUPH6OiRi4Q7e9fQ9fO0elhONz3PQ1X7oq0PuaMjwSnXeMV1nkJ5NCg
         1PGR683ce+XaMymj5D6i1neHgegICCGOO0Oh8W84QDxYUMX7SQqNCCMvv1OE529fve2s
         4deFw1HB8r23vK/YoMdKhIaOTVy566MgadmYlZpO0e5obxEmwuxIQnZ7cniERQBnRJhk
         GA2+0O68FtQz8I/lonnmxobdxon3TsFtre6KLTdcgGgZhlqv5mYIA7fdnlj+s609WLs2
         sD1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D9hw1tyF2xNwFWyPmio8njtMOWA8uIyfYQ81GU7PQ4g=;
        b=6kNVtFtpZ1HpHnP5Q2Z2Hgk/K+P1TAODr0w5fUKF0BxbQtMfWfyUCHXcWkZ84Y2y4G
         u7/EeE8vRnBIRd8VIn5vrGe17WuacOFxziWADNhvTpbu5uPfOcQSJLMG8DYDW9DHPnBG
         opkLqg0jF5Z0L/lAlTy0wW1g/INwn+ofYHa56ZkLhTA3jkRE9kyqrgTyJ9nkhzVpAa+9
         jy4OTjp9SZi93t+A9RL4id1aF0XhS2Nx7W0u/a93T+BcwL0VUZGb5jzXDzLJ9EggVXLO
         U/iiQ6wHtcd4ZARBqUfXj1SglLnn6GKoNz34MxdVB+sVL0mUtGF79xDIXnaGGMMb71PD
         3Wbg==
X-Gm-Message-State: AFqh2kqKi9TKTpGpPt8iFjqMsTDU3sprusIdkGiaB+Fgu9O4p63jalxV
	Msnc0lWYdFVMNgOx3i2pSOk=
X-Google-Smtp-Source: AMrXdXvaLyIZDB2S9vQZlF3OIaI/XmryotvyVvLG8GaQ4k7gCNGscNcXAEniNr9iPcBPOU3EdJJIzA==
X-Received: by 2002:a17:90a:780d:b0:219:ccbc:ed8e with SMTP id w13-20020a17090a780d00b00219ccbced8emr30058109pjk.20.1672257839728;
        Wed, 28 Dec 2022 12:03:59 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id q60-20020a17090a4fc200b00225d963fbc2sm7056781pjh.34.2022.12.28.12.03.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 12:03:59 -0800 (PST)
Message-ID: <6e00e703-f0ff-a739-75b5-bbca484ab74a@gmail.com>
Date: Wed, 28 Dec 2022 12:03:57 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221228144330.180012208@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/28/2022 6:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc1.gz
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
