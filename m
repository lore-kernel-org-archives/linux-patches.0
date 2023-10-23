Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A463F1848
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 21:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bxlioY2y"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-66d0252578aso22375956d6.0
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 14:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698094877; x=1698699677; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YbeI5inRzR7k95NjvuTc2Wfz9EEbnQ9XK4gjlca4j1U=;
        b=bxlioY2yN4LEE64wd5T29x3FII7hdAC15j9vc+5pSiovvoXh5gLrqRiOFKtSBQpjRs
         +pUw8CBli0GURxChc5ZPVavI4hYIGn2aDq4/zWLK2MHvgQ6K+jgiS7oUP+BqiYLUaTsY
         PigBMhNuRGFLp9fItrgaZqwVhA5Bhtu0EBu470/IvWyenx/B/Rzzm2uGU5Ca+AIJDWR6
         W60Oaex8YTrUSPmCZusfZlnysHFGknixj9Ao0Q4TzwncH9pQ+8VJyorpXTsHcGQpFwT2
         u4ir5mUKZYkUaCg6fxPiQ8VyPJz/rCS3QtruTNcjr2Wthpy4qs3SMWRkMqYxhTVEmyzw
         gceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698094877; x=1698699677;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YbeI5inRzR7k95NjvuTc2Wfz9EEbnQ9XK4gjlca4j1U=;
        b=akZ2cGFPsFoSTOp+7buY5IYcNZVxhxGr/JpWsMa5c5wcLLPMAJvHwAqO3KOJMJTflC
         PMzxI2MDQJ9QsjfzIZ8cwmOVVQvDgvBL9prJuj92/jlaikPSdtW5XeEQ4EGSDvuIqvZL
         HkfLE2EdendxQuEU2Zkigs0j+nDqNnzEWPNrU70RU0HZZJLJvtgz08DsHcypqrUGPW5o
         7xD0DXpTkA3er1tliDU2S1tR7EExLCtg81ad2nEpwtgtSQU/7VvJcUpHWHpIuNcbUiJo
         JCNbq+rDnIK+1lG/T2+CjeifIbDkfTVqIGfChGMX86n4kmLkK4krN+rCFcFO8p++9CbI
         XAMw==
X-Gm-Message-State: AOJu0YxEy1iC92DMTsrMIVekRzNnAwVFmEdqdPKikkgShy1YrnUCSbsI
	R8NGAwshQ9OVnIudEXPSWes=
X-Google-Smtp-Source: AGHT+IFpbMGlO6hn9OtY92vdiN8s8picsYdngOOf/s+eB+0K2iCLDsU98Dk3YpMsLCbHR9aWWL5o2g==
X-Received: by 2002:a05:6214:29c2:b0:66d:18ec:8e7b with SMTP id gh2-20020a05621429c200b0066d18ec8e7bmr13255980qvb.62.1698094877337;
        Mon, 23 Oct 2023 14:01:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l4-20020ad44084000000b0066cfb9cc087sm3148888qvp.134.2023.10.23.14.01.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 14:01:16 -0700 (PDT)
Message-ID: <0dd204e6-5f16-4c85-b8f3-949b673464c2@gmail.com>
Date: Mon, 23 Oct 2023 14:01:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.5 000/241] 6.5.9-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231023104833.832874523@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/23 03:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.9 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
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

