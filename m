Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFBA1D7E5B
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 16:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752683506; cv=none; b=mADtz3A32+y+0YijQQi9TcMlgSBvhfXWXMxkoZfNeou66giZghlbX9Burj933yI290TmRSsJz/ErJP04h1wuTQmerCTt9AXVagAdSb1f2td9F27Gezyv2ByaTH9mQ78SpLgkF4/f70O5l6GRR7mUcXW9AjxCDOLwgsxOTgIPqN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752683506; c=relaxed/simple;
	bh=lH8hAUXwnGmTTcGNrRpWjI1TGsdhwcEl4A28kANBwbI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kn/77ybMUr47i5ieTm5ZWvip9PxQDJLR631m34etPFSlDLevj7OJAQEDrhksmbGIhr+nFc8EzuwmvNKvUwYPeUxEFX2abaRpl2bkqE3u00Eyrh7vF/jc7Q42Ag4jKE6mKjd688wyYyBw4dqLwbIZLN/M8TInBZg7Ut6MyNEtU4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ULwRCSFq; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ULwRCSFq"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-74b54af901bso96888b3a.2
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 09:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752683504; x=1753288304; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JdkAV/hTgwELk3bnSKdE7d9fjboMsrDzTTGP9GZNiMc=;
        b=ULwRCSFqKqmH3nZ4qhX/f1YIZh8fxiwdQTxr3Iuvpw15wn2Z+7kWK8MzW/VXBKMlcR
         GEg+7mlHusRwJqcHUsaxJoQ8FwnZQ1EBpP0HAn2kU/kAVe6C1TmhPC9wIkHgQdibDN3V
         b1/FDP93XWZGfWYIqd5clphN/xGLx8se+UbIXQQ4FOnvUmORbcdsenf36UnSIT6+T1mu
         z5FuzKu7sPEirBfApwqQcPzSb1q5edo/QXEZykMjFwVaclma2duFOzKREvh3ZA09hRC/
         1KIvLeCmQRPy3X1DWw+/BXPT7c0cLHjr9Lc4NDwb89fIfAMLLjuqd1tVBkyKCiOWeSbC
         sW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752683504; x=1753288304;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JdkAV/hTgwELk3bnSKdE7d9fjboMsrDzTTGP9GZNiMc=;
        b=qKCiq1yZxnLRfmYTjAqXw+M926wQMgY+Cegt68Ry0MwA13ZmPAyOj2WyZFE+Pncvy9
         +7Jj0/6U12Dg8ryuajnCeqc9uQWiWk1dW/1es3cyIJWkmH7kalTYMo7umCmy2JLmn/+a
         OLgJuUX5GDks+52d/rZhE1p0yLZtg/2W69JaC76NqvxvcDN/t02m+AudQMJbL6JhzVzZ
         lRoC0TTq7oTil3KKUm/e9HdBMXxCEetMT/Mn1F3A/Ue1qTXoqh2QKxA/xYl8aEKBSXad
         N6wxkTD4p3evUbRT5HhcV5jZd+J2TVsLOYE0V4QQtf+7iPaiXeOhm8Pnkum9Bv2gu8tB
         voUA==
X-Gm-Message-State: AOJu0Yzc88RsdkMwhpGsWQaMbubuTtcSa4f3L1nZY0rw9C2shlG0cQv5
	gMwg+CWAwM4Srhs+hm0uugyE0ecQoGsW4HsL5b57i5mmGrff+YxeIcBc
X-Gm-Gg: ASbGncsTVXWxU3v59YP3JsBo5+UCziYasdOZ/3mRTFhyJfmAS3c8PVCJVAqbcjgEcqB
	MGCVGAIFfQWbm1ytN9kXPMLfh31+FhbAcHgnA9TkDxnxUXd5uNdEh8ffDO1OvXl3Ai/O+Ch4zV7
	bnk7Ip0e3bKd9yVdoaoaXKnSdDDeVN/b39Iiw4ZWfIF7VKKLAXz3pkbhBoglxPuZgWusx7AuEP2
	TISViYbMgZGS7Yjd6FutZEHDJp+NYFkzQcN4foiDBUNNQs+lb74T8Es35xAgnlmOups9267H0wW
	GZ0BWM9774jGEXqo2NZ0EyBgm825FA901U4h/8xqwVr+RT/7Dr2RdsOzuZh78FAFt5f9ooUi8Qk
	A12NlVjq3TC5Em0eNrQR/zGI5FKSmyCA9RTwc2bZmUxM0Wo+8EWe3TXiKv4mZ
X-Google-Smtp-Source: AGHT+IE6N+g8dLd+UH5gFcF4X5IjqUvh5bFoXwdR8iJ99kiBcBlrG7TWst9ORYH+7rAEdiCP7weYRA==
X-Received: by 2002:a05:6a00:17a2:b0:749:93d:b098 with SMTP id d2e1a72fcca58-756eacb78e3mr5111283b3a.22.1752683504048;
        Wed, 16 Jul 2025 09:31:44 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7507a64b57dsm8580799b3a.14.2025.07.16.09.31.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 09:31:43 -0700 (PDT)
Message-ID: <24f12d72-e747-408f-86f4-689b4ffa3cfd@gmail.com>
Date: Wed, 16 Jul 2025 09:31:37 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/209] 5.10.240-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250715163613.640534312@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250715163613.640534312@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 09:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.240 release.
> There are 209 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 16:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.240-rc3.gz
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
