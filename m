Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEA6205E18
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 19:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712862818; cv=none; b=kdQVwPQJV42AAL7+KuDMZwbZuFtny9aFcqghHTpYrihkCmNXvJ+ANtzaXxwhmfGvFNG5jhsgPHSxKlY2fckyBobh4l6neyDtPEi0bFKhhIBD9FC6WPFwgXTzNTEEOUyBOM0KqAfCl4HhCz4hLnc4lZ7/ovdEUBjlCbxqk8Nn8qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712862818; c=relaxed/simple;
	bh=2CMK8rOtCxGsbTCs/JqTdsujjb7w3Q+fa+8zVF1mOzg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PDpXSLSZEzVA6oylsL5/poW3uNqHQWrE/f1UcyHy2bVlSJZNtBcbRWVed7NOPmvlAvilF8gDdp/9gsaEEk8sEJj3vyYXO1loAWNROxbsXtTMoFcYlIhJKRxglnucM6AANa5e4v00yU6uwxxyTNMBV5v96G3B/QsLaM4irisSY9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FL7rMj9G; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FL7rMj9G"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-78d5b1a34fdso9015185a.2
        for <patches@lists.linux.dev>; Thu, 11 Apr 2024 12:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712862816; x=1713467616; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M5m3l4Vb8I5/ZGVgXiYeL4TNj6LNEAEO5dE5T/EQin8=;
        b=FL7rMj9GUsfsuAEPKFb5Ha7AgydWgvz/JxfpSe/MECMIMENvyTqPnw5MXTxFHp2e47
         W4WzAJbXtBjRBSn2YrZWdhn9mh2cJeJgtTuDO0PN2TyhGAp8pjnjTW623nlYgwHXHLtK
         K3eFIdDLwsAjVZYh2APP9pEDLJUofB3HpI/ia8sbfDrYHc+mVNT1EOEtujm+WnAtX6WE
         knuSpG7/U4LaJDWOA4vuZnxK1dXPCh2ylHxeb1XWwv3Be8yZm2wJV1Vwu8wySvC/XgY8
         FxocFJTVkXKCbyywcYy79Ii1LTR/bYncuCyf62q5YQDU3uuxT0IUWkyII9lzodPjhznF
         43+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712862816; x=1713467616;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M5m3l4Vb8I5/ZGVgXiYeL4TNj6LNEAEO5dE5T/EQin8=;
        b=eMltSj5TRVfL7CIEdJh7ijj+XfrBClywmXZ3tiL4xcJkb9Q56QQN/O0YJFWjR1+cBm
         +HE8FlmpoBOIvS3pnf2lJxgb00cVh3jkYAUkGgUZj2iO0fq1jXxidLyVW3XRxTnPS4yG
         YbXQH6LaKRDY1LMagXpM+elyZkmVcbmeV0/F5+aPHXRNttSIVc9lXx4FxgOXdbMnC/9s
         +qv/Ppl/pZ+CTKG8lRMNgdDxIduoJiwkxoFebSpam23WG4fllwovG0qn9lhfaGRh4bN5
         JGHpOlaoSxE9zP00fqly7bjSZ1VYd/5YbLJr13ZN7naQ1WDBwvUHuINwKMPgkbfOj7f5
         6psg==
X-Gm-Message-State: AOJu0Yym7T+DTglGfHe6lB/C6xzzHCX9CTFTs8NeeytILjg5NGJQO48z
	WpwRRdEGB2vOFe8KkjZjRH2Jj0z6EbsyOqDz7692QPfAKsJomSrn
X-Google-Smtp-Source: AGHT+IHhe1I2Uq0lLSbvmS5xMIfCfYMrM/FUl/d012CYdm/v+sQx7ZtT7UhmRSO2G843rHQGxzmibw==
X-Received: by 2002:a05:620a:21d9:b0:78d:7368:3c7a with SMTP id h25-20020a05620a21d900b0078d73683c7amr577364qka.35.1712862815843;
        Thu, 11 Apr 2024 12:13:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d15-20020a05620a158f00b0078d54363075sm1387123qkk.40.2024.04.11.12.13.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 12:13:35 -0700 (PDT)
Message-ID: <9292ddb9-c316-4418-9244-81cb6a8542e5@gmail.com>
Date: Thu, 11 Apr 2024 12:13:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/57] 5.15.155-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240411095407.982258070@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/24 02:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.155 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.155-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

