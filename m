Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004561487DC
	for <patches@lists.linux.dev>; Mon, 30 Dec 2024 20:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735592352; cv=none; b=OAd6td5k7h1HGPNRyehEVPFLLl5dkbrj3Yk0Os7dNReEeDvQf3w4xZ/Fn+siejTYIah1df/csjgvcNB++gJ1QfUVHTJ8q16BCEUO2M++gfC+hPJovjr5g/sp9tDfM6A+7GsnZJ/R3HIYPSJ3OgUn50QGgqYtAe8rIS4ce68B+v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735592352; c=relaxed/simple;
	bh=vTU3H1/sRvYpuMMMR5hkt5v7VOn5C6mSPvE9kITO+UE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a8/Ce+K1f4mEncYzA06V34P1EZRRjO6SY6vsg+fsp1B8nq1HFpA1M4ve4Ahi3iPj7HlvpFhmtv6g+Zt4uwIX0sVocnQufhxVErYf48061k8mt4EDYFd30BWbpaPt3Ltse1QVdaEaeYudwMpQoU7hCj00Ivisrb+9Ij40py/kIZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ju7qaZ37; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ju7qaZ37"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-844e161a957so747140039f.0
        for <patches@lists.linux.dev>; Mon, 30 Dec 2024 12:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1735592349; x=1736197149; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4cv4G7/sErhZgQKmo9NijRfxp/8v8RJcLxptnmXL6YU=;
        b=Ju7qaZ37TNKT8+ZByR7c4/W7ib2KqpZlsUFmLbVeMlb+aDbDp+0/CPnlJfdxoBqn+r
         OGr5HcmDKqvQk5/1iFhwcHywatbT8SUnOGTQdsNtD/Hnvt/3IGyqN/kTpR7FAveuNaZO
         KTMwRLgNcK5e3rnR5n9ti4bpQOy46ibuy4mbg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735592349; x=1736197149;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4cv4G7/sErhZgQKmo9NijRfxp/8v8RJcLxptnmXL6YU=;
        b=wOw5A6mF3sO+KbcsL1uZ46K+LdKYwCJuu2xjLZYl2yoaX8P8NrVK9z6rYdZ4bG3TUh
         3KQoqNqiS6vJvcC19ZG/6sv4yOiI8b4JlqHaKmvMrWd1CK/QEIK32DRW8XxoXnLIBlxI
         dNSzhQ1SsEYcJpOAw6T0yBO/rBCJhRPFZRzgwuR5NXVmNzr4gxrX9a1EzHIV47zbZ02W
         OOBcgjZ9zrQe5hpxaHlEGyEWVoVy4f+Wn28R7fp+Hn8+8/tf1eLhyqAZ+mVYkLWPXFRn
         1+AFQMGtDa04+ynlBmxzvsrvzlXCisCcXdYBf14lm1SZAvkeV0ap8si85eCpXheAqOog
         abGg==
X-Gm-Message-State: AOJu0Yy3Ces5Xr7q1MIHgZnI/RlXAETncLIyry8BGUxMqe79KP4qpAuz
	HwZoOT3qFZ7s9E4ALwotlw2p5v2wjW06hkxANDDDlmtqcfV1sz5ckIg/Bn+P9kI=
X-Gm-Gg: ASbGncuMviDHa+H1JNKiPNpHlpBuHvqlmuLNHM79Hufa5rrRbJpgtPxctBMgR2EJJcw
	c4NKa5YDjS4+HXly+HN1fHv2L79NLFvQMMn2ahUoCvlnmI1cg/ydEXAChSEPG90UEMYZIlVkmw7
	Clf8xmK2AphNRfUXMqQj5lxT2bSMIz273B7w8xrcYQgpTYbWf4F2qxeGtrACON2Ukk4qQG6jdlU
	vaLJ9k0T4jL4qEfyyAdYI8chIcTu60VVkKRdwKL+/HggQVMlTgnny47iCXJJi8rxiFj
X-Google-Smtp-Source: AGHT+IF5GZAtgN5jx4NEFMEu0Fn83y1Nte/Rnijh0Xu8azUFjmwoUtb2T6ZQA02TzfPc5c8c2kh+MA==
X-Received: by 2002:a05:6602:3e98:b0:843:ec18:82e2 with SMTP id ca18e2360f4ac-84a087436edmr1473730939f.8.1735592349248;
        Mon, 30 Dec 2024 12:59:09 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8498d8aaecbsm557047139f.39.2024.12.30.12.59.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2024 12:59:08 -0800 (PST)
Message-ID: <79806eff-15d8-4a9c-a274-621a92e8a382@linuxfoundation.org>
Date: Mon, 30 Dec 2024 13:59:07 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/60] 6.1.123-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/30/24 08:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.123 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.123-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
