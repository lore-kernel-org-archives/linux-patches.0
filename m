Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19ED7DDAA
	for <patches@lists.linux.dev>; Mon,  8 May 2023 21:54:12 +0000 (UTC)
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-61b79b97ed8so24062826d6.1
        for <patches@lists.linux.dev>; Mon, 08 May 2023 14:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683582851; x=1686174851;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dtAzQzES9I7yNwBqIfwbZWRv7FD60/LkD0fvdz+X1d8=;
        b=CIf1JSnYYmsFIJlhk4/NzzeglTtB+d0mZwmuhQC6ECCTliVYouVKf+YTOlkvvIP0Wr
         Zob9QA43bAD+lk1jJaxYx5Bgl6s730KfkuL9qUqBH2sk1ppZ9bf4EdiyzbqMy5KSpjAp
         lKsB0EpaVBtFs9iISSEm4p2CnpQG3tfP7wFKQxYyLspN72+gO2XbDJLovNZq7YoMXHw3
         YyrQFLmrnh42UJ5lXjFNc403wWR2gyPh6pWgvD20ZEgB10oiAvTjDyAW+9ZKepL6Ut3S
         g68jGhDYWiRVBwlKp4mDqDDwh017bLBPa5Byi5QMcAgp3Q2dDImxDTWAjqS9E4kiXNUQ
         JkWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683582851; x=1686174851;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dtAzQzES9I7yNwBqIfwbZWRv7FD60/LkD0fvdz+X1d8=;
        b=C5oWJrvY8p3rXN0zkNRXzlL4rNaOq1xLj4uDPfiAiSNO6psnKyB6jvCgLQh2pUkGVO
         gCcua8/sYxw3N+FzcJJH3Yk/QN1DrZNLAYLq5pAJO5T+sbFJBEpSOWNuCjH+ApTu69gN
         lDrmYu4nus2n1t7OfJuro2EcC1xTIOxHMzEXk8yATEAm87aLI9RB5TMpg1jdsODz8BRb
         qQkiCU3+6kSElGmof2RoCMpc2t9wpSW6Ta/04pk7ZKCAG89dV7bxNZrmt+MjI+l0L/Nv
         aNMetixtXmDfgHzMRt/Z+NS8K3AuxK1pvMGakJwHce1XMTRxW53o8Rv5jwL+8uR/p4/k
         Zsog==
X-Gm-Message-State: AC+VfDxd7UvyITpqWqp/bNuROb9ZQ+C7ubTiGNOcuBRzi7oAVyrB5Fjo
	/qwqZVHNwx61Qh447OlZWtY=
X-Google-Smtp-Source: ACHHUZ5ybom6RrSpzq1VYoTnDCdZYCzJWdBq24QpSo2V4yvKhHbc0LizO4RGX3O4ncfCrXa24q9GPQ==
X-Received: by 2002:a05:6214:4011:b0:61e:800b:4fcc with SMTP id kd17-20020a056214401100b0061e800b4fccmr18449504qvb.25.1683582850910;
        Mon, 08 May 2023 14:54:10 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n7-20020a056214008700b005ef5f8dc89esm284571qvr.88.2023.05.08.14.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 14:54:10 -0700 (PDT)
Message-ID: <7f899e9b-5a3d-7150-9b47-aef6280ab3c4@gmail.com>
Date: Mon, 8 May 2023 14:54:07 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.1 000/611] 6.1.28-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230508094421.513073170@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/23 02:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.28 release.
> There are 611 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 May 2023 09:42:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.28-rc1.gz
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

