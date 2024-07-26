Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1A417C9F8
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722013965; cv=none; b=ZTkZQ0HoqQHl9vG1yJtdNefjyb0L5wkqVej0fNt7eZKveolbQngluoxQDbApQD3PA8YwSoLL5x88Z7+Qs0iGojmSTcCKXz6LXHN/5MfMWkQq+byH/nn0xvHlUQTc/W1laqW8W8br+kjn4+nNHeg0EM9pOS+MuVs8HyH1hBAy7YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722013965; c=relaxed/simple;
	bh=Paa9ZDYvS0ekF8AgxpGFY48QgAj1OkW4CidPPwf91os=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iiaj22yYfPVs+V6nlOAyYGiEEtd/xusyTvyAg8Y2ewx83qsSgONBBlG3z4gU5Cy0R/sGY/I60qR23u+mCgLzDj2zBfojX4h+xwI7SxcEvjaOLG5B5jNm3UTuZi2hIshqgImG+cW9HOkkrObZ8Hw52pTei2nEmNuf+YLzctm7+nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XLz/KgVp; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XLz/KgVp"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-44fea2d40adso5696721cf.0
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 10:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722013963; x=1722618763; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=phmZkQSEuAqXCaxKHicEmYsGacKY8DubgP7bbe6kSv0=;
        b=XLz/KgVpjt7o0b4hM7LdhjO57wlUAs9Ufolw82uvok+j+qIIHyQX9H6gRlSyBZSMkr
         69v2XJZ2dzhci0FICgRl3zXeikFm9m3dKHjh/9mnWP/DCOmkAvbN1JIU039KtMJ1o66Y
         sE0Hpmv/IVFf7MNycw/T4sQ2iujke5HJksgMfXU/QXi9Zed2W3CpLv5onC2esk+0/DRz
         pqGcwfarRvJVrwZ2rg5Vv9UUt1GNqp+KRoRWYywHOB31zILC+BAg/PnnQwzsffvoiVCu
         VB3vVjqr3rrSOrt2hW/wbYTBmPLrcH+8i0AgJFGaMy5/fv0sdtLOvfz8K8njvCVRPCte
         J/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722013963; x=1722618763;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=phmZkQSEuAqXCaxKHicEmYsGacKY8DubgP7bbe6kSv0=;
        b=KVRl97twOdocdLtLm7Jd8/Xtze7UHSAtCSY5NxAMFfIdxDbZG82iP7IrpMto2hmNPx
         moef3vZInIYkFVfjfakcvp9z68YuoPvfD4K/U5s+1LKvHql9ylH4TGh11CwhuEpRHCDg
         /nieNzhOLSaxquTVqzG1e3CsbzQdEjVpmX0OkVdt8VOx6Eu0KhaxvnfCYca2NflXtvd+
         q5fZ/qSJaKT67ZTU0djI3m8lnefEAPXbEGZ3znQ0Ham1ar6ttVo2I2Kthd+lWiDmrTNQ
         qjIjPJPjafs29t1Cc+iedUtSE1gLve01Bw3lsXPAPy5bbqldbuXU7Oo1gQBuzQdBFx1T
         zxtA==
X-Gm-Message-State: AOJu0YyyDhWkMMGxoqdJrbjlO339YBZh9U3XhqDSz3+NlfG1wMklchRh
	0ymJe3LBaFYs9DRjSj76pQjBaGtz4tjSCT5Iw8PRkY4ZH1ryUHRD
X-Google-Smtp-Source: AGHT+IHZHGBhL8vd4ol7h2fs10xteHuuJ/Onna0wlk01Z8AAdma1n6e9rbgdZcTZUCltHx0iOmVT2A==
X-Received: by 2002:a05:622a:345:b0:44f:ef22:8962 with SMTP id d75a77b69052e-45004f2ab0bmr5921771cf.49.1722013962832;
        Fri, 26 Jul 2024 10:12:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d75a77b69052e-44fe8147958sm15087101cf.32.2024.07.26.10.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 10:12:41 -0700 (PDT)
Message-ID: <8ca4c2d5-0774-455e-8ffd-69fe115b99c7@gmail.com>
Date: Fri, 26 Jul 2024 10:12:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/44] 5.4.281-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240726070548.312552217@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240726070548.312552217@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/26/24 00:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.281 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 28 Jul 2024 07:05:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.281-rc2.gz
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

