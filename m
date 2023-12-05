Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439DC6FCD7
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 22:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iICc08TT"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-423d8761eeeso959771cf.2
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 14:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701814261; x=1702419061; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hiHYrWLVsQ4xi96qKilwHGdyOD8NQ+GmXlpe3R+oL10=;
        b=iICc08TTb/bQzXnnKwIy4WlrCOZB2c8FEzWW4rg6F0dS31LaOxBflkAMM14dye4c3K
         wC3rbN+I9URyT+EAvJ+SblGhcMuvHbMrqnp9dWWBR79dS6USKh4V3RPt/72+bLsVlnz+
         v9EY3NEX8ViMJw1Cnb5E2uV/GKWbN0CdAgxxzNGihBDSFloYbgB5eFT5fR1VOaNKOsl5
         zxQYj66hYN4WuiaPqqiwXXy+RmAz8a4/5RbpOsVUpZPt3idl/5oCTT4Z4vpTu44qIyPp
         MSI+/e1cceQMBTaR/XjdKyZSQUcxAT/gON+mk6CenPOcJrdf8cxgIrgLo6yL+aQl8ZuL
         b9Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701814261; x=1702419061;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hiHYrWLVsQ4xi96qKilwHGdyOD8NQ+GmXlpe3R+oL10=;
        b=bhm6JgwDIbcWgbeGssfZYIzhIEYTTEP9uBjFZ9gRTCCxFDy42uS+8+2KdYYryh57EU
         Vs0K1Bfdv7SqKUbjpJ077tVmEpUkT0knlCyRHvCq2rpeU8TIPcJawKymOr7EBTqzj/Ro
         0yGq7FjxN2SjaysshndiVFGDjYheQg7fhVwvMwpo7Wn7TwtUIWLGjHGMxE7OXjhimHj8
         EUvqZt4tW2BgpRTEX2KBAm2imf5+N4p8kPNHc2eUMxBt1LT1k/TOc/+LtUyEPzV0AAex
         vLwClIOMa4s4ev4HPN/zf9eOdJhQIuZR0D4uPR2L9OKzf7x0rxXMtRkuywL8rTNFzlKr
         +Cfg==
X-Gm-Message-State: AOJu0Yy5aHhqBmhzV/UlZ027MyG+rohCDy0p57TyWmuyq3IjR3K1hNZ8
	nX/sW8CPXDBhKwJ8Phfp/ks=
X-Google-Smtp-Source: AGHT+IF+mdfV+A5byHRDJyw7Fl1+njvyzE+4VwQsv0XG5ecPxbVjutByKhU53pJtzwDxC5jgIepBKQ==
X-Received: by 2002:ad4:4090:0:b0:67a:a721:ec23 with SMTP id l16-20020ad44090000000b0067aa721ec23mr2012694qvp.103.1701814261044;
        Tue, 05 Dec 2023 14:11:01 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bv14-20020a05622a0a0e00b00425406b64a1sm3709864qtb.24.2023.12.05.14.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 14:11:00 -0800 (PST)
Message-ID: <ee7deb44-a48d-4a91-a137-3c7d2ff95246@gmail.com>
Date: Tue, 5 Dec 2023 14:10:55 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/64] 5.15.142-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231205183238.954685317@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231205183238.954685317@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/23 11:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.142 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.142-rc2.gz
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

