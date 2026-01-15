Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD6E330669
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 22:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768516833; cv=none; b=u48xp8DQucbJMBZGm8TMzTEjTkNbJVC2IwCqew2Nv+h9YPa7fG+wmVxLmYICiiroafi1OL/G2HEYsoPl9I7otMLuyd6TMrUreIcVm8keyZjDm+zoc530v1jSAqdAjvyKHZZncYm3arqrmWX0cim/jBL+y1WkLPJPGLVwMw26bCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768516833; c=relaxed/simple;
	bh=HMNbA5LmXmY7WPBtXg5bBxhtTEiQsyJQyW1+KaxbvYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eQKqHP/LwIieDUHBqjiBQWZp5IefQYh1rrIBM0oeVHxfYEPXy/w9y5lbM24c29Mc62cZIkd5U2iYUHxYZFCu2Ex/tIFsOi0ryj3DbhUkPkbtto2Hva4Synh2e3hFebddoTNDbDwMy/9VJZKy5TBhyIJckZt4lMX+3A2TPmiEM5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Av9UBrxK; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Av9UBrxK"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-40413188553so965693fac.1
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 14:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1768516830; x=1769121630; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=svh+3n6w4xdcsiONDBlL2rmEv+7D9XR3KOYEj4trX4w=;
        b=Av9UBrxKhJTdhQCCn2eImxQNWR68iPk3dcl55YcK7G3OHRuvIUNep5PjWlTiAT2KTu
         Bzsmu3mafauRpHE5zVzQeEvwLf+mxmPFHHQ4SPYUo5xLcqWvfg0TmLxn54O/fdyp9gF8
         tnhH3KChvDtdjX89/5WhBOCpfRr4RTRnaKUAI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768516830; x=1769121630;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=svh+3n6w4xdcsiONDBlL2rmEv+7D9XR3KOYEj4trX4w=;
        b=sQ5JImgpfC3/pFBXekMqhB7NBYh+5WYcFtSilumEAxNIlGTK3kP7d+k7drQo536GPS
         yAsflsyc5mjJiaySIilEF4luSTvGUnNHHhfkrMoxcWMIfqUyjEtkLxjnjlxdDVHyGMmQ
         UAJ7lmWoy3CkNqSJu93ZfhmTikkXNZzBSz2XF16yDSy+ddxL7qc6b/97YS7XcaMk47/u
         1DqGCU9nsxI4a3VmjeRTiVaWGkJtL8Je8MRsPsJIVvqI2+YMssaLBrlOVIVsoW66D4W7
         5rSgursUPfTFmmXwqHbVyY9z6BkccNrxpJET8v6GbRxQgAyMe2cf9l8bZh+o+ByhdLfB
         8jUA==
X-Gm-Message-State: AOJu0YxiNYUssuzmiHFk7QwTwpPDVDAI22EYjsFVTblI78kQ/bg/QnEt
	Jxdd1JrWmWhCNxbQsmu/usHw2yR79FZfFizZcWmlseo3cucuP7cHVjGhrxD20LZCIbs=
X-Gm-Gg: AY/fxX74VrK5r7hLaGC2U6RFirM8b9oLs7DgJ/0XFoSThqn39oHKFCurLfTea4dnTX3
	YnmswNjDn+cvBocB0D7BL2P+EpIDSzwPAV+UHNyWZy4OtsBvArD+FoSNOvg9Qd3rkxfB4gX+3nW
	uB3qXhhmq5mg0hHZnAPn9AJhdsUtK0N+okw/KosC9jDdseeU+b/v3sSPraTAe9hmyVc91trbMQA
	tZRaspoWhOqzyz1gg0VP8eIWTbfqdvnD4V53MIGrsBgyKgeaDHILmfD+v/ckjiK4UMgB8+oOnin
	ui8tL/Zw1LWUENtlQvLnTTe+vhSITtZnw4clEJmGAPdI6gkGB+Pj1cVXgbwZVGwRkkeWIOMXhuw
	Ka3U58790naLeOFKSB4WGTauqlx5f+lLFZjuVzPiH+91p8s4Ivsnn7jVHcfMgN1ZuIJyN9+1FI5
	cTxgAnMDvglZFWlgRfWzUxYe8=
X-Received: by 2002:a05:6808:1a0e:b0:44f:8f02:cf5e with SMTP id 5614622812f47-45c9bf58363mr555672b6e.18.1768516825585;
        Thu, 15 Jan 2026 14:40:25 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9dffa9f4sm371115b6e.10.2026.01.15.14.40.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 14:40:25 -0800 (PST)
Message-ID: <b3f9430f-4226-4fc2-8825-8618b8caeec2@linuxfoundation.org>
Date: Thu, 15 Jan 2026 15:40:23 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/181] 6.18.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 09:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.6 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
