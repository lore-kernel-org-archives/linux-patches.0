Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24081DED5B
	for <patches@lists.linux.dev>; Mon, 10 Mar 2025 20:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741639287; cv=none; b=RIPr/Ipkf0g4GA74WmEnGzsfserOnrJ6bYmZXl6jZHbfzxr0A4Y/Gyub4GnPFyVsJaaVrRh+P9ENpF469vULt7JUCl91mYODTjyjcl85qjlzMspdbXjTpMZjVKwJAAQWr+t9T1KNJBTtWXDdTHXBNZS1E0gbhLuAaUnB55hSrR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741639287; c=relaxed/simple;
	bh=iOFeGEkeYwKNw3YjGLa4PAADjkpOns1puKEPrbXm/R0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=evefkxUuTyWDB1ZpkDz9dM3t5lnvtZGnFob3Df+PDyauCeFiv4c8wMwwNmWW4rzk56OO/vx3w/s8M/t9935+66eWI6+SCGP8h1Ov7YF8aCIiRWukYPYej5GYLeNjW4RbMHUiRIuNYtsPztGnu/kS4y9mPRRXR2pEzPNHKtRZVZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CGfESV2G; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CGfESV2G"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7272cc739f7so3133539a34.1
        for <patches@lists.linux.dev>; Mon, 10 Mar 2025 13:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741639285; x=1742244085; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Gt8lLeNOphLGI2TA8iOt/B8rG8B3lX/1L2wm03BOc/Y=;
        b=CGfESV2GXU/skSFRvJXKik58OIwRHHegOHNJQqelYWQ6O53pFlMxZS/5KQuGf4d9kR
         jAKjIZynV8sO7498UZe3w2GmIj2sm1pMIZxjRi+Fba0H8Z7sBUcsxAibWy7r/1Gb4xIz
         SA/2coKXTTVORuSRWwbGh02WxIUp34OUv2/DsVIOm6Qn6+henzniySJW0fdEMLGg19RT
         c7OjCUwaSm9Gfj8g0n1IObn90mXs98SrisAW6wYx498FEN9hJalswdR8kmlJ67ZyqQKO
         Ma0eQJWfO2tHxin5cwNaZzJXJu+48HYUJGfdjOahn4Wtte9HHa8K2NoyMuAUPmkTsFmc
         9uEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741639285; x=1742244085;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gt8lLeNOphLGI2TA8iOt/B8rG8B3lX/1L2wm03BOc/Y=;
        b=we8doHWvcTV6EoQfXLfUU1amvAi6n+ujpMf7wAMYNL0wXLVUE2aJx5hadsOLOyyGmd
         itgGutkNsJPxYeXLWYSAo5RaOz9Cnw/rXbaolCca1bdqo3kp3p/zbSDjVSnzSzfqINZj
         KA3qYSFZtB5GDvVuxMoYxaiSP6U0YMZ7p0sgLjklubV47v0FhuubP9Y+6A/9xafcEcTk
         Um8W622YDfR4ZmUCzi/qS7x575UPhlLGmBQmZUwjYPXU1M+WP/bPUFlDM2AokSE0pNxs
         MGx0xb0L74/qXbbWevun/qYjudjayssy94+K2Tyo5uu3WQLpodPWQxsidGRrS3sIqpQQ
         g8Nw==
X-Gm-Message-State: AOJu0YwvKVMnT+pHRFIRRQ6svWIfYLbYqkBceY/FUras+qzUpbbab1Rw
	MmC25tt8Im/Cy4s+sa4FT5Ud6s867oww+4CaIsKWhdGA+8CNlyOd
X-Gm-Gg: ASbGncvDR/3fXAxJex36UkA3/JiwwHXULNH7cZ8HcwnZq2c6vIo7tyo/bxZcZV7j+xF
	WDQzx2uLNZu488PkwASC6uNKiurR4HoT4Vu5gLjhUJXitffwWoedGFY7LABHhXRxATdb2/jXc6K
	F8lkBHfsZNi7UyIhb8HABTXlXJoBOPl4S7X6yehz8R3TlKTduWMqy/6cXGjBKnD62zROOpoL+FL
	ZKdk1Z4KgaWhzcdzzqA3ct1YT3o/W5eV9U6r7Wrwyfekez+tNjvooyJFzAYjXBJeOq/CK5NPAUI
	pUv8wPw1sibmarNCzE7zhFWKNOY2xj3qqF7WvFGSf9M17GiIJkic3pWZVf31oV+aoXCTyYYJ
X-Google-Smtp-Source: AGHT+IH9Pa17O3DgN1ZWzumsrv6i27njbnYFEjZVmLWI+Bck5mchL4HicXMwOe+/QWv/1Ky6N1hX7Q==
X-Received: by 2002:a9d:5385:0:b0:72b:2513:ad54 with SMTP id 46e09a7af769-72b9b73e937mr570131a34.10.1741639284767;
        Mon, 10 Mar 2025 13:41:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2c248d5ad7bsm2305532fac.34.2025.03.10.13.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 13:41:23 -0700 (PDT)
Message-ID: <c7719f5b-b56a-4f6f-93d3-18c46f713a00@gmail.com>
Date: Mon, 10 Mar 2025 13:41:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/620] 5.15.179-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250310170545.553361750@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/25 09:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.179 release.
> There are 620 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.179-rc1.gz
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
