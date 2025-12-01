Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697B819995E
	for <patches@lists.linux.dev>; Mon,  1 Dec 2025 23:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764633477; cv=none; b=rtTdKDh8DrMEl74Fjt68QqVnbBdOs2O3er5zdelfNis/r91beQM/pwiKqTJf7IRxbZ+mz3NvGFc/1ASVMD4hTqDaTzFhi9iNxZ51AM1Dbu65hyWUdTaRpNxogXcTs3sPAMo1azDl9LywNtQujDxFgfriXGLKMFzJEE1hXU0H5Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764633477; c=relaxed/simple;
	bh=3vDmUwcS/u70A09LnxZ0rAkyZOobFeZv3xxWb3IHy7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nNokzlszUsgwen99xJ/oyB3jlqMViySc0JsgAf3vviurrFca7449bq+ZtskpVsXIbsvgRxAnzDWFH6Bx6b5vL86X286rkSE5xKYhClP5v9KxWmwsK2tzjnLtXPL89H0RurPOm1WcbRd7Dxh2eeoGjCSeD6JtTz2aIOh6dX+bDO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SascLFOs; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SascLFOs"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7c75a5cb752so2864730a34.2
        for <patches@lists.linux.dev>; Mon, 01 Dec 2025 15:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1764633474; x=1765238274; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=23nJKbEHvBqfOwfZ1RhHlN2bMHavbfGoV65MzPmmeVU=;
        b=SascLFOsepgimK4ZhrnWEVyIlNhhuAgg5H+2D2wwZl8jtmrhCP/iBmhKQRPwWTndO8
         9W2yo6k/Wbn+FLQdksjRhF+GWZnvzbbtbPecZR8iVvrxVZoDuqWsOpLyajcSiAtKfSEt
         iEqzCFZqshQGP6/YYIFlf3HPZNn688gtBq7pw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764633474; x=1765238274;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=23nJKbEHvBqfOwfZ1RhHlN2bMHavbfGoV65MzPmmeVU=;
        b=fkw+VYRfSGhg1wbeXa/bcEJUliGcIWYONG6odl3eH/CodD1fczsZTO6GYlOGQ37nzd
         viNizFqdnVXRSUSqxNecttXcUHnVF8feBzObRjUQMbTaUtD2Xp4uB+nK2pRNhQWGCRd9
         5VENSiuulyYOEQHvuOyVLOA2cbSyqx2ALfTxBg1xe602a0Vz+9wen7Hp5bkEPTA2GvXx
         pSmB97CcvaKLJTK4kFejE5rNuP8pxCC0PDKHKihTTlGO9581YgKn0hS3gNn4cW6ZQCyG
         Hlh2MWdCRkaVgOIkyphzfBQzqD6XYDIg3yR0L8VS0fjPygyKHN6L11LLt1QQVAD09FXz
         PEpw==
X-Gm-Message-State: AOJu0YwquoYQhNgFANCPb6maA99+otovlm0V2kdPA8dF251TfVHirgjt
	13e7QCKXB1e5FOrXiHn/idx0fbhtFT+deqGAajuK/l7M5GZMrroJ0qxaQ3vGO8DfAVo=
X-Gm-Gg: ASbGnctmwMN/YetaDX1QINFitAnCDE+OpH1s5CachErOmy4BCJdJDbQTwP6b8YwSsei
	Jex9IG5QBuNv0gZ7xv8sdQEN3jBLjDob/TwYR/7GEXFKbnufrWX4ExWzcaBJppFPOQ/hkj037y9
	qufNpc/R2QeLWfkO1rQcZWogcgHOng2mso7U6xNWQVo25kIBFWZjdT7sz0glMiYXDINi9M0kEgn
	yMKhxL89+cbLk0r9i7OHREUxpcFoIYoiT5ORMLvSKVS3lPIqOgFVsNzR+0HjP9hlgLMOsp9CQ6H
	IjkQWm5LXAp+pgNYNN2UCwMVlq6Bx3sbJbq7HO5rZHLJJyM1dDsWTk7JdY02np8q2yVmjrEKVQA
	EUl0uewCLce6f6/mqjoURPpq6/r3NYuSwjp+IeUvRGq57HsAWxnmKpmv7a80ziQoQMYk+2cBmFo
	ZVoNdvbbuM0MX93hHbfVghSYI=
X-Google-Smtp-Source: AGHT+IEtS3jcwo4WzU54Sa3K8J8ybpqBEguU1sThRdV9NKjDD7zBUT+pKVXB1PdslMVOEqC+2jguSw==
X-Received: by 2002:a05:6830:26e0:b0:7c7:18e:914b with SMTP id 46e09a7af769-7c798ccdd68mr16820921a34.17.1764633474482;
        Mon, 01 Dec 2025 15:57:54 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c90f5d7d82sm5532004a34.6.2025.12.01.15.57.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Dec 2025 15:57:54 -0800 (PST)
Message-ID: <d574146a-3434-4eda-accf-d17bff2cc0ba@linuxfoundation.org>
Date: Mon, 1 Dec 2025 16:57:52 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/187] 5.4.302-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/1/25 04:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.302 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Dec 2025 11:22:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.302-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
