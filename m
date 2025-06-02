Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B21C1C8629
	for <patches@lists.linux.dev>; Mon,  2 Jun 2025 17:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748885393; cv=none; b=phcxN137LLP/QxLagpBchIhWkh8gxZD/y8bEDmy/UL6hdDFMgM8WeGWOWFjkgTPHCbNbAO3+xKzw9OkUbxwL1CEqp03wCvaUIo8cIF+/L8hzQanL9YsuQglcOiZqbaLC/PMrdHY4gb4J3VIEpyBCzVyW4SWcebYkua7yic73M+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748885393; c=relaxed/simple;
	bh=/k52fvERoV6696ZIQjDt/Yqaag8+kqaiCAcdYh+ioxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RjxboLOXkOxP5CcFogR4YjqDLi3ZoEX8ew2cGtKZQPm+paXn8xY6h7RoUu8cth2aRBI8p0EpvbcjcuU9BE60RriGowFO+vhZvV4BUpuuNqB02Jq9RYWodtQYdZKzhQM8SiUiS1dyxsvSfR47ViaBejJ2LLQivLDGtUkd25htZZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kyD26h79; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kyD26h79"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2350b1b9129so26960105ad.0
        for <patches@lists.linux.dev>; Mon, 02 Jun 2025 10:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748885389; x=1749490189; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=/uxZx90irIwx1TMKX2TekSJ6Bc0YQ9kHKHz65xqfy+Q=;
        b=kyD26h79CvPD4BGC5/AWY8YKa2SAWkltasGAhk8GZP+HKszorpfYzB7zlKDTQLJ8Pg
         3Xx04eGS8WKF/KuW3U1XrQYwCf51p8yXHKlsbFJiqHXzH3YQJX3Dy/p6DTbfmZ7vuOqz
         yWYFtMUcbg5TOEMjMBNWZzXqQe0BNTMTDnnW1LXWTTW7Y58Xtlrm+9R//EB4sNbaA7sH
         /z4NedhTUEt0iGatOtph/y3AETpYbulOU5MIWNQVyk/yBIua9xihWrRiXn9utRtF+Pqo
         B0Phkyxjnz3tTw3CO99phtKHuNpLlpr4zwbM02fG8iXuwPT2uorx2WX3TtZgiK9PlSJb
         k+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748885389; x=1749490189;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/uxZx90irIwx1TMKX2TekSJ6Bc0YQ9kHKHz65xqfy+Q=;
        b=ga/57A+4l135GroFdGuBAZ495EJVu2XdIDgNq4vmkF7zgj8iw0OTs9uD887u0aYSEN
         YdMmIdC3MgOEHFjCtUvaObtzF0kH9u/1Y9uULB8yDzki/cYVtZGrwmeP0kjXYUIbkRL2
         mFRrkVSaTMn4mbAjjD3wE3dnXp25PnInkgZWCTowdGtBak9fAOXPJ+9ZCgQ0rgJS4FVg
         fjLSVMCk8vMgaoNMTT9RhTTVr/31GBFOlI3tOdoizkR2sFIBsyYFaz+xLOXscg1NjMtZ
         owFEt83vGjWsazqhOQlfchSeRjdXw5cGzY1CcOMp+Hc9/JGpZkjo08ID9yQKu9LD7FSw
         6UbQ==
X-Gm-Message-State: AOJu0YwUhhqDkWcjDJ6gLcAvvVRnFpQH/PXQ7L0qVweExmhajh8lpEOa
	cK+/OVn+PertQGK4dn71FshBNfpXG3jNt17klVU5cE4xWZtKEatiuibp
X-Gm-Gg: ASbGncuTshQ13f5hmL4ViO0hRJUHkIXljbqS5SlQ3ySFj4u0bbnB+CnE81rY/NqIfA/
	Xet9ouUiYHp5EtF7D3yyx3w79EMZoPLdllzXHSL+swsiamV2/oJ7MVzbs9peE0IffgjkTpJSMpQ
	w4nnhQioKl76TrtvTYdnW7SZwvoqjExqL1cGkkigP4ccpfX+LBCt6ilO9/eB1qhivfGMuGxSm30
	2z9ZpakY8J9vW16ZECBkuJdg7t9WIk4FCD7p87e9U4p75hK6oAhUoehCtmvLlwtX+hod4lCFHJs
	8fZErYNrclJy3zX0+R3MDaJ7ePDQD0mmBPwjx8UYDNWtbnxGoItabTMjg2Gozf8wA2+w4vuoErl
	rIgU=
X-Google-Smtp-Source: AGHT+IHsQwAsgpXEgFwRa0MDFr1nPaEbL7Y2wjlCeuBsa6w5UKvZTbynN+EC/rV4/tyj7X77V1aGyQ==
X-Received: by 2002:a17:903:2b0b:b0:234:d7b2:2ab4 with SMTP id d9443c01a7336-2353956657amr179906875ad.17.1748885389519;
        Mon, 02 Jun 2025 10:29:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506bd943csm73768645ad.85.2025.06.02.10.29.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 10:29:49 -0700 (PDT)
Message-ID: <8c4df7fa-e1d3-44d5-bccb-b246322b8b6f@gmail.com>
Date: Mon, 2 Jun 2025 10:29:47 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/444] 6.6.93-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250602134340.906731340@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/25 06:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.93 release.
> There are 444 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.93-rc1.gz
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
