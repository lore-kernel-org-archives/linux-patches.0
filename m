Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E9EDDAA
	for <patches@lists.linux.dev>; Mon,  8 May 2023 22:15:55 +0000 (UTC)
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-75131c2997bso1974430385a.1
        for <patches@lists.linux.dev>; Mon, 08 May 2023 15:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683584154; x=1686176154;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ni12ezVQWBIVjC1x6OzqxuM35vVSI44ZqU17E3y1hIU=;
        b=UVqOGAdcpqwhA0dnudO4ZybK1VnpmRCZHaeTB0TRT/qRkVrJtdQSlzz2RW6Jcx0OEL
         CgJ4O4e6jGZtfnb8Jxnnf5JQUGLzbbxka1M9OLNZfm74LYsff6RoTDJwYNFzVvLwT7lE
         c5lWujJpsqPbYF+2xjCxhq+ZsR4DFfvrGOLz51sV/GsnIP+qzOou8OIyZbmWqyBzTk3M
         dCqTkL7s5C0z0PK2WId9riL0iJZrA0Qj7xbgVlj1ibKmn79TAyBv3NkCauO5TKRwXJp5
         9Qrjz4Lx32Eb4JA77/kYpM645ta5Se8vKxUcosTakPR4+k7t45lef6s8lmnm7U01DNYZ
         T+bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683584154; x=1686176154;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ni12ezVQWBIVjC1x6OzqxuM35vVSI44ZqU17E3y1hIU=;
        b=A6nBybsFZ2QiXXuAgVDZThxGBYC6dwvsTge0Bs2VgQcla5QHoCkAHJyNCLd/xDvlNM
         lzin4qqqOsFeyDbjgCAsfxWbT+9WfdfjH/3cCXjyeFwCDDrgFs/ixeSY5h6tsarje28b
         l8ALvY3BnWSwdJ+dpgaQUWVtcA8+x4l0Pr/ZjpN2CSQtdt8bgDtPItrjnry6H+a2asfj
         zYN2dFOcRcarGi4y5bznpWwURkmny54ZXxa2UgIukItspPzkLI22U09/j/9wnGTuli+x
         wlk/W8U0WE8iCLiRHvcfcsD+FDrss1bhThMT6rNS+lqxKlu0x3x7ovHpUPZV/UP/cSyO
         IZxw==
X-Gm-Message-State: AC+VfDwCQSKAPpc0BuB7rCqMujKHkknfaBeqnfeRU5HkO87pkxRZ/aiS
	xJSwawEQ96SbstCRA6ylb8k=
X-Google-Smtp-Source: ACHHUZ6of0yPAiNNSx4lAuG2KJBTZqz0VGy8qfeIqIa/Ft/la3BvV4KcXa9cI3Z3LQnCw5m69fcz1g==
X-Received: by 2002:ac8:4e8c:0:b0:3df:a280:b622 with SMTP id 12-20020ac84e8c000000b003dfa280b622mr16807715qtp.13.1683584154447;
        Mon, 08 May 2023 15:15:54 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m12-20020aed27cc000000b003f364778b2bsm105634qtg.4.2023.05.08.15.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 15:15:53 -0700 (PDT)
Message-ID: <e9fcfaab-a28e-627d-97fc-a5749cb41a1a@gmail.com>
Date: Mon, 8 May 2023 15:15:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.2 000/663] 6.2.15-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230508094428.384831245@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/23 02:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.15 release.
> There are 663 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 May 2023 09:42:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.15-rc1.gz
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

