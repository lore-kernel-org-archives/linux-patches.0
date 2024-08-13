Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2552E630
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 17:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723569561; cv=none; b=Xi0noYyktPkBX/RDS6i1D5lZ96aLjscSilLutEpbh5dWHI3pz6EYTBQwVuo/TY6TRclG/g/vtL7XJhgZLQLWNKyK+wQfqsSb7uOFKgUhShVe14LARjz827UjHMO675di1iEDuKrc05EXDwuyjbsbP3b6j0vLAYq2xo/mYcP2ifo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723569561; c=relaxed/simple;
	bh=p3JlrF731p5W7KLZZTZaFqixZukbSiTDmCckaWM0a0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TyIjVrqpifPFc8IcXA0Xu2NSmcOxs7DOtxQIlVLrH7sPntFjvRRtuoGX6hTnyRr2os83F2uvk6Wu7mSa9Hn3yAmr6RAUxA5nejUWKvfybsLnEGCXdkffDw0kDuN5Ms9d36h4gAn+NdX3V8EmA45Q9mG9ybxfhFx0I8sDIp2vPKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nJyGY9Be; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nJyGY9Be"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-26119999171so3841928fac.2
        for <patches@lists.linux.dev>; Tue, 13 Aug 2024 10:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723569559; x=1724174359; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QCc0tsfkmrKQXJYCabsN0V3UKjnS/OuvyKaoLRsfqns=;
        b=nJyGY9Be6lP8yqAFGupPsUfVkLsgTb+4n2X4dnYR1pGMDr6NF4ZJFzIphzihCjLMJn
         3LO8GJthPmGJ/r3ebshKpQqd8EBL6ia/ffL2282vvDzww8/cKWXiHPQpeNxSYpbbDE49
         3RA/p2s1FRUFtBl31yLYk59VOHKTJk1OcTcPhwaPvn+B15rVeYQfhYZyecb9PlIbgnEU
         BCQBc7ehnjxs1sS67ylTCU0dxQ7cYpbIteE3JVyVWicL10bIjyXn1/k6iAkynsyijVQW
         8o5lRqFjtmJkXE+lf4aZ4G2oe8Z3d56EgdNfl0ofdaI88TzZ6DiV5YY/UTMv3BnlCz3b
         BefQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723569559; x=1724174359;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QCc0tsfkmrKQXJYCabsN0V3UKjnS/OuvyKaoLRsfqns=;
        b=ZupT8QY8oo0ke8iHLT+sDN8ZU/rTlsnLFXNONTwabUwdEPOQgYsYTDMR7jPALPIkfx
         8ibCbUR/XeLDrv4JI7RGTea9hlU/CgDJ2LuWVckr0QaJ7eMnpUorSpRDL0gaZbpfhQHH
         5QOnujnY0evNb2fG1ceG7mP5hqbWiC+dc12gHxrntmLGBrgfIoBam904lpgPYFeK/oH7
         wfibdz57RhbwRYWlypCnWghTFvWqGk+ORDP5QhrFF18oUyOehp0BdniQfRKSaOBeQe+j
         zlYKoP+5S0YAMuBXakB+IZq0X+VnmUNRNZJnacgGqccEW2KbiuOeqwHbXG7ejxtas+Q7
         HMwA==
X-Gm-Message-State: AOJu0YxKsZ5DswkkAU5lCbndb1w8N6bnP/a5f9PafyWJ69NpjJsZvS5g
	Clll8lF46I5uTzua65cIBJnmJafQ9AlDVrFKTmY7D09IgW3ttdDPLvcoGg==
X-Google-Smtp-Source: AGHT+IHZLZ8+gNQpMjLuMxej8awWkxCsctUKAY8TomcFBHEzy5e/OV5URSLHpHoz2Q5glGUstAQ+4g==
X-Received: by 2002:a17:903:18b:b0:1fd:a360:4469 with SMTP id d9443c01a7336-201d64880eemr2532825ad.42.1723569548059;
        Tue, 13 Aug 2024 10:19:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-201cd1c86ddsm15990755ad.263.2024.08.13.10.19.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 10:19:07 -0700 (PDT)
Message-ID: <c0984797-7fc6-4176-a7b1-eacbcef2f6ea@gmail.com>
Date: Tue, 13 Aug 2024 10:19:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/189] 6.6.46-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240812160132.135168257@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/24 09:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.46 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Aug 2024 16:00:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.46-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

