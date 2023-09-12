Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83BB4422
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 17:35:11 +0000 (UTC)
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-655d25f3678so25195396d6.3
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 10:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694540110; x=1695144910; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yKgCvol1JzLTTChhP3VLdzRO6GqcPOymhq/VwIVtzK4=;
        b=k6VS/3Jl8U9lfbbygF829GTP+vooBHfTfApl2guTaMEcIbMaqs+eO9LVJJBu8Nvnxo
         JeQC77ioT8ZgV5Oq8Usuxr+XBlB9dVC2R6Zd1HfxxU2Idx5FjXaG5EDffW+YXEfC7yWL
         NbQqfF+9mcEGEe4OWbRlKiBPuh3QBh6dHS1f/9IAj7k7tXwKsfJIwqHV1QZwEhC+oI9k
         Ka288zZ/FwZODCHJD6tXoP4Ex0kMzjdJx/RQCwFu/7hUJqjkfG2JTQeIl1DNLoioYKMV
         EKD3d0TlIbdXq+AvUl1JDJQ/1QZDCLU85m9IICW1LOo2tR8X1vR33st05MWwSX9ebSTQ
         EhRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694540110; x=1695144910;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yKgCvol1JzLTTChhP3VLdzRO6GqcPOymhq/VwIVtzK4=;
        b=DiiCVQ9M6dArpwotTpLGZgCSQTmu0OXRYGw9eolqFqMz1QyTfDmnugarqlXKwus4pR
         LWUlNpaSTTlUDXR2Wfa5tlHXwT0+fNnxlEhQPTOhmJefK9juRNHQ/h38X+5gWb6LqHwR
         T1MzIyUjL2R939GP+0gX4cWH9aTBoCv4ndAkx2/0T2xP1Hw3mIZc2H3B0ck4F8UGjN37
         J7C2KqHEvLuZf+pH2MseddGuGsTr4sJE0WWTpt8BHmSJauEKbcELvAcbqEi8P8TR0W9c
         HWfwVmKmQlmBRszYvSIFIlO9p4xtdw9Qvo/cD587CnaBYlCaxVSG51r9pNNkHJ5puKYp
         hJ4w==
X-Gm-Message-State: AOJu0YzUgBWmSMoawtrD0j6pNYWAeIPREo70wxnrryqoymnG1vh6JmiN
	Y1rjJ7Fv8N8nlzN4Wh4k07c=
X-Google-Smtp-Source: AGHT+IHV9F+Tf9UD8lr0rPhQb70NfocrHfzH/nQsnnu2dp0ULBv8jGmQbcgWbmKf3aK67d4nUtIuNw==
X-Received: by 2002:a0c:f892:0:b0:64f:5ad7:f57b with SMTP id u18-20020a0cf892000000b0064f5ad7f57bmr118055qvn.6.1694540110592;
        Tue, 12 Sep 2023 10:35:10 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e11-20020a0cb44b000000b0065359e0a3efsm3849935qvf.36.2023.09.12.10.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 10:35:09 -0700 (PDT)
Message-ID: <19f0d292-5377-3606-e83e-3a5c0fad5cc7@gmail.com>
Date: Tue, 12 Sep 2023 10:35:03 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 000/600] 6.1.53-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230911134633.619970489@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/11/2023 6:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.53 release.
> There are 600 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.53-rc1.gz
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

