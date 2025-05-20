Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB582116FE
	for <patches@lists.linux.dev>; Tue, 20 May 2025 18:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747765689; cv=none; b=sNmseC2KUbCEeuNbEUEhuwaUcaPuodPG/Th3FVLk+0xfYG+eqjRQTGoNe8uF+kLGgpV7Hmx2crBgAu/pn13/wcY7plEgVs8ftTzGf5D1Pl8hGJI2KMrDsY73AkfQtfa1sR6jNuJYuzSNoO/4aqrgkN2+DdqN6kTWgqMZF/6XJDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747765689; c=relaxed/simple;
	bh=rCJXx8gGWF7Y/yykzx37aKd3ZjPKtf4V2UOvUxBbtsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EqEXCKqQdIMRIneDwKAv4stm1Mp9Cdj8maQc1L9n2lWneGcMah3Gz+GDJeRXy8jh8rmt1xsZNmvOjZDkksbC/4R5vQchYs3VJd6JyQpWJOW/BKmLMmCzHLVo15xyDw8CUNFR8Td9lGMwkjpagAjwYH7f5QBuxOiXyf7mOajorZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DEhMMvv+; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DEhMMvv+"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b26f67f10ddso3204629a12.3
        for <patches@lists.linux.dev>; Tue, 20 May 2025 11:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747765687; x=1748370487; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HYInFiFPI9ndfR/4cO64UxKvCIOi5HU+gdUwzbowEbw=;
        b=DEhMMvv+jPSZ5YQjxKL23dLULMjSi6nQevkV0k+B0h1PfqiHIGfEzLz2Pf2Dyk4tNG
         bcwr8dMJjm1v+rogCdY1sjCai8huNMKf4y5L/ziN87HBOQywE8xip+4Er0yKFohKgj5p
         LxQ2K41GOJLzvMY1TN8kpOu2+6yxTFgoLZIeL+gaPtnbaXoE0yZiR1Gwidp7nBdDZKW9
         HDrP3/uh3z7J3P5kFzK34SfFsVO8s4kR+jfiZEsoyE7EkW1weqeunggRvcq8C7fKyx7/
         IsNckVSx0yfnmnX4VFEq2NHe53HwaHRT8QwfO6v/rQr5bHactnm0fOSgScIkRH+JBASV
         uOAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747765687; x=1748370487;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HYInFiFPI9ndfR/4cO64UxKvCIOi5HU+gdUwzbowEbw=;
        b=GKvwXVd4AQSUEJBDkIzXP+XtOKyw82z0KrB6nU9RjznWAnTA30ecagFwbIR3bWOMQh
         N1uOI2i5Q4Tr7zjBmR5tgL8kIso7ZQmEPwaodDA2BQapZUM3wBhJ00to6ozMo00VGJM6
         wcm4ocUQbUzfCovloseAtWwrOe1+L97YtuZCd0PPveICktHxO/GGQcPTX3DX6kMpPtge
         DidiZHkBrBTRMyGSzUszszsZH0J2HMpw602mmsOfuECr4onsuFBZ9VmG3ivZce7KF82n
         jZuMsFhIzK+7d6A7o4YNylZmldsRhjjqflTaddqBNbcYEjVKKGcO6ehBllNf4wJBWhsK
         GFmQ==
X-Gm-Message-State: AOJu0YwHvWNoznINfY00u4u4V/CFu6v9hzS2XDhPJgWfzQCEmBu8rOYQ
	G3EOhjt9lM0j874DXlsxMQ5b4HLszGqcA0MSdYBDO9qaScj73bJfisyd
X-Gm-Gg: ASbGncuqCPPPlkhRENJN8h77BVrZ//kQnxA7NxFOmXqec/isHhNIYmYwRsbe4CwzjeW
	2nMnt1nA9oLjwa8zwzv/ZlLc4CG7g2CAN0MjnP9qACpTRnSblPQs+Lgv2mgDWP3sAyZF5WLtXvx
	6+LNtkLDKqFlRQBL4eps+ug42LFqQq/udEVh2cm11E5HhsIfDN9/CO010hJBwefbWNhVb7CO8x4
	s99pT07Cdb3bnZittDr3RNgOW2bx6kJIlE2LuxBts3+3jAiaRVsF0W8EJJfy2/oB4t/VLGeGXsr
	DqiiSsTovjPhJoRuZEjLvQr38hhtmTnXc/FY0BWEN9jKyXEhgMct+tT0qE6VSmWbl4u0CyfqWdD
	fuM4=
X-Google-Smtp-Source: AGHT+IESgy/nLH7exbpBEzHU43OET4g19jrvnZakgXDIKVS9FFM9QSYBQYvYluFSIMlc73WVOzRMtw==
X-Received: by 2002:a17:902:ce8f:b0:223:fdac:2e4 with SMTP id d9443c01a7336-231de3515a6mr222440185ad.1.1747765687367;
        Tue, 20 May 2025 11:28:07 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4b04a52sm79864825ad.91.2025.05.20.11.28.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 11:28:06 -0700 (PDT)
Message-ID: <ce477b83-57b8-49a3-b924-73b644832b06@gmail.com>
Date: Tue, 20 May 2025 11:28:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/97] 6.1.140-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250520125800.653047540@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/25 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.140 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.140-rc1.gz
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
