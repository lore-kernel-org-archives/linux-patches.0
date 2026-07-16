Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A80A3A5E8E
	for <patches@lists.linux.dev>; Thu, 16 Jul 2026 17:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784222457; cv=none; b=WnTJtJiuw+aTqPnTf6g5RzS27zr1GFH1zicrrjmZBan7B7XamWjj9IlmadA6Foevi/ARF/pBdJwnpparwccRqhmUGVNX18dCE3Qyaif+Mb8TlWhRaYdIpIpfPouJP9Vigl5XlfL4NG5nG5pZak0m8gCYJNQHaaY8sJ6J88dE1I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784222457; c=relaxed/simple;
	bh=GWQfN7yjMoPWMWr6hsCcLjowPGOd3T/BfgrRBkNTggo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pWQi0UgOn55SBnd86znixt24CkrZ4rXy33XcuVifLibXa6nDm4OvMgDqzxWuLjrn4fL/Q1PYoF8H1IAPdZ+eQu7rWQgd5DmIZAbfSeQnH6uSIPDiY3D4+BmGhhl8nD/Eb6p28xCQPtLi/TEdTExaXr2u/3xMpmRcT4ewdBeSGks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AQl+rOV7; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AQl+rOV7"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e54f8c051so507904985a.3
        for <patches@lists.linux.dev>; Thu, 16 Jul 2026 10:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784222455; x=1784827255; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=76cyaRlrxLbmiOeRadEQjvq34G1DNYWMPHzBVajJa2Q=;
        b=AQl+rOV7V17Q3ZKKpfEAvJi5quFg8HNo+Sq1EejNTImg373U3Q4HvGpgTbTzc6oCQ7
         J4q3kYNPE/rBcEq9XDhuqcCXwBxnmWwmb/gcWn0J9YtRXS875LMWFEfM+yTXkxG5vkjB
         Nl4e9phn95iLApk8HWIxtP+pyMy0LSDgZAAmuVK+dthARWU58xn6VkPl8P21yzrtugkC
         728x0JTFq1ak1nYJMNu2nTvakKE9lRN2IQCYd6ZJzRw7OzK85HQkK87DehV4F6noK34r
         7wWUX56BZTh6BIEUEa7tRfUEMhu6QsOg6PrHlFe7FOAdUqMJO2xBJK1XdAxzA+aMUUJn
         MtTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784222455; x=1784827255;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=76cyaRlrxLbmiOeRadEQjvq34G1DNYWMPHzBVajJa2Q=;
        b=H06bIoiOvqb9HGrDaT7otCiBA5dqGHU4PGnstnU8GmuxtRxbu7nYtvMhcp2h4Y0T8d
         VX3NYN7Z+WE0ipwNl4UQ/TG8Lj5W1+KVL5mUvPyA3AwLssvbiMvO8qiQIuuj7RqJehLU
         XwIhVWz7fGqcxrl6R2Hkfm3VrZ8oBawxPOrmW1SD8Mp8p0JL1gl+gzMYuCxdqI823pgL
         fl34e5Ez/gXtlo1THwek6f4y0jqA1VFKZ5N1fgC6CRCHDQhEEHclIpjgyA3p0i7QC10h
         t2cQGxOFrNp/r0to0P6AV1F/jlduNdzCPBvqiGx+C+cvLwERsrO0jnzGlVD5L8Ruj+uN
         SGzw==
X-Gm-Message-State: AOJu0YxtoQW+WzgxIsEgxcvm2QsFvpo4mvLcQrUqcmaNJm39i4kL5QZn
	9Is3LATWvwX6giN4x7G4X4V7F1dfbE5Q5Nfzc+42UfmMxGqX9+B2voVo
X-Gm-Gg: AfdE7cl4ICLl9kG1+ELTp2cdSrUymMtkMd1NUnsvJTxMi35tl+EXdIL0xOcAWC4UrNQ
	KnnJk1KoBwQxoSNAS/hl4pIl+PI33ho69Ylkia2noi1v7fA7OhQkNFgLrbKS77FwBore4gMRu5A
	/tVwLrUpM/ARuXU766uq1+AixcaVyIkGDDxZ4ptwrWK0GEn50dzNMLOV7ydYDNcrf9Ui6VXfer0
	MqbD3Rz5pLchhqAaCT0dJt8+siAL02wNYIS/oCFkSvngww9eMkHO6M5KgndgZJDnHGFB/HOl7ag
	WXxXrC8tNP9kuPUmVaPO6z1+gLQjIMUCywaRmgtYCSndDSpQNB0ojU9nOZ/02U34mhkLeVzt4JT
	NoKlbXw/Cf/Jnk2SzUYBrundSLOYwjeuH0l/0nIO/gHtg1uSvmByuhnCHNwc6lLTpBXeItoCLDO
	k9jeNZDRpyMmOEUYZnevMSA9jXPMUj
X-Received: by 2002:a05:620a:4620:b0:92e:fe10:3f02 with SMTP id af79cd13be357-93086bea8b6mr1312938085a.51.1784222454693;
        Thu, 16 Jul 2026 10:20:54 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5b93387sm2197935785a.16.2026.07.16.10.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 10:20:53 -0700 (PDT)
Message-ID: <1827cf2f-2fa5-4d8c-87ee-58bb98bb0b3b@gmail.com>
Date: Thu, 16 Jul 2026 10:20:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/480] 6.18.39-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260716133044.672218725@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/26 06:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.39 release.
> There are 480 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jul 2026 13:30:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.39-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
