Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793218554;
	b=5ejoMr9YQlfdCphUYd4Q10+j9ZETsn6H2rpH7iJYGXcPoBvz5tsPlyCijt7SOyCCNeln
	 PfrjccdUgdFWRz42lceisAspsSYl8ErTvY0s8J04R0Uzy6CCde6JbM26XBp0/n76tcWbR
	 UKIyQSTBHmrjh+dw7vGh+5nZLS2W1q1+xna+RXxLuwvD9LeZ1M1ZkFVD75hjT2XaVbytb
	 aZfKCcnBrjx5vePyCqdY7ilUYES5D71ztUXUBoK83lrBld8qT2H725kKwALbqAFQr8d3H
	 cQEqYBYolT7QiAXnCXckEyTM8scr0C7Y0KqOHj7RY1k87wZBIRrPuJXXA/jjE9EKS7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793218554;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=sE7YL0Mu7zAtP+r+dItmrpgUYmZe1QgZ8AhEij2E0bY=;
	b=SaVmW/InFBXG+eh1ess8DresNs5HDPrrgMqDxgZ73MOLgVwF3+lDFecfzyL8ib62kxni
	 NCkWukmAxDHDSc2F6HahrlcHuFn8drgNGEEbORAj9fQGGFGcAtbVh5eYG2Ud2irRDoOog
	 CKLUdkqWoQV2LivfSs8/23qD0pfxUsiE3IYVZWXf60JXO4VLUmuLAlcYGJYGqJEfgJ5Ol
	 vQshZ/Jb0xFOZZ9hEjLgwkq/CC3eEFwjUc0mFWG2oD2k8kZWjB5RLtzjlvmQsJOSpPJPo
	 zeOETeG/wZfa2+xi7B4HtIH8dxIXv7GQZ9h0X8k92l5D6A+i7tUPvLH+fSlh67yGUlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fXntLAww;
	arc=none smtp.remote-ip=209.85.160.174
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1CD606A321
	for <patches@lists.linux.dev>; Wed, 28 Oct 2026 20:15:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE1CD606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fXntLAww
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-535179e995bso14280281cf.0
        for <patches@lists.linux.dev>; Wed, 28 Oct 2026 13:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793218553; x=1793823353; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sE7YL0Mu7zAtP+r+dItmrpgUYmZe1QgZ8AhEij2E0bY=;
        b=fXntLAww3wqfPWkAJxtGL9ENxcqwggowayhOkjuHOw1sD5CY/D+cF4JBbB2t9qTsK8
         eoT586p02KiXra4v8T9BiyFOoV2CoCD3cNGYtW0Y8M+EuMaxNDo2DObpl1L1r6sByyvJ
         3tPqJX2okCwnzNTFO5TaQw8ectz3L8wdtf2eTO0ydLf+fFnTt2zibWOLjKkl+cD+qfOa
         5yx3TKUUzPeyxx4eWViuJd1zc0KgvMfsj2r57uOpcHaR5cF6Au3Q4EIL+sSKKqUBgHiB
         hSlAgxvhluxn7JYBFK/X6KVWX/1CNizCy2n8rmKDGgoJfEJCI5XGuJ1aDhHzGKWAFTdw
         vbWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793218553; x=1793823353;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sE7YL0Mu7zAtP+r+dItmrpgUYmZe1QgZ8AhEij2E0bY=;
        b=AomRT52bIvl/5LGGY6T2lxYP2OHOUwwo82/iQTQ7xPZ1vXKQdQ3ToVyPGe5IJwEy38
         zZuFtq6aw49uElEcMfzCIt2I6RoMldp3kuMBCPS/zCxW4gKznraMpOaJOssOfESzY9pj
         5YknacVU07elcjpzHLPSn0MZhFDgD7zLHE7SCo73YCAnB1A3e0rr3pSH1VXJyPs5Ej4h
         EtQVb5hQgeHYPg3c/lWFx1/NDEROpqOF/htiELF8zbYWdyDAzV/QCa7KIZChjTNpKaML
         K6Seyh3xEtpGlrmKaEAjxvPR3V1A8HOsQW/gtVrsVHszhh7uQdy3370saZfb8io5e8DN
         ZteQ==
X-Gm-Message-State: AFq9FYI80F/3G0iugVn9/kTsqoUKRzuiJjY6YDmQ649NgnmHddyNrf7b
	W69epmL/a1y06XE9i84jwA9a5ovKWrlb5MZyGGhckLwWKH8+UW4CtuKY
X-Gm-Gg: AYBFou3qInsyZDJWZcRLLUOjDPuYdCsQtRLZyAXm3YD8h7LKMDnN/g/7OiTI3r5CnBx
	UmbjxR9LgYkCm5ogymHICiWa26v0xuRvrWanvpUFIjVKSex/YVTRmvJmd3uJYLLR4AFWRqxcYZY
	odLDnn9vItPIhw5Nv8rmmzqRPwYBLh/HHajgYxheOkBElVSMYDUKM2r5rLgRk+yI+ql4irnSGPB
	VjU1DzIUM5clF7dfPeUjHb0mwL0MU1SZFG97nJIcZCo/tN5Fb9WBHuqUMLhEGpXR5Spk8WqmeIp
	2BRH5YQbUqXwp1vUjhu2e57gEBp72pGf1I4SHLggfGmXVU22CkrT8YI7eVHwfTVWjvpIdxmQmnI
	BKtQe0bhRdeLNeKIY8dI68/9FPiM2KLdEpLLUHu2i6jGWBKhLhF0AL4D8qcKe2NUcJiElLVon/K
	8sNpQI074SLM01k9aSO+EpIuXTqhpSQ8jG3PQIrWQh+uzQ7DkOSf5g6qU4LWTghbu7Xm7ugnuzd
	1VOsMcD5GaZV6j6ZJqdD/8F99l83fhO0AwKShQ3khyw+QXGILGEmwimG+o68026jpcI6Gderz6G
	lOZiPzxjYq3dNywusmeZc6xKkYQ8YCES4Sw41UggpMh4y2UmtgFUQl/B
X-Received: by 2002:a05:622a:506:b0:535:2794:851c with SMTP id d75a77b69052e-53fcbfdf35bmr60489901cf.39.1793218552723;
        Wed, 28 Oct 2026 13:15:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-538394c38easm112809151cf.7.2026.10.28.13.15.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 13:15:51 -0700 (PDT)
Message-ID: <131ac3f8-8658-4b78-bc0c-746cc49cc526@gmail.com>
Date: Wed, 28 Oct 2026 13:15:46 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/516] 5.10.273-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261028170003.522232767@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 09:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.273 release.
> There are 516 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.273-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
