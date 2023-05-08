Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B80A2598
	for <patches@lists.linux.dev>; Mon,  8 May 2023 22:37:57 +0000 (UTC)
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-619bebafb65so25887986d6.0
        for <patches@lists.linux.dev>; Mon, 08 May 2023 15:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683585476; x=1686177476;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MJkBy5EhvULhTIUWG0tl2IkSQVaZ72VNBGuYy2i26s0=;
        b=EnPPvxkasliKAFV0S5FBDMJU5GlsgYqLJCJW6mFeVhF8OLKOJsHuoLxdP7Q1v1AjVI
         0+zRgvGP/OKGkydl2UJ5Job/F69SEsR40IntmodAhgsm3sP6hagiwKEBJXOCkbcj8wtO
         hgYZPSBxAwK31+fu9icI2Y+V2e1S/rnTuHrlSz0tr20KiykOl51q3fKcvSMeU7E5qf2X
         KWMmML7FlqkycOWg2AN/LK9FRRRjTw4fO6XdjdcBCBcJhggfKbtOQSrdZBru++62rQan
         +T5ZYfN+B1UOV0bxNsUc+JQ7prEMwPSR5iimEOurfdlTsF5LTGIyhOI/OpaS3h/JO1NQ
         dSTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683585476; x=1686177476;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MJkBy5EhvULhTIUWG0tl2IkSQVaZ72VNBGuYy2i26s0=;
        b=D6SotYOxDYkuHysRh3OjkERH4TF99YmSw/+i4i2MzLcr5ix7GB37wJPVU8jOQyr7Lc
         KPZ4C72qnzKSgfkXWFJnEiZno9dAEDY8hoMJOFedX+MK5LCHQKI7emkOVu0Vw91PraIS
         NRRS+jhjcChjadaNv+PGfxsaOMvsMacuBvl19oz/75NgzryEpn489REpUFgttvjJUIFT
         DEH/gOri0VH3TrCT4jeCpaF+nnb0THwo2IJH/xRVdVAHSVOLWUxXy2lwTSHnNx1Ekulp
         As+BgzDZxjYIk3QCJDJtmn8Gsz96SXYjfVlIxnPEFfWs85CF5piYNbCWjsA4RHydhBQH
         Q+vA==
X-Gm-Message-State: AC+VfDwTXTzB4i+/R0j8XUEFF4FI2eO3tDZXmFCTJKag7T3dlDrsBiuJ
	WmtR/YnlvzaW8DEAzgoQA+Q=
X-Google-Smtp-Source: ACHHUZ5OwMyCitYHah+w9aQCDUs8Wtq3PhzO/6Lf6RIKL760ylUrBGsJUx9djMI/3TmDM7N7a7r0kg==
X-Received: by 2002:a05:6214:528b:b0:5ef:50a3:f9ca with SMTP id kj11-20020a056214528b00b005ef50a3f9camr14950747qvb.47.1683585476323;
        Mon, 08 May 2023 15:37:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o16-20020a0ce410000000b005dd8b93459esm316406qvl.54.2023.05.08.15.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 15:37:55 -0700 (PDT)
Message-ID: <b590760f-af50-5b01-079d-546724a3c21c@gmail.com>
Date: Mon, 8 May 2023 15:37:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230508094432.603705160@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/23 02:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.2 release.
> There are 694 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 May 2023 09:42:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
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

