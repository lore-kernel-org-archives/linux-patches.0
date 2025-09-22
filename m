Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED3627FD54
	for <patches@lists.linux.dev>; Mon, 22 Sep 2025 23:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758582071; cv=none; b=queC/Za5A8j51QzW9jCE6TepGxMgasE3vyxhLCjHFlxwx8A6Pf8t2chpmVFnRLc4U23VXbY4Fa5SwpKO2myGoMxp9C4nal/VurXg3Y62Ni2wnvTxOekYgI20GeRfvNrc2bBEByb1aNAJKT/wCjrgvM2n8phuZG0argSLh8aiag8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758582071; c=relaxed/simple;
	bh=Ip4IJ9YcCjAcNS7SeyBSugqXLgQYC1klaEHI+7Slqio=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I9V8yUDDf93yJ7Jh3NrO1GYwfyNU2gYVl8nC2Plz40Me0G0DNkLo/bE4nZd4W+nEDZ+w23CxgRMyqudkf4SSBpHbmwtqiqxzOJGbXQ8PAcLSr8k8uaEjKffkf+uMSu6FXHHHNxGSFATUH7P2WJ4AoQ1QO40EGoW4EbN4tfArI3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I/BNMbpV; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I/BNMbpV"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-77db1bcf4d3so3568181b3a.1
        for <patches@lists.linux.dev>; Mon, 22 Sep 2025 16:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758582070; x=1759186870; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZIRmuzDxZZ6U1ppyV2zSqCOvJ0mDBr9fz+vZ74M3vS0=;
        b=I/BNMbpVJGZ3JdGS3ShyMEo1PJkeQ/Q0LhK4nl7zLFIp0CrtHjbylGpZY7HyasCWiM
         dcxKiHooxrXg8f84Qb+BNMDuurV+YL3h2ZTsnM8wT52FWGry67sj0lmYpwFxf4K463Vb
         CMTFZiQ4b2BC7L93+baKIKYC3eQd3MuDIz23OSegCK/7L9ZatbF08rpPNS/TRB6SI1p8
         7+IncfrgoPlpPiVVChY9cxqakEX8wR1+DyIqcp5dRyw7ni2SD8KZbe21Ff1zDiGPndhE
         Ly/2R35Mg9kTEsSSwBqj3dyl2F/oiGHBCvkw/GaPuJbyN3HGInjum8XHJ8mu5501Gx0p
         nySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758582070; x=1759186870;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZIRmuzDxZZ6U1ppyV2zSqCOvJ0mDBr9fz+vZ74M3vS0=;
        b=mc4oQoxCOoA4NAUSXLbrF0iPVKfmvVNVs7IRtBjhpZwjPs/+G/hDviuhHPAAHuNxNE
         bj2LpbuNyxu4VTcOovH+RQDhsGFxJaXBJ1aonb+ct3uVYHRvyeruq8fBKBF6wKAY/355
         u6xCrWJ8DjToFq4aLcxRWliYl43jOFUZqmF9L9GUYBNA+9Spd4Qfyoi80N/OYnX6qwLg
         mk+D5zcMNYenTph9QWIk5ND+rbLvHuYLWus0FYKQB5/ql/3AaNCLKXNWMai4se191/Wu
         t00iSSk9SAC8+4k2vJ9cnZjqM37F/iBUQxoaKkWs0Bt1X14vJH+TiJ6mlT1rHDWWpDtX
         HE9Q==
X-Gm-Message-State: AOJu0YztGXgJV4eacGtse35Q7I7NIj4QYCz/QGYHa2FcNSIRfmWGXeeD
	EULjCP4iaL6H/Ap7S7UTbkf3pvQJGXrP1ZIR6hJ8MyN3GmnttAeYWOAW
X-Gm-Gg: ASbGnctZi/KKe/FCNlW738tiwzlAjJrPbixS0XXpOVY4RJ2sFUnEZ1SjsQJtz1B1dG7
	vqY0kvFv6CWQFp0g0Kpl1wVKQWs5fU57LZ6GBvm5MbaWZtYzTMgeGtT+rU8eNG7QrsKqZ49JkuQ
	l658YNWM3l1kJ9Wxx0CuHlJ9+nN2grepj2qQleCgyG47lJhxslNtSCt3bHpoMAnAuK0XGvRjKKb
	8LlMvR7tIMRFpRp6m4eMPMV55Au6kiiLjIbrSurP3USMEgzzttG16H7jkUb0740p+qC3bDHvgYm
	zccMt4yLpnyXzZVBxiT98rDak8mlCdJp6wtDGGuSYmTJQHty3mSlfDOF+No+hvEtBblw9XxpV2t
	7Rg1i0KA+99c70sqW0qROjam3xZ7x1EhEQVWPXULtRogd0IrJO2NcYpShfd0cN+0mucko6+bEL0
	zds9yinL3t
X-Google-Smtp-Source: AGHT+IEWsdn/BYQUoAQIfQeX+2S0J+Xjds0yc/56BhxRARTZuUx0AR6Bk4YM/v7fMbIc94nL6KpfHw==
X-Received: by 2002:a17:903:2f85:b0:266:f01a:98d5 with SMTP id d9443c01a7336-27cc79c350amr6680795ad.57.1758582069506;
        Mon, 22 Sep 2025 16:01:09 -0700 (PDT)
Received: from [10.255.83.133] (2.newark-18rh15rt.nj.dial-access.att.net. [12.75.221.2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-271353b8792sm80534825ad.123.2025.09.22.16.01.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 16:01:08 -0700 (PDT)
Message-ID: <5326f2f5-e2cc-4733-a44a-db08dd8d19e7@gmail.com>
Date: Mon, 22 Sep 2025 16:01:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/149] 6.16.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250922192412.885919229@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/22/2025 12:28 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.9 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
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

