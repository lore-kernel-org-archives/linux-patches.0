Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB6214F12D
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 22:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736979260; cv=none; b=FDIwdFe0og3mQqhOadl0k4IQSCIuL7d+QcroZ62H76LltLPaSBiqQ65UQwVMFFYMtr8rckbpSdSzf7qqXhCf4yIiu12NDLfCJHtLA/VMf+Zln03UBZFooMUhVeIq6UDUbnzg8HkDShzJpDQ7CIVm008beanGhL6/QO2+T6QuqUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736979260; c=relaxed/simple;
	bh=OYJIAOSbItTp53QRHUFYCA93HDtJ+rK3bdspxDKulfI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k+Ceqb92f+6awj95MBEyQNqOKFNoxQkxCJH/4GnGp6Gp8BNbn126t/AgX06mTJq2Ye6GlbSu4Etc4+tICG0NguRJHtK3rKmpoi2zIYzmI+bljf2jQ3F6r4ki8Ki3C6Sk/eu2U3iMPecR+e0xx2TICHAjlI2rATFqxr+Ken23hTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kX0GUOtA; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kX0GUOtA"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3eb7ca55c3bso210680b6e.3
        for <patches@lists.linux.dev>; Wed, 15 Jan 2025 14:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736979257; x=1737584057; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8HKNpdFHanwKimxAIl6hBfo6D8KRL28BVynAHn3Wm+0=;
        b=kX0GUOtAToyH+URnVy382L2g9bxeVdM06IPQzYQ43LAuSyTXrsxwFJS4DHItKMn4en
         jRuDLHctuMa3tXoZjMmMGVBlSF0lMBw5LsTVOoPKhWrHGEfu/dDXEGmtW3n5wstEFEQx
         s5L/3fUD6o2PTislrUJqAHfSwoiKDuOLTAx1c0zOy46jH5Vl571a1yH0bVlKZCOJXTJU
         0du5UkaYr47CrNEA6o/9F09gwBcdSMF3OfHLvuF8Y/tzykdTs4EBrrO9T65/ad8wSOGu
         Np88LIJtgGiOc9RJXZOQKAlFjT/zvIADNS5G5o928ptpCUpAL1wwmoVqBxrIxSkS85Z8
         ceWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736979257; x=1737584057;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8HKNpdFHanwKimxAIl6hBfo6D8KRL28BVynAHn3Wm+0=;
        b=OruUhxFNoXriy5QCXEougCFWOJ3FY04NcTAmad4TRLLx2lmIswf0lS/t95ur40K5YG
         Yxz2HDSiOK6LeU1sjtt2vUUmNI0Gihur3nCfyYr+oLHKm+zzan8rfGDD2ZRvRDLPpsEj
         GBKcItgkq/lIbuIZYTmtFpLTUbgIjdz6OehvUr26+VTd4nTijAw0dz65GYYi4WUtFl5Y
         x+MmhgZAdmW33EqEmtyG80KKafGIu4AYCttjeKfF149dabKllvQnjJUnhSXdbOdIwasm
         y5POjdTYvwnpJsPnISH1kt6rQ6pM+m8foTRJ0HNt0WAHzicQhVbPml9Ph2pk7NUQHaau
         NyZQ==
X-Gm-Message-State: AOJu0Yz20RltDU9WXS3tN019VnxpUFVUsM9a8d7/9mn2gkkNpDSBdZU3
	QrkhxvHaRusE5rfoX6hKyDntX8HiIlhLAenSS7P4suhcAa1WT5sC
X-Gm-Gg: ASbGnctYaWz6Y8QugCoVr5bVMeHNfHDULasw1lJTWFeTvRWQnGECzrcrqJoLBBDPVPr
	iAk1wwaCpJMyNm6QpembPh6SuZaX1egRckZQc5lHTC66SQwgWzTkDlBmCzqyktdQOlTdPfZinPj
	vA6c0wSWjSbm+tkMQyaJvDcVDvuV8Ztw0lT2/SzBmlMxq0NCRqFels7f7XucwtnV9KcPceC4za6
	B0LBFnF/Ai5w2Z1M7OeZBoKQGK7JV5TnbwlaQURB8fHA30ziX24EVK8HrJLhFqdFmqjCgP/Bzba
	9OlHZ0fn
X-Google-Smtp-Source: AGHT+IGhn9ll3NB911ccBhd1unOJGldWrCQq0iGgnN4m0m8+Te4LLQNyBxBXnD940TpjnaUQ0xxj8w==
X-Received: by 2002:a05:6808:3c4c:b0:3eb:6db7:f787 with SMTP id 5614622812f47-3ef2ec90357mr22780482b6e.11.1736979257247;
        Wed, 15 Jan 2025 14:14:17 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7231855ee1esm6057593a34.32.2025.01.15.14.14.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 14:14:15 -0800 (PST)
Message-ID: <4cd7adca-fd08-477c-a00a-f43a653456f8@gmail.com>
Date: Wed, 15 Jan 2025 14:14:13 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/92] 6.1.125-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250115103547.522503305@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/25 02:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.125 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.125-rc1.gz
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
