Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9166928467E
	for <patches@lists.linux.dev>; Mon, 19 May 2025 13:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747662550; cv=none; b=QOOcZJPysSCuKyaH+t71ObpN55ISnhELG0ic/VnN5+N2igvuPZOtC8J1tWiQEAqwBWBAeK2YHUpUcSO58NJtR/riNw/CqGEI+a7wYOPA6mvLt+xKE+ZGFG1+Bizjz5MlML2M4jo1EQ7mgMVKtr2thP6/oYGCO2k7yx9nzP/Qum0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747662550; c=relaxed/simple;
	bh=+i5U+/q7DdYlgNftgdH0vSuewawjBJm+SKCR/+Dhxw0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nAmQ0LQRh8FwdytUoIzE3UeD7K+IVqnwP3kFdvYEUvZn6gANmHFv0D4539j/d/y+GQngpIw+ZIaYKOxxYXWYHMCDr+jFbg4VrnJR27DDjyKds90Sh9iE160BC+/7d/KzZhcHOrkTUcUZKQeyPPRmWVM9P5qxPlczp0EZ2ldpRyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S8k3ypBD; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S8k3ypBD"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso3955421b3a.2
        for <patches@lists.linux.dev>; Mon, 19 May 2025 06:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747662548; x=1748267348; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=RJ1rkLjdmDS4CHlLprOfdptidhEWdZD/FEVNycGC89I=;
        b=S8k3ypBDT1Q+6i78eGAA8GTZ8W2RHOOzwMbS/tmTBiimbyRX3KF7+dDK1FW4YcA8ta
         +z1vFb8qFEf+sC9heQ2AD6BokGJ37qEjMaohyxLt1/k9u0B+2HxPu9TNid5VBEViOPfk
         02Y0K/Rm6UUFuIdRSr20blGXea1M+YEykw0u3NYxVZ9nYhGJ5vouc9jHU8T/fXGgfVVm
         TMG8d33JpNTa6+sTZnDVYU8zJiAw0BPzqlTQF64nbaaEp6K3vqdreL3iQfsiZZRUy/j1
         aRcsyCKIv6dBQQyiddOmX9Zc4Zbwe/Pp0QG5C4H76c07G8j0vgpzK9D2KJuq1Bu50+HK
         abAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747662548; x=1748267348;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RJ1rkLjdmDS4CHlLprOfdptidhEWdZD/FEVNycGC89I=;
        b=Hp2FIpf/2xddcWnk9Sq98nVSa/nY/iEAbbkgNtx0nNWOY1efA2h9eYXfn9ns87aoV8
         ob5cpeZZXoyIZUvIb7IkNE2+wAlwsaVqOwARIGSlIEvdwP17XVrzIbQTOXfJhFeb7ckh
         Lkuo/A6PbZpRMIzrsH3uCid38/O1V2sob8xa1BJMOvMwVd2vC1mzcLb5d7E3pSOLeS0Q
         0HYkqV+AV6YOizKtd9KWlGvFlr1J3estzuXCFcYcSBru8vpykp5lDDkph+GWXkRZaQrj
         YCaZ5dQWYZmjf55xur9OaEt8VD7iM9MUXq8LY3F6uSnZ5VVhbFovC3VasQZxb20S44fV
         QBxQ==
X-Gm-Message-State: AOJu0YxMUpduCTa8A/Mr9aKazIreY8UnMzR9sUc55HuTSrDPoVRKblS/
	NTl7xCN+yo5I2hYAZP4JXlsFiPgC4w3cxUpfgueiC+hIWbBX3tlYnASD
X-Gm-Gg: ASbGncsE1fkgkbZ+Ps7oiU+2P6r/Z82Q8ZsiNYopALUyzPOeAGqI7k8jZyRdpNURTA1
	d01uE2duo2P/iukDZorfWuLK5CIzMnh1wCdmaj9Pu3uo4dy6Aoe8Qr15cO3GN1P8Aodf8Z/aNlV
	ZL3CSMCyW9TfnVzy51eCIACLFYnn8aKPZhJ29UGpam/uc9eRgzSaSQlUol7ooypCRCDlo+omjXY
	tWgYS7C/khugrNTX+kpg3ztJS2cTPi70oEAjZyvQcLqrnewcpzUtjTZf4MBA0S1Rgq9MeOzIku9
	+boEnjVKl8Tm7I/I2ujdHjlEv+eCwuPBH7wjAdTC6fJDDYetTYTWafWBc6XV8iHBb+bT8D+wcHs
	XfR8OH3Y5zTEtJ5LFJ8Oc07xTS1Fg6iikG8g=
X-Google-Smtp-Source: AGHT+IFxl4y+OpBihlKaxKp8TIKR+G0/FovbQEi/UJqI9c4lBckCiUeNmYkbyvnGR20bxM9jFJ0dgg==
X-Received: by 2002:a05:6a00:2790:b0:737:9b:582a with SMTP id d2e1a72fcca58-742a98de014mr17552211b3a.24.1747662547835;
        Mon, 19 May 2025 06:49:07 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a96e589esm6202775b3a.9.2025.05.19.06.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 May 2025 06:49:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <2f1ae598-0339-4e17-8156-03e8525a213d@roeck-us.net>
Date: Mon, 19 May 2025 06:49:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org
References: <20250514125617.240903002@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20250514125617.240903002@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/25 06:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.91 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> Anything received after that time might be too late.
> 

Building x86_64:allnoconfig ... failed
Building x86_64:tinyconfig ... failed
Building i386:defconfig ... failed
Building i386:allyesconfig ... failed
Building i386:allmodconfig ... failed
Building i386:allnoconfig ... failed
Building i386:tinyconfig ... failed
--------------
Error log:
arch/x86/kernel/alternative.c:1452:5: error: redefinition of 'its_static_thunk'

As far as I can see, its_static_thunk() is built if CONFIG_FINEIBT=n,
but the header file uses CONFIG_MITIGATION_ITS to determine if the dummy
function should be used. The redefinition is seen if both are disabled.

Guenter

