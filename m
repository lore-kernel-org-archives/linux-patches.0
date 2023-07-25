Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52781F188
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 21:24:44 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-55fcc15e109so3024735a12.3
        for <patches@lists.linux.dev>; Tue, 25 Jul 2023 14:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690320284; x=1690925084;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DdGMZ3nhAKvZh4BY9rcT4I0j/MWs6ecPuO0p3nOu5rE=;
        b=bXxSJZvblOKlLAgXGnD6CioO9LiWP5Dn1MW2LVqZutjTfDHbabWhItozvlSWlDsFa+
         C4rtv9M0CQEn2oWgGowUbGgpOJyBp0OauQe0NxzdOtOf2oiyg2PJm6e9sbu/CKdjpuMQ
         XAku9m0JPM0Obr9kR9ugRj3GNmZoQC6X1emWuO0+fSDiphVDxFNKP+Cv5QZ049yf5M1h
         O1CnBI1lGrf16f1uS7zMN4iOXfjKZ2I66B9jLnWd8w8cTq77JOwY/v37XmOuSfNco7/d
         xd3/ax/K2fu6MVCy6CTOYYjK/weD8JegDnuLK2Sxa/Gl9u+Ldg3hbteUowQWSJUuJpm5
         LzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690320284; x=1690925084;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DdGMZ3nhAKvZh4BY9rcT4I0j/MWs6ecPuO0p3nOu5rE=;
        b=Egfzycru9+akUf3p3DkwmApz+66H86PQt8SOMY3HmclyQCl4+OwdvQOpTm/4jV8Gg9
         6TOZPbwA74M2UvzdkD7JZUgw2+j+do8dOj6u6gy55lojZjGpctq6N1d7uYK16uBt8NjI
         41qjgEi36WffQl2FbJjDIgnx0R9hmIDj5K+KhvIEuRu/x8OQZk3O4Fwur59d5jQn3fyg
         at2/swl+zNlxxiWIGmCweuWTwFV05rcPcZByf4lbw37bJK5KgcvMZAq7LVFMdyCI5HvZ
         TLQgrU3nhTZ2HH0aMt84qKkdMGnkUdIHSrL9Mi4ZObynhFnpfRDKHKucH8sgHFmOKGc9
         bWXw==
X-Gm-Message-State: ABy/qLbxH9dKdq9rzalRjJ3Av234cw2opu8FFKpfZ7NWr5QPghpQRXm7
	Q4ihod/a00lH+dL901StV3M=
X-Google-Smtp-Source: APBJJlGfxPTf6vGPHwdCOZ2d046ZKGCGPMNe9DfRIkw+7ghicaW796dobYiDSByaxl43MNNWDEUopg==
X-Received: by 2002:a17:90a:a607:b0:267:faba:705 with SMTP id c7-20020a17090aa60700b00267faba0705mr303108pjq.10.1690320283675;
        Tue, 25 Jul 2023 14:24:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 14-20020a17090a19ce00b0026851759e9csm30706pjj.29.2023.07.25.14.24.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 14:24:43 -0700 (PDT)
Message-ID: <64eca0da-dfe1-fb61-27d8-1e873bfb6a66@gmail.com>
Date: Tue, 25 Jul 2023 14:24:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.10 000/509] 5.10.188-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230725104553.588743331@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/23 03:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.188 release.
> There are 509 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.188-rc1.gz
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

