Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308013BED78
	for <patches@lists.linux.dev>; Tue, 10 Mar 2026 18:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773168812; cv=none; b=sAsXf28QBmqgKOMeQhS3XFA8IjIoSIVWZBqN2SMbFfo8L/c1E+Bsu2G/54DdkXxaP+afFc6DekY5Fo5F+TvcY1ip2HUyfnDVCk3Vd2rPAM+HF/0mAML4MCwatLInUCIyc3ITbVjMqp2/+SoDoBmW3VuIJ+4KoRu8+wbRFwdAu8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773168812; c=relaxed/simple;
	bh=C+YhAYa/zpX9wWGnavj5axbhk3T9OzYwmyrcso6nRMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P3K24CRUtFbsPt4NYWduh4wKmQ7uFPUkkzvrNkeb0JfhanoJ4gnK7DeTgffH1HYnQ3gCdbU0rv2sYBuABd4Dm8vHwnPjMqMoPSphPHQiycE8ECPECuR+pKaoj6Sx9Er8LwjewUSSspTl1daK144wiRc4nvBPv6ACmpeJAzW6S7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M7IXdNrj; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M7IXdNrj"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8cd81963e73so299917285a.2
        for <patches@lists.linux.dev>; Tue, 10 Mar 2026 11:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773168808; x=1773773608; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FLQ8LDeGKXboJUnLLEJGwv7md1mGO7c1nRHDugs5XoI=;
        b=M7IXdNrj1SHz5KFNUTQlc1U+penTmAlW3jc4IVFfzsRdwxTctnAKVT+NbL8OtEe35l
         Ios914mSVi9tcNM0kNr6SObdjUIHTBcHmflpsaeTrXiAMpIjoCrdEGYPeWK4kaGbCjsh
         u5wbZPpDUTUNhJF+hBJyuGVvVoaAprbsZNIoh2/e0kgyUxSh3VoJeK9e24iDFEYkv6hx
         MRzxVOHtz/1p6Sxk3lf59B5Lzwm/c5XR9AiqTkB8ulwzxLr2OubDIMVfFnJkQUYlOWeE
         dVjiFKuxSFVd4CCj2p3okYTcQdUPrH42F/Z5cLAfOtQphby7AV8ou3lwNhRCNPafQ82y
         S9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773168808; x=1773773608;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FLQ8LDeGKXboJUnLLEJGwv7md1mGO7c1nRHDugs5XoI=;
        b=Pba9D7QLqJkHZI1Q4D/l0ERl+2efwpw1KBNxRbvqABGa4Zkszku0okSF57ezWFnrAg
         RVPnhbX6gH6NLWi8/TzYQLDL66sVXwqjlzwAtZuFuZh9l5lXXmW3tXQIR1v5kKrYbB93
         EtetZnvf23SmXX2LIfTLUqzmRRmVXiBe67Ec5elKi4y4cBHpmjhW699YcdZsvDPsqFC6
         BrUKCWipf5PvgVOMuRBbyy1C7q3gKNZA6t1JnbiUdwYPdzQTVpC09VIcUpMi6v2z9RXF
         bVmmLvWH8PpT7gyIWRXh4hJN1fVilmT6OlTSqV/yBH5uDuboGJNW/M6yBieZH3peTruz
         Ja5w==
X-Forwarded-Encrypted: i=1; AJvYcCXNRCG78Hw3UNbR72fC3amcUiqkvCsXzUhzZpek8vwC8b2gkN89FxBwZxKRbjr8IMpQiNdpRdlK@lists.linux.dev
X-Gm-Message-State: AOJu0Yzma24ZXx4PCAGq3HjnpsOon4lf3L9GVCyPRpZ7p8TxR6g7mxeM
	cZMfKNRBsYutWxZqRBx5tPTO/yr6Dbq7+5ir0b3UcFOA/QS6XF3yz6wc
X-Gm-Gg: ATEYQzxE2JNeBk0d9A9rTu7sBV2wfQy8wxtMEpJQSypJdU49Y3VAEeNsL1SqLAl7v3/
	1HVFm3IPkxFXyjoEabgbUBuPr2oWbDaj2vVnlwOh6rXS1fUFDVASQgJ/C8eEcisxvEC4TwM3rpw
	rTYDB2T5nZC2/cLZeWHjZHK+e0zE8Xu6aGNncVB7Mq/LwFYE7hWI8jeejXQ1WoEeSzLFhx2nfwa
	pRKnITMEFQtsLG9XxGGqFe+9/SkTE4h1OtAPdFzrNgbEWZIxknhISXl0OMYdNwEaCWCcN4HRU8Z
	OI8LDoII9bL6cCG+/7SdQafPE88rulzOAIzGQhgGqf7y9mt8t/qpmHb+FmjOJ6j83HOgmoLg3ZJ
	K+DRKZOIymGbsrUieQ9263aplga5JQSwihzknzvBw/+ZuYeifGieih5LnbIrZ162RO5kbpmGtWo
	SrDEqJ3HXveb1qtmnC2Yg+t564gUmK5oDGRuXXDm6bVKdwg/+BNA==
X-Received: by 2002:a05:620a:27d0:b0:8cd:7547:712 with SMTP id af79cd13be357-8cd75470fbcmr1680711485a.76.1773168807908;
        Tue, 10 Mar 2026 11:53:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda129d012sm12863785a.19.2026.03.10.11.53.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 11:53:27 -0700 (PDT)
Message-ID: <8d14f8e4-26fb-4824-bf3a-4e8f8ff16dd5@gmail.com>
Date: Tue, 10 Mar 2026 11:53:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/314] 6.18.17-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <cover.1773141554.git.sashal@kernel.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/26 04:19, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.18.17 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Mar 12 11:19:16 AM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/rawdiff/?id=linux-6.18.y&id2=v6.18.16
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
