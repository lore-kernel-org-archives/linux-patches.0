Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794252270;
	b=ycGZbMswP4OuQSfzerc17kEdZRb7sne+VDT6Tf34K+FwnHgvW+VWIYaORFatlQI82G++
	 u6IXcAJPNGLTzi7eI5tuW9rxkAkBLO5wx4ZVK4q3w1Oo2GmkkGM7SmugWD6C+W//+WKVG
	 imczUGPC8YHVPKyUvUWnw4YDE+4tuVzH2kSvNB2k5LIwcShlDC1yQUG8lMLx8aNbQtFa1
	 VzrB7/4Cn2oKLXyYlr4zht6ecikgSbMY3R6NzMvWeB9oUR0Y8ucsGqgC0Oafy263YBTmO
	 mlQLNdsgV7DnsjpFg5FIsYOSTrHIICdqzi1U3wKsAc4Bu+iu0HtPPT5zv1YEfjPhkNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794252270;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=iNVyoaT8eOK1CmL3RYnHrqcQrx2W93eTgrazTaJ/OGk=;
	b=NBnJ686Ep4+a9vp3nWnMm5Wqx2gjnaNxP+JCL8e9AyYqlawY1nBThWo0r9uQb3VExbHk
	 y5GtvghvItxaDBIcCyVG3Svsxgasn2qLRAoH/j6I9xkw71YG0+OPy/CmSfqrXL6Jj7Yjo
	 95DEiHdd/FjnhL3a8VRLY1uYSdyB+tyqQeBV11ZvD9sqVo2m2GUOsU6S4ThRJao11PuJQ
	 WR7bqXeuxiT/a3PvripJ0aTYicJqIcvYw1qnIDiFFl/tDvfvVyulYwWhqibT5dFSwcsMp
	 Qu059dywtSyFFkPqVP0UemXiS3w32OOo8EO6GcTXmE4LpZd6WkapimqIdPf8Y/vso6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YEognGcg;
	arc=none smtp.remote-ip=209.85.222.171
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729EE606A338
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 19:24:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 729EE606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YEognGcg
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93f269e335eso138832885a.3
        for <patches@lists.linux.dev>; Mon, 09 Nov 2026 11:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794252269; x=1794857069; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iNVyoaT8eOK1CmL3RYnHrqcQrx2W93eTgrazTaJ/OGk=;
        b=YEognGcgH43SzX1MT3q1lcPLsKcsDc0xgiAjNlrt0TlOfvdTpPoesN4t9wnNscG0bM
         xctTJ9MZPucJmaXpe8GV8Nur+dsYwpEQEEokgvBh7+DQ8PSxbtVG/kcbIcKBTtDcQLwd
         EMDrs3qGca8jiRk/h7bJq0xSc+yr+3qkva6VVQn9dLWErkXZUdGIrtYcvV5uPo6We/Cu
         hECEv4hC5SiFVcfCl5VwleumLMMzqg365/igxF3ki8sUymRJxcSeXBR4Ilk/aHsnmZGP
         6/sKNXeC+Re1XOV8NoDe84YCpwh1KuRYl/Zd4P5yDOiKUR+xiUvDGjGV0VrvgV8MVTnE
         XqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794252269; x=1794857069;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iNVyoaT8eOK1CmL3RYnHrqcQrx2W93eTgrazTaJ/OGk=;
        b=qOSOJ7or4WGUE9fKEyKNVwp6EPP+d3OfQdWgO1+QG06Ih4c9d05drzg+ffE889lc4s
         JH58eNl+0+zhaD0aJYn2erz9yY8lRBLFVamEJRIhyqyFtV7OfQM/BF1SwqJs9lVRLp9A
         YaiQIbXKarvccPAKYcPLGm2zBQr+7xsk7UkNsX9are7wpGfsQBT7eBG41ry70c8B9eta
         /J05Lu7jel6fFU9MXmwwAD47MxMKKwK0HG01VvFRTUNuBXXrR47Bbg5JHJ43eRDnoHoj
         rL1iCZWAsRh7d7xuGmHL7+7DOU68gOW/BXlVEpGpPXOiTtPwGNGbt7OrENmaXjAfmiFX
         pRFg==
X-Gm-Message-State: APuU4Z9y3OT0FBAhkE6ifaPXSBLnKnbzFZBYxygaIv63oPps9BWcrX5M
	jM2NC/b8H+0rP7w/kn3DBRVAZenft4TrpeYqC92kPs2GWarAMDr1uX26+q7Xvg==
X-Gm-Gg: AYBFou3eXEcjMG7wddIOwZwFW3O7S8OYiPB4eoGn9cdCQlXJtoPiI0/kJL4rzB+UelK
	K13crrCMhgc7Q1UAb21apfFbeGi3c8Xd/W4efxOOUBBiDqO/wUFNNzL2zc4yL3zpuvmxJQjo3ok
	EtAx/DL4jDp9kj7VepGfac5sd1+xiFk0kFUH5G+9+C+PI4xc58Ru79ZQoyVUGJgEBFQ/efEAu/w
	VCXuNkl4zaxBMiLxFlNt+If0xMzkdAhEZnqgxS6ZTsfqTlIjJcN5h/JECiDy/qfD3JllqPtQCfa
	cDKc3IxZsrDRg4xOe0Jhmy4/+kVYUjzVqYPvJZs4KQUQXTEyumGicARlBG0otbPy9UXUJO0tNdy
	9pLZIVqC8MtIh9rMJJAa/hZTSucxK3vr6rj4UVhIy8afMmWiFB7+tZuqgwRdXOXUbAwlVcSI5A+
	l2+rW5kH/fL6WAxCfAgAGfGqHTC5uYXXSN+6Gr3mdD6UXxGYl2WRrspeKc9uFn0baWDFX/Fk4wE
	BOvAgPRuUEyna2gwMBiakZHa7qWiIFTeRa490tJ1Q/Ay4U0koZnlJfaTL7kUhTw+8vw4HZuyC0F
	dTFLTwEnmfbK+UoRDd3RDdg5TTY++3VQgN2OT2H9K3BzqOXBsXNy67Y=
X-Received: by 2002:a05:620a:4712:b0:93e:646c:9133 with SMTP id af79cd13be357-9479f3934bcmr75883385a.64.1794252269384;
        Mon, 09 Nov 2026 11:24:29 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e73c9absm45460285a.8.2026.11.09.11.24.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 11:24:28 -0800 (PST)
Message-ID: <ecd48372-c802-4ffb-842d-73c689bca64e@gmail.com>
Date: Mon, 9 Nov 2026 11:24:25 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1536] 6.12.117-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261107134957.653319350@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/7/26 05:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.117 release.
> There are 1536 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.117-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested with 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
