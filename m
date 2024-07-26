Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A0D749C
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 16:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722011746; cv=none; b=CtwxMOC9mKT8b9n99Q3yV6B8x9LxjA6gfPdZTy1ECPPkQ1h6SwiqplOPhQKG9JF/huESyImjIYiS2bPIXAeDoX/IeI6dsNOXmubf12lYXNEgawdRGV/KhZOFCRvALKYjJsQouEq9kybEeqCrz3ABeYaouG/bI2WDw6yhdBS8MAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722011746; c=relaxed/simple;
	bh=XY7HymytUjgM+8NWLDU54wb/4FH5oqVN7Nv9uROTHfY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rROqFuqjCJ/MM37BbfI3euqz1ETchmQVxPvMDIFkRlcgTtrljcIzKB20C1l9llTVPLc7RRGr2s+BBw8Olq8jURwTZ2SyY4zOFrGdxg5gb5C395DIpfXtIPqnPfxaa4nnTrnbq917pC/2irBfHFHI2GOfa0xJEGtw7IpRPJ+BM58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyBD2jiX; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyBD2jiX"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-8075313cc7aso9170139f.0
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 09:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1722011744; x=1722616544; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NRqdg9zdgOn42cgCu3J2giuAnSl1Epr3+bFdL3aeFPc=;
        b=PyBD2jiXJQfrzQ6Ubo3iQKv/1/Jn3nTNviPskX6eoeTYCRCPFBmzCUCi2naVUcxsIw
         4v2EGso6FX4iFokuXogaIbYw3rPOlleIbb/d/uCAJHu9ToAmRusLuqSyAjv3GJLitesa
         U6Y2gOzAooOUdEw9UrRgHIALlsCnlY4EG9oMo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722011744; x=1722616544;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NRqdg9zdgOn42cgCu3J2giuAnSl1Epr3+bFdL3aeFPc=;
        b=rnmyTk3t3f1wvLSsZ75d9ZiFUa/Ud3Nn42CdXLu/nnsBXHCWk3yJ0oTS4FVspa43pI
         aAaTvhwRBsd0twzej8rfK0SbuDgidxLbbusXVm7sIbq9SYqgZIFZuy73n7vE5EvPyb/X
         AuFwCKEyxsiFAiRXgPYM4opvrpb2VpmItgrxidlrkoVM8CFFMm0AcA73tgZQKzLxhDL8
         /dY2KCk73sTtewOQnMvRaj9Z/F6IWLSLC6atP02xPo6/R+ZTIzC7i+0/SR4nQqCp7dhA
         hE08TUkry1ZOLMr/W3+rBl2QqtQndJPMBg6SN6IxKzExHPQr0spT77mRf7jwgdY0zoVk
         n5Zw==
X-Gm-Message-State: AOJu0YzOps3uuhLoMhxSWRHdNOX1U7LJslGpM1gBwSkEdWTMqQP6kyEu
	8iQUI7H+Lva+yGlReGpZ1N126N6YygQlzMm36cgqJfRSnGhZAqkuRZXY2wCPP+A=
X-Google-Smtp-Source: AGHT+IFeoDN0Drm6gcoPOSZye7+XsJes/VmkzbaVf1yHuzlZYvG68vGemgBrOcVeA30R2sMZKfn+uA==
X-Received: by 2002:a5e:c70c:0:b0:81f:8cd4:2015 with SMTP id ca18e2360f4ac-81f8cd421e5mr185814939f.2.1722011744093;
        Fri, 26 Jul 2024 09:35:44 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c29fa3e10esm936807173.10.2024.07.26.09.35.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 09:35:43 -0700 (PDT)
Message-ID: <bcffbe4c-3eb3-4c36-8d79-a46ffd6a58f3@linuxfoundation.org>
Date: Fri, 26 Jul 2024 10:35:42 -0600
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
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240725142728.029052310@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240725142728.029052310@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/24 08:37, Greg Kroah-Hartman wrote:
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
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
