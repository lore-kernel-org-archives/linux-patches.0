Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B281118B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 13:46:08 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6685421cdb3so1157736b3a.1
        for <patches@lists.linux.dev>; Mon, 19 Jun 2023 06:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687182368; x=1689774368;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HIvdumOuZ+uzm//Q8KqLv/f6YpyXoaXW/Ro3RALrI/U=;
        b=i5JwtQKBWoT7sFG1Fz+c1EUCLWTvAE5jMeEASpHbMoh01TnNF9UmqC2IPXAoJP3aR8
         T9nG5bTy8MNs5pFbNnJO0d7O4Npy4u1KDkoS50uNjPKsZeI4z+GimUX8CKsCiTQGwnkH
         +n+nheztzivYSMXB3JK+ska/rRsTrVT7DfqBa4KyQJ2f8Lf2StTw3dRogxoaLCRVqfNk
         AWm/wdzOf2D7piok/Dx50jXQswd6N3i2ky37qnyE8Bu8H2+Z4xpg48EoYammTBZw7ult
         oBGG5az58ZqKgK5ySnWWRo+kew80XKrXC9acPnDI1b42S22npEJ77dGiDPlfzHRP9ygV
         PO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687182368; x=1689774368;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HIvdumOuZ+uzm//Q8KqLv/f6YpyXoaXW/Ro3RALrI/U=;
        b=hP2BeU2QDA15mTUV0+ZmvSA+QC2C+22PdPkzqSozqga4x/iicm0DTFf93rRhLky/wl
         9sV4BFrMw6SAJ8k8zYacqLkgk06OrLnGE6VacxUwEBaLTOzpmTsCn3pm60tYHMnOkJ+o
         1jCeSfHoaECJBIsJyd003txBhM90rSrIGvRmhabuKNcc3zEFCJQyeU0Ifbic6YqL4BLD
         ZeLTwEI4M1/07EnY8F8FLNaigBlRKc/BNe4w94nsPcZs02rsLLNMLb25Rmiq0QZKaAyD
         BnRsy+cp1hwRnbi2iZAf7ELD1NUO5NGjgGuooATH2DNHw95vd5tO+KstIltZbsR/YGxe
         x0cA==
X-Gm-Message-State: AC+VfDxRU5EBhrYgkbBqCzSxlXCDDqkjmk28gatmCtsLcbbl9/XsfvnC
	p2RrcAcD1+Vf+rk/WAA+M50=
X-Google-Smtp-Source: ACHHUZ6hVtaSRXVcpARz9bDj143Ijftd/mu+PCLpAfX3sCeNiBfBb4EpdXjUvSU7RP2RZrry2BXVow==
X-Received: by 2002:a05:6a20:8424:b0:103:b436:aef7 with SMTP id c36-20020a056a20842400b00103b436aef7mr20689920pzd.16.1687182368045;
        Mon, 19 Jun 2023 06:46:08 -0700 (PDT)
Received: from [10.178.67.29] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id 201-20020a6302d2000000b00553d42a7cb5sm1177513pgc.68.2023.06.19.06.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 06:46:07 -0700 (PDT)
Message-ID: <c8fd738d-cedc-9a2f-f093-0a5b49ab0131@gmail.com>
Date: Mon, 19 Jun 2023 14:46:03 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 5.15 000/107] 5.15.118-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230619102141.541044823@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/19/2023 11:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.118 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.118-rc1.gz
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
