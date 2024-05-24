Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD0D86AE3
	for <patches@lists.linux.dev>; Fri, 24 May 2024 14:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716561427; cv=none; b=thSzlEcKcwbAfTZ+lV8TjjOlbjqGH1e9CjZvbxRlKYfsJgMlJWhi7yHVr309+ZEvIPbLcGQFSkWykFampoVpuKz/UfpPswK50RROz/RmtP3nw2qZK8AjR9dRg2GrcxMew01Wzhkj794+5ZcmyCbQfWx7lhNOXC3z7NRAIG883ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716561427; c=relaxed/simple;
	bh=zYiUOM/cgz5FKbnxjvOvtgTxQKTjT8kGJGa40kErl3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sS+nwXam78gbkbiL2Figj7aJHb/iCIHyXulUPAk/2fScZTGxt3Edrg4eEvxvuIwnLcUhHYhETucxioecnDXAeiWF/K65pkdFG/knE7vwp7h/21qjcOIbPirTHPrhyskwmY6qCw76E5TCwCbvi2ObLaSnl79R16EFprC4HbGN17c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1MoJ+LF; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1MoJ+LF"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7e24aa659abso28668739f.3
        for <patches@lists.linux.dev>; Fri, 24 May 2024 07:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1716561425; x=1717166225; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eJBA7xup2TeLFqY6dNBteGIN45rczWvZo72CMZBUlOA=;
        b=S1MoJ+LFXRvYB1e46rITMpxW5ZMwy4ZYYcxfPubd8YS6zDmbGecoH6GQOGsZnRuh6z
         pTXgKqb7Gacp0sQQ7NMLV4RhmVZSlj+pjitDq43p4AiUZ4K105CySilOsHUI6DgXyrwY
         jYUseOuhXGP3DAYLFMB/nVXq9gE2PtbAvzacM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716561425; x=1717166225;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eJBA7xup2TeLFqY6dNBteGIN45rczWvZo72CMZBUlOA=;
        b=SI2L/NthKS+fGnCGUSZ9BHbypTLlhv0oswMW9fI/QtCOwbrotjHimiIpAtlYJ4wRVb
         nKH9H/IjzKLFZH8sEnvrBoP8iUfwUCWR3nddIo5A+32W/pUvoPjmg+tdxc4Qz9DN1R5d
         xRYgUEkAKAnvBDJh+Xviaj1FP3+0KmbYV8mKU0cm7Hy9Wte3nxLzKDmC24j2y3ehksTG
         3WZiGTBEXkYXWQkZ41aUxCwJeluYnlyCRIDgqbrdsk8Ca815zT4397NcgDFXYWGYCMKj
         lUvtobYHw8o1IRTOGHv7Mvj2sOIyjtQoYYClXuwFOifSSX1AptNpFenM2kOmDir4G1PG
         2MCA==
X-Gm-Message-State: AOJu0YyrH1bilLsWIj0BSMQuEVNsGdvXW2n4ikReyz423fuf05WZtNvK
	EP9mY7VeYc9xMowSubYleJIu1mxdAlR3ZOZvo+mVxmAK1teCHCjbXCe7bpUo3vA=
X-Google-Smtp-Source: AGHT+IEg9xi37KAXDcTtnCl9w6vL7Y3TJQ4mxp40+rGGP5JKoURGQTp+uGB9FOOKyJqiHmPqX+Y+qg==
X-Received: by 2002:a6b:7003:0:b0:7de:b279:fb3e with SMTP id ca18e2360f4ac-7e8c6172dd8mr253938039f.1.1716561424952;
        Fri, 24 May 2024 07:37:04 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b03e8282bdsm399007173.14.2024.05.24.07.37.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 07:37:04 -0700 (PDT)
Message-ID: <9138a7c1-a561-4f12-a529-45e3ff2c7caa@linuxfoundation.org>
Date: Fri, 24 May 2024 08:37:03 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/45] 6.1.92-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 07:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.92 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.92-rc1.gz
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
