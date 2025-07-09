Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911CE2367A3
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 22:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752098801; cv=none; b=LnQw6p4C541/NzI2GDyrNKgOG3QuWMd/0hNhEXtSHg76vQxGvOFXpPGOY/ShrLjZY6z4J842cpf+m7Y7ULRr1kvyGhrHFQBv0Okr3Fhre3v2M3+/L7nLlTm12Na2+d3qSV0D+qX0uoVBjbqjYQlUAYUfCYeS0wOBKiHAuwp9buw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752098801; c=relaxed/simple;
	bh=UivWZVbVTdAnNMHvcMlummL2yP5IUJF6YP9QTx7V2tQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bgGVZz60Q3xigQO2PaqVD1uVN5HkObhOsIWWAd0Jw9Ga6C7XNyBwJm86fXrFWBsAAkBg8+FmNifcO9/K27qqaRnKWp/nxY6ic1EkQ6lhUAaVDownF7yKEqJAaCnMX3xnyflEURSv6HFZbMRwaepOPUZgpS+HHahAUD+zoPhL+6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Thek1kyl; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Thek1kyl"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3df2ccbb895so2932545ab.3
        for <patches@lists.linux.dev>; Wed, 09 Jul 2025 15:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1752098797; x=1752703597; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AHVWGMYHRCKbeFjqKUCEW0KQtyaUl3Of7Bsa4d9NxMs=;
        b=Thek1kyl02PRecbzlHxUNHTw+zrsfhFyT+OfQc0Ff0OEY1FjH2qIUFVGjpvu4erO59
         BZIlRDUViMiUPV2UXeY+R8e7hBpWjg1HgMomaUWo8CUCP7f5BhaGyh9+exCpfb3823kR
         4qycnLgEyI3Ym89HhMCNF6Dqn7kUbAkrMo+HY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752098797; x=1752703597;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AHVWGMYHRCKbeFjqKUCEW0KQtyaUl3Of7Bsa4d9NxMs=;
        b=OFNHlRBZFOZmo7k03qiCC26iGKQBdCreuyYWObYKgzQEwP6fOWqHz+kXmx+eEz4Sm5
         PQVKrJ/4vDdV/pRdVU0bNbbMz6SInRSKCsU+eEbKX2+vanUEGp4Kxe4ywSTHbVbFKF7o
         9GC5i0XOXp2f1+E2P4NGukLhyEMQolHMD86iIiNFzQlus6sHMy1LyJ5ePr/OIEtzIOsz
         DUCjkVBB+OVTYUhA1nLL+YnDO4E56M4zkOkhwR/abo51Euh6obWX66pFco36clLwL4t5
         W+R8fSvEChFhOcT6NWDFgrhtlhykkx3ghSdBgmFU9zk29y6NIrqn/PWQFCQzMgWzewIZ
         Se6A==
X-Gm-Message-State: AOJu0YyKHscidZ/GwN7+Nnk100MmVV/SiAeKQXyxBbGfpMJo227BDazc
	jkUIf6kPj5P6Azba5TQg8RL/C3pIne8oblFSubsPP8dftrGkyw0lzXm8K79X1V7Met4=
X-Gm-Gg: ASbGnctOwsecAVkkj5r9OpUxyP6oiWb5CVOKjwNFI06u1rTv5JVLleWqoBh/pJ/SX0Z
	IT77UOrkGP6cgPSOe+E+tkwqBWcNQIhGLGnDQtNpk0KVcLWSWKHHdRmWK3wH0phWQzD1LRXq8y1
	PHRamI/w5CZXs/8e+slZn7o9raVo1gZl3UBU9Pl+PvEMa6Q7+8G2H+W7nZKUi1Q1bN1mJS91HiK
	/gJJsoDyocd1xDFNNe2yvWXkV562gU+7n67Jv+bK4VrhVwJqziJhoVNc6kBKUGowzGYlc6Y3Ac2
	i6hOKrtZutJ9T+nU8PE5lRRAEI7HxFLgzUO0ipNdXrl6xNeCW+durxXd+ctMMdrRJjKeJTqEdA=
	=
X-Google-Smtp-Source: AGHT+IHWjvyzeLL6N8yU+Q79PG0An3NzZ7hrnWtn2/hlkyOhS6W5NhNcVoTCYr01Ld/L8cIfVJIByg==
X-Received: by 2002:a05:6e02:2205:b0:3df:3110:cc01 with SMTP id e9e14a558f8ab-3e2461eb736mr3622715ab.19.1752098797568;
        Wed, 09 Jul 2025 15:06:37 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-505569cc6e3sm37400173.102.2025.07.09.15.06.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jul 2025 15:06:37 -0700 (PDT)
Message-ID: <2c51d285-186c-4110-b292-4051737ad215@linuxfoundation.org>
Date: Wed, 9 Jul 2025 16:06:35 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/81] 6.1.144-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/8/25 10:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.144 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.144-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
