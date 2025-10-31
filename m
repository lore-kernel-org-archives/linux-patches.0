Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270EA23D28B
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 18:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761934926; cv=none; b=gSJfMRHJP8GNtv+aeM8/OL0whJk9HHDWNplcj8Gc/ijnBXSbn0o4FbnyxJaziq7eu9ezG8QLRN/eI7hc86TjexjfoAWIHZNE4frvelG42V2XuvhSlYH54ivk0trufUcA6R5qkenMhmn2dO5t5PIM/BNFSYtGr1b3NM2TUmKospw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761934926; c=relaxed/simple;
	bh=v1UakN9jsJPX7yNaZTbgyP8GASSXUsSW6o8Zsu1ouC0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e94czmL4zSbAYkplawny9o82DsuO4KBh8aqXNjOwEbXjzoyEXbzw5Wx44PnJBspbQjXeHU/eOYCFnmfRxEKLLzs78ekrFjpTOxx9CjCjUM7af9SCGI60fIeFLCdwC/Q9LS0wQJjW4eqyB5e4+uxqrJA8ycAnwnYnnwCr8JIYTJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ME1yClPv; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ME1yClPv"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4e896e91368so30357581cf.0
        for <patches@lists.linux.dev>; Fri, 31 Oct 2025 11:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761934924; x=1762539724; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WNg7rFgur4Ks9J4kEGe6V9kXX8sEbPHDJWbUh7qSANQ=;
        b=ME1yClPv1TdE13nfKxBpgBySHX/JlpVn9UwN10cgqeIT+lXcIpu+17NaMFGX6KSIQj
         DNrE30HHwiUK6zxXy0hQM0Vf2HahKymu49o9wFJza5oJhZUai+V275MtEWSO7CZRDd55
         V7/XCi3WjjIX4x/S6eJmaWTB/kXvT5hSokh30duC3D9/sCsNZi82IXjmCayH6VZFQ7XN
         H79iVsSZSticBvMsdcrMoWzuL7tN89LFlRSOB/1ppHPOROHxDEUvilFAK8vOXA9M30Y8
         IJlBmgD/SWJZ1cKBHsCSi6p2z0Fae8K+CEb5Nk1nZ8+Epi5dtJ+jnKb8A/esCQKdIise
         dNPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761934924; x=1762539724;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WNg7rFgur4Ks9J4kEGe6V9kXX8sEbPHDJWbUh7qSANQ=;
        b=q83eBmb2j7oATHKWP3XZysjThSwM+cVXTm+Jtm5BkA7XdA8BwXbKo96QxNIeoeZe4O
         WUYmAou9kzCDh9gzJT6hnBhtYML1gemGa9ZB+c0U3ZRK0KBUwB7uCDTvVJ5waWj+B7qQ
         tZj8sgP+A0GSdO2Sj8ee8Oi/l8M445hSxuOKKIWR13FKCXqmRylid3Bc9Vv7VECCAzjp
         WA0iSsyIm5ZdAMuXTdh33qAtiCT3do0jMvDNhFKTRCbkJW+Wbg5gBwsODbkit9rArd9X
         5p5+6TF2DrNYmMo2XcFdkHH3U45yzzatnDbeLXE9P/iPXYk6YavskwVKkVTUeMfs7MlY
         VSmw==
X-Gm-Message-State: AOJu0Yz5dO+TsR/C4CKZRwrFrNqhtKoMfXGDybQ9vrQUl/MSYfs4OPJX
	8oWoylznWf4/0KVvFHSB1XpwSeV6DQDLNtaurEYRUewOJ771IPigeW30
X-Gm-Gg: ASbGncsdmrMeFeVKlUtAA2t4NUclwt4gE4LuYdKNRttq19+vc5sl9MjBMF02crkiANV
	5KLJQoXUUp31IaSzmiIBdOw7ZIRDDIOeZ3imApYZWQCTpyS2rRHvJjGeYNZzjFrBVhQaEEC3xS/
	qCDOsW7ez4uRJxoJcFssNDzUjBcjzmVnTgwicm5OXtF25sJOEDFOkqsGu3ZSMROKZT/W59/kfFO
	i7Ae+dwOeV9IHnLQOOQzCTCT9lyQy5250+XlqTLT8/M0x9nr5HMugICROE1PszeFAUINZ58CWoV
	h1BSiqqI6It+A8lC4JTKoYNFwINIRRUPxMZsE+OPtSfzh2SDSBoxitlMdvamEDCUJF1LI5IaoT+
	fIsPaObCneHsd8o9Lad9yzvq3MWBZNXY0n2+6Ycp4RZGe8N4tFBb5AseG3X5FY9Gvtvzhtq+HLf
	2BXuGr8RS8XjMY0KIRHWrbT//QgYsrvsCR5cJruQ==
X-Google-Smtp-Source: AGHT+IE2Y4cl4HdAmAnO0Nju4hog4gnzrMfHzCSqMbr0G0SdGHuWH2lYj4xE8ZKGSbOxQrsimKrLbA==
X-Received: by 2002:a05:622a:424c:b0:4ec:f285:4256 with SMTP id d75a77b69052e-4ed30dcaa9cmr58851571cf.25.1761934923830;
        Fri, 31 Oct 2025 11:22:03 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ac00a9a851sm153268685a.20.2025.10.31.11.22.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Oct 2025 11:22:02 -0700 (PDT)
Message-ID: <3305be28-849a-4892-9f62-706d6faf0f55@gmail.com>
Date: Fri, 31 Oct 2025 11:21:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/32] 6.6.116-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251031140042.387255981@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/25 07:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.116 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.116-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
