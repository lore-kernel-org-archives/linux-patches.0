Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487AA239563
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 18:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738867393; cv=none; b=ljJXnDWx1z8BHxSAAoNgCl2/XztE4PT5g2ac12F9ahnUCOCrqwJT5uU2rDSGJR6WqY9+P2+lv9vfM5rczkWC8DIJpC7Z8gsEzoqM3GbCaJXhqrn5Y8PnfCyX6cBrBYelmnUr4UYhZ5/Eaqwa8GageuiiJHBNGEf+Q4y3SKRUlVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738867393; c=relaxed/simple;
	bh=uAdAXJ3ttfBwLPhGf5YBt3vPt5f0DiFXdkavg0WbUCk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Il4kBR2KjYx87ZnEDuiHug6PrctPGfJFTlMUWQdrA0txfsHiONC050UHzxrtlHM2iVxSGcbaB/t/xHTa/vLp7PCz3tT9KIUTl+KMDM3NqpIfKQRagaB2Hz6QDusYEsThpHh3Wm2O1zoOOfeC7Q7wG0R1TK/cuR1VLqndOMjVq7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f6IuPhdg; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f6IuPhdg"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2f9bed1f521so1913125a91.3
        for <patches@lists.linux.dev>; Thu, 06 Feb 2025 10:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738867391; x=1739472191; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=o/SGIzDDU1HxCcCtg97Oxc2BICy9BGiv/PmjOhgONoM=;
        b=f6IuPhdgnXW7EXsfnF99YHZ5bLVDftHu3nj7ZUzhlD5t5YlcD64FnbUjAxZQ2V3RpH
         QB+pdh9I9nNHliquS2dryzOGPG4U7nYrr7yyy3Trs6P22DUYG63fYEHFIkz7cKlG48Mf
         iuLvkgqSsCtzyBYSND/7kE3eq9DslXjnjyv2gaPgsh3iy2WSKTIcHWgbN4Pl8Zyx5qwB
         u47UjgcPv47NjhLs4a/X2oEJTDWds8kJgqR/BS809oBI5zM2vhtvc5HSPfSDUsFLC6ot
         eGlABRGGvOKvHqaaqb18p6HxqD2poAVJHIMJK98jqA2znbmmVa0lIBbUqfJvOoPuHa2X
         zGOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738867391; x=1739472191;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/SGIzDDU1HxCcCtg97Oxc2BICy9BGiv/PmjOhgONoM=;
        b=EOMZFlrJtGP+4frPRYifY6X/8KQXKjGiIlJoIqVb6/zaj9Sqr9hqANkU9zicBc0fPv
         G2fTKm5cW+8xhhhxlPhRHnByc4zVRRgz0ncfeQsWRYkSIyg2fAyizy4dhp5o7YxZBayN
         ppM1KyFlO+Jokcq/BFjmyZu34nFksmew/oWU6sHwzdQrQJVzzaFn0MK0S63HaT/FgS8p
         BPjfP6azDKP6vGyvfC8Bil8hKMHw4DgIjT+xN9+/IFWlY5LUxZ1kZIZALGqF48WZrLKY
         kdJpFAMaka4DntfZkkQaF8ct66JBsu2ZwI0fugpeC7iQ6PFEAMLffn1IWnH8JAdL8GYx
         sVvg==
X-Gm-Message-State: AOJu0YzPf0QIqT9xV8BtEKdD9nUpE3fPqUmO5zqeaaxn/8Hrz3oRHIuF
	3bBqLJaXBeCZKaUKjWcKxH42EPY7RjACNN/1vUBBZVdjUfFZvblx
X-Gm-Gg: ASbGncubRmzNK/jpl6gwe1Mhrub/HAV6Pg287MGXE9VOQf2fGsPkOGZMRUQlJ554fZj
	PvAWyPgbe03wdsJnYSx24Y5Vga7Fr2cOR0ofOIgb3vbv0HFz8H0j8OqnYmoJHKqYL+y12U9iwzi
	ITfOEQeHUrYUBJ8yszWsxz0FZBuMWGNWdnYxDwwJrDpuHuaWXDAswb3qQr6QjmUGkzN1GE0bE43
	L4mMsKaDEz0PhbwwuBmEIhaE1N8QwEC/YQ9qlE0B3SLSqzsMG6zuq8F6mhAWldtdOXDnStHTADR
	Es6MtQxTO/jMnPiJEC+Vrqt1AoAYCq3o8+Ksw86qPSM=
X-Google-Smtp-Source: AGHT+IGiU24T0A4ZJOX9laIhtVM1hqrLeeLDEOg8OUwzqY7sc88PLn51PkImSwHoo/N/LgXlKs9E2w==
X-Received: by 2002:a17:90b:38c3:b0:2f4:434d:c7f0 with SMTP id 98e67ed59e1d1-2fa23f6e5f1mr182841a91.12.1738867391422;
        Thu, 06 Feb 2025 10:43:11 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f9e1e4166dsm3946656a91.44.2025.02.06.10.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 10:43:10 -0800 (PST)
Message-ID: <cda2a9a3-825d-473c-a9ad-10fb7cdf139c@gmail.com>
Date: Thu, 6 Feb 2025 10:43:09 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/619] 6.13.2-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250206160718.019272260@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250206160718.019272260@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/6/25 08:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.2 release.
> There are 619 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Feb 2025 16:05:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
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
