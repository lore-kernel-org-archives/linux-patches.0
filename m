Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFE156474
	for <patches@lists.linux.dev>; Mon, 11 Dec 2023 23:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="irZWXci3"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-77f44cd99c6so342305285a.0
        for <patches@lists.linux.dev>; Mon, 11 Dec 2023 15:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702337298; x=1702942098; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+/CcEU+t9kfeqhNVYW8ZXZVMGCQYXG+cCUEuVPMjWR0=;
        b=irZWXci3YRrHJD3az9854YH++06xytdUo4pTCR+VZLjvgUBzSsslVCTyWkrAqR9DQl
         G9g9fsHnZV4/YtIsNfZPwH6FGzJiwfAWnkcSPnJHT7Rs8pU/tTa/FRaR1BK1buXBhRU5
         gWsh4GzZpLQbqSUBjy5optXwG2qC2xLf9y14fPlwQNcOZSbPsEutd2x0NintLL4nsIy2
         tTjNKeLScnsMXIlkUtKojFROw3CbpGyxEtLxooSBminiFz0elhTX1/tyowNshAk5k25C
         iOIo44AJBzuhx6u5VWDSt4zH8vVNt0x7kklFtAVTfa6HInuiajVlQuL7s6JU5EM/eogA
         fIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702337298; x=1702942098;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+/CcEU+t9kfeqhNVYW8ZXZVMGCQYXG+cCUEuVPMjWR0=;
        b=udUZNQtFtb5zdoUxl53SK4tTA3fH7d4hotdg97GRuOjd695qNJeFUqaCPYRRVTFoKY
         y+8ytPzm3cY1H8w5ltjaiM22ZlVSbkP6FO0U3GFg7HyMvos8TYJHDPqjjaQv5PQ1uwUp
         F6RxbidgppsWWWJVBT5qYdbTVeZr/GEmjded1EkhhK8W0me5p4xVWv3XHwD3FtmYfqdp
         N1yjys6I+CB4DvnEh9jXpl03J/Uv+GyA6lJG5Fd/INAzqAFPwyqwhDt8DvdWmYcSsI5g
         HYOjk8tCkcAVwWacxmDnhYkVJ1J7j5IEXWHnHyW50nMkvh9mHkQXxiazSQLEoGaHPgBr
         Q8GQ==
X-Gm-Message-State: AOJu0Yw4Pf9ozzwEj3PV/hYwYQBnIFnwq+zy7GfFL/ZaqyS0XwJ5wyXK
	pjE3s619TTIPNfZppkAR6O8=
X-Google-Smtp-Source: AGHT+IHOAg/4UrVqKpIdOiMYEw91NhkVrr61GYObY+JC4jNoSk5FEMkCyS25SKrirdNU1VFTYlhTaw==
X-Received: by 2002:a05:620a:2992:b0:77f:3b24:56c7 with SMTP id r18-20020a05620a299200b0077f3b2456c7mr10563991qkp.18.1702337297948;
        Mon, 11 Dec 2023 15:28:17 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a19-20020a0ce353000000b0067ac2490d95sm3688058qvm.136.2023.12.11.15.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 15:28:17 -0800 (PST)
Message-ID: <f24b655a-3921-4ae8-8536-c11357b9f755@gmail.com>
Date: Mon, 11 Dec 2023 15:28:11 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/141] 5.15.143-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231211182026.503492284@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/23 10:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.143 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.143-rc1.gz
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

