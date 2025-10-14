Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92ACD307492
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 18:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760464805; cv=none; b=pms3GdPyoe1FyW3X9mtQhBYzYQMOH9mitYLu6febxDt/Bl8bBv2kIX1iiWX2VhuDD2UKYdEp2EzK5UKDDvVouHk2nmyd5MX1N9a0bdbw+PGuICvA2gk8I94pv+1Zde5hoW6+uurhNvigz8fKziKjW170n4zVQ0eyM01IpTs/X+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760464805; c=relaxed/simple;
	bh=21ukBTCCWgadknZW2SMkQg2BIIiZPeGfnkE/wF+Fy9M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fkCUiU+pvMdBP878PNB1WiujhG3hmmzCNBkEMpwxJWy1WE5wHykhr8yGRuzYK21k+RwyG0avIQIp3JV4qGW/hMxmbMUd1DP149hRVLQLa/6WpfMVYj4movwwpipeA/ixFNPEh7lTGbZxqDXZ1dca/ZNXvYZ73cg86WkHC1sxgNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrsOFgdc; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrsOFgdc"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-430abca3354so425725ab.2
        for <patches@lists.linux.dev>; Tue, 14 Oct 2025 11:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1760464803; x=1761069603; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WoAS4TyvZHgjNFjXDlSUMotpNCainLerBGX8bzDNj1k=;
        b=OrsOFgdcjO87OkWQI0xh0quFiGoBhPvQg7qy0dO0cTeRXOAimLsaNyThS3o1UeQbcD
         XYVrAICZKp4jw/MBC2JKZWhq77vly8z4oCD8PmLXnLnGwSvV6NHOma87AtY1Jz7TSUQt
         VS6H4vcDR4H91RV7jb+CwqSLB9IvNMBI01D2o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760464803; x=1761069603;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WoAS4TyvZHgjNFjXDlSUMotpNCainLerBGX8bzDNj1k=;
        b=oAZzVJ6zAnlx7EDzedH8dGOLgF7DDhXTmLT+EAMjRn7KJGKqj1jT4zY0iUTot92XH4
         hLdnKuTDp8DyVUIGoJvZqEEKZGVHXl61yzd79KNpjUuIu1QSSwZRKhVQkXKTPkYwVRym
         WGISYILyXA29M7j93lSCHBEF2fVUUPe/m321Rdd6kVwp9fiqM6h/I7fAeFHWURUoK9UE
         hNKQCO8o4jtBAEiFRp465IM53/AhLIdJ+dhjPQlNcx9QddTpMuMyws/eTxJ9ULCAum50
         +VIEqXPXWbQxlzSQO1HvsvVVpXUhQCmLoR9X3sPFEtE/k+kkItk13VALt4QJCZem4Tle
         BJ/A==
X-Gm-Message-State: AOJu0YywOnrnPbBHaAaa+AFESRxu3fWRIcUdm2ATHNgLAY/9E91lQ8/m
	6PsjcdMDqSHarI8DzSwjmuIkXH72/OXqcJEP81lwgueb42UT4qOEoepBOA96IV44Lvo=
X-Gm-Gg: ASbGncsufm4iJdZwRArlEVnsKtXnAZxgfNpznklPJ33dfNAyMGyK200xB/5qHxu+tD9
	x06oKfUol610ME/Qsps7c7fN/l0iMvl7wp0FPr34PWrNzjYqL3dXah7ppjF/f/FfnJrfls50Adt
	Igo4bpMXZWBcvTUtoB5UHc2u1575LVvKlHxzSaecksXTuYp8y4/q4JVT+byAsCEiAmrZl7zs+eq
	gutdBew9a7agkzO6HcaHiSB35oTAN0/7/y0FDdDVS/90XDzmgjMaZEOTGsCicysswZ7l/7tM9S2
	vbhO2Kh5oJYR1m+jV2aD3x3VKdecmenzJoEoERZMEji+FhqMW62nYXkRLIUd7bawMmxM1X0KBFK
	J6v5fT2vZ6upwz3GqxJ2gg/XGCgKGJt6hul3HtdxzZjABg77N9zQQIhHxqdhK06rS
X-Google-Smtp-Source: AGHT+IGs+0qZ3roynS5JzK/onWLpnh+nlFehYpcK9FuZyG1lduY4TIIg1ukL/IPrYrEz/ELyjmlwjw==
X-Received: by 2002:a05:6e02:2501:b0:42d:8598:410c with SMTP id e9e14a558f8ab-42f8736931bmr330675805ab.10.1760464802510;
        Tue, 14 Oct 2025 11:00:02 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-430a3869174sm8014535ab.15.2025.10.14.11.00.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 11:00:02 -0700 (PDT)
Message-ID: <24b09edf-7f27-4f01-b745-8918da8b3c37@linuxfoundation.org>
Date: Tue, 14 Oct 2025 12:00:01 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/196] 6.1.156-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/25 08:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.156 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.156-rc1.gz
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
