Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9E03EEACE
	for <patches@lists.linux.dev>; Thu,  9 Jul 2026 09:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783589766; cv=none; b=m8IlniJ5KqWvDtn0z91SRsKOa73UAKBj6rd5K3/PwrpcVWHzl4mwLDNP+5wBwtu8hOZuw0p/feq9GVi8n6QxmEEz/1iYQkxVOXOWi475QMU9cIez/C11+PLNnFDcwTz4TpjfqjPZyRe1dzYOLodQHf2uGSU5Ho9U2o3D9mPYCg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783589766; c=relaxed/simple;
	bh=dwacK58PZYD/fisEELQvD1XNGY/AUHVcRTeEXysE7x4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=DfcejlDjKBzekZX1ERaJntNgTH0hkQuvaR+p/LzjC9ryX9qc6afc7OLB9ASKgnoiVW9eqWcBz7Cr0llWk1cie/XctmlVYe2zPY3wpudvlNV9AKQIps0I4Dui+oNWLr5Ur8nIpKFXPoY760bTcu8MReIg9bQUTn/+ViYwQ3ZsExE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jSha76Uh; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jSha76Uh"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47df6a5202bso298331f8f.0
        for <patches@lists.linux.dev>; Thu, 09 Jul 2026 02:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783589764; x=1784194564; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GvQrm5Ns49lCPx3T22+ey6qMomLJzKoL27egFokIkhY=;
        b=jSha76UhYOEszFHsrkOpnHlIvtPVW4QtyAe4Sqj2vepmENTe9xkSbQGT4SudMLnrQj
         j9ZjN9j8EIqVcqlVuqjs1rk3qKezHLm/vsV9kcKjLEx+yiWoa990fLQ+mvHTxsLA7az8
         AkA9Sacl0bZ/TIIp0UiaAevEowqc1g0uN5tt+IpouFqBYfmHmoGWMgZ1+euPqw/YGvPg
         cgI8IHC6q4aN/dsfeBsXUu9be/ee99ujgjwFnKfJY2F8Xxe/jBUaSc4a0JeHNuVaLuyY
         8gZ70oxv5ijpe0yAJu2i30uE6QchDoR+bWP0LWyKWGXEAf4MmFeBtKaeHm+U0m1vXMLD
         r+Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783589764; x=1784194564;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GvQrm5Ns49lCPx3T22+ey6qMomLJzKoL27egFokIkhY=;
        b=ICwcD6QHzI1/hakMFLRisPTQNwp4FwjeFqNOEWr0WFDpjC2srNwW385anQ4tjE2LR8
         PfCzK4p7o2rWdnB+BnTY2XSrzV3XInQRR4EKz9Wx/1XuvJsTRLF3WF2TfDuJgbg1XRiG
         IFzzCyQ5oD81yPenYSDcMG828FQT51yLNswmKMtVk4tfY0OoMJX4gaD976afB2e+Hfm3
         /jOJPUFgyEX7GorJPH2gPbHKvdpM3dmmh6wCx1R1a4G6iCHXqNC3z+xIqJ6tOVugIvxs
         oD/fwXPW23o38Wa0ernNYdYxZ6QttImMG53kDhUQs+9BBLBtF5yNZq1IXWmsBd/EpWe3
         squA==
X-Gm-Message-State: AOJu0Yy8oHiZ3NOTBAYiG12i1v0rQhudVAkk+tqjput9XUGO6acotLNv
	xoms/CGUsCOWhyATqnYTJLWxr5ciznGWNnVjgNl74ZijCmVNeITeytR4
X-Gm-Gg: AfdE7cnZrV6IZ2xWLpnSqfbJFNT2IdQccjdjpKTSBQ5sGB4YwSvjiWNQ/9Ija3Yf4Du
	LOO+827lvJR++dHy7IhSEa6XBRI/NqumeWT8dHWfLMTXuId6CoruRnMrKQfzxSAf++ZHUGZdIxg
	8bzUM9iEvgO/mz2/AsyXjPdbw2ulvW+DGDyL9WZGiHK3osAhmT7AppqUWWyhjinblzBlRrxZejw
	FLtkLbGOGXUTxPXxujRppQeXfbbsKdg+XJcJVEJBiGAzcs/trnus/rBgKDnxRpKyhQcJkA14aWP
	KPn24l4SyDERvqODFDkmSmCIYcLBymVdtMbl78lanOvI7k5Wtn1w/FJH19rltaiJL/fjwxulDkr
	4yKDquygBH5p8G7tqQp2CB25AKEADqmnhfiCmlR7N6EUzhJFxjr/NdWVaWasVguy/hr5jNHSOtK
	/mCkPqFNhx30GBhjb46gqyNaUTIPXP9WWkNZUtimKMoQMBVAVGgKoV6lpqKsO4x7nDEkt8G1ix
X-Received: by 2002:a5d:6f0d:0:b0:475:3a97:8e47 with SMTP id ffacd0b85a97d-47df07f5453mr7632216f8f.29.1783589763769;
        Thu, 09 Jul 2026 02:36:03 -0700 (PDT)
Received: from [192.168.0.105] (88-187-52-200.subs.proxad.net. [88.187.52.200])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039bcdasm51655410f8f.21.2026.07.09.02.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 02:36:01 -0700 (PDT)
Message-ID: <a8f8eac0-2332-4f8d-8b4a-c13570fa5a0e@gmail.com>
Date: Thu, 9 Jul 2026 11:35:56 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 000/129] 6.1.177-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260702155112.163984240@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/2/2026 6:18 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.177 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.177-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build fails on MIPS 
with:

arch/mips/kernel/smp.c: In function 'stop_this_cpu':
arch/mips/kernel/smp.c:396:2: error: implicit declaration of function 
'rcutree_report_cpu_dead'; did you mean 'rcutree_prepare_cpu'? 
[-Werror=implicit-function-declaration]
   rcutree_report_cpu_dead();
   ^~~~~~~~~~~~~~~~~~~~~~~
   rcutree_prepare_cpu


Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

