Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C6B3803CB
	for <patches@lists.linux.dev>; Mon, 18 May 2026 18:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779128359; cv=none; b=VrqOjo0DoKE2jXfp+NDTlrJsIRfPXVveq/+iWIQGCHNJy3CD9Dzk6QiBx5GJ9/I9/xaY2rPGB7ONJ2WdCc4gkfMecRYtPIIxIw3UUH33RFARxgBf4MNGVPL6Ms6oFnOJg8i+8zw0oAavtcxj8cOUvOcKF4oRkwMBW6BSEQN7EVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779128359; c=relaxed/simple;
	bh=L5I1Egkty18Oxhk+NikpBY/EXVWM3jPPMiyr+xwgYmk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b6QTGilXpvdsIcKK1YCtJq67PjCn+CMs6gmJwevXpeOSmjoRx3DgB15Cbc+ZET7tUNmY2QHxXHxMNOFykukzwRTk8zQibbPAiOecX5+J1d47Tj9m4RyHfP6ZJmGlJ5nAuD3cgwsy3C4kvDn4+K2DA5i2Y1K5rut5WiBd3eRh860=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aAOs0RV+; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aAOs0RV+"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-464bba3a9easo1738264b6e.0
        for <patches@lists.linux.dev>; Mon, 18 May 2026 11:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779128356; x=1779733156; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VCtT6xuhMHaXw1nHALH3FFemEU2JIAPerrti8zvo02Q=;
        b=aAOs0RV+vV75w+nVrxN8EJ+GbCRLtFkPf73dG+dAF9rarqYXrYeyyKspTojTv4USJ3
         E9vqrlBo7TZOO3DyzxoUyK1I//qNSRO1HAnE4DQxV9sIeTwm0mYgBWqTohZ5fJio6OJj
         1uoUvwuth2P97D+1r7fgM4BSuRWX2+oZ7pyDKuBYewK5VbvE4soeL/JBATdP+njIcjVa
         NMXd/hlc9e3pTvTeolHjmeFUhdn4iZlGS5nCF6yv4iY02kaiitRF0dgsygLEiXp+xHfQ
         kZlczpANa5aqizI6Y3sZ48o0fBo8rs3iyJSX20qqGbsGHOL4cpdVxhpVRHDEa4oVZPvQ
         dd/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779128356; x=1779733156;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VCtT6xuhMHaXw1nHALH3FFemEU2JIAPerrti8zvo02Q=;
        b=HTwpCApQ75c4XcwhFjSrWQM1siBRTt3Vj6XxSOEHzeMWvARTIuPCnXGZeweRdg1ol3
         L9xk1uuTy3YvdU4GFJBwnLiuLfB1SwuIYNHnDGqFe9xrTki2ZDSKlCMk20IYwL1Chokt
         53Ouz/wsdImVgesjYd7X0oYCdScQ/GKmmDEpC2cYwQRdOllTrrK086of8RW4AFga2bDl
         l6OBHs/thzfdzXDzafhP4Dr23xrNAcwKo3OqDA1iGBAz/uov5u+6vplczs3t5bW9L71j
         6XQhFVMmAdp9pNrATc17q04ofHrAlnLZGLKuahfWdEM4RBzGJBkNPm3uiU7VWhraiNVG
         8O3w==
X-Gm-Message-State: AOJu0YxJEX1XoeuU4ZU2BcEczpApLQr9Shf3m3LHmIqwxJlIkwBc/ET8
	yvF5+XfyxhEMtNQWnZ6Mw5FhOJTEWObPy340OqJGy9PG4BK7FWMqpxtL
X-Gm-Gg: Acq92OG63Y07CnFryixM3jXh8+9q0r4KxrbvHnzuz5tMo+viOIGSgJZUnJYDuyGJCbc
	2TcHQc1DiUoc42klBNNdcvEFYZHPXat0tHheA0wO8Pbsg+SB2gDdNvIwPJpkKPFu2h2IIIz+kdD
	JFbfWFuP/rjojZkLIX9+qW9dSnBYu2DGrpWoxwoinSsc886gGvnI9qVq6bsvbYTti3zZaAfPuTc
	5rS1Wzodt5Do6QqsXIXfWAT9l1hUEi2A5lY097vIT0wWRb8M+UhZriiJQ+5pbzJuXhqCUmkBdwz
	SUIRRCMZ+wgISt5Js2TWSjwr8H9TRmpZTSxUUuaj56AF22/i/Bo7bXvcpKBjbtcFECsqSjLI4RR
	Ify8eNDIVAsomFE9Mur7Ufuc+sa5APwFUvOwke49yQGpARqepdmSTSFngilKwlUOliUW62tUv+2
	oJ/KMGktDpJTbqcxBPIHVkzkNqGCkSokNldhkb84n56BqvngxyZg==
X-Received: by 2002:a05:6808:4fc8:b0:463:efb4:f9a2 with SMTP id 5614622812f47-482e59468bbmr10642289b6e.28.1779128355915;
        Mon, 18 May 2026 11:19:15 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-482ee389209sm5469316b6e.5.2026.05.18.11.19.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 11:19:14 -0700 (PDT)
Message-ID: <537ae7dc-c2a9-4fcd-b5fa-0fec2831781f@gmail.com>
Date: Mon, 18 May 2026 11:19:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/187] 6.18.32-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260516102236.209957148@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260516102236.209957148@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/16/26 03:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.32 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 18 May 2026 10:22:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.32-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
