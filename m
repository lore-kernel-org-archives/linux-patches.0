Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9B2328B6
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 17:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q3iZK32b"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-5aa481d53e5so1939152a12.1
        for <patches@lists.linux.dev>; Mon, 16 Oct 2023 10:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697479051; x=1698083851; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LgrCPxN3s0kyDkIjbwluchqoifZkFgL3rzS9YM9DxHM=;
        b=Q3iZK32bVg8DVI2jls3SuEtuuTrHlwXPgki68W0QqeYmy4gMaXnAZRCRUh/rCPIjWA
         RMbQXh/P+qAoht+eH93QHMRzYm7hWdlWrNAs6CB1jFQ5bGYdfLB2HNMfRZDOLhQLyJXp
         Nx43HOJ6OS5QS+azRgWZPB3SMBBOFd3XvlU7U6QJOs+9phpZzxoUvF2xq38nuDyk8FqB
         awXKa3v5KQKrJcYfcuBjJGRELFBIK9xBqhUDUvWyGpkaUNqM3qcJC+clF0LgvhYC64DD
         G6deCO9tI3q3zpzVvRJuyc3FEpfCssFCVwSdKC3sn8YLL6gziT9XD9vgbmt20sE4nJoa
         kXKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697479051; x=1698083851;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LgrCPxN3s0kyDkIjbwluchqoifZkFgL3rzS9YM9DxHM=;
        b=lkQ3rUHnc12Lm19KLTjGweb1nTbXDkBj0DcQ4qvAysEyE3KcgbbD/10un2F8a3c7R0
         GkvNqMCKermMXz/kWtIX/ObJjrIIy99+q0pfqqIqQRoxUAu2ELSm9Y1paIKJjQ20/RUj
         jZHw09kJ/ZG3l8HoYRNxgchDT+7loFT46fdY17VQ6U92KCut1Q14SneYcsKCofbWa6zW
         I0ldyxq2sqynXs7aDypC00AOtGlEAt79QlsDL1p1y3U4bcqmhJGQEQpuwtPOj7ORz62R
         UJRESAo52Is0kYTl2oQjffg/6FplIhRdp+sQKIimQyHzJNZIzMmwBhYQS5kNSdgyudaM
         TmHA==
X-Gm-Message-State: AOJu0YyFwQpi4OUhhdsWAdbu41Ny6CxFRuIPcmVeq6e4r5DnKu+q9/Ru
	KyDteSix+d9kxH9WO3nKt14=
X-Google-Smtp-Source: AGHT+IEIApVRvIsoma2miRF/H9TQmZu/H+SrQyVpQ8eYe73uEL6Fmwky8fT0+x5txyMn5Jqgl7YgZg==
X-Received: by 2002:a05:6a20:6a0a:b0:15f:b5:bfee with SMTP id p10-20020a056a206a0a00b0015f00b5bfeemr37822612pzk.5.1697479050844;
        Mon, 16 Oct 2023 10:57:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ml7-20020a17090b360700b0026f90d7947csm4997555pjb.34.2023.10.16.10.57.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 10:57:30 -0700 (PDT)
Message-ID: <b42699a6-22ab-45d6-87c0-1574c54d29bf@gmail.com>
Date: Mon, 16 Oct 2023 10:57:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/102] 5.15.136-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231016083953.689300946@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/23 01:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.136 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Oct 2023 08:39:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.136-rc1.gz
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

