Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C6D3C13F5
	for <patches@lists.linux.dev>; Mon, 13 Apr 2026 17:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776103191; cv=none; b=B0gnS+30lUsyMwX+IWzbuoNxyLRZYuCEZpKOolecVNsS4sp3zPiMHZMXE33ol95+VLbyM9iZy9zznUSnrm9PV3MN1NdSndtuJp2+BAdnW/LoKjClOKE5TiFjuEU85FSttkbeAQ5xU5xam/52UOOL667yuNsluUuzRKogNpDRN0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776103191; c=relaxed/simple;
	bh=MXxEALZQeY7mo4WpT9kSEYRb4GlrZ06qXuiMKIFJ/BI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IQ2VeetBAhilFa00fmsVeZ/FSpIJ56WcdW1c0IOOqB0T44dd9rs78dRJFwOhv285eclRODFQ1zvRM5wIAcMqApDTtxFnYdJ01LMIMoSSvM25BlIV6qyENtAE7p0Ne6PlBLXz7vjGttYhTiIRIIy6I82uQ7JL07YnYM3E3FAyHmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X8BIq0yS; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X8BIq0yS"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8d6d5e45c43so563855085a.3
        for <patches@lists.linux.dev>; Mon, 13 Apr 2026 10:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776103189; x=1776707989; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OPxBHy0D/fDvlZiHd8ibuhOLZoXAtAn1c1jSfW5Qwjk=;
        b=X8BIq0ySP4+v3RTi3MelLGKMlZiZPfn91OkR80NfFvJTUE5D5Pg/psHRmcblqSEON8
         4cczpsxMTh1H0r/5IgWJiABVZ8AsqCDPqU+2wuZx4tU09BrYCxn8O9l0oHUFWZBoorcx
         2WUdFDFZX3B1tFfgm6pB7uTMR836rOsupaKRhZ6XULL1GdJoINfpa/Bt/yTJX82cqJ3i
         reZBbaq3/CcdQq88frgBmNxVAkXczHCdmgT84nDNl3tyWWncbll5FyALTBhlJwJ8o07P
         txRCendgOxJp3snvBRM+CMcphDUxRoVxp3SzdcJ3ZH7/tsRe/NiHIwMLjyclEiXdrjmu
         TnUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776103189; x=1776707989;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OPxBHy0D/fDvlZiHd8ibuhOLZoXAtAn1c1jSfW5Qwjk=;
        b=PC9sUgizWPVsyKdyo4tIa1Ttmj++9PMcn8e4Id98gLI0joCHsNRLLSTt6GiisAtfXq
         gAd0yeSwb2uiITUQ6YVfAlYDSr0pjzhwan0s1CzdekZYobWmItNWuWCFhkzija7ma3s9
         Kjtxrgg4di7Qk8LGllYl5LwQydNLzXZbVbeZBkl0Wo8MkuUpziZxrx0Fs60pR3jLwsKj
         E2rzK7PbczDtPv3r8M6l72gJKcA2oq76wkjDqKmgPHtb7pcTo+80Q5Qi1Tvx6u+ac3ip
         +6wlnZZDvdiQ6eM6UA4BMP0IfgBzZUXavHXhYDXj+qvDBQ+uLZDzFGFsm2THozFAeO/2
         UEsg==
X-Gm-Message-State: AOJu0YxZXRGxzEZwEM9/xxgCz0T3chCdVIgQB8a8u5uv5oG+hbwleUW3
	d9tnFHOYwMiOOBqEUSTEWTvJdJ3PsvfRfShphajd8wIIh4HvWZ164M1T
X-Gm-Gg: AeBDietj3Y0f4au1JS17H7hlC+lQHmm4bGZtHEkmg4gVsNaffYmB2t4KhZZrEc0IGxt
	8Er36bvi8UFXN/sP2TF7dJqvixpX+BnHWM4icTn+jhmtNEFMZUFCCg3VSMcIQidrBJCgpkhIvyP
	W9JZ3MDTJhlRKfexZ6zuVCA6wZu5mZoWHK/d6RefiiqqLcYsOhNGenORWi9X0XqYJwGow35RnVg
	L/f8cAjdDtARk4VoCzWLRv5Eh/ULLYfk7S/GPC/lNuYgKHkSCX+jsnVRjJMdibAwJ1ueaNRrI4n
	MEscLtGYD1W5lT/mS9WxQp17ijfFpxwDf/jeAroHLaInrudFbnLJSepwANLJerAiebVjzfXArbK
	8aMKbwkheKrH0q5lQUp607trjNkpF5aVauF71kK5aMSa5bWlPdkpNhIqoEYR/xKL7tvGYMyx8YT
	qFlagPEZGBLw4KaR6Wg0RpoJIU0TzpcJxL/rF6JjkbB8BwTUSKeQ==
X-Received: by 2002:a05:620a:19a7:b0:8cd:92c5:b3e7 with SMTP id af79cd13be357-8ddcd8f4124mr1894202885a.18.1776103189122;
        Mon, 13 Apr 2026 10:59:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb934d8e9sm929818485a.35.2026.04.13.10.59.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 10:59:48 -0700 (PDT)
Message-ID: <72e59812-5a7c-4041-b33b-f8089b7d3db0@gmail.com>
Date: Mon, 13 Apr 2026 10:59:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/491] 5.10.253-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260413155819.042779211@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/26 08:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.253 release.
> There are 491 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.253-rc1.gz
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
