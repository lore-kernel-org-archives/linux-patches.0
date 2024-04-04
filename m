Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684BB6D1AB
	for <patches@lists.linux.dev>; Thu,  4 Apr 2024 20:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712261480; cv=none; b=DchJFvtuggCZ4BIpC9X3rwNTRASI8cEsfAlhQP7UJkUnmMeniS3NIZdgp9cFJzhUofknMRx7rDqrjhCnNjYWo7ifxzU5vXPvJIHMXwnZTZZ7a9ZYs5DBhpSfszVQ7bKFi4YCS5/g7KAFLfzA0Gc0slJZ5QxBi2g2VryR7/QMPOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712261480; c=relaxed/simple;
	bh=M8iIHi2wG31CMAypyB9Hf3PCit7uyA2n3iFds5lnbAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fPkFV5BsxIhXRA4vBgCIj2kGKI3zKc2Qfk6YzeIWtm95YF/Z5kIrLY22SdGERmtSnzfweN+POecdN+zUaEYb0HjENd5HfYLfCsmllqDIE5rE+WPSE5ItEZLVsNMYc/V6K5QgGnHEW5LoJlvSPG8YNqWoEx2AEg9IUa2B0pEd1r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fe50Cp9s; arc=none smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fe50Cp9s"
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-7e074f8ac06so482814241.1
        for <patches@lists.linux.dev>; Thu, 04 Apr 2024 13:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712261478; x=1712866278; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RjPJff2sg2YzMJe7DKQkjhJDQMLyOxul5rZyxHlPbrE=;
        b=Fe50Cp9s13uvRH3t5ISBPxIhH5k7qxLb9t9f0VemrSuBznVoM/sXJv3v0gO+BYrm+8
         92+hRkzf42fR/zm0ktukFrLsIIfKfk0kPTEO8Lc+PhvhnAtvGUuO6FoY59A+BXRUWhK6
         KDb3ORTjdNElbcVkX/KyAHmJ2sNKCd5QA2D91GoLCALYyWwkZ0xnpXnEV5gLpiTpl0b/
         7UCapo++T1e6AOQIxPI5PeiypqexcUQ7FIkO1I3wwPphmsO/KsnadrQ6qSQw+rnMECOL
         rDV3ahQkSLb5tsxqs3Zhsd+uegwAEwdcY6GGbwBX/2J8s3QFfocXq/iJI8injXgjciCY
         P/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712261478; x=1712866278;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RjPJff2sg2YzMJe7DKQkjhJDQMLyOxul5rZyxHlPbrE=;
        b=HPTNcOA07ijzhPibbQ80zNyT/dPNByOlhyYBea2P+RDvwqkiBdNsuGUCA8htoQIiV4
         8MCLo920Hq+fRyI7uFmPBiXGGZnaJ0gQsHyBMrGnyHqLyPg81vfxpFdUP+7UuBP1EuZA
         9U6F/fqeqC20/3eyHczXyl50gVZoLNi/8bc5yQcQ6o/TOPz4BKPk4B8UQGTQHExh3W51
         OQ2A3QECEmo9rlZco0WaweguqLBDQXdH+sAIQJQyyUbqKxEVyAkfrsC4A2l1epdTLzh/
         V6wttuCrUoHZJXp/lkyuX8neA/UPAVDBswUYw5Ca84FcwUtC6tbG3ojDo80gmHEbQHLj
         NXOQ==
X-Gm-Message-State: AOJu0YxcIal9hdWL6BrFZMBbjMMP1r68LvSn9RDR0fXg/7uRvCuKjpDj
	+wpgBarnzmJdfwj43JXRQeUVGgiwPLX5OeQsv391OEZjJPTsfudT
X-Google-Smtp-Source: AGHT+IERUiPcO7YKkrekeSdBQhRTR0raqdh0bkL/Rd5vl2K9OCFPKO5bBhKykLnsoGvvKIbbYvcNuw==
X-Received: by 2002:a05:6122:4591:b0:4da:9d3e:a7df with SMTP id de17-20020a056122459100b004da9d3ea7dfmr928443vkb.5.1712261476812;
        Thu, 04 Apr 2024 13:11:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id fe4-20020a0562140b8400b00698facb19d5sm25978qvb.106.2024.04.04.13.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 13:11:15 -0700 (PDT)
Message-ID: <2e5e148b-1d5b-405f-bfdf-b55cf6ee5489@gmail.com>
Date: Thu, 4 Apr 2024 13:11:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/11] 6.6.25-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240403175126.839589571@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240403175126.839589571@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/24 10:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.25 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Apr 2024 17:51:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.25-rc1.gz
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

