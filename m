Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8076933C186
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 17:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764955577; cv=none; b=nSXiHj9zZd2f6YOLHAtCk0P6euvaly6Qj1Fmjy3KaVZS0CZ23qfLf2GUUXOCd/eZgCKu3S/s+x4f/IFEKiaOVLm4krwd60f73omQ9LOFU04Pi+NnqNESKJr83HyVlPUyZPTrN8ElED/XcJYm89+45umPiScZn8jlDmX2rCYCNXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764955577; c=relaxed/simple;
	bh=g6iktb+IWC5y9d9lpV3js62z29b6taQIOUMvHdYUJ9M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QWtcyGGYtFn/DKAhNK4Lyav8cCg41vr/GR+ifzpvbY3gEkhE95b6EdHFVlpUimxcYsNz8rSjmn6Des3g/WLVXQt8Ay5TQMmZSvRx2HOszrrgs11XHonXVNpojrewJVEvIix3aJy13slpLQCT956xNbw0cIh5FRpzOAUGASB67Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eNjt6M0H; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eNjt6M0H"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ee0084fd98so20543781cf.3
        for <patches@lists.linux.dev>; Fri, 05 Dec 2025 09:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764955574; x=1765560374; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LINLdZzEK053sMV9v22q8svB9xbGy0ZtcEzGRAfCE8Q=;
        b=eNjt6M0HLRV3LCf3p4dBwJPnIMs0HzvmLcM13XY+Lr1hGigffCGvbJ41DqZWSTly7q
         rXNavWVi3skyZfzDdwMQ+m0vc1JX9lwWJut0p6/PRY8OQDNmTksRMwJh46BeNPYaJMXB
         qezqVJHVbOZXV/HKi0vSQ7M/3fE44nPwxt4jZT2+VRNK0AQXJSTlphLf2gHYhfbF8Q3k
         tRzbEsiy+7aIX2wNKuzeB2T983+564byUf3dMofg7n9wLgdJo/Yhc72smUEuFLfm+KSx
         uHJLDKxQQlo6mFpEmpyA09XchVzZ4vEMlkhytu1dDFIKfbQoeG2hPfJbQn0bz8URrjzy
         ewIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764955574; x=1765560374;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LINLdZzEK053sMV9v22q8svB9xbGy0ZtcEzGRAfCE8Q=;
        b=YfJIKcTv/aJb8zXwvMxYXzpHEKIy7LsiKv1U2CqasifluLeHRHoX3IF3RoX1C8AQan
         BdzYF864WHus+rI6uFdyyopJeoT7K7SAI9mi8FPe7KoFTm6cbVh4fDxPJXDLAtONvLoH
         cdLrgWoO1NqZKro30Zy2C8mK3RWBBKDUpLygnZy9pMoHD59mgb6bHTuSi7WfuVisZWBE
         HIW21RDHCb3WQocolVK9VR4a46tUcjYxqkkW2q9fpr5aawdRjcbOQU40OaEILZMtiyLg
         3ECqzEY4MyEnIBu8Bp4JT9IO8Arov6PdXreVJYWguJEk3ZarLy5u5KyzxHtWAUjWvQmy
         JCAw==
X-Gm-Message-State: AOJu0YzAojz9oLo0fD9vs6FXb3Cv7Bq768LZFKzSeG0GbYPpbMfcVGKo
	E1znv82X3Khkx/FYwRSIHwDQVwVi7ymvYO6b8tpub7L2FDYGjkMHB4jT
X-Gm-Gg: ASbGncsS9abLJnPMX4Nn9HRUduvRFmn4qqEk8r4W4SybfleTO/5Dzc9pMKc6VzB4CSx
	HHrvSv0AakHTFbVTV0IUSgO7cm3pDJ3zWVXgm5eaukKD+QIT5FJ5LNBudDqPiBX9qQp8c6mAqn6
	I2woSmoKm3Hq3ByCuNJ12m2nWpUHmvLl3EsdOKwAg7CXo1fpipNaGXgHBebGQVBsttbEYZ3jetJ
	I9Brm3KWkQib8X0i5ZCsWORw6k1IkBpkA3dCikYa8QUY2hmeyexaFaQ4tx+ZaGR9eKHiwXq2T38
	XnFlAEuSu4CSoBqrnSZf01tigQWym6BHsn2bJ1ojZKwuWW3lP6hZ09kqkS5K3eKIFwtzlPNYrG3
	Wk3BRe1b/2sppMh4LtoXHiCtGcuRVQi9+W9YxncGQckNxi56+suzKZgJU6AajdQJSIbU6fPg/dc
	ieJ7JyM2OXUDqrCM5LKsLIt/UE//uYDWVsoJr26A==
X-Google-Smtp-Source: AGHT+IHgkqlNiyAQxO/j6fihjxQBw62JYYCT+i9/xAjbcB6t1Y6B2OClS2hc/EE5bn1LhcbH93kzzQ==
X-Received: by 2002:ac8:5fd1:0:b0:4ee:2423:d544 with SMTP id d75a77b69052e-4f01753008cmr153536761cf.11.1764955574345;
        Fri, 05 Dec 2025 09:26:14 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f027d2b54csm29932351cf.26.2025.12.05.09.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 09:26:12 -0800 (PST)
Message-ID: <4be38ed6-74b9-416d-9223-7b3f37d5a74f@gmail.com>
Date: Fri, 5 Dec 2025 09:26:08 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/295] 5.10.247-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251204163803.668231017@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251204163803.668231017@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/25 08:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.247 release.
> There are 295 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Dec 2025 16:37:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.247-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
