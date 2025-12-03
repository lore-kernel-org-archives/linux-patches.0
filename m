Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E971D33033B
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 18:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764784891; cv=none; b=BHDP+otZVryVykNiK1p97/u3m7C7sdpYIyDF+tNu1y+r/7igsoY/xNHGbNnG/47Smfw61Bce+Zihcu8powwKoE6kCCxxgIriS7Ht661gxTPw6afX2HA8cX6cN0P4ixBzk6Ow/DqfIIyyV00nkkj/qqbnKDI9ZGqo9RMVNyopuds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764784891; c=relaxed/simple;
	bh=ntjvGlLrcZ1G+Asp9gS15qgv2pa54burYuU122Y5eTw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OHlgon9D0hKQf+cdDJsk0ivJhiga6VfA+/TUVpsq0u4WGEnXvmpcRD/4yPfCSMJGpKWixiSH7qDXmgmhnQ8N7qfhBi5kqCVHLpVwSKnWGSnhinvo+J3OtOaIqGDfj/e09iAUA1ZWEJ+Hi8iM8wkxuaGCYpelxYiuYoc7I0s3GHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BnGoa5T0; arc=none smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BnGoa5T0"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-5e186858102so41594137.0
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 10:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764784889; x=1765389689; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ncJT/IoSu+YIHBxG6RjDXHdYgwMwWxBQA7x2oh8P8cU=;
        b=BnGoa5T0xjPeUCACeLM1bpO5ZdzWmFGeOpZJwwvR4O05bgfmAjb0kNk9y1cZqMz8Vw
         teMrSaBpJOiCmbx+WsrUprZlSfmjl3U+dh49E6KOjsIodO9b6J/H1ZgkLp0Fm0yTeDN/
         53zgZxVKHTZPozE4bsykyasIRnjBTP6nM+NRNPtUACWEMvCfMW9SiRk3BYSnYVmfNf/L
         WnwrFQcpxN1f4mN0o7YmuDyrKoIdjGRVP+yTcoEcQiQp2bfh0ao++EDeNhXBOEdFd9qY
         ISNawwkkxKPOrLeQu5l0R2jLMIxmPF2i3+QZo0RF3NeKRoCxFn7sACmE7XGKV18PBKFQ
         hrmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764784889; x=1765389689;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ncJT/IoSu+YIHBxG6RjDXHdYgwMwWxBQA7x2oh8P8cU=;
        b=cpkkks/49DeUB5jDraP16z3+DXHtIyRy5w9tOanCw2uxLrdTg4LEAu33sNriQJsuQJ
         axnWfhabMp1wf5ppRprJawg27zYhPSS0BhBKw9QC/BundXYbE2GjuQknhrhtnkfH3ITM
         65fXlSZo0q3Cyjy/+pzAJ/IMpJFJJnrr8xb2LqV7nbO2OR3v2W0Uz1eeX6KlG7tdMdgA
         6WJKVr3AM/ritS3+Rn1pYzCcveT2J1jH9atNPf+oghgldYgwa24HJ/AQ5PgWsV1qrqAf
         tHR68IxJ4BLI0qoJam8o1Oz5Lft4o08pK/yeaFUsiqxbRf5uyE3q5QxN/5umSXLoo3qr
         21Vw==
X-Gm-Message-State: AOJu0Yxg8rKTfCE34q6nh7YR/gAxzzyTeAkK84FwsD5GI5TwPKNiBlLY
	9rwwhee9Z7V0oR+LKSz0X5mvMFbs2TGHUIItDafBRj+HQQiVgGw+ErUd
X-Gm-Gg: ASbGncu3SRKJ6RBAuv33d/XNpo4vzyFZK8Hb0x5DdbGeCltzGV3iIPC/UVOfYasQZIO
	EUkfdwSQeYv+bBsKtVrH51KzshJ5jWGSEe4xgo+Iu0A3Qt2RSCIo1V0+bW7w4Dv+pXZGEn6xgrh
	pzZgnVdNzfXxDEaMz1afj6msBwKRCnGkTBQJ93b02Mz5imNiG/m9nHgFn0shPW/OfxlfvjVUhAh
	mfJ1inhIi0dmUKsqest4Qzu5EPJ4fr9XaW2a8aYZ+DGRNfQR5N9Vrlh20oJvmCOQJhQUKEF7sRY
	obbWGXWagErfvpIlm/ELMVnR1mM/mXRagT71FrUXr/d3AZoyv9wud0Zqz/qamIc/PexFvSUbKJK
	K5PGgmfKy+lP52cxaLfMmKnLxOcgvj0mkPBQphXvLWWcqAzz2XVV30TD7FR3NlGRO8up+bCJwKX
	Kqsnd/eq2MXmRz/5XaI/ZeDChnyKCyEpUDgcZBrw==
X-Google-Smtp-Source: AGHT+IH1Sfhwt2TEXAHKsmKFd0ZdFGeqvK0X2GluPHEpvL+AZPyVG2NwehyogNSX40XuOfjRPey7yA==
X-Received: by 2002:a05:6102:cc6:b0:5df:c33d:6e57 with SMTP id ada2fe7eead31-5e48e369cc5mr968565137.26.1764784883974;
        Wed, 03 Dec 2025 10:01:23 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b8fcbesm131573066d6.54.2025.12.03.10.01.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 10:01:23 -0800 (PST)
Message-ID: <a8e4cfdf-ce51-40c6-a3c2-3a6e3d416c59@gmail.com>
Date: Wed, 3 Dec 2025 10:01:19 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/568] 6.1.159-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251203152440.645416925@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 07:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.159 release.
> There are 568 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.159-rc1.gz
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
