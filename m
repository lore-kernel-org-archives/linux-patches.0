Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ACB15D5B2
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 16:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709139449; cv=none; b=DgrQ3AGz7vN9tdb6CEOmu8qZdQ0mPp+a+QwojOSYLXCbJPSJYUP+2OZJXVDWaP2mUr3ggkoLVN0tmadA6YjOdbcDHa2TDis2V8qccSSNGQTqvotT65IRglRMk+gmQj4RGQnzLnfxgyiEWo8V4VTso4poLxcgHSJ4bp/mbfFHCIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709139449; c=relaxed/simple;
	bh=/2Azqu1VyiRaiAF7AA3juHS2VEk/q1WqTNt34zVPHsU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jtDqzv2SdD0+/N58ri5eKkyVTyX0UrgGHAzd6GjXnM7kqzoSesyl1x2oqCwCAOuP3Inn8PySDw39Qbq4yPZNKuoy9Nq86ZT/y57E2NIyZQSy4Hhd3sldJ8Xzd8LKtk4787Q9xE/qNFRUJbw7jil6hOJ+HXHG096TnIT0wWysQXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FMoS6WZw; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FMoS6WZw"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7c49c979b5dso114353439f.1
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 08:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1709139447; x=1709744247; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HNUHzB6bTR8lkrQrwB9JvKFIHk8OQ9UNvaD+yVEbMY0=;
        b=FMoS6WZwZA5QkH7MImsNDkY7V/QYHs31edIykuOuaq6J4QmaKLZE9nlPsDAS+wp7o7
         eIJmy1qsA03V2l5+fsUUbeudTe6XB+VDRVzA5vZKF7ggK+QMISol2sBRriK9HrRT4TgO
         yJeuavnYFPT7PnJgthKYZBfFmQsiIql3leYXk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709139447; x=1709744247;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HNUHzB6bTR8lkrQrwB9JvKFIHk8OQ9UNvaD+yVEbMY0=;
        b=Wgtlax6Th7q/Atn9klEoMBs5INCyIk5aslec/zlx5RkyvV57Bjw06qX4rZ8KRrozf4
         pcf+yQq5qgKVJXGf7zJyAJ1K31YINpEWdtfdQ9mPKl3Z3qrFcDZo/dhh4DDverPNCkrO
         hnhOdX6QhlHJgKHz/3FszHJLcoD/PFxEF0EVvCpLdMKRuO1h2iDXMpV57JSj5GlA3e2W
         s/Xqix9/Uil/hzW/8gNyifyFoFW91G69iSWLR65JyO1Ox4Ijcfx53Esr/4NLSPD4xBsV
         ++31p/Rno57EOV5UzrincZgAACrGj4hodvMbip0KuKblAKDc6Lux9ipURPz90ejzNdjt
         iKsw==
X-Gm-Message-State: AOJu0YxkPGneZrF6ITlUPVPlZM0LVNbJkC7QVKwrStHoMtcjxu5JHAe2
	JmqSe75ZEef1Wooct7DDK/ZP1nyADGiJ2j/2xWE3JHOI8Az6SRMSxwR3elP/9Jw=
X-Google-Smtp-Source: AGHT+IEYqpBKyp8I8JnTiZT8VG1R5X6EV3Xdx0Ok2vStet+qqfgqgLz4QUj/IMZf8xcfL3JAP7OUlQ==
X-Received: by 2002:a92:cda6:0:b0:365:4e45:33ad with SMTP id g6-20020a92cda6000000b003654e4533admr12522573ild.1.1709139446863;
        Wed, 28 Feb 2024 08:57:26 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id bn29-20020a056e02339d00b0036533cae5afsm623565ilb.60.2024.02.28.08.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 08:57:26 -0800 (PST)
Message-ID: <fa711f78-98b0-48a3-95cf-594ff41e0998@linuxfoundation.org>
Date: Wed, 28 Feb 2024 09:57:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/84] 5.4.270-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/24 06:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.270 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.270-rc1.gz
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
