Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2055D1367
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 23:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768519086; cv=none; b=rbYJB+P+ICiwSFS68/oAUM7F5oLPCPnFyJhPC+L9XV+Fa2kq93MnoahQBX+aO1POvBEJGccb0ssBULpY/erptP7RB/56hKigC6nUddNpgVuqyu64zhWD1VrQbO9zODgB9g2YHCLLTcMqUtpJ3K3Ns7Uj+XRp8k1sihTh+JAnhCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768519086; c=relaxed/simple;
	bh=/a5h1NXFNbjOAe8WM6ey6/NlRR2UbEGzdPSE2qtiYFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oGEFGFtRhCZESdfIboqRB2vaoeuBsf8kk5os2mogbkUtijAgkhxAAY0CPoXBE1E2tEETXQx4bHHVb0up4bjVMNIv44MriyEDEcaqb+RqDEHbXSlJiBA0oGCJhHDnCUQrTuPA1dwVUAuURn4AMkTCncZJXCzLo5wzs9iJWrmWjAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ATHBL/+b; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ATHBL/+b"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1233b172f02so1819724c88.0
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 15:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768519084; x=1769123884; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y4+b7fv+uiyrdpvSXYwwLEsO8D8We+5a8qlvZcop0Ug=;
        b=ATHBL/+byRrd8V9Tj5EpbHdKZMmIkfnqKL84ntsJZJTxbS84wGuKDe29Qv53tZpAKR
         sA1Ra8EYcgp87T5SZ+56+4QUUPBuePcd3UrYCZ5X6nTp5OmLfpoQzoT9k7cW2LxWdxO/
         FusM+8Yjm0gFqscvQQtLDuRIzeE6Tt/DRbZp0wGZ74EPYCFCDDBCrEw+O6IfpUGfbq7i
         6hjqo07yoFebfxoeY8BYaceCeXwVqLcVf42AMSL80cJlzAmwI1mF6f6Eg8BHzvKCE01C
         ER5fNNz+7EQu1EAHiT3SKeBPsWEKY0W/7/NhS1Gr/YwpuikCs2f4WpKb2eX0WOMqt/4J
         sKUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768519084; x=1769123884;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y4+b7fv+uiyrdpvSXYwwLEsO8D8We+5a8qlvZcop0Ug=;
        b=XzWzNqIpycdBoWwP5VMFEQGaNMeLQSXB81bhnwvWL/Zg6SMM6rfHEXCDXkBGSfJ7v3
         lMaEJPtZ2uNIAcpdZtmzWwrzHeSbBywSQ+zVhNvXOcBEkkRJVTjU8PzbE78zoFRunuu3
         UkNd6psihpnRp/p3PF1vPsKugFAjBR1p9G0IpL+r4DQx2NPuont7KPp+slxFi8Mqq9uF
         HRigaegPNC+rHgdWwbdN7pBPv6Dw4IPjHzDDYHkm1pnnFPEVxMLad5wt+HuKZUwSJSlf
         vjpfR4lQvRuUC8vcKcjp7kr9Hmuas2Lq05Sb13wS/XC0DWyo8Lo2fQpiQK3ASKSFmXsI
         TkmQ==
X-Gm-Message-State: AOJu0YzMUr2aZqB+ah6FknHhoB9yvqDMpRmr5k+78lGJBR58pvBSFxkR
	8YjNts/udvc+hXgJ68N2P0rR9KSRz0fGR1T7JuRyy0yUHsnhse0dZKas
X-Gm-Gg: AY/fxX6epWrokXMpHwHJwRePml3bwGfVHksb4VN5WpQ6CUEigYoboVEFSpvDFfO/zyv
	LWjQjV3WsTxG1P+p//JnU5mWOASeK3S8cDzWenhsUP+lWJ95HN63OJvQoMOp4pL08ihbF6ux6vZ
	5cZQlBQucje/vNnJieeeHm0Nxv0w8vqhalf4vzUrT+20Dr4MD3DvRdoclPYhEdbM7O1mEfHky0E
	DV697mUthGMIXzKz6RhMo2CeI8cVJH4h3GI/UvjlX4adCHcN5WaTUZ/sYfNFS7BFsQEJmLYV7te
	WD3jENj4H9VSAJnO/MJVV0VCKR1r4zC9JhiTc8r5luTF88/CaUliYORh5e0tl24bb45qBw0T59c
	pRvTHXKs6MOWrraQHJBfM612gEOOtx8wGTGj2TJIvc8ZWy6pBscQjxJY/YzK7shbLkggFZpvtPM
	Xxr76A42uZGWISqWHOfqqUj9row4N+kOEgBUI6vg==
X-Received: by 2002:a05:7022:6884:b0:11b:9386:826d with SMTP id a92af1059eb24-1244a747274mr1225642c88.42.1768519084181;
        Thu, 15 Jan 2026 15:18:04 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6b367cbd4sm676532eec.33.2026.01.15.15.18.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 15:18:03 -0800 (PST)
Message-ID: <004572e6-5238-4226-9a2f-50078383c838@gmail.com>
Date: Thu, 15 Jan 2026 15:18:01 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/119] 6.12.66-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260115164151.948839306@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 08:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.66 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.66-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
