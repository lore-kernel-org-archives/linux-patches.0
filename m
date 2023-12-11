Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCCB53E34
	for <patches@lists.linux.dev>; Mon, 11 Dec 2023 21:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PO3x877u"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-77db736aae5so253790385a.0
        for <patches@lists.linux.dev>; Mon, 11 Dec 2023 13:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702329353; x=1702934153; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f7MVcu7o/NtINowl0l8HYwXfyv01ZrwZ3Kxgw8afM7E=;
        b=PO3x877uqOF+zr7ERystcll+dtDH5Sse/5yGw+9A2xbupFFT3gw3qoClS2mK8L/LRl
         5ibtj4sPAZ3FNrmIVp/dHzwiTmHyWVfBwRIXjqf0aA0CZ76mC/M+kDQRtyTQOHaHKPfn
         4LgZ57a0/Hg5D4CcqGkrXWnN3inr0AHRoTk+0Jkqtfi4CAbGWeLerpy7dPs7Tyt9N5ru
         ZPF0WDKhYnvMZFQHjeKFdC06QyUOKg02FIOnXQVJZiMGVJbmdh5WizWMvNePicOz9Imn
         Ak/+eR9C2PNt+NSffpCjz8ghTZxtq8SI6N/y5ozRKogDC5uL1dNQ0wl/19p20Tn0SAa4
         2d0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702329353; x=1702934153;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f7MVcu7o/NtINowl0l8HYwXfyv01ZrwZ3Kxgw8afM7E=;
        b=ZmXKKCad2JqgE7KSvX1raguo7nciXrQ+AAKxHWO+voSsxEVeex9kC/S65QfinHLMsW
         Wvo/xOTYkXYqblz98u0nOy28TL1h/4mG+zynq7fVg2HD/GDmfluLoLYDoGS/OMkHtWA2
         pBuGpk6TCa1XmGzFooKE4wYrjkoFK70KyJBKYPgHle9xkTDFq4U5+v96pRJWIDI37cJ3
         C12iJMqGBtilwVvbDypF3U21k+JlMeCFZQYInf/d1tY5dfFfCUC1BQ8DfpQT+5eymO2C
         o3gHI5o/pAeHqc+/cxfkbL52Nci8YTUNBIW5oYt6nKaF6rLvNtzgpk7hw+tfw5c2YXc4
         7Uaw==
X-Gm-Message-State: AOJu0Yz+yq4MMApwYljFRnbyH4TG9Cl9QiWMxLmCu7VkZcQu3Y8hW25X
	Jdgr03ZI37SdWftl1SJkuag=
X-Google-Smtp-Source: AGHT+IGsNhakLJTeZI6++7Are4btlVbr4oMf0+N+oBzUW+gS4V/RE/+UjPoePWZB+K/aoxk4RzxQkw==
X-Received: by 2002:a05:620a:1aa6:b0:77f:c96:bb8d with SMTP id bl38-20020a05620a1aa600b0077f0c96bb8dmr6908517qkb.6.1702329352929;
        Mon, 11 Dec 2023 13:15:52 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bs36-20020a05620a472400b0077d8a162babsm3200309qkb.13.2023.12.11.13.15.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 13:15:52 -0800 (PST)
Message-ID: <41909d24-db7a-4a11-8983-7101e87582e0@gmail.com>
Date: Mon, 11 Dec 2023 13:15:47 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/194] 6.1.68-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231211182036.606660304@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/23 10:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.68 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.68-rc1.gz
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
-- 
Florian

