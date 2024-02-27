Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545EF524BE
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 19:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709062053; cv=none; b=e4J6WMkcV9d807/Wtj13VDhY2JepDTKX7acxITPqU9HqrVfc4tQAPVz+mUcPB9IvSDwu0/juoOsdq2Too1Uueo85OojPjjy8lLxJMJS9TvH8pydVzE4SFV00YUq/Fx3grHjr8Wc0AzaP0LoS+cL+9V+VzylhKmaPChW9IcoQNVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709062053; c=relaxed/simple;
	bh=XrtQdVMbRSzYjsznNaecSFZDnk2DEQW08+pU7w7QjkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WbzPlCw7sh38YNWPD8vojKx6I5vgOO+yxT13eWpc15fj+25QIzsB73Drp8JlwC1amGbX4EbDPdHVES3naACXXSn5iICiCJHo8P4v1DG3PlJXbj0wYUSlXp6NNNR+a68uyoyD3W9y5hG+zA0rx7VuTuiPqhCC/c58Itf+un4IAHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HL/fwy5V; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HL/fwy5V"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3c1adc90830so614624b6e.0
        for <patches@lists.linux.dev>; Tue, 27 Feb 2024 11:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709062051; x=1709666851; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wCrWUksx7vOTzvehmJl4wWEPKb6RL3b7eNiwdpGdi+k=;
        b=HL/fwy5VXxpMAC07BwCXqenZQH0Bef5ORNFPzEd19KIGmCAsnQpzbyBKmSFZ1GWDEU
         WImnzSV4XBTlg7VqIMstsfDX0roNyuFzzhWZ1ip0Sj+3bmNqtplyLR2/jAt5qAIcqDe6
         vVffSqsS8B8MDdNS4ujTKRIwbO9czS0XNgPMX0SFxPJ+mFvErt2eLOssm3bLkjEDqYZ3
         KOhsN4aVlpP1C4EW0+Um+gdkeAzPusCCzW3nYrfHlkkQ0P1PrDIaBzXfhpI0quD0RkpA
         eycNBGHD6/gageigF5ALfjY4w59L/dkY/P4Ut/XQxSLCLc0HnljGtEICHCUcdkcp/X5j
         1+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709062051; x=1709666851;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wCrWUksx7vOTzvehmJl4wWEPKb6RL3b7eNiwdpGdi+k=;
        b=Ld4a39RMnh+NaSMiK2S4f7SO7lzB02yXv94K0nvCm2DJp3MeuIoTTPQQZGG6KljrcH
         ZPCOdPCFbHGsKRpL9qpuQtseuupCV3Bb9gmVpREjW/WZthjIIYBq9cV00QoNtO836syw
         Kk8f7JnCIWS7d5lNXamCoEkLKYPNw8zHQBC1vqZF/rp3fpbL24Ag+P+nUH1lpemJ5jLq
         VFJi04971z3dDY5MJspQPeD6xgjXWnxD8GJaLpKiizUat37T7gQWGv/khHDXXSlL0ZGA
         hKwRVmQsxQ7Cm8TBhMxxvc3r0z37hVhb7o430uVoPZvk9VyvND62Xd6Vf5TA5gLTuOsS
         t0fw==
X-Gm-Message-State: AOJu0YyA4q5eXkMKf6dOF5SAl4zcgyiv81EixxcDNubjnv+JiMIWyPcE
	z+5koMv1EfBpgYzHgYos/a05oI6gqyBvbv13b1JM01GXQ/OGE8pP
X-Google-Smtp-Source: AGHT+IGKqibhDTaKHF9hHxyC6qvdkGJmUJhcVVJrA2OOZkmB37nOSFGRqE279uAV1IDj1tnRcZlMSg==
X-Received: by 2002:a05:6808:1244:b0:3c0:4357:1d20 with SMTP id o4-20020a056808124400b003c043571d20mr3288891oiv.47.1709062051366;
        Tue, 27 Feb 2024 11:27:31 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b12-20020a05620a0f8c00b00787c1102df8sm3860584qkn.127.2024.02.27.11.27.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 11:27:30 -0800 (PST)
Message-ID: <10ff67a8-074f-401a-9344-2c19ede9f628@gmail.com>
Date: Tue, 27 Feb 2024 11:27:25 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/195] 6.1.80-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240227131610.391465389@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/24 05:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.80 release.
> There are 195 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.80-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

