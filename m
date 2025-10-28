Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21072C029E
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 19:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761679599; cv=none; b=jC7Jr8pVz+PGNp3qjoZXQPaOjdU7CD8xOidlDFpI+RHYQjD7Dm+1Ll1N4PWzRyt/gSRShiGg0PVW/PHTyDhMxjhzNfB7nAXkiSyVgk+pt88ZkwCNmU/1+SsJmcgErbhFy4szntB7yrYB79mi/8H/iRIDY/ZnGhYuvjM7cnvzf0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761679599; c=relaxed/simple;
	bh=fWAjrSl5wuz9CHN+jSQpndkryTRrBFNBMsQjYdVo/hE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gDkXUwKIcjjcRl+5RWYb+Qv5spu0YrsDTCAadduKdiAK3Ux5GUSm69/AgDVqaZct77Asgpj+wUy9Z9RFtIqIUDS1t0SGDJRdgme3+FdK7Kw2mLMzMUqinkzN6JFsoR4gdxQQ2ES6JhIGPSEVc5qsxC+7mI7Tbfr4BMPE3eBNv4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNyuSzrf; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNyuSzrf"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-938bf212b72so272333739f.1
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 12:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1761679596; x=1762284396; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8IvIkf55LIrjeya275ZJh6F0vpAd8aXk2EAO0zzJPoo=;
        b=KNyuSzrfmhBPc+NOUWrdMS1uJpQXfO4UKFyB57NIhTqEpPE/K9NdJ05cO3fJx/MnGQ
         B5fLVwq/evEE0yvwm1Pw0Oc1qOVbIlOjbZGW17yV/goxbU+E68gUu9oi7+F5Thcuw4pb
         MfW8Kn5uPLX6RYO1xlLqu2aEb/ySCkM8UEpgE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761679596; x=1762284396;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8IvIkf55LIrjeya275ZJh6F0vpAd8aXk2EAO0zzJPoo=;
        b=IIkR2nwh2Ofz5vshKTkYSdpHhZmv8fw8Mf3fJXlwQREu+mSelWFtbeHv+U2MUfMynp
         SeQJhe3uR1Jr1REN7NL2w4nAqiRVugusMwDQ+Y+TY6ZYGme/FVgJyo0e++q9Lxuh4Lpu
         rSvv9G6GoOaumfQ2v/c5d/90mw4iMMPjzsoG0RdxJQyUlyPnlcm5wcvoY2vMx63iOOTM
         YFy/u7wrRTgy7rUHNvlJkj+eNzoWT31lHIBOPQWqjhuGK1zBxyiiCeqePdWVLUrV1p+5
         MhgDcz277VUfH3YNs62dlUrDwhCX/VmUwUOp8XswccS3uuHw9JCwHL8cI8zIliQm+mDx
         SgHg==
X-Gm-Message-State: AOJu0Yzq5mAs6LHUwS+QUOeVqJarchhkc8ntsckORifNL/Fw5vkWz1mV
	UkO+OFM6Cl+cUfJwyYII+YMGLbEo+kSm7QNGuaCVqgs1UoSAPjjs/KQkhIjSW7m5y6U=
X-Gm-Gg: ASbGnctfSx7QLt8OUe9NuVbu69nTl04O2/bqMmp4yLJprAFNVg1PLF65DZX3NRDyWKE
	JFpKUi55H100oc0dnPurwnIy8o2McqiDfG9CvZ/BnCv7E3lckihb9jm9MjJfG2h4J2+ymePVlhk
	qUCFGZ8XgdGS1VoyTHkf2VayQReYbKwc94nBiTV3KaXRGkUy9exr5z4GV6+op3jVb4u1a8pPLMO
	EwexRIVlQTH95tqnJ0z6p5QRgVyTfPU9AVA4WhbFPEOOawyVBKWbPZIwGy2Nz3+M8Xm2wP0dDL/
	7oHjSmkhQvNwGpUgohHBL208j5mT3wgdjL2EfpKFCQ4XhEtf+5Dmujszz+pbb/vTXdMGo49QB6F
	Rb5E/Lvu2q8QBG9MypI1I3RQry3lCWyryx9JQ1SkV4YK11vZbCaFndEI6xf+TPpVLGEANz0Zo8d
	G+Wpa9N5C7z9zv
X-Google-Smtp-Source: AGHT+IHOET22zbNd3s2CTpWwK2kftebS+p9x9Q9Rf3shDPSfh25G9Z4MDAp3rBcc8BbD8E0w77JeMw==
X-Received: by 2002:a05:6e02:3a0c:b0:42e:7a9d:f5ff with SMTP id e9e14a558f8ab-432f8fac74dmr6310995ab.11.1761679595937;
        Tue, 28 Oct 2025 12:26:35 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5aea995d2besm4673940173.48.2025.10.28.12.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 12:26:35 -0700 (PDT)
Message-ID: <cd84d078-53bc-414e-a879-dcf3a10bb179@linuxfoundation.org>
Date: Tue, 28 Oct 2025 13:26:34 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/157] 6.1.158-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 12:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.158 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.158-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
