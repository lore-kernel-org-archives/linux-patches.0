Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E55156C5F
	for <patches@lists.linux.dev>; Tue,  9 Apr 2024 19:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712689294; cv=none; b=iPlxU40y03YqeT4OKGmpEQ3vIqExK2+Q6q5VzMg3J4FCM46OaPBDY7StPBCrhbY3o/jHo9VI03c9PlIc+lUU7W2KVUiZ6kiyOGbtylsOVbijDCS/0tMFfyRu1eQ5KWVCl3J/5f0WGkiYE4WLMFmWt0GX51UQ98ohhbr9U+fqiq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712689294; c=relaxed/simple;
	bh=EhGuBWVPdQK8VKnXlzCuljD9IuU49Ti00ETnt24k/44=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JIpceoTaN+w74zM0AKhakxVPT1sfdOFX0Fsf8V2M2eAjvb2wkq/v7fAcZPZspuugCWix+2vGA93tbuxdOuXtyr3/ElngXksUYHiPsuV1BICUlJ/2+jCDINKyuRYxbOAd9hcPpWnAzBY61I+6PMBfbvs6Vh2w4QFrGvtGrn04KYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jBdHsDNA; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jBdHsDNA"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6ea14011938so1551802a34.2
        for <patches@lists.linux.dev>; Tue, 09 Apr 2024 12:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712689292; x=1713294092; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gyZTN6gVoSJHHT6RAxRzhdFNsxF/9gYB/Bq8Q2JUTRs=;
        b=jBdHsDNABDXGSvEQfUOljmp7V0JrBHKSkGuMbZN4HR2zBg2OHkI8ll1rh92lw5LC6d
         XeNSdy76h7lLec3UYdZEFpaeiCn9GqvSPiH0L6l9OHoj0BL6VxMh274T0fMO/rSGqg3Y
         Q6Bq/7krAoJOyYeXbxYJ449lhxXPBrC5alJwl6AFNgqRCh7HsjmtvZx1e6v4fLFcRNF4
         lM6zCrHgVYEuQ3pNQzT5oRZhgu7SG0uSBnl/OqluXaFQiGkPx0Il4TFBdi1QMUPod7Ut
         kOjqh73s/dfqNg/drCkSHTRGXKKaGXXdEL4nWFAclyUMoXmA+SdVoORrlpiuqodfAcn9
         yO2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712689292; x=1713294092;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gyZTN6gVoSJHHT6RAxRzhdFNsxF/9gYB/Bq8Q2JUTRs=;
        b=fIoN1XSQDE29jZpnyRx7XuEKMcqbIoIDUF+t8Wd0ebK2fA2yendp52UAZmVOtELhue
         ObRasJ7k6886vcfCW3NbRFvDkNpl8ds6wccyDOnkanGMjojKxbbVe1tTBu9AeIcVs6NF
         l2ijbfLvsbRZmC7LKZewJJExOuAGU0Ecnda34i5Iql2xq55KIOtgcWNMr4zhll+C7Sty
         ajQEEjddgn3v5sdiWv8z9cl7agZ3sHBgvokaUbbfAjlzzMvHJ5AQXAE+/9jZN8JK4DSP
         EbMAu1QT4fVXrHjakSNnKaHasP4Q9le+nxxljqx1W09mZRDSUAejhjQsxF5nS2NL51G1
         p1Bg==
X-Gm-Message-State: AOJu0YzmPRj4uKYqtvfNhf9L5Sqg3q8rn4F8G7TQ1Cw5fumTlRwtXGoL
	R+jkHHMwK88vD4bcLfi5qRvkWLT8DO6Qmv+xgGsJo8wTiyO4zjD3
X-Google-Smtp-Source: AGHT+IGXEceHQ3ia8cXGq7qrTT29qTSyLJnD1/Tp5AB1LA19tFqRpEuIfFqVqRoPHWdWDkQcyKBF6w==
X-Received: by 2002:a05:6870:972a:b0:21f:a11a:e251 with SMTP id n42-20020a056870972a00b0021fa11ae251mr539900oaq.5.1712689291600;
        Tue, 09 Apr 2024 12:01:31 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l2-20020a05620a0c0200b0078d349b102dsm4366977qki.92.2024.04.09.12.01.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 12:01:30 -0700 (PDT)
Message-ID: <e1390768-7dd4-44d4-bb57-b91cd3d73fdb@gmail.com>
Date: Tue, 9 Apr 2024 12:01:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/138] 6.1.85-rc3 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240409173524.517362803@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240409173524.517362803@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/24 10:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.85 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Apr 2024 17:35:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.85-rc3.gz
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

