Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010743A0E9A
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 20:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770235865; cv=none; b=dPSyC8zYOA9z81xB8XNx0WMGh8LWDwW/vKK5Cjn7QR4InIsm1Wn3SWcdMBp0d+sL6IY6LsbQQ4SegUv8e6hz7OtXWLT9+c22S7N0kzo/ge4F18BIeF35vzbN4XwWe/NaQEeHgBv2E2ZgV7KtugvEDTgfoFm6037r5Z2xuaqI0WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770235865; c=relaxed/simple;
	bh=TCyssPZboGbxxDII2EULs6DVjfgqdpFkizVzVPMOWYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NyELV/n5KxlcjvMBOXZKRrKSQbecvWBUG5VfIspSIwviHCdwW/WJFiT9AFL4l8f8GwlsB+1weFWtHam+Bn9qUXhAkv5tFp3OwZPvwTynNSbIGFCQ7wBsxDdzGVS5hfHDleWbELawHUdTz1eXlD038Yptd/P0upMw+oP7vl4iO2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Or3wLqYk; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Or3wLqYk"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-45f0c1f1b54so136573b6e.1
        for <patches@lists.linux.dev>; Wed, 04 Feb 2026 12:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770235864; x=1770840664; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LgESDrbhOJMii9m51k5IWwkl14XFcJYuWviMIIIfabs=;
        b=Or3wLqYkUvQnK7dGxCthbnmGES023F7b4PiFu71ivVO5RhBpFuIsi9BROI1J72mepe
         6hyxy3YhyAu5LSCOKLD0zz5cbYUEPKS+EBmOTc7XGgwwu4k7ph8q+LI4+S0o3C/t2dT1
         dzdsZFUMuT3DzK00Cr82vWlFcUak/Vg9kO5WXpUn7UzNjULMO8H0K4JdcXE43sg19dFR
         6z3f1IOTj7qycKpAg56U9TJfAn0c5pHEpdTY2r+nVo5fgAelBwQKo4tigf+rLl7YLNSb
         4ucXUc82oKtok8ZRAH4m4YPIPV92chJ8k3OKAg49soO5IlWVWrTM1stRuDYMvvt48mLa
         nIqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770235864; x=1770840664;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LgESDrbhOJMii9m51k5IWwkl14XFcJYuWviMIIIfabs=;
        b=SHYWAZZgxiO0NwZWt7CsN5y7hhGgTsthQtpVLHASi5jq+Ueo5o+uBq9ouqLdPIkUjn
         seugMbvC3NdtwexvYec1a/05hGGQ2JRao62xO6OOzElQ/Iv8TW4cqz/v51GrsBHQkZQI
         Fpt1yDYpTcGAH+sDkdh8T4U9TXEI9b/3XYyGngALWquoSKivgvpHaEEjmmgUFnBtLrnp
         EMoy0KOaz3DZx7hUnTqCSb+lJ+FUFYXcCYkdTB46O+qu0xBgX1ZTboAI7SXmpvp0mnEo
         VpogfN7c04ujAKSEOF0+ADnKo6g/2KTxQFiyBN67mqsdtTTRWypW+VBIIRP3FBC0fjAb
         ziuQ==
X-Gm-Message-State: AOJu0YzrFYduvZSWPU3R1j/Ki8oAbJY72Z7T9frmkPD1oI7fNf2pR+cO
	zSdyPSsS4t5eCWfJP84IfVVoOYguaQqxS0z+H/FCRmZQYo+nMbui0EnK
X-Gm-Gg: AZuq6aJM4nJXIg700HKnFtvFd4dhnCYEgiVMnztkI76H67aoE8zh99o/aimH88NtGJW
	k9cSOGetk6GzNEksJ9CP2v2muVgsqmgIS1YfmKOBUacBtrwmFLcAbqgKtpZtqnWWCvzsul/+DQm
	L6WOpvt2FY3JgWqrBPhVcc40YP1/tbAmPCYxh65gLFjG6byVYOyHBHCSpxAnwMzs8qTUYeCgV74
	lpdEcCfSkqnSo53oKxgINtCYDWRZvdhO6MGpjEyqRGTxvUaBn+UnPgqEo+n8zuVdgFwDSelXM0n
	lqQvh5ah0ghbtrqwl9c6vTSoVv4Isymo60g+F7ezBVNtLl7v89AJ9PlJgSVVeII2RWjAv+2KMyU
	gamJ7f2WX0FvWIyP1k+JQJu4lOIakUFmChEfVCVxZIjZBbMchCGTemtBmyE1lXcZ4JoKb/TXKko
	9BeuiuZIoJFelYpzB5ePQWnE4ZX0pBgGasseRc3Q==
X-Received: by 2002:a05:6808:23d2:b0:44f:e7bd:274c with SMTP id 5614622812f47-462d5a13c93mr1849743b6e.51.1770235863737;
        Wed, 04 Feb 2026 12:11:03 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-462d67d07absm1905840b6e.19.2026.02.04.12.11.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 12:11:03 -0800 (PST)
Message-ID: <fc04d4ca-4a6a-4524-a6ec-d8427a94e90a@gmail.com>
Date: Wed, 4 Feb 2026 12:11:01 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/87] 6.12.69-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260204143846.906385641@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/26 06:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.69 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.69-rc1.gz
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
