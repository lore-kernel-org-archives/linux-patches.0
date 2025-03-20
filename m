Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787FD1BD9FA
	for <patches@lists.linux.dev>; Thu, 20 Mar 2025 17:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742491573; cv=none; b=DsoTzmqpKvqluPa4jhIzgl5+tPh1NtzLXFjx6FhS+T4XyJ+EJPDopCMefFc2+peAIaTiVWVKg8oEHWI/lZcp7BVaK7UqufvvkHshQ5PMqx3E65Br+cs//L6TzF3svAh/5uVk5Qkd5ZihwMGFfpN+rpiXykjZr6tqts0of7lsRUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742491573; c=relaxed/simple;
	bh=9H5WCYunBYZ1ODdWf0Vj5t7OeAVQF8+pFEmpC3BCNOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gyfxMErWRbmvanWOAAgZB2wKEBPAk1k+cglPR2LUre5YDYuQThKz9f3m09Vp0rH9yHu7Yoq6Q6ZIshozizw4GxuMNafiuNdyilHNn6ddCOy43xGTA1yBG0f2MTDGl2SXky3PCLQ1q4Rnz6PeBqRdfPHJKhFK65PTc75lpuck1J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mfz7oSGL; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mfz7oSGL"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3fea67e64caso644522b6e.2
        for <patches@lists.linux.dev>; Thu, 20 Mar 2025 10:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742491571; x=1743096371; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zHPyA0xewYb0I+0x/ot3M+q7jv0f1rkY1kljPbMdmBc=;
        b=Mfz7oSGLTqdDHDlsUjAZ3Kj6i/v8aGj02PqcTNI6jf7YpM8fOkfjSqoE86Rk+wu8CY
         lpJ4Au3AapcNtMYAEbjhxSubQTJkyYj5WR/3nTqnnczf3VDkdRNM3q3jesPzfvFZ06Oy
         uuiH+NNE4E3hWL9ZGNrMEfx+xKpRFgujM41TuMwIL1ENRZrq3RXbGuzeV88ucac8WpuS
         7OdRCwF/ZGe6oehOnJT4Zx4KcCCSiWfRySVreiXusEM+CqVJ9IwmclUnJv+b1IPlANlR
         i6OknqvFP6JBLVGqtLcrdQPqQZ3gLWllzsDX2U5DzmdcQ2pirzLeYtEnPjLi2B1yxAxi
         E5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742491571; x=1743096371;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zHPyA0xewYb0I+0x/ot3M+q7jv0f1rkY1kljPbMdmBc=;
        b=ehZlU3BfUkF5yKPaBejs+unjWn8FrJ6xr96l9eW5j5Cg2eLEal4T/TUcxT/XNiHFcF
         0STZKJbxj5t07rb+91L6tHmW2mVc9rqPNA8OdarWLjq/7bixsgnCOxo/AIXXZUylmuEz
         HUNa/36zsQND1JknupIKk+Y4Yfx+pHzlFF0b6Fgo1S37TknndIpfCrHN/P/+mxyHC+W9
         Vr3RKk3iJYUGREA4be7VQLWHkBs2dQBUxxDrbsaVZ2/NZkG4hOmPEf4d/5CsSPrZkp7+
         5Ync1J1tbpEocXT11rFjJm1l3qFoWqEv2XRx+okpWTBl0lgvaOE0i+VI2VgTXweSaI9t
         xk0A==
X-Gm-Message-State: AOJu0YwEZdBudm1wImLJjFho8lBixMMs7Opsrm3Jmm3n5bT6kNpq419h
	44eEJosO5mhBGNep+11b41ONeLQeK/dtKsWBO739JSGO8iqgX6tN
X-Gm-Gg: ASbGnctFGCmOND7AtlQkWMnEaeU671Q1DdkNJbQlGT5Oo9ogACeZw80+Lr2u0paC+ZA
	HqTCAtQwie83C/m0pnJLMDlNJHAD1MTclJc4V3aWgu+AvwoML2wH3fD0LcN6IvJRCxqW5gtenEk
	+pHUxQ4Xju7JQFN22f9W1O80fxlnTApr22+mZsHoG1H+/KBh8LHPvlBZtZ9V9FrL7iq5g2RKGY5
	loIYYUc3Y5tQB22+pVJqnLupaA8sp8W/sfZwXf0q4DrPtlhviq6PGdfNi0taDxX9EvIv6jTdB5d
	9nkZvHR87UsATAPOZtEva30WUSaw51Nqh9Jx+0e3gXMpNVFNecjXbxPQ4NkeXGjL37hOWIp+cud
	qhXwZo8M=
X-Google-Smtp-Source: AGHT+IEcS2TJigeO4syfX5A1zRGC8/KkKRBQ0dVRZB7BnLSRXfI3DNUbD1hpLxkSzJ0UUHCd/WpTRw==
X-Received: by 2002:a05:6808:1694:b0:3f8:b73b:6825 with SMTP id 5614622812f47-3feb4b7b9aemr2834093b6e.32.1742491571404;
        Thu, 20 Mar 2025 10:26:11 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2c77f0ed902sm54935fac.48.2025.03.20.10.26.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 10:26:10 -0700 (PDT)
Message-ID: <7bf2427c-27aa-47a3-8c1c-72b2be7418ee@gmail.com>
Date: Thu, 20 Mar 2025 10:26:07 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250320165654.807128435@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250320165654.807128435@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/20/2025 9:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.84 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Mar 2025 16:56:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.84-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

