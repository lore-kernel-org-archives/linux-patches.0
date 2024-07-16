Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FDC19DF8D
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 17:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721152192; cv=none; b=Q/AF/r2nBOoc5cIIdL3bUmoiySSBYYjstyo2YNVZMxNqChk9XP4G/AWf0xOAkHW69g7rcKjYRCQSeZdI5AFcoFpcdr2DLPi6whnpz3Xax6XKzmzN5HRCTdheCv745miWpvUwI0SopAbWtRRB9jcpaIK0PsBGi8z8sfgzrj5AkQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721152192; c=relaxed/simple;
	bh=2YgWT/VTHM8vCLSpVHJrwCbPuHut7t6GyCnV+GRWJbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fKfTgFPvsuQADpqVc636eqgHaCOBVmyF1emVPYLt2BFK5RCVOboM3qmdzQpwy8+oiOUYt0mqVEXhSX4VmORg7VgSmN3DfbZegG18xoRc/v5Ltpm5FQ/2pI4fLC3zBsgVriXUUJYWoiiy5OQuPjuAG/yZcm3LHy+VnYjg5MvASfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O/YP9USL; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O/YP9USL"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-6c5bcb8e8edso4735583a12.2
        for <patches@lists.linux.dev>; Tue, 16 Jul 2024 10:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721152190; x=1721756990; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fw21HKKLStYNAT8K9Zm5OQcaI1CIyT02HeyhGHNjbwc=;
        b=O/YP9USLLw8Bq+LhitwwqajoUwpcBJb/G2WjztC7QNQiTzf9G/5rTFLQhxdHZ/pWV4
         ZX31bX/LZU2EeHw+InAqkEXhIE3/EvKh7wdMHii0arrhskGoV+LLs5QRH4aX2XSniIPg
         1xoGR4vGh/RZLCS7tGvppEpuSz3xGPi4lw++hUiP03jT2PjVcaVr0/1CtnENHHdeD6O4
         lqfvhK2eSq3fYnA09Y7XIQKrYqJjV1u7/LgZQGLL9BnK7S8/f6gSlpofT+akC2UTyNhP
         3E71ZSgDuCtKvjgvurFENwMH958nCBDn5Ys4QVCA03ch/4XowXrfVUEBKpv4FsUGSvx0
         /Nnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721152190; x=1721756990;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fw21HKKLStYNAT8K9Zm5OQcaI1CIyT02HeyhGHNjbwc=;
        b=bhhNhAefEikyyBM50ZL+hzP3iAwE2mnJDZAAVw+YwNpiU63DHTZlMlG0roiP/dg894
         1P1yQmFZvp4Hk/kAjsBSTo6dRenFtrJERZ7PzWiOXTStuHaKGkpmuRYF4MI91Y+VYzOc
         JrYCduS3uMOdsi+AacaXv6vMoFYTCuXf6aK9/azVV8fp6xN3MOk3JzuB4TBdAR8/7a6C
         GghjkeCUX3CJdNu4U3IpO3h/mO36MdvB0bapw96Djw110kkhYknAZjXa9buTFWkPghiz
         lubq6Zy18f3avSj1+KYa7jOwXx47o77IAmrIsT+Q5A9PaQ3dFz2dYl/O5P8qSmmv+Owv
         UDyQ==
X-Gm-Message-State: AOJu0YyrmwHWeq27WJCB701LdisInsMePQTvCiEu+BIF5dhHB1Al33NI
	oxN9lmQj9WjQ9y8StSVgANP4MSD2Xn1cDcog6qTiGk8BK5ve2Gks
X-Google-Smtp-Source: AGHT+IHEUJk0xLd08fCWUkUT6q7L5dyqKFpNyi0iCdDU+61xVknKryfkyO5HXzgACjh2WUmNoM02+A==
X-Received: by 2002:a05:6a20:c781:b0:1c3:a446:160 with SMTP id adf61e73a8af0-1c3f12d1da4mr2342066637.56.1721152190245;
        Tue, 16 Jul 2024 10:49:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-1fc0bc274dasm62983165ad.166.2024.07.16.10.49.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 10:49:49 -0700 (PDT)
Message-ID: <64f66282-451c-454f-a437-d8baad186868@gmail.com>
Date: Tue, 16 Jul 2024 10:49:47 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/78] 5.4.280-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240716152740.626160410@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 08:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.280 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.280-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

