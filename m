Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8801B2DC772
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 21:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761598896; cv=none; b=EDlS4pj/OuwZ+hPHHPVfAqHULUVS4Jo5/vjCta2SJFtxFguRcOtUs4oBHLem8WsL6itpF9H3hhF6eEH9WF9ss5Y+2mkgu3HuJK3MCVrser7T8okUMan2GS1Zj89oSvAMuoG7yYT33P5kAWKPC4UibbnYWOs7FwC0LlwmQePVONs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761598896; c=relaxed/simple;
	bh=EZp5BK+kY9z9HMDQNMaQsFSUJ4La66FEV4x+BFlDz6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nxA8+YRMXgGh4mkZebHBy7PymoQUU+AwJY0fC1K53kjcKfXeJbUb2uuGfEWKO6s9mwHLtUvWBoLuaEgAYEp4JXcPMQ0lPR84nP4Jk1Hmnb1TAYPDfwAGwfmQRIp+2hHrgjl5DXPAqSiJBHCMiLjeZ6ygVcNRGGUCcyscxntd1qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hvyLNVAk; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hvyLNVAk"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-27d4d6b7ab5so76193965ad.2
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 14:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761598895; x=1762203695; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g8SoCD3YzmKQQpH3IErNvrdu6c+r9DLyIYwtyoko0YU=;
        b=hvyLNVAkXnVDOuhuc7s339SUMz3y/zOkNSlEi7PQOlVNbl15n8wtEwnGKC1tBDrnw5
         +smgIvg13FJKg7AFvb+Yj1YlF7cZXg3vn8ESvqUYECotetjn/fq3Kc6yqsvcIXG4Jz+W
         WV6sPbUZkSeoC3GisNK+WfFsdp0BjJUPCEU6vHJHqhP+VZWk/7hKjDgL2dxUcAQlOm7o
         l28esnVIcpmnakvrWhlFv4auPVroMICxtlTpswIaqNT6qbYntauPv9HbB9/vpd/6FVJ2
         HipuHUFwUu9jBZksMqlNEnZr1VWMMFdDQmSD090LBA33/KShqYP+cSKFl+CBPSia0aUY
         +xwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761598895; x=1762203695;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g8SoCD3YzmKQQpH3IErNvrdu6c+r9DLyIYwtyoko0YU=;
        b=Kf8FZYJA3ckcBFlDvdNIefqkUEhOIDi2swgPNB/adE7F3QwAZMjiUBLMVpYxjaGdYo
         +GR1tGc3Na9s/tCP1WBesXkQL8PS6YeHP8oDQBaaalMo9RMkK7G3eCdhBna+bQ2hnwKj
         W2JT347y6tMAZGlwrLd4y50z+gmJSin67bgVOeLFat+DQ1Rq+gBXVHeZ4EpsHURZ0lu/
         2ayffGTTPry/U2GAC/w9Sp5n8yphAjE76Gk/Nq85UXgdMbj4KOH+A7kcpdvcmFz9xTFt
         w345kCRjNAMWZvd3yrtVIDFmq/eLeIrwcniA/gRh6ofBxYyR3912wkE2hUx6vIZMJDtZ
         xCNA==
X-Gm-Message-State: AOJu0Yzg4hEcMwcSm639EFrvlj3tY+PGtBuKXuxqoQygvN4QH8ebc0kI
	nJ0uNZHZYcp1UHynpxuCX7K21sxKGjJVkj67bTjAACWTgVR3ubxEljVC
X-Gm-Gg: ASbGncum8iB+ef0mOcbeV6RIm0O2V7bWA3FEXS+e3RILtKFM55dKHeQdT3dW7OvdR4c
	/vjXxwFtDRX6aI1Q7hour95hZAgX/OvuaK+hNu5xEJxuLv8weJ59v7rdNGvfaY+osBecOv5A4fB
	1x9pKicd9TPB9MKyW58kbmnSr1psxjN+dT5fcK9sHLKYb/9m0Wfhu3lzNSZ2C5X4NYyTNyJQJfS
	G/39DmcBMzzI5c7YBe8Z0R0gk1dCXILv3RRQQpbNH4f2mQotMcqa4WXORShml6CKNCdO/E2XKlk
	kplK6QJN2C/VNJlHSpIRy4jpDmTMWgmD4rS7qb0DFydIlbqmbHS7dPx0QQZwcRaQKxjwZtS8flW
	k4utGyAQTfNiw4Qy917Uve4bJsv1IS9cPcfNgYadgaUSJ8aHRcoIp2yPxg+1YOdo0LRtxRAR5xx
	Dr5nsc7Muys32KIyuDy5rQ3PK6d5w=
X-Google-Smtp-Source: AGHT+IHa2VYZJfjdEJOEY0c+qP4ZQxZk2QwgKpEDvKCAvVbLkScqmzDjwXnBYcxlrWLzuBDFczggxQ==
X-Received: by 2002:a17:903:2f85:b0:292:fc65:3579 with SMTP id d9443c01a7336-294cb38532amr14538255ad.17.1761598894570;
        Mon, 27 Oct 2025 14:01:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498cf3433sm91739285ad.21.2025.10.27.14.01.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 14:01:33 -0700 (PDT)
Message-ID: <f3172b29-f4f2-4b95-b67d-cb6cbaeb3bbd@gmail.com>
Date: Mon, 27 Oct 2025 14:01:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/123] 5.15.196-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251027183446.381986645@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 11:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.196 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.196-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
