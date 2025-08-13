Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318182EB5C6
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 15:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755097966; cv=none; b=mCw3rsvCqHFOT5vvaYqp55stJ4k9OB+idN+EOjC+Ow3JBOyOHE1xrp5pmjMNPjzVc0fJx2/UK3PoYB4U/EE8s6NSvm/iFTYhh0FghUtGWgQ/Lxx7SMUux78/UxQP4XBkBe9aG8B/aDsgSGXIPQPe9STvj0aTm+NV6ZMzjvyWt30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755097966; c=relaxed/simple;
	bh=zVsSFbrvhm9BJ3DbBCbm+xy2MVqqV7KykKxHCqqt4KM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Coyd6QlO3rXTsbF3uwEWaLY2OiveKpQcffSfkPXUudmIDUy5J4Wzb7Lzq9UoD3wvgXMNJLa7in6TbI2KMiTqNUI73DgWHOEqvVioShCSDx3WRDUM8fPIBKR7mtyVvZ7rqY+fp8QYCt9cX1CXqFMmt0oaDxoZ/CUYi5Mj9ticzcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zvx6qJcL; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zvx6qJcL"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-88428cb5dfdso15255939f.1
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 08:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1755097962; x=1755702762; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n42jFcBE2gpeQ/vI096ladjtP3+BqKDXgfUhoLDuD1Q=;
        b=Zvx6qJcLOG7kc0yW6d4805SHg+OTFVgImgHIpK1aPURIfyJ9xJLhyTatYuSC1BRmND
         vv9GQ5Sk3xfxT2isGfwtaCG0pX6wpwqIs1WRBdO7VcnQVZXdE1cSMSrjyvzO5Ut8f0OJ
         vGh9i7bm+kWZn3Kmk0rH4WzbWsf2JBEWKSBQE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755097962; x=1755702762;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n42jFcBE2gpeQ/vI096ladjtP3+BqKDXgfUhoLDuD1Q=;
        b=AE4XYwLMKq8zxmLoGq7jsZwhZR/EcUBYf3PlzxsXRsR9tIJEL2h34jySP9wOcWa25n
         cpur24wSfU1ACDqF1/rZwXuBPP5Zv1FWRf7468pDfLraKLlSKjMjGee0A2rAG7f1yWEl
         YrrXtolPpizSXr93lFbhL0F8sAOFW7GjAskWfZMTfJ6TsBog4FObKqZyW8rO7cUE4yx7
         ey8NLcGY/b6EBetqOmUkGRjyL5jHsRVZSZaD3IYqS/iIHMMwGf8J1ScB6lPzD7w4rzFL
         q7hIrUridg5R37tjNkhKCLywXt9EOZNfPALpFhuUoa/7uFz8i/5F3hvrkvbEr/mv0i7f
         XQHw==
X-Gm-Message-State: AOJu0Yy1EEvuP5R8jLKbvU/G9v/dtfFv/keFaRUP+WBtPaRFObZmhps4
	XlhfIo1mIaW+lE1OfqFhrkSJYEGKbJfraCRRKr4pBMudUVBvzVdeS2afgbb8GdXbcQs=
X-Gm-Gg: ASbGncuHHa2+MmBXdXD27PJGGPx7vFqx0XvHLfCvtC+wKzZICK/8hu+TGTGTrP4UX4F
	aSjyHfBTgDEG45T6+4UfXwQGhv4h+0Ml29NCI/EyUml9g3xiExPD4MApHLix8cVUmlJXwmxbOH0
	MAfgYCWBUc47t0O6d1+YvXxsJjNA0f55TFY2I64utJEsV/fPWy3zSxVJaAsBu6o4R/irN7wz3hL
	h0aEjyiciUR+lQDK6tmvn1VyP8DqW7Nf+Tl785s2aF1GESjpHejSfsRL3WUJDhzJD5UZHDU2y8t
	T/DMP3vRzKOna5C2RQYVFtlNvqyogqG5+3iT33PvtCP5lThqjLWlicFVYHr/nnOgo0iwXsWgFgT
	NIRNiwOzXDeUCT7B0Tp9zrDmoljiGUlNzkA==
X-Google-Smtp-Source: AGHT+IG7OVrd+2DrUYOqB1Ip+rADtsN4EW9RyHicJM+g0CKieqgcluHwZyyU3hrd1BkUduuItJ8C3A==
X-Received: by 2002:a05:6e02:19cd:b0:3e3:b3d0:26cf with SMTP id e9e14a558f8ab-3e5685aa5bcmr45056125ab.10.1755097962142;
        Wed, 13 Aug 2025 08:12:42 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50ae99cfb72sm3840508173.33.2025.08.13.08.12.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 08:12:41 -0700 (PDT)
Message-ID: <9a55a42d-353b-47c5-bf9c-1b55bf67ec04@linuxfoundation.org>
Date: Wed, 13 Aug 2025 09:12:40 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/262] 6.6.102-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/25 11:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.102 release.
> There are 262 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:27:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.102-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
