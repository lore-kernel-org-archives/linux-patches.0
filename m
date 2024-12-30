Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7B7EDE
	for <patches@lists.linux.dev>; Mon, 30 Dec 2024 18:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735582260; cv=none; b=MKJPw+ybdUZgzmYK1t2z+h7nED1Mm64mS4ZkUw6YapCS5FZNkG1pOsnFXfB4mQrQnkf80Myq9KQVQVC9ObRMUfXNSWj6oy673zGx6FTpdfcuOCxrMAXg3frLgaluBhG/kyqa6gZ1KuwdG1hveO84rIDJDvYdrPzHSwV435DMnik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735582260; c=relaxed/simple;
	bh=76s1saDLVGxgpjPOn26jApFtMqijW95mlrh+Cqztvd4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=keEf7fuG6UzFHgxB3308j+5KboIpSZxO2xO5ns7kx4ZB1/Ty+NPpzdEtPl37vjJluoW3ehYClSVuLqOL14+nO+bZKpYfD0IXzC4cJ2gWV7zTNH9dCKRi2KYtJwGvePVYaKxJ1NF6eGqE90/aC7FJDeb4bwFzS9gigucIoMdXYbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SMj1Vk62; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SMj1Vk62"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7b702c3c021so816402485a.3
        for <patches@lists.linux.dev>; Mon, 30 Dec 2024 10:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735582258; x=1736187058; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=+5WHTUr53iWR5qjukQpdlBNhsUdDFBx6Bhkt96FfO/I=;
        b=SMj1Vk62hW1/XdL0D3lb5+B2GyZGhRDSWNEa0x0D4MP4uVTHtwx58epbbbbZM5MH7M
         VwMf1oTiLM+eGoDbXNmyzZ7PkWpppMRo8F0xkPtQa2WfLEBv85qzkjkPLlsGeHGg5mT4
         mimjpICDH7Ox7e34VmLfHfy7/LdMmoKZVsnVzCwixNOb+p0kmfJYYy4j2ZGIYTx7aG+v
         c9AlZjM4INL94oWOrX86m27Hsy136YiFYY1H+srlrcgQiMXreAlx9ZHOughL9TjO7zcS
         /VbUL+WsUmSBFmbnyt4RV14LaoaUlNYRWpb1CNuJU5K5+gS8Rj8EBUks4PDIYMA3Oqhh
         E0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735582258; x=1736187058;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+5WHTUr53iWR5qjukQpdlBNhsUdDFBx6Bhkt96FfO/I=;
        b=H9rxWBgU1nznVXRpz9YyugjMDpp9jkI90yt/RW38lIetsJOW6Bd83zc4RuTjNFKpqw
         NMR0JuFM1jlJy/uVLwjrs7RSKIFw665tM/WFO/wwtQ0MKVR0l3+W6+Lu9H2TZWn9S686
         kYgg6eQS9OcBJTPHC2Ub3y58yYVtuZBIkJhzN7tGVoBMOZD7wkynzZtAEwEULODEJBN3
         HdTiJLNzrZSvbyYByqMaZV0UROH42nzYgweqEdTnBUg6Fqq2abqsqnWY6mSZiSC3LRZF
         JRQkUt99k4yrwbvai5Uoir1EQsHvwAUMcukdzwMvsQJNcO7m8GiZ1vyFrFLh3b7EoM0R
         wbMg==
X-Gm-Message-State: AOJu0Yys0ITtpfSpMc6ouFQXX+w0X6mnNddZwTZCKrDkunh8BEV72xtX
	0rwq2WjfCPuKEvxVjliZS+G0MEeX4x52G9dOIz36M5iiniJxkYH9
X-Gm-Gg: ASbGncsyhUiKfQ8xLZI+vefw2HKNENFI5zdd+1ryEStyPS/bObs+swqhW/mnfDsEcxt
	K4W3KKS80twvVC6fuCav4q6GhVGG88+y6Te+RsahMQkQHFv7txFf8RGhseybCJBrsDOrNrNX5rj
	3SqVGyiv6risnYF7qunOU/1YktsGp0aSuKJOljf+m2AH7VqSRb4nYvPdOLKHofzrqOZk/iGZh01
	KIZfv+63MHNunxdzLT8ElHVppQuznFszJ2LxUF28dgprzpAMF3nS85dA8XYIcj5yTJfCD79Y9SC
	teyT1dJM
X-Google-Smtp-Source: AGHT+IH/pyTi1GUrPCv8oVUrhjc/UCMbc1DGGQboZpm6KcCOxpSgKs5HNif+Vh+s/vC3q0LjM60wPw==
X-Received: by 2002:a05:620a:2855:b0:7b8:61df:f5e4 with SMTP id af79cd13be357-7b9ba7be7d7mr6471057685a.35.1735582257702;
        Mon, 30 Dec 2024 10:10:57 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46a3eb30b46sm107572331cf.87.2024.12.30.10.10.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2024 10:10:57 -0800 (PST)
Message-ID: <8edd954d-69c1-4018-b400-f66cf29c6f0d@gmail.com>
Date: Mon, 30 Dec 2024 10:10:54 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/114] 6.12.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241230154218.044787220@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/30/24 07:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.8 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.8-rc1.gz
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
