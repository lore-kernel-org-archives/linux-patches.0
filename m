Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46838B641
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 23:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdgYchBg"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-79fb8f60374so46792239f.1
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 16:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1696892618; x=1697497418; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=isNibIDfjCBz+AxQha4Vz6XAmq4W2W0frOEb93LFaIw=;
        b=BdgYchBgOCRXBLZqt3pENrPt7ZRfC8h+stD9at/KVq2O91S2LpRmpopWIE2fGrHeKC
         9D6ptllxUdg0VuTQQFKkbUeWMEujyIli3UB1RcEZiAg1t/jhl9bJoFY4n8RQ1ZSK+QAw
         h7Xryvk7CGIh+5QTyI8yIPHKWbBC/DmbzVcx8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892618; x=1697497418;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=isNibIDfjCBz+AxQha4Vz6XAmq4W2W0frOEb93LFaIw=;
        b=gfq8zZdLXh5m1n94jebjJKjtFXfxoe30W9NSjqO8pmBLxuMNYqWhwDOZRdc9GG13sI
         AibdhqD11GUdY3asNMOwlfOmJ4FPzDT317hicaL1wWD67GjLewjjKS7bChkLg6O4UOJr
         G1Ge8aixCXW+L5/7XjwsBzBi+JUgcwosLcWkpFBIyq8KOEjEXOK6AnE1DTnOowMD9Rra
         i37eclGilYm1Ud4UBnUv+EQ8nUceW3flABFiarsT6xoi0WLDJ6BEFn2rXl+nSUHaATYZ
         yKrzw2EgROsURMLN985WN3ItC7d3PGIShDDwRSGHYgcfmDkH1OaV6SE4vUy/l3t6QI5o
         FgGw==
X-Gm-Message-State: AOJu0YwdPnrXgZ9/GGat05qEA5mNwvIT0QK3ZZoJYnG3aWrV6EWxMAW3
	z4u+KeAulna8Sjo5gI1wjp4dyg==
X-Google-Smtp-Source: AGHT+IFC7dB+rmhJK94YvLDte9VrWpF4MStdv3nT+6mBzwWpLQzXID6OdAsgCEfdl8dnfczLe/bLCQ==
X-Received: by 2002:a92:dacc:0:b0:34f:b824:5844 with SMTP id o12-20020a92dacc000000b0034fb8245844mr16033525ilq.3.1696892618299;
        Mon, 09 Oct 2023 16:03:38 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c4-20020a92c8c4000000b0035134215863sm3150909ilq.55.2023.10.09.16.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 16:03:38 -0700 (PDT)
Message-ID: <e60e435c-892a-4d9a-ac46-feb7b49b7f18@linuxfoundation.org>
Date: Mon, 9 Oct 2023 17:03:37 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/91] 4.19.296-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231009130111.518916887@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/23 07:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.296 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.296-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
