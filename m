Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F4A347D8
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kH4nDNGj"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3ae5ce4a4ceso791426b6e.1
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 09:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696523320; x=1697128120; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LCjL1Nhcx+ZRfFxrSaIUnghupuRDrTl5Dh+1IzKptGc=;
        b=kH4nDNGjaaIpT3HdaCrACB7H1OIPT9YCjN5eARcLD8/doiwWfyFr2vPG1kTMbJlkRV
         oXIA+yXtwZ1XjBm5YvsO0UlLNbzrH5YIfVJ5FWpKeZg4trP6iZGjBoHanz6Y4/yQ/r4d
         y0hnFnU+Z7zxgy3ydqV9ACsaeVV2/Ui0bqMC7OJH0bK/hx79mtvB4X3yuaT3GvHS4d/a
         YbmqWf4reak5e3IMSkcvXfUQq9zqi3Zx6BatrX3/M1SEt1KJOH16Em/i0PVcLvHKG5YD
         dlmwt4dlGjJjI+hnnzlX595kDyjFuw934TRieUYs+xVV+8EIPgH6OUnJuNrAyMHnJKkt
         wfxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696523320; x=1697128120;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LCjL1Nhcx+ZRfFxrSaIUnghupuRDrTl5Dh+1IzKptGc=;
        b=wWWysJSrtQCcjkwlXHlMKOJa/8YezfOwEucD3/ow3fOh6a/brfxS4YWL7byMnhg2KH
         yZkYUNraHHB6Re2eDh1x5e3hkFfhMlD1IixpI2Zv1yKPmd/TgCckuYUytdYGAK1bk3mp
         xZQY+ywSIzWajUK1T+KWHlOZOwxgaEmQ1e55TDny4m/I71itfgL4qexVv8CaJBuLBkTu
         yF7veG7bwen0X0jhTNvuETCYz49CebvQNuwZAOvgAiMdnViKPSLpNljQnJ5vgTKQQKAd
         Pp6voVvH897p2Kf9Qa0T6A1fDDbyV2D+7AecqrAP0lqC/gYYPVfIzCKUqlbVV3b1LgmS
         zEdQ==
X-Gm-Message-State: AOJu0Yxp3uolXDlCwqXf8xaKfe/8e3azYligIVM9ZznYxogCMvY24bFd
	Txru8xxBAMHAEPeikCuElCM=
X-Google-Smtp-Source: AGHT+IGxlPwo0Y0oep9fIBEaUahI/dpFBN6J/y7Ev9r8LwvBmovuSH0MCYGFHfryby1oHxSSBQbKZQ==
X-Received: by 2002:a05:6808:1306:b0:3ae:1e08:4209 with SMTP id y6-20020a056808130600b003ae1e084209mr7930890oiv.39.1696523319965;
        Thu, 05 Oct 2023 09:28:39 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d26-20020a63991a000000b0057a868900a9sm1598513pge.67.2023.10.05.09.28.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Oct 2023 09:28:39 -0700 (PDT)
Message-ID: <4628ee76-0bbe-48f4-80e0-a6d4a4dc6811@gmail.com>
Date: Thu, 5 Oct 2023 09:28:37 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.5 000/321] 6.5.6-rc1 review
Content-Language: en-US
To: Ron Economos <re@w6rz.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231004175229.211487444@linuxfoundation.org>
 <be48ca60-57dd-9bbb-d695-0d9d39e98dae@w6rz.net>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <be48ca60-57dd-9bbb-d695-0d9d39e98dae@w6rz.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/5/23 00:24, Ron Economos wrote:
> On 10/4/23 10:52 AM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.5.6 release.
>> There are 321 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.6-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
> On RISC-V RV64. Bisecting now.

Naresh already reported that they have tracked down missing commits, see:

https://lore.kernel.org/r/CA+G9fYvHPnba-0=uGS70EjcPgHht13j3s-_fmd2=srL0xyPjNg@mail.gmail.com
-- 
Florian

