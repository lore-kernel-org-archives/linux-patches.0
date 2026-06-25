Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A961260580
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 23:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782431901; cv=none; b=AXDyufwiYktrJHXNJc1b5CwbBXu/SyBVW3CkhX0h7qE4RHn64P9jsIOrJivuwyt08Zgv/KwQ6SkwEd/BMXoOrdrDllT8iZmfdNae0N+sWtWNZrz3rIvlHtyhpl0ThtxlpLo/S0vOqRnXesNlVTW3eZYEhqa45o8mL7gZq07eZas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782431901; c=relaxed/simple;
	bh=KRxEHiQTYyU/OTzawB04E/xqAfA4n+zG76v5h7G0d7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O4QtD/0o8gNPfrJ39WKoiswcexdh7umEsv1Vy78TLPl/jhbtwAqtMiEfGnYCOFA7p574XxIN9FBlDjdiK29vTH9jz4SG7V6ZrkHZ4mqLkN1XVvg/i6G3cD5Rs0wdnnKu8lMCf/8HJ/d+Q0X5XGbtmOcpuHbMXnwIdZuVzrDFNqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZEOqif8; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZEOqif8"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7e6cdd78fe6so179472a34.2
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 16:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1782431898; x=1783036698; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vi0Fj97kSm4gOIJe2y0udY4DdlKiUQsQ1VFiAjycuSA=;
        b=dZEOqif8WlQX1vWE6v2CU9rfEYVPvUNuv4Sw+G/YcXA05t4+1y75t0mWKyIh4fSNcW
         vhaflZMZgsWttEoz+7sc3g4RaIqu5cUK5uXDfduTG1PQFrR206I4l2IuRyRJfJ4whLp0
         O1em6Us0ztk91j+MrDnxUzCpaqYvzqJLsq9oM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782431898; x=1783036698;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vi0Fj97kSm4gOIJe2y0udY4DdlKiUQsQ1VFiAjycuSA=;
        b=eLSKxNYMvaIlqICOqOnCMYYKOWXj/rIbKDRMx6XX2pBEe9pHreca0N4Y2cEz8NojHi
         NMtzWslU0kZXWsE8EnBT3yQJpAEZLfBnLG3Nl2p/enN5riCzjG9Iz4p1anjXSrleJ7n3
         EnEZ8bbDuSNJZM/zwzH38xnbZzrdy5iXfNpa6K0HzqlZX5J/pk21ThX+M5JJDbIjuYff
         lwJ0kbRCU8SEj8QIQQ0YEQ7Nt7QN+bPQeEk29zwmhwDn67+2KFExTVDqQ2Fe5BdIis2g
         1ULYZSiVQV8Uh6JTDuLS3Fni6pH0L978yUXvpE9dAw5RPLP1yoUvPaWvrdMnBboGHonm
         ItWQ==
X-Gm-Message-State: AOJu0YxSYSM/gA/5LcFy2A0MFEb3BwDSmflClSvsfqEYGFaf4wLhiU4+
	4SfPxbFrcaBI4vAWvHIAVhVcLidAUe4phEbovhPsjRPGhhiLx5htE8jLptDSsjuxhSI=
X-Gm-Gg: AfdE7cmUyv+NE/1plSJ9BIwgigdNQFUnoLwl8Xe+ZOzsBeI2h8q9cyS88Bwe3Wuc+Nd
	qdEVbwx3CDLtszLAIKRoSWn/Cy7oFKd56q8TvMUt6dC5wYD/BLpNz1wII5koPjwunnsacQN9rfV
	IxgP7kDRwFt4OUyYcGHNKSSAsNTJZrMCe4IS4Qq6Ijw5X95me3JuQhkpzzk7/73DkStXw5/XJrI
	Yuk7WdxujYV8pbUiSXTdJ9pGCegIkLeIZWSnhewgQUE2kCOVsTbO2cE1wyaqLnnXYi5J0wfsRMe
	Ji62Y14Gm6uf/Oeq22B17pNuq9Si5eYU5JUP/gk4TnXc6ZS45tpEx3obCMnRXJqMkdqigUcivX9
	iK9eYTXbXjW4Zzl0R6gR8MERejAgdz/7vvRho4CkOiz/62UoLJz63fL2TWc8BJfEfSWNGFxSDh9
	yFLUinKkqVIymZjvQ9j+eL
X-Received: by 2002:a05:6820:81d1:b0:69e:41bf:fdc1 with SMTP id 006d021491bc7-6a13519c65fmr3834055eaf.19.1782431898247;
        Thu, 25 Jun 2026 16:58:18 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44778b6159fsm10484577fac.11.2026.06.25.16.58.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 16:58:17 -0700 (PDT)
Message-ID: <4c2de804-4f3e-43b3-bdcd-ea06c97fbc77@linuxfoundation.org>
Date: Thu, 25 Jun 2026 17:58:15 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 00/49] 7.0.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/26 07:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.14 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
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
