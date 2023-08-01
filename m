Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6EE2358D
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 16:30:26 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-68336d06620so5726244b3a.1
        for <patches@lists.linux.dev>; Tue, 01 Aug 2023 09:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690907426; x=1691512226;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W6SHihvZpMURcyhm7Z81CBDjuSNiSBVG7mTtgS7+Wb8=;
        b=gy5ZfNOUmH6cM3NLp0tiUJKLaahZnFZlaJqPZEeC1a+ancG30Y2LQxTksSk+v9QrGU
         N5ilAtVSZlnBU0bpvin7raZQG8VPka9wl3+8QLf5GPuQXW2/bKIjoUfYu2Je2s5hn0qi
         X+p3Dp+0v08XvxzSSbGZh/BxU7pxK65JgqyJ8knTC1IfLMIrzXO8ndOVIDCpubpezL1+
         n6U5RWNrErAPhCYRanpscP7/9f+iMmfn1ntKMp1KDTYK/pvtqbvsIUh3z4/WOiffn5IW
         aZpUvvipLNewQxta6EmnyRRzThftEh7LTZl7wjM0ELmtWZPGti81jpcDoxLqRuGQaX9P
         PHmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690907426; x=1691512226;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W6SHihvZpMURcyhm7Z81CBDjuSNiSBVG7mTtgS7+Wb8=;
        b=WycFioxvlc5jukbCArltvoUK6IcDPFVzCUpKGuHv+U9qwHIhYVxcwPg+RJkLu3HrWu
         DjYgqv3P3Biuxu81EQX9F2haapQu3UT7WoOR8GQ51f/4XgSvKr8iUv2tMcbtjFqNH7I0
         RiW4tD/urCxtXBVA+7GATp3m7Z8PNYhImG5dMbTkE/5/pQ19x+uNb51DDfQQtYzFIk6K
         cV8ko9gbS0mdksHHYc/Tam+ueh8xDev7TwaNAyoqvpFbG+cCXIVt0bjhiP+pgIDIByZM
         JLBkgaVUUnypB2H8+7crAOnFLWv/pV0FBpMLMx3GpGepZB6SJh/LUoHm3FXlItJ4FR86
         J/7A==
X-Gm-Message-State: ABy/qLb7OmikbShy7pgmVae8wF/PgVW55QFlqRVnS6rjsrM92HDpdHG6
	C5ta8MSfg8bI5Zg17qWBvMg=
X-Google-Smtp-Source: APBJJlHyV+DNAhqLdZDvVlGGrpxeDH3ScXnLCA79TbQybXBy4r9sC8kEeISZVOW1Z8bNFQBx3wZKxg==
X-Received: by 2002:a17:90a:b306:b0:268:2523:652c with SMTP id d6-20020a17090ab30600b002682523652cmr13179348pjr.31.1690907425773;
        Tue, 01 Aug 2023 09:30:25 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g12-20020a17090a300c00b0025ea87b97b9sm1456497pjb.0.2023.08.01.09.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 09:30:25 -0700 (PDT)
Message-ID: <03b23f8c-91c3-4ae9-b86d-4aa6c8cb5d78@gmail.com>
Date: Tue, 1 Aug 2023 09:30:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.15 000/155] 5.15.124-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230801091910.165050260@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/1/23 02:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.124 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Aug 2023 09:18:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.124-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

