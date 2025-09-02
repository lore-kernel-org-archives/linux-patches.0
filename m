Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464F42E0919
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 17:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756834419; cv=none; b=kt+2iWH9oYZ90uHXxor5AdsKK4nNcQZcmynhKqjG6tjDTpyqv4z8bWp3MInR+BMi2HT+4jTNCA84GBUciHapdW97l2JhdEJiIy4Ku/QES4xnGHvpjt47FcEL2+H/yS7CcFif5LqD/AsjPr/9bQusEWmtt+6MQtSVOo4t28PvPOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756834419; c=relaxed/simple;
	bh=1sb4mNzJKiBNJOkSjHwyzDcm6obJKevfcRIBh9I3Y9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IlxykomXS6QQaL7zP6DfUrgBmnqQaOuKmtZA/IyFZ/1vFJ4HWimhTWlHKc1o39AA/FbbwHb15MKzmaIgjzCyauqV8935M89Hm6tz4pepx9TDvL8Ib3X4tNTnhw3vk8b5LAbkhnnxmYlWm25VgbsSvDX3UX4N6BFwMWJNWxGRriI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j8J6lVZf; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j8J6lVZf"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-7211b09f639so10334746d6.3
        for <patches@lists.linux.dev>; Tue, 02 Sep 2025 10:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756834417; x=1757439217; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6qN69cGhCW4JcQNOQzKp6W5d08xWFi2OKORK99dzBII=;
        b=j8J6lVZfCA5WLOhgDhnVHtrcaVtVZHF0NBgKdmsy11gKONH4B/6NYU66S5+MgBYs3Q
         Z5iyr1fuOhF3RQfg0OsBTjCtrPuSorJLUM4AtZuiyVh8PdB2IHfUDToGGGYNOU0riwDY
         GgW1HVA3Onvqhe5oZoCoL3A267xeppfUQytJI/sfS2tHB1tdMgbNUgCFia00fMfBwJQ/
         eQAZtVkBI06C+qKGvfXsPsXyQmWYMUzH7/N9zoCLNHGDFup033sq6KRyqZXNUEjMVzWX
         pUaDceBH5FRigqFCTMd2Sqh7ZR8lZrNhAb9+CfznYnSFYQAYzFO8prW2HBhgdzM1Gpcp
         d1hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756834417; x=1757439217;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6qN69cGhCW4JcQNOQzKp6W5d08xWFi2OKORK99dzBII=;
        b=KV7FZ253fxoWGq7NBFYEZX1Qfx+o5F4AjxmnANGVGW2v+FfLjI9jbC3CxnstNFHHlm
         zWvym8WcCJ6USKEckd3lsOdF8R61JcB5YmhLBc/BxT11ejDKsY6RX1VFzqx9YiG19s5z
         eEM8b41UXyy33iqq5cFMdL0ln1eiQj8CbFoW+nLDPDMzhEL5zD+vT3HIZCWj/4iLsC3Y
         SbB+iUxo0e9ysMHTX++1NUR7F3qmfy2QYkZGJwdLIx4MpZ7O7ACtdF0/wsCYiDN9opNn
         JP6RiHOMBqAqz0hM3lvbxKBIfksH3v6J8ZZQSHySUG7bbeVYwDAm4MWJQRstZJ7SGbjZ
         4Dlg==
X-Gm-Message-State: AOJu0YxgeFtL86TzzP1K6KP5bB6enhRSsn5vmehBagIgMqr/EO172ohM
	RW2QFzDxwdGPV9XZp2hrX451zt8WBvy/3yF6Xm2xm/aW2mqHpmn53b2t
X-Gm-Gg: ASbGnctbVKjghfWU4Kb6vq3pZr1zt+LBMFxP5FL2jG8fzZgSpIJs6kEz+LGEB1/5QpP
	It0/Dex6sylX22dZOHCFAkTbdGfgqIXDjbogEgk+jpKLj0S62aNE8YY+qNOnxIl8K/DOA+ovmtG
	zBY7S/pAXZlhRgXh7RK5xVMAJqQsfz7P6ZsQ6YQqJ20Qc39Oym47pXKrmTzsuNURXI76L5D6ySd
	wkI5+KnXXXQWYDteakKf4AIaA2e9OJqmQ+AEn/1Ei9RgZS4IaIJgvi2uEHcYu+NQjM/l2/NrYGj
	t8lwpYaI2xODp3/qN/BkMDK3izgAjYGDqe6x95wwQe0D5mHXkYz/EI04oRK+soA1haWQHUBHA2u
	Ny+jEroTUbUZXspknqV3yRQD8Jd/rK6LgN2dmAGrlcXwNZ1LOFfqAzX2xkJKo
X-Google-Smtp-Source: AGHT+IFgSFSvZEOW6oqviYgs/lS2mqs3G5IXLNF5/g52GWc526Espn4quku/UgYDjQAhamCPVdnpJw==
X-Received: by 2002:a05:6214:cc3:b0:722:48f8:66a with SMTP id 6a1803df08f44-72248f806bemr8840036d6.28.1756834361702;
        Tue, 02 Sep 2025 10:32:41 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-720acdff0dbsm15143366d6.18.2025.09.02.10.32.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 10:32:41 -0700 (PDT)
Message-ID: <7a44540c-198c-4e15-bc87-f93c7e3a3deb@gmail.com>
Date: Tue, 2 Sep 2025 10:32:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/33] 5.15.191-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250902131927.045875971@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/2/25 06:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.191 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.191-rc1.gz
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
