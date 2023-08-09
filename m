Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724771AA83
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 18:17:46 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-686f38692b3so39463b3a.2
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 11:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691605066; x=1692209866;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EJQ7Cy50cBVPoWtJxevAy6xVINQRSlrLcMP3CSFJ0MM=;
        b=S6GX7kEVUd9BxjShZ+LShn/6Dd0FvN8vTCReO7kF9aFwm5CowNxpSZvLDf7+feMRln
         afOqtI4Ff6yM5lJRBZBvyLTgONSTDCp51K4KreukoUaF8LnEvTCvF6Y+f7Om0Gp1nbpH
         FjEmevlgBV7tI3MgAIph26/7jid68ByoYPvxMifFtxqnA+A0NT2hPNmCvGe6VVrvbfy9
         xrAnyO5OkCkiKnBSzqWu8Jp6GTenzczkyg6Pot/w0yIIVIxtiLpkyqV4JfzpAR6ct8Oq
         ZhtnukLEeANR6+jZdRCcZW4qokjKlKeoebMHg8ufgubWCwAVXRhxJTUKa1lx2nrnr5j9
         FsNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691605066; x=1692209866;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EJQ7Cy50cBVPoWtJxevAy6xVINQRSlrLcMP3CSFJ0MM=;
        b=MEZ0ctFsn3JTiHI0EQAjjro6sYmVmAGifYUpae9VLTqfE5zjpMtvXtthtyuVSX9NUb
         JTlkFkVcXVGfsJGyhtjOlSCI1mCBY5qCWoiXzM9weeS8g/xB8sWBiS0MaxgKXnCXuEqg
         nzmXndMJuzr0zgN9A1q1NXJzUnzog/m6+DZmG1CfPxnowkh3UwUr/F/IPQVRVQGgrQJt
         zgIMM2ibL8g4uT0RdacYlejIcxuI+hrfWs9bkD/rg1kR6fVce1BdeXZbRe0eN4nNx66f
         He7wFBRDLxwWNZJN4Lt9NjUKWuIEggfOG7SCoC7MNai98caHGDhn0bLCen4LcvVzgkOb
         xYnw==
X-Gm-Message-State: AOJu0YwCOJtqz7bI5OwO6+FIsogqqrdYQ9sRYrez+Pb97oJQ2fWVoogH
	woE400Owr8ioz1l7+RLM1D8=
X-Google-Smtp-Source: AGHT+IFgz9/M8aPndMwOw9738tQtX1YN6G8+HnGVOxGUusoEeZS5bOxIInyOJszPp7kJj9kO0JJ0qA==
X-Received: by 2002:a05:6a20:1394:b0:13d:8b58:53ed with SMTP id hn20-20020a056a20139400b0013d8b5853edmr2858507pzc.18.1691605065558;
        Wed, 09 Aug 2023 11:17:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q24-20020a62e118000000b00679a4b56e41sm10234159pfh.43.2023.08.09.11.17.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 11:17:45 -0700 (PDT)
Message-ID: <2c9315a6-1e77-288a-226c-a3dd866e5c1b@gmail.com>
Date: Wed, 9 Aug 2023 11:17:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.4 000/154] 5.4.253-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230809103636.887175326@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/23 03:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.253 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.253-rc1.gz
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

