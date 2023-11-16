Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934BB46522
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 20:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QzOtRK6H"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-66d0760cd20so10742076d6.0
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 12:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700165849; x=1700770649; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jA8Kf2xvnSFH4T2vRR6MMovJYoXzknMX/4kPrbr3RB4=;
        b=QzOtRK6Hy3sgl/nwdwfLllPUf+yNSkLMU/zM16N4OUSW43Bxv3teT9E/n/ga/sKw3R
         7iXpxFnwbBG9EJ8d96dp8pTK80HyeBDFcRrxwHq480UlwFH/Bd2zZJnwlT5DjvMLvEDe
         VD043OP2PwiMuGOQ/H/fXFbbPriFNqzx8dw5wfQDQISc1FG3ENYkjtNl0KK1qEzqel1F
         PRfh1+4uDDNg5/XYWrc6obsWJhMipvJLPnECjT5u9kmUR+JSJCe3VOxhbusot+bDl32v
         SNXnewf95dKqQ/JENC7j3F22Ai1C4H7BXqgY3iM5dzQyms1uFnEpacM6s8NtthyYWCaM
         6hVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700165849; x=1700770649;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jA8Kf2xvnSFH4T2vRR6MMovJYoXzknMX/4kPrbr3RB4=;
        b=ivU89miL0KBVVl5/uRKyhX6kFfFGw8+5PKBHQeFwak0BPFdUzHFQT2V1wgybh/a/3o
         +r0mL4g75I1rjYIti4mPbDaPGohe9TyCqb/hLip6u01vcO8+qdxsG5SGuwtcLMWXf8hU
         9BXgyWlZTqlhfi0sCdIURGXgunqhOj2fDnR7p/ZV91Nvkz9q4cUFtH1va/WB7+1d+B80
         UXo1U3fHCghFBVdQL7Py6pvt9Wn+EXkBlcHbzw8qX35PlpOMRwijmLv1sLC7paz+4Jtn
         oVyGwP7siLQGL8E1J7LeJcAj9NDiNXzP14JgPB5R2JxBq8lYN16PPLwVyB4LJiMgm2P1
         iYwg==
X-Gm-Message-State: AOJu0YygD6HznPT5YA5YwqYSgMJ+BDiZhfK2zTq3JN9nHA8NLcjIMlOS
	cgecF9Ws21uIeWPCa9TkAZw=
X-Google-Smtp-Source: AGHT+IEBR5eQSqIyrMm+k6Ud8Nw4s21ElqriwLQkbTlLqTJCI8hd1WMpEWFgPawnRXbHpEEbWmQ82g==
X-Received: by 2002:a05:6214:161:b0:66d:2ec5:c1b9 with SMTP id y1-20020a056214016100b0066d2ec5c1b9mr3827300qvs.11.1700165849521;
        Thu, 16 Nov 2023 12:17:29 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c10-20020a056214070a00b0065d1380dd17sm45796qvz.61.2023.11.16.12.17.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Nov 2023 12:17:28 -0800 (PST)
Message-ID: <9e94d5ad-d682-4193-b965-edea91a9fbb4@gmail.com>
Date: Thu, 16 Nov 2023 12:17:25 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/603] 6.6.2-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231115191613.097702445@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/23 11:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.2 release.
> There are 603 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Nov 2023 19:14:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

