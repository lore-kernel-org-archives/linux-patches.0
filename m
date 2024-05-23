Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8002086AFA
	for <patches@lists.linux.dev>; Thu, 23 May 2024 20:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716497641; cv=none; b=BRVQ0btAyJ7/m8UFJDd0k4yiT2SFJkC9l4XiyI3S+njC8+rIpnZOX8o+rf2+rgHwmwnp6jA4EkOOvjRzZdpseXUI8iljczACtH2vo4Jag+9hbFHXTFx/nkWoMNGW/EDbYbweKRMeYYEnIujDEq/CfyCIxRjm/BboGFsICGtpfG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716497641; c=relaxed/simple;
	bh=pjdVD0Ey758EwjNxbZg5v0ciiT64t0TzFMxkXUAipvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bcxczEuMh4252sN+qgiXvVrJPFURpwaaH49vIAZ54ArGO6PCaWoZxRiqilvH9vfSgZPuTyv8z0MznwLAK44HiVYg/OATgGavqqVP6N1hpC1kjPK5LeCXjrbCWfxf7iCXq/uevCIh40uX6nz+TQI8oyEtP5jJshxfEm8wMG7ycJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F7f3ZiLv; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F7f3ZiLv"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6f6765226d0so2684773b3a.3
        for <patches@lists.linux.dev>; Thu, 23 May 2024 13:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716497640; x=1717102440; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u3tHKSSpqdK97uiyWkm/Md0YuI2Y3keaW8/UuVa/Zik=;
        b=F7f3ZiLvkS7OTbBsWirm8QpzcS9Ndo3ytCLcCD6rT1hf5q8oI71fFoaqT6azoAnAKV
         rlzdXK5WvxkvYZRxsuWY6vPcVI7Qmbm1cCXDehfcygN1VRZswR7GcAVHRCqfkzztQzEF
         rRjkKacSGjrf+4qABjQpFSvRoRSlQ6kg94llFu+cc4In7U5VKGprBk/W+7nzLyh9mjXP
         2W8xTahKZ/psJwDheQo632TtjL5wYjzqCIO5AWs3xj5RTOuOF9NMnVILy2seLLt/P54U
         D20Pkx8WwjaaolYx7rksgvd58FBj4GA++cCg2N0XL0AkTzeHcTBzY3MWyTDLZ9bqo2HY
         52Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716497640; x=1717102440;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u3tHKSSpqdK97uiyWkm/Md0YuI2Y3keaW8/UuVa/Zik=;
        b=CPEv/Jl8lcBlqnIK0U80aenzNx2svniHkuTUqXUxMv/78V24Mycz853q4aCoRhpix4
         UeAjcnGpe09bFxl4TqCB0WCHsYn4K80Jgvjlt7HFtnedhNiM+SQ9RUwV+BSkZlgPceBz
         vqCKkfi6DdJI/9pGwqhMlQdyKIN55TtMvd9Qwa7NKmuBdCNCKrtF0B4KdJ6fXwmULRtw
         RrXlBJQ/5m/tiq4No5c+Omxji5DGR/5KAOf7b5lrGW7Uo/6hGLv3HPhroJE8jCVaWGZ/
         WE0WFaD3HgzYyTziNmNRAyjaVJ8VaO9GQd/bkXHfM2jWGvISwv0iszJFX4Lpo+NNGoTj
         6hrg==
X-Gm-Message-State: AOJu0YzyPmg39cyxS46SJ2U7vrQD5AyusMonDEblsHKFh6vadwNgG8wF
	12/rpHjTqKeI7m4dh0UpPfgMj7MNHNbDlBHC7qzDlO2/3WZRvQLf
X-Google-Smtp-Source: AGHT+IHC97JOkbVLBmEFdPLulQZYGm7jf3Alvz+hlXanilKWbJ7JVA2WMR+URu6hZudYtfCu7PbVYw==
X-Received: by 2002:a05:6a21:168e:b0:1af:fff9:30dd with SMTP id adf61e73a8af0-1b212d42ef1mr804825637.35.1716497639884;
        Thu, 23 May 2024 13:53:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-6f8fcbeb973sm40251b3a.117.2024.05.23.13.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 13:53:59 -0700 (PDT)
Message-ID: <15e80061-6e8e-4845-b377-e13dbaaa37bc@gmail.com>
Date: Thu, 23 May 2024 13:53:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 00/23] 6.8.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240523130329.745905823@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 06:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.11 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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

