Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B35643CE78
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784740677; cv=none; b=UJuv8dXs/ckzOvg/jnROchz0x+m6RmDdTRyjaBUBri6YQjd5dC1QPVihnvj8aIMUYyh+uImh2b1fqX4vSQH+TaLrhGO/+CvhvP5qFxcCIuKxUWB/D2hDuduBjsAitJZ2EzPp5hiuUY+O7rTazZGaS/Yb6DG+vuW2VQ6o0gBjgvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784740677; c=relaxed/simple;
	bh=yBog/2jRFIDxukHm/5g7WlFhjk9IVCUZ4sxIuyNdUCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C6DZI7DJlLp96WLlXVaPpaWiVuq15Z3t/gULl+Rt7UMwBA3h1gSSbCzAjFSlZq8+cEn/S0lNTiOZMhdeCnvvMI9b9dGhmmge2esuHR8JclI4CA/auz3lw4U7BURg87sBuzqGv9OWxoKmzlXIiDg1BE2grWGf2+qobkO+38lIfNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s5gnft63; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s5gnft63"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c0c68aa31so94100251cf.3
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 10:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784740674; x=1785345474; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kSNy5VOSaYTtujmoWy320tYz+BN9oHmew4YUUk1LVBo=;
        b=s5gnft630G148Uis211mJF0mEu8xL/NEwbQKSuQlTzlJysVaum/jg32wePGL+kp7WT
         tODvpU8ZQ98p2CqCZlZ6CLa70wyvMWWoifPz5ydYlvlx+IjDDLp70xBrZq7GAJfJRyeB
         88fdITQQz8mUcR+bygX/cCIbNfhRbUBE5TRRgmImFmdhRHnLBDY4dzkABvnq4ZMx+I1+
         XlD2RkJwy3I/SisYJd8/XsOz60QrK7uv9xzQ8pUIWiehsMXEYb1x2hJkgPkZhuzALZAf
         d6BVVfwdKZZjDLYRYNgrrYYiuK/ePfmeCXjv9gsyZA1ws2YDHloOI5jTlXrb4ih7wqXS
         wQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784740674; x=1785345474;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kSNy5VOSaYTtujmoWy320tYz+BN9oHmew4YUUk1LVBo=;
        b=pifiYVKiv4P5acMng3kPazqez2I4wW5gskrN/IbB9s2oHPGzWmPJYbBUEk8KIsdpwk
         FyqMKtnVSHjuIp2TRq9T0rs3DAgnG4QqOk/4GD8MNvwIBTY2TQlJEF1Q82LAX6oC3M32
         7VRetuDmIzY6DY1nrBiyHHekPzvmW++82wcXL7cjK7umrYRhclAVjPUNk5szwit4eRT1
         Lt/s39o5gBV9ZOsJOgcPWDDjj0EEazz/0k8hV79yIJsZTcwFLA3IFZLGHbwtuEseInW+
         oNxq5RY/WbiUKYFFPaNhCcP+To/yjFlQvXDJ8vG8A6IID2a8zOf6z/dakgVDbZ7YVylX
         eOfw==
X-Gm-Message-State: AOJu0Yyi2atmu8CxXyEhNlJZskwyGKBf9li8hgJ0KCqcRUmpkBRIgI/7
	fnSkVDvXApox0Km5wTfCxmX6C5BSqYva44OY4neV/PjsxPRIxVcmQjgq
X-Gm-Gg: AR+sD11SPdhvEHPtEDw4ucbgRWbyMya0oSH8GCQHXhvdYrE+3jXJfWsePEyf2OlgPSm
	NkB6VJAA9Hh7nfvHqgwLp2ez1yKBJwyn9vF/wvwLMEy3tlS6fu7RpIqRtAZhfxPehDGi0Zda19k
	YMuiFzj25OST9fuNoC1UVcQRPDON3DzAFqFPw9QR7ROXqY+zz9lVZFQap79cAXUPK/VM7cxCZWC
	fLz1e8Cl4dadR53CT7kDda9A+6ftSexXlKEgSUMpWN5HIQcnVnGNY/OGfUkL3hu4EyEIzgvbgUJ
	1p/NXMmgo9ORK4HwKtdnDzuQXTaZxp1smO9zFPFXvfMEUFSEKcjteL6yOacQ/gVykb66HekB2Ll
	vInrRLDFsyIiAGgGYkhAqSbAQGzWuYiiminkt4Kt0KIox2zd6iwvPLAM2f2uMt28ys7dBMrAdHA
	z/OXthKEBWuK17ktcDjGMY9+PQe3FP
X-Received: by 2002:ac8:7f8f:0:b0:51a:8c9b:649c with SMTP id d75a77b69052e-5213d0c5b54mr227513001cf.64.1784740674468;
        Wed, 22 Jul 2026 10:17:54 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-527d402cb05sm19671511cf.31.2026.07.22.10.17.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 10:17:51 -0700 (PDT)
Message-ID: <07004d68-6189-42af-8a56-686d0d46d532@gmail.com>
Date: Wed, 22 Jul 2026 10:17:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/674] 5.10.261-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260722142749.280611149@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260722142749.280611149@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/26 07:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.261 release.
> There are 674 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.261-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
