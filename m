Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A32B1A4F3A
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 23:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726009392; cv=none; b=ozkPILWp+ifzXQOnIHoJK9E4+mjxpuITUsDrySQcpSrlvFAKBcQzfR8dJLLrGUneUEZ+WglR0JS7Eao+dSNuiLjOfxGcXqFbbooL7DsB9Cr13ivWUE4Zpx0Chk5IrgIBBKWvDdbaHa3S6uH7jhZdsjPp4MpMH5PI49dIyEEa8KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726009392; c=relaxed/simple;
	bh=01XXCU8JIt+/LolNj9F9a66tCdxaL1YDcBc+c1mPPQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WdneB3IL6GNv5Tk3eYDwJ93FHR1qsN+B2+DeG3RUv2M61s9cCmyJ0ig7O9FxX+LFvCox6I5/6LLa2JGxEmEdh1V+/fNfEWhwVNXClXb/+DjUrbb/kxXup6NalqCA2FcHT+wG+TtyNbvOX0igR/gNfaQCo8262cLjxJibe1U+JKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUs2nKaQ; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUs2nKaQ"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-82ce603d8b5so130308739f.0
        for <patches@lists.linux.dev>; Tue, 10 Sep 2024 16:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1726009389; x=1726614189; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Our0i5FAN8M9eyBuwGhZmOhmd7tZTzv8n7Ma5HUwtUY=;
        b=ZUs2nKaQATLwiIjPA+dvtxK0vbTsXH12QXoBTz4h1GM/ivzvA566e7rrT6Q6dZmPNa
         teFM0hC1zCRVlbe/CUbuM8kF1IewiaE32l0fPexNomWbtl949APC8G65WlDXIg+5FDmu
         MPVInK9W8rpGJdW6T2Px63DmqExUOOjfPBD1g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726009389; x=1726614189;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Our0i5FAN8M9eyBuwGhZmOhmd7tZTzv8n7Ma5HUwtUY=;
        b=w9KJnBMAy25t780vFXNC/4jY4XoqYbgx8Sg+QZeFtxiByrdvtmyKPEvMT6z2brrZEj
         N6qGeXqErpvfEVX5SAWwXkmYzX0qVYdbqIt8CHegvIpHGpfT4K7X49YLKJmekA1lFnT7
         a+bAj+Tnj/VoPQ/fARZ4JiksxIQ3mlfB4emasJfEvs8feowxtP62WjPt49x7OPNqpyx3
         SWNhsXVEJ11xgOQ63tsi51QoUVFfjrKT8ciUvjPCVi3N7AYm8OyaGSJf9MxgEL3Q4Jku
         PT44qr21EP+86o/g5y34gfN1S+52OaTNeGE2AdBRranH/Aqg8QwlOvfMdL6FiZ4tryLk
         Y1/w==
X-Gm-Message-State: AOJu0YwG8lSMXT0h1pw90AOAbP/RHh2N05c5e7bzkxXgMi9km2FY5t6V
	3NjtfzA1M7ktcgX0JvHEfUoxoqAqZozAm/U9BSp4livWHIXN9/u3/A1ynqfEnU8=
X-Google-Smtp-Source: AGHT+IHTzytd/BXjhulGOFJeDN5N2Y/iSixDSXEeNyCm+5M2O3H39PajIp3Y22RsVR4SC9HtjYRdKQ==
X-Received: by 2002:a05:6602:2dc8:b0:82c:ef21:91de with SMTP id ca18e2360f4ac-82cef219385mr890886539f.14.1726009389357;
        Tue, 10 Sep 2024 16:03:09 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-82aa7385633sm228261539f.33.2024.09.10.16.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 16:03:07 -0700 (PDT)
Message-ID: <f2b4e304-2a9a-46ee-a56f-c7669bb891af@linuxfoundation.org>
Date: Tue, 10 Sep 2024 17:03:06 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/96] 4.19.322-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/10/24 03:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.322 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.322-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Build failed with on AMD Ryzen 7 4700G with Radeon Graphics

   CC [M]  drivers/gpu/drm/amd/amdgpu/ci_smc.o
net/bridge/br_fdb.c: In function ‘fdb_create’:
net/bridge/br_fdb.c:515:20: error: ‘struct net_bridge_fdb_entry’ has no member n
amed ‘is_sticky’
   515 |                 fdb->is_sticky = 0;
       |                    ^~
make[2]: *** [scripts/Makefile.build:303: net/bridge/br_fdb.o] Error 1
make[1]: *** [scripts/Makefile.build:544: net/bridge] Error 2
make: *** [Makefile:1086: net] Error 2

Possible problem commit:

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
     net: bridge: add support for sticky fdb entries

thanks,
-- Shuah
