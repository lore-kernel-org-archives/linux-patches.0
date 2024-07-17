Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5182C181BBA
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 15:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721230937; cv=none; b=rguC3LgxmmmHgEuBFQFvqneYeWfww3+PYZVnJOepYJAt1otQHVdrlgGu1Z4Ww+AnFuOLUKF+X4Gtw3DCuNiEEA8Be8MOscqfDVgxx6C2OjBOXHmr7FRUUWCDUSSlsJRyijZ27SX2aF0q4PE6mLPi+d4FLObh4/jHqFmy6RHndXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721230937; c=relaxed/simple;
	bh=vuHvG5Bw01x9b75iXfvM8x7eQfEWf59Y3BamQMGwG/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jKJ+eCM9+QRhLKh2gGkraZGqHrE+rrlDSv3Jo7ss8x15Za/r42tAowzfya/znKbkHAlOaFidepEWruzzaStBSejHR9BeC6Uzbx3hE40FzU3tnfiO+X4NkdT66kaHRPex69i2lexdy0cTUzUeEtV0zRKM9Ase1SmHeKaw9UpxYI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhFI7z1d; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhFI7z1d"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7fb4ac767c7so3763139f.1
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 08:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1721230935; x=1721835735; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1cPjwCBYBm9qF0338CZIKw1PFkwmH858FXYIGOpiO0M=;
        b=hhFI7z1dLmPQEzJ6El8eqa6S1EOgUwcuRvT/NiMu5wl5heXYHwzPhSAPhthQ4nGhkh
         6Z4kTfPGq2GBMHtHV3UXWSOiUHHgZpHcggvtL5gTL04rsw/TPIDNcQR3NKqBdF/QsJV9
         4mGrtuW9gmOav5mTvXEGMlOhkFfOz8BtKb0bw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721230935; x=1721835735;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1cPjwCBYBm9qF0338CZIKw1PFkwmH858FXYIGOpiO0M=;
        b=HP1qup0EdTWm+N4N/SNat6NE4pJ3cE2I/O20ItszOF2NSZYLELReo1aUYkFsK/61Ec
         5yey2WYsbPwMshlcah26g5vCT8oOZCnj4XNpPdMtxjsxhLHmW7CAfgmGOFCOtUHKWMFD
         0EnuRBUeVDYjHr+uqPC8YWS0B8T9WqyH2K3/W9F2uix1hsDO7Hjok072bkok7wsz1oGp
         vaQGtnHd4N9v0J9/iOlMNIc0dnRS4fqCzFeLFvLp/e2yHUA83lSdDSXqH//iW/ReZ5qf
         XNGtpKyCAbDUU1igQrkiq7aoOL3olzDupS5uEJjfcokZHhVFxmdfGQWxOip1HFtksleR
         hRdA==
X-Gm-Message-State: AOJu0YyoQF+R57S8PCZQgQp07l3E1zScSfpZdQjLOZiMLWOb1NQ4SkvC
	HB6z78Ah2+OqZzjvNFenxYJ0l73tAD17JTPzxu9EVE9Ov1SuHLmUxrzOIWPk3hc=
X-Google-Smtp-Source: AGHT+IF/J+Fr5qIJKCpkhnuE7FiXLaULtb21qr9MB3cIRutKC2vqJEtVHOTobpt6Y2/K0mg1P4vPzg==
X-Received: by 2002:a05:6e02:b4f:b0:38e:cdf9:8877 with SMTP id e9e14a558f8ab-395579e88cdmr15685405ab.4.1721230935456;
        Wed, 17 Jul 2024 08:42:15 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3950aee0d17sm8345205ab.8.2024.07.17.08.42.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 08:42:14 -0700 (PDT)
Message-ID: <c843e23b-5a8f-4f58-825b-7faaa2988841@linuxfoundation.org>
Date: Wed, 17 Jul 2024 09:42:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 000/143] 6.9.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 09:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.10 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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
