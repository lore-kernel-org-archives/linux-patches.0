Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327542F291A
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 15:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755097849; cv=none; b=SUGn+zaXj8AM8hW9Vv0RUxDnZ/BYWUaFHrJiHUReEjDT1kvwmTwu9ygIvnyh9r8E1MC653x4nvA8YIKZ1+oYxRwwJdIY3Zqf4YUj6ygT7I5NPgo6yzDkfWuIyp5OIa+V5RlWgXjPKUHlI3lbYjT73kCNCtzQbZG/bFsCbo1TPNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755097849; c=relaxed/simple;
	bh=qEyWX4DpS2OZS71Z3EmVZt3QnEC/1Su46EWk2Y0GS+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PFtz/R+/oNGET90UR9XwKZDgXBGQeIOEFxa4vbI9Af3OzFoxZHuexkOLBwoqjGB3i9G5CGjBTaXbn/JlUYxjdFAu2c8mMwG2CjzB0Q2+waVSTGZ9+YLTGx+VuzDHI8HnEyvJJZRn/QqO+UhOBDVdyussqzv5MTGwzw34qBZ1qfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5oJ2jbB; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5oJ2jbB"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-881982ca24fso77341639f.1
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 08:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1755097846; x=1755702646; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P9TWMfaZ9cUPmbpbkghmAnSm/qty+t2w4h2Z0YWH3b4=;
        b=N5oJ2jbBDpiSgl/peZfH/at+6UbCDq37RoxF8FGR2UeiJ0Wp1bxKUhjU53PrBt/ijO
         +yfmQPYYJLqWNn0d8K7itD9O1nU3TyDEY/im2GAYNPCvnDAOFMesGtSfnHgCNj1ZTXa1
         QBKtqBP7XR918ktrZdMJwcIUDUGZTJ0vwLLj8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755097846; x=1755702646;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P9TWMfaZ9cUPmbpbkghmAnSm/qty+t2w4h2Z0YWH3b4=;
        b=ne0WmeC57vbeJsRNv3VePfexFdtbl9VxFyxakVa+TGIn0wQHuEN6P9cVgbJA8acEBl
         gu49nNaS5GO+NMxeOf0yR6iiB18WEz4wqR1B88YJUlX6mcdHNt/CBGkPVSYl2yvXmWEr
         soE4coOWlEDKWrZuHJRxoSi4ivGp4L9vcP1DZlP0oeISbIeFYHXrAj2wWGalo6ksKWlk
         OXgEPFCmZgcluiNVS7RuhcxbllM9z38jEM4NesUr+8QdRvX33YOFXzISQB4gLsw/07C/
         Bwje0atBkzBhc2ueNKhrc/jOeOZJpKIJQrtB1O/fiZWvLNKIrnFaixqRDtbldtIMoZVL
         CcfA==
X-Gm-Message-State: AOJu0YzLxdylWxQ4r9k4Wjn0pQ9g5ONzRpe/slz6Rzln9BG/UPbyHm9b
	tvmh2DBSm9Dt700Euid1DkaouBCZCcpp3m9b8Q/cpynXzBboTQuHF+8YXr16QXBrZNo=
X-Gm-Gg: ASbGncvvBA7FpIpTSYyth9atGjooAo/aXquCpDnoXSGhwScTn1rqauBEKuGBDnNEaZy
	qdHBW6DApibs3O98Kj6sxbSBbjh0luWhRzr5KLyN3O+jkPmuzgFdT3tA4SaGKtSdsiGmzkWaSw2
	g4VDjODJ04tJfjjNLNSAZxnj1y/TceePW/g67oBiYeErwX9THqfTMf1T3GP4fFxK/WGApGlpPxV
	yprHjZYeZczn1IMHXNiqDcB7/QBqSxKGQfmyBxZ0hY73C+ChOF593t/khy8StVOWsAHCUQWv21k
	Kx+YpeTsrG44V8S0gONJgGwykmUbYwVmRd/O/cwu0X6hDJbClzMrGzLZAjkz3eTH+6+4rVZd09W
	jMFk1zRJTV3bE+E5Suqu7b8R8ZUP6s6DLGQ==
X-Google-Smtp-Source: AGHT+IGIUfrH/onUJt9v2z5NiJEkUVDB0jr+F7u/mzY7NvvGCnp6Vfd2yhacr6P+7PUvb3cdMFgOqg==
X-Received: by 2002:a05:6e02:1645:b0:3e5:5c80:2cf3 with SMTP id e9e14a558f8ab-3e567492351mr51215665ab.13.1755097846224;
        Wed, 13 Aug 2025 08:10:46 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e55b077b34sm19523135ab.51.2025.08.13.08.10.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 08:10:45 -0700 (PDT)
Message-ID: <8e112680-447a-445f-ba94-1d4b25ce816f@linuxfoundation.org>
Date: Wed, 13 Aug 2025 09:10:44 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/369] 6.12.42-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/25 11:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.42 release.
> There are 369 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:27:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.42-rc1.gz
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
