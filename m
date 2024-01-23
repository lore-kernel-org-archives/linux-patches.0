Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0249C2C1BC
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 21:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706043956; cv=none; b=WqRolAJTir135xC8sopHMl3pd7Gb2QfnlwCBhuMXt1ZURdF4mz7mih8LdtwgoLBBpMMqBPpgwIXEJ0D2gujwZsbWa/8qBWcOjNvk8ygH9iE+4W46W5GFiNZjcpGbmumfWw9f7B5LGe3nmqy69sTI2bV7N8jb6OQoY24dngYhV/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706043956; c=relaxed/simple;
	bh=LAb9jklOkanwcFSMqF7FXyCYHPIYqxV3pCk8iroPxPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RjUR6RJGfzbVLz8glClYRXmJIr4nbn0W7XWOIUsEgvyhGAI2siHDWBFM70VrL+bUl9rzd+Xk8NL28yuJz9t7eFKi4IRbMSzIdmW7oBmifrQFSoiJWPYIBT/inLI50eUbUeUJaEBAJrquEnqAigydf5wNBmdBGkXnZ3SCDckO5E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fxsx3mys; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fxsx3mys"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6dd82bfa998so850068b3a.1
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 13:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706043954; x=1706648754; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w7hK6N5tABRAYF0lmWIqZBB5CM9z/KRtcPvdR1T6JwQ=;
        b=Fxsx3myst5Z7LOY/HgvR6K8qNINy2E1eNT08Ymzv4GL1/aLUBY6JL0coDop/wym6r3
         pFproMXLZiRrLQk3rXMWqxKXXEO+zkSMTnQaHCYF6s+Alwgmm05+aStwJGdvGLZ75Dm0
         hARQn9lI4MgEY6tBIhx3Kh0zEo5DddTQr+0wo2nkzNuINMnRM4bJl6xbRb6qgBbzSVGO
         cbwy9OyIfq2XFlQ5uyUCtcX7w+r2jl4n45AKJeZe6kTIhv2Oy0f/j2iAIOkoW/ytYlHV
         BMl/YD2spCd63tda+y3cWWma1P8mGwzPENnq4Hn+IHmHmIFSDxbBwNjqLdkyjU4cPjSQ
         VACw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706043954; x=1706648754;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w7hK6N5tABRAYF0lmWIqZBB5CM9z/KRtcPvdR1T6JwQ=;
        b=pv92Xd5ULE5MXl7XCzVXSJeptTEv1HwOroIgW9zavg5lC0+OsCeivjGcNRNZGSSnZF
         e95qNUq+JosEBGDnAJumf3fXCLQZCj9QTRQo+/UI+HEAJWR5SQHQmdP3JN3d1BFlLzwz
         IX9Tdy1qep0vBKkdpSNY5GqSF/aqXi+OIYNHcl9ynJ20xbdjb77O8tT/BqX3LKNW9MA1
         0XzoUYCkVEGpjhe8fQGjAZTfib8nwUOSUqHBHGxKOg66FMvk3CIKEE9UM6cE6cu2zFF9
         tFRqWlyhJ4M10GjE7mWZPhu7VB75EMy7XCb3mzVJXCZi9dDBBlCINuaNI9QQfXenuIVm
         YDEw==
X-Gm-Message-State: AOJu0YxfWZwNE7wBOGOJlaBV4RkLXyBBBgH8k0se+BzMRgGlCXzveF31
	psd7zVCoWrDLkDxk06gsXW41nCcGyPCZ4+m00ZIdcc6fQobBOnus
X-Google-Smtp-Source: AGHT+IFCQdc/lC4369UHbvonoAAxgYklZsl5CIX6YXP3UXsjFiYldD4A7+R7kQnrxOMVaJbFsL74TA==
X-Received: by 2002:a05:6a00:2301:b0:6db:e463:96d0 with SMTP id h1-20020a056a00230100b006dbe46396d0mr3570881pfh.55.1706043954244;
        Tue, 23 Jan 2024 13:05:54 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e2-20020aa798c2000000b006d97cc5cc13sm12140361pfm.8.2024.01.23.13.05.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 13:05:53 -0800 (PST)
Message-ID: <c8aaa17d-9e3e-40ef-95b8-485007c48047@gmail.com>
Date: Tue, 23 Jan 2024 13:05:50 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/193] 5.4.268-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240123174434.819712739@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240123174434.819712739@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/24 09:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.268 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jan 2024 17:44:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.268-rc2.gz
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

