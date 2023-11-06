Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E2E29420
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 17:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DXt2+yGD"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-28028f92709so3651873a91.0
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 09:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699291955; x=1699896755; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jIBrIYqApw7fSHDtPe3Pg1olZEmzuGAS+T77XqoaE0s=;
        b=DXt2+yGDAaTWr5X+wImT2qBISD0nL08Fd3dL8YNEUZK7Q12DfdBH1eJZH6Umi6ukfE
         7JFJLWsWu4kcJAi1UJhRu/zZsbRxCUV9sMzpC1DNv3J3vK5lFMU2CAiM81VoDJFW3fQU
         JW1bLTVAnFaQYTE5HF7NrDOpXmXMTeGqpz1KiPl0qPm/OHfJH1RagrkVd509k+Y8OdAo
         73LpRyjKKkqxCimSqwnOmyYBLQYWI9BR/AEqGZ4MJh4iJIerzRSgmzFUdm1OWSm4gh/J
         CUu0fyNkwmN7KAbwbyhqz5YNph8M0QnauvfSqqXXVd674mVC/rlOra6ecFPjjQxLtMyu
         kV8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699291955; x=1699896755;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jIBrIYqApw7fSHDtPe3Pg1olZEmzuGAS+T77XqoaE0s=;
        b=H9UzmaQX01kxoJF7vRl6sXDdojFfKb1slaEdlCgKuAFbF/9k8DAxPZK0wM5lNFUrCx
         0FPHSqVHFhwu7uH54ibGXM9hMMPsHqaZNwhcoeFS5j6rQMksAXjbzq/qdkT8EiXI/pDW
         4z1fjUdU9qNtXFRMAQdvCwlJdJurxgkuCfXhSdF2TcnxSxiQpzYICte0AOzHmbZeZLgp
         FW4IXUJHzoBmWMCh998Qud5SikD7ueQjzMAnwptAu2NixcY3M/o4HZCKvxdD6TBJR086
         dTrt6vVEalVPDnjj3FX/67ogepFr7qtuMZQ1Zn3LGawt96a5oUWaoEyxO65veTdvmntW
         VodQ==
X-Gm-Message-State: AOJu0Yz3YObLVm/Gg2qDbQx3o8rPEuY6fZKB92+aB+jhmiOXQQj/AAVu
	VircqasrBZ/g0EANFO/jiNE=
X-Google-Smtp-Source: AGHT+IHjmwc18Ai8f/eQ3aVPPqt7f4cG4Zh5ILvd2PJoi3fWfhA87/WnnKR3BGJ9KZaTVcqHIW/XPQ==
X-Received: by 2002:a17:90b:1649:b0:280:fc4a:cbca with SMTP id il9-20020a17090b164900b00280fc4acbcamr245666pjb.5.1699291955164;
        Mon, 06 Nov 2023 09:32:35 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 26-20020a17090a035a00b00274262bcf8dsm6383055pjf.41.2023.11.06.09.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 09:32:34 -0800 (PST)
Message-ID: <a42cb7dd-d87b-460a-b532-5618174f993a@gmail.com>
Date: Mon, 6 Nov 2023 09:32:32 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/74] 5.4.260-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231106130301.687882731@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231106130301.687882731@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/23 05:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.260 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.260-rc1.gz
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

