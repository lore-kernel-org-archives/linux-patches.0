Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9394D30BB82
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 22:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768514704; cv=none; b=hdtX2MQAjnUAO0y563yVunpmJU9+hMeAsUGaiF5jokj8htn7+i2k00l+JaJp9IlhQXbC4zmzpJCi4VxPf7HuaONxek44PqqAQJjHWphfNBB31sDqQUlZ6ohw1qhLHbhTTZx7CKsaei9pqbB1KGAZDi8YeEcJmCHneLDPf7FRusc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768514704; c=relaxed/simple;
	bh=R0b8VCHSbkBtpdh8j5P0vV10qmB5MBVPUur32MQ3be0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e6w0yz3kNwE1GLHfsuxapmYBGGkn4Ul/NIDbP2Urjphh1HTUAdUyRWuKess4f4Fk9V/1ZCvVV93AVAuKWVNYML5zwFRFM/xJRf46L9XWAiL0BiEDlRfJ7d26SUlF4idoVac+w3f7DVofuvRY4rLxdfBlLr7VcCLZo5tN+CYbIZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gEyapPWj; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gEyapPWj"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-12336c0a8b6so2769291c88.1
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 14:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768514702; x=1769119502; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hMhG1LPQ13v4M6oficiJe15IjRoHXbIMZN4u43rTwMA=;
        b=gEyapPWj9EaRJ9GFCwxsF+Fci+h6Cvga2/ea+CprsZ1NDMuuNUdC+iJc4YAdWFZdfK
         u6EaJ1ErKPlPWVr3lqn3A9EA6IuwiNS8dOatDCBsENJSzY1EKAn2ieddV12D0Ix/2R86
         LyRxY5nq80DgzTCijc4lChOWOmJRWdiTKAEkZgHuwB/o6WE1m4mFJKwRdv0Wj0hYgVUz
         FOaWtJn/78g6Tgl7+OofECu2E/BdLX4KqJHD71KvTVGXvP3Du32n9vd9OdMO81Arpbz2
         KpYVqnxHq9E5iVQ1VTZoXNZ6NY1zjDLjEL3+XmFZlLreLab50H70iFqelredcaf03qJ7
         bJzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768514702; x=1769119502;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hMhG1LPQ13v4M6oficiJe15IjRoHXbIMZN4u43rTwMA=;
        b=RDUnQOw3EsGJF2X8odTn5DXtI7G7WYM6vsxAqjGKfmKo5TlQHuV3Qeao7OvMOUh375
         nKPi2BC0mBMKgHIX0hWFW7m4564Y4DfWfEao1s85sp798vtnFJpu+jxPdXaywwSFxE8X
         2CXbgzxMnvfdV46zI/gdSCJ/lGxtR+rbMXtMJdauRzge1foR8dgK9RvMLw3ypOCFlbB6
         BEoXolIzOiIdJ2Ugf1ucUp3CX4g1q57WB3H9n135hz5UZwPqe0m9ADIDf0W7y3dJQljL
         qZ+fbrVHrHk0fkWXtcDuUeUIaDVxDTB6VGsnSfjzZSPy+vniULdTD2khg/0N1w1LqX7A
         Tdmg==
X-Gm-Message-State: AOJu0YzEhJXnqUVz12JUTveTPENo9ue18dx2CHxw1Se28NUgMZkA8+dC
	Y+z+enY5l4c2OWXEKS+ymAPQcBapQBVfIleqNGpb2gHtSq0LjvakCJCJ
X-Gm-Gg: AY/fxX7hvc8oEw6fkIBRHhQxHNscXnAWjmmrXzywh6X2RWcy1ODH38v3pC2qRZL6XU9
	w/ZdHjDQtxwu/7fFunjhEF9SCi3mbJxeZZMt2m7HyebzJqWbjB080AuKd96lmPSLZjDAgz2SiL8
	q9Gc7v7Pve5M7I3Y2B4PTStVeLfzRNukKoATXJBnY9dgrHxkH5LAuKrEMEUBC3pLlHLoEuODec5
	FE6mf25Req+E4I3wD4qUZJMDTNoFZ9m1jkoj9DIISVXZlsjxxbJmf59yzrO88Jb24XaBI3SgGw5
	pjxGf1wm4/MV2RN3rsTlovGG+7HjwOL5Jbx2VINtbxCHx5NG3DFrMXWxBqdVKTjzrKasiqbWF3u
	vCpaGHsF1JB0ebmEbVpcXq/8XvJGlruyNd1QXFHO7c6z0fjUa+YQM2eoo2Q04l4cZOcm5497d8I
	6lBQJhB8RTUELp119itP5uest7gt1zqTtJkdQwlA==
X-Received: by 2002:a05:7022:4581:b0:11d:f464:5c97 with SMTP id a92af1059eb24-1244a769945mr1456056c88.39.1768514701546;
        Thu, 15 Jan 2026 14:05:01 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1244ac58140sm638426c88.4.2026.01.15.14.04.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 14:05:00 -0800 (PST)
Message-ID: <7945785e-93c0-468d-af89-94473c7f6186@gmail.com>
Date: Thu, 15 Jan 2026 14:04:58 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/554] 5.15.198-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260115164246.225995385@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 08:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.198 release.
> There are 554 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.198-rc1.gz
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
