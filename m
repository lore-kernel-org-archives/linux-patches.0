Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89395184120
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 19:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714504650; cv=none; b=mPDb/KbpHFasMoaE4qFbVjj1Uob1cMsmy52/2SC61q2jufjJhSx9FGv3iHM4ML2SKvhThVVAEBgJfTUNRKy6BopWXzJh4sR+XY+UDj5y0xpiCHW7BLAxtAotDOL1DOhSTXsBw2iOCnIaOOpXUKWU0qWxkGz2EWMgVBWsA26vvoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714504650; c=relaxed/simple;
	bh=P/Ac5nVgg1vSfLOIGOhRby4AXGW7urQjIDX2VEXiexk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IwAXdAZoUdNV+3f/PTmA2trQoCPYXdnoLWMv+RW9XQ5qE+OupMLYRjbOpxvzgUgUf00omOQu8vT9xURdRplykJIb9jlshaf5ir0MERttEU8wuL8wJF6quKhIHd87XM4GjmzXnN28ngVUXNI5dJpwkflpeBFA3QSjTAhpnqh/Xp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W2Hi0oMU; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W2Hi0oMU"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ecee1f325bso5432496b3a.2
        for <patches@lists.linux.dev>; Tue, 30 Apr 2024 12:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714504649; x=1715109449; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yTr/n2Zrn/cC95O6zxi8/JOT83ChihXe6hHSdTRi1co=;
        b=W2Hi0oMUHWhufWvFp6VVmXBjhuZQMuc6HOwlVDqqd/KcXPvPu7EqAs1ncd7SwdLwvB
         9yGFNommA5yynM/YG/fdxW17fYUvl6li/LHUyHiGq/IHEOyekk6k9mfPr1ORxINw2TqX
         S8bDKi+H4N8OVbZc/gayL+1xHD/sHGtZv4MOhBAW7c7wvt/U14YiHwLoN6pPrKHH0j6/
         p0K/GaPIgjbPRlIqNPn4niPXsLNCJnRKUTqtVksu8hCRwI7X9PR0VtLbx1aizjufD9zc
         dws65Iq2scIzTJv4sApAcQLTqU7MplBSqsyoASNDJnS3tw+ff7RnsBlabZw3+kh5Kuk+
         oU+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714504649; x=1715109449;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yTr/n2Zrn/cC95O6zxi8/JOT83ChihXe6hHSdTRi1co=;
        b=oYKhLW5JRBW0IFD/nTGVwI42y8kojIVx3bSEDXUY3O/TvSUUiAudJjrCmqVlzR9A3b
         fcnCjYLmw5MjUAmOG7PoaGMb0Y9RvYdorrQqa0Bugb3HxTqfMyWN0CTLz1jozkna2EEG
         ZN1uqZHU3dATlNsoDrN7Sq5Eszn4rG+C78zBUhHQ/vlHcjU61Y43vdYuodpw9F5+dUdr
         7K0Nvm8pZxAnAcYMuggBoR/DOKASEyNZKhtUDi+tnTsokZazFihr7q0k4BxUoN4U159a
         72moMlli/zK8BeVlio+YZdYs5o14fiVBj1jiAjisp6elFDCZPiza7avoreVh46VeN7H1
         aQMA==
X-Gm-Message-State: AOJu0YwiieBgWvMmLOYfEkXZVXiJdJidCUH/lpPy2DUV+cgm4kBHx3ni
	zxv+piIE/7xNB/VGuX7G/a5WxNt0+uHNBL3e8umi7GfU1FqMR7rl
X-Google-Smtp-Source: AGHT+IE9IBMqPoBmU4Bm/t+czjSih8tLANLcH6tDAgW1UPVm2Y+B0KGi327+p9gxFxhgEbEJgSaDaA==
X-Received: by 2002:a05:6a20:1f26:b0:1a7:8610:bb62 with SMTP id dn38-20020a056a201f2600b001a78610bb62mr606015pzb.51.1714504648823;
        Tue, 30 Apr 2024 12:17:28 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c6-20020a170902d48600b001eb4a71cb58sm7053832plg.114.2024.04.30.12.17.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 12:17:28 -0700 (PDT)
Message-ID: <138791fd-4db2-473c-86ab-f8072c14167d@gmail.com>
Date: Tue, 30 Apr 2024 12:17:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/186] 6.6.30-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240430103058.010791820@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 03:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.30 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.30-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

