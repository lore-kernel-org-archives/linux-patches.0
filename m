Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A761D63F0
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 03:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757303427; cv=none; b=ZYm6LL9Bk4nc0reHsrRvQ7ZcsXP2YrwmURkOWgl7dWttPzYVC3mZW13c9IOXyfjwkAgitb1CgFjvc8W2P5SfzxUyC8aAz1axTXdSpCHy2hmR2E8al/CifD/Gonv8MN7esJtQAJ4M9WAgpBkAj8PVT0+ne268gt5C/XUplR8UaMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757303427; c=relaxed/simple;
	bh=hUOJUjN7uZ56WvyOp34yQKa4syixecTF4g5kMWnFvG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WvEvpNtldXGvPzVVakzNh4WJHwAuT/8p8i1T6/aii1VcWiynL9NGWk/Ky/FvRCvQEjzJTde/UYmTjwe2jfhIdAwCslU7+enOTZY/3ZEFjJMCfBwUGCcqZllWU8r/wBM4+DUvPJF0zw1qY6Iuv1XBwAaw1w/6g2pXLjrJlXJ4LKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f06Mj6xT; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f06Mj6xT"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-24cb39fbd90so33181115ad.3
        for <patches@lists.linux.dev>; Sun, 07 Sep 2025 20:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757303425; x=1757908225; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JcU7raKB0xaPr1u3hysKEvXRC7PvlwZV/t+nAxbL6oA=;
        b=f06Mj6xTkeThCUoQbuagmS9PvN8zQ6Y278Ntx95r0EyTu6xLVmLdMFxh6snvxN+V5R
         tPiwb13xuVUGXdYa78v1qYrzWOj42s9ibHN5auQsBRKNJ5W3WYpafG+07ZIqWi/GOynI
         iKPi7bEzd9lRunKcqu/N1Or53HQhJMVHjnm4FDez+L2f0gg0FA/2mLTIpAkwHpwTbd3b
         Hu2qudU3E7PulcBDWVntTJmdG45tz6dN5bxpBW1r4rBBKfRa5Qf0luV8lIondk+SmI9H
         CxXf92Odmmfx+inLJz8fO4QqO3AVN/sWcF75yNvlPYIhB248uSQnvblabhcmAA4Oamem
         2bfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757303425; x=1757908225;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JcU7raKB0xaPr1u3hysKEvXRC7PvlwZV/t+nAxbL6oA=;
        b=Nu8Enkb0EqGXeiQkV/JjF3lFAjsaXetKC3C/sCYqQ0+2Dmnch60ocj0rcgT2SuBGVU
         y74cOVuF/KSy/f0nj6nqC+EhSwttyEB/oFt67MgmaTZgWJGa34YU3zT/qIFWqiu2Gzaq
         E2kqt7uHQJJ8PHPu/0dXQbJWGlqQ33ipymNIrsXRIfGo6b8ILZKsOQMg5+eYtGq9i7zY
         ByLZWqGPvd5yip2RbJkRvFXrsWszbv+WUtMcaakQWsxEJYb49MeMxxoyjhR1QIznzx8h
         AjI5dUpUk07VDerD0KVgqXDeP4/3HPcv1Rr2Qj+hGDfPUgDtM3qpan5VgW7XOPFM6yzY
         fphQ==
X-Gm-Message-State: AOJu0YxelOxDiStFoTupPQ0wPQoTtlhWWvQSyJTzCThGDBV6NuhQRwAw
	huoWZAGuW0ScTIE8Ok6MSXe2ZyidpI7gQ7GoS+1moazNgIXWnJdFIIlz
X-Gm-Gg: ASbGnct4Ynp4kABneYugmwy7fHV5/sck6le/OsEc6OsKmueTWPh53Ma5iyaLsQXkyPO
	I49I1MsBuk9sOrSCy7Ld0W+zXPfrMFA9gHySgIwyE1KjzDqaQObovgKdaB0NNG9lk70Typ0EL5t
	YKhsH1OBQ9F2rv6ZHdME1zMbfHgIBZSLwEfRjNvwkgI+Pj4enGPTbD1TMeX/2DuuYmGUnKUfw6D
	7stZdRhT148oCAqIqlKVs2wElFxVNDtA+iyvbX8oMIM1csikNiRJqmnSUwc2dQQpXhXMXe1cQkj
	SdLST0Ey+3oolIjlanJA7WjOeGP147ZT7GrYF2CbG7kgdZ3PJMlqPAI0u6Up3WS7lpZb4svBUC2
	jO8m9vxB0ULGp4bpfw3gqI9tuxZIwlSKfmBUYphsHFLDOQ1FYc2vasamGDowiaSuVf6LzeWmsNs
	Q=
X-Google-Smtp-Source: AGHT+IE7aI8NDiO3dLx8ia+TD+Op2GcTZb4D3WGE/zuPERgoRDXMR/mu8A35BvvWsNINZhsClG1D/g==
X-Received: by 2002:a17:903:b0e:b0:24c:bc02:78a1 with SMTP id d9443c01a7336-2516ce602e1mr82931435ad.2.1757303424837;
        Sun, 07 Sep 2025 20:50:24 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24cb34e9783sm111548785ad.50.2025.09.07.20.50.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Sep 2025 20:50:24 -0700 (PDT)
Message-ID: <2a8e98fd-2904-4cd8-9571-d73484618cb4@gmail.com>
Date: Sun, 7 Sep 2025 20:50:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/183] 6.16.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250907195615.802693401@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/7/2025 12:57 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
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

