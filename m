Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F06713AC3
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 16:54:00 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1b04782fe07so5626005ad.3
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 09:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685638440; x=1688230440;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NrtU5RuYBeuBi2r2ar6tM9mhHcon49dtHwYky6B6JIU=;
        b=clOYmIJ3HQKANIN9/t2d/mYEqaT268+J8yLmiK4mVGAzAw0qNYC6Bl8ARLobf9ruoo
         1mUDr/40MYug/7AJz+SdzToLazSvrehF8Q9i45818fr0fo97tj+qkbroNAHVtKfW1UrK
         HZ50rGJxToJa4KM3iaXlyjdPqYCcmnjhYzr17mYdEamw+Kfyy8dCSQ7xKlq8Wx0x9YVU
         CguTnPSyWoElDsJx1wsXm+1h1PhNO5ggyfT8//NF3LvL22uFXq5t/jNOlJ/PfowiPV6/
         PCdqCHQl/rIiwjYIOXU43AenRwWKAL0ODPHLUGYLCvtJ2HKGVb+xrU+8W47/kxmAqpIU
         kvJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685638440; x=1688230440;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NrtU5RuYBeuBi2r2ar6tM9mhHcon49dtHwYky6B6JIU=;
        b=YgJGuha4kT5cpy0tjrEWlDduf4bHg47jd+JRh5J/o9G95EvHXjABa1VEuZFqCMmohE
         8T7HdbB/dOY0NYnbRiTuLdDyX3rbC6bNTgDnTAUahAVlPB39PaDjvDaZfCxexnBJjycw
         IbyAKiErAvbqtlC4YdeNV68w2MtnuEa6oSjDbSPEA+SI0wnCY1aMJyUuDtDKV0naHoLr
         PxgQo9SeiLbjbm3fZzSE9VweHdEvSWScE+Z6/7h9F863PpJq9DjhqSDrC3Bi3eF3s6hG
         EW182K1wQqu0R6rKMtLaDdh3/lsPBcFcos1lcGzopF/HpAoWgRsaiMcmM23N0Ll101HT
         Zm3Q==
X-Gm-Message-State: AC+VfDyg2/Wh4L2fNMD2LPyXstrDtrEL8JPZvCOTBiCNYby5vRJmDNpi
	oNUUh+r5Afd7EW42JNmoLL8=
X-Google-Smtp-Source: ACHHUZ6m/1qrRK/zsv9YPJV86YK+Z5z95pxtrYyl6asUoeYoyHvmqH8fKisn2sC4XM80ysZXgBsorg==
X-Received: by 2002:a17:903:442:b0:1ad:f7d9:1ae2 with SMTP id iw2-20020a170903044200b001adf7d91ae2mr6313209plb.55.1685638440333;
        Thu, 01 Jun 2023 09:54:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 2-20020a170902c20200b001b06deeb319sm3664116pll.300.2023.06.01.09.53.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 09:53:59 -0700 (PDT)
Message-ID: <cb644201-0fc5-063d-9a23-e5d81da7542f@gmail.com>
Date: Thu, 1 Jun 2023 09:53:47 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 00/37] 5.15.115-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230601143331.405588582@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230601143331.405588582@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/1/2023 7:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.115 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 14:33:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.115-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

