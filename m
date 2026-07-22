Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB91470E8D
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 19:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784747126; cv=none; b=tgGXN5meBTsdwv8npK1h96US9PAZt7s1MDrJFW4Zex+VOVkLM4mPQ5b/8OMHpEshrOHsR/WgQug4dCDA/3nrYBP3/o7ztx0K/CZhSKhmunjpSRTqnwh+AQSADN6L326jZVi1NdwdZFNn2JYiEySQyhJIpuGFl+JtPG5Vpnd2gcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784747126; c=relaxed/simple;
	bh=RTGSP1PrbQsR7MQ2Uj3+W1TKDMrOZZvw8Edchm0Erc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DNDc4/aqGoKtN3hQxJPj8U1Wcf58BiGTM9FJtICwNlB6ZUj7XbP/uUDxxK0q62Rl4XVtSwUHo4wvaxpVtKambtCjLzxPvzkEMaTGuEyem8xPPtBMnYKjEhHtPYmOxXB/IdoTbWMlvNDF8swmhN/ZSwg4ZwksvEU4PFN1OpKpl1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IMgb0pWJ; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IMgb0pWJ"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38e347638adso8057420a91.0
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 12:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784747125; x=1785351925; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C5Fg+zZTeJl/Ra61hw9jhQ9ZtWgPeAP9paote82q4Hc=;
        b=IMgb0pWJ7EWz2j8gN6INSGGes7eDYCYl/egSKjSTyd0xdr8SYQ+dfw47Lg4yCDIrwS
         EomTnGP3Quef+GRDRUf//b6vtjVyu3963eN5j6pcoE4k3sihBMAB86yHXLkZlSlI7MT9
         3jTQPqQrFzTRvH80Vm4k8VqDOm2pgUz4KsgC1SMORXNz1NF0nxZM5D+pO17fBOnHlmh3
         kzy9AaUXxgNDNOpcbBbUBCXus/jARaKRgczU4oSeSJOt8vDgTjpAvWJfDuQKxuiKiXg6
         u9vaqXVzoE8AKBztwdJMpOnD50947b7PqZw9nRArW3LZtFkkoZ+UVkSkX3mnM4LC4Cl7
         deuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784747125; x=1785351925;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C5Fg+zZTeJl/Ra61hw9jhQ9ZtWgPeAP9paote82q4Hc=;
        b=BOVEypGJIHZLc/7YdbASuYvxmYKhMtl3Kxw+VPFcbGurpZAsC8K86+iAo2Mr6LSqMo
         qMWEzpg36dobN54xCACE+lfP8XJWuNrKRax2ir2XZixSMNPIUbH6rp9NmkbiT1Y3Xrha
         XFTCsmi+Ig28XKBZjIw5W0OvIk+SSzYUdeIlU0n3seMKqFAMKFEYQqlorayy00ULrHdn
         KykAlZqEwP1iXRfNus0mfhXHj/HsT9L68hT1Xes/1039nW8JTy0uFa3W4WEK3d+oLenS
         vE5pROqcGy2XQjjOR8x/pL/Mkr8bs0Jc8zCCXe8LdKxdCnZ7cEi3zIO+9MIucU4vAxmA
         uc5A==
X-Gm-Message-State: AOJu0Yw3PIw0rFlnzMJ6OrfRW3gnWv5s5YZnMhkQOZCB1vSziDzq2yA7
	xK3i5Y6Z3Fv/UqvH9RBcuuzF7IVAOYQF33/Inqpd8qGEIpKYhYqmvDT+
X-Gm-Gg: AR+sD12TV5m2v69B6ijHcl6fFjFppNGn2Dg7Djrosf4Dc58WKamhow3Ldvm65VKtqke
	ay2U0yyIo1NcLy7gAlHqGAOcZwN+5TaInd91r9kNwg+FJVqWy9azAC0kO1uiEaJl2uofmg1VCKF
	f4Rye1aZIhP039BZrJ4wY6saiw7IlB1u0VxhtH/6pZ1d9mULghUOXMZ8jVXp1ht42zTNg1X8YJV
	DeEfqzm4d1cCuzY/ClFWqkel8HguyrER0ji2/FOejCZ5lNLAbmTVh6V3J8wVyM0wh8Vz8Oue3w1
	nH6jBWPc/R93WB8+C4WxJ+0th2sFAPFztN8eriq2p+yPC9uqDiEXkBifMgZENXwNukz+TGsFHxp
	3zvuWV3r5HoiJJD1iL/DP/2uzQStV1fRL2BwL+5+Rw9LezEU8B1GfqdsyiDr8wirOF6Sf21FPHn
	V64HLNp2iReC2nM2fI9JUHrb3PHGt8uo9jxTHkCYs=
X-Received: by 2002:a17:90b:4e8c:b0:38e:3fdc:62e5 with SMTP id 98e67ed59e1d1-38ec648eb01mr10353a91.19.1784747124698;
        Wed, 22 Jul 2026 12:05:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d13003f12sm14365136c88.2.2026.07.22.12.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 12:05:23 -0700 (PDT)
Message-ID: <d9f821d2-32dd-4412-a694-a2e0a515c9a8@gmail.com>
Date: Wed, 22 Jul 2026 12:05:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 0000/2079] 7.1.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260722142947.085426486@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260722142947.085426486@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/26 07:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.5 release.
> There are 2079 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
