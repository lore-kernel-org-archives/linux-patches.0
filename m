Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5C433EB02
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 16:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761668444; cv=none; b=Zmm9LYHJ5lmFyIAjNDNvKopPJTjWNxECoqlzF/5PYCucweCGPXmVCm3xtatPaVAM7GqI79id5EsyXMasB97SblG2p/086HdmrOao8IqPkwGBNZ1cndoQXiWtR1+8Ml03bLYCAcJEEWbzUU3wyqSw27sRfJpxfd+3w0oEpgNJEyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761668444; c=relaxed/simple;
	bh=HH99Hm1/4ME4y2NVT7mTUovpgSko9sHLYoPoc4qGOcY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qm7X2fPL9MlTs/pgCG/XEtF5PJsLvk0wwfrOmyvPgG7k0kmHUpKcQgFmRRFcWE5P4ScapNIJ70+bwTf8LAUGwd1Oe0tBvxsNl94kRR4k6PVdCeF/aBLEREOY+vRXEq8sUO1ZJQAkBUMGC1gqNn3yfxI+QMLrCNKJwG3VMgMXick=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OX4N3D34; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OX4N3D34"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-88f2b29b651so630162085a.0
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 09:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761668441; x=1762273241; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yBw19L+zHPRR+YuRqFX7epI1wOiSjzP6L9/PKbP4WH0=;
        b=OX4N3D34H+Z3CpRPY45494iWzsPyJUA+hhdaxmyaYqbnCoAiGuwfHVfl+l5pbiRFiY
         Xuz8tUnGrdSVrijYOMzKSpVEZDxI/itCWbgvlnmA+nVjTc2Lrx1dVECA/kMu+o3OTrL0
         o3tFangOV5alNMEvSV64sf4sZlPAlVDaZc3lk02rFBJy0B55eqAVCAf6JjE9nsU0wEY2
         tKZosvd5kieg1dlI/cukhYFfrU7i4loPcBsMXPV/heA/TL27SFSnOUWnrBOkOKZFf2Ju
         ++30JPOSlmMDVg0HDWoZdU/BFk0xwlgVrfvzrNVgR661AAPGTkb65OhbXEJA90VhudTr
         UHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761668441; x=1762273241;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yBw19L+zHPRR+YuRqFX7epI1wOiSjzP6L9/PKbP4WH0=;
        b=EEN0yuegqXhNqfo798mSQMeCLf9tRV7Bm7q7K1T8e951Oe65DAbegbXjhCmnP1fwaG
         53dPl5Ro1GuN7SkCRJN3uQ5cwMG1uRHxkBjsjGjJ4fw5Q4LbYljohq+IurwvpRLv5T7T
         yFnao8JQQ+lIJssoINH2FJPeu9aRplSHlx4LjQeX7IZwihpZhFD5s4MJ4NK7kqdOBVqb
         /Zi8pK/rxe99mVk4CVrpRQs53wTz3DJpH/Vat1VXHpv3QlQYI7sPoNhByze1sWSv9eLR
         Uvo9WDk9xKp75OnlWZmeWmKDPESBqW+Uok88sSPJ7dNnPunSyLMCv5lL4LyVypcq2PEC
         eTEQ==
X-Gm-Message-State: AOJu0YyXVpMl8UoFA//f6brL1ZPB4MRCWI+xLrmcYtYLNy1BYDy3ZKEG
	/AyFOjjFba4mWoQzILbLsF+MD8UBzrWEh0LmzllGcQGeBoNH03Zd2m0V
X-Gm-Gg: ASbGncvWkv5jA02kFUvzRa2fD18yzlcUuYNMDqu7ZHcLvA/UqJBWYeXTSZQZHnzkuzF
	y9q0D3zBmPm1AdfEHxz5I2/OPT7j1BXTjgj3XK7v+Tax/DBCLzHyAAhGcYphMfAiopbOLZBGE/J
	qchP/rtUERrm0iApSP+4zIr/9VV0PVscNr952n6njJ8d5+6d0+Hi4FwpGlYuupDo8M/dpGvzRFa
	fjCFqfmt1yCggay6vrGmTaitQCZkQ5N5adxwpogIBTDHu0i/J0zqaSPR0yBpz1HBCPMAmx0uhnK
	ma0H8X491ASZ7Owsf8FTy/jj8i05lKJbh43UiGPqMWmB2zNQwl4wBtJxX6kvpjViXf5WnfJprUm
	3o7yEKLoygALWrTUWL0KQ0xNtl8A9Dpx+P4tdS5bVh/Ds+Tua3aajGUJuuXlBT8sIwFVadi7Vbc
	taCmLNyJW277h4kJ7N+2KW09TmqZI=
X-Google-Smtp-Source: AGHT+IFiY7niBCsgWr+WrtN943Z11lRxWOW9j3KP33GiWaN6m/57e17SHj2oKDJ2x2+uveoFhStVnQ==
X-Received: by 2002:a05:620a:4052:b0:8a4:19a:dd5e with SMTP id af79cd13be357-8a7008e05a6mr507815685a.68.1761668441025;
        Tue, 28 Oct 2025 09:20:41 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f25798ad0sm838599385a.36.2025.10.28.09.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 09:20:39 -0700 (PDT)
Message-ID: <f978f5e5-5828-4556-a9d7-1f8df8bc16e0@gmail.com>
Date: Tue, 28 Oct 2025 09:20:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/325] 5.10.246-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251028092846.265406861@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251028092846.265406861@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/25 02:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.246 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Oct 2025 09:28:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.246-rc2.gz
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
