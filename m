Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366312C21EA
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 17:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761154395; cv=none; b=rUzPPd9NAaUv4Ai2s93ch4zDgE5iQTmJ8aLp7CdHRT0/DC5jg9BGDvE6GXhFRZOIgQrxPnQTdN8UrBqhnFhnAeLgIY+SUa0QNUzTslrnlGl9aGit/ZIw/FXwSUmP/DO6BUoUUuW4sj4EoHg3/45WRuzwVA3HWQJVNHRGHGE1acw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761154395; c=relaxed/simple;
	bh=X6lF8zIJjF7s5ROui5zboNzCSWi7qJozziFtgW7mR/A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pWaJeuO/OZ9qQlRQTgY59uSve7U9tBEI36jNcIQuuiGP/kb3vFqPg4vZzFE6MzWUAVU8ksraSRfUSGs5ZfRgXgtwvUl74QBoSWY6KO3X3yh9Tj9ybIoWmgE2niuuhm+FobHCOMaghWczbDUV3ytm+LZPNSUbGjB4RV8qjtjF4yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cS7opd5M; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cS7opd5M"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-781ea2cee3fso6419077b3a.0
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 10:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761154393; x=1761759193; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OroZpdIC1yf+MDvOR3gnvSgvT2N1FiEkEXy4YQzpI70=;
        b=cS7opd5MENT7KfXoRU4fpiljnxSYmHQbriZ88NvXFDFbK/GhkTK/2m8uCQrXlhNB50
         DAN7xEGZd5095XNH5FZ/hw1229ziGyJWxjhUEqINOVUGuneim2nu+qNDYq5TuoNBZwVJ
         p0H/xzxtdJAGR2s2gqo2387ANvRHUE97tknrKU8EHpULpcEBYcFDE4pSYA2lL3jiapml
         489f1ZcE/23SDavpWjUjS35bbWdvBkAVgPIcn7ywW9qPT72xEbgKGJmAfRskVdTvAGwF
         O315eNeWx4gUXHroWdzbvOWY1LuOfDBVdiBDYNWLvt7/g1PT4+Q2vLKtFX6VAEw/nLqm
         liJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761154393; x=1761759193;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OroZpdIC1yf+MDvOR3gnvSgvT2N1FiEkEXy4YQzpI70=;
        b=ZHT0OxwUQk+xYJ8pqk2GC1Wz+MmmMxYsnmUfb6BNL07DxaIo+MEHCOQEARSUmyHSJ6
         GD8ss3yeZ7ZYpwVDhjwAWYILy61mjqYDmw3foGXYsTIEIxSslkjHOQpdfCGSGZRc/mKP
         LAXHQyGTA5Gn5KfG6nhCUDUZbFNj9lNBSah92DrXmU6TtOg+N0qAuEMRs/jppyObj1DA
         o6fq9+BqVc4TKjYi7eTYZTaup3KAmqwJSBnWa3k+3pmzIuIqZFnwUOohzAxbf498s6Bq
         LR4mSIbimFndiJqUI2Lzkyau5DkX2I9O8ainHkyrzztrkNHZ/GpVbDq7o/WvEJPOcpkQ
         I+6Q==
X-Gm-Message-State: AOJu0YxOMqZG90uVDYh5M3460Z5oB/N2wLET0BBSXTOeNVRGOq22EkO4
	WTch2eMB+o2o2Xyjyg15R8x2Wkxp1daL1Rl39MvzOafiQ1l5Zy4V+0H+
X-Gm-Gg: ASbGncuqxaVFSQPuXJC5q/X95S8BjJX60hk8duRdjjxPEkQyZKkSjOE6ZcJEBP4sbfP
	hhdig9yCnanZA8do7ro7tsJmqyPjqTqhffuXHxMcUlN+hH2a0c78ZBHLz5KYJhiAMHyZYKbTe0m
	rE1/EPq7MmD9KXyyjI+5dOGrFMtiLSLGkjA0zu85lQBDWsXOdO6gUc+PKeGKgvr1GXFqB1qNEE8
	Xxovm8FffXu441dRc4ubmXyrmyf/Nw3mrYECyaQqVL18MeWHe+6Wf48PWa7jG/0AI/TESEqqmvs
	VlE+1tngWCyRbutZdNAGaZy/kNItKxVxnsfUnZPb0zZYyoqgIdpm0weT32t4NrMIUY8FrgRNFOr
	aDx/LiUy5v7gQXE5SRtbFgGrTp0YBCyXQW71tontBUiM3M27ZtisToCLjH1IHkmVTbUYnG6ayqH
	XHbDruWUgXbmBo2MulIF3s/UCEjE7BEva1nqYEYQ==
X-Google-Smtp-Source: AGHT+IH2Iq8OrJ8QYXSfjxY6+hOLsa6tF8yaRUdubPLGMOGZUqcxqkOZLieRbhpzfe7R9WCuEBEiww==
X-Received: by 2002:a05:6a20:a11a:b0:262:1611:6528 with SMTP id adf61e73a8af0-334a85fdab2mr28401979637.29.1761154393201;
        Wed, 22 Oct 2025 10:33:13 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff349bcsm15116989b3a.17.2025.10.22.10.33.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 10:33:12 -0700 (PDT)
Message-ID: <bd847f60-5d93-4924-8e92-ec0e3b809817@gmail.com>
Date: Wed, 22 Oct 2025 10:33:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/135] 6.12.55-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251022060141.370358070@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251022060141.370358070@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/25 01:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.55 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Oct 2025 06:01:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.55-rc2.gz
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
