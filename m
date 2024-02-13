Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7713627E6
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 22:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707861824; cv=none; b=NQJf8OAJsReggXiioMSwbAaOI9BolpQ477jEYMTcmWZIkQlHgTzqip6yasEAcyNO5+tT0VRY7uaFNiAgP4yvrKHP4NFaFqkUh756o8fEuPrdDLF1CrkwXROilGPwZOAYl9zrrQuaqX1TbyNYzEu6Upngv7A297fLj2pzjnQuiGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707861824; c=relaxed/simple;
	bh=ZN/ERQybVeyach0ht9MlIPex+bb6wOcAovzlJrtd+n4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c46piih1SD2b0ji+XyLqOkHx5sastnCnfma2iujtyzm/w5FC3mnV/B+7c1Zlspz4ZlGO3ilXHXczXm6Kcy0QWmCcziHBhq6yLDgQey+zryft1MR+U3oWcnG6telTTS6+/ADA9FmJu1QHUDrEeIDL1euogFXkHduftgXfZ4Gk448=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HL/dUudK; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HL/dUudK"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-783dc658bd9so226110785a.1
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 14:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707861821; x=1708466621; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I2HXMDB/MGTQCp5MFRiwYdYl9rpm9iyOypkHduc/gLg=;
        b=HL/dUudKRuuleGaIDu9Nd1YuknDfXTMOqLL3XOKhUHJyshpehP0eO+bqLCgLT9JSQN
         9pAFoI4Q8bkgpU91FnVPAB+rqsdg5kEKt4eYFVo0As0KumxiQBFw2W/7kH0pyApuM9pl
         /Qof5NMPqvUz4GvOlmFsJ3TGBegcZRd4cBQVSpn2Zu51SzXkJPfVHqLBF3zYRxQm4HWx
         dbszk+kwT8dybDear1T6S4IYzG4uI1WrMmqp8Up6oRruiLs8DNRssocpmVNUHG3ZOSJV
         f4i/mIE92iEpEsD+wAVA/lKYqG2qIbqLABrIKtPxZwYZPJRnIr5AHThmoxE1JxxOQJAj
         yyQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707861821; x=1708466621;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I2HXMDB/MGTQCp5MFRiwYdYl9rpm9iyOypkHduc/gLg=;
        b=xJweAahkz1sec23ru57XpCGoh/O+mD1OIk68WhSy33LOimeloL0fcBrJlnaSTzJDuZ
         1sgpx/dD5PjQ1NrbZB75vgOleR7nT6D+iI1rH5dJ1aKV3aIjLtsw7NY3zP4LcVUnxreV
         Nmj2o83O8HDVCBXax9/f6Nk01MbzMXVdbhCgUiv6KQIlGbkdLh6C6RzYYCbUvUbSwH87
         NKqGxZA08LtuX8GPkZugykIzQkzQAYiwmeYXMVFjY2zMvTIjfZhvfc835eE8jNolgRWF
         MIiXQrveIUHfkcnRrZo8LymsIsW92nCZ5ZRvcUZuF7ffLWTlospyVNjurDRJSgnRBVkD
         q/IA==
X-Gm-Message-State: AOJu0YzbLPZwlXgTun29pJJenl7nGfP+AxmHscAk486Pqc15UdlYZIa7
	tVH9cu+2Zi0POoqWaAxiJAkTAKE4GxhDsYn6QY9BVo7lIfo0t/gF
X-Google-Smtp-Source: AGHT+IGhZcXrp1agoKvRRle1EnMepwO4A7TW+UC/jmdeFBAZawkSzsugIYbzsOajfD4xZw5xSn1fCg==
X-Received: by 2002:a05:620a:4612:b0:785:dae1:550f with SMTP id br18-20020a05620a461200b00785dae1550fmr1197929qkb.6.1707861821639;
        Tue, 13 Feb 2024 14:03:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUJOfKetfgi9zVioqweyExdTNWvgGz2UGEkSeFdTWJRhTXozFtK4/x7UZGzEmo9kpvC4+INZfWYyZvpTqxL8tk35KRMPEE1I99LVjIntgNuDZjytf8Nd/xaBfzdMwrKlTupt0a+ckqB26Ldsp4iug2jku1MvdYY8mAfvhEnBYc31BAnq+4ATKm0Ve1pMqE+gZwnHtNlyWgu1RTMJOXd1FTF9fTqBg6gVAoPEDEpi+RQsQDRE0E4AECaMNhkx2BdELp8mq/CyCRcWJp++mRXQLZTLaTfXWnU7VALKNp91bszzViQk8lZbxCh/pRUkcpbYdDkOW58a7tQR2ZQjA/SXVFDnMoHc3veEeXVeXwLXbaNOSDsuCdIyr8RdlvNgyIKtZwhkb0bTT9TSr5z0gxy7/xEbxlHQuWRyaSiA9n2Ks7/BHG4rHMMN+7vFUu05TG61a4EzQ6A9dD5CsLCzjExjpEt4BIz2ze1tfW4LQZzTAivD8Gg5ZCtcNnW9HmUz+ofdn0ghzOGRe6q
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z3-20020ae9c103000000b00785ae649de0sm3281105qki.97.2024.02.13.14.03.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 14:03:41 -0800 (PST)
Message-ID: <56365edc-c073-46f8-8bf9-ead7cd8c9d03@gmail.com>
Date: Tue, 13 Feb 2024 14:03:38 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/121] 6.6.17-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240213171852.948844634@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/24 09:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.17 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Feb 2024 17:18:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

