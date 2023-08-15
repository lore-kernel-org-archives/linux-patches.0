Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345C3622
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 03:02:44 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-68843478de1so736284b3a.2
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 20:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692068564; x=1692673364;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q9MMTmEvWS/Ce6VFrXHaEsM1pgSF/YPsnYYuXBrACr0=;
        b=X5Ic6vBDzAAF6Ep0MUw/84Q3nMysEY2zZMaSdDK42+wn0hdRQ/+y2XcgMHrLZg/zOS
         eMar0jZyljiUPCcl7NQFB5AocYNDAyJ0TGJPLbUGiexbwGyrHg/Zifs8yR8nzHXlM7WY
         nl3Odbl6CP13riajEITYwujjhnOR50AyL/PfxRJ5fRXy4uP24SagchZDCX/Zuu+gN33c
         MlFuiboIGSHoMHlLZC0jBtCVHnqipC9pVOS7goRYTdUkotL0DyJmgYh25yvr8HGmzB7t
         9NXX2K3tNGcuF6y4GM+LyGVb5SywLRKYMmCPMJU2BAAkvlkOT4PsFGUbh4nOXYybQguY
         BO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692068564; x=1692673364;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q9MMTmEvWS/Ce6VFrXHaEsM1pgSF/YPsnYYuXBrACr0=;
        b=Uj74yrdouNOQHz+uu5xThkWKPV7N7Qnvwfw7gP5SNFRaZlad8jsx22IIQmXUpMiGfh
         spqlJSA3tib4AhYCw18t9U7loQI5a9aj4mjCL9p/EBFH8u4rhlsbojvAveAlb7xIg28l
         sDUEndH2zSop9Fwfd0aIKMP1aEzHU9VqhsE48V7hZAj8Z4KpmeO7bGXnTwOr4lLHg38b
         fkiuTLOxp33vZHfshCfS20uYdnOUKtHgu33YtZniR/nz/MKFVvsVNDmLIsw++cRINgjR
         C1BqyzVEdYHTa4WcZWlUSBP+A+6dhKRsyK+DYPfadbdvHYBYXkixdCaQYZgheqkgoFOy
         MViA==
X-Gm-Message-State: AOJu0YwbVhlb63qWauzPnov+OIQzqYOUEcHRwcn49s6+pLUJoF73JHwY
	bYxopVNOBFe8+g2VJ9SLK2U=
X-Google-Smtp-Source: AGHT+IEkJdNUDBYpx1+AoWlymwYzLLyqU9y56LHk33P2EkpWjWtFxo08KOEXY5Z/VKssMoN/KT2Akw==
X-Received: by 2002:a05:6a20:4428:b0:132:d029:e2d7 with SMTP id ce40-20020a056a20442800b00132d029e2d7mr15685050pzb.55.1692068564227;
        Mon, 14 Aug 2023 20:02:44 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id w20-20020a170902d71400b001b016313b1dsm6799423ply.86.2023.08.14.20.02.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 20:02:43 -0700 (PDT)
Message-ID: <b54c8861-e81e-5e1b-c777-b494a29b76d2@gmail.com>
Date: Mon, 14 Aug 2023 20:02:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.4 00/39] 5.4.254-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230813211704.796906808@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230813211704.796906808@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/23 14:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.254 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.254-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

