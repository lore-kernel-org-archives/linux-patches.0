Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3313649C4D6
	for <patches@lists.linux.dev>; Tue, 13 Oct 2026 18:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791916458; cv=none; b=OrHhYrq+4uUJXLPmJ0veB5cseAXtIsB8P0xN0SkyVmMR5uJEsHLCT+sD0+/9Wrc6jYsNykSA5fE+LCf8TwSsIpxnVOmzs5i9mwY8xcF2ClO5gKGzIROK108UbGzKvgZ3shraRiGjjgDodheV2aKdCyjinvQW0HK566GzccFWHP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791916458; c=relaxed/simple;
	bh=gebbGvmgTzGyJx5X3pGdjNejK98oYXopgYCQYWylHfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YQo+irLYj16rISMXeUHplHvxxy0XSyEBSJQ8nFwq753rIQRXL/qqF6zQmHgf8PdYn4BklNhZgRMpOdrcQtJ7cYdDr46ui3eW5zWq2OlLG8QVswKJwPHJQ3xOgwiMrp0SPw6dRdePKwCBD981mTg/PBP1Bu1Nuk8t7OJtdEr7PoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a2Lgwcq2; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a2Lgwcq2"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-918f75a68f0so55656976d6.1
        for <patches@lists.linux.dev>; Tue, 13 Oct 2026 11:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791916455; x=1792521255; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SBk9Jd0lNDJeCaVR9wht3+TY3PnWo+nDczzO7C6GQJQ=;
        b=a2Lgwcq2uI32DkauJ+i+PxNnrTrNmROnOv1u+ZDzel9sANDxKDbk8Z3L04hUwH9COm
         6qKO8ahtyjr4M9hmelh5pStLS51DIp7htMkRRW192iKcYzww74jw1XY8QZf/R4kmzPyH
         WCyVS/ksVLmI4sGvsCmyg3MoCAa+D69fLtQ3CG/lE6mTUI8fsktKFPZk/t8qNUEUcxEl
         LdErkNZVbObRouRhbfRZrq4Um1k9PAg8q02Skh5X07KMQBcJnUtUM0xMU4eEhOU1v3pR
         xAmDq7i2ZsGVDkZJEHq8Rw6AXOPWdsAzMEREdJaqjhm5k9BY5SiyMMwmo5Dw6mhrJani
         htdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791916455; x=1792521255;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SBk9Jd0lNDJeCaVR9wht3+TY3PnWo+nDczzO7C6GQJQ=;
        b=KMYR1FC23j5e6xRO96uqQfOOIaSpB4bHKrNF/7PX3RCfYAQmPcslNwFWmGQV0dzX06
         2rqPEBcpVBMIX/Wa1HwIUb7mK2m58klmq63iNUhNPV63vEqCP4uuIxGC0QlEYBje0XoS
         Y5frIlJbd90evKZC73k2xuobyv9xunagD/3jfpe9tzTQj6ymtEGgQd6S8rSWN01+5NdK
         P1riE+B6i0RfnfKSCAs2SsvjppoT/8a8WNS/Kf9ROkpwgD/o0N/c8azM6f6LVqzVX1yR
         4PySo0qFk258MYJyZga7eLvHp3gmfDtA3MWNZ9ZUr4ZnTdJuwB7DeVT1yedG+vkjsQvR
         4Rnw==
X-Gm-Message-State: AFq9FYJc6bghQDQvakWjekMZd9OFnc7/oQuPndNv46yirPr8Vc6LyC34
	GUmfiCq+SC8kTKGIHs1bfSDXlOCu8XErzFsDV2U9iuiHesM/kQK/KBXX
X-Gm-Gg: AYBFou2QEpnZq4xqHY01OhtggmnWcZhlZpbFpgygsuK6E3lIWZLyLZFM7sMC0v50OdG
	tlGY0FpiOnAmRwT9aqFQcuOugl5sDoJcOYlYWbwr45LNBvjgww/j0kQFZsosKrTYZEGuqKurtNi
	T35fcWktfaZALLpSIJAp4pEjSZbmHxlZrYnTcaZhkj3Tt+mLqFhr+YgKwGGaR47SLeVPz7QouWs
	oIe91Bg3MDs5mcZT1KDIEoUfp2pngwwvZcTIQSTBwteliiuT5kETNueR7PYGzXnGuJOKdSx3gpK
	HNNIiz8olzuO4Q0grL3uAngPejaISCXJSa86wKfSkHL0eiRTT+Y0qutEn48IZyMZ1aq4oMo61jS
	vcr2ZhEupLaMMqnP1U7BXKeO9/16XpnVrdn6fhHJ3CXCwAquP9htz+72NUTYsmDorGQG1x4zThX
	V45cvzGwpiBfzgUizZ24T3cWHJhHrfOwsAgut55K7jT0h5bFV1JjB3x5s4EGv7u9NJtS7NXeD1x
	DTl5qhaLbapPBzBM+IQdbj6
X-Received: by 2002:a05:6214:2b8b:b0:919:5ec0:bce4 with SMTP id 6a1803df08f44-91b55576506mr229759486d6.37.1791916454936;
        Tue, 13 Oct 2026 11:34:14 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b92b86sm32027046d6.30.2026.10.13.11.34.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 11:34:13 -0700 (PDT)
Message-ID: <c2380f00-6070-418b-8fea-5c48bd4dff0c@gmail.com>
Date: Tue, 13 Oct 2026 11:34:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/497] 6.12.113-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261013112907.864180619@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/26 04:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.113 release.
> There are 497 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Oct 2026 11:28:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.113-rc1.gz
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
