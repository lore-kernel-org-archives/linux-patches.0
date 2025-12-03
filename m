Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233E2308F11
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 18:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764785456; cv=none; b=XEFMq/ztb9VvGkZDApcQ4lYQ+jo/ILuySqSb+To3JAMKkt26EuBZdk+jyXP3svTk/RWjqXEtdCnm8ryZpRBBHU7lhvb2VLKOp3Tgl9VExw5lotxD2W8upbZMwMsKxMna9qsVT9rwkD7nlm7YDFHem/CUuRySOO/81LVE6i/eQTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764785456; c=relaxed/simple;
	bh=13G27CGnHbrJI4bqNi9oU22KF+i1tcG3HTSAfhgnGM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y3mEmimvnhBOhPjRpc44Ym2eQ7RXz3sBKLQKUqaDjXPChOl5Ktc8vfbz23+jSwCG2YKyLrdNOyoPnLv65JYC1Lntc5YYQU/D+wtwFSikbgqGBaD1BuUOk1qhFHnfWtZdaLoou/RZ3tOb10jIkmtovJLXjclrY5LxoojuD1z3M2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cZGOdNk2; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cZGOdNk2"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8826b83e405so92552356d6.0
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 10:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764785452; x=1765390252; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dT5mKy0txTpJbp7ljcHsvhb/t9sv80MRauLsPTmmEW0=;
        b=cZGOdNk2s2v8INN74h7hMX7UcPrb128DEssgHGu3zjc7NL1YjxiEuUli8uRhJHAJRn
         gn6lJfznfZv5KFMLpRxpsfG24N44VgkJdeF8Akrs+EToi+BuiAUrjIPt9jR4jIbc3HPc
         4oh9LIMMAKh2uw0DQL/w/Ze1WuZsiIWWdlMdxjIj18Oe59Kdegz99gWSQCYOOD783Ps7
         mvUv56AYJZa975FSJbHlpBfP0vCPWifOoleXVlCEVY/Af8RmrCKq7BH8bVoGHNjJhHLT
         sh3tnQcT1+mypk/6ZfQv5ZGfqk4624T0EkfOULMOcGhvQJfJngjNrDQgKuKTAwJJEKX6
         fXTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764785452; x=1765390252;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dT5mKy0txTpJbp7ljcHsvhb/t9sv80MRauLsPTmmEW0=;
        b=mJp573hXLHfpsfu2MWmHDGpJrqW8cYf8+dVMlSmDkD5tvykXExF/RkBmeSIOpQSMQl
         AsiBJC6kFKVG60uxEOqBBCUiLxmeLyNLwNoCOrI5OpfFcsILIrZkzAuYjiobVNs28Y72
         g56fpOH2wPbwyrg13AFgEjkE6BrA01hcCMNyubeLaXqPXwFnSIziGAz49J/dS4/cfsiu
         4U4+ImGJkYlqxLDqrTWfcgxVYEI+5+10I5e6c/00X6PMNhzsJkgiYF6E0J2Xu9Tw88+X
         KysFUigj2UspZ89MllxuLroUFDs78ucSDgwK31xvOWlF0Fpo4kvA3LNNSwnSVnGDVviJ
         iYWQ==
X-Gm-Message-State: AOJu0YweAVYQFsrAZwgcYRQMno6g3WI0AsI9PSd2X9wso2m6fkLswE2g
	YzM1yCx99dA7hv9at7Kf+Z0mzXlKNQOpFg9/DbUasdfJYF2PnqJqoIOY
X-Gm-Gg: ASbGncuaG5DZQICpL9/nI+7lpPfzfN2uJaChFUa3W3LArgiPZZiZdFPr30L6sD8SANN
	Uy4lWR4LO9pDP/1tR6e6iZYA/NVofrfkRGP8hExhi1RPb0E5ivuP5/phI+3rlXu56tGb8TiQeMz
	8+HO94gDcRBAe4ZVzIrNdr3K6ceeTypRh06gPmLXcy8y1YdKKWvC2CAKmiSdTrCGhh4b/e3NxAj
	ox3cOxUr03b0mBG3zXeXi64F/bo+T2hQDgStrVsPh5R+v7WA5geB04Xr6HdBHJANpcNp0HPUmok
	3FrkEMpu8F7y55CUf17rqty036n8dmvXLh6ko0AJhVEYSU2mznUoLrL3WtHpViiiKJOjU0x2J1W
	BbXjY4ELXxChnrvgS9ssgOpY2DM+JfuUVuznykPT6RPYoQTwfrNWr52kwbW60ko37J3t1391/FY
	ezTE7QzDNBOanGfWhkOcu6McLZj3eEb1CxQMiTcA==
X-Google-Smtp-Source: AGHT+IHJiMm96D9owfTt6fxCt383LMWsYv6CqWficwGSIv+STHNx/qvB90Ov/ekSwrHk0/51lKcDEw==
X-Received: by 2002:a05:6214:2469:b0:880:531a:e656 with SMTP id 6a1803df08f44-888195080bfmr52504656d6.29.1764785452287;
        Wed, 03 Dec 2025 10:10:52 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-886524aff3csm136195896d6.5.2025.12.03.10.10.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 10:10:51 -0800 (PST)
Message-ID: <4339d616-71fc-4aab-89ba-ce0b1b50e95c@gmail.com>
Date: Wed, 3 Dec 2025 10:10:48 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/132] 6.12.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251203152343.285859633@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 07:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.61 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.61-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
