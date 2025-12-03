Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D7625B2FA
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 23:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764805402; cv=none; b=ZCF+V82AgWtMnFzec8/jb05285nE9uHo/lptqWcVrrWpQO7/JcS6rxuyWcVsIjiopzWJNco7xcVBhRJgGTtKz0VGUspZMY9/yE7Dp9Q9ymp0OajbQUu3BDoQiV2EWga3uGwtVE6bwUwi3zCDV7rKtepl5LBkD20ij39cwabniJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764805402; c=relaxed/simple;
	bh=KbKr01owsmLxfyhnVDZLYeAz4isyRyyTzNwUMiogW6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sxnX7uR6SSS81UVtPpxJRrnO/xbYHTMvyvi17OCM7kSM8ZIXj4h8yBiY39sO6MM7gyfnm1e3S7UHlLe7ovevxvePNIl5fyze28/MsTGJUlHmclCOBsKl1ZqN7TVjFLmdfykTSC/GJIDkzboYT+EshpY3LSOUJ+iEhtOHPjPey9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgxqYRMz; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgxqYRMz"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-3e3dac349easo303329fac.2
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 15:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1764805399; x=1765410199; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wQUjSkRA7o9gYvCUhGv5afQrDSP5yNWAQozka/JiI88=;
        b=AgxqYRMzZt/zbhFRDyZLE69P4J02y4fwEu9bCpoH3YenHc5W7g6qcytaB/lHV7qHbi
         1OkLaPNLvHYtj0i+uciM4NCyQqQ9OON6wu1frNQ3SsEcwfioV4feoCt8ww5kHLnP3c/w
         /NdvYYx6/xX3HyEVgqc1kaZq8x5GajtVKFM/w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764805399; x=1765410199;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wQUjSkRA7o9gYvCUhGv5afQrDSP5yNWAQozka/JiI88=;
        b=xNbM1uTt9mT+D3GRxI6nl8qoi76evVqyvdAWxz7c2pVgVlh699BSBzQZVgbE15t+hg
         swoz6fvXefyoP6jxq1u+BZGj4GfkS7+uMxnBcxxVcNVFEaW1odrg6tOmX6bHyAWCTNDe
         ZYiTJN0162J/V6AJlgRJDWlk0zjXSlUx8WEq8GGJghbFu33X7b6ZQlubqzH5UgQRb2Cj
         kYlOmV/wfC3L25AnABbnJ+1D4bQSF4uEtPkm/TlwPgUmPJU4nh7r/awT54oEeHQRbGr3
         caoEjFXUFWlP24zIYfkzxkQ/GQ0QTugagHkCie1q+ROTbAzN8/OWEa/bzG468e3YHvAo
         uCLQ==
X-Gm-Message-State: AOJu0YwopkSKrID1YzezvZd+Z8i89uaRnEjJCKTzyivFNAeCO5vFqC48
	Kz14t2dMWDxIQ8AbQAI702Rn4rLdVnA8B8ml+iWVPC0OPaomOILyWuBLHLHUpCcDsdQ=
X-Gm-Gg: ASbGncvcfWOz0S/tIvMElwhvCdxtQgbwnb3vvqhtlQ/nOhod2vaMlwfRiMM28CTkp6R
	YkA2YrH0hjHgg6gfWbWd6bSFDolkVUywzKTGDViJMRxuyaDQOvJMD+ZdqcqCjg38/RaxHX6K+Km
	L2vk3KBFesiq1KJ0XxOXjVrLiXVE7cx2jnPGOgJDMxxZBgGwk27O0nrmqZipG/otOjYccEwdjQG
	0QDcb1enL/gQn13BKZ/MAMQ+pPPAbJsRjOSHvsPKfbaN8BJeH3PtxOy3Yl92ysAuv65edAjENBw
	ziZA5e+UCQnEN5mw4ogLzItbIo4p3rC1tb3YNySeH72Z0llXkcvFBh3ypSziG1yxlSBM05bik7F
	GmY9tnpkGgZ2gSIOioryOD6t/NYNqCSD1Ul29tUmJbggmB9Pqag7aspLiB1I4XAitQg9I6YJfcF
	TSAVYy3FoZ08WTVQ5I2ho3u6g=
X-Google-Smtp-Source: AGHT+IFIJiKlAtzn6hk6GTPwPglZddtGPgAdQrCquTbSFirZZ8ZbYvXEtSwr0mcfRLe8YWeWF9T+1Q==
X-Received: by 2002:a05:6808:300e:b0:450:d056:e0f0 with SMTP id 5614622812f47-4536e3dcb62mr2315210b6e.2.1764805399523;
        Wed, 03 Dec 2025 15:43:19 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3f50b5123f5sm117756fac.13.2025.12.03.15.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 15:43:18 -0800 (PST)
Message-ID: <1615358d-5443-482c-95d3-e7d3c6e318fa@linuxfoundation.org>
Date: Wed, 3 Dec 2025 16:43:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/146] 6.17.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 08:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.11 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
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
