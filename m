Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9AA25A2C1
	for <patches@lists.linux.dev>; Tue, 20 May 2025 18:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747765167; cv=none; b=XsIyW07CVm8i8nWluHx+3rMkkIkRJPUD1+Rp0i7r7aguekjF+NLzMmJ7u/XToEUywXlQyBLCY2zQDY4zw9UvZS0hVDtkHauqn6+Nv182LcxRPmoqqj9jdz629k18T3lEKSoVBV4BW0Cj7tAriwox3/7OrPCgMQkz2LjIl8VcH0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747765167; c=relaxed/simple;
	bh=IxR++kloUJc3RyylQhbXGp9wRrX6m+pcg5jG15OjKas=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=doxmjNCDwFNvM207X2bvVcyaIp8ZBzxPW9ysnzlY8Ty54Pqf1P+wME4NW2L/JspOlbyhSg5KJKBJuCu6Of0OdexwEOqEA9ICF3sMnfNd+8wKWNVZqIZwKGmqm8SdZEwd+QOtcrukz6dMl87AM3nrQQWDpfcqJFZwoSabSmPKB2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LbLpQxuG; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LbLpQxuG"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-23229fdaff4so33991185ad.1
        for <patches@lists.linux.dev>; Tue, 20 May 2025 11:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747765165; x=1748369965; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=DoKyA3bBBGJsvFy+XPHReVuHpiex51sJQBrZyjvoQcc=;
        b=LbLpQxuGv2uTBIwbrTtqJf+gVHRKuHz0qYAxwV3h83kWVu5D3eYe1A0trGl5KSgKGq
         UFzXFGnOZ+2Jq3OnA4u4KgbXb2aMLOsHjYoUP5ylcdupXmSBa1q+Ro44mh44Qeu+Ytxa
         QRE1jqamV8tW5wPkg5YkTScHhoMNS9BhLdkMEXXtjP7YKwRn9nQv80GRKS4jAyyxlouY
         Cb7oL9TbrOSI/jp9Vn49DgfIiFLSTdIukLvZFmYC+M1AEB2LdQwnPZoOfJ2MisMPpD9/
         YwlbB074k17dA9Jka0RUuRSSri2WZ/NSSxAWsv0BsOuxS0/UE4WECX20Eeu1xpoMsVhB
         rvMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747765165; x=1748369965;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DoKyA3bBBGJsvFy+XPHReVuHpiex51sJQBrZyjvoQcc=;
        b=eYLxbiGiNIsOFblaXSGjsX1wd/RZGIEyGSnWM+gS/IZFR/T9XC3sZMH163G3UKxP+H
         vnRdpBTdLxZ9b6fkJh/xwpgnJrMBHHi1LQl4kF9A7/y35iBIQm4+2qSMbu2l+iFt/Vke
         UBP/utP+sJHcDIUxP4YBT4ESARGpmP8o7u0aPhyaWWM23Cpmxk9I80hrLDc9AiDNP1qZ
         uhrlDpQ6JKnyeHY0dn5dHJJayl3BfD8aX2jjGVQ4Cc7gyReXf7GSZk7uG4q6WwailVQI
         TYhNmp49gbs2OTewoIhlX8LKVZvTQWwlxjOrSvRBu3AC68uCKM9a/fg33H0RtrhjAsbo
         WuZw==
X-Gm-Message-State: AOJu0YxZxO0zZJZ1AHwFjgH9/BodLE/0U575w9lQRNrvh/xcIcnkoGTK
	B1ZmjBx9ptppyJbhHhjzbDIBNHxWH8PPr3uCbuOx6B4kkCvbCTiP/BV6
X-Gm-Gg: ASbGnctXG/Z5qgbe9zoSlzEIrPZe3nWmHy89EtYSU4m0tTGSYFK7v2H2lJn0Itf+4Ht
	4SIevX7kTExCOIIgI6991faukE8aUxkwW41r2xCqBb5Q3CKYmOt3/aUIowRBTqbtw9fwPk6IG80
	eZNBx0ERwKElyktjS5leoLbzbGvPKxo5opoGf6GBC36igq8C1+MsIBo57GQ7y/bZXJTPBbNsXds
	XgkfRbhXyC1uwvHq1WKqzUYu10q3YtNeO8BiJyMFIfjnD2edS+qc/xRQPhJXITiVGWrIWmntM6t
	UlJnHNsNvQO0eeA6R9fwbNe6CQFWzpTkmxCG5Yc4YLR+ofAztViRHDsJafLH45QR2Xi3VpS8Us9
	zxNwgVqs0A1mWew==
X-Google-Smtp-Source: AGHT+IGwQsi+8LxueG7nm1aZmo1UnaHvJZf+HsSsQQMtspoPLyCUE/TSSuNXzyEMuI5THrd+rgbtxg==
X-Received: by 2002:a17:902:ce01:b0:224:194c:6942 with SMTP id d9443c01a7336-231d452d6e8mr274361115ad.34.1747765165516;
        Tue, 20 May 2025 11:19:25 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4ed255dsm79721135ad.213.2025.05.20.11.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 11:19:24 -0700 (PDT)
Message-ID: <cedb87c7-cb1e-450b-8d83-62b2d39ceea3@gmail.com>
Date: Tue, 20 May 2025 11:19:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/59] 5.15.184-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250520125753.836407405@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/25 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.184 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.184-rc1.gz
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
