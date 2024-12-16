Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF91207A3E
	for <patches@lists.linux.dev>; Mon, 16 Dec 2024 16:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734366572; cv=none; b=t+/LPysQ5vTIU507/y5IcOPoURYBa+H57uLK/C7n8L1IkPR1X63l/SvVsYshXCNqMRTW0JdLrn7N80VDU0l8BfM7NO2/zIpbjhaJ6wOdXOcA1nVyET23VgL0YJEqwEq7Mh/T082Bs++OwWNrrtxeWIeW8HuhOoRYNyhNg63gI78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734366572; c=relaxed/simple;
	bh=3IgqwoNYpiR6zExU54Z7G93tBLU19c3FRBCun6uurE4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWh8d4srOttZpV7qf9d7aep2wB4v/vKbddzEuXOJprw/kgwXGfQkwVp7i0uOGVEbmtYqtraC/08TgOYM6CxQnZrCMRDgQ6nH5z02l6rEWPU26Uv1IRbXqrNTfdseQFwKpG6thJrc9vaqPeBNj3oRBlsZp1EbQ81V5Wd7aGqKPpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AvNV9HV8; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AvNV9HV8"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6d87ab49423so46131166d6.0
        for <patches@lists.linux.dev>; Mon, 16 Dec 2024 08:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734366570; x=1734971370; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IPu0EcOKfFbh2kllqSkRuNhepsvNsyULuW0PTLnpl+0=;
        b=AvNV9HV8U4e89+OHSPoxBTs0fqhtgrubDjEGjqKK7/Dlr0/3NAwpD+bHDcIT/h+OC5
         9LyMEG+xJz1W78twdYvyg0LO5oIbV4i4occSr2PVI0K4tADS8xbngmMN5JNCKLkYwwdD
         4kxA38inST4TKcyXE7GNAccYh+sNJlJW82DZJyoP2+3wI+/oqUn/BOYTwtimgAgWBQvV
         ykUUVtCa2SkEXCrs0SYXgBIj3mYrgVPW66rXMk34pMjA71aA7DEKFSQM6G/kE8C+37jU
         +F7gvsIexkEndKcMLaeEYyQkP50RHnKxyBIx05DZ8HOnh+5adQJiUHXzSYrygElAGXVo
         UD9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734366570; x=1734971370;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IPu0EcOKfFbh2kllqSkRuNhepsvNsyULuW0PTLnpl+0=;
        b=Kmb5YMM9aSAvt1OHruAq+rOnZGha0U1BvYiloAmDkVrfwv6N9LlOk3kOHioYR6pipz
         t8v+aWZvnw3FdWRTb3MKyHe+sv0zEPBqfaEjaE7TaqXaC0Ii8/vpFShP4DvYVfSYOaCD
         ZiyuYNsoK8KQbEUxJuUPg9/D3kFWET+RGkJ2q1VaEp9GmMIAAZM3oVrRKZOrkoAhu8P7
         Xt46ceRKNTUOEl0TMYv7//3EcH2UjwbvaTYnKgnIKCoEsZiu8t8kaI7mMiREf+v8I080
         RWjFm55WYGv3F+PyqLQHBv3jH3JRK6rG1I1ZDwOc7HZPyaBsLfXu8XMnAm59+NmCzHdF
         tWLQ==
X-Gm-Message-State: AOJu0YyHlvOdMhlrr1gceg2/SrmND983DmstyoiV9sdD6snLXHO5EHpM
	4vGdiwR8hE3yi0HW+Iw6mB5VEsBZFL58tfWHaPC6Gd6LCzsqv/86
X-Gm-Gg: ASbGncuucV07WygJIiK7aBKt/1xePambvW2uawPpjbfLIoZouimVL5/da6oz960k8xh
	fFHOqFwMW2ycuNsPxdSgpNnKpR9/d0MZzPywlmm36iEyWEAyEqJT7+OcA/cZa8WkXWr++Q9C3UL
	nN/FbF1Ps9/KnWaA8rBLaomRpblj2V6S7k80gA0fJ0UK21z6pZT53Cukxu90vkBNpibfahEUzbJ
	nvmU0+kDDM+sAaeTBKdVu1ZC89QqGKPy8AJ4FyKXPX7NekP3gEwO9wLdQc5I4MZCPiVDPro4nrs
	PXTgs+gvytNp/oBlYn8=
X-Google-Smtp-Source: AGHT+IFV8sPRfUhMtyh23vClNMX38LuCZ8JifAGK0CyBawV3sKJgg+OuHPfb+jmLwSAUZYZTLnLeFg==
X-Received: by 2002:a05:6214:623:b0:6d1:7433:3670 with SMTP id 6a1803df08f44-6dc8356d131mr210440206d6.4.1734366569883;
        Mon, 16 Dec 2024 08:29:29 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dccd26e45esm28844236d6.68.2024.12.16.08.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2024 08:29:28 -0800 (PST)
Message-ID: <4be52a15-b0d6-4b5b-8b76-795bc04461cf@gmail.com>
Date: Mon, 16 Dec 2024 08:29:26 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/316] 5.4.287-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241213145847.112340475@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20241213145847.112340475@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/13/2024 7:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.287 release.
> There are 316 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Dec 2024 14:57:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.287-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

