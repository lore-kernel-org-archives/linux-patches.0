Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4471F7EEF0
	for <patches@lists.linux.dev>; Tue, 30 Jan 2024 22:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706654958; cv=none; b=NpsHGIt1HNilGoLK91MfUSefb0jqMAe2y+DMa/opBEeaSyUc7Pfzhzeik5Ad2yrQHM9QDyntO+UNjYrUmrV6d1YjbS5BoQnh+Bz9F07nSRTdcWEg7WWXP1eNlz6eWTXnUmBpuxJhdBSXKYxT328rj2TokGSm8FCRjNJrywGwXCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706654958; c=relaxed/simple;
	bh=5PEbedCvlPcPx2iTY5riTWdi4LRY/hHKOrHNlonDI+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KgTx1ylJwbG3O/5oLqLD8PhwPaFOST7miqNcqdBKhRSDNCcUvbdQHZOgyOpv6TTZ8byWlM4IJxER2+xxbg0G5SBfdKP44kzKdv5hDtGwW9xH+6ovVz6/y9gm7NgECJh8EyeTig7/JkTGPtMXRppSgYSdLNWoWiJWD0puVbyZidw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nNohCYCQ; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNohCYCQ"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-290ec261a61so2647156a91.0
        for <patches@lists.linux.dev>; Tue, 30 Jan 2024 14:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706654956; x=1707259756; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bq2zWShlBmwvfZivQBNk/q3mwb4pxGumX5VXlkn+VXo=;
        b=nNohCYCQY6A93L03+rmU4HJDIvh2fLWWKQVd2AlIWvIITmpjEL3+tug8/oK1zx0fUo
         +chFhTFZKrSeooevQtHCn8GizWnkEGrpjKm6nXxzn+nHMMnoV4yn5k4+tXUlMqrbnJmo
         DbQdeT1lGTMkmPGHuw4hUJVQKCtqybMAv1WTsWFUwDTj2rcm1NBrsO5JUehInNmF0pfO
         caaLOkmjY/8SqgqbNKopVq8ivv0j6ZMiIrUgOgUm5fkGef8QlkxdSzCWo4FUNgNzFc8g
         4TWQTaxVvn+2IaJL+Nd3BQNr2+ymFeqUJlIQVmbjd6DIwghSMvBZidqrTNsUD59y7xmg
         f9fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706654956; x=1707259756;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bq2zWShlBmwvfZivQBNk/q3mwb4pxGumX5VXlkn+VXo=;
        b=qSmle1mi2tOhwZXsTrshzrSvxjlnbV4OsDbTlGzXAU3hZBMvgTAcX8uym483+zOPg5
         TeitICM1ysZ490Fe4beQQlItSISkiGBs6XyUBZkLBdF6BRWxzuIE991xm5nU5CoKL4Aq
         XT3Bgpc3/fEx1ovda0R6+78pP0g5sm+tMH+bVkI+fr8S8dqlqP98iBq5mqPsLoAOC0Vi
         SD9zn07ZGMQ27AICmf5saFDvTOygIQbHsTZdl54eCYg6Gzv7x8o1hWiYRdRMi7qOEhUJ
         gWVpGTwYGEuACk3nD25x2v6OMoaLxuqzKR8eYLj7i6IQsSdCDkYLVo5JFLKiHJpOrZEC
         khiQ==
X-Gm-Message-State: AOJu0YwHcVciQSdRdLfa0vp2bVdN9ylAi3yvkQOmoKyQjZ8dtWqMKe5A
	IXeWiezZbL9tHPD/MSJpnEh/KD8PXAtKatz4sUfwjrhX1bv2XbxQ
X-Google-Smtp-Source: AGHT+IE5nbC8dbVwlBAa6gngPdGysmSFzxXCWusY8Ypyqkcrhf5f3HuNcFbRnl7n3o/Ym1zWisMCAA==
X-Received: by 2002:a17:90b:e8a:b0:293:f625:1b0b with SMTP id fv10-20020a17090b0e8a00b00293f6251b0bmr63974pjb.5.1706654956398;
        Tue, 30 Jan 2024 14:49:16 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e16-20020a17090ac21000b00290071b5a93sm1064161pjt.0.2024.01.30.14.49.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jan 2024 14:49:15 -0800 (PST)
Message-ID: <f681ef24-b854-40b5-8179-eadf69e63a62@gmail.com>
Date: Tue, 30 Jan 2024 14:49:13 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/186] 6.1.76-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240130183318.454044155@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240130183318.454044155@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/24 10:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.76 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Feb 2024 18:32:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.76-rc2.gz
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

