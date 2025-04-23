Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F59E2367AA
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 21:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745442930; cv=none; b=AdkbNEhWTtaAVs9x9AU6cK/KmBPEDOdUS2bf4+lgu3Je2GVzBkZzqAW5hfi7Mwdf1IYPVU8TSr7D5bYjClwrjhl8fg3dFZxPzAwnmNInXNmILZeJc+k1VpY5wauv+VeUrZcwlzvE0OCHfrmpbrMGlgBnRyu4R7M94EDQTaJaFj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745442930; c=relaxed/simple;
	bh=3wg5ZZBKnTg2ncyGfVaRhOLARfZpulIN3duBvh+GAG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z9Edskn3bWEPDusQiFgMCNRyAb0IgG6UnHoMlCGHLjWlLrzWl2uc7hEY9Y5/zXgXeAcLPKGEB8lgJG7seBtDUzTEinYpTafPcv9ybem2hdEhgw8uNQJesWLJrALf8YwMQ9k34uReuduZWndUVc/H0g2YFhXef0xhFTyNpXMSuso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghgNhRYy; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghgNhRYy"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3d8020ba858so3216765ab.0
        for <patches@lists.linux.dev>; Wed, 23 Apr 2025 14:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1745442928; x=1746047728; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9b74JLWsSCMyjNH83DE/ETA732OO42vrMEekT3J9SKg=;
        b=ghgNhRYyZFTg/XfOXdEOWpObldH+HZ9zr1Hnd1/bQDtKdOiXIJ+pwEWFhQBSK8uzOx
         VfQQOVIjp41USHCwXAKmqZ0ywADovZ+JoBANBPBFTyT3Ax7Ep6PtDPQQ1XFNLWCciaIO
         PheTy8mU5Qxg57qq28yqqWr6FTCNoV7ycjwNA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745442928; x=1746047728;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9b74JLWsSCMyjNH83DE/ETA732OO42vrMEekT3J9SKg=;
        b=w8yrziS0UyvcjToByWsZCpTndvYTdovROYZSJxE/TSrwDJ6wLeS6bnARky5PIncq51
         s5RCmsqYkqTLifLAWC95xZAbHPCNI6UHqvOUsUnhADF1V5k2C38URNE/nhKSgOcQ/zpd
         cf0ylwa5buepNu2lI/lmP/XrpNk0QqhFeBzlRIjFq5zsW1oriVSFPBBXAb9/h1LjqsR6
         8lLEnNt+KUXWK8F6igb/9Pxg2NHVxKk+mII1alOPjmd0AYlEMRgJRcb45HltyDQy9zHB
         KGYsOKyinfm74Kktf3RXbiBDDFs6drf6yCfpLT+vbZww2TUknRMFoyM85UD5/cb83xd7
         KhSw==
X-Gm-Message-State: AOJu0YyK+gYufe2Y4m91OoSiHH30iyTGoFaO1lTE9AjfwpCJ22HTOcTm
	UNgRRXAkacsIhHCqXgykfFzED97IhW9VVdlWFksvPbbzJh56rPty8T9GiUqdUTI=
X-Gm-Gg: ASbGncuEhtGN8PLqAkZ3y4DIhMc4TxagEVg3vTBxjAXc9klMkKdXs9n1AyVU65X2n1/
	hAi074OkxRc21RkbCZsNN6nwkJ44hwKj8qX+IVT5bixlki9HOiqk3xf1fD6SLc+WtUHQE+gTwdz
	6znmXCaVjYOy0TfzJNCU9LnFtA+BvIc7VLvATrFaYTTf7Vrr9fyPaN23aOF1epu9yjgFWRaE3Rb
	CRZyu1r0BohBTqLaezBPOvfyR0Muvh5EEpRVF/PCHAkw5YKqtViKQmWAr7eXXRLZycZ31Eh0TpT
	bZ/mAXNg1WTi/uH8RwrS06M/UjomHDfADJhZd0SEqYc2+2askC4=
X-Google-Smtp-Source: AGHT+IFDN0xZmCbclTEpZ4bYvv9YC8mSFQM8qjVUhB6DvAy9T+2/8p/39df5wnTMEJTBducPcLAdJw==
X-Received: by 2002:a05:6e02:3c87:b0:3d8:1e96:1f0 with SMTP id e9e14a558f8ab-3d930422374mr1767695ab.20.1745442928314;
        Wed, 23 Apr 2025 14:15:28 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a3955530sm2920111173.106.2025.04.23.14.15.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 14:15:27 -0700 (PDT)
Message-ID: <f26e49f8-1b0a-4aed-b322-4243c4687e5a@linuxfoundation.org>
Date: Wed, 23 Apr 2025 15:15:26 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/393] 6.6.88-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/25 08:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.88 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.88-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
