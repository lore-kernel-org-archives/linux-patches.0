Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6813ED5A9
	for <patches@lists.linux.dev>; Fri, 29 May 2026 20:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780085971; cv=none; b=dzRoXQVQ3wRl4FgA6TINv1dOuMJm+sSOAdesYqmgWQGEjMaeM8kWBg8wPFpy8DI8CU0rKZc0QP6VBvnV1PB0HuS72gKWP9t2LRs5Zy6SoNqvXsHbxmA9FBDeb5qr7siJIitbgSrS8PNjfk8ESeRo0kdpS/7EMPUGUsHjR4Fgop8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780085971; c=relaxed/simple;
	bh=STzH8eny5uuaKC/00hnekg9WJ72mmM2AoVi3Zh4yXUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LmYvnxo6EMqzMzR2T3ZkvsU73x/qMELTAg+FmKLg903fdRGMW1i13hh1V93uZfuJRD77nxomhk92Ez2RZagAplGeVW+4tvdE2rGRz09BtV4e9EfZoJ5Xgt6A4BvR0gm4HcIhhWyM8kl/ZePPF/dnQr38l+Ind20W93Gqhn4S+Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WuG/0ezv; arc=none smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WuG/0ezv"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-137335bc3caso5911761c88.0
        for <patches@lists.linux.dev>; Fri, 29 May 2026 13:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780085969; x=1780690769; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FM5MWghC9sQ/5zvBJBTe/TB1mM92Y/a8Nl9pCm7IVVI=;
        b=WuG/0ezva2DQKFLpmaBcKy5B9pt1o4FtFnBSMkK/Ii5LHFcNoHa2f6zaNWdXGDMP62
         udCSyZI01r7E422x6z866qkCit9q1Vfz77JIlU+iPsBueYcNBxSUwnrES2suzbuw2hqO
         Y5mSHHE1jB4iuskfxsDTvpaQTZqgonBmEI2d5X5dJVzSNHr28s/FiDet6KQ6Hjv62GoX
         2p3ap3+7CRX+DtNJv3WbVUEyyBpxLiu/SDDZDKgvVdgMfbu7/DQki969AsW8IxbNVk2I
         gtFx2Mmp8tMGrPX7BpiJlZc3sOgb4iz2q2+V+DdWgET9/5vIQZShB1CuRcGxFpidDxwe
         YeDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780085969; x=1780690769;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FM5MWghC9sQ/5zvBJBTe/TB1mM92Y/a8Nl9pCm7IVVI=;
        b=LZ5jW0FRVp13fzn/4+KWrWh/8lB1HteVp6mwvi6hcBquIZn2ziH68LEufLYpm9unNf
         QbwpKy0UmGTtasji1tpmAkUmPrlzr1GN10B/XqPJZKyOoOoRYNPGL2iNtaCPftKh5/FC
         6QRGslEOEiiP8eeQdx8S1LOdUUmPOaPbySh5M7DplOKxGEqAM1ONYWWZ80qeAtZ9C4W1
         EksiZ5wgw6TR0ae1vfTn19SV4mUW0zogsqhK0LDQm1i0TPo9TfZn5xWl+QkRsw3tPSx8
         ME9wKDSZrAvIifuOsQb59hijGJGFnUYMxUpfMwOqomZKq/18ohn57thLyHbx1Q6mNcNO
         kShA==
X-Gm-Message-State: AOJu0YxB4IrPhpU+TsMRZxHJm3Ne/t3u8NlysyLfN5Jnz/fr0oAjPC7o
	0AJaeVwFMrMhSADKk3xEOyzBVQW11uvAudzwblROd9xRIPn0MgCtwQZy
X-Gm-Gg: Acq92OGxN6kjrM3pgGLZSF23ZTmwTe077PHgbTLQ2TRtXSzw07rJ+7tru8KqZIiQsu0
	MZtHRG5HqXTs5TYcly7jyKviA7k4R/Ju0r7mP1RJ+JyEhHNWRhssL802TVEWmrpMGuUM8L/GHi8
	e6RnUAAFeGm9aP9/OlxWPl8h4rGL92LNKPcc+e50ISYc4vBUjQRc3FHeGVMuzGyYIgGae7I5q4V
	a6QrrHUt4OWypfHATsyD29i7YDyVIsIgnBXFJMR8IKbHj2V6GUfHa3GyTCSNaC0axKRsIMzq7lq
	VsFE7ghXPjpCrUAls2mfaKf5yEsxe8gjEHrGJlxY5wqm8D/zlOCgmlbUe4Tq8Lkzqh+HIbxIr7J
	emjGscG/mubraupYTBmMgzPQXHrsmj3WqsCU4CK3vPaAc7znx2el9tjkXer3MI3UwAkLIBLkY2+
	qtcce44EQg3Pzz03sDsT0wcfieR43Ht40Rqq6tX3FF7MH2VJ4/9mMgtGABazDT
X-Received: by 2002:a05:7022:e24:b0:134:df4a:2821 with SMTP id a92af1059eb24-137d42a2f43mr622802c88.40.1780085968738;
        Fri, 29 May 2026 13:19:28 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137b3d8f839sm1706299c88.15.2026.05.29.13.19.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 13:19:28 -0700 (PDT)
Message-ID: <1c493242-3751-42ee-8ca5-b76608099bb8@gmail.com>
Date: Fri, 29 May 2026 13:19:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/461] 7.0.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260528194646.819809818@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/26 12:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.11 release.
> There are 461 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 30 May 2026 19:45:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
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
