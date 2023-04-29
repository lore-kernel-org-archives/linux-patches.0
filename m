Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE254320C
	for <patches@lists.linux.dev>; Sat, 29 Apr 2023 17:14:43 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1a69f686345so8130595ad.2
        for <patches@lists.linux.dev>; Sat, 29 Apr 2023 10:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682788483; x=1685380483;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CNntHbXC3KisuUZTZB42fQ54DMYWor62BVWmA9HgpkM=;
        b=LpjSU1aZKzOY6dbXM3xDEZZyveLWsKDCEKnmVUuhAi0XccmogbroPfxIjZTiEISSXF
         Y17w5jOyBCP53YVX6nnayDKKsB1RUAOYAhWRGBf1AweD3oAXexBMxRaauxUeKS34o7r0
         B775rPsQ5jxfPcJNUNrdzhVv9CljB655sjZH7x/xPfN2q2eFREvMwfijthwbxGSaGv8x
         9pLYfwaQxwUpmhmfpsjlYH07e8Z5qp5M1lOYWPunb85EIQ51rsFPkcmortcm0HCVORak
         hsfzlj9owr1XrPuS18LI83a9DsPE+XD8PzPLxYRDNzsfGGFYkKJyB7vHcMtP4+szwd+7
         AN6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682788483; x=1685380483;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CNntHbXC3KisuUZTZB42fQ54DMYWor62BVWmA9HgpkM=;
        b=ltMtOtiwiHhV0DzlVL/Fj4fA89qNkMiV58cjjc8/3AZfkfMM41TDfKI7NFNkvn/gTp
         cSWyJhytOD4pd6WzyLup/0opEAC53656ppblISbxUJin3OMICrZnFFuKS6Kbv3ou8zFf
         Ne3u/AEh4grHzA8Csjg9hUXxSC/7D0b+Rnm7EWaeeIDVq91cXtAqZWHo1PvuPgn09sRX
         tb6+ZjIrnVmSG7hk4i4drjNJRMViYAZz5gUflfhuC1yuR8UT+zjyEpZToIipxwl+8W3V
         8CYT7ZPAugLuEvYmazsS581ej3QnW/9KkAPFemziYtjNA589f1vP0Knu0YAMAVGGp+Rf
         ADOg==
X-Gm-Message-State: AC+VfDzM3qluwfgpMNKrOP8xmKtmAAq36AqMVnH2nScGXEg1AV1x2II3
	mcSUVHXhQyNpFwU8FD+cWE0=
X-Google-Smtp-Source: ACHHUZ5VOCZLhARVzo4w7nhi7d37cdIbOxmUukkZlkV6hjVg4bxeiwhuYlRAVCEtYCBPRZ2L25ruyQ==
X-Received: by 2002:a17:903:1c3:b0:1a9:80a0:47dc with SMTP id e3-20020a17090301c300b001a980a047dcmr9116397plh.3.1682788483171;
        Sat, 29 Apr 2023 10:14:43 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:1c98:2538:93cd:aefb? ([2600:8802:b00:4a48:1c98:2538:93cd:aefb])
        by smtp.gmail.com with ESMTPSA id bh7-20020a170902a98700b001a19cf1b37esm15112497plb.40.2023.04.29.10.14.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Apr 2023 10:14:42 -0700 (PDT)
Message-ID: <7dc812da-6006-7909-e079-4543b0458080@gmail.com>
Date: Sat, 29 Apr 2023 10:14:40 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 6.2 00/15] 6.2.14-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230428112040.137898986@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230428112040.137898986@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/28/2023 4:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.14 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Apr 2023 11:20:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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
