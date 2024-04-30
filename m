Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E792184136
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 19:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714503939; cv=none; b=mCo2Y1tglLCLZc2mK/2mRxlFnaaUGADrLem8dpVz8JOV/S0ZnXyEMhDpcl1UNZjg6MlroxqsRzZsQl/VCPN/O4cI7kPFCQJN+1am2/Dy4Epf10PqdqSussAR8HcrHMHnSZkMc3cJjIkgZ3t5iaKaYpYebsZJvuLs65AFQCtQPvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714503939; c=relaxed/simple;
	bh=WB+cFY/Oo6dEPImnjyMRPDI5dtWUaU17g78MOKNedr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N5RRYs8BN+82i2CNzkQL962hMt9Hjw8YV91p0RUyzXrV0npOWKReEnFMmaDliIQN1xhFwzmugXNZydcHYVxmWE/m1R2kwjSYoMZVoWoWPXAozzzX2lm7wu4z97TxB3BwySXx7i0E4cUFr1zGWlKpGllOYSK1d9VeNQi2U6YT4c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gPYVziZZ; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gPYVziZZ"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-43ab8e0f435so11950951cf.1
        for <patches@lists.linux.dev>; Tue, 30 Apr 2024 12:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714503937; x=1715108737; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lBkZM5+/yCa0yNBxYsm6HArSk5dGVdMk10zv37GIXdQ=;
        b=gPYVziZZplDawGR7N68JfcygLNjsOWkz1C7CASWNtOUWFOUgFgylOP6THqsib7+Ykp
         bu07EvBiyrDzYGd479QQTff7/LpkzExStLXyTM7V0tO4vreyKv4/vElHtaOWga4RvgGf
         rT9zePn1Qm5gn1JimBPOC53qX2oBe/Qjjp+NXgTgTyWzowhiUK+smH8VkFuCp8YcTT3e
         sG1QV36TCQwl6xKtEBGCOdnRtsCMxHaNWoOyyLikpprv9qSw1HjXpCMjnssyQtKv18uY
         tmyFNtULl8MkoqUhfMvfec/JFkZ8T2+psAxNUPLwPnCSfw/Vy9z+5eWy2F2PLXdStLJ5
         /Z4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714503937; x=1715108737;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lBkZM5+/yCa0yNBxYsm6HArSk5dGVdMk10zv37GIXdQ=;
        b=IeQFCJPmJlzkZWjF8nnA67rbbdvjuM5sLtfgj3IX6RI61UHYY1E2fVpRjarFnDCTXh
         MOyxUGpXoe1kkGFwSNhz96TgldE9/gUypY4362ckBWtM9ljiVG1uniaZv7FdXIrqqsjc
         3byVDfLseTAtjThABnPMhA8KNEh5ekjYoXZa1oWu8r45Oyf3VQOI+s+II0DaGJ2H+frb
         tSPGjGnzM52kt4Sv3+zRKM/xIMh+1kTa6pTyX/g8OiCEJhSbyOeOFihg/5heX3bKoM0g
         YfQ730owjtO5CQ9gGx6frDiYLZ/LyS8mQL+HbxhGCaH7MPamcdXGbFte9ySssmZEgsrK
         Y8aA==
X-Gm-Message-State: AOJu0Yx9sSg74f7cWi6f9XMNW48VyLuu5RK9Mlwh4XaXGtC2mBfSlR+/
	lpdCV2E3lZ83I6VXdRdQK/1fmPeBCnhflx5jTddEfHsBv5SVp555
X-Google-Smtp-Source: AGHT+IEvDIWbNjqKzq2B17rnkN0GdCNyXVkqotY2iwNIEhZVicQbuQlmJyxW2//UeBAFqzO63nGCjA==
X-Received: by 2002:a05:622a:5488:b0:437:bf2f:9bcb with SMTP id ep8-20020a05622a548800b00437bf2f9bcbmr234769qtb.22.1714503936832;
        Tue, 30 Apr 2024 12:05:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o24-20020ac86998000000b00437acb8a6basm11199685qtq.6.2024.04.30.12.05.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 12:05:35 -0700 (PDT)
Message-ID: <a7fd3dcc-2831-4b0b-90bb-1855bf2bc7eb@gmail.com>
Date: Tue, 30 Apr 2024 12:05:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/110] 6.1.90-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240430103047.561802595@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 03:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.90 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.90-rc1.gz
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

