Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301747E79E
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 17:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706117237; cv=none; b=jihi1s6MZxNqRcAQ/+AB7UMr+gp/vDXcjwaM2q5CM8DMJqZnWVuW1xRRyGjoWO2Xq99w6rW0ZKy2ctqhn1OupOiTwBqjrZSgsjf4ovviLGqd9KZUHTsgUljDwEXD6z97vTFRrXgCWqHIr+c/lm8bm0rTtan1NeD8HG9+n+xAzV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706117237; c=relaxed/simple;
	bh=6MOAemICKjtElSAV9D/Bfy4WMpwOLClz6TJUWRBoYhE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PoxeNwSYXAk/Ptje2qs2db7/+QdUYPLXaGiLb1pNTk5g6+hdXVv/DZ5CQmYnKoobotEs3CFwHqjt6Q1DUJs2h1FK/7zXc3iKv8+1Vb+kTCmtxPC+qHV4TFArT021D/m+3MPUDAIJYwyMPqIZq5cgpKapCkfEwNn2Lk+ep1cFc9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YK84UWyb; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YK84UWyb"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2903498ae21so3267600a91.1
        for <patches@lists.linux.dev>; Wed, 24 Jan 2024 09:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706117235; x=1706722035; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8T0KaX1AdA+aklBNgVQv4mrW58QeobM+4jGoReZEVhs=;
        b=YK84UWybNNkADruQavodWh+kX1tjMMypHAonP7WARBvkpBqi5en++eqIn8mcs+klkY
         GREj/fHDR+GLWjtg9QW0ORkQ+YlsEomkTxv6OjKLrfecrBQGOTfS4GTyt00wECcUxrqF
         zh0q98wkJUKsxdPQ9Uj6CtmlKilk7/rYfXIedQH88UkKhBAACFTbFLN+x+i0yrNSaZXv
         u4LtkEVJPlcsUQvZ4Xjm9fPGV4pX4M7aBSHd3OLvIj5NVIDM1YoSjBhbR4ML14YFp1ZB
         fJx4MNOlq1RomcTS/BFbMw0Xk9sGPxXDCKvDOU0VolWbUE/01LdmsByjoKNCA7+dLmpZ
         5aCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706117235; x=1706722035;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8T0KaX1AdA+aklBNgVQv4mrW58QeobM+4jGoReZEVhs=;
        b=PBB5fH/ykNMPvspx2+XVvnIm9wKTE2HbncOHrXr7YECK1yOaN4JPYovjOaMmZOXWZ5
         EGoTppCgRHGDAiUzGJLiEjfVKBuHXPHxxTsmVHAvVKak4fhdngMLBMsY0QWTL6TEikcy
         3/KbikeJa72F9ipYqv8I0T6H/Lpmoc7Z2RD3pp5kvU3rNDG9OT265oIJbpV/oDt5c9ZS
         Wu4CInTqTlfuRFU2P+d01kBBB8LmoYZ2+vfXm7iW3f6tQEi+jEzCBEct0m2FUcSr8Fgh
         xoS45ul+k01+JekNNBp606OECUmhUu4bIir4/g9aAcH8gMHHzo8wnTcvsFB1pW/zueF0
         K5Xw==
X-Gm-Message-State: AOJu0YxObvnB2C3O8hK5R4EF9w380Ik6s5FDR2vg7D0fmSH7gSfv+Xa/
	H9cxofaW9bt2/ioozNRJg+0eZpTiJIJtQlN8FrkHWghSTIvYKAjq
X-Google-Smtp-Source: AGHT+IH508l0adTi9R0vCI4CDcPTzxgx20rKPZ+JzYtwVUVMT0Kw4JVjmPi5iP92h4H/XEJnSe6gOA==
X-Received: by 2002:a17:90b:4ecc:b0:290:c939:6bab with SMTP id ta12-20020a17090b4ecc00b00290c9396babmr2364008pjb.45.1706117235366;
        Wed, 24 Jan 2024 09:27:15 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id su7-20020a17090b534700b0028d29d837c7sm13895057pjb.36.2024.01.24.09.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jan 2024 09:27:14 -0800 (PST)
Message-ID: <5a794dfa-bcf0-4e6f-bcb8-cc09c5a5de2e@gmail.com>
Date: Wed, 24 Jan 2024 09:27:12 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/580] 6.6.14-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240123174533.427864181@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240123174533.427864181@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/24 09:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.14 release.
> There are 580 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jan 2024 17:44:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.14-rc2.gz
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

