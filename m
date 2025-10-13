Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B318C2BF016
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 17:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760375385; cv=none; b=AuZ5nZTSepEks4ZBwIwQgNTmaGjpOGHW+ceUdgGvhescdZOb0wnrMCB6G/Ae3+1st8axAYq2+xKy8+n1K/S94aBIypBqAjM5lvk32g5SLX4BzTEzbaeWhTT3DEJlvpADgLV3KRqzedSLkddi74rX8Iasj9CRxAUl3Ny+MoQhGlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760375385; c=relaxed/simple;
	bh=9u0qMy/Cq9gqm/KPJ3Ei6I8Bl+VxQM9WS7DtgkWaO50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uClStXrrPejmqelixm5VxPEHVM36KQi9iHtFvpGaB8m/Y83FD9TvrYc3QuEk0TRFKuLMfmZSfyIU5l47Zs6pnjr5pjHeMhbKe0yMS3Yihm2igc5gxSWC+hJIP32Z1+3PPtKI1TEp+O6oOUrmPuS1/ZvthOjWHyd0idfLmSQVxkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I26+dAHP; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I26+dAHP"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8888f2ce2b5so245837585a.0
        for <patches@lists.linux.dev>; Mon, 13 Oct 2025 10:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760375382; x=1760980182; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zq9D0oiH0XGev2bvZJNS+y4TMnPelGliSASbJ0U8VMY=;
        b=I26+dAHPu04nUNbguYxfbCQ1XQvGi7yGohgulwCOz51p7mOXB+9VRmYFgo9W905DNg
         mlWJcZUBCyX6hw3BqqvSlCh/hbSfFI+FoW+APQV0jgf8mNsexz0wr++zyatbbAwn8zzW
         Xig+foVNXFxYO13rzue7C5SUDuiKyvRkmF0mKRZEy6594rWGS9xg8lkYQA2z9NQXcuil
         K90SVr0HybuQC2m3wN3V3Qh9xDC8iwFrHQMS7TrxHBHMpTiguSYa8R8dtTihYPoWlIp4
         SgqKNurdLV0sYhqE7B7s6R3bodbWd+p3/4iiO2O0iC5AmG6KPEX0R0ONBK1MjLnlntiS
         pOlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760375382; x=1760980182;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zq9D0oiH0XGev2bvZJNS+y4TMnPelGliSASbJ0U8VMY=;
        b=pkwcq9TTCP0oIjTh7JJLi+0aSrxV3BGs3+i/mr3CN6EoHFwbKTQUNGg+KIgZiWlsO7
         NDD64ATN1wKVhrapzRMamJHFHRL3suRCFIqeumyYBIuI5oYS8z6vo5iewJtDS4w9JWjQ
         KjY+eeB9GKOQfUjLNuk2JKgrrhRQcWYOJrqHF5wH6KtzMxkBua2wH2W9wYsrl9eMs4eJ
         i6Y9Y+kn8dFRboUkvAdwDDJz6Or01nigfHqHhS8FnDMT64zRYSKG/d+DpcZGUNZSQrT6
         xCOaH8AhshQMyHpY9/sBaiBZ9zTzbEUT+qjWzFC2fDf1wprZHZ4f6ufGpT+Z16Ewi8ct
         ibrA==
X-Gm-Message-State: AOJu0Yy+1PSh/wcTJEXE6fNXA6aLGTmCWQqlCYn6o3wES6FnCWxZ914M
	0dU1Wxc/SHDgoCVsyJht95EcEhpeyIEXtgcNAHTYfX5BfR15uiu6GiGh
X-Gm-Gg: ASbGncvhW++suPIAEYCLlyxLANz4+Ktu3S7HC8lbKo6OHqSAK/d1fzoZsCfh8ldhj5n
	ZZx9jiIUpfQ5DtipSDXGYowVFLtJbPBo/szkmPt4uux+bcUV6HQ2+FwLskGisG+sJnhJ+BChqbA
	ZQ5EkFaea9ZGSRh4OqRUjpNIjkKIOhXh8KY6uee2J6dEwRiIMXAew1HKJjFiStlZPFwOz36coTH
	tzv0z90Np2D8sP4MrQRt/ByURaOVEnmjAOFaXh+xAiVhVT1yK/LUYBUCbjJQHqH9QnTqxEHmreH
	aAMUUbPDTEyMojnrudVARFgNI0ocl3zfeIsRjis51gJgx5IbrtH8BWDlv3uq7DurcQKjlEb4A+k
	wLWpCgukzU2PADCZLum2OQC52Unh5wGES7FzFTYFIB+H5qnp61fFEHL4CdSKSkSjhwI/3
X-Google-Smtp-Source: AGHT+IH+yeZp4fthmE6bMZB75N7lU2V9amhOgMmYrKXlYcGZT8jtMuHVCUKmGe6PAoHqnGK3ukeXPA==
X-Received: by 2002:a05:620a:1927:b0:87d:9a55:7566 with SMTP id af79cd13be357-8820cbc5160mr3723625285a.28.1760375382268;
        Mon, 13 Oct 2025 10:09:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8849f3d862csm1029109385a.10.2025.10.13.10.09.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 10:09:41 -0700 (PDT)
Message-ID: <8bf9a72e-759b-4c98-ab11-6c31461db7f6@gmail.com>
Date: Mon, 13 Oct 2025 10:09:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/563] 6.17.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251013144411.274874080@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/25 07:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.3 release.
> There are 563 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.3-rc1.gz
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
