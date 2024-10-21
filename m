Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3F01F942D
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 18:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729535073; cv=none; b=Zu1Zw4agSXWQORE+xQ1nZiIakC+K+MVIN1FM+OO3y76eBWR2BaxTHi14uWAWu3JUpdmxdsRZPZE/VDMEdVg+U+taNxP9QZvDYg7fDLrbzxgVWZKjKY8x15gK8IDjhNlQPxralBcz0FdUV0M8jVOxlTmXiW1aDo51ZDJ1oqiTcsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729535073; c=relaxed/simple;
	bh=0Ej3yNFCIOulKACEC48dP6ZyXceyyATvx1qUGxRdu1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gqjekzi55bgwdrjIeOyOceu0KJ+0n5vZEbTStr74I5XGNMqpKQxI8sdY8NXIbZQ+FFawQJaGytHVf2OK4pj/Q5c/ObgXhhiNDLd2PwTBYqQx1HsEr5MfDQFlUmMpuxQehxjZ0rL2/TOF3DR6Uizh0UfpwRkhC9D37IefH+x4+Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fM4YtN0L; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fM4YtN0L"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-288916b7fceso2366713fac.3
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 11:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729535069; x=1730139869; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=l1OugvVhfXnAwunfv+Eh5wItxlumFBT3ASYrQO7f4/A=;
        b=fM4YtN0LLgtG0ilAgKI7QP3XVPF1qaqWPJQQoi9027srqt1ROJymsVO2hZ2bB/Exkt
         ipDdBw+bUvzi88t+3mWfCMG8tATxVB0gi4TcVbHlTIvyPnc0PnI5OdIhLkRpEJiaUnLv
         it3VwUEJc7Z3Bl7NuxSZaF2bt+elk9T2bWbJm/KEAVmdMyThagbFsAeZk/ts77XvqKYr
         Rmpqo6QlB5TSftuRQ3DO7J/p4qqTwpxO4mpxL8hGABKJ55/Ix7iZQeeS2L7lH9vFq4nR
         WrhALSJGdJGTn46FYfPF9TAVC2j9YzSNdgwIGP9dhwFvJOnrL9D7b818aLvbGOYnokFU
         ewig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729535069; x=1730139869;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l1OugvVhfXnAwunfv+Eh5wItxlumFBT3ASYrQO7f4/A=;
        b=hBLwOEKjGkfb0ec5MMgPUc0Wt7CG3qaWRBQhvkWyH0mp0LM1W2rtmvU3Rkuo/20vkN
         jZsIYk6IyKJLLr3TIR6weuMNjB+FlnYQeZMElGG2U6KbkSODdLeO5zR7oenOqncUiuUP
         8ympgOYHW0IOicACtPC78Zp69yy6PzaB3SljYeuZ071SGFsjdNXb7vw6RQRSVw31QVpR
         J5dupq8WZ4zK2hg+2jvkDh6H03iHSYEkQKEbMuRT4SeHnn5V4G/fJ+ntSzugoNVN1Clq
         0sXP3N2jsh+bnnZQttf30ymX2AjLpD8xd6ACy8fSF2v16yIVxj0mZvrOY8mmInwt7ipN
         JJYQ==
X-Gm-Message-State: AOJu0YxK52sPlHK0r0RwbNB1q6lkwt5zJOPX3sixDtt7SHWKpvfGNPmI
	uIh3m3DYgOHPytdIJeF1D6ZhFPTc2cKHS5W9rgO8cTZA/nZz38vq
X-Google-Smtp-Source: AGHT+IFfO8LDJdyDU2yShSiPwFNICBVbTtLI4Eq7i2BKXfuTxHW2fGWt79r3EUt9s99UYXSx3W/89A==
X-Received: by 2002:a05:6871:151:b0:288:559d:5b5c with SMTP id 586e51a60fabf-2892c49ea77mr9627283fac.34.1729535069014;
        Mon, 21 Oct 2024 11:24:29 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eaeaafabd4sm3303041a12.12.2024.10.21.11.24.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 11:24:28 -0700 (PDT)
Message-ID: <fe528f18-a211-4cfb-9b5d-9930d685b231@gmail.com>
Date: Mon, 21 Oct 2024 11:24:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/91] 6.1.114-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241021102249.791942892@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 HGuUuzv+GKZ6nsysJw==
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/24 03:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.114 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.114-rc1.gz
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

There is a new warning that got picked up on ARM 32-buit:

fs/udf/namei.c:878:1: warning: the frame size of 1152 bytes is larger 
than 1024 bytes [-Wframe-larger-than=]

I was not able to locate a fix upstream for this, but it does appear to 
come from ("udf: Convert udf_rename() to new directory iteration code").
-- 
Florian
