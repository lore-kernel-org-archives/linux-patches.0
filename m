Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFE5BA2F
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 15:58:37 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1b00ffb4186so5858715ad.0
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 08:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685635117; x=1688227117;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tdo1BT7zY5jhyUPqroUtUjnXkFXuc+CaZiA5H8uHP1k=;
        b=W6AMR2wuXVBEF216FQyc9671QMNLxsrZsTY226oQf/776+kGNZoLb8A0hLHNHh3e9r
         QG4m9eCwH3SgtU+75i8LiiZTAsbRChN6hnMdTi5l91dl93mfSqjS6kkAxxn4iPN5lScA
         LdiYRt+gVDNIvmICvNEGL8lLD28zW+JkteVL/0OBDgeURBy1DyHc54c7TvIdxfvwtj+z
         2q9ouj1ExOD139OWgCecEMJ7Z02mRUMPXoa+eS7bhctpvYbAok7BHNTs2WmyLwb8G1/r
         n8SoQXGGu+5WxjPWHScusd6tMGyMD/XV8fFO4qzwBUrMVheh+qbSf/n4pVonROlrez22
         NT4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685635117; x=1688227117;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tdo1BT7zY5jhyUPqroUtUjnXkFXuc+CaZiA5H8uHP1k=;
        b=h+N9wrCsqHEtRDwW0gs9rfMjs7IjYDF3hGNXQxY9mYxztAYUf8Bh/EccHH26OOv3XE
         yASLEcBwS93Q5wjXj9borsewLa2SYOrpnJbKrs7vYtkDmX0kffopSMlbHzdHY/NN/fQu
         nXJ024ioARDsWiAYvzelAR2leQNvHwKMGLicSMLFeQppcfS0JKZOx47RdxE9ibQAxaEj
         lCRDNm2SibAn2IAYlofs2KlLuTrTN3lXEHj0olPtOdjv5fKfJGigUts5ol5PcDxhYCjd
         fzeLG52gNM7xwtJlYmGSSFBGecO+Z7fzOve8Oxp3omJ2HJzDUix4ozeDmLw33oUEPgYS
         rLOw==
X-Gm-Message-State: AC+VfDxc5Lljivrq9rkMcYwefAgHxgiygDO2pgaRLW8WXBT/QxRHKSyf
	wWSGHo/dQn1kvIUAW5QWnZg=
X-Google-Smtp-Source: ACHHUZ7o1nsP0aRLIFzpNb6EDRUCEYYUOY9hg2FCBv7jz3JfpIdh+lwJy9xTpEbcaZktUxLUvEI/HA==
X-Received: by 2002:a17:902:988d:b0:1a6:45e5:a26a with SMTP id s13-20020a170902988d00b001a645e5a26amr5354940plp.27.1685635116641;
        Thu, 01 Jun 2023 08:58:36 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id ik8-20020a170902ab0800b001a194df5a58sm3712243plb.167.2023.06.01.08.58.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 08:58:35 -0700 (PDT)
Message-ID: <09f64b6e-ddbe-61d4-b229-95a31b2acb50@gmail.com>
Date: Thu, 1 Jun 2023 08:58:34 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 5.4 00/16] 5.4.245-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230601131931.947241286@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230601131931.947241286@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/1/2023 6:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.245 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 13:19:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.245-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
