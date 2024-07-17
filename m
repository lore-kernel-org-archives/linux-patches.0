Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4356B188CA4
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 21:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721251557; cv=none; b=KnEoefpXgSLxl7m8pMLG/Vd1e53rZ7An3q/HBeFdqCtuP9UArjDRLWsaBuypgb5V9yc5JPURHrOQf/DvaPVblKcN8LrQXdnkNPQb3nzvK5g6CBI7/fkaLeZQpmxUwUc9SYQQKk61aLRidL9Rr/6i6WwcQwetwjSvIog2lzI5+nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721251557; c=relaxed/simple;
	bh=AODMLuRwPchbYFj0U5w0p7CWGnFA2ybIfL9Hq8sHjUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dbq0BfZYIiKnV9YZ2hn/RSZLnHhB6HnxlvR70+MU4ZOrda0Cy7dsx1guDpZk9/Bc6f2jPUm4LUdTltgdepdRcArQqDjblW2+Vh662gTOSuX9ivMlCr3bwGHeej8eeqeOuk+/+29e/t/dU5gB1FZY8TkTOt7FZ9VF6U2VwLvMViE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pt7WDoyH; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pt7WDoyH"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-70b0e7f6f8bso84001b3a.3
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 14:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721251555; x=1721856355; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b2FZIW3YSi1wBOFs9v4R+8sE20hCRwn6eVXzZjVhxJ0=;
        b=Pt7WDoyH+7lxHFuaqPqS0b/zCvY8vXM8IGLJ4PBxyT95uf+ejzWK1sGelnPg4mWOEK
         gRshlKOaxYOMo1FJdA+TaOsTWSxhLOYFLYx2aClhVr48EDnUtm4mq+WqBcWUxvkdx4Ey
         BP0X0t3fPWBeQv10463DZix2SXfkz3cKZZyDtvrBJCIqbuu8exa41RQ+Lm7buhRPG8EE
         k1VT5Hwtn4/z8rGRUzCVP2wT41DDQXWUPBWSf65ZUUn5fJxU12ZIDlA3nZ2Hm0uz+rdH
         H8gWYogd3RfHfWYhBTm4tEx3xFzMT42qY1I/eYmhDYd3SO11/vCEp2nK4YJm4QmHmsrU
         NwhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721251555; x=1721856355;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b2FZIW3YSi1wBOFs9v4R+8sE20hCRwn6eVXzZjVhxJ0=;
        b=aBcUNH7hoN4xJeeak6QODkwuT2YYM0vQMotw40sKYOowPSIN78++e7LivtahTs25gy
         97U8dZevTltucLIDz0sxVCOtpibyNud/MKHo8IlcOrDOarPsy8eJJeNFRPYNGf6jtRQZ
         vEfI4JMKWstw1XRDbM3deslo8T3YFuWPBiwWK7jQyYSGHu/GJsQxnPKN5jOS8E7yAS4K
         R3yos7E1vmm9+9don5bVFmzV28hpDOQQlh9ZqhpK9VIK4WXH6oL5ieXZ+x2Hecr6ZlD2
         XpEJa6PyvVnR2Kucjc2qP23vTBukziVAF7coHrwGedpMMugx09+4ba2ouhv48A0AgqBZ
         SqbQ==
X-Gm-Message-State: AOJu0Yzea0dt0piebxRq0O+tzpc31EqqV4d4Nn8Hl/AircSpvsf/MQys
	HIZYOzIkJI+gq1Try+6cJNYWBPB0yTQgJr8ay8DuBvDHskdWH7ii
X-Google-Smtp-Source: AGHT+IFQbW0ItxFef6sGCxXNrAyaZdWSeSUCCyVWiaZ7ROXW2Ds47eCnyUtG28t0CqTWQeUPGKsCOw==
X-Received: by 2002:a05:6a00:851:b0:704:2f65:4996 with SMTP id d2e1a72fcca58-70ce4f902b2mr3485587b3a.11.1721251555311;
        Wed, 17 Jul 2024 14:25:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-70b7eca8c12sm8864645b3a.171.2024.07.17.14.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 14:25:54 -0700 (PDT)
Message-ID: <b6b4c58d-8731-456e-9ad5-f83f3934ba6e@gmail.com>
Date: Wed, 17 Jul 2024 14:25:52 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/95] 6.1.100-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240717063758.086668888@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240717063758.086668888@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 23:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.100 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.100-rc2.gz
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

