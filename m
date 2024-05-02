Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2CD14292
	for <patches@lists.linux.dev>; Thu,  2 May 2024 03:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714619517; cv=none; b=VHrT6CH1aVaEXi4WJp7ZzNuHatV0epXa3Du6q3RcdtLRC9qQWqxMKxFOepjnud3jguqUkdh6UEf/7kdrf11n27CQnWAX25BlI6UsVtIXOYeoX+qv/sAMoh5V9TdnKnfHmy6B3jWmMMboXy1ZYitCS6S5YHX1IhwXuRe5jUWHYG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714619517; c=relaxed/simple;
	bh=LkPS53ybZzjbrrcSV95WOf2sCq9FOuYSYrMbGWNBNhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I9ToF3H5OLUDlp65Q92lHcltHCfDYC33MZ2ylSaoY5U7L4moHf+GGlQx+sWDpdol4FbSc6VULzaaDBD6dq9dcovuvDtw40pksdtdu17/YJ8iMxYZsLZZmYQe0y+bq4kfNy5u3RL4vvPyRZrqO3Jvc1ujt+8FVsABszC4D7YSvRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoEymqWZ; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoEymqWZ"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7dee034225eso21197539f.2
        for <patches@lists.linux.dev>; Wed, 01 May 2024 20:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1714619515; x=1715224315; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mfgGwtM/EQFerGNalxKwgDbwkkiHPGr3KDqQ/V1rOX8=;
        b=AoEymqWZieUgP4Uk5HR3EpRIgN6T/LzNSi0UvVCxxPsUkw5Q+a9wNR7AizikxetQSA
         hq5YC0WfGAAdmHGkKIJhVCkGzalqSnLj13RibiJ95qL84oylAGz/H0aGxnTFayP/ds5q
         X/9bYJo7G2o0PL6RsVgNDFXSKmTnGTOAL6hJ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714619515; x=1715224315;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mfgGwtM/EQFerGNalxKwgDbwkkiHPGr3KDqQ/V1rOX8=;
        b=rHxcTzi51fB1HQwRQ10w31iCIJCvI200a5Q5nJyek1k6myD4torEu3OPu7cSOw6h7z
         knJKg2slyt8YDOKYmEFXabbPNB3TFxw0d6EScJCMWWTMCuF/RkQ17/wscstLwaKUtj4R
         8drfjV6QZ78XCfM+shCCaXy7ucHs88gM92FzPS/TfDgk9KbCWzSCwn24mRo0SgXk6yao
         sEuEzxhwMI5uxH0Wc74f7st4pdjveNTi/V/lh2hTRtQaVFANY6i3zYbVUD9rQQssb8RT
         d4ZvgqMor6zr7xs220mbE0FmfnKcuAT4ZGr1Gcw7rpPoS8pZheMPw08UMmRZTGpi4DCT
         ligg==
X-Gm-Message-State: AOJu0YyfcN5fZUvNN5lAn6nd0GSXTKS8lOAlEoVByNCl7cwPOFcLaxxE
	dE6irFUwmjtCZXhHe4tHHZCznaojeP2PYjFpYOcF0BZDjYop/xTG8zgTnj2Qj2JRcXEWUeh9Sba
	qIxQ=
X-Google-Smtp-Source: AGHT+IHq7TbLyMMAGqvlOjDGbNlw43dcSHaF6SIWFiIu8ZSJIuh0KT9bmLi2rwjikxYodZZ7VWyEYg==
X-Received: by 2002:a6b:6604:0:b0:7de:b279:fb3e with SMTP id a4-20020a6b6604000000b007deb279fb3emr4960746ioc.1.1714619515011;
        Wed, 01 May 2024 20:11:55 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id s4-20020a056638218400b0048746404167sm5437jaj.17.2024.05.01.20.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 May 2024 20:11:54 -0700 (PDT)
Message-ID: <929c53e5-257b-4ec0-9af9-9a260ad9d0ad@linuxfoundation.org>
Date: Wed, 1 May 2024 21:11:53 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/107] 5.4.275-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 04:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.275 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.275-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
