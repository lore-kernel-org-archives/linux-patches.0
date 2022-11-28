Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3881BA49F
	for <patches@lists.linux.dev>; Mon, 28 Nov 2022 22:12:52 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id 6so11207560pgm.6
        for <patches@lists.linux.dev>; Mon, 28 Nov 2022 14:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7VnIiqkaLT/AOA+Uh3vYc89XGyhScngUhSEYmii9N7E=;
        b=hf/Rd5cgspTnUYicP8bfp0SxkTZo9YWJxzNwarpU4xJULh5zWcfQXnuff3SuYQYzO2
         1hUYiP8DJRkQP23pUYDWiUHSaT5pUDVGXcxNg/2asHYrasdRz1d5QLYVO2LBAdx1Dkqe
         21Pf7WCRasOTddkVfVSFxdmDTpvc4zJMmNXI8SXYDGscpx0iwe0VCv1xLFwx9cPvqmoa
         EavQ+dTGheMEqFf+eMklvPIy4rYjnvaoWdMRthxzrcPt9K+Vi6YANBMPD9vZy3k+bNlJ
         sI/3o9p9RLgbGwGf0WvrhN3gY6iqLS01sIDVaV8bxJAMuqxx+w74yVtF/pC5Ymj7509+
         ZeoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7VnIiqkaLT/AOA+Uh3vYc89XGyhScngUhSEYmii9N7E=;
        b=fZLVkrVA2bq1kskE6zo/5TW7WtL9MdHam8nT6kwahHS503PIAfL0QNrOIhAGm1vdha
         rhQIYJjZdXSKVF9+BC7c8ZuQN9I2KV4DLhVMCsUysqcaAkcZfSGHgBvBajIz2529lXWQ
         Zm2AS7B3CzluQLHzY+RjWHk6ocFDCyj+K2BBkYDzeuMztrFQP9bgimSsetgqxg/KQU9s
         yXH08mOPnUsfFKP7Okl4vrduK3XIzFi1M0s9vEoFR1UkqGDqjXibqlPWj9wl9/s3Gi4n
         WUQBn7/uF5t3rOBKoy382zWVxGM65azis2sanbjkPGKuECpdF6VJEaqcTGjculoX7T3y
         UYHw==
X-Gm-Message-State: ANoB5pkIDbAInBl7pqlw5NrGjF/UKoR93iPMB1tSQE36CnW1utvdYa5u
	emBCYORz7j8Pg/Uk5VTfTKY=
X-Google-Smtp-Source: AA0mqf7gi2938a6aMIhx7F3eopAf9BP6LPatYMG6aV5lHkMTn+qjJcYL7NMxg0OZsK+ou+Q0IcsCzQ==
X-Received: by 2002:a62:84c5:0:b0:574:32ac:a47a with SMTP id k188-20020a6284c5000000b0057432aca47amr30644859pfd.7.1669673571506;
        Mon, 28 Nov 2022 14:12:51 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pc16-20020a17090b3b9000b00212cf2fe8c3sm40644pjb.1.2022.11.28.14.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 14:12:51 -0800 (PST)
Message-ID: <e6d08779-6e40-ef74-fdde-25335bcb9cc0@gmail.com>
Date: Mon, 28 Nov 2022 14:12:44 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 000/156] 5.4.225-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221123084557.816085212@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/23/22 00:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.225 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.225-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

