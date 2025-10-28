Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD174343218
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 16:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761670600; cv=none; b=TKUews0XQwWkUZ5nWctqycJqhjXFmTFLubP+8ssvfN9pqLxpHnkCiBk8zVFdnPS91K2CZSGlY6nb21XHXcCZ97tiO+ts90UKN6qNGrCe1pwkopEBvRdoHIJNwL1qbttqSaB1fMJXWaET0rNQNfYH7IWOB+kI8hIyzfJndBSNcJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761670600; c=relaxed/simple;
	bh=p6RyFVKNQkIaQ4ZcnL2+jkSmewms8zqCNQv3TST4Jn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QiUlEUd2HgFZJbkH3elhHYBhhs5hyYCfSdLneGrkaEJ6uXbrR4RgT+78+Xk5g/SU9SvsTxDU9n0nMsuKlWCXiKYZZN2YCQ1/GI8vxzdvMoAheEjEzZzMnB9ge/lRlGLtuQeVHSBX81myb6CgDUEboNl5Xbgyo4Jj5YP/p2WTGAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eVJ2FXbr; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eVJ2FXbr"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-475dae5d473so37068925e9.2
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 09:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761670596; x=1762275396; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RWB3SgEBP2sW+IMp9VjTcvHlAHIvY8hohrCBcP8MjQI=;
        b=eVJ2FXbrt3PomD/31YfnYUqLj15JPWWMBHZ00YsqQbBAx+UjwohfFeQCmYrVejhXnt
         H8YUS/lnjH1Dj3eyxAK/TZrOFnDldtoJPOdGVxozqyRxo3VPzKTtyTraJQlmP8NcLN7h
         cAo9SLJfu++BqoaRKdkHcuUmSPv/OAFwxFrtvTT2eiLzwb8L59dz+doEhK8nmrJIdiFP
         LOOYs3w0ooGjBkQFsMLgqBP/ckd99ql4tRlvlFF/0zlpyOPW7vhu6gUtcfMtlpM8YAjG
         JQjhCN9ysrrfgVLR5Uf8A4OQXb5FPQFrQMOATLXY0KbAGnT01HYKoFoIIWZ9962QApy4
         mrOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761670596; x=1762275396;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RWB3SgEBP2sW+IMp9VjTcvHlAHIvY8hohrCBcP8MjQI=;
        b=mhNcgiILq7PIssw8aDQDGHeySNTu6+8OdP52hJma9uJblgbEL1ui2ZwgQd9liJDD74
         DQX2TSTQ4Dvhy8OxESFnX7adkxAkA31CCIj3mUSgI6+k7x0uPUIgQBz7Dwt4rCIwLgyZ
         H1j+wnBXYAmx4A27OHdjqjL2hHHT2MO3ezZYVlF3tP++wbjjgSOZO1HH3xtsqAh+BXU6
         hRHN4Z4ul3APhYwUrR/778rLUlISvCzQtdtZdRr8d+ynTgfmsWdv+yNGG25XgqsQl3sw
         rkiBA93JVK5xQ+wAPygHD4pP7wzfOh4fkhYeYEf1RVYaNgsC17F+f7ve4q/EINQ/0UW4
         PNDw==
X-Gm-Message-State: AOJu0YzF2tpZt1zT8FMOrR4PLze6CWxJ/Pe+yBs4LFjqe+f+JuNGPw5O
	lwUNhhB7PWg/2+papi157lAqG0rFLE60xG9ASNrSIi/3DFUw0fPZcytJ
X-Gm-Gg: ASbGncsgTAA4VCRsQIGBQZD6JLjircwWExkOQdBy3TinZtyVhI/OoOK4B7VHaKhFWAi
	PIZMgzRR6qKhrzOgurOuRhBYvkLAoG5fyHu6643eU7HjUhty3ZkukZfAB92z2lyAYUMDsgfaRIw
	r/iwJBt8dNoAD8iyCbVNKxmFGWrU3kQo83WcUlB7hzojxEp5Q11lQY/hVu/UCRXWTTDq3NLd4sG
	mjYURQAMwA+dVt8JEhpTp5zVPxaWFDzpMI1DO9dGGTztxvYrFTbyJh8jaQPcAE4LoPz+Ar6HAMf
	SyF/4wsRYYJQImuQcKHjOTOPk5UmtAfeLjF0fftWL+p/q0f+efbl0BwvXXeOaWdqO3XfkBSxsmd
	BIa67Lf3gOgdcAP6Gkxr877k68jDFHNxqH+AZm9RssmfeFQLRHGimmZOqFcEWgF/w362tjLcRKv
	WnWZuFqmkQ0PM9bjnxX9Y7rPyIJdg=
X-Google-Smtp-Source: AGHT+IGzGR4B0wLNVXJkWpJi+gf0J9ZLmHxgn1i3xJss3GSWwRHMfKatObo/0+gt1zOBw+J/Okn6YQ==
X-Received: by 2002:a05:600d:435c:b0:46f:b42e:e39e with SMTP id 5b1f17b1804b1-4771e3cb792mr378315e9.39.1761670595796;
        Tue, 28 Oct 2025 09:56:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952df473sm21333826f8f.42.2025.10.28.09.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 09:56:35 -0700 (PDT)
Message-ID: <3c1dfe1c-a1bc-4873-9c5c-4f9904888194@gmail.com>
Date: Tue, 28 Oct 2025 09:56:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/117] 5.15.196-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251028092823.507383588@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251028092823.507383588@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/25 02:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.196 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Oct 2025 09:28:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.196-rc2.gz
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
