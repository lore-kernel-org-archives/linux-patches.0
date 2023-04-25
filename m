Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765743C0A
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 17:39:13 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-24986c7cf2dso5318899a91.2
        for <patches@lists.linux.dev>; Tue, 25 Apr 2023 10:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682444353; x=1685036353;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u0GyBkVE1jq6h1UTyHknq9im3hMJEVZDEDB7SjkZ9rE=;
        b=mOHbdCctckLQsK71d6JeznFiHpUgTgoVDfA4I1d4ERl8NzDZm8hw7inSpHfmlKSI1I
         JIHQUMpk+1w5to+mZG7cZhbIKxDf5vNXdZ85VZTxsz92xlArBK7vleB4WVqdod7ZvrYw
         NrA22RXdUELhPhXWCbTYZAdCZqOQX1qwge96e0o4YvlBJgHH2yrHCStyl/dkEwtxv/ns
         V5/10GEEi2txVoI9C+fv+gigHJG9Dvfc2DJQdyBEyt/Gd8FgyKH5718wLCJIQNrWM/zz
         LHMJnPeNsaCSWQ2qS+0e0woFuR4Unkj6i/MivOYXmZpxZ6s7QpextqKKe0GJquwo4Eyy
         VnMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682444353; x=1685036353;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u0GyBkVE1jq6h1UTyHknq9im3hMJEVZDEDB7SjkZ9rE=;
        b=PYO95JsW/FYXNjCqb9wF21wFAEimKnHsTzQpTaIeoIbQeyEotB7jEy7kzvqEUg7Rgs
         ASQgrtbWZHzV7rH9NFoHYR8poU+lkyHgdWj1lNzz7nIY5hTpcOQF4HkSsekwrVpKh27g
         341fKn9xC9d01ukKiklF1DNNuIBp5G7dQ6Ro6/q84vvlUBoLPxUjptJEzeK7+sQ+EbbC
         C4NCQhs7qOKKhly9hPty01tlFtEUAKNZCG+kohBjja4PKQy85qfcVQ0b16E8r0x9Gf+B
         rvxwTznQBlQ/cSh+3vvtH89+3SgiiUucKbfQc0PlBM6L/wK6mReKUZMStQ76s2bpO/HE
         y7NA==
X-Gm-Message-State: AAQBX9d8+yQIILOceC/a5D65+YA8xnKLB+wyUqSaDhW2S0tOpqTAqvI0
	o45horUTWYrGtsjh/GVf76M=
X-Google-Smtp-Source: AKy350aCYLCu3HEjMHOaSFEpgIEhzjdathjT7KFIU8M/HCjkphQvvS+advWRwcCxk5dR6zvYzEO/iA==
X-Received: by 2002:a17:90a:c687:b0:247:54c7:1bdd with SMTP id n7-20020a17090ac68700b0024754c71bddmr17907988pjt.22.1682444352534;
        Tue, 25 Apr 2023 10:39:12 -0700 (PDT)
Received: from [10.69.71.131] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y9-20020a170902864900b001a800e03cf9sm8486237plt.256.2023.04.25.10.39.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 10:39:11 -0700 (PDT)
Message-ID: <6c695171-739f-4e70-77c2-7ef79ee8f5e4@gmail.com>
Date: Tue, 25 Apr 2023 10:39:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.4 00/39] 5.4.242-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230424131123.040556994@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230424131123.040556994@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/24/2023 6:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.242 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.242-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

