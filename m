Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E29322D6B
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 16:22:37 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2566e60cc5aso758366a91.3
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 09:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685636557; x=1688228557;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FFU/5Iv9owlTTt86pLJPmhqgSRLxIfPlWHSZUPcuZc4=;
        b=d+NEA05T2No89c3k15b1IHVESm59uCdSRC8Juyn95Dz+Bnd9r7QpSoj/JLeMofTquf
         0/M8aU+N7lfs37n0z+ecYD64QED2a0ezIizANK2jaAaz6RWUnTQnzfH8HGQJA5duLh2N
         kc4PAGywyZGT053Oez0OooMP3+y7uPDPFY4bAFBV41aa/2nglCzVZpjQqFiXwWgxIBmW
         oRwTcBLIcFHQ1iqhYBu9EudNL5IDVGn63BZqtv3oCp1Y84uUY7Fb0DjGO4WAORHcoN6W
         ieVhnA+cY10zWZHpvl2VXJC54+Xvl89pXS7sWKQ1E+SsXPUw0lkZ6ALm754k7xGHDZOn
         TpvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685636557; x=1688228557;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FFU/5Iv9owlTTt86pLJPmhqgSRLxIfPlWHSZUPcuZc4=;
        b=G1FjINx37R3Pjt8iSMC9DZMZYwIfJTqLjXaNr0QA+JZaoas2Dg60XcY/A2UNQrclPo
         2mGa+9cfox09ymC8OAkTuammrf1sM1dq/MYy7+F30H9Kt6BD8qsdTLSuCbGii5fKsaZf
         jYZ87UKUXFaODpzeDE5ykP9rkmbHgN3hr7F33bloRSdD5ibbTWvlOYM9hIUcJLaoRnpM
         uWCLZdo7Dk4o5hxVhGW5Bv3xLmqhA5+tR0ojrtGRoC4bIPqGKOYCh31EHmBGhsESrv30
         WjHTC2LR+frddk3A61Vbll9CNvDY8Vb5mKty+6VUCIaYMVA6gfD0nm3TGo4cgJ4KlR1J
         Ha7A==
X-Gm-Message-State: AC+VfDy74pQ4Iw3SSu6lKLLLurtOrW/13dacLSXPYvSkpRQXV8E4OgLX
	vLzP4i76oQf7oZTHEsN2/P4=
X-Google-Smtp-Source: ACHHUZ5MxBd74DfWqf5JtmxcE4FhjBn6koOuiM99hOW3cotRFG8LyaW/sttp/jZrwO8St8jDqZMkgA==
X-Received: by 2002:a17:90a:ee8c:b0:256:959f:3443 with SMTP id i12-20020a17090aee8c00b00256959f3443mr9903062pjz.25.1685636557273;
        Thu, 01 Jun 2023 09:22:37 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id fa2-20020a17090af0c200b00256353eb8f2sm1651166pjb.5.2023.06.01.09.22.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 09:22:36 -0700 (PDT)
Message-ID: <2c22b77b-3f35-0810-ab40-595c07451973@gmail.com>
Date: Thu, 1 Jun 2023 09:22:34 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 5.10 00/22] 5.10.182-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230601131933.727832920@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230601131933.727832920@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/1/2023 6:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.182 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 13:19:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.182-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
