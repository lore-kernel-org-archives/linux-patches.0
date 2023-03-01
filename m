Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BA58835
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 19:55:01 +0000 (UTC)
Received: by mail-qt1-f178.google.com with SMTP id h19so15648677qtk.7
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 11:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677700500;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S7q6UpnF9np505yO0BiawmWibmxherXG1GGRZXT3ORY=;
        b=Bpusk7J2C3GqMTl+Q4+nEw1X16Wd3qLO1jyutq9Ww1XPik2cz9qi7osLJ4fdLkCYcp
         afCy+tnO8FdJhM6q0z7Z8gn7/6Hz1l88kWezKycf4G/skRgDwPCEh9UhfgCTB50GlIky
         Faw7hqjcLvTm0z5xDHC95Ke+C7INy2z6aRty3DBZZcw/Lnv1mk11fa+R7ftKXueXgl3u
         RYGWm49nCzjQ7gWsW3a6CGG37jW4WgYtlzxSaLfa9EuQY5Tvzrs1WAjLCMAahq/SGJKA
         T2jRTUzClX5o8xDFBX0xJ3Eq2iFcf290jpMpsNSjkFuob5M+361ee5uc/tw2pIZnuVHT
         nq9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677700500;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S7q6UpnF9np505yO0BiawmWibmxherXG1GGRZXT3ORY=;
        b=x0Ek4N2rAqxPa5uHogseA3J9wdu+1ol0bEvQ5DkzGFVg+eyyY8R4Q9ZM1jqt53Yl66
         mm4+fgUI9pkcZpZy79xtAFZSaplaKKkL8KkpOxlQMvDiRmPMNJHSdGEsoBlmstK1DOj5
         KN8b0eRnPK5tShZds5GyhNOFYH/QvpGRa6flaMRSsXo6PGM/VKh+R922uWODf6yk54ms
         Y29rGW6RnuBYg2l2jUKV6QcGGbNngY0Lm9li5hVBRvmWi4vV0wq4k3q8fIQw7YMD3d7E
         3eNX3SaSdL09ckyejJv3JrsBOVgFvWvnnkEUFp9ENULYw8LVQQBSF+HL+0UKGWkhIlho
         RGaQ==
X-Gm-Message-State: AO0yUKX2nUlsw3YP5TwGV9ojmnEyqhgvl2PHz6Knd5eQFYYX6obELwd5
	Zj06wy6+n10VUiFYXO4BS/c=
X-Google-Smtp-Source: AK7set/aIZURiBH8Q8ywlza1eyf0gl0yMai4LqAejDTsVmBCEgyJwoIu0dCkCdheB360KIhRIt80bQ==
X-Received: by 2002:a05:622a:1004:b0:3b8:6711:a472 with SMTP id d4-20020a05622a100400b003b86711a472mr13310897qte.20.1677700500479;
        Wed, 01 Mar 2023 11:55:00 -0800 (PST)
Received: from [10.69.40.170] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k13-20020ac8074d000000b003bfd27755d7sm6834730qth.19.2023.03.01.11.54.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 11:55:00 -0800 (PST)
Message-ID: <fbc9c0fa-fc46-6a94-f9fe-fdc63efb79f2@gmail.com>
Date: Wed, 1 Mar 2023 11:54:57 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10 00/19] 5.10.171-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230301180652.316428563@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/1/2023 10:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.171 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.171-rc1.gz
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
