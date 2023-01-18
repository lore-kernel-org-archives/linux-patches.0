Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C8A539E
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 18:10:39 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id u1-20020a17090a450100b0022936a63a21so3221678pjg.4
        for <patches@lists.linux.dev>; Wed, 18 Jan 2023 10:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=E5zH3GBetx96dCsoZwnkPO6vR0i5RiVAVI6xw2JpxH4=;
        b=X79dGUbdJLmO78NITz9bxQ2PPcMmDREYzYKRxXfAIDnRhePe72ma2mNOi5Llu719NS
         1gCNDN/7Ba5xswCQ48zqOQwl7923ydE0YrmEQvo/7/QcC+dCqj9ISPJXmMUsvMGAjKqe
         jrCXLa8S4JvTFb5RO4bpC0/eLVKvCmOI6bFH46o4ijMKzDiHf+MzOjT2PGLvaZRz/rUn
         2cqAMfmzwwoZbsOvJA8BhMGMt9RGg25DBdQVtEp4JK9Koca2q8byXfPz+HOseNBfxAIK
         RRdjSeuEwVwyvs3OQ25SRbjs3rxbWLnjew0WCbuE5p7RvWuPuRtCXJoarF927XPFcDY/
         8v0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E5zH3GBetx96dCsoZwnkPO6vR0i5RiVAVI6xw2JpxH4=;
        b=YHgIY/0E3s7BDViP45wlQsOUPqjaq9hfIWPGGiSRwQscLyvjYT+dzIbkh/3NowO/W2
         5ZEdtuXm+I4twHXQDpAPLExj5mqS7q2VhW18Qrce+zpod+UiIYBlJGxcyI75um+mEJyB
         UCfnJMJXSF5c20fDHT96ejGWp1P59flD/NPp/p+Hhx7k9zVMrkA04cQY1rMWl7F297bg
         qwDPrcpG0lvS0LlwNhkOR04mdU6Q52nVdrt/9d5OZB521ZCFiy7f6Q98YJZfSQkWcN1N
         BCcNF6L/+brjJBfiwpy0RuSyEg+cJx3V1HMCifBxJzNymZmEqnm9jbUpSX4La83epwne
         ZC2Q==
X-Gm-Message-State: AFqh2krFfHP3ZPGrnmDIeF25+6CliQdbzjssG1EZNcSIrB0aEx/9b5l/
	5TKSEYoiRgd2xxD8rif4UBo=
X-Google-Smtp-Source: AMrXdXsbNyD+Ta/0C8GXROsqTuRCAkx0uBuYzjbvCb9UrFOckwt9AkSVIWFPYr2J1iBPBcC238jEPA==
X-Received: by 2002:a17:90a:3ee1:b0:225:c712:5df8 with SMTP id k88-20020a17090a3ee100b00225c7125df8mr7457734pjc.3.1674065439463;
        Wed, 18 Jan 2023 10:10:39 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x4-20020a17090a6b4400b00229934a0a6asm1636237pjl.4.2023.01.18.10.10.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 10:10:38 -0800 (PST)
Message-ID: <82bc97c8-c59b-8a71-0f1d-67837cce91ec@gmail.com>
Date: Wed, 18 Jan 2023 10:10:24 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 00/86] 5.15.89-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230116154747.036911298@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/16/2023 7:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.89 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.89-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

