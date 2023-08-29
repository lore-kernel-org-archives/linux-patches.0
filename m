Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3552517751
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 17:46:43 +0000 (UTC)
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6bcac140aaaso3502352a34.2
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 10:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693331203; x=1693936003;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ocew/w2atcEmCSwlMkjdQJJuFYY4ZZA2+kzr8umyZr8=;
        b=Uf+BZ9/FvKEWV5aK4pn0W+Gi4mKLfYKJ2pNzRZ0IsC3B4bTeq/IL9Miie6eRR1KzxG
         DhRqrs2o6KDhSSRjCCGyMH5reXLfAG9kIFVHJbPa0Mf58xcsDzOrkH67m12dxIxLfh3W
         SNBfFw+i/DyLKiBhIpgihfV9nH7oL3RuoGtP6i44ZGd6eDnZnI61RLrv3EHkLv40hR2l
         EtxNNKChCKN8aHe0JXost5NSfSVpt7QRWIK1U+a4bHEKcdk+x/nYYB6XPx5bULdCMVCW
         AOdO9ywoB+53b5XQZZsojXp0taEX+9JIoU9V8Z6WFHv3Yh7/zhdYV3l7MJWDqVAb0sbo
         RMbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693331203; x=1693936003;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ocew/w2atcEmCSwlMkjdQJJuFYY4ZZA2+kzr8umyZr8=;
        b=MQQFPlpbVPxwCdvtl6zMC7oTyGZx8nYL8ssw1B0VE7Sw4jREcKHZM4H3kEfCud5j8p
         i6iwrBuY+9XhYfKzourMVJSXy27wW2xgtOsWbR5vyBFPzr0KqznpjQgcYl8xLKos3PVM
         7LVBCJDkSK5d3lnkgZtXwdg2xkQZbNTlaby21SdQv/BqUXjKsTTSIJyFJQ731UsGcuQm
         f0YXPoZ3+PoP1pzJwVptvP2Q8Rku1cesD6gvrsEso5nGRkmPFtF3GMWGRPe4RAZPf+4n
         k5/Q3Ip1bwDanr0mAdhat3Z59n4qsVa3lvk7+1orG1bZhalZL8MRcX0k3wHpNhqJ0LhX
         iLfA==
X-Gm-Message-State: AOJu0Yx6tpIJs6nmk0xy1xbW3f2oaK06XP9+BIPttsbMJ4yobSxgFN6R
	+aa+5RbGe5ikitoIV/lAqDc=
X-Google-Smtp-Source: AGHT+IF1aiYM5WpO4pbflA43yDUEkRs6AxfZ3StLZiWwJeWALuJ43TCZAU9p2HKF19s1ubZ/shybBw==
X-Received: by 2002:a05:6830:6a0f:b0:6bf:29d4:1886 with SMTP id cz15-20020a0568306a0f00b006bf29d41886mr1460142otb.34.1693331202963;
        Tue, 29 Aug 2023 10:46:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l4-20020a639844000000b005651c9351e1sm9274618pgo.64.2023.08.29.10.46.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 10:46:42 -0700 (PDT)
Message-ID: <ed443975-1fff-3ec5-d60c-a6f5bdc09772@gmail.com>
Date: Tue, 29 Aug 2023 10:46:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.4 000/158] 5.4.255-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230828101157.322319621@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/28/23 03:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.255 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.255-rc1.gz
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

