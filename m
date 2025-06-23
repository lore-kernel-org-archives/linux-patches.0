Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C991B225771
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 22:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750718361; cv=none; b=rcu1qNyhvD0Mi9J2WgNeNnI1Bu8KgVFDgKxfh0hDiZP79RRrb6qAHZT+6EQiRBky5lmd2YFI9TbecwAwwUSyzOlyYssn5eyBzCsrHQmyqX6dyWa+A+NkLzqhurRo1c05DsnNR2MXXLiN0FhUIVThqEVoFz/qvFzonPx4NaRD9x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750718361; c=relaxed/simple;
	bh=0rVNs7RhKAYqM4PKyTZ9ZFLKPRVUBby6U5PdZIouJ9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WDRHPWRK5cedGIDUK57OlvLKxEjzcpO228k2/kxf6Y8Cg4q7dlsx3EWVbLEXLSzfhDisXbSbmnqbl0Q/eaCo/32bk9oqpURdU9P0o8eqrRPbF/0iyc1rEEpmrO3uU7MRNEDO9u2Ck/jlyn57yBmJBZIpHgjsQf9DjZtt9mQxgmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UH0fvPlL; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UH0fvPlL"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b31fc7c27abso3133111a12.3
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 15:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750718358; x=1751323158; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eVldHq4DjbfdVyoY5+6ghjIA8lubME6n79s3SZ+DPi4=;
        b=UH0fvPlLrnx8KiZQXS9a5wFc23+DBVHdp7EOPFTgd4D8n5RBwsdCEBbZNXyP//x2/I
         ILliAY/5CUGwfV89un8MceY022cWwVPAI//+kQvDqw1uveaJE5ED+J5Uw3OVFZ1ps9Ky
         9HiTIQ9zBtFWyoqr+196BIaDVmGAzv/3mk2Dwl3lM2TYmelONtkYZxtcmir11rSGz8rF
         YwWjLHX5rfRHQFG33HGt38GzXEx23NOrRuvcOjuBmKGtwy3tpfKDsYGfAG7MeWF81uX+
         lYWvVZjPEU3hiDqGkHjLzQKDQhI9gRR24gNvgIUyGCugCRoKWp/hEhLfyTiNRdtO/Me0
         ikUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750718358; x=1751323158;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eVldHq4DjbfdVyoY5+6ghjIA8lubME6n79s3SZ+DPi4=;
        b=JFRRlwX1lq9hPP4VR8vTHu0OpWOE9HsAyEkg6gIvGebADbNRi3QRJ6PeZSdAAG94fj
         ezeoSv6o3vcQm8RwGuXqvTSKeMvdNXnIt1iDr42tMvlIPpc1DBLw0OwohNuQYe3eSRFK
         BjF1fdoC3i1OxdZgYCWGKMbrBjMcj6gt41TOgGHaSydSxS4uMK2tHHL1EPxGx9P7C0ow
         uZK1QTzICxujcwdiwMK7YQmQzve5LbZydj/jgBVQ/uRPt0EBzkYvtEHqhjkyZzy2DSTJ
         oqfnvpcppN7kxoUm/Acy1WmiV5knDaonjWOHy5RLTFJceUQ0ijuor4yxUnFCOpP8J22R
         fEIg==
X-Gm-Message-State: AOJu0Yz899JJdQZdk4RIkMkcz68xOGT8Chk8mglcepT6LAKh3LteoEO8
	6zYCwThgHRV7N0ufcJGG4u15iXFSpMBkPU0Y+skKsp5G3k7ntvspQq4H
X-Gm-Gg: ASbGncv9FppmAPfgYdrSOs6K1MBwn0dCBBR1kR8CSsLxZBS8bx4ZixZbc7Bw6gixoEY
	711l/xmDxGEU7526n2Td5d1g4kwiblA0xpet2KdqLpSs3zBP/uN7+cTBZojXgg2LxyvuHSGqM+Y
	kegL3CHjqEbeLdJoMKcHTwZrU+ZEvjhiNAJgsq2HMIrpV8W2C4QD2Q/MjOcKZ0jXDycMruNxt8q
	9sGJiJziEc4zVHmR/aDUbp6mik357x0Fqn5PCsQcoUT2NePS2GNttov2ajWk0l/zjbdcfsQfBty
	igcOT+w3IIOb/thrGFT3Nl0I6buGCDuSYZgxf65Fs7+wTIXR/HnuVSEeeW/p5e6VbSM1MMs831a
	z3D4RDeLgK5HTHQ==
X-Google-Smtp-Source: AGHT+IHYN94A5/Fx/LxUvjM2tcOJlcPKNTiO6c8jVRWWoWyAPBuJXHPcEAuCtVUOpPBBQS+38+Ho9Q==
X-Received: by 2002:a17:903:1aa8:b0:235:ec11:f0ee with SMTP id d9443c01a7336-237d98cf47dmr187500535ad.14.1750718357998;
        Mon, 23 Jun 2025 15:39:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d86adeeesm93889435ad.196.2025.06.23.15.39.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 15:39:17 -0700 (PDT)
Message-ID: <b9ed6a3e-026d-4e06-a1a1-feba6c6a8ce6@gmail.com>
Date: Mon, 23 Jun 2025 15:39:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/592] 6.15.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250623130700.210182694@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/23/25 05:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 592 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jun 2025 13:05:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
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
