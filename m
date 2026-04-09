Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4B32E7162
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 18:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775758600; cv=none; b=cLKPDv08cmlU+KI7ATM1kXICevQ/r8kcDJSnWLqgys4uXscYkFTkfgunhe4f/LTOg7yFXQQRThrxQbOwRXxJ4E9Yqa8LjiQ8YS+do1aKfsD3ya+OjJ0C84rLZTRGWapodBk73/z4jEnzUafcCcTZQ+I9/d/kqZIUffib/F4Gmek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775758600; c=relaxed/simple;
	bh=UmlE+6ZdtmlTuBH3guz0WuhhlgaoQ909RCT5n8LexNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TMQcfKW/8TIKjG3q6kaFKxQ7rtwBvpeN49FSPuXUgvH3xtAVAQSfBKWCHS2hVU2qo87mCiMpeo9m3nD9GAuyl7dOACpxblNoavDr91BEgq8MOBC19Vd1fdCVpdsIllos7UQ9Hm2MOK0CmYiWxBz+LW5VA3sugLJ3AymNE47j6oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qKyRCQDB; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qKyRCQDB"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2b6b0500e06so1502493eec.1
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 11:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775758598; x=1776363398; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UuIL4P3B2HTR8rrr8+m3taUTFBIHOuLuzCd06XG06aY=;
        b=qKyRCQDB7Hg8B+Sa9V0bw184Q9p3mYdAuEToW0VjGXXtxls+I9EQDfwzyutRg9vVw3
         2iRvECT6LQ48ktwKZ9BqdtpEKw9bht+/asERcyc3SEhW0xHMa3JrpE07sMr9rZ9C8LN/
         XZQZfwvzSVBXcCpuZC4Q3nrP3rM99gw3k/YsF7xOG+DdTffW9vw+PpG4ScvwtHOBdDNW
         Yf7TOFKlLJowudOErzPlULoJelqXMzBTo+Pf7jYZbtN4aMYQU2174UhQQBYwwN1o/oB0
         GumsyNVA0Oc/IZ1ldWmmHYZPskI1nf9FNUt276bpm1LMcwasrxxftKp6/lML95i2v+c4
         vg1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775758598; x=1776363398;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UuIL4P3B2HTR8rrr8+m3taUTFBIHOuLuzCd06XG06aY=;
        b=fARy/JwBCkHmapmCA9aUoH3fLDFYuby1VZaatjKS+Ouke2a/aBIDujxpMMyVVoHVQ8
         oln1i/2zl6CDscYQNNTkEKSYG00rBDlY03dCJ+S66FKFE8h6oY9lgNvyn0b+jxxPlzSt
         Z8AC1o4NzvXHwyN+tWe2+9sSv/FSVFXjVoNUkFxELGRkvsysB51P0tuNCNn8MKIIHUe0
         ePbTqnx+t0xonjFqXi899nI7P9sjoMbZhr5vbhlmWu4DyITdjshy5flJy9erOXPDh1xX
         /2sAAWoYeZ+H9NkUn9jGcegUuxnZ4IA/Y/tbMi6pCXihXjLN9Z+WgCYZrv96RqOlM5tj
         mJCA==
X-Gm-Message-State: AOJu0YwS5V8sXy2BSWejyFTMoAXbXycSbtdVgpLl9Y25xI+h/4Fx1Qn6
	R0/+oqMz+7ftZN91/BzNkBF1vDGOOQGnR2oSPxTFIt84iKSlhSr1U09y
X-Gm-Gg: AeBDietn5rbpz6bIGKNLLvn/BMwrNT+EIcGh2NVXF9tYyvq2nVF/S7orkd7pWnFIlTu
	3N/cUA2hUKKucjFaKusxqm32LmUu6pi1k/MYm/KX+1vTU12IkNPYKzdvsZO8ueyZ09swSLJCLjr
	OT6sZLKGlCAr8JCFv1X33zE68PxEyhF+oIuTPtfDUdTlq4QuZ1eRhrMG7P7F/SWLB/FCabcB7Gk
	8MTYS/bnb3Iwe8xAPf98VyR1pesbHAbWskGZB5fnQC2oo+js7G2hexGuVe/w16Kmrf/w/9yG5Lu
	4f8WnI8KG6MS2t1dppRTVXRQMWrulwsLMdMkeBQ6FFoxgSD0N5RN9mrUi0KaasFZygauApcyfqh
	OeIhMyLitPqiZrnzwyYhYPnrl7OrIMtYq5K/MqzcRCRTcoW6cQsUMJ6EtwM3Q3x9rqjVkDF60T/
	3DXagEt8WXg/O0Gw8oXBfpb9R/c/Udnnds3X5G232LbU7/ItYGKQ==
X-Received: by 2002:a05:7300:570c:b0:2c6:2bac:8ac with SMTP id 5a478bee46e88-2d589ba8011mr57164eec.27.1775758598240;
        Thu, 09 Apr 2026 11:16:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d5627c44fcsm745677eec.23.2026.04.09.11.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:16:36 -0700 (PDT)
Message-ID: <c3b13741-154b-4c03-bdbb-e1225e1dd34e@gmail.com>
Date: Thu, 9 Apr 2026 11:16:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/241] 6.12.81-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260409091733.126574279@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260409091733.126574279@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/26 02:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.81 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 11 Apr 2026 09:16:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.81-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
