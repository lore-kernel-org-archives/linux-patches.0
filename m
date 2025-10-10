Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4502749CA
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 22:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760134874; cv=none; b=T/IxjxzNDWK/qGJfZB5J0mVi4b+x9nb3IuOwNH13yCPvFtxtZfEca4Nx4tpy3U/W98TdDQPk9xFXfuTMKW6t66h3seoVXrDlZgwEjmlaqU0B3VbG7lJE2+mqb+xWXvHlTpQR6NLzWrnBobqiJhUhpU0EeHkXvVfQVoiBTo2qaRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760134874; c=relaxed/simple;
	bh=ArQy/aBxepqtqZjpmtkPhu0y/QoRlipcXP0SdEbn4mE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kL4Y9sYFujIwncjfrGAM7Nh8ChR1bmQyZVf+H3mWoEGR0gMyIiYZdqqHyFG/6gIEdSiLcbTS84rtaDqZExvIwg3WcyGXJI/Lp79IOid4pRKAZQ5QgceaQ71RjZN9veop3CAcjAOX09lYMEYkMMZB9BmRUmWM/UefXl5sFvED67w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/7OF9+4; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/7OF9+4"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-9298eba27c2so109851439f.3
        for <patches@lists.linux.dev>; Fri, 10 Oct 2025 15:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1760134871; x=1760739671; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lx5r5CLrhF3bcMJ0X7SPGFexB90B8MChAA3VoqSyKsE=;
        b=U/7OF9+4Mes3qG/FPwh6x1MjMVd0N3nDe10LuPgHYVKZsdumFrAMSK+kNboXQ5IXep
         bylE48ud+UzvJ9gu8rVLUdCXWHU4LyY3F1atZS3g6JF8MDhULfZ2X4JNKaYDveofYhH6
         i2z2wkEnAm0tt+2PalaEF5QU1WZSauWWnwXtA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760134871; x=1760739671;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lx5r5CLrhF3bcMJ0X7SPGFexB90B8MChAA3VoqSyKsE=;
        b=t+vfWPWLhB354yKP8evuCYxg4765cTXMHbXu4dY0UJNnHkRbyNMcgVIWfUwUhh/OAF
         d12kcymVYtvfTO+GCyXfRl8mam9UQYkswpd1i3b8m6q4d4Ipm17uBdkFKoYvhC1z1x3u
         OYRcD4t7MjZIvFxdWvqM2nmFbq5p7tiLNMLHROwyzdr/dPtrOKOtgX0vEPY212uThHit
         mexkqd2ksG1jtbJP6N3Wjc5v89cfnyQ1xC6/i6VXdtugrtE7ELxvm6elGYttGc1jr0iy
         krKs7+Arl9gFppkBjW3w0xxEtGFzbaLS/dI0XWRisPd80iK4dx0q71kMBrk0sx3DYuMB
         cduQ==
X-Gm-Message-State: AOJu0YwVgAzgdmPuEJ4avXAmyHqRQNmf1BNAn2qNnunT7YqbCfADd/VP
	J6ZBzkL0D3Zhj4JGm0bITmYsP1/FYUVIpZQbAZz/4r8cPjw/5Euc7zsPaPLrhOVKXzY=
X-Gm-Gg: ASbGncubWYUQz5d5ygpTpRTPbhppQiytDrIVYap3t+ryn+2cxyABUdPmBNxRMYUzVDn
	Yl37rGAQgrVp+Xif+EqGcQr25R1g5OV4LhDO61rqksz0V+mYgusZqjgswIu1Z2iPmMUaOkldXnb
	51jvfJTl7+A6FBAI+Zq4agzkh7xIXXm936rvUvNKNJmdxkwoUFSxCoo7DjbgfbrHWZnOIISz+56
	Hs/PE33CCTt2+ePzwdiiph1WKVO6zl2Zo/9TM6v0rwsUJ3s5Ap08J4MReeA1t2EWw649o9MC6q/
	Q3/vMVnATt9VqnguG4RdLs0bPpS+4tvj0buZQpWiBAi1mujf5M5vuW52RIctE3evofN0ux5omFG
	zL9MctVwshHb6TYhe94jFyr4TfMAFkY02vHXN3cQTg5Ke9BFqWw+6abNAS+d4tNdD
X-Google-Smtp-Source: AGHT+IFxBtMZTPCXc1lKr5S6PbgrQdr+9ayyIqV8P0135BbdiNaXWyMPA4gEYyZCfPG7eNjUg7lCqA==
X-Received: by 2002:a05:6e02:2164:b0:42b:2f98:3fc2 with SMTP id e9e14a558f8ab-42f873ec98bmr149773715ab.17.1760134871512;
        Fri, 10 Oct 2025 15:21:11 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-58f6cd59fe3sm1310332173.20.2025.10.10.15.21.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 15:21:11 -0700 (PDT)
Message-ID: <f5fdae10-56a3-4933-833e-fc69a7cf914d@linuxfoundation.org>
Date: Fri, 10 Oct 2025 16:21:10 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/35] 6.12.52-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/25 07:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.52 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.52-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
