Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F363385A1
	for <patches@lists.linux.dev>; Sat, 22 Aug 2026 17:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787418337; cv=none; b=hSkr1hrFgWKboQVPz60atQg+gixdvK2zWFzaCoZtKOyNho8BXHTz22NB8PUiIgdWL0euunCPd/cxFs/i0sjo+4op2umBnmp7kKuQ82Yv07e5g4qLDEBGhny3eQ7BNe6dTaYuFDOXhaT9wD6+tU21f0H6aTHv4Z22zB5tkRXMZt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787418337; c=relaxed/simple;
	bh=QPLlNMMbjesKQsWEfI/phjjPWXr60vHoWmwqRuUuxs0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rLCGcmY/uZ+tqD8Pwg8nX51tH+WCtvJXDRp3vhs9GVmTcICro2ruh73OqtkeY3VHTth6NUBxu/mz2R+M7i/cR+/31jsq3Bn31QJiWcaX93w8K332OhbxeXtrCg/wdb3CmSnEWKNrBIh+Sfnebl0yhx1fNMXJjdlCNSpD7qFqCGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pWzJAzF1; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pWzJAzF1"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-395cf2535acso1607104a91.1
        for <patches@lists.linux.dev>; Sat, 22 Aug 2026 10:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787418335; x=1788023135; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=94g4E3XXKB5hk3Ok+4/woZgjePfy9NT9YGo5t3pERx8=;
        b=pWzJAzF13yJxpvVcS79dJVgD7d9IdqOCwRe55nsrVRsgK8qnFMNJLEaHp8rwW+DeO2
         j1CuIZns4pUb1GGr5RZWsO/r+mD//9lvnH1odrzKHvBiTUxaSmZaZQjf1ozgdRj008yX
         nV7eoZhND1D5XdDMjOsMZMDZndrqjVjUX18YfZufKH8bB9AzLL9hoOfu00Donro6S4Tg
         XubQ8inGmlDS3SxulnjKHVGFdzx13FZPcXuP8ovU8oIebriesbEA7YYpnqsJ2PR4R9C6
         WE7jcoIrHW57KClioYmyiVxX7K4KGzC+E0bPUu2Hf1G+OXb4Jrp+c3fwGT4Wkn0f8Wzh
         ORSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787418335; x=1788023135;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=94g4E3XXKB5hk3Ok+4/woZgjePfy9NT9YGo5t3pERx8=;
        b=HOdVhI5RYqo5wBuFFsYJtk+AO0mMB/kO6wPiEmcNcjUnMOrhZDOPLcJhzieVGHGXs0
         pzokJKvrBfuHeESoWlflYpiK/wflzaWfTvVXgHvijSRHjru2OTGiQDy9ZFLrWrtm89wj
         eP5gIlGc3EJYcNIAbKmqUTO3LPSMkA6+axy6dErcflWXX/ePi75d7ijh/LBZKyMyteEs
         UwXBzgFREL8JyAXYpjb+M1odLbD+PhMdn9jSC3a6au3xIt0827dihAOYBvqnPpP4b3cI
         FwiC9qdtbojiuJizV3HNIWePrFm2Os+hj+eilOP1dzeLyCBOA3fOCF06kKUiu6L5lP4J
         AidA==
X-Gm-Message-State: AFuF++mHNjK7d5VtMEft0mnMuDuVD8B846vym9xlV6AGCXwOdfs5aEdx
	fDRKdJxsYTygXbSht/pTEyB/CJlXjJIvTqMpzF7HvsT3TBWRR36V6UGL
X-Gm-Gg: AR+sD10On/8tKKLFpHLDpR635THTpaepxiIUxRTff7o7v1LQNso3U1jlCIYnC4Dv0Yk
	1Q/8qT4vsvwUggBURQgE0+MIc8V4r1+Y3ElD8cKle+VXw2R9gpPdMR7+XC4zaF3KxNHgYfSO74k
	/pKnQanQ4dCtI7BgjirTUx+IdjKQ8NwF/Ms7ameBAPNcmlHTb4u9If6S4gvt+vIif/y8urZn8Hx
	4eRMdWz5c/JTsaqHAH8XB3x2zDZyBkMeuzIQVv1B2X7DD639mycMtXAMbEK7ySdmzrAUTIrUvP8
	pWy88XU5Tmr+JRwZsIrbrX23AQir8yf90tSEcPLJbxkyafLV7SmDUmvfSMTos+EZdZ1HLVo74Vc
	cjndvXlmOLo9ZkDTdDms9JLms6YRkpQcYfyskkoY6I7aJs/4P138xBW28tyBcodaWoYBcSLxiAb
	gDFzXXSZ7c5h3qfNjN9K6ms59ze3ZfdfnrtWZ05l0qpfIYqwL4CRnBz2VqRMPmNSBtsk40rq40Z
	MIAZ2wggGhBtCJXSVHEBSp6VVk4bg==
X-Received: by 2002:a17:90b:3bcc:b0:37f:a913:1554 with SMTP id 98e67ed59e1d1-395a06bc47amr26496228a91.16.1787418335043;
        Sat, 22 Aug 2026 10:05:35 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1418617378bsm8669683c88.11.2026.08.22.10.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2026 10:05:33 -0700 (PDT)
Message-ID: <aaf725f0-c618-4b01-9233-4547fb1ece84@gmail.com>
Date: Sat, 22 Aug 2026 10:05:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/160] 6.6.153-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260821142844.249995408@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260821142844.249995408@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/21/2026 7:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.153 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Aug 2026 14:28:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.153-rc2.gz
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

