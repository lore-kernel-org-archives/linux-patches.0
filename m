Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD6F2D978A
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 17:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775756780; cv=none; b=mGyoO+t52QWUBIX7pl+JiQUdZ5dodZHYYf3vdIDhHujiZb3fIpx0Jh9GbYHA+RoUjTJWkHhn5d6DTlzjI7q+uOuiyJlzAZYM2z8cZaXFWOl27d/3eN2wAfp753oxbvPE9p7YorMPvfinS2npwvdCVeG4wDczCZbHwRn8R7ubdEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775756780; c=relaxed/simple;
	bh=57a7xxfAJFhR3+ynBeRHV1UtRucLAcay9csuJzC7Wu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P4PhI4M70ibtxOL8aOQS220l+ys+2HqMdzB5/1I0aduIFI2L76uZldFxu4UQ3r8DpNCZWdC8yVjBFAKzMWhBiIkjeZsduz2w2qh5PDlZ0jK46Ox8loMlFhkQ17cwTIszk07UBgILNtYfURisLMR06cSwB1bCL2Pfb8JsdE3iD1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XalrMolJ; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XalrMolJ"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82cf83bf375so610666b3a.0
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 10:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775756778; x=1776361578; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7dkiOk7ru+pz2NgaxSgxh8nzfjv/NflXfPpkd0541XQ=;
        b=XalrMolJNN16pxni7bxN8ZBp6b2E2dH7flPNjHTZab+AVB+kadUZN2MuKBqa1haCBk
         2nmTCS1TIs6PCZeGTRr6Sx7cjMCzPACU7LtBLtn/R7jPFwjoUd6ryszZpNDYiQ+ny2EF
         MghY6Ah01k9s4KEUHgvvvtnnizyHAlGSXcZ90XjeaiMQtoSsxKkBPZJWj2DbT8UFxRqY
         p2kc8lEUHf5dbJi2VQAWnCzP+3EbKbfloYKPXBgS72kCVMmXvxMDr8ljIpxw3DVZFSmV
         E6KnSdm6ot5ml5lazEylFGVmAVBxGrviQtkPp92J03/Q/aYsL/cbCikOlzoKMV+xqMvb
         uq1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775756778; x=1776361578;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7dkiOk7ru+pz2NgaxSgxh8nzfjv/NflXfPpkd0541XQ=;
        b=Tdoa0cCPc56ymZpzz2n1k67pGk/WPA4cnNuR+6+08GIqA+clPDoFIMoYaZYbNdVLQb
         wXpB1I3JqxxL7ImPUcpz1wlxSJJHMfsi8Mv/eRdPAI9yYp9oTf1+gJZWRLIBjBzqS9Hb
         YxRVC8spr5q8VqsZlg+JwIz/BFWffhruqONhmBvmKNFGMJPUw4F4SSpCF9ihkJ6x+JZR
         WLOBo/QBEwi/V0BfTqwMW8uAaLmCfWkjxcjbahk6++OhPHvIRRcPGlvn1tSR1hnm+AB9
         LOFeQ3Fk5GN/8KMb/AfSSQIkLe7+K1eeR9pwbAz8Qyv80tmFUAybQo8EsJ8rUl4Zf/DH
         GseQ==
X-Gm-Message-State: AOJu0YxlATUb+Nd5PJzdXZePgawZQWtRSX69eg+YdJmZJ2rsZkE/PJqG
	NefYiquKD2ALr4cOo7qFjLEArlz0cNnzqyVUdTT05vZpXr/YC2MS8Dz0
X-Gm-Gg: AeBDievQObZm69I7nG4Q0feqJ6mnm1mWEHXBfkfppw2RmRiecsTc8lbM0xd4//4ramR
	7C7+dNw3ttyYjRUf5vmSU/pA+SxUp7q8vMjdHUTQlTlYVn8P2tzT6g3fLZMWi5T+5yb/M7tqvFD
	3/cabo8jOC5EHO/1MhTG7Q38oXgFEhKxNkEAc2JqvOfScv8+VwmtR9pLdqEDF4WTbbmZJIIi5ys
	8udYLumtisJl/UXB/x9Rsf7fTrZXGDcQl+EZnSJ9QiysN59VnBJ7g7qzxaMUalBKU49i0PZAQUF
	EopaNl4noqsH3DcggJnq6Pj2fsAyMf85hdysRz3d4ImOBgR6Hp73w72o9FxcwTNMTppG/aEcuhM
	4h+sUkcGIH1Nnf8MTPn9CmdFGf9U46d9AhhjO/Tb93/SLLv0QdFpTpu188hxXJAYxnmB3VtUypx
	HvBsim9EF8yye2eng/J/OQ+eZdQnweh/puEiBa3p3u8woP110opQ==
X-Received: by 2002:a05:6a00:ace:b0:829:9ea2:3e17 with SMTP id d2e1a72fcca58-82f0c12f8c1mr151735b3a.9.1775756777968;
        Thu, 09 Apr 2026 10:46:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c30ee4bsm57712b3a.2.2026.04.09.10.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 10:46:16 -0700 (PDT)
Message-ID: <2b8c4d81-e85a-4297-b064-e159cf41dc6f@gmail.com>
Date: Thu, 9 Apr 2026 10:46:14 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/312] 6.1.168-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260408175933.715315542@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/26 10:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.168 release.
> There are 312 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.168-rc1.gz
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
