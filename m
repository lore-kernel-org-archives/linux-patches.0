Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141CE43AA8
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 18:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722018194; cv=none; b=Tl7t/yTJI7vww9LN0UUU3c1qgfX7jqs0eAOOgzi6/mFdeivzq3kIqDziNFjxMKdRcnMHAfRA21EC5z3W+bwtRovrM3IZ37tA6ym3eYuTC+mpFQy4Diw3L4Tl3IFcmGoBCpGK8cYLKPHwBtidNK6PpUinJjks8NwzgcOGbvwbHDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722018194; c=relaxed/simple;
	bh=8ZbgTM4bv8/Dutf4flCW2Qj8W47CiAr2L1IPtzMfwDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FumiSSVBxCGlUiByDXqirgXwkEyJ/EZJM2Vm9AalJv9VDe9OjGYMSeHXkljtYbXkI4lyWMP9R8yQtaBkX8wZgk2YqEBp3hE10L1xmlEOqrO/ebQvxav5zzohkVp1C83CmIp/iNJL7XwCR2loPEkLt0ORYk85BWSsQ0cmlj0NTJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ba4HEMBa; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ba4HEMBa"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2cb64529a36so920129a91.0
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 11:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722018192; x=1722622992; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KIJ5Vdb86u9FSPZw1NlhK84OzeGR0ySDutwUA1pkvxE=;
        b=Ba4HEMBartpHCoR10qpF8yJfYauAVxtIyEPVxT6YdYtAT/rO+LkHqQj8utD+gHM4yX
         8fPZTlGDIKZEsBLzcNWYwvH8FLnJXGV8GFx1dTNqcEFeJR6fh7dLiqs+FNDY8/NwLHh3
         TEyg87vGxKVkM2hTYF2jVQTvMQltIdf5H8zHY3SbQ8yL2MkwU+SGw0cOlNcvG8aYOJ2W
         6UwhxZOhfLqOwHuyhG7r45JscnQneif4vbtwCkMqbaAvuVRqZdyUSoWTuOyWgxZKfOk0
         CmKmZL9wEN4CKGzahRgOGquBVILyk9L3ez7bu7NLgrZLibe4uJR7c613rd5BJyH5l7as
         ogdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722018192; x=1722622992;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KIJ5Vdb86u9FSPZw1NlhK84OzeGR0ySDutwUA1pkvxE=;
        b=TLjZjcyzWtrNYxWye5Z6aLq3M2rMEH6/ym9GyEdabRfzIgQ8QRn6LVWT0Ysze1ZXbO
         c8cKQ4mzzTE1ymwUxu3R2XM9+ST73HpjqlBbh98QWGOUh5W24905WTWHAiW1Jt7TpsES
         +kgPtLK/g8dIOCJanlTfNbOGFidldSkydsCksLqJ+H4gzf1/J20vvB814wSFYzV7eDij
         vPSdEbTF8FA8/vmuvUk8NtR9YZpvXJOzf9wx9wgOL0EbnuE9ParTDi60xNFbj268T9zg
         1fkpezThE5SfOO6KwkylHL4+ML91/Ky2B6QliMZYH7vL5EZPzfEwVWvSjUslO9uJJCrK
         8ODg==
X-Gm-Message-State: AOJu0YxsPT28IBZY2oDngY8B1ZWUjX8zy32Rtn9xeOBrYR+P0pIrHDJ7
	H902fIImOdDf+GafXoi8GazmvR3LohCfLtsvwsPs2tbsNnyD9fn+
X-Google-Smtp-Source: AGHT+IHWZvLD2KSc9UvLW/4dy4SoS0vzj/rrNm/Vr8V+kM/iz0DSnCcVxsNazp8DmgfomClKo2PPlA==
X-Received: by 2002:a17:90b:2647:b0:2ca:7e87:15e6 with SMTP id 98e67ed59e1d1-2cf7e72bf48mr350073a91.38.1722018192312;
        Fri, 26 Jul 2024 11:23:12 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2cdb7600054sm5813739a91.47.2024.07.26.11.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 11:23:06 -0700 (PDT)
Message-ID: <f185d728-8545-4962-b667-e761acf0fde6@gmail.com>
Date: Fri, 26 Jul 2024 11:22:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/16] 6.6.43-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240725142728.905379352@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240725142728.905379352@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/24 07:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.43 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.43-rc1.gz
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

