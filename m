Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1765028C86C
	for <patches@lists.linux.dev>; Thu,  9 Jul 2026 13:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783603911; cv=none; b=J8WPsMbxGa5u+rnfgZ3fN6IAraKCmcBqAejRuEKwUo+YYCu6bbMj9LPBYPfhqXdX07vufiYrtOYo9FW5GsNpwx3Z/ofe5440VFCQoqeJZd3PMOVubtPmLRPgByF7cNlK+mOaU7GmMHmpnTKMU9gHiyfLWX5k87EI6xn0461NwrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783603911; c=relaxed/simple;
	bh=nK+XWSu+Tw+t9agE8i4GBCd/GLcgTvq6lhVAwjuSSYg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=lbWydn/JCt7VZN4xTB99qMn7LnOP8b3K9EONyGrezMF3PbKGlzapanMumzaBS58PO/1yjzNspMMGcb1YVqrXc6XN7rq58iASow3giPftZ67AP5S96bKIkV6ohvQWgdkA38grgly+IYu+gUmb01poVuPkeh2nTeB3V7Pcn+/RJLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sbYPLe4q; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sbYPLe4q"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47122683cf3so1150636f8f.0
        for <patches@lists.linux.dev>; Thu, 09 Jul 2026 06:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783603908; x=1784208708; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n/M+W6LXlcmdxEuUQROOr/3E+bmWxRBOl/fTyxk2NmY=;
        b=sbYPLe4qD8eEtB2sVtnxUAdOD2KMH7a4X6jsW4VEOtGnXPg/O8QDAM6MHH7VEorBTQ
         DrCAQqUhSYAPLfoUMEzVtE75qGy4OMFNBuG0C9DV3vPav7616z79aTXYpoE6Ot+Y8TDk
         i6GY6TAUnZkQiWWF9i7PdtO9uUaec7503bFkNG7hD9Uxi8V3tJngxw+vRVqnXq4ZG5cE
         G5RNJE7vmlV2Xm0hFwlcZGJkQOY1/2N3Ka0rdFKNsoz2GwPNjCxPzBkquysXIMJtU57a
         p3/yoe+1cGPqFbhlfCEo2ng93LhPkLrjrpV0QFm/LovTb5Vmg3tt75cgnBbg4R2OG+HQ
         PeEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783603908; x=1784208708;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n/M+W6LXlcmdxEuUQROOr/3E+bmWxRBOl/fTyxk2NmY=;
        b=mox6hZvFQ2U2w2xO4JDI2zEKY63fbWTO5zZZ+QZDVLxPpt1qlOXbNu+DynXFjyd+WC
         2QQphE/nYdq8PmJSpVVeEptM5shEJmafF8biYiC118XspjWyFlqaEqs0ajTFxTmahgm0
         Fc3g7KyP61qTxb0xgXBTuCpYRQ/bZl9uFLkzoz/Xyxyl9ebcUg+hwAGK5tWOHzVfDc5G
         WQ4cwHtJ3mwXxnJkUbYOU2xPPkdbGptEYXpqGvPtUqlHggIQjKKx3f0M36xGsr4pjgzW
         YNpHEcB1++NzPXCaYqIpEeT+c05vKNpL6r+ae10gGYB7i0VXFLtyrjYSwcpPZ8TYzF/Z
         Zcng==
X-Gm-Message-State: AOJu0YyDhMlfXk07XFdg1aMdTEZx1Qo3sbsbXjm0OEdkGbfiPkg8G9fQ
	DqLxHAC3vE6+/hYkzUZDv+e2CHP+tz6zlaZb+/ljLI5C2pgQOkrsfok9
X-Gm-Gg: AfdE7cmG6G7IGr1UkvZYlIWQHU6z3zYpBh/pR47HS3AVVME6cgbsGBAi1uQD0Zfrv7P
	9tJrPvC4h1UnsHLj781aN1MWucieH+0477rbM3fttVErt2FQhh3z3sj/q2dCP16TQFakSkuQc9v
	KKQs5Grd+qENYSRvt6GkIWlry8pg4K2R5sWjU89/6SAIw3vrdwUlbyLl1RYOji2rtpSkNJZTFc3
	s3G0SINi4c3UITbqo9ojN7zAbQzK2p+81XG+rMj8xZ2IRz+CZbW6ZmO6L5ShLbw3YfwiIiUTiHI
	jdD6lySInk0SLvNaK6MSxg9PZx08qUwcEmDWqW0+MfvQJ1lKFYN9mTyrisD9j3T2K/yNn4NpEZf
	jEqIvLtEjYaQZ5HyLpzQ6mlA1THPwPQuCSlNkCwcHfoGXq5rY/nAqmUEctLFeK0oWnDbwmsi59Q
	JjLGScnAWkI8Vv2ZNZe797tcNA5FSQ5bUP8s2fJMbE8DhWqCP+ZeDoudgbD+BMCQ==
X-Received: by 2002:a05:6000:24c5:b0:460:3233:beee with SMTP id ffacd0b85a97d-47df0775706mr7751817f8f.42.1783603908110;
        Thu, 09 Jul 2026 06:31:48 -0700 (PDT)
Received: from [192.168.0.105] (88-187-52-200.subs.proxad.net. [88.187.52.200])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039b0cesm52356756f8f.22.2026.07.09.06.31.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 06:31:47 -0700 (PDT)
Message-ID: <d4579324-8e59-4113-9409-6c4048b5dc00@gmail.com>
Date: Thu, 9 Jul 2026 15:31:46 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.18 000/109] 6.18.38-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260703072816.644513463@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20260703072816.644513463@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/3/2026 9:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.38 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jul 2026 07:28:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.38-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels. Please backport 
7ee7f48413c42b90230de4a8e40898b757bc8e82 ("perf trace beauty fcntl: Fix 
build with older kernel headers") for MIPS builds of "perf" to work. Thanks!

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

