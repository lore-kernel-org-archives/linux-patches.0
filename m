Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2E453AE
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 20:43:27 +0000 (UTC)
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-76dc77fd01fso79415085a.3
        for <patches@lists.linux.dev>; Thu, 31 Aug 2023 13:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693514606; x=1694119406; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4ZEkpgI+1xGvtb5oOFsSrJIyIMnI7mF5GQF81tetMAw=;
        b=l2Sgq3WwniVMruxtGVIlho/Hp5xOOfvaodWZ8D5TdT1KTsvuVz4chjNxZjAaRzs0xb
         n9AZHmWTNQUzTO+t+nWA7NkgSi9Q6dUBb3pUsYL1IY+2nG9e6bpgh8hPmO/TWI2q1EjO
         NlH9j7H6EnBEYlMbjH4qKKMtuWCaGbUpVlVBzuI6Jz9H+d3spP4jGMTSJqyLxYHUolGd
         GfZUYjM2wrGvT9Fk3hhYwCbyt92st8vn9+393A51pWlIFtOqil+Td7ApP0CYc8o0Qc6M
         eNPn93770CzYyHdLiGUQov+xjl/gLnVEV4WjvXj6hfBpM8Ip/5gaqnJ/3m6jFwD2H6n1
         b1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693514606; x=1694119406;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ZEkpgI+1xGvtb5oOFsSrJIyIMnI7mF5GQF81tetMAw=;
        b=h4E5UGZXj2PRfzCUGamv2wjadITH8axQ/UmWynYKut3SVeIpPVUMl0sY/pRFvQxFxi
         b0HBMc7LsVE4OyjwBmtTLlaW+YH4EkuSQPpG9XwWrdE3iptsL4FJhNDo/VU9bRNajsmr
         qIXbnKEawDBC1OEi0mY+2XhcI4u+Px58sC/vPZ8vay3TGlf9XyN3H5y6eDO+dw+sK1CN
         iA+1gzab83Ukhzm2JKTm9GI/Ox105eyi/qTB05T4v+306s0ekgzCBmmjORoFbHPdyd42
         RYSioaMomTCbhuKLiKturpJbS7S7tIFnOo4Q0NILdsCKLGjqEEKF5ytMbTfTsJ+215v0
         1AyA==
X-Gm-Message-State: AOJu0YyDGXtAfFPUqp3hqex1P7rh8gvw0L5HPKUf65LL/KnlYPq2h2ww
	nj2RnDzgev0AVv2ra+RkSFY=
X-Google-Smtp-Source: AGHT+IEp+IPzo0Pw0JG0bt36rjaOYI2aqAxXTUBCCt/Bq5AbEV5G3X1iHPGrpD6JDmVg+1XHODRsew==
X-Received: by 2002:a05:620a:17a4:b0:76f:27af:2796 with SMTP id ay36-20020a05620a17a400b0076f27af2796mr627289qkb.60.1693514606114;
        Thu, 31 Aug 2023 13:43:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p19-20020a05620a113300b0076ef40734c8sm877942qkk.79.2023.08.31.13.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Aug 2023 13:43:25 -0700 (PDT)
Message-ID: <890f7c2a-f87f-308f-fc77-cfa9cfef53f0@gmail.com>
Date: Thu, 31 Aug 2023 13:43:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.15 0/9] 5.15.130-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230831110830.039135096@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230831110830.039135096@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/23 04:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.130 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.130-rc1.gz
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

