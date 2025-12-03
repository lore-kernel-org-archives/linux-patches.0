Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C382D8791
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 23:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764805668; cv=none; b=RtY2PBq53WC3w01vwecqbe73fRd9g3gJlyLEKrx1Z1Jr4pUQ8D0gwlH6uXTHXjUFlNp1tA99k00w+ENJzjDrIBbQpxduCUWZQoy8BnpiMeG+G8xfLes3IUakbJGPIAlkQGLRDsuiEeBa/RTrgnZbRojC3XVI9jHpegbazgyY6tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764805668; c=relaxed/simple;
	bh=gTsejU6waB4HvsDl+QP5oKKn5v8LZxLg+lNCDGEDGvM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SdnukSS2gNgauryTEDYrmqvdqAYAbwS9pgzLCYmFiuXU+HmelsUxasVUqskhGH1lLUeogQe1nl3y/cyQQycJlqFWqb6+2QtczwwEvEo4DQqniGkXTfAy9yt93edtoEbqIwHMO21B4HoH/wSLa2iwxPTO6fNIz8iZyi4d9Qg82SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acCdgCJv; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acCdgCJv"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7c7503c73b4so258599a34.3
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 15:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1764805665; x=1765410465; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NpEO7mPLNja/i2RVtaH3h8uU74uxJ0yZRdd7oKRDmXc=;
        b=acCdgCJvrQj65EIdXjR+Vb7Ih7oxqGfWbipHi20KicHc4rJ2DpPKozU0gwP6KCSE+o
         voE5lIhuUs+VWPi45jXWBPvhJVHR46M17nOGmWKkU9iEwDnMGwJBN5MuJDd9f0F8WbKE
         kYKGXEPLeNR60bnapbvJz3DGIh7MQaE1iBHbc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764805665; x=1765410465;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NpEO7mPLNja/i2RVtaH3h8uU74uxJ0yZRdd7oKRDmXc=;
        b=PEZXFqhUBixc1QrCpn20V75ZXzSKRivvUrwO6V9HSdb2DgGu3wWBl7zXkngvGxDx0T
         CcJiARTIM2LjY3uUm038skzm9sK5iOp/RSoCL9p/3yv7gAN75uJdADG0grl1h8JsS9Bd
         /fKH4BPv9GT1DjjVCLQpwH9tkqYSow5+4XrnCijS3wFZn91/g9R9iGNxqm3fp+gcE1EZ
         Ww2I9qvQmM0zYNPgTapelC+jz6u6T82fNTm9Ug/xcvwQ8uSQsZPxugme51uGyMNynsx7
         JlH7wfo5CvTf9TQaqdod3y2wtKGBSqPKD3Lq5BIpNBFf4PmvuY7Pu71Bzd5r9/x+PSUm
         Zkzw==
X-Gm-Message-State: AOJu0YwkaNeZP/mvYRxv3/y3BU8KEBIFezcQQgtUAMSnAbW6ydp52iC7
	PeCc8DxjATozD0Gc3cr1nOIPBjvObbiv/OLtw8sqtm28Zx4QxyaKbYvxUQ47LDSyaGc=
X-Gm-Gg: ASbGncvhey8LYNAfuJJD0SwDn5kp8FNRuy/ikE5YPCQajzgUwiI/8i0jjihWPbKeaxp
	LtzQWBmrL3NbAefxyY9GiRHp7npB7hdZ53Cdt71/N9Sn+y0D/cHEPH6KTpuyUPNjLVg6ybZc/+M
	RhjoLkXFzrdp435fpLagwEefteSy9nekkD8Q+gOgMKQ+61dcv06HrqP2ZRGlTh1nFbptDOcObPn
	alR+yrTExGXfQ2AzsuqApexHKmRSEuttOaoKPVWkScjMHQGXoxPhNox4w92JI4qCo8mKiZdYTKD
	F5zJdjWBT4Aey6HyD2FXboR6hywdQA5tabiLetMnauvBkRC2dwh5X8MbdXU3DuEwfZwfXDJ6OHy
	Td9lwZTAfee2cojHvwtWLDsR1xewWDhmcnyL9bkclpgOw7sihToTf4wPOsynGXgOOHScyQirnrA
	LsIp6DKGmBXLmEYuzyAtVBKsM=
X-Google-Smtp-Source: AGHT+IEYE9EPukd88z1i5cAmvv1+8dEP0hdAZd65CqeILIvUcSKk6z1hmoGXKlyW5Nz0aDU07vOoeA==
X-Received: by 2002:a05:6808:34e:b0:450:f45e:f4a9 with SMTP id 5614622812f47-4536e3f88e4mr2143895b6e.19.1764805665453;
        Wed, 03 Dec 2025 15:47:45 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-453170cd4a4sm7847735b6e.17.2025.12.03.15.47.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 15:47:44 -0800 (PST)
Message-ID: <74952156-013b-4b79-8aed-c0816b7da369@linuxfoundation.org>
Date: Wed, 3 Dec 2025 16:47:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/132] 6.12.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 08:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.61 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.61-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
