Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC8742501
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 17:56:57 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-64d4e4598f0so1368132b3a.2
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 10:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685642217; x=1688234217;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eW3QFVF57TKq+xJSZJQaBxxKYLyfH2NJCp7Uqxfjsd8=;
        b=E3pEJVxDo3EZC5CvAjfToZZgPEP2m9NuBKb1kJurZQ+tevnlv1LScOhAn47Tzv4omZ
         qDiUGwHHNI1sJS8EXRvwStb3NvIX/oVlhKntwOXPxCXExqZkguGWUw2Bm03nnBvahh43
         mKQ5f4r1RJc5JCzWKI5vX+XM+0uXnxHUr5ksV0QUx86G7I1NA+BoXHai8rh0+4Bip+2f
         zkl+jOSGHSglRBNn4XET1A8Bg7m9ROYxlOKk0GFn3QSU9EDxrSp8NwjmYmLjJwYwRxCA
         EIo0NCKfGZEeyRgi4P+RrmIfjimf4zsRlw1v4VwugbIs+NtXVLByepdbjioh3Yqtul8e
         KVgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685642217; x=1688234217;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eW3QFVF57TKq+xJSZJQaBxxKYLyfH2NJCp7Uqxfjsd8=;
        b=a+3NO6yEie/MItx3Y/JhkWuPF8aym1WSV4Y6eIGi2peoROYdTOQB5EyIFY9uYGy3zZ
         L3dB+qi4x406yeiHY6oyspE5XR86bZLK/CuQUHI3edkqQBFqvPTmNXdNDcm/F89mCG6U
         BIVjuvYmzKUQpAAlis6uOjOCQevI9YPN9BIwyEOle5cHJo86xyocFEYCrEw1F5RfHiG4
         P65gSv3aB8qnhX3uH1An3NR8kwCtUprJA6tfLE2MlUmWq/RxNcvlr+ntcDwkTSQlFmoX
         +6I+XNusX5gVo/Zv1EUtnPbJmgR0TvaJfDFMHJ68ZOPh1RzyMAvQmQz0p/KACSfaqP3k
         9g9Q==
X-Gm-Message-State: AC+VfDzZfFBshIN/9heRKap6KDM4kB8/3vlXnttXeglauffQUR6LGz6g
	Uo+q6IshSjC8fQ6GQV//z2A=
X-Google-Smtp-Source: ACHHUZ4iUp0Mo1PQUUKsMCABVAushMXRZCylzJ8g1BUdc/cieUhWDCiC+J9eJGKFewUaldTKKFKCDA==
X-Received: by 2002:a05:6a00:2450:b0:63f:2f00:c6d with SMTP id d16-20020a056a00245000b0063f2f000c6dmr9997307pfj.2.1685642216952;
        Thu, 01 Jun 2023 10:56:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q24-20020a62ae18000000b006414289ab69sm5364231pff.52.2023.06.01.10.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 10:56:56 -0700 (PDT)
Message-ID: <de024e21-6cb9-d90f-9a0e-561ba979f242@gmail.com>
Date: Thu, 1 Jun 2023 10:56:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 00/39] 6.1.32-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230601143327.479886832@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230601143327.479886832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/1/2023 7:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.32 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 14:33:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.32-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

