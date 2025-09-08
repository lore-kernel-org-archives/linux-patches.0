Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4323C2EB849
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 22:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757371931; cv=none; b=axBPQdkRbGOLXLC8oYx/qaPa/iNF8LI/9C1pMwbuExFHqS0QcaywmDbnMS/gvxkz2rVc9EsV+SW4njllop7mbBAdDuJsBxLgDI6ZRfS6jVxEriKCl1K7E1cPians+3F08f5RDRU4BnPGbXLWJRzyfJbVpzA00acQ0f5YZOCTJW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757371931; c=relaxed/simple;
	bh=hfXJRklhNrqNgOO3gqE89RdVEWhgtTk71OX57h5wA2A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AXk0pwkRlV6CakfTwv7iTOMQC0tq/m1B601F7g47djb8pA5XLQtn31h914+93vflIoMzzYt47oNdC/ORNbCCFsKSor5IhbMGwfouqESkQIsFVERo66lv1T1zRXisQXTLQborPcsGscUnLMBshfzAn+9li3asz7yQLZIP2aXw5vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ze9mQsbN; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ze9mQsbN"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-40809f7ffc7so6283935ab.3
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 15:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1757371928; x=1757976728; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K80z516Bkbs5y8nHg9W5TbWub0+guzt3PhdAiDrzrS0=;
        b=Ze9mQsbNh2Nfo3WZ3P90AnX/NRk54mjQM0fIbGDEbSRA/q87ZqfR9K4nP2lzlpbpGi
         SLTd5k1Y3KqiUhUGZLHr8Yx7y8OFnuFQHNeLYLPt6Dzo2dYc+my2gho3j2psLTl1Wqgy
         hWDFuKVFKVzK31RzSWih5n0SUDNLxakSyMyZ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757371928; x=1757976728;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K80z516Bkbs5y8nHg9W5TbWub0+guzt3PhdAiDrzrS0=;
        b=Tave3YBtTX7wWM0DoxrHpzwYxkAXttETww8FBMdfMnti58Au4Wod/HjRsNlozQ6vmR
         nt/VgWKbz4yXXuCOOHn4PBVcUsx50X7QmtyNx4oP7GHFfCeumS+IA/eBYfotAyxAl21s
         yfV3v9CCLtaERTVoMJSzEIzJmruWWLiYUPZom2aHZrTMBNEcyFYA7qKZWTpHP1oBvK4F
         WUUUK8+jSakCUe+Oa4ia90j+ytK6PaR8cqi0qGsdAKqPUAKRQ0K3Ko26cNrJIu/xEGLr
         azw7xzAyL3K+uDfv7cEP0bBHVwwoyKEy/mPL7/kGC8fo2Pir94bgiFlgm0N2t/luVkUm
         VESw==
X-Gm-Message-State: AOJu0YwCSVJuSbIhrfSfBzLOWsAXaPypouz+aWjy4904ny+wkrkuQUTc
	BaZPVMquYO5YhoyVFQ9lGBLRNo00+XZdpbqWQhHkJUhXbdNIjbx5M9Iw7opxtWyd8Lg=
X-Gm-Gg: ASbGnct+PPHqDbrL9qAEx8jXTlbjYePanzFu+mO1dhpziAc6s7uNRRkFiq5I77CatPH
	yx/RHf6+rw5IcDtw1sTPaQgQI2B+Pbww2UZcYsl3wCJIKQnlt4aZSuuB7/JQGg2/j89lPj2/pr2
	sUdjRwEa6SmryNC4OQ+slJK1Dmi91msVRLHP7mMuVQUReMRolm/YRbfZajVXB2+sL3PdvX7SCme
	m85RHu/0GrEtg6aV7ce+p+HLgxcab9ry5rdAqLOBPFuEEFCRiDuBDkoUI2A54WzCYWp9vTE7kxI
	Ne8L71v6lG06GoFBclyHafUPDkNjYpTAvILq2ms8v2x6xaJtB4KHZm5zCH4iEkI4rpF+CBlD0vd
	+D35sHR8OtaplFq0ARHdagmv1i03zV/6liAzYeUjqM70k4w==
X-Google-Smtp-Source: AGHT+IG0SswkXVluvMIZNs4Sx5AK4Z0SqnwhuqTZrY+edeQ0Pv/2bKDY5ow0cu/a/aQmpuNgAXzn7Q==
X-Received: by 2002:a05:6e02:19cd:b0:407:dc0b:7ba2 with SMTP id e9e14a558f8ab-407dc0b7d0cmr83195055ab.3.1757371928306;
        Mon, 08 Sep 2025 15:52:08 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5104c4caa4asm4555133173.41.2025.09.08.15.52.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 15:52:07 -0700 (PDT)
Message-ID: <3ad4dd69-7a3d-4708-bbb6-308e7d1b4183@linuxfoundation.org>
Date: Mon, 8 Sep 2025 16:52:06 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/45] 5.4.299-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/25 13:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.299 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.299-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
