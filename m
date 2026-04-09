Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C0C30FC0F
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 18:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775760122; cv=none; b=MU2QdpfgQm+id91JpzjOy/AlluEK5W2hXSoDgGuFjFcJqiPwx3V9n8s9tw+lTyjpsKqhiioBw3vB8V+gj/N+6bzX+vmMl2RZ6JPkXdxg3OB5p8gdXv6sxcg/fFin3ZZ6sUgRhIjG2wFy/QeJB/vu7HtBtK5Qwh0XKuscAhFs4rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775760122; c=relaxed/simple;
	bh=s8MIl578KTQcoEBQfpo+c1sgyqdA4Wu9I61jd5+tSIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D2AV7K9Uldqvxj1nzRm9kMzS8hgzByW2w1cSwYwjzJnZ/8dNxuRVXSvmfpueFWjtybh/qC8ypYNT/fBa0/w7/VGHQ4P5qjDe7Ql3UVD0KFRYaWeijLo7vmiKYBffPnICRXMjBxUqoV05UTgsLiR8KEpg9mHqi03PJp6wjGJGs6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fOwwzcrP; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fOwwzcrP"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8d424af6282so130325885a.0
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 11:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775760120; x=1776364920; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RRmCUdhZKwH4QD8153zHmJo6T6OgpMUjlI9kfqLfR4M=;
        b=fOwwzcrPGFAkaWL5Ld0t8FKoyaJGEmp/AiSEUD+LoXta0QI9+D7AlW0f0FEflXNOhr
         WWJlqv0f5sk1u6QAgdDuyuqjX/prRDxQxlQVSDvr6ZINY3mO+dCRW9jTujMtBGTNr/Hl
         YuFPiWtrwg6arGDLNX4+e1q+r9V+IZ0+YWKJjcll9iKW8YjqXe79yKyErJF9Hl0CCcKt
         Isj39MTnwYv8TUNez+vyC/LLWISic5+ZWeLvSB7ihMP1A0xpbcAg/JE7D4gqTSiURMz8
         2uyN3AtGHUiR7CwPPb328C2XrHkT5kkeaDZLLacrF7oiwnGSPQKyaS2hY8PacQ3UlSXp
         aM/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775760120; x=1776364920;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RRmCUdhZKwH4QD8153zHmJo6T6OgpMUjlI9kfqLfR4M=;
        b=ommEGTypzzhmTd4rVmanp60rINBMS12LNRdbRILs9+bO1MgcuAj8iYW+pVsPX6dMiV
         RC/npbbdYxtFCgoLNzeta2d1ZLAuoyY0IQucIpNQji698hEvm6KJGTjMYp0quT/3p07M
         M5neeABlenHjrwJCTcRyRfOmLTbJBQoeSdxK+GUr3AcawIXbtfJGVB9mXRq+Eb7WTCQD
         CLYFpv92Q8L4Xqz5jkyYSjMc7gjHsXlYQC/P/aCx7TrvNEKPjRppolqSxxUFRIVjcUfq
         P84ky9U4nj9bNFacU42QtSVntS0AXOTgJ9RoY0jRHPZaEjoNt/0DtlTvfEo0ny+G8OmN
         IBLA==
X-Gm-Message-State: AOJu0Yw2KF8JcNgeybTQ5spd47ctf4TnM92A95uZWG4zsKB5dtrsWkqI
	pr2/cIw+joswmvwx7SahlmXS0YFIHvPRLsA+rTbVwlnqR3wZbHi+sw45
X-Gm-Gg: AeBDiev30GTg5cTzUWALzTG1cD9fVS8zpKXsae4ahAC6BaF/Q4bVulyok8rZ/aezFrd
	emKav+7UoZnnCo5uuITB02d3qPW3TFKBhFPtkPmwXkEOY0kIHvJuNCsb0tjsWx9CSYZZr10O3yK
	Dq0hkHaSRQljSDPrmPyCWBFelieomdMLeqnKpRBaJDMTYq8Czly0QuyHI6JW9fP/z+6OOK+JWGq
	c+mQu5trrA29PDkpbKygUnUqCe1QAm1XZvEHt0iOz2eASo2zn8Wq6UVR5cTo/WCLeU1AzJf5FlC
	xaL5bWZeqKOP83l6kcKJAAvOMDaSzVC8h6oj5jLXGQoJTBWB9Hum/u/NWtO4eV7fUJhHrvTOo6y
	0gAJd+aCh/E9/aYsUIfHSNL69GnsfGGWWNj+6Gw+Kc65b0nU1TtY0Q12UBTYjeg2eeA+iSe2yhO
	VXOWjr8kLJx4JBkpobEag9RCwTrGWk13sZa2QYUzNZ/VgdNNM2DQ==
X-Received: by 2002:a05:620a:294c:b0:8d6:bd01:a67a with SMTP id af79cd13be357-8dc3bce874amr691692185a.26.1775760120457;
        Thu, 09 Apr 2026 11:42:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb9637c5esm16141585a.38.2026.04.09.11.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:41:58 -0700 (PDT)
Message-ID: <7c470568-0bce-4200-981f-b9fbfa94ef31@gmail.com>
Date: Thu, 9 Apr 2026 11:41:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/311] 6.19.12-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260409091742.514769762@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260409091742.514769762@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/26 02:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.12 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 11 Apr 2026 09:16:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.12-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
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
