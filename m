Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AD3224244
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 14:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752675194; cv=none; b=HbWbiqNeiVzIvQFaTLMBqvAtZvrNnioCArOZ6pAtEaJUAj7AUOy7spjfOT0uQL3co/NL/5flBpOyBHGEawH6B5an/lRfMML/nTRl+VsQtT/FvzSL+O1Ge0H66jIzmaqB8xq9fgm6To54wDZ++fd7XqQm5mUf449W5tfjOr1DntI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752675194; c=relaxed/simple;
	bh=9KP0i5+cSVpJWMEJF5cFZAgK0HCmNuvp123htV7QtDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K9Mxn9j7bD/XQ/LNIa08HY1ZXhU1BppepC8RgWtVcMYVGU26KyKDBwskpD9X611cw06YMm13C0tgBVrov3K6RJ+uUji0XK0XZd9bvEyr8aNSbdrEs96RkodQ/HXpYKVF45po0/REOSlJLqPUBbKBJGxSOjwrU+jzablFxnZCOto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKiN4rJu; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKiN4rJu"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-8760d31bd35so248670639f.2
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 07:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1752675190; x=1753279990; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cun1QCF/ovodSSiSCrQbvW5XijyHxrC79EnA8g2Zp1s=;
        b=MKiN4rJuFsZOY8C04uBbQfgKEDfrmEoqx9UBBGuS9jsSQQ0Loy77a9FrYnG2iheDVt
         mobtVLoPxvFfX/XoJGyqzE7bjSVRgDKm/I4i90bhk0zvrleX9sv6T3Q7+/J1NHEUvEpC
         KdynTm6VUs/28PwceTNv4rRkYFg13usHvNr8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752675190; x=1753279990;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cun1QCF/ovodSSiSCrQbvW5XijyHxrC79EnA8g2Zp1s=;
        b=h9zYJbDHLlqga42YbJtxK/S2JoVDdx7If6bUOh4AHYCtpin/gkEJjpmOVHhwgjD+kw
         cAph3g0EzrLW5YlGvGJ8kmVz9hRjI/YYH9DPkVuK51aYquSmPJmekbzx9yCckn7WNtLS
         yvtF1IHtNC1X3DVFGWxCMxhwfh632xrvkkPBCdvxa0ZK5qJetGBnsx7kUylFbmA8ZVAE
         a3hTPsJ2/iw2BPyuBRWRW24+Tk15q+Ywhnyi4ndr3G9msj2HYpQiRvWjGuMFn8Fo8pif
         e2SR66wvrBM0zlwJ+tE9gFsDV9rdTba8jFKXDEU1FG+bX8LXeR9alvJK3l4gXgOgrWnt
         n51Q==
X-Gm-Message-State: AOJu0YzeS6tQxUmvGBpqGOePtWCME8fnnMGVGFGHu4g7L3WvNAlIZpH8
	8DLerJpVGGpaCG+hbf6Tx4ntRRpNjJgEM9dHM0KteCq78Na/IOMvrSjrjzqWvTHJPwY=
X-Gm-Gg: ASbGncs+sbDvSXxrBLwa2bbRDrsT+Z8vQP1vEULVFuuMJPCY8yNP90rkyIhFdkPwx0n
	18zE1mwHpv8wi8/8KvN3AGU6Ra+8akswzGgoal6NPGC22eR7axvZQtSrlYIQEtnyTbapzuCYCyh
	mCiGhOaDHAFtQDL5V3REVChDqYiERFfVM6fagdV55EbTFTe8XLe8Vwlqf/ZwVcVSzkhYbrZAAE5
	xf8ySGpTtquvhYsbb7XU7F6yfSE7REzSzoXwzRAz6ByTeK6AYQ1svkeFfLPphnF/XDAoH7brcnY
	D0Zx/Y9R/uDF6zy2pfee5b3ONseAC3qgTUr7iUveeKcUZ1f21BL0ggoRoqs2ovOW8ckJmGuFXBY
	E75FPW48l3OPPdOqRGfUthCwezXLkIm6xNw==
X-Google-Smtp-Source: AGHT+IHpKFuCwjn3ngh9585q+QxCCdOLt8vZn2f2O2xTlcTneZ9nwwto9RRUsv4jwjnpkK+gfLiGFA==
X-Received: by 2002:a05:6602:a019:b0:86d:5b7:5a42 with SMTP id ca18e2360f4ac-879c08a606emr438776939f.4.1752675190609;
        Wed, 16 Jul 2025 07:13:10 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50556595731sm3062897173.42.2025.07.16.07.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 07:13:10 -0700 (PDT)
Message-ID: <481a8e7a-19d8-48f8-84bb-5a2a78b0e815@linuxfoundation.org>
Date: Wed, 16 Jul 2025 08:13:08 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/192] 6.15.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 07:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.7 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
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
