Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E95437845
	for <patches@lists.linux.dev>; Thu, 16 Jul 2026 17:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784221419; cv=none; b=dA93uXMoRafI+CpYyLEC//WG/TMNS+E4bNzl1ERERidj3SOW3jUSgn21uOXpFGsTA1q5rFJTnTGEnEjdNXZ+0t1WVnbPuF2hHNTr5zWUDNJ2TqFR94VItPPWIQowHNtujFlblLRLv9QLitpI4S3bkopffTE01ePSJ20gE41piMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784221419; c=relaxed/simple;
	bh=EIqvPqeCjm5Dc9Jmv5QrM5AqpBkwUJmjdkmGX6+T5qI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=piYc5ch78VIB359lGffNkfBA6E0pbj3AHUEGeqCN5GopB/nQpax5MkuaywY1zRbdPv9O8+Rv1skn1AA5R2Pkawy6WklysHPDe4c+AioHNgzNKjdszUrKUHcW/2wIuaM3pJaGZHT4vhfWQy+w6xK/e59KuA2hMnDLC1gwOwRr3nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MZdGVUXE; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MZdGVUXE"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cabc0a1ab6so79376765ad.0
        for <patches@lists.linux.dev>; Thu, 16 Jul 2026 10:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784221414; x=1784826214; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UKtPinLhhVEt3RyIPNlUBx5bJFVV9VU0HPG4/JBg7mQ=;
        b=MZdGVUXEu67YtXR+TkEZr3GhHqyBCLF95Uzr9mxsRqW6pz0M4b3WxKIT+50RVu+T6Y
         I98GLl9x9lh5xS9f3iQ1Sz4k+LowUWsTSu7BxleOVZtMx2RLQuVOw+x8G4+FmlNoEPaf
         Uk32x7SNl2vGg+bwwQVX4DwzLoQoFVq0FkdocIwJmwlUJeCXxtdzVrq37qPkJwnYw2BA
         e7GHjr5DjNSp3PEsT6aObc7gqQJPzRuPdevPQJgUz3lmoREW7PvuUKIi+6MM+gQePFxo
         FQx16/sVF1lD8BM9D8PLl+dEX1tZ7HARCMNwJRmi08a0ujCEUdzwI6Y1GfYPDFDF3fNE
         uONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784221414; x=1784826214;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UKtPinLhhVEt3RyIPNlUBx5bJFVV9VU0HPG4/JBg7mQ=;
        b=pMWfz965pRijEX8c2IxrowAhZ4KNIT/3FZe7uu9AmPikHLsHjqWgJFzKKzmLc0Rw46
         Q0GdOuwpoNGV7TJNr8XoCmML1nEjOuqcSTjr1nGg2tWjK92UMWJ2mqmctnH931+YbPlm
         uZcxrFqMBgvUqHAWbgkLfOpAIeXLDqVmo4vZkiNxSzlLTfzv3POt7DXwGpcD9peujBqU
         BJwIk920yWa7h5u51QTz6K4oeZ7l5jSUXS394l2gJ1UubPrvAR5eOrSoBXwBoGYLPQkr
         UuLjSLvgylR3rt1DrlF56SaJY7pewCCXwJ5gO8rMWwqAaJxzFl7xfMNdP1445TETQ7Zc
         NfjA==
X-Gm-Message-State: AOJu0YyeaLhaGelDyMGl3QSvFvl3H9WB2Lyf8hoqT6BeQ/aF+6BiC0ay
	4ccbJ1GBuUA/pNsyH8B1GEwYhSoXYHwfY3XWdhTue9bOuq3mm4jNrfep
X-Gm-Gg: AfdE7cmUYwmpl3+RIRCXeCqQMtRXuqg4JrVf6VdPUG0ZSeOKoQJYO8B7mpR343VobTT
	+vs5uvyxUxYEw3Q/TvaBP/Iet4Vii3xdOR2pRRo4/t5msc8qccz97OTOfsBnR1lgXjMr7Ybs00W
	X1SCkROAXW42eIJEBIgz7OHTP+2dbEaY3QaXIx9rUUVm2OEFjcGzPLh8AUXFS8HUcsSO35u3T4w
	fEpHugnZGTsg+zNZrIBl+x2lVu83YBYVyUS3Ur9YmMRBpsF4kaeb/08inWUhMC/tc9NfAIpKEI0
	AMy4shNKu0UHygnwWLrXoUUOF41NwiIPxIh0eNfv1eKAdMDhm+H21Vt5Jl9ubFKYZLmo8iWSt7h
	cjW+x5Ni49KxOBWM+est7XW3Sy9NdiGe80ef6Aji/avfXURd6ucTHLq/f+Px7OGLsSzJv0NftKh
	74gzqv8cE36qZD0APqdsJD6Gnu9CXx0ZCvc6cmr7M=
X-Received: by 2002:a17:903:1a2d:b0:2cc:5f48:5764 with SMTP id d9443c01a7336-2cee9bacb60mr142293835ad.44.1784221414399;
        Thu, 16 Jul 2026 10:03:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf1012c343sm23542985ad.25.2026.07.16.10.03.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 10:03:33 -0700 (PDT)
Message-ID: <c577fafd-c2ff-400e-962a-f9e77de3c434@gmail.com>
Date: Thu, 16 Jul 2026 10:03:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/349] 6.12.96-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260716133033.287196923@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/26 06:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.96 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jul 2026 13:30:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.96-rc1.gz
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

There is still a fix needed to get perf to build with older kernel 
headers that I will submit shortly.
-- 
Florian
