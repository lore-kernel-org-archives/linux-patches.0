Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536BAEBC
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 01:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FoFdIWdP"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7b38ff8a517so27121239f.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 17:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1701826660; x=1702431460; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nsMy7T3EG2zYRwsChqog9nsZDeN6t1YOUu6K4nSNjSI=;
        b=FoFdIWdPE/QAnuhNZDTmEtT63hQz65VRZXwpTIPa5PCfYRtN/GA22uS/fqK29tba6d
         hm00R3rNc2WfJDiEydB64Y76di2LJ/tHTxKlqrlEh9ej182FX8mSW2SHbc14X45BLdiR
         f0oi2MbPVGZbRxlTan+6LK+sBfq+n3KfiTZYA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701826660; x=1702431460;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nsMy7T3EG2zYRwsChqog9nsZDeN6t1YOUu6K4nSNjSI=;
        b=uzLaS5a/nPR9HQZzx82MHdXvsY6/VxG5kMmvasdKdOYJUD6a1tkF5NwyOMCPVGj5c2
         7evVZu1iKX7HaiqSM2p/xGoSNbT/7WYHb5ZXoqTSqzVkcs3jp5xn7o9P3cTRGkvQWk2+
         mNNOZmoSpfAJZwU1qQpXeYxm0KofHGwiAtMG26jXIctlR0yQgcne87ZSMoeCBswglsgY
         f+gvlwPXzVPv7KMLr1gzeUV1DZlWr/vklcP4tq3/xMjlVCEaRyvY/fZyhihlZWXnmYUm
         Z9Yq3eIq1hvpkBrruZvGwlBMWPndxc/m4VkhymTt3lr9uAq3ABjskC/X/JHmrZij1n9Z
         h81g==
X-Gm-Message-State: AOJu0YzuoE29DRA9VBx9h7oLjc12fYZNwKyZgCqLfMR2Lv4GkGtg5SiF
	K7EUfF8PY6BLyLGMqE/m7rfHjQ==
X-Google-Smtp-Source: AGHT+IHdO250DHcjWcfyqUmHLuU/KhgKLl62WKWorND1qPqtBYPDYhk8HQGQyYJRy4S6yz6f+OeeSA==
X-Received: by 2002:a5d:8715:0:b0:7b4:520c:de0b with SMTP id u21-20020a5d8715000000b007b4520cde0bmr494655iom.1.1701826660337;
        Tue, 05 Dec 2023 17:37:40 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id d25-20020a056602329900b007b457549001sm931003ioz.36.2023.12.05.17.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 17:37:39 -0800 (PST)
Message-ID: <4d7e7b23-7fa7-44d1-ac5d-ea955b2aee75@linuxfoundation.org>
Date: Tue, 5 Dec 2023 18:37:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/134] 6.6.5-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/23 20:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.5 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
