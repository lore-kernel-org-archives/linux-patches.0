Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99C61DFFD
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 18:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744224734; cv=none; b=QlOwHrnllP9A856gRtHDAlcLfB5nDIsxGEQ6GHT2gyJxEtL9/vNGczebiuJw62eLVRc6KyLPFmxJu8Otb4CyannLN2H/BEyomIIEVrnF+Oj+B5X0yU2KHE+KOhdQGjZzrH4bHWcOOBunUUUcbU2CLLYdWvD/Mc4E/831UE8Ef7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744224734; c=relaxed/simple;
	bh=UYddorqevsRwxFwmg1do08PnXxZnhargYzpzeVk9+Lo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CS2wEwnrngddft2oYdYn/nRsKpSDV/D7Mz1O22/jhpy8CJ/jBlFEKDEnsj2duA7af5Sjm2EmqzRCZg1AFt7KbkXZwVGegbuQcr6S272jJrLjZL3xyRLeOoto7xl7eHvrsKreqkMeQOuJ+GygilDc+fccD0vU+TgYZRk53dakpfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmSHabbl; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmSHabbl"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3f556b90790so2383185b6e.0
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 11:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1744224731; x=1744829531; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6GibFRXqwcx9teBdvxC1Ow1/QUI0XP30meo2aqGd17M=;
        b=UmSHabblNhk2Jd6TJ8xA+I07WaK/VFRmMCEXZG0Kb0yg26JXY2IcwiemgNcnUFnYc4
         2PhlIhObYyrYkC2OnPxnpppd+bhI1vFyM8553c/cu9CB21q9mkfq70zv2rxcqArpNA5C
         aTJEsecnXA4rBaWSo+MwfrZ/W21Z29xk/RxwU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744224731; x=1744829531;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6GibFRXqwcx9teBdvxC1Ow1/QUI0XP30meo2aqGd17M=;
        b=WakDmVHmlavHZsjRMu5xuixfBfoCYUgcWPRgca23bywJ9YUB67NrSdcPBDnl2sKmQX
         6miHZ46beEB5UMAxk6uSTMZZg5Y2ch9NQafBVIJeYDzUeYGmG10UaRcst5WX0M35E6Fx
         N8iT0JgwWb/6Sgb9/eG0Ga2igJtPYCdVwQlSl7hiZkgE7Fsyd/VFHniLxeN5YujeuUND
         DRD/sYzDGntpM5Msya79jTAUL2MTzDPNqVuNHds1ZC4zdm5OusmBXRlThgcRBGG47NaD
         9BTvitbvakPgleuS5xCXkqB0vPr0nL957WyNxMUIbAgajFfA3mHHNnyiw3DVVAishnaV
         6MEw==
X-Gm-Message-State: AOJu0YwVEiA0ARz+5iu9pSClv8XVMSRuHKveA59CCBhGiII3SnR68NRP
	8yYkiorGvQPF/2MnMifTuJIRKNoUPslSm9yz+npl0+/AKBGKny/qQwpPoT4qc1I=
X-Gm-Gg: ASbGncs2P41weKIvk96hv7B9BXH5C3Zec6mIYTD1RzXM6t3VerONMt3Nvd22Cq1m0mZ
	C/QAHy3UmDdQX3uYmqkvi5eJb0ixsk+p8d3NjWt/nqAL/MG+rTiS+pZd/t0e3ahKpgykWmi+YW+
	dIU/kGRlC/QBO4SEoaj26px9P9+6F1rUc2uEPLWkZBhtSuHHaocDL/qiCFNwOcHfaaQJM92OkZT
	ybO3XzrfGelviC4EEYUgeMYwcxiqlbVsknYlCvw/VzZoNUBEO8OtH1tnugVpxj2CI5wK3nokWsF
	Cn7ZfRaD4xxyZ9mBpwV04jozJ9zCh4TUlrWB1tY3aCOEPZ4LS1I=
X-Google-Smtp-Source: AGHT+IFoOWUYGnhxYrZFsDOJwhFDr8tTOXYJZckfR4G3iPbT4vRE7iwS/DWM3qg2w//4iHId28KWdA==
X-Received: by 2002:a05:6808:218f:b0:3f8:498c:9ef7 with SMTP id 5614622812f47-400740bf168mr1827591b6e.24.1744224730849;
        Wed, 09 Apr 2025 11:52:10 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-400762eb331sm254058b6e.29.2025.04.09.11.52.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 11:52:10 -0700 (PDT)
Message-ID: <c1b5c202-5899-4a2e-abc9-93bd4b17ac87@linuxfoundation.org>
Date: Wed, 9 Apr 2025 12:52:08 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/269] 6.6.87-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250409115840.028123334@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250409115840.028123334@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/25 06:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.87 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:58:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.87-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
