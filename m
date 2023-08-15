Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6326713AFD
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 17:38:56 +0000 (UTC)
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-76731802203so387239585a.3
        for <patches@lists.linux.dev>; Tue, 15 Aug 2023 10:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692121135; x=1692725935;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Hkd0vr8l+i8TA7+6Xkb7goHWw+Sxr4X5Pv6u5Fi2CNM=;
        b=Rh1xTajwGEtdV7nPTnwcFs9RNIiHnwcZQlEOY5aJ1aCvx4dHBTLi1Y3KrkbRpPX1Gv
         9CyAvtqipwTieYn2KeCenPR2oLECkljVA+m241v1Elb/wbZiKN21NSumhsljvsptsg/f
         XQ4xIbu5lbJoHwgSI+8dtcZQtxpWcTmM0ODZuWtsK8711Ye0Jp2+7fvyr6hSR29LmpiF
         tF75UufVfKcZgweVqeyldC6ZHnyjC1b0G7RmKb/8yT2D05GhmWVb9jBfaqJDm4KxQWTh
         0kYnDeACGPAMT/BTXYJKeQGsI4CB0/NB/7Z6V4MnD2MkfD55z6fYfyyQrQGp+TSOfKMv
         q6yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692121135; x=1692725935;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hkd0vr8l+i8TA7+6Xkb7goHWw+Sxr4X5Pv6u5Fi2CNM=;
        b=KV6sbQz1PND8+62Bw3VzpPblsyzcPbUbT+hZ0/f8PlMnJFc5SPDxZf5ho7XU2shldq
         ySQCUtnfL5kHJGJ13uSsS6DrCiP/zt/y8RVEvClKVl4IE2YAMvWZnRFtIL71WuI0AGA/
         WL0FMDttp/+Vmfk/TPqbcagS+0ce5tGXAkCQU1BuY/AjXGz2dWP2PxmbXqfk1EZfn8ch
         mj1MqqPrtYpRTKCvBw3NSvdoCyqDd5KRaU/1HFJBFe0NeIWFPsQwS+I4a7CvBMgMGcAa
         Ny625SoDGEUw5J6BQ/vIH5pGOuiWHSLFVLh5xHEHrNiQM/XLuNvr3+eoSHuGaOkkR/u4
         Us3Q==
X-Gm-Message-State: AOJu0YzPEsTJQR0Gv7Gunts5sfj77ui1MkzoFX7nobOr/KPAdiFfL4z9
	YBp14y/YQQSRjQyq9OPM3CQ=
X-Google-Smtp-Source: AGHT+IFtBsk6TfpDYGZb7LDV77U4EmAigIkbu7pXVPS19QOpzgX+a65yqEiHbPpbyEVuObDdECQVHw==
X-Received: by 2002:a05:620a:215b:b0:76c:ea6c:59a3 with SMTP id m27-20020a05620a215b00b0076cea6c59a3mr14366377qkm.46.1692121134963;
        Tue, 15 Aug 2023 10:38:54 -0700 (PDT)
Received: from [192.168.114.133] ([107.119.56.177])
        by smtp.gmail.com with ESMTPSA id j7-20020a05620a000700b00767cfb1e859sm3899603qki.47.2023.08.15.10.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 10:38:54 -0700 (PDT)
Message-ID: <9a4553c6-cd70-b99f-1186-7c3a0168165c@gmail.com>
Date: Tue, 15 Aug 2023 10:38:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.4 000/206] 6.4.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230813211724.969019629@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/23 14:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.11 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

