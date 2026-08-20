Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542CE3ECBED
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 21:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787261659; cv=none; b=X6zunuGknkRxzLTOR37gfEuPj8emT+sOZ6n22OWi6Gxqhrj6KbA3luQRdTo/vcsrcXPEWGYzQHjuageHh4TYGmb0hAi4xB/gaXQZKIjT2Gj/eLQDp4uNJNgF9xwtpBKLaXOeTvacXOhvYQMOCYL585gW1Tng/2f1De6peJq/Ack=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787261659; c=relaxed/simple;
	bh=qIkB8dKBo/wt3b4yl3vtKdq/2WMENY7BkaeDoAJE/Fc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C+/2vRGKMvyNoa8Fk5TZ68UmhS3Wzo2IZAo0em8nPMtc9CmwCEbVtf1cDEF1fJb8JB9VMNv51wuWsMjZJIiyda+0gZgBNjRqOp7AvbietuXKpNEtWYYHJQkJZgBTX7CNiE8s9RwX11WB44bSu+n2XqHvPudXYYqi9KYBTtERYkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UsJV41lK; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UsJV41lK"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84a2c90e383so1042886b3a.0
        for <patches@lists.linux.dev>; Thu, 20 Aug 2026 14:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787261657; x=1787866457; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VYXoftc6soVX3yMyRggyhy2ugeoCiVfhvw3PG+iGTkU=;
        b=UsJV41lKUxUzi4LS97iwxteHd6kaslK0dNj1sspWF5JD787a7ugkq3tya+xc89cr8E
         Jo/ZAXD+4PUkUaYQVGgAxx9RGmmLMAPXTfJGz/kZpg7y4820AGeCPwcYIVfQx8b7DE+b
         7Yp8R85UsgPn0CordZbssgLFLBxNwS24SNew5agEV3oZHjHquORdDkNtH/uCnBQ1vWhS
         hZ2PLyrMvgShD7Q38ELajjYO9/6rzJGE0xoFxfMO3Ng5BgtWMGsdi2NE34VTm2ghOBXp
         e+vptQWf5O+bACAZT1y/HsVluclvBsGKUfm8aFTSTqJu/ICpazC2ACI2YTnuHDXiilHJ
         2p7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787261657; x=1787866457;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VYXoftc6soVX3yMyRggyhy2ugeoCiVfhvw3PG+iGTkU=;
        b=GPQeO3Fz1pmynjIB6+Q6SQxyPRFcjTkxUl2s5fex3OCWYlbqRk+DQVzeGls/zevDpt
         yPTeQv3WGo2o12BohAEXQaLmhxbUb5TlbWPpnpTE7mIPcER3MwjVeaPlvFNqnRj6kQaL
         hqoAhWwHubW1Bvqw8BHVT7DdI4+zi3mBJCMJ/CrI5O5DBVXl3WHCveSypWv6CfGUxBPq
         MORkCWC7UxavM5C3H6oo8cLGBbZowaXmGo7qLmxfG7nPgnD8hOrilpqgNq0Pv0F2FFLk
         jwq8DX3DJhsiorlvgBOA3WzlCmLgXvhzMskTW7DkORymr+R5SlZfk4eNW9eHoub2Jk46
         BF6Q==
X-Gm-Message-State: AOJu0Yy8GphZOFaDe88MW0dSZg9ElNerx6X393At1STqTi1Em0/iie1k
	l/ebP0XptIrfrJBOp6cE7MTyGTYKYamMYSQy64ZMsoi5SuslY3RDyton
X-Gm-Gg: AR+sD12AVOfHTQv0/t3Gki35tw/x4XKAg45cByLtJpmgceiJTEcWCA8s5IgPjaze7ir
	TrutndUiCeXA4tW9ZaR8L7SekoDuHFYbNUzb+JUKbq+hBL0q9Q2IR/F/mpdJvJISlJsupZF/SIp
	7a1CDoP1Zj5RT1oEQ+6oRJHUt2Tz9p1J7g0S6EqSK+IACy0z1iXrGzDCFCDB697MZPFfUAlYugs
	aYIZa9SgvetInzNezf761syDbjr86+B78FRzvTpPVDDym5wuyLw6wB5+Rizbz14WMFwUA6Mex6b
	AHg1GA/HwgugfdCLj2WBWe2Ji1s9i/5nxZ+AoFX9RqrTpKhYRyQhR7HqN4xXxQEowK+x+gH5bJ4
	xswR9ie7PrDWOC4xqQHKUBF4B6m0odw61Sdk6wmckQF0XDMZ4stjZHu9HnIqh61LsE7pI5CPs9s
	eFlvzLYqNjovhevXdDBvWSFmyMU3w+c178XW1xWthnZxd9ljbltoBFt5tJ2wMKiGc9P/NlGKgVz
	aub+ik5QnYbwh0=
X-Received: by 2002:a05:6372:a749:b0:3b4:6af4:bdd5 with SMTP id adf61e73a8af0-3cd14fb6375mr10162877637.15.1787261656657;
        Thu, 20 Aug 2026 14:34:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bf175399sm34681017eec.26.2026.08.20.14.34.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 14:34:15 -0700 (PDT)
Message-ID: <708ec0b8-a829-46ce-9c53-e0edb32cbd35@gmail.com>
Date: Thu, 20 Aug 2026 14:34:14 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/166] 6.6.153-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260820145211.194104353@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 07:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.153 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.153-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
