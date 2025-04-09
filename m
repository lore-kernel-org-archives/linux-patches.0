Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B6A19CD07
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 21:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744233383; cv=none; b=nnIpOSP8Chqt0FvKJHW+rm5Vn76gArRL9ovIsiAUgi6WDV54eGvCd5tVXiwotTbrKcmp2DjLdU83w2V1HLgZ8zCx35eYay+oJ2VAghInRaB5t37uZk3YPQmDsYP+zvtQrQ4dHkKeI3wMYvEZZbkx28VgSb+PXudif26D30jfjh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744233383; c=relaxed/simple;
	bh=zoTw2izgU7xAnKJwewW/51QYbBDVfCEL0FCC5otKg1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uho2tdZz9dk9a5Bz4PttaMuyBhFhw2Uds7TtgCEtrDYXFE/xEkWaocTeDPLKPf2hSIfs9mEbDNCKvHuNemSeaszcwzimbXdmAWDe9jnMqRDZ5uMoHEuCtQRDyONGhgPUkPau0a4bI/YPLq3DbM2mjKes6D8VCdnfKb4kfd0DCtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fLoNQlco; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fLoNQlco"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3f8ae3ed8f4so39897b6e.3
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 14:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744233381; x=1744838181; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Aje2B0MfANax/FlVpe9svmUWn2nMjKWT9d5HglJysY0=;
        b=fLoNQlcoBfMas3XF8uFDwpX3+mJyEcBfuVdSakvFd/WcIK2aUJzLMNXlij96sBoVyx
         xqS/+LUef/kRxBVyiLGMY8m7yTpTzaHdgzUZ4mhDb7Ph4lfC+aWXgm7gzzpEAJNTN0cu
         3lonivLsa0emOObt7lgKSFsMEHPBvDdWKiLnKk+igc6kIYZVPkXmGIImBIU+ngzTDRMf
         uO2jNmoLakLA+qjM3vFI1p/TzAMVhvrkRfFICayCrmUJOB/cqnMCkWZK/bLjpClTnQ3D
         0Rafy/Wd+0nGaJBSMzUrTl9m+tY1v9hSOHy4aSmJYEqBGgOTr3nZLoaTxdzsrE8KQJyf
         gYgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744233381; x=1744838181;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aje2B0MfANax/FlVpe9svmUWn2nMjKWT9d5HglJysY0=;
        b=ezpLQosuZ2cfk/wDsxIwT/KTjeIaHNLcO/k+7mqD6AxXPJ2Lj9IV6JYm0rVHQ3IjFT
         nhmjk1Jq9kNEjq7KmiUNlWj3E9mmFpZ72RzXis2XeEWQUmtqODqRbH0bA4HfdxGiockE
         4S11u/22uqY7Rm3QM9tF+WOMlQX5/0Z9dJydCdjNZUR64SltvfOXdETG3qEuUWEOA5/L
         UnrTyk1AefiNje7W/0ptBqyxDP053bMOIj7XlwLWVT2H1b77c9ff3Jv9d0PzJ5jH5a24
         tb307rT7RCP9S8zNiGuWzII5wjCKDJifG2zSilZDkU7alag4S9qeBeAkABxAM5X5QJEF
         L0Zg==
X-Gm-Message-State: AOJu0Yw1GNjj4hYdfFJySKfJGF6KEei7MYH7IeBfRyDAj/TZ2fpj48cu
	9SRiZvqfABlXjNr+zyxT+SmR7NKsx1W2bhwFpi6AEnpj7+9YM2Z8
X-Gm-Gg: ASbGncvbHdqm98t6t8QLpx8MfabVq22pE5Caqsf7LiX2AkvJL4Zhp1Xna28PAcYgIDc
	gb2tgXUjIXNU80PaW/zvCwNhNafxKwGGxhN9d6g/8/ptzWY3q6AXV2sJ6Zajf7HsgeGVvif47uu
	nDeznQqsP5AeWSV+LSmcLoBm2ImIraQXtavbRYVOSi63k5pVzxCwI5z2JDF0xsBr5MQtKnysiAK
	w6Fw0unf1Zj6CwI5R9ALhPAghlZfPTUYg9RKehBNmnq6L6oOurzea33HhsLgXtJoc2FqFnnSKU5
	P0ldVeAbUyT+q1nIhpvfzfalXwcLdr13AKJOEEYvO3ChzBqPggSObuX+iHHa2pkgHrQ6L66DJPF
	L+OE=
X-Google-Smtp-Source: AGHT+IFAxyHfjWBXp9p4x6Zwgq/IkOJMIBMZAZpUKHTesFsLu4ibm10yB8qdfT0hzXgW/FylaWaDIg==
X-Received: by 2002:a05:6808:2014:b0:3f6:a703:b71a with SMTP id 5614622812f47-4007bcc4f55mr222085b6e.16.1744233381180;
        Wed, 09 Apr 2025 14:16:21 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6045f50eefbsm304850eaf.1.2025.04.09.14.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 14:16:20 -0700 (PDT)
Message-ID: <2e01175c-e84c-4f57-8068-6e361d54c8d4@gmail.com>
Date: Wed, 9 Apr 2025 14:16:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/726] 6.14.2-rc4 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250409115934.968141886@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250409115934.968141886@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/25 05:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 726 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:58:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.2-rc4.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
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
