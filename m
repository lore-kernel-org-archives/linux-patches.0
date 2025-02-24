Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D9A24394F
	for <patches@lists.linux.dev>; Mon, 24 Feb 2025 18:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740421346; cv=none; b=sEKiWwmMbJXpSoNeRAfRIEm1IGhA5+z9ler0Xvj3z7SYL/lxthHm9K/DZts6tPUZkn92VW//BbL0u1AfLeLzpDOWqDyGkk4UVMOXYfarSmavwNI9HR26fqpoejwQeibmUyaWEna3lcmg68EDfQJ1cKIvMpn/eVTvQl9+EGgGLbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740421346; c=relaxed/simple;
	bh=naeVgrzsbRbKEcFwVbhDb2hcvAba94hy6j1nys2AWcE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U7vqhpRd5uyqcM1xQ3CJ4/y14d+H3xcQqg5G4ZgcVxZbE0IKiPyMoLildWHEUZWfZ3Fba3nPTuR6HKksZBUMHrjCdpo6JoXf07CaVstJM5mAkWaZMs9uhmWmh2xPW9xzE5sfUXR2D/onxXRyS9PXuRAl+dtzP/39fjNQpZQ/oSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ksWL88Ki; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ksWL88Ki"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-727295a84c3so1280349a34.3
        for <patches@lists.linux.dev>; Mon, 24 Feb 2025 10:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740421343; x=1741026143; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UdKEHmyMd5H47y39cmettl3IA1fNENE9xIH3vBcrpPQ=;
        b=ksWL88Ki9ihcPGaES/cgVf7ll4ZAWjgaic/+Qa00XXHTJoEh/an9yI/g2FDd75fCb4
         lnOXR511f/Eqz0LOiKP1ctvOim/3qphvhEuBVAs7ftynoSkRlfgnGpRPHHIucPO/bbo/
         Uni6p0JvB7esxCn+9kA2Gf2b8kpY4hAK+Hf8yZcdRuxcj3EYyvX9neXvMttBEXgZajB4
         Gvy3PKiLFXRGi609L7rEa1fgMG8ErCde23Vskik7xSo+iRMgis72Sbjo9hqv/WmaDjCD
         3/xk8ayq/IBtix+ov4vkTQ3j+qqn7ISEnJ4pch3fZvsewzYuuMnSt/FXC/xkEYviBac3
         4rcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740421343; x=1741026143;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UdKEHmyMd5H47y39cmettl3IA1fNENE9xIH3vBcrpPQ=;
        b=RojH5Emz4ha4N6zgLihfxhr5Kk576ZX531L02vImTAiQmuiYPUiaHFDVbEPi5w+b44
         tZSCmLcJz2Yn/6PTiR5VznYSpx97f95Kxu9sbq3xC9PO+u/zaGtS5XkATvYA/vxxgUCI
         T0deuUqAcy/MP34dCZEtA9GEs4hg/lGfTzbNZsPWILUMm2JDi3wqAkAiuWPY/OqQavak
         UYCrvHZtqwFnWpxlgzZauFnv2BGT5YmwYIsGbVNuakRWmiJgm3B2feor4hpW65Zy8K4X
         1wVK8gD51pIZ1+dezsSnQvMXTltIBi48Dmrrt85hRhf9p9AwEcmP6X3zlF0XYpgvN1J7
         zSfA==
X-Gm-Message-State: AOJu0Yx4k9i2m6Si0SawhLbIKsrodXej7W4rHiA4eGNgIZPx4cHkkKVV
	0shxuyzKUw/OLqeaGKd4A2i4J2YP4qpfy4P5CtmnTxyGVzhHHPfm
X-Gm-Gg: ASbGncsG+NFTIJ+80agcZIF1uguOmmBjeH3xDIlNPF1j2nK42h2bpqPeaGNfSmHVHtp
	84EttPBEGBIfnIdVcjLQm80DNAqd00Md+l4SlckbxjbcaZ69vvY2ZKNqeKSbedZI/srTOMc7YKI
	v8x4vs5QfZwn5cStZFWA9QVNyCqwUXp2v8THcGu/AVjCiY1KDS5F6a/zsE0Gp+ewM/uB13HZiQr
	DVCNLGCeXdRMLNR8tmVcbnmGsAk1Vniw4D/1sfgKnaIQJO1noWWm9r7I4Tma+OIClXijn3ZhOXR
	kRYrFzoC8uUPGhRLR+c+zN6SB1DSsouxJqhznT/m9Q==
X-Google-Smtp-Source: AGHT+IE8yA1C9t9rSYbPuuyP8P6ehNeV+szdw5a8Yk0mho2cX/JB4I9hh8GU6Uw/l0HXkhoC4wvt/Q==
X-Received: by 2002:a05:6830:2b14:b0:727:38a3:8a63 with SMTP id 46e09a7af769-7289d15ad9dmr257289a34.21.1740421343508;
        Mon, 24 Feb 2025 10:22:23 -0800 (PST)
Received: from [192.168.99.86] ([216.14.52.203])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7273b0d30f7sm2332167a34.59.2025.02.24.10.22.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 10:22:22 -0800 (PST)
Message-ID: <226b50e8-0e17-4842-b2f0-c8c84d59177f@gmail.com>
Date: Mon, 24 Feb 2025 10:22:21 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/138] 6.13.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250224142604.442289573@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/24/2025 6:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.5 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Feb 2025 14:25:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: FLorian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

