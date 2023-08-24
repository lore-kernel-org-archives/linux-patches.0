Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33483134A1
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 18:58:13 +0000 (UTC)
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6bca66e6c44so159961a34.0
        for <patches@lists.linux.dev>; Thu, 24 Aug 2023 11:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692903493; x=1693508293;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cTx6IU2Ceazpc05DJ3qYtLFFrnEetHYitYmMRZqMriU=;
        b=WOLiJcE+SWGGX95VXh8H5Gr76E5LwURu/6NJSn5hiS9LCJOGs5VrS5QEi5bLxScIFd
         34lnY0cKM6IJd1QNEnC8gDaZsz1LkpI8F/e7jk+DeMBC7utnS1U2mHjU3vq3SlTWgqP5
         GrhBFTetM2eHXydSnonip/+IXf5G+ZaA3epaYiDZEUOmSihNzeE8BACiRaTvSD99gvex
         PLGJ126FYShxKGXA5FgdFOfjlwvnJIP4RhnDDwcNwgTzyZFlgOo/GgujQgPdDG0HDarh
         YSS4iJ/q6zH6qNzIAoSAcjLy639IE/p9vuKv4QCkzzKtIiGud1/J0SxNqE56+Drlvezt
         2wsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692903493; x=1693508293;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cTx6IU2Ceazpc05DJ3qYtLFFrnEetHYitYmMRZqMriU=;
        b=jez/dc/Pmc27rOnerkiuvglRrWmu+GTheiRdY8jmRydoKca+oN5sz9LvTHM9t57l25
         DTod9AOLVUbJnDaWKchkzH6ov1znTyhBGwcQ5q1F+NcgwjIcDa1kNEpa/4TeNUWO/IIL
         mkrzEGKWl822sxH+3OAfwKAIoaUpvVpqtzpFC7cutReHvAiJ2AyJbKUYxTNst2Kw33ML
         hAxUINjVjZQUjQHdstaTOkJTz+C2kFMB8+fjSxd8X9mjPkSgLXI/z0PKc6Umq+nHTA9n
         c4e+/ovdsZNNt3pavHgiSXb1RBB36WORveiIVdJh7Rx9Didw+wQAjbzsY55QU8loLxhC
         lprg==
X-Gm-Message-State: AOJu0YzVs108s84tDKNbKC3PU/v7gj19hzJJMiMBCq0zBdXUIM7wiPLV
	fd+J7k+TcJ8W5gkWwshpQnE=
X-Google-Smtp-Source: AGHT+IGIdGYFpUdJfRknf/yomB3a+RSBgDVRGmkaCdT3LuYrH7cKx5fAD4wFRuW3ARgGvn7lLsDbbw==
X-Received: by 2002:a9d:63c1:0:b0:6bc:cace:c07 with SMTP id e1-20020a9d63c1000000b006bccace0c07mr3417604otl.18.1692903492877;
        Thu, 24 Aug 2023 11:58:12 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id jr16-20020a05622a801000b00407906a4c6fsm25855qtb.71.2023.08.24.11.57.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 11:58:12 -0700 (PDT)
Message-ID: <286fcd22-35a6-54f3-4abd-9bfb415defdb@gmail.com>
Date: Thu, 24 Aug 2023 11:57:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.10 000/135] 5.10.192-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230824170617.074557800@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/24/23 10:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.192 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 26 Aug 2023 17:05:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.192-rc1.gz
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

