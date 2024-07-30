Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796CC1AA3FF
	for <patches@lists.linux.dev>; Tue, 30 Jul 2024 23:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722381102; cv=none; b=kdiw3MOO0RonAre3EMN9cFqukPm6yIneQ8vH/vm0WMBURHBJRJ2ReOk/CtNs/bFK9/A201fYcsfxViI2453EkggFSapYczDfmKvC8wmMIzN6yKgqd8QWwNms9N+ruiiD0fXefTIRml743X+L52fg8Se3hk/JasTPr1uEc+nE8gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722381102; c=relaxed/simple;
	bh=nCeuwLIYjC5AyVwLPKSkgV1ci1aIW383MdR26rf74WI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PPSMkIvvlk85ijGdj4GU08iYND7trTuPeRZ9vcWsMWWzzoLJ7gp0CG9sfJrlUlZ6O6UGRRiCRDsL44s/vgDGxjHLqJJ61PKu5/8219I7WtEml2yf8FC9XdA9p56WuWzauIWXsBMta4kjLfaeAoayrvbPcCizOJeiChI0//FM1kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGoN8+wU; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGoN8+wU"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-81d05359badso32344439f.3
        for <patches@lists.linux.dev>; Tue, 30 Jul 2024 16:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1722381098; x=1722985898; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sFwp9JoAZRcGCAmAU/pa0KmQXzJ+i1s34wWpHxxRFHU=;
        b=HGoN8+wU3YaAcVksLLk8+3mDJZMQnWepkUz690lV+B/mYWEfyYYwwsOW2IHQ0M0E/U
         liPVTNbaXWvspDr4eHIZNzsec8GBCp3EDJXBmr0mq/W8IKyQgYz5fdEb9+0TOocwx/Ce
         sU1BssqcoObX4fZw9VTLyS/F7fy13Sz6Ezdg8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722381098; x=1722985898;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sFwp9JoAZRcGCAmAU/pa0KmQXzJ+i1s34wWpHxxRFHU=;
        b=horsBmp+gSsVFfhYy42Y8NV7GsKcGbfj+l9gyGtzqEu0U3MBTEQFJhB/fn0o4Ib1x2
         iXkX88itmF3Q9CcEShO3apquvJ7CBEqujc2BH8Mni2/iJ8rYp6YRC3yG7iAOkOZw7gji
         xTZjqAYxULP40aakS33VQRVzd/EF/lhW6lr0NK+9jGv9M/zabo/oIZkEK8qNeEsSrqwF
         Vo0T5TmQfJppNuYI6qfHhi8pc50FrdfQZwjkMVwBu8WUxn9gQnJqDrna8fg+BEdUuxwy
         AiMt4wbTdM/Nv+AbE7uGOtEG9PL/fbRfFa1LhDQ7FUqO3VHdGx8Ok8JNsayuCbtcmIVk
         7pmA==
X-Gm-Message-State: AOJu0YxeYfJ19TiE6mvEG4JHyVifva+2urR3MczTBHDQ01jhhxU0umkc
	xTzktQrxsJUjHoptHpVRvJUiqpzcAa+xtEdBw7Ah61M2U2QMgutBvoeJwAL4IzE=
X-Google-Smtp-Source: AGHT+IE6Ubd/KWl1gwVavGozmtWlhzKPtfYc3QbZ3wbPC5xho6UnQTVPsflVhp0HDM1OAKrinyAWHg==
X-Received: by 2002:a05:6e02:1547:b0:39a:f5b4:c63b with SMTP id e9e14a558f8ab-39af5b4c952mr63224755ab.5.1722381098495;
        Tue, 30 Jul 2024 16:11:38 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39a22f14094sm50774925ab.60.2024.07.30.16.11.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 16:11:38 -0700 (PDT)
Message-ID: <585d7d54-2476-468d-9ec8-8988ba607c5c@linuxfoundation.org>
Date: Tue, 30 Jul 2024 17:11:37 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 09:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
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
