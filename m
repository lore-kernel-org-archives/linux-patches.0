Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9826FC3
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 20:18:45 +0000 (UTC)
Received: by mail-qt1-f180.google.com with SMTP id cf14so17573015qtb.10
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 13:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678911524;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i7Oo4rCLmTR5khONcZOf3GrOVIeiQMyZuYfMGppjVe8=;
        b=g4iBEngLjsfZmcXFPg0qcwM7BY/7iF8NmuDx0pve4vKan4QD8olTTnPv/mMm2U4BxO
         D04tG9G6sGbIeRT4WFXX79HhdIOSiNDUfp3KNl72rLAP0D7NjOmox7AAo+fLNhfpxW50
         08pwI5j4ah5lJ7ftuzCYucjS33UYIy3IdIyXfipRKvTGwLPnrX94srUe4Yoc25ceEIPH
         0rBHVbxkrK2VhFfw4aPBYI/MQNaKtPZwFM+igvt1sxVgPhmNbed99BtQW7sRLGg0hQs6
         DlmouuxDgPERMPzkyd9ciCJx1DoOxp8E/EQV5INBozTZlKQDy8LzfL1RQhRNyBslOFrn
         6CwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678911524;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i7Oo4rCLmTR5khONcZOf3GrOVIeiQMyZuYfMGppjVe8=;
        b=Q1dcwXvzD6hSeRaWQGkyodt5epvnpEjTYjEFmtwEzKbdVKgg/OmhQdJaSpTbbt5j/G
         DKPT/+08iOMO6wPUl71TOI90msh6ra//SbtzzYWh2S4PjoYzb2DzoSjK0JOUs9todbQ9
         Etgu5BWrnH+fFsZ3kNBuL3j0zq83nYGZ4ga8UuRpfdSsRLBW0mFStmF+FFv8o2+KX+YN
         Oh7vtirxTuInrmxYXzyyIqwV3Yr59FuaHk7PnDcoaEoSmgSaE7RDX6Uz5D9CwHT22Zha
         OlIvaplGrmaqeB0OsECkykqGsnYeEZmEmASAe/xu4/NhEh51teBbxLyKEQQ1ZYnZnEAP
         SMPQ==
X-Gm-Message-State: AO0yUKUcqI0JP+bPxVO6rv1qoGnlo1iuXqH8LbVD4YMm1ZZ5yna6Bn8+
	r5tBIPT8fFy2crWcgjDH7eY=
X-Google-Smtp-Source: AK7set8ZnMwV6chz+Olux+wW3D2kVdtiHQV8qLisY8LiCrsEcF0E7sMgOsppzt4taZJaYW5HIk6aQQ==
X-Received: by 2002:ac8:4e41:0:b0:3bf:da89:1946 with SMTP id e1-20020ac84e41000000b003bfda891946mr2084099qtw.1.1678911524243;
        Wed, 15 Mar 2023 13:18:44 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 24-20020ac85658000000b003b85ed59fa2sm4424090qtt.50.2023.03.15.13.18.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 13:18:43 -0700 (PDT)
Message-ID: <27903740-0dc3-4373-bec9-430455bb98b5@gmail.com>
Date: Wed, 15 Mar 2023 13:18:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 000/104] 5.10.175-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115731.942692602@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/23 05:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.175-rc1.gz
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

