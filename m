Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2DF3BB43
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 22:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712873281; cv=none; b=VFZKxfNJcAbk5iJFYAlPdbp7C86ARXPMrmss62E+/z7qhMeocnsFD6yT4yOmhLBOm9gKn0eRLO1sj8W0PAyRA1FKVitX8mnlKGoT4jluh1SJodcXPIQFtnBlqtuoNM+huDV2/iURRfSMa3E+S5THn7/9DlvyjhDgEjiD5MRoAz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712873281; c=relaxed/simple;
	bh=PWZiYQ74/w0UT+7MjhuPATgOoC3BIwW3cwjpV1VRKWM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ElCQsZ+5jjGcqLTxfId61/cQso1x2NncPK7kUH3fGFDsiMZuwziAUfpXWypCz7iG8/cLJJzKqLesqDbXKvSnD0BUCo8U7dZHNurH49v1PiVfFLKG+cNEv7yHQhdMobKAU1o4S2nrTITKg1/qXuhU7+tDxTdYX3MIWwqzAqfTEwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L9tjlI46; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L9tjlI46"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5a9df87e7bbso217395eaf.0
        for <patches@lists.linux.dev>; Thu, 11 Apr 2024 15:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712873278; x=1713478078; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Z05V9hjl4isyzgk10gFX2UAfVgP+ufpBEOn2xeP4+k8=;
        b=L9tjlI46cbG0On6X1V3Bu67bNKzPeYUt0hdQRaCWF/q6f6WZrrIAfI0mzjCt/VjBQO
         Yh5cr53mPVCLx/3iBZEFpDsqU26W7r+sQDMY0iDsM2jaoRdRWFJ5m8jNxNK7G33hMDMM
         SO/RdE0czJb9RsbrYq0epkIdye2wNxvqtwovX/4WHuiFUu2kB5ejPKOnazsAQeqNkwNP
         MwedRRKzhP99Aa9jRj4aFID9HBc3jSx9Z8lIhxuJvnwcADzRU5kqiqhNqnSlNJzmOmOz
         D/LwGlWcOooKFFTKA3ii8pMnaUNiQzbnfH5kOPhboMx1NH2Dd5LFnyPRosrgWBrONRlS
         61yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712873278; x=1713478078;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z05V9hjl4isyzgk10gFX2UAfVgP+ufpBEOn2xeP4+k8=;
        b=D4BzIl0Qg2r9cm2ys8RKObck9myX3l7zrzAUtDFkTc2/m8E0s01v3fMEn8lr4z4tHk
         p5H/aw5HblXTLo4Gch0u3tobsRgWPbxgQZnIqKYelPPXfLt4ElfpOlDjnMSVqbWmxwdv
         Q1EhLb5CHq1igVz+lJ/4bMpZM3BWBvI+mQXbF+N4hmQ0QyuRBXGeClbcMG780yQNmeR0
         xvExHk0ZmarGSoW5F2LOQ3L2xoAIn94C0JlmFudg0BuEL4EnZC/C5QtCzdpnIpr8DqS+
         LlE2VHCHOo3Qp2Xa13GkLAHqYpjJLPADWlO2d9uPz5TdFxLzobDL1RaxvG852HAiqp5o
         WymA==
X-Gm-Message-State: AOJu0YzWUHFlk9pfrTLrrplC6mhN3zuF8M0Cvgsavramq/8iICU7x0f/
	UZVKRHXeTnyyLdKt0L6GL663i12Hi/nn0qe2nxaEOJ6QD9baqNLo
X-Google-Smtp-Source: AGHT+IFWiubUc9PIA8Vx8GbSjfNdWLO4HJihQAgveeVyU76bMwj19cyMzQXJsyuCa74WY2or4RWXkw==
X-Received: by 2002:a05:6358:90c9:b0:183:ea4b:620 with SMTP id e9-20020a05635890c900b00183ea4b0620mr848080rwe.28.1712873277620;
        Thu, 11 Apr 2024 15:07:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o35-20020a634e63000000b005f072084432sm1552607pgl.38.2024.04.11.15.07.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 15:07:57 -0700 (PDT)
Message-ID: <d50fef0b-3bb9-4e99-9491-c0d6664492b4@gmail.com>
Date: Thu, 11 Apr 2024 15:07:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.8 000/143] 6.8.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240411095420.903937140@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/24 02:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.6 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.6-rc1.gz
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

