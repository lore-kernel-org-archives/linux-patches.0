Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D253214A62B
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 18:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763749831; cv=none; b=p0chChznZVQial00CA88OPh0oLwFivqaFr3Wl+L/ud0nHGDmg7OpeBh/V4ja3lIO6Vf8L4cgyR9A/hnGJdQzSpwrjvLtWDF46qeS/Fta9oJnPsB/KKQ7UuPb+9fNfcqiHd8N1tnEZQHI6Nx97jb+YO9GbNiuMhQFyv6hFYsJKW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763749831; c=relaxed/simple;
	bh=/3Fsv8xJYGR6NyMnCYC0WBdDkXp89MOQ0KycMIpmru0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fuKO9J1++8qVP3ZyFgbeKsshy+1UN4UDSUzrzo7GKB0ZJ9CBJIYP6akfhU3QKljUOJJ4AcEmTR6uWQfy0azHYu+4gT8NdV/eKqwMNDzKqplEBJEZLD91vNppIobdMBxFgOGI4o+74yP/9UEPsmtST9mB8WKOa8a+8IcccHkgYjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UrSFQXvS; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UrSFQXvS"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2957850c63bso16403695ad.0
        for <patches@lists.linux.dev>; Fri, 21 Nov 2025 10:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763749829; x=1764354629; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=05vOK3XNL1B/SMLezaEPANrmPpyZuP6hBZyVD0fJcn8=;
        b=UrSFQXvSAqx2+ZtnxlPW7i+F1JaOozQ9bsGu45QWIJJ+tv8GFtlFqwse7nm4ApcJp8
         UM3xeWwgwlD+5kACMeWk92BuiVWSMK3kqFLXN65Ouwl11SZZWYoC1hMNyTagy8ybf5mX
         6jsf4fn53HdV7RrYk+TxC2eUFw6Z8GfdGS2nLJ0cyJstQ7dN4U6Qxrs9wsIwmJzSrFZ+
         Y3w9yuUYTEV7/t+dwIbEMmf23DA24Mk5uSQTeeEFngXPF8veOFBeT5wO/EIzg6tiYVAL
         biW8lN6uM2Y15KYfOdt1AFRDloG0YR1esPjXzTWRcH43GR34jFItz01o5SgsLCy57OUY
         w7Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763749829; x=1764354629;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=05vOK3XNL1B/SMLezaEPANrmPpyZuP6hBZyVD0fJcn8=;
        b=SjXZcge0UeEkBHq4AB8y3pt3VCCaJS8QgO+yL0epDD4JUh7lT4KGu6PNefiX+SxpAN
         r9WZJb0feBV1hu3Qlk8HCM6TlYzGQCc3btZhovJ0RZseuVA6Xq22FiU30NAXegdVGjtF
         MYPZMCzUbnZCSs9V2P5nrcJpWByKpMYeU0I1BVK86m0CJ8cCj4a5G17OgGp/F9yS1Uy/
         rVOvDg+zcNKfRW1jJ3fypmYt2rZVF39SKBX0nVydZxtmMukf4d7T+9zGiJRdgldWBhT/
         9krhnfrsuphdTRKnjbF+X2wwC710WHLlRESxxMVPmaeQX6FWeay55/YnJWaxroMUkiQ6
         ejJg==
X-Gm-Message-State: AOJu0YxmucsKJ70eyk9a7oLLi1vhJblfqjT+9IIfzN64S4M+n0Xz2UB2
	DdODe5rOTGeCyaHg20vPw3mTLhQo7IZpWSXvc4PUSSbtVzmiDECxEb1C
X-Gm-Gg: ASbGncuiMIzaYOkiYcrb6o4krez44J1VlhW4xTnbOFOlZCTmXQWLN9oUWAXiw+qFHuD
	1E3xTwuq3GqvNtWM3i/40/hiQhOdA2PVhFB1skghei0J0y1tMILR9YX8mqoNtZkYHIJ7gzjCJcO
	g3ujhTgga/qWr2Vh9FvRPyu+re7n89pgerEfXQWuu+xrxhwBZFWrx0BvdmtE5eYllWrH5RvLwmz
	S99oAIAZx8tODsj+1ymPi4pSBFLHdbAsAAijpkiWP4Fmm537OeDSndpVFqYFDSRfBwITdgx0fSg
	wrc/fYiZ/xTk+5O4QXb4wbmsnxi9GV3KKMrQ8ntZk5bXIVauzAMWX1pCGHixOsx0NNpXKYYoBVa
	+TTfejsZyXiLp1XHsiq5GJOBSXADmnl5gFOcFL1qpgeS09QXTjpHma/cp/lrGScpTOytaJnT8CF
	uFth/Tp093gtVMDA1xTpYOfY6b2HBEVZPIu50cjU5YmBsu8I6x
X-Google-Smtp-Source: AGHT+IGTeIP/rqUuipvHHkDhbk0Up5bcjTyiB7vyj0WiNxinfe2KpLJ5dSrjZjejShsIPeV3u+Npcw==
X-Received: by 2002:a17:902:ef4f:b0:295:82d0:9baa with SMTP id d9443c01a7336-29b6bfa8cd3mr45930085ad.17.1763749828890;
        Fri, 21 Nov 2025 10:30:28 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b13e720sm61910715ad.42.2025.11.21.10.30.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 10:30:26 -0800 (PST)
Message-ID: <528cacca-7972-4319-b145-bb3ca8bc7756@gmail.com>
Date: Fri, 21 Nov 2025 10:30:23 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/244] 6.17.9-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251121160640.254872094@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251121160640.254872094@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/25 08:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.9 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Nov 2025 16:05:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.9-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
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
