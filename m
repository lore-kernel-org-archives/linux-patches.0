Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E185A17FE0
	for <patches@lists.linux.dev>; Tue,  9 May 2023 17:18:25 +0000 (UTC)
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-757720be6abso165872185a.2
        for <patches@lists.linux.dev>; Tue, 09 May 2023 10:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683652705; x=1686244705;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lVBbbB0GLPur6nb8BO1G5j4FrYFhbeRvMJQv2Lu3H0c=;
        b=r1h3BOoj35Me96v3doCTbYqW9CU9k5NRI42HMg/sFrmebAnr/K/iyvDPg4PO0umWXt
         +yaXnnvdzLAUO0wGsGh7AGtvzwVBNop8YVEJGU2w+EKRHZ1out5p9Np1o3Txnvp3p0VK
         Ay0PA39d3RRy03s2XS14MYe8r+eJ9C3tgKQilQIlLKFxApkupOBPMHfMrwCo356h02Sr
         xqN6k5sXp9izPD6sRd95qG/jQ4K0hV+d9FScIszYaNuIDebHs3LSHYPCA0cEF2uoTUOy
         nKqsN3jtuHXw6DOLZ3vD8GuvKmhNZ4s1UeJfV8w7jn68zQ1YD12pvetOJIKE5+fLr+lS
         zXjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683652705; x=1686244705;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lVBbbB0GLPur6nb8BO1G5j4FrYFhbeRvMJQv2Lu3H0c=;
        b=if/jGhdpWU2cZ5shkA3KBBZCWacfL8BIDgV/6mYkHM7xqpArQYNTazpk87cyoKJchH
         GV5HX57rEVQQRsL4mE5hGWeZa1AnX3qP8UE0cjTr1za9NveI9bJ2TV7IWsurDJvCo3OT
         pKzRDbFAISoTr3biyFXml9fDsNcPBz2a5+BIMU8oOlnbfSqPv2AMOzcCJ6Q+Si95oS+P
         zYutYiir5EvDhfCIbu/cmg0tOljtZonraXxmEBiWZOjhOyi+Z2v/KMM/wsSNTnFkPDzs
         I2ei0z5kemXD30AUxIHcE/jeNpQwn8qlFZVDy2a1PE1CtysWRLy3l8pwlaU5tjY6CxQw
         JCHA==
X-Gm-Message-State: AC+VfDzZ5Q4grS0Y9i7lOHEar4C28tmdCqAJGdXlDy5EBHq1lDLBpNFR
	cdBlEexFbfyaquvocsTykQ4=
X-Google-Smtp-Source: ACHHUZ5SpdGSyrpJy6yOhe77d44bAgI5Hwu7cBtxx7aYFRM+x1Evag7WZNyyD/Ry/uq8lvt6/u7yYw==
X-Received: by 2002:a05:622a:1353:b0:3ea:bac1:a5a0 with SMTP id w19-20020a05622a135300b003eabac1a5a0mr21342715qtk.37.1683652704712;
        Tue, 09 May 2023 10:18:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i2-20020a05620a144200b0074df2ac52f8sm3416388qkl.21.2023.05.09.10.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 10:18:24 -0700 (PDT)
Message-ID: <010cbf15-676f-e6f2-e750-ee4e9e561f32@gmail.com>
Date: Tue, 9 May 2023 10:18:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.1 000/610] 6.1.28-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230509030653.039732630@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230509030653.039732630@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/23 20:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.28 release.
> There are 610 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.28-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

