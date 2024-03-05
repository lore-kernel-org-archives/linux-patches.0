Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB9222F0C
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 19:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709665775; cv=none; b=B/fV1BzDPtZ5etyaOlmcRO4yoeqIXQQQsKMfLrqRCq2kjWAB5cQkBcAgFTdLy0Fz1dC8e7QVGetoxkzepde2cp97N16RW1mA/Y969EMvbK+CXRDenybFn/YvMXhBwIrS4o1y+LZclG2w4S0YGch1mnU0et/LyKTcx8t4VsMnC98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709665775; c=relaxed/simple;
	bh=OLtQO8+KteJEjf7/KV4xIpCdQnmltnmQvPa+hIMVVRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p8HzyyR3sSNRyWF+fr8vQGbiX32qW0iddkgZsaqxa0oXRWSoH3yxiLgcmDCS/858t/Tl9gbwyRkxb9rhbPv2MjwhXKEt6RUCtVdS969cY2eyXtumi/ApYWVfKrkO5g5H9KuqIxEF36W6bCWE0BM7zpVJ5iuZtgbRHgjdn2cjFBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4zKs2md; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4zKs2md"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-35d374bebe3so3680105ab.1
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 11:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1709665773; x=1710270573; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fJuPfjX2KomvvPn8gzvHjvJi2W9ezL1RcJ/6vVRMjo8=;
        b=T4zKs2md/u/+vscCUO0ok3svuFLRqBzMHM1JmCuPwmLYoNXigqkVFJjpKw0hod5ccG
         9U8uZmS1V6Tml2lvrvBGAn86OIHj6evmWlxv+xfUOboKqKVwHupiuRMFfm81MHeZ/X5a
         XPxAw4FnrLMo8R6BIx0h2/KYfCh4XX0RooN9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709665773; x=1710270573;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fJuPfjX2KomvvPn8gzvHjvJi2W9ezL1RcJ/6vVRMjo8=;
        b=Y93RZi/0rvqvq58SwoZ7aLxFaI16QN5rjIn/qB9Q8G5s3letTMLDXOP2YCzywsmW0D
         hHEarjmWTg3+ZhJQwSrPlIMaC/DXyVavEeo+G+HPExJmA1u+t6Y0sVGlD55I+AmUrv/x
         kaKFGXCInuZtKBjWrpcE7IfRNuz+/CDAvdOs3ChOu8erFiyhE7VTpy9hX/90GmCooFo8
         vuphlwtJCs28KcuRbyEjGM+h2/rvtb/CurS5rwd3NfJcUU/ku4frIzyb9rEEHrBcRcBS
         /iEloS6bM8t4XbAawZMOIywfMlvCRONT/uTpvX5ZaiEDoDFWRkY03yFoDJfpSlgJjjC2
         ZUfw==
X-Gm-Message-State: AOJu0YxnfG91Y8clYMRIhZEKVEsm+q2ttYVp/6So2+3H54rHOZUb4TrS
	S4BoI9GKPIR1C553Ol5hZs9T1K1hfwiSVt7uiWaRBPRRqhZmvOgng5etFSfUN9I=
X-Google-Smtp-Source: AGHT+IGqFvA7SmKFO2T1Afyh1LJHj/ldgmzfKenQlB1sNl7QSU6q8kGFy677aTOXGAmdzhHKp5I7AA==
X-Received: by 2002:a05:6e02:152b:b0:365:a792:3749 with SMTP id i11-20020a056e02152b00b00365a7923749mr1295968ilu.3.1709665772847;
        Tue, 05 Mar 2024 11:09:32 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id m7-20020a056e020de700b00363909191b8sm3190492ilj.39.2024.03.05.11.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:09:32 -0800 (PST)
Message-ID: <1200497d-5f96-4974-b612-550f9e03d9ce@linuxfoundation.org>
Date: Tue, 5 Mar 2024 12:09:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/16] 4.19.309-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240304211534.328737119@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240304211534.328737119@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/24 14:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.309 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.309-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
