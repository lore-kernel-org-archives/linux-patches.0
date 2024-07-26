Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA8238385
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 18:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722018184; cv=none; b=PF/c7X9R1BLqBMDrTJNcXCmyzsz9rjRPC4TiTsHdJ7vSf39Ut6rZ2AInesXglFQrmaTd8tdjp8p3HywnsIf00qt6hIm4dz+nNUvXzLnZuC5De/KcS/jZ3PzxTsyCH11iIOsnhmD08STqAVj1DvR3i/cZJqKpPLRA68pyOVsPXQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722018184; c=relaxed/simple;
	bh=NXuxfbSFshWj7VpqMIkSso+XTvOsVSg0ytFMHzYj/FM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fQpvwmStlJFmFa7uWAo02ctbKtCC1ywF3XgZ51X9wbRauADR5sllULqqSF1xw6OPdBVqQe9gd0V/f89ZWkF2nk/Sl2tN4qdjF3CWRZCnsoBo+fWUUIEwwWbpbR77KFwiJc2XE5UG5aGF1skO/REyiXDFISw14orXOg4bOMT+6ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kFQcmjGO; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kFQcmjGO"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-70d19d768c2so1085642b3a.3
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 11:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722018182; x=1722622982; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8dhDfK5ysELU67lH9lFcdq/u0XuELw/N2jDHhfUf6Pg=;
        b=kFQcmjGO8u8inWrevZ7+0o/wq7VV2YDLhwQGMXTGPU0VVGjFowzKj9vG/+c7qIr9j6
         NRjXdsZVUeNA2XQSYxRco5FQhyrqJCSUKpnMLR6Ke3hCZTV0CO16SK2rr6KIOmyuCqNX
         Rd+BXB+Igt/JdYAR61R8POOGu5XyLG5t4wlt/RYHquGIeX+STpBbbwyKW7JqlPG4WiUt
         lMs99oqE1EGtRmK+J/LJDtGvK86Znve9YrwQzD8mHcqMpw8FiDtsyoaKvmCkt69E/FT2
         YJKvsH0OL+PMP3IxQOW/VCsOoTi+oEP9dbdq98cxze2BokBNNLt8kQaydk6/AuNmh29R
         z9lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722018182; x=1722622982;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8dhDfK5ysELU67lH9lFcdq/u0XuELw/N2jDHhfUf6Pg=;
        b=GB6w9YTrUZ5A6MhOogaYICobGpcjYN8Jwf0+covr3AXBjuz9RJghwTP/lBznOnNHIr
         sVBzeChIJjvlp2g1ANUiXw36HYXsXPNpvcFwZcVa+Zm5Ei1rgCEdaVxSJ2VL6OR+joCj
         aRac3PCFCvcGwH0KUQuTyo2DSkmyySrm05M8d8C1IX1Pn4aKBS73C2U9DYz+u8tGHf+D
         RYykJT6ClWs5KWzy9ONnPAKLXs8o6TdWlwAFhQ+BFfjdNrQCn+ci+T8DYUBY2+Z7yQRE
         JD0pvHuiaJ95z3mmBYiEuv3do4w8YSr6uREeDxi7a8kevJaGYkws8fmAGBhh3w3CyLnq
         TqDw==
X-Gm-Message-State: AOJu0YwMGdqdvb+rgujkUEZL01Wb0rxfB3x2thVO7fgcISGperouk6kr
	0igMYunC8dwBupZlDnuQQ8SYrJ23eAswc2sJVH7an8dInxtZKoHM
X-Google-Smtp-Source: AGHT+IEYtAR8TW+qCjezfdBy6NG/LzVqGZNjjejyUBsQ38BPbUibbm+HIoQxBu19fqyo1Nyo3uSnUA==
X-Received: by 2002:a05:6a20:2455:b0:1c2:8d16:c681 with SMTP id adf61e73a8af0-1c4a13a47d7mr377367637.34.1722018182266;
        Fri, 26 Jul 2024 11:23:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2cdb7600054sm5813739a91.47.2024.07.26.11.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 11:23:00 -0700 (PDT)
Message-ID: <b5c7d24f-ad3e-4acf-8171-8c1d44bc1025@gmail.com>
Date: Fri, 26 Jul 2024 11:22:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/13] 6.1.102-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240725142728.029052310@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240725142728.029052310@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/24 07:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.102 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.102-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

