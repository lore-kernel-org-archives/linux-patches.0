Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7D38C0B
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 19:54:45 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id l15so7450940pls.1
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 11:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6lXLb2kAxu1qrxKFIvtwpsX4ghWa+4Y9mIGpesCLWZM=;
        b=Zm2YMz0ltXL+hvMMp6m9/q0f+/mcSg2Hy1AL8uLoRvfGiI7/hDF6FQwlQ3kCUKqQfW
         h55b/8BHi4r8D3Y4cV2cs1X1QhWKTl2jz9yqu/s/p07q3oXMDRlW1ZDYN0bAnDWKh8vE
         JE+wpYslf7OyS7IT+xQ6e/9qn/z1i+u0jAN2Vrt+ehhdBvDhUyeWion1lAvqt9bvDk6j
         c0R0XV8X2t8LaPinBdmyCtjVgF/wT0FHzPQl7a57aLnwZeyfJuU2ZgwC75hSxzT+oCwj
         nBdXcmCRE9lczlS93mdPHv32549y/Y6oFlaS+AOWtoyK1LcbmYFPFr15bIYpWqa8dydS
         iG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6lXLb2kAxu1qrxKFIvtwpsX4ghWa+4Y9mIGpesCLWZM=;
        b=e3jEpBOdOaFLWij03e5eDttmcLdyFtxglzVbRiYa5Re12l58BfxitvTqa/CFMziGu9
         HIJW4dTNvudArd/RJXtlvqu0Z6Nn0CuWKg0jAtMywJBs0M7/f71CwA4be7nCIb3eGEwr
         dJzY7THXXWGXdY7cl8SaHgwr3aCQu7imWaFIYSqKVNaQ58FCa4n8o3EsWINVQB+9GiZh
         96R0YVghYvv4Tpj+82Bw9WTtpFUOji7xwNJjtcTQTa7tzMFOF3pZqv3+kLvYjqDx2PUa
         g6eyycvNJ7n09h6iEq+LQEULVHcsvl5mhmKNNkXA4lPlJgM0Pkqq9iSncN3zpz6bXrED
         c7hw==
X-Gm-Message-State: AO0yUKWhsGw/Uz16NM5RZFI0lFFbd/3Yf3M0h0mFlzGrzUc1h8uisqBn
	OyE4bk6AM4nzDzeWuy8vpoIRtuX9qfNSVQ==
X-Google-Smtp-Source: AK7set+inZ15B1OxI3byvR4e3v0ZSqG0MkSjGibLn1UTgkq4V5j99CglJLFRAzKioatHpF1QUQiyyQ==
X-Received: by 2002:a17:902:f545:b0:19a:8378:bddf with SMTP id h5-20020a170902f54500b0019a8378bddfmr5986612plf.4.1677009285147;
        Tue, 21 Feb 2023 11:54:45 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t13-20020a1709028c8d00b0019a96a6543esm2553118plo.184.2023.02.21.11.54.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 11:54:44 -0800 (PST)
Message-ID: <c03b9be7-139a-a0c3-ff90-673904cf3431@gmail.com>
Date: Tue, 21 Feb 2023 11:54:42 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 00/57] 5.10.169-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230220133549.360169435@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/23 05:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.169 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.169-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

