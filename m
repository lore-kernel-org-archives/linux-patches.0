Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4984CDEC
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 21:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712005364; cv=none; b=P9KDQ3L79UmuKbrw/+RRAp5q1+SyaMtDva84vwE49K995/uBDCiEh2rgdjROk4+OpRq2Kcet3v0VKYDb1ekleRbnm5uaL0ZB1faNe2H507385HKX9N7KDIoVw+WgLCRDN6Or02ElBNtFCdclTiI7KmcmNPqkZUqqErDtI8INC/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712005364; c=relaxed/simple;
	bh=L8Wh/UZ8fV0rI4LaC6zoFQSLl3ZeuehQjPS9Zvohfo4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gV2Jo/ftPDndZDkDrKSULvbhWP8PrZzZ+lit6DgQIFwHkj3EddCr0Xvkl5IATv8nzPXmYAeVvEXlF6p2wO8OpFqZfRoEL8GtVkVYAo36dnzsLJl8rcdxbGLUtf39aVtJp+Zf4Qqugs+Kdh5fRGizsyM4K7vQ9XNJjVQDNsTfYGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hkfwXQBv; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hkfwXQBv"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-43182c2457bso27541591cf.1
        for <patches@lists.linux.dev>; Mon, 01 Apr 2024 14:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712005361; x=1712610161; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=60igiFkekBblK0WjIxOCyw4MGpCAlBwmaansRQJCJfQ=;
        b=hkfwXQBvQu7ZzB9/Cyd3m7ZxDzqu+cU0r06Auk3bugkObylJHkz/KFrfqogVdph1H/
         UADWYwFNoLWmdrnPIhHtnkW43PKd7CqaC2A5f8fizXgTgtypFZV14oEcnIpMqH4zrcyC
         MHC+liAwpZhXVJItvfOWCKAAitz190fQL8OqQ9J2exwHCthfxSNpDx+XB7zfivsAbrEp
         U5rpSIgyj6nm6SGgmjMJBYaa1MHnLztnhbZrfV43m9ekU9+K17PbJMGIonSMbd+BeZJN
         MDSHZEQbQETAZSLEkdqMIFHdymaTZuHFgnNrYO1VIwmppXLgQj2lTSUeeHDZ0uzNfAWj
         ZJ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712005361; x=1712610161;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=60igiFkekBblK0WjIxOCyw4MGpCAlBwmaansRQJCJfQ=;
        b=VumdS+rLWdvqEM6zC4/Q+Cz++HPSWrxuDhsutZJEAyp2plHHNSyWqc6UUBoXMa3CXG
         b0jeGpY6gQMq+9u4EnWO7zbJ7mDTeN0ovK8Yc8czURVJJnd/WyvAxxRV1HX+RnWbPuWu
         6EgGNpiRDr3L6noHCK5ueLa8cWVpD1oNivZIkXlHWVsBUiNbDFjz0oGzohM1S8QmOgV9
         iqxcqySQL/oZyxZ2fy0nR/BqAUP5injVYJ301MTp7/sq3CZDSk8GhrBwuNajmxpDJ6JM
         nEImsdCErNCZx1vucP24kjdbNdIa6GZfyF2qSLy03a/Y3n5t83wUClWqEscU8XIQGqa2
         ncuw==
X-Gm-Message-State: AOJu0Ywsh0wMYM3BIC0z/uUxAPA1pUwul2SQNKdq96KqcTmfb+grWDz5
	FCQhpXWNWlecTGBDodGf0UDE6YwEc8fj8LT4hmOdkL/HMPRR+Jeg
X-Google-Smtp-Source: AGHT+IGpDjLzeopBVCUJQnng+B1vb/J3Iy4vxL/xCJnbz8Jocgm1bLV/RcsWP0pI82/ZLssPhN4hgw==
X-Received: by 2002:a05:622a:351:b0:432:edf1:2e31 with SMTP id r17-20020a05622a035100b00432edf12e31mr5575749qtw.61.1712005361600;
        Mon, 01 Apr 2024 14:02:41 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ex9-20020a05622a518900b00432b5c9b9ecsm4745631qtb.14.2024.04.01.14.02.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Apr 2024 14:02:40 -0700 (PDT)
Message-ID: <78f8f918-5912-43f1-a01f-99060512b87f@gmail.com>
Date: Mon, 1 Apr 2024 14:02:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 000/399] 6.8.3-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240401152549.131030308@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/24 08:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.3 release.
> There are 399 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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

