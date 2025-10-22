Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B0317A309
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 02:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761101307; cv=none; b=Jc7JyHv4G7ujHhDi7PBPxFRh6vThshRsh+n7NPxLeZVWm57bv6MwnbPNzsp76/AB4KSxK11EeNGjM2M4vJl0Z1Bofs41enEZshv9tf6884EhDbdVxxO1n+SFMs0cahzRBkODMFcqaYkqROllHRER09K2NMch547w4PabKIIarfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761101307; c=relaxed/simple;
	bh=2ihbmTG7aYO6isgKBBo12eNmNVhYXXQhMaLYdKlUogE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pFtUeb5FXZPVWGZUtioQgZvbJKvBSpYgIOa08/YPyWBWx8hM3K6VMEM7ivCUVszNwDCotuRwW3u7M+hOCNyNIz3bYGv4jOD4N4unr0HXfCTW+3Brri3yEo2EmYb/Vl5p7FTin/x2PD+wOD2C2xTkHI6/9ZHhNVbhDVJH2PHz9tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WYh5exYn; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WYh5exYn"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-33bda2306c5so5034840a91.0
        for <patches@lists.linux.dev>; Tue, 21 Oct 2025 19:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761101305; x=1761706105; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fb9NiUGusZmP2HxYoohhNZQ3pvpdldxDNGCkCdvFaz8=;
        b=WYh5exYnbvOqR8ZHU8RcNr7g8xhZrya5HHRhICHAUOJgz7ORtITbkAXhMJUyQH7aPS
         5VmDCKHUvwATP7WcQJBbE3SG1Sf5rPAm7xblDJIZ76qJIaMRyTqsEHwcNKaPzWrQEmuq
         8OzKE54YUIVMMWNSX0xWWtS7tULtT8zzRqr7D5Zas3w66wg4Un7362FuQeI20vY/OB9q
         CFF67/juWlK4nb8L60L1HCVwO7V6AG3sZKCFndBIY6xGtJB3dMvreZ7Gg5//x8kqUX6z
         QCpc2YqLwOlL2lb0w8wNvERfGr6HKYfGWnCtsVvBzL89JRfxQarkXiBKltcQeOKVwoEZ
         WKKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761101305; x=1761706105;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fb9NiUGusZmP2HxYoohhNZQ3pvpdldxDNGCkCdvFaz8=;
        b=LehwG97Vq4GFMzN0iqI8SK+pHyr8vRJonIgeNLvjOR/yXu0xqDbVGK91bmg83Zrgtj
         sDSY8BM00FQZYHDg1FJ0sOzTmhUKHRlFklNi9/B8QqqgGOalx8Y3B2FPozrk/QFiM5aZ
         6bnWuZGbq/aPRLVhy6vxIxZac8RusCvlr24qK14DBp19P1YR5zIyoEmlDpXP6PInQco6
         AgLeYC3Vaz+I9FYX1m5tjiUmywBaLNQaYvO9poucyfN93iInnRiA2jfkP9u+NW1Xk3nA
         5+6Ol+jx84rXBtIVHRzXxK/2rr9d4DHGPj7k8QB4ur8LT7LaG4uUYdWugGaJcvvOA0IM
         cT7g==
X-Gm-Message-State: AOJu0Yw2dHyiz9Lcg06EEHlSAVwgosugKM4D7VQQCy1kYmu8di5YhOvr
	JDKK8+U8xHziXjGfN368a0O6LOXzg0kbbhfeesDU4oSAUDk7gawwDis9
X-Gm-Gg: ASbGncveYACT8xG0h/59q42p0vzUjJP9u9mZOtlB3Psa+Ceomuz+SF9iIQfueqVBG/t
	w0jrUKTI/uZAx9elR0axYISkN5PQKHk3N/tejFv5TyEKIOOoEiyQ+xgt1u7PcZd8cDUt5uE3O9f
	SiYBrAfiQSLeq7NuycTYfMfYSBwmnH4PAwifvkk21R6t2WPKjpxsqb5GAEDh4IwxivUS1C76Wy5
	qHVXMwI+81Bx6yScyxolxCE6B7YaKpqckBC48U4ZKqIURYJLax1xA4H298rp34OfQLbadX/iBST
	HUcu3DpJqkGkmvXNjgGI6IC8picWK0FS+4XXMhd1BDrQIT05ONjH6/XJgTuw47P9aVtopgrxgGd
	xWLB6MkTvFPz7bLKbpN66iZDKXFQ4seX87jXkG7M5IoYuQL2PQPhxGPR8PRl8GWSpWDugCg9u2z
	W8xftzaSGxRNfwiuP5SFJDY6Fooq4N87wyOXlfcX56xqWc/9DU0x+H
X-Google-Smtp-Source: AGHT+IHUH6QgXerzHyeX4iRldiExQDI3lqMQbQ+JkPENI4w+BBTAZQF3J02Ulp34lZmp62c/SVXYMg==
X-Received: by 2002:a17:90b:510d:b0:330:797a:f4ea with SMTP id 98e67ed59e1d1-33bcf9090dcmr21211755a91.29.1761101305056;
        Tue, 21 Oct 2025 19:48:25 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33e222d8652sm1010138a91.0.2025.10.21.19.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 19:48:24 -0700 (PDT)
Message-ID: <9e2eadbf-f380-443e-84e7-53590ee54f2d@gmail.com>
Date: Tue, 21 Oct 2025 19:48:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/159] 6.17.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251021195043.182511864@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/21/2025 12:49 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Oct 2025 19:49:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.5-rc1.gz
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

