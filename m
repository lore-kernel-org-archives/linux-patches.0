Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA993ACF1B
	for <patches@lists.linux.dev>; Mon, 20 Apr 2026 18:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776709051; cv=none; b=AmG1PwwQw9Bc+YoM2RXUD5IEZ0O1aMurm8a9qHXA2k2dRvwWfW3/fEqMy0xvwAGE9rJAdanNBys27Mg+0er9n1g2gBuh0FzJkFeJk2zUn12pwXg/Yaq2VLy9L6cnoJB6jcFIPiv3u6Dt3r3M9248Gubx7lf7zOm7tyW5oOu+KjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776709051; c=relaxed/simple;
	bh=V5EC+3U8AklyCgan+vJfwHlRkHMhPgczsTl3WMn/fDA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kmQzqJsdk9dHMDWDG0qzg1zMrpEoaxng3b9nfdh9c7HNM/3EmiKLipYLalE9oHsiIddP9qtt9aBG/NwDKFcskOOMjlApZ+bdCL8NYaM4rQnP3Zy5OiZ7X/W80is567cFFPj83ZaRO39Oyq8Bo0fVqX7e7yRSPx1BoVu1X42yUyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HsLmBHKU; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HsLmBHKU"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8eb5ad01402so126269685a.2
        for <patches@lists.linux.dev>; Mon, 20 Apr 2026 11:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776709049; x=1777313849; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9lt/Z3RJdhJdXLDrfVQy86Oma13FPqwNnNxDceu5vR8=;
        b=HsLmBHKUTMhsABqft79HswfjyKOZ+mveWBp1WLbnmlD1aH8FfcbrKwSzIGqjI1VpCm
         QEN2Lq2/nOFEChSaQNmpxYhPI+fh/uL8hjmFOAhf/uefYLwTa/5xZ+IceGD4BRhp7crI
         /7dGkV0bxC350gANQMPHRuT8qXAdPY/k9edVDNjEHJOX7wjd0fWAfNCQ7UjfP2/hhwlH
         AsYNJD8dkV+GQxysnTw4zsj9mnhDIlMWg5tm2/VFI8PvoGeNkyCtnvsoxGaBAOwdiCvx
         BdOrslfEBGyZAAfxp6b1Cij9UCJW3Le3/EP/Pwh36jqe+oBJJFSJHI10GpNtQXqqLVXn
         AOYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776709049; x=1777313849;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9lt/Z3RJdhJdXLDrfVQy86Oma13FPqwNnNxDceu5vR8=;
        b=U1GeFR7NgZo53ABOU4p3QUhdX2FEIyNW7FSiAMQkNkcYd3mo1nJwp1Xa46ejcElkrS
         e14y8F+FIcoxT8uGP5uPqsSjaabv4dmVGenXtyQmULLYL8My+HuHZDmQRe362hPfrW7t
         i+gJ6TgZkPpCqHMpuaDjm7VRUBZknLs+k7BciWassGjCK13UlyPbIblHJs/zTwoVUXHM
         9FYgPT0av46xtp1emUeWw4Sy6CRUrnCp1wuSNRIa4OrZKJCp9368eIIbWWGUTE6ryDht
         C/WNsKsulLpQCsBDdc3A5c3hH+c+w6/KRipEa6JWfJPRhpDHc6Na5zNCyvJheLrcf9+H
         IcAg==
X-Gm-Message-State: AOJu0YzlapKeIe5zuu/66+Dyi8Glv5QgHEEO6Mr7++z2BQO3wwUrfM5f
	/RqfcxUKhMQTmvGQWAA/P1XViQlSEZcQq+kGaWAUxSwnUEgY7CmcPYvJ
X-Gm-Gg: AeBDievAak5SCxuN6fpxbWpLxInPmdgtkcMNw8sSRz3VLrEkr1JxSTDhQ5cAlea1O29
	sMvXTo5cobXC0zp+4brX2w+U32qbDFEIfMISueIGF7rIEf8olirIJcmDgokb0Pga4FW75P2f6RQ
	qlMR9ebWWGUctBtLqEbVQF35GexV+6VHNsoUFPWR5CpLYofunbAqXeGVkjbsRmtgntDdL8W59JG
	Yt+jSIsf72olj7YB/w+aELc4Paq73YCj6a64GzOIO9x+ct8CsX6aLB/erDOtwVVtH46z7yXwlyL
	4OevoCDLViGX4GTfchqjC5lMxWhToAYYlUwHfN/2UuHuIkV+tSadOsUS3f/G9Csaau8m5CWfLpZ
	UobHtS1QGA8dXYRSQDE1H1mDIVwC85ptd9+qkIXr/UT0lj8/H+k31wtq2KvTwIxroOM92l4Wn7/
	gEb0/tcl6+KAkDAvr6k3t5kTLxxA98P8I6s7pTyF89Pv40EEzju85n7fiRPFR9
X-Received: by 2002:a05:620a:4554:b0:8ee:2c17:2ff3 with SMTP id af79cd13be357-8ee2c1733c4mr44142485a.0.1776709049110;
        Mon, 20 Apr 2026 11:17:29 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d69ae320sm990989085a.20.2026.04.20.11.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2026 11:17:28 -0700 (PDT)
Message-ID: <7cc779f6-3cad-42fe-a8a3-fcfcea581015@gmail.com>
Date: Mon, 20 Apr 2026 11:17:23 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 00/76] 7.0.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260420153910.810034134@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/20/26 08:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.1 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Apr 2026 15:38:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
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
