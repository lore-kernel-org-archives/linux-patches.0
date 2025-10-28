Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB6E34DCCF
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 19:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761679493; cv=none; b=Stkbeh10yc7KtJFJdGQuPCdcnxChNdv72s+u4f/TXoCRpP6ET7oR1AZRdW2C8mzqOcw0Shu+WYfJCQ+8aP48U2nEDBHGmIPPuO43Ze+fXKUQI1jmifykUJp9okokUQSDjFNSNdzA4TVyqEs0gYZMlZ1e37bq7RCuaweyKGtCE4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761679493; c=relaxed/simple;
	bh=YOYUi7F/Hythc5A0zuG6/J5WGc9v5JfX+zO66GNLWY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DHT9zZpjQyrL7aikHPbBJdihsMGIIkFu6JutMS5N/VwSgTg6QPUi4MiXwWCBXbrcbKdVyNxXgfF7vpPbbpQ86KcmU9A7P79V564VEsbT5BQ2kKIQoOaBoTvIkM4MLk11pzWQaY//21L7l7ra1aIGKKOPzBJFXWA2UTKuPU3MyAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRuuEMDt; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRuuEMDt"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-92c781fd73aso614193639f.1
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 12:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1761679491; x=1762284291; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lqnf9jST7x/NcmXslhQQGVDr5TfMAmtc49PlrfRjlHI=;
        b=KRuuEMDtGp/5pQdtVknw1xSJZf87ihPcb8OQgqcjda1qaSba7tjB0THVJqwRv7Yw3E
         az/zW0T8xy4gtrkymaQtvjXibiifbp6skJpNn6F00cMPYOUKTaQgZmokA5Rf6lagKy8c
         ZDAcMcfh8HRjkubo0IytmkOvLEyn3fChCipaw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761679491; x=1762284291;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lqnf9jST7x/NcmXslhQQGVDr5TfMAmtc49PlrfRjlHI=;
        b=L4iUQV7IFP7XiJ86FeisX5EO79Zg1hb5xRv00vnD+Ce0otVGc+iVCn+2IokiEUuOnD
         fupuQ+MxiBqloN6LqcgB9/vswe+IXBm9DLjVBCrA0LK2OkbsK5mkiYkeuP9td1+6A6IJ
         gBxnixhh50Tn3tb0dLBXYcSvolBCuNl6ZeuIoHCH4DkoxywolvbRSANnD2qgc8jQsmjt
         c7Z4NjSTyY4QlpjPmLJBErO259DLxuJAMWE6R/BQOmHWIt0Fn3EStKc+riIMydfEXKof
         BfhLAbaUCXbEOCi6rsQT6G8hTnwpd3W1UNLxMU9Jy5MrN9acUwHaCp3YXtOqOBpDvx+G
         ZszQ==
X-Gm-Message-State: AOJu0Yw1i+81E5dQ2qKrRFqSxdtEADtaZT6bzaaSdjcECKm5gDI+jBZC
	+LIC23pyWdz2LnfNGUMXhG5V5UAOm+QZ0R2NEQPHoYMBrUQnTGQhG4kORAd9voOisHI=
X-Gm-Gg: ASbGncsIORrFx/0/vOQLdT4xyG47XqOJyMm4iSpRu2cRp11rN0+Td+GJEUKVixgTFYb
	ruSJxL919Xc0XGHJE7uRuqq0aCyCpevhkzuZ0g01o8HTDA9HjBrTKZH6dhG/1gfE561gJapXsmB
	qjzP8E4ZfkIga6uRfxFM4UNyGLXULNCF2Q3rYpqCelGdUEMYefpY6CZoH1U+HjGCiNnqmU40Nh8
	kZZNzj9H5tHMt25R/u9Rji+TitEKd1AR7pl5mXVKg6hPkpF02Y6nhXDU/FukmKTQu9EGteaVDMT
	M8aZJ0jAOrWDrUnUNB4MciyfSzmIN9QZzJn/uO7Q2jBVq69J2xUioRTUGDKw+DFgGpr8XyScZbx
	MRV3lAGq4AA9+bLwx0pX3iaZs6WPXijso2UNkKvHPsSQeswrkSbrCmjg3jHb8aSGIlRgefvoMtQ
	4M2oBdgoYRsCls
X-Google-Smtp-Source: AGHT+IHJRAuHzK+xQWLlPVLuJq+hr1sweTNjUYhc4Dc2I5aDW71o9ZnEGmf8KK1Q7LnIfXad4QIGZA==
X-Received: by 2002:a05:6e02:348a:b0:427:a3ef:5701 with SMTP id e9e14a558f8ab-432f8fad698mr6072985ab.14.1761679491258;
        Tue, 28 Oct 2025 12:24:51 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-431f68747b2sm46442155ab.17.2025.10.28.12.24.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 12:24:50 -0700 (PDT)
Message-ID: <ac5ddf39-d8e6-4655-829f-708547bd0fdf@linuxfoundation.org>
Date: Tue, 28 Oct 2025 13:24:49 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/117] 6.12.56-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 12:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.56 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.56-rc1.gz
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
