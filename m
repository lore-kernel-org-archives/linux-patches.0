Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399571E536
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 15:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721231634; cv=none; b=FYYZSbn8Q/bd61ORy/r4TrkiPw4CvmhTIxIv2a3vXZPxJICsejZfIUsmfhbKlbdbek/oj4pTrvkU/Db4d3ij5W7IHu0U1x7Dy79s6+GiMaMCidxlHim81lG7vPvnIuTIk4MTygRNoMzE4EAB4eDhBeyMuOvxB7fdTvrP9Q2k2ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721231634; c=relaxed/simple;
	bh=MBMtHLJ+DVr4ag594rJE0YlnuRz+2AXsrDuPKfiYZqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qbCtwCewCoN74itEjh/1joIp9pXfMmh63wzbbBl3KepUridkwcgaWaBLFAmiHsRJ+ThWhnEqd/JbGKGT3r57uF1/qmOKILyzImD932xzdxdAhFB4uRF8FJ/8LEcA6/A3xsQCRbyPuI1m0xOHoeCNH/IWDNVOQw/E8FlSwb5To64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qg7Lwemh; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qg7Lwemh"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7f3c804daf7so4997539f.1
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 08:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1721231630; x=1721836430; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=obXgQINbVfqbboodSk/JMK7xhpmmi58PT/EBrAmmKbI=;
        b=Qg7LwemhVHJFw/ryA1w4HjZ2ypdgMHvGVuhzXJ+ExxoPFA936QRbnJOi0TdvzYl6AM
         FExpxNEOabDJSbfPB35s6epgbqcSlw/YtjQ4ha8QPL38zC0zJWynQ0nTN/J7mKy3Zqlo
         QcUnMUBhwrr9NViSB8pLMtB89ZcfPT2d9liio=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721231630; x=1721836430;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=obXgQINbVfqbboodSk/JMK7xhpmmi58PT/EBrAmmKbI=;
        b=vGC4sUyYCdCpy1pqpAiNESkmiPq0QDenCJohxIA1pQYuGtn9cTKx0/rYUtCiWXmPhV
         oiuai9o6PAO5danShIa6fhIwekYWMlhL1CqpDoEMmyFI9erWlg0kXLFuVE1vbcL0wkfk
         y1MolAv02gYj0bhfaIdgyFFfYR/MMOPvF9h9FJsayzNDdK/BhqaS3cPP4tW4qe9X4VTH
         LGsq4OmE6UmL4EktQ3OxMA1KiWHx1cOMecRVO3IJdTeq/Ftp+yT2sM0iVfnGXrYg0HlY
         njytFsqsc70LPCnoN+tdvn1FT8MuRbpyWFeIG6MxzZCeyiLFstAfFvtU6wsKbjqpgzVA
         51nw==
X-Gm-Message-State: AOJu0YyFgwGAZNCTwRx+Kjb93IDKsVJfbvU3jdyhRtNwwiiThk/TSFQQ
	3CiAdTQw0iIWUKjFm2t+Qb+FstouN9BIiLL9pyWAl8kkT4yslCeOaVct8uRBQn4=
X-Google-Smtp-Source: AGHT+IEFW7pms3EBMhQHP3lyWtsxOEdybprANsdD9ByPmbsmX7K4OKOQoHB3AaTr7G3d46U0Wi+Ngg==
X-Received: by 2002:a6b:ed13:0:b0:7f6:85d1:f81a with SMTP id ca18e2360f4ac-81711e195e9mr150596739f.2.1721231630317;
        Wed, 17 Jul 2024 08:53:50 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c210f21da3sm736469173.113.2024.07.17.08.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 08:53:49 -0700 (PDT)
Message-ID: <ebbfa660-149d-45e0-a39e-a267095bae39@linuxfoundation.org>
Date: Wed, 17 Jul 2024 09:53:49 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/144] 5.15.163-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 09:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.163 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.163-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
