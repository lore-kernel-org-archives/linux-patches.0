Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66BE3B784
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 21:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721250823; cv=none; b=Iam/yvTw848ZmpU1xSPa61uOzablNKJK41EPCbzHwSZniF//POZWDotvtV7k0LbL1omlcpgI2u6KgYIC5clEPZXIMG0EEAFM+pWGPpRcUBV7EKRIYlo38mj1yZGQ8JPUYnFTpO8AVSH0XukscD3J/IYS39C5aMOxutoL1QLa7To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721250823; c=relaxed/simple;
	bh=OqbYl0EtPsiIJ/JzofPEfZYdPS9B1E0efqPwuhHn66c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OdMbyl6Bkjh8UmKOMijxmmyHqXCLC2EkRGrtSPlkC/W+fdN+heHO8MEazOUnJVwYi1HAbX8HOcHFPR6jrD86qFaO0QQ+gKl/+cTS3dW0eAYeJZQndpjVarLaScbXHVy5JKKJON+cwPd3FnaDir6DjyBbPdDqi8arNESEi3OiCOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PeES0w1C; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PeES0w1C"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-4f2ee3be4a1so55818e0c.2
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 14:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721250820; x=1721855620; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NW5Oy/Lbqu1bOuochGW5ItalKB23NYf6u9CW0Wpg6Og=;
        b=PeES0w1CZ8ktL8nSIMF9MunbCKv19lY05JesMKcYZpvE/PRYc/W8bSh792BwDIzKUY
         SviuryZ+Crj4tW1N0lVUkaQ7PHWlHiBNQshlCLem0CcoW7nzfB2Z4pAnwnQ9/kaFRswm
         dp5R/RkbM7OqqcQoU7dIAlbyrBiR8H7DyEcCQeC2ZKY1bAcSe1+nYDwGHMmM4v35w+8M
         33y4Mb2o0vpwVZmXAuUhOvcLIS/glqYenbrKg3PU437n/GbO47UtkBQBZBH9pPVaWRTd
         tAGxorJz8ZELfIV7QwTlcMOGMjQwPbnQdfiH0HS27g8doACWpByJ+ikS/dsOVFJnxogd
         147A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721250820; x=1721855620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NW5Oy/Lbqu1bOuochGW5ItalKB23NYf6u9CW0Wpg6Og=;
        b=FQuKN4/N9LCtoxtAGhx7QR9+05nC3gqQaaXb9DvTcqO+s9aldB8X4eHF8S4KnJbK7n
         HlUdXJ+vqdPGQPqyNF0z19eKLkOYAS2A3XKnXGOihAFn9RkN9Le1Q/VuhktLhk0Z1hf5
         BgRORyqIlLLzRXYaJ7DHsL5yig/+UazC6rx5pUPAqs+FBBHovGzfWLXOGUIWAEax46C9
         ojXImjc6vW7//wGN0Rb+rfKdmlYK0UItreXL++RnXnnoJA4lUBTV1GnjomZOPDLo1gLF
         nn4lTXDJKioDyWfEjmR3awhr49F5qNW/9cgcloKNS28++Bg08UjEpfxHYXu55vXR4loK
         4cQA==
X-Gm-Message-State: AOJu0YxPx34r/0zzHy+GsX/vaaCRH1CgrHmSuGn8FFSNO+eGseA9T0XM
	UZLOMR3kpG4VdbQGo1Qc+snuVhgaNGPChno2RN6PaZaHXan+zJ/X
X-Google-Smtp-Source: AGHT+IGHKRMif/y/hLTvwZ/qd61SwN/RQ4C8vEoiFYk45phc3gS5NgJsZUDsoMGJaXBZt1ntEj14bA==
X-Received: by 2002:a05:6122:a25:b0:4ec:f9ad:d21a with SMTP id 71dfb90a1353d-4f4df89f3e2mr3802053e0c.10.1721250820583;
        Wed, 17 Jul 2024 14:13:40 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6b79c4f5f71sm2341066d6.41.2024.07.17.14.13.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 14:13:39 -0700 (PDT)
Message-ID: <5cd42936-191d-4f82-bf70-2bda0fe2d12d@gmail.com>
Date: Wed, 17 Jul 2024 14:13:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/145] 5.15.163-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240717063804.076815489@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240717063804.076815489@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 23:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.163 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.163-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

