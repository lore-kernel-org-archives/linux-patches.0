Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E312DE1E5
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 17:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759512774; cv=none; b=b4ia3NhM3muoCzBS3KH7qj9IkabjLm2e5t3VSM61W9OyKcz3rmshYSYW5Gf7/xHHh6icLW4gu4GjvQppPL9q2G6xtOe7Cd1TCUxKYpslCsZGANM89C8V47pBPj2Tb8XP8/FaFQJkSFcD4dL9m6qsjASRG7bnDzFp6IWVTA7zv3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759512774; c=relaxed/simple;
	bh=/zWwxR7jnhgT3e053y0mBHqlR28r1nG7om/4xdmHk2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iHqHA7bxgNe6JE4TEnOdfALZNq+0q7PkNqY82IChffzctI9eO3K62YiOuvhL5xOUo3cTwuyE3R0MMii4XNeg/905o3CIy+05+dDFMEVE2Zs3NOQ7BIKDXBI3bDm/F5mvKNAw7IHe4XiHahOHm9UwVsZ7FVAC4L85AhDEFM1mfeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IsYQ95Oo; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IsYQ95Oo"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-27edcbbe7bfso35431475ad.0
        for <patches@lists.linux.dev>; Fri, 03 Oct 2025 10:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759512772; x=1760117572; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O3q3kNPw0ApKhnK7U/kRjsM4J9QuxzhyjRkD8O9PFXs=;
        b=IsYQ95Oox6ixW/NvqpnhhZUYPXe553Nd7fUcCf4G+aY9zZBwq7NghTKltF96BQIVl6
         ST4M2Nn0YGpcyCGULZvrGuxBYKwb5QzoqdXLaUVTMnhfseFW4WU+UI+SMW4Mfc14MKq8
         MFbEmIs3IpXdOaSc2NUx0auWyaTrdYzkTQ9qxNyOdX+VClMDpEfPQ31jBTsfPMCFY8Eo
         PVUaSb+k8KU1QKU0BFlaZoCKj51P5d76BYPCrhUfqTqwKUgoWXVZ+lctD6Ge4C64oVTd
         Uo4kNHEX5sduBU+xvx7nfemYhSj8VM37HYjyK0eVuiUBa8isC7kieKxdHjVpCnP6V68k
         FnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759512772; x=1760117572;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O3q3kNPw0ApKhnK7U/kRjsM4J9QuxzhyjRkD8O9PFXs=;
        b=UdWlKloCIacVlUb2gi376lYEWJeEmT+Itn8FXGBHUVh8iL/BVte1b7ShcgWslFQiLx
         B94rwvCOxr2tB6nYIOO0RiFQ1uO6p+rM8T0efXj2vxrdha5gUDm28LE6LwZFpT27LfLn
         iGVXzJxITISZK5pMpvuk2EHfkwA5nQvJV4zUdqAJhYmCQ9xejt4Mia96CtNi7bESn3H9
         Tesl7wHAygQrZgVPox4+3MzhrgWb4SnnL5ybSyVEZBX2q5cEuzfrg2dkwlBPJHUezbKF
         ZyUav/vLaCSInLDkZQ2eM4zlgGlzUn1ape1b6hnrRlmK+DXx9csW5EEoUymJ699KLjoG
         J9Eg==
X-Gm-Message-State: AOJu0YzuLS/uTmdzHDHOUjlgG4bvgq1/r8zvDOg63DHmBJBanrbTwcNa
	A/aHJYWvMegTbHDTASjB4RthImbrsq+PRrJfHUTCA15cfdFh4mWT8V7E
X-Gm-Gg: ASbGncvBwtNmkHd7tfwmU+Taw8T2R5mx52sjUNcrbTT6fwIM4gbwUgmoC30k84ixTD0
	6yap++RJOY0Wn/metUfbkMKSPaameJkE43L1JD+Cuh8xt5XfH4JxdH4wr7yeMlMsZF5yXG/o+x0
	ywpPOe1oFGvcEhTZYBZLDVpLkE7EJfYTZvVVr5E6k0hMQ90uxumsQmLVFbha0PPFzxE5Y5G1AGa
	nAMGD+/atzkIfDOrN2mGxZ2LbUiLbKbZxEWzdnAK9pHQT3uGGvFk9VhxwDcID03Uxdbgdjrjqym
	kEjJeZhFzuGCacDRHd5u5y590BwB6nN9BmIo0IU3Vs1cQw6v1xMFstBAKk1TdXdQhVFS9Nf9+BH
	qll9/rOaQ5UKRDB2W/gPi7HR6whiQiQJ2wRsP7K/ia/XhohNN1N8SVZ7zIEwx98hmC6tm0kRfkz
	ePeOHRZZgomAjR312b/sU4NJE=
X-Google-Smtp-Source: AGHT+IEhIeNN62AWq5uTx46AyDu8Fa0z9Vfz2iBvkwTa/pyPi6SOUcGwfQS72vWfZG0oq9oJ2p0Edg==
X-Received: by 2002:a17:903:120d:b0:27e:f201:ec90 with SMTP id d9443c01a7336-28e9a5ba9afmr46890745ad.25.1759512772366;
        Fri, 03 Oct 2025 10:32:52 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339c4a34f40sm2756054a91.17.2025.10.03.10.32.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Oct 2025 10:32:51 -0700 (PDT)
Message-ID: <08e96c76-f4ef-4504-b80a-9d474035b45d@gmail.com>
Date: Fri, 3 Oct 2025 10:32:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 00/14] 6.16.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251003160352.713189598@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251003160352.713189598@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/3/2025 9:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.11 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.11-rc1.gz
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

