Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596F8218584
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 22:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717871; cv=none; b=jf8NBIlZ8GpZbUX6D3GslQkFSdEONK9O6gxF2PMnoTo/ogMInxAgSuT/amD1RWLlAxFp4IgWQnwxEwJYwPYblDGqi1lBzRP8rauzGg0keszOXYrtvn87NcqPDkz/MmH+4teMEZIHLiIJUS+UfCtE6NKDeGkmiA2YwJNj+LNyBJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717871; c=relaxed/simple;
	bh=J4prJqFMOZSWKIBygwjjzYfvEK0tX+WSmnnAOmH0vIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p2DqnnQLR+fe/mF+fsacEHaqCwhO/r/ig4rTp3fs5lroA7snvMIGKZOtzBh8mkTytnIifoUQbvGOgOfolaFl4GAtqcYL0xymvEjTtGrj+qwTfpVa/aHlT8hkXVRQJnvE+n8msJPFzTnNd4p4YHUrwPEdcQLkdzFGoeGCf0tcLG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HnxUOQhN; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HnxUOQhN"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7426c44e014so4147897b3a.3
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 15:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750717869; x=1751322669; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=crs67wobF2BOCAMBhQN6sPHu3RMDqfrP+kr/UvgkGpc=;
        b=HnxUOQhNRdJaNLTv2GqAE1Xli1eJzikrwnF7Wpj0i187qWiHUl/UseRCY52Em7Xb+k
         yxyFz/caf+w50vbYgRmfMRXzkSSCxbpRZV1Zbfl9oAuYAD4R1y4PkJjPjIdKAEPtvfGC
         V9qOWnTjHaysHtyjdTsW6T45uJn7HSdFJfFZcDv2nyDtGI18Ltl68j86pNi25id9Gbd9
         0F2ZOz0sBxQqvK3SCeU81mLYYBkkQA71KOTfLq2NmPOwAc025/z3h7eZqTN0pnJKwZpM
         5rj0Vu+qKyUTnZcXzsyyajIP2ANC65FHJBZFbVh65ROEGANrq5zJdMFyw3teORHM0cVR
         XhHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750717869; x=1751322669;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=crs67wobF2BOCAMBhQN6sPHu3RMDqfrP+kr/UvgkGpc=;
        b=PNJdUlMKVHBdHxUrRBXzt92iTaPMw7Tt+WF4cC9yej0wkgCceJid8ToaNgtUTYQluy
         60LEhH4X+xUt/MljnbvzYfaWWj/Z9wpHpzlM3FI578G+ub+3n7GQZumlBzDs/Y/rSfPT
         4LPh0CsoTO3lTV16hV+ZipMWkvn1T27rqntCFXNKjNmY1vqxxxxZi0Cy+EKkpJaoaw49
         k6EH1lcV/uL44ECzHwMZmuGikuLtjYmjQFPBt+EcU9rJTq9OT1SIc6hcGBT5Ch6Sa2HZ
         /78KjXyUTtog/5ObI+476kSRY/MlJtQJs3ZfR5zQSVQ/A+1YttX9RK5pde/kGsmt40Ot
         0OZQ==
X-Gm-Message-State: AOJu0Yw9wkGS2OfInAqcIIXq/RPWgqLuY8UVqM821iUgmfIg68ekHmrW
	2qIDUHwMsyBVBIJ+ktePhkNdbbIc5ze+pzt/wL6RKEHoye7IWwcJa1NS
X-Gm-Gg: ASbGncuObIDu/4DuNE7Ni1b18CqVu4pNvSxZn1xIjwKf3Srk9A9GFIYTGxdHck4DqXa
	VMtXETusgOtOJc45Kdm8PpkLcDqncilHpG4ubHwxEWY5VnY6INXPjaK08Pli5556YsvljdO75US
	VXE7r7aMRoioZ1eK/Ev1hPywM/QtR3EQoAyo+ItOpanvm46kdbCQqU6NMWBHOlDxeEsFQyXT7Ls
	lF8rabkW9zKOO8lhVfPEGfDeauNRisB1xWFvagtFfDQYYTLw745Bm0dIZ6CmAPC5I43PFjzzYZ8
	i2v5kIphh3K1JEJWZfsMGKPTDWaT25Zh+VyibTdT9/Wzp8lqoIv/faKEUJ219rtpwgppbNG/0AJ
	lJce18O6KgawUng==
X-Google-Smtp-Source: AGHT+IEjk1KO6eKn/BPMgWMsPPKOKrRIfqRcuAx757mpeqbEUNy0qrn+KEdNTu8FV7x0iFVmxafGGA==
X-Received: by 2002:a05:6a00:4f8f:b0:742:a334:466a with SMTP id d2e1a72fcca58-7490d6659f7mr20225510b3a.12.1750717868667;
        Mon, 23 Jun 2025 15:31:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749c88532absm180337b3a.131.2025.06.23.15.31.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 15:31:08 -0700 (PDT)
Message-ID: <fc7376ac-21bc-4c9e-847e-5e86c748777d@gmail.com>
Date: Mon, 23 Jun 2025 15:31:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/414] 6.12.35-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250623130642.015559452@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/23/25 06:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.35 release.
> There are 414 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jun 2025 13:05:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.35-rc1.gz
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
