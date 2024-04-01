Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F1256760
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 23:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712015028; cv=none; b=B9UYrQEIcawtE5TgAjKYnYGC7vIjjU2q+Ky/GvjGGf8aiVLBKKfmHTtXoo8wUkDBr69uPts5Camo27ef3yIEo5Kx0gjNHRl2TOuWWTFTKgfCbqYzwosZ6YMhMRh3pLG01tMHq3XI7VYuhWkIRXmUtZKeZr4JVTZ7CPh3wUla108=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712015028; c=relaxed/simple;
	bh=/aLX1T9kIfi/EGQc2BoJLbyZzAFpieW25xRpsLJAQhA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EuqdRTroSRCBVPtwS0L2l4R8hSwDZi7aSXLLavRBfjNiIbdVTfEktpUB4MAyQ4+javyWjwqwDHBS05JA9dNWHaA78QEEBJjgozXGy/KlVRlxBXGmkwA2QcyMnTOHw/4QdKG6S58FBeDIWEYLFM03LPoj5ygEUut4OAhelgo7twY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBmMpYY5; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBmMpYY5"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so21008339f.1
        for <patches@lists.linux.dev>; Mon, 01 Apr 2024 16:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1712015024; x=1712619824; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sr9emmfv58xU3HXjhcchlx0IFZWjrl3OxfAHso5scdI=;
        b=EBmMpYY5ooXb1jNZ5PUPJZIUMsS5q2iei1ywkrPvyk/zwIiZIMd+3sldUyPAWTmbnV
         5GGDxDgCFnT2CjarfrkcBZHHwAkn6vWsio5wDV2Uc1TtyCEaXFemuDg/fO4MknoYLh9F
         u4dP1BFx+OHERZjk7JN1DqRbRILtACQ1DQ+Y8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712015024; x=1712619824;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sr9emmfv58xU3HXjhcchlx0IFZWjrl3OxfAHso5scdI=;
        b=gb9Siidm3rs+movGF5WC3t2ROwTNAQ932UAWDXyJ4KfSpIn1AmwO5T7snYmp8U1aT4
         fzuGG3SM0EeIHBwvsRFRZCdEAmCbvPw8D3JlgYQS2GNytiaC8vV+dgvYd/J1GIUmCN9K
         t3VoZPpdPCqGLLnIfkkAHHUTB4pfQJipRoVtZv6zwmElmSVx/lkjic4W5hBFnQCI5N0Q
         5kbJJCqzV82z0eBQ0pphg/uj2OH4sCrUtOVLapQhuqbEdR6QequFYV8hqndqAuc5twmA
         gU1GJ2mTHrjQEbNo58TFdgWNdkWantSwFLKlw6lKoM0Nc52aR8lLDk1bnxeD5Yo0omqb
         chvQ==
X-Gm-Message-State: AOJu0YyuuWVfogdkGYJ6zfXtAF7jb0lD2O20b7GMM+/GZ9naFDpHPCDL
	ny4yo4Duo8vXcKlriY3tLuKw2xgJ8MMgnCKHP/iMAgc1quhLZMzvlwDDnp/Lh/E=
X-Google-Smtp-Source: AGHT+IGZ97KiCuSx2Zz5czL9EQLY26VKrwzyrpaH/+ls+eah1/8qinFt7a/eq+sOWXitaCCevB4xww==
X-Received: by 2002:a05:6e02:108:b0:366:b0bd:3a1a with SMTP id t8-20020a056e02010800b00366b0bd3a1amr11111338ilm.1.1712015024165;
        Mon, 01 Apr 2024 16:43:44 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id x6-20020a92dc46000000b003686160b165sm2966117ilq.75.2024.04.01.16.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 16:43:43 -0700 (PDT)
Message-ID: <1331591c-623f-4c77-9c3e-98c0c7981ae0@linuxfoundation.org>
Date: Mon, 1 Apr 2024 17:43:43 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/272] 6.1.84-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/24 09:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.84 release.
> There are 272 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.84-rc1.gz
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
