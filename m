Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5C047D92E
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 19:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772564762; cv=none; b=cNRgbHceTZ3lpAJjb7ayQ01qrv0k1L7GADWYKPcjHIRtPrzZ3ktmACaKQuZxRQSXsVpsQddQL+k9UlypA6yy/esyeLdgAuqcEALnUj89XpzrhtjOSqHIBMIQdVmEI7Zb6or2N6mHpU6U2LYonEO9KCVi0b80l5vIVDuoZB3OBAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772564762; c=relaxed/simple;
	bh=2ygF+FjlJwVJzP2Osn8d0XZHc7MUwb31MowMfzgYVZw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X19E7wzo6kNXMFSVZymMrMPk7kkg+HZ50E70gP2xWh63jnGYre23y6L2QNVrG/enKH/u01jGmsxn4Vkm5ZFpdjqifFKZ0dW3cSYfiBPV6zyrax3bt1PmRjxIZJKG0xJxuZ3TqqA/sc36ZfJ+Iyv5NMjUs3AvmyOYFuCT236qSVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWnHtzuO; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWnHtzuO"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-40f1ffba6a0so686364fac.0
        for <patches@lists.linux.dev>; Tue, 03 Mar 2026 11:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1772564760; x=1773169560; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zGWQLkDUn2HWC4MUXfBboPa9sF8g7U5fx7BHwMKQ3Uo=;
        b=QWnHtzuOz3C/pxAUhtp7X2Jvd53eKlfb78Ua0oHz305lx1UMK6V+uFpWPb5O4XjL2O
         NXGyX+2jQWaDIkdkK08q8tg7ubODPZJTupIa+Z7kL9xkhxW0+QtYf9i9XxJR6k/JrifI
         ay+0xUPfHAl5fCXlpKWfELbSpR/7SJbJD+ZJA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772564760; x=1773169560;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zGWQLkDUn2HWC4MUXfBboPa9sF8g7U5fx7BHwMKQ3Uo=;
        b=GxpROZxEwFyy37Cx3oaCO5aQwp6FX1FHMmiDqX3x25y8uCWdvmU0JhF2BPArEzD6m6
         zbrwKgrGxM77LudU235xYVBkQqKooSYhAutYij5fXmaQS8J/ll4+qDOuuTQkq3np2RYH
         8lqspjc+4UZ7xpXXDP/3pNCaa843Fk07FhmijF4yEhtdgTbKsPaBWPmHH4Uxyi3rAfX1
         k3DGZfV/BfrKbDwz95jBZEP9VoLri48ROVavgPefuwKFIlfs1xPfy1yWIZ6kmO4PM/xl
         q44OO+lC85HJGVn0jWUdpfXUtfdcnkGNOM3lohdMBjmodNP3YVCuntQCWJKtTqR33Fdr
         FoLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEYFnj2G75vxvvv2ilpKKPRYM/8c5BN8bbufTXRWufSXprjMynrj5duQfHs02W7DQFpVaVEH2r@lists.linux.dev
X-Gm-Message-State: AOJu0YwrGaK28DyRUbcnZASS4ELIaFHhSpmEQMJ/XBo0xhdgw8Leoasb
	oo1RKAd3dCR6uCQzI103qfbVTJjxbCgZCw8b/en/XkclZ5pDDErxZMS2yChL4oyEieo8SE/kVZ/
	mbQ2yO3k=
X-Gm-Gg: ATEYQzzcV6IFDBhRcZBfof2B3muTBO1XTjqTn1R47G1/76LYfEt9QEBz2Kx0rmTiXrH
	NdMbvhcqnenJxIFtzDR7B901ayRT+1Suzb+Cxh+9JQk2wDOoh4iRNHST5vmleeC3BQ8bKQea0EE
	y01K1P7867lLocR82xkFVH3lgn6ozuwIkyIyqn3EZ+0u6JbYkKd6Efo1GCPkVoHlTa05a2CJDLj
	Ndz/qrTWtHcYub0ZIV8lWGYWTSTQKv6v3CdrcXcL5tySt/MAGhOhwHrpTIzjpZh2iUw3/jBSas5
	n+lYZMR48BLegik4F6ArGX3Zq81TNoIV4T2V8uzvHYEPOQmNCAQLUGD7x5lNsMgNZ0dNMzY5QIZ
	0ZyjKDzlyFnt4V+vq7qsogHvu66LRYE01141yg2Rj0Fi8OJ2317pXI56mYqi/2S2rV96srrGkGe
	gJHkU/OnLHyLHDp9/8mbBXxN4uHlZw3AtFAaQ=
X-Received: by 2002:a05:6820:828:b0:679:f05e:f143 with SMTP id 006d021491bc7-679faefe831mr10360610eaf.35.1772564759974;
        Tue, 03 Mar 2026 11:05:59 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160d26d9absm16223836fac.16.2026.03.03.11.05.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2026 11:05:59 -0800 (PST)
Message-ID: <0adb144b-e3c3-4129-ac90-6a41463b7925@linuxfoundation.org>
Date: Tue, 3 Mar 2026 12:05:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/757] 6.18.16-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260302160853.2519610-1-sashal@kernel.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260302160853.2519610-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/2/26 09:08, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.18.16 release.
> There are 757 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:08:47 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.18.y&id2=v6.18.15
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
