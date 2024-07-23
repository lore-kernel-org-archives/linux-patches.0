Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2771A140397
	for <patches@lists.linux.dev>; Tue, 23 Jul 2024 20:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721767494; cv=none; b=uKj5eqpcG8MMvIixZN3T5L7JG4Q7dqh9BzWi0NdrJsbMzwiLJ2ZSTfuCNT43V/4Ox8XLutyGJhnVjcZPppduzB0eu8hl/oWfcsWHRfjdfGazQp1JCnJP5VZvWVomExa/mP1ymDFH8O4cWakmgXambS/u2HjGgUcbpmR93l23IZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721767494; c=relaxed/simple;
	bh=5eGxl2dz4vagX8F8KIWwj901p3USwXNj6Oe/yHWUyE0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J1w4y7nbyEeiaOg7rzikg9W63U630lfQzHKTuLcDuSmLc7KjzjNeBn7BM4m3Y3qTtZkePgY+3dfv4zNJ22yNucd87sA0gWjL2RlXx53LkxgmhPzpZxdTrxJCZPGj8TFUPVpy4K6M/N8KthH6+scee6xUfOt2a5trE4jYF9ke0Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZBdY2GTd; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZBdY2GTd"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-70d153fec2fso2479508b3a.1
        for <patches@lists.linux.dev>; Tue, 23 Jul 2024 13:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721767492; x=1722372292; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=47bKS4H+6Sl2dCqP9QIWi+FcafRquOMBAIrVbdQQ23Q=;
        b=ZBdY2GTdLCv1I67J9dyjcbLpbwzyPAqLiFOiCmQHZaP7XXxPnJvmrhHkMYik6OgFLw
         t6wHOLtxRSEiBdaX5SH6eZT0FXRAbAO0lOSC0VW7Ks+yJ3MmKe+R27XfSQ3RyGsXpz7c
         h27CABUlXKxubnbh+8X2sT+5Bt9DvI6xF2LLOZWM+O4T38FqIj9msQjkLOaO0i5A8pEC
         Zth7j3w2VAVCTEiYrRwIkRbZd8jN+e/LiHRG2sFwo7q4l+EJyLynWVdEaPOvvRLNZNrK
         9+SpiNGNy7CilH/fvi4fdzAX/jhtufICjcId3tAfEzFbzZDrRK+kRrh5xlyBfYG5Oqwj
         KIrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721767492; x=1722372292;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=47bKS4H+6Sl2dCqP9QIWi+FcafRquOMBAIrVbdQQ23Q=;
        b=ocsTTY+mRQcfpeqs2EqJIv1Du5BwEe5IHteQhLR74BquazRXvh7MNDP3XGUxx+bVtG
         t3t/lFfIOYLVTbLXIFA/diWvm/ez38lOCzjKsneKQZbEf88fQ3GjCmHwMPQ1/24rmyfO
         2CsNGcSqFlK+g5XQ5acKX2NJ240tv6uifo6xcGQEJ6xbpRgRR0lKIK8xhqsYi4zTmwSD
         qaXfPZ7XaQzbk6GAsAMeR4UYoXfmtrqgv1nOOz1t5KZ2XFUxLmGAXVK7RKWOoSDsv1T1
         OJkT6k125XgpIO5zbKQp4BircgpO1NJAN2rbZqd2VEofK4N+z5tE9/xS5Kcg0AOi3ZpU
         kkNw==
X-Gm-Message-State: AOJu0YyyStqovWFGk/vm5Fo8kwnxOPfyJjjWlFT6FcY9g3KHK4DbKjtG
	QDICBZNUA1nOvje4zcQ9CGysDCmtPuW3BgcriP+4Y5yKGiR/89bs
X-Google-Smtp-Source: AGHT+IHIJ455lRhRF3pWGaiD6x9nAZcg8iqAXoATWKTb2IYqoh9OGgkLZ1hnZEjpooDN2H3LP4qGnQ==
X-Received: by 2002:a05:6a00:2da2:b0:70c:f1fa:d7a3 with SMTP id d2e1a72fcca58-70e9968fb9dmr1185952b3a.12.1721767492105;
        Tue, 23 Jul 2024 13:44:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-70d241803fdsm4228166b3a.220.2024.07.23.13.44.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jul 2024 13:44:51 -0700 (PDT)
Message-ID: <6b6244e7-6592-4611-a3d1-67ac30dc24b8@gmail.com>
Date: Tue, 23 Jul 2024 13:44:44 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/105] 6.1.101-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240723180402.490567226@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/24 11:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.101 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jul 2024 18:03:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.101-rc1.gz
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

