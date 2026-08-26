Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED93C26AC3
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 00:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787702963; cv=none; b=A/KMlW2IxD93YvkjRHvOb2h/QauJm9JoZ2oD3U2E2LYaKmRcVwysBqGM85oxJN1aOLkNTm5MiM1UP228Li8yDXKOWvDTA+KfsTPYhtfYCAWh3wrqMBjk0lEPG1Zmru9143x7HDu6amc9zEcZm/KI2d3+YkyPt34/yKa//0Wazhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787702963; c=relaxed/simple;
	bh=FaH2Tq9QFNbgeAH8IOjswCrrYKuq1yzZpbN2j0BlXFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jj5ynwZ4RhusCjGH36OA/1Q40JsFfPflT3gvK3sXVNGkfMiD3g6Nw4q3w5V/RRpcLl/Y6YX4Y8v95ew1e1XnM65O7i0V4mtPVUrr9eTEJGO/eWDGHxMOr3JmgpqE6w84mlYjE9jfhwW080M/ICSMFLmEr5gnKHbdfo5V3oRv/3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5gL4scC; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5gL4scC"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-4569e871502so383232fac.1
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 17:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787702961; x=1788307761; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lPql6cnyypO7jMwx4hb9J0beiqnyW7fxD+DB1zPYgkU=;
        b=Q5gL4scCgN4HjziokJhmVGtKJbLuzSXkqoT1R8pVW8IdpRdqJS9s4ij72WOBNPmpjp
         UGEgbsi3Zmpo9aeDCcIAkoKG9XrA/xL/apHod4gxDmd0pTmNqsUrDmgDvv8jk7PK6Tqy
         d333eHxvWqUMfU71Z6hvVkmNckXnlGpx4sy7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787702961; x=1788307761;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lPql6cnyypO7jMwx4hb9J0beiqnyW7fxD+DB1zPYgkU=;
        b=LJ6FqLj2Hcm44dWODv1d3ZcISCohPA9UzRLzH86FseJYVAfv1puJTmGX1qyCtjQp2f
         pYei1peuvKOV13SQmtiDkgPWaVxi1YY5EwRQ6KWTb81xb4gMJpzA7oO2wN96A8dUE8mN
         wHLPQmjcFqOhPx0e/FE8OTyPh0Sx5o6mwpuVN4DPXZbeOoINfn8l7D7AJltX0AsvCTI2
         xC15keP/ND7FgK2wbGGtLUadS7l/HyESOZ2oDxlqUYrB3T230QJsnTC45ciNSXEt/FzB
         /pet2aKMJQcxgUbImMMJF84pYfhySJtnvOacQkxpZx6Koa/Voz1aZEwYOzX2Zl+K0cRA
         yRzA==
X-Gm-Message-State: AFuF++lOJoC/w/EFhtlnlyOHCkbpWIKnoEqVx1L3dhHKYR2QZe/fbt5c
	7cdJWQLHRSkKxUzUql0sg5sZiRnSBcZLfF4UNUlH2QHK78nLJozttR1beKBhskI/8+U=
X-Gm-Gg: AR+sD133xjCTl+W3KwasO7cHDrkn+OuRSw3+ix7uCK/HrTt8wCBB9y3PvWu/txy3ycC
	1sUGqtzpbaaKKPgF5c1muQ3iA6ua9snxp5+2Ng1n3lMgRrhS5GbRflMYwm0F2WpvBS6C1Q9Fk1/
	LJTfNxthhabVi/3WjBSRVwh35OD2JK8oQpOcAQteJSxw7xNlE9udxatMDhfAiZPAvAMBdPy8LQ7
	2/nNmv7hmncXPnZcCMW80txSK/0kkDvw3hI4qhI1XK/vf2rfIV/S3Hqj9LgFzmEiQ1neoGM+l6S
	GvYzN3yY63zsB+L1iSQawHMe6daV+ZOA1U9wyNoPJQ18Wy2zKHdAeOABpfLB+iQshJd6PcalZPw
	j5wdX8LTzto05E8SPWq3oFR0+tlFy+8iZjOd+j209LezVKn+l1isohr5Ql5eZoNAeOhiwvKnOct
	aHcb3ScZ+dekcQaZcMPPUtI148/lsTnvYxXNDTrxxutCfmPAJ17WNKQRZbWn8IXYVMVoAsjQ==
X-Received: by 2002:a05:6870:aa97:b0:456:55f3:b8b with SMTP id 586e51a60fabf-465982c1799mr4010595fac.5.1787702960757;
        Tue, 25 Aug 2026 17:09:20 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-465afa1f389sm739700fac.10.2026.08.25.17.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 17:09:20 -0700 (PDT)
Message-ID: <bcb5d410-92d9-4c22-87dd-286866c96723@linuxfoundation.org>
Date: Tue, 25 Aug 2026 18:09:16 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/77] 6.12.106-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 07:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.106 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.106-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
