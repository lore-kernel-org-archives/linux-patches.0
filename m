Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA355EE8A
	for <patches@lists.linux.dev>; Sat,  3 Feb 2024 16:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706978914; cv=none; b=JTakxuQWKD6puDLrLsua5Vk735jvTh9sfu7BGOS/v/eGZtZkITTEQTGdd84MsjxesHsQciMdCu/MaY0p82JziAR/TAdlvD/8uhaD/ElGx3GnhwCvhrTgU67ZeLD8OEgWEZQzfisy+JyYmCBDOmhnSPIT+eqRw1r9W9CBb43YmZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706978914; c=relaxed/simple;
	bh=ijEBBEx+pTcvig0Q4DJZc3u1c6zzdLxOO0mpbvuEL74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S002H/8fakpqmEBqKNi+8FwUj4+VureTwdHTCgfD5WMFtfRFF2UecJ8361toLwdvCdGRWRRAxNxt93MhgJSb6yB9OgGhQD/w0Gvcm8dzSNT7/YAwgOxRcY35Li6b16uQuvrq/rhJ3JrNlDcss1tOrHMyjPowN9I5Nx4MXIuEwnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=elzcPkfl; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="elzcPkfl"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5c229dabbb6so2031518a12.0
        for <patches@lists.linux.dev>; Sat, 03 Feb 2024 08:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706978912; x=1707583712; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xes2H5qmDPKQHZchbhzTjIMJ/+DCcO/uOHw2ALSakKQ=;
        b=elzcPkflwdYNvr9sdzERV+LzzwF7etdCvUaqguUveREn0cWSB/snNG+TR3Wtxav90x
         8EtjvXmW4P874TWiEwrKmsq8I+WXRo5EJh+60/Eq6jrTi75GC6Rtqv3u+eiMW/vCtd9y
         lQqG+s2g/ulVNJZohE11g0Os7NcnkD66aSpgOpPViNjDvKRO6S82uuaWk1wlXS8GDDbL
         kwniMQtIE3VdAD6GuNPe61FL/xMikuWKVXOt6UsMg6MTwFfoB65wILmF6SGsz52KitaD
         yHIpIEYqZ4MmptO1afZt7ttY5mAtEE2aZEOERQIAQ89UIBzmlrHmKqZtlhHR8dfmo/zT
         OxsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706978912; x=1707583712;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xes2H5qmDPKQHZchbhzTjIMJ/+DCcO/uOHw2ALSakKQ=;
        b=LjRf3ExIQXExUD1TE5TZ1kbrtFE88SM9CHjD+/2wi/vkfHdWCXwzhnsQ/P6XV+sAdk
         Ti0cwpYEvoCrQscOBPDvBB/o+Bs/6IftumfkZK7RaA1SBjFa85bH6Boos8nuJ4uxFxtu
         /E5MGTIlxW0ohUOfSj2I9Qt9gWGnwfTmkzfF6EmaFWv50AsjYXlFE2bL6prZ0RzT97sb
         0amEPpN4Iky5fqVYLUk+HYGDib1bSkYRZX+9w0hy+4erL48mTJ/ugWslLbKAeKSBceNE
         leWxx3j457TiL/045i9dIlPIvRRYbT7NG7W8EIxDrYgj7xloo7lU6kMm/hJWJrbNO6mo
         gP9w==
X-Gm-Message-State: AOJu0Yx7oCYImZds5+UCElXWFJClhUgoD6kikV5BX5Y/Tw6I3/9dgd81
	aijPXGyOTuoYZS2LKSUmzhPJjHnbO5LzVbbqPB3krySjE1ca9EI0
X-Google-Smtp-Source: AGHT+IHpPSTdzvo1B6q7X6Ag+Y+ir9Rwq561jnx97w5LPrR5xqtZKXXzYZJ3AmeqXhcrkdkTyGGoIg==
X-Received: by 2002:a17:902:8495:b0:1d9:2a26:d4fa with SMTP id c21-20020a170902849500b001d92a26d4famr9912489plo.50.1706978912462;
        Sat, 03 Feb 2024 08:48:32 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWvu3AtHJK3Gq986W6LxRn0a2Gk3SCZwNL/YocxWGhsMDh/IR/ivdvGBXN4AsdDCUzQMmzhUJgKBNFaJv4iq0rywNdzgBwIfM1ku3hfi0+nDSn+3yG1s2ls1nTUSSneqr0ef+Qgo9n1MkHqw9+yQJO5ec52alINPlsoW8nuczKiKNsk1+Jf4uZO9OG+eSK9L4GvK6E0Sbvnprm1X+9gA3I6IGfw7mWpfKsM+soNgXLGZrWI/Fe20MEx8/IV6oD93cEFtymOsOpKJ7D8exiGniZvxiAMr3AZK8L9CJHg/MHfaBPoSdIoqf9P3sQdOUF2HRGBhwYAhRgD23MdhnsaIWbP6y/OoUSo/EFlkS8xPGDzdyYG1SwN0oiE4M9SpKWDlzpzlhP1DNVfLST47CrI06zlM2h5mrK0CnvqQu+bxP8bBOzRpM2Dg7oDJZq940cv3JNdiXzF5SdqLr5BzDhYmMM8o1aT6qkbgWDm7Q/YwWoTCs/+1xtBvMiJRmrgOfmiC/9o4qHOotFg
Received: from [10.230.29.214] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y5-20020a170902ed4500b001d8c8c903c0sm3460184plb.149.2024.02.03.08.48.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Feb 2024 08:48:31 -0800 (PST)
Message-ID: <691b655b-dfa9-4555-a91d-b71643824b09@gmail.com>
Date: Sat, 3 Feb 2024 08:48:27 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/219] 6.1.77-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240203035317.354186483@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 HGuUuzv+GKZ6nsysJw==
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/2/2024 8:02 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.77 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 05 Feb 2024 03:51:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.77-rc1.gz
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
