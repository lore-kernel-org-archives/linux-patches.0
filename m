Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D7A183CB0
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 19:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740511985; cv=none; b=fu+qhQ5MBTBIfnNBzGS8pTMyPG7tddsSdZ7klxajYQUoUpFblrso9wIkyLjtsdeSCgL4gSlYpiWrZnuJD2Tstw5ZRIaxoiIfIZTIsX7ju+86TCQeCEctjgH8tpLnrKYF61RLTyuTxRzX9w5IEHz7+wvla9GfKyMP/y6fwjaxpOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740511985; c=relaxed/simple;
	bh=L1/3SKc8l7iQDSrFmOoDCO3JUgx4ujK+IIIgTIEi5vc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VAm5OxfIE0NJ3O2KG0h1J7VLnTaFH8e75VcNNylNSci8KLfmqhogQ/sID9Esa8VXClr6/djcmlhNFhKd1C1xwuK23Z05NmlzJmu6o9JajSbSyhY8yAzmR6otmL53TJkoblDvmGNE1oaoGFWkRcCQblyZ0r3y3qCFN/xnNlqSOzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IyWorPhx; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IyWorPhx"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7275bc6638bso923140a34.2
        for <patches@lists.linux.dev>; Tue, 25 Feb 2025 11:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740511983; x=1741116783; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Miko2TmZIyxQH+Gi61JnK9vZXA4QBkP1Yh5ec2O1TNc=;
        b=IyWorPhxBr1knNiTmMK0QNhg1JRuzR8bIYYboW1Q8OYvORDncj19T1hAUqWDmGfrWh
         uogh+ETgTGKkPaJKOzIhBeqV9/kzFZLKORtXHbbEpMjd5ygN8k0MWcCCaDIB3YTlFcD0
         zWaVM4MDgpUboQq4oKHgif+/RLsiCJLV0cEOQM1/Ftpc8TIl6hzJWKxk5rsDUYWFUDCu
         PoCH/8tn7Lgjl8YpsypGFQthdQ70ZTXPWdag5ihts50hGKXNiqeQLP+ZsS+JKye0YekN
         GGhrxAPVd+TwTGa8wBhc9hHl4ZPf0axXNSswRzcawrccdX2GjQaRT1peHukb6rdnayC0
         NE5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740511983; x=1741116783;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Miko2TmZIyxQH+Gi61JnK9vZXA4QBkP1Yh5ec2O1TNc=;
        b=CsHHvua1wqqMZ+irP0TO5XKic/9Zn0PcmQVw7Q0Oidn5+Slqge+gHOzI69OPlLmhlK
         Xy0pqCWD9qvxa1h+at5I9esxn81iz2iRLup1fShxSXBNXVjsRcWqh0dD1BX4AiqU0aMq
         6X5SPqnyfAipfzbuM4EEp+nA3xwG3CW/douXSCBhYK3Ad0fXxm/k+ymyQRFqhn08gfDL
         wfCuQ9R/WZZqR44y6qz48t7spiFz87Nl1bPKHR9lpmMF34lD+kwIC9MlHs2qWncC2BJL
         /Fp8J7hEYFxS/M6+/KfZRqHSzPUHaq5FQQFndo6DNTmDBCFA0cr4PleJ8yTuFmKnRpED
         oCjA==
X-Gm-Message-State: AOJu0Yz0wEIJM/yGnFHmbzux7F60kruz53ReqtY++q3BhL1tfndEQmTB
	fhNR7Re1hCKmf+ugEKB3nCDOPNh7VBt+JTJ2IDTHIrXYQqLwrX9f
X-Gm-Gg: ASbGncsknTFyWYSZciVxbXpEDS4P7P7PeBFL7Wjq+GqGy4ImOBsnpLG1O1zL1K8Ci1W
	YELIcrdPaz0x5BQnANP6lTMWSPfZTVxMR8asrdUR43/v4hADTnanyMvGogo/LOIb/3WniOJXkTv
	RSc9oKyriJQYrShBg5n5Cbz41C6AOI0QEejjI3qVz2mL6Lm/6TbOhTSvr7Z2fMDw5yJEe16aFWX
	dKLs5EmF5m+C0RkgBiafUCIeWaznfVwJ5X3cxTgiDHxqPJrkKvSBYbwna8N37zVVCx0kOhR6N4h
	8qeUkXMHoInV+bSeMh22X85LOuLXYX6zeEKc/gnDTg==
X-Google-Smtp-Source: AGHT+IHQ3RLf2c8orAvsF44RAiI7PLXG4mCbFCPUQWf5N1ah5oJ3kD0yAmfLigtS2jv5wP03VEOwQg==
X-Received: by 2002:a05:6830:3590:b0:727:3692:149d with SMTP id 46e09a7af769-7289d0f181cmr3630523a34.12.1740511983028;
        Tue, 25 Feb 2025 11:33:03 -0800 (PST)
Received: from [10.69.73.201] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2c1111f4c55sm515413fac.2.2025.02.25.11.33.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 11:33:01 -0800 (PST)
Message-ID: <2dba0ec1-52e4-4ca6-9cc1-14243c310765@gmail.com>
Date: Tue, 25 Feb 2025 11:32:59 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/137] 6.13.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250225064750.953124108@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250225064750.953124108@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/24/2025 10:49 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.5 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Feb 2025 06:47:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
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

