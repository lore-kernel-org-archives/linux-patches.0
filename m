Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A735C5FD
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 20:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709671909; cv=none; b=e+LMMJiIu4HxpZ1cwi+jJSz3QH+TKpAtacP49cY9yADoFudacz5UZXORav6vk059s3oWe3AcryFkUumpUBhrcbqsq9j26jm+vzOHsHgSDqJRqbfn/pNQ+UCPlT3VZzkkUcDwiOE9xIc2MbH9JR0O/S7b9hbeiLRCcxdaR5cGEog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709671909; c=relaxed/simple;
	bh=SjSiPVcEcyD4W6ufsE2+x5JmNWbIASUDZW/T1vteaWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n1X3dFwvLBCXMib2aTOVzped5rHr4Qqg6UFsXhj9wgS3AoXnjoKLYEZS8PdNp9Nn4yriOkl693RSuEzJeLx6tgrypcpE9jbUKEmjWxiFWvIbVhut6w75BioK959FalLJ/KSIOflN04gOTmQw1rcu0vh4P2/HDzX6WwWGCRsTz2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eCarhDAQ; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eCarhDAQ"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5d8b276979aso4490306a12.2
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 12:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709671907; x=1710276707; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fnn+qBNjgeLnA7Zdn1ytKrCjMf49ommBffpdqi1uL14=;
        b=eCarhDAQcXquJNKrclnOQfQqMdrttguJf/0i/zizmN+At9ZQKdDr5PzhhGE8cG84EJ
         gF7OjvROR4/wfmjSq9yKZXaY5awbvgNdmoJeyopF+InLnIan8L/t23XSH5LECN2cmYVh
         5emNd+Di0Ti2vpTZcXjkZQhPrEPx+G66/30vHqSsdTQTOMCjRj6iEBzTQS3bWBmxO161
         82/RBTqfSgKH+3tLpk41RuVL3hhtsj0zlFzyPY/IFU7gYf/Xs+3c4PQ1RwdVWjeXr7mc
         KVks7AFATWOk6WwN6ZonUVl+0Rvxr65VmLuDWOrDl43xwbYWvm28nE4wgrvLh6dxky8n
         L4KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709671907; x=1710276707;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fnn+qBNjgeLnA7Zdn1ytKrCjMf49ommBffpdqi1uL14=;
        b=sdCkdquwI4Mmdbm4Plg1/euV2KaA0p1lswVmf15jZEhqjTEXre2M6t4n5RSDjsFvSR
         da3pspgj713u124LT54YYGGBr5CLnmlbyvIzuQ9iJR4JYOFMwlUi3J5sxPnTS6jPXKHz
         yWw5omFXf1motIyS8XLy3xWdZK8XjR6txoMf/jqieFlj+8fdjsCrI5lrWnyZfDUh8mmd
         DG0qSPrikdR1IOFCUV2y6LYqemRUVAgtqPL7+x6/yRZVVkmpejqqvwuhntGiEyTuaOKr
         4GJcQSOj7sSW1tVJv/ewPU0KOJ5c7e0/Ykz87V7Uh1ctd654OXnjqlaxy8yFjbuSVhBo
         05Bw==
X-Gm-Message-State: AOJu0Yy+bcHtjVShwe8XxpOWwf2QTQg2vrdLhXIXwVo3N2KVDtWqmsSo
	JRS0iDlfGPuQ55ZljKcsspEga9vc1DOsAAMIsWYAU1SdkypjK7s3
X-Google-Smtp-Source: AGHT+IF3mm4NwyqtTufGOJgmT7DBewSlt5bothb7FXlxENeR6anuCge2sR0DoCkr4rlTwamTf1QdZA==
X-Received: by 2002:a17:90a:dd82:b0:299:489f:a126 with SMTP id l2-20020a17090add8200b00299489fa126mr9619659pjv.41.1709671907174;
        Tue, 05 Mar 2024 12:51:47 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ep2-20020a17090ae64200b0029932d175c3sm580395pjb.0.2024.03.05.12.51.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 12:51:45 -0800 (PST)
Message-ID: <5a8f45b5-3199-433f-bbf5-cfe7c9e77e45@gmail.com>
Date: Tue, 5 Mar 2024 12:51:41 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/83] 5.15.151-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240305113135.403426564@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240305113135.403426564@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/24 03:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.151 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Mar 2024 11:31:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.151-rc2.gz
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

