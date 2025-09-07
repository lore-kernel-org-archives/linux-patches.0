Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5806718C011
	for <patches@lists.linux.dev>; Sun,  7 Sep 2025 21:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757280524; cv=none; b=kPnINW45vLRqsx/UwJdX1IbmN5X+L5jmR305pY0l0bLzF/BOLrYEsyVggqVs8BcK+d4Rov4xgGMT4nMpObzMmbAW/UWRRHnTOCBDLi0xYVBijdQrLZf/HXjOohMe5m10Mx9t46FxwyHsVqduknB3v2srGZj0I0+9nIcD5kKi7Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757280524; c=relaxed/simple;
	bh=gR74D3k+MV9PfzqWWLYbz2aBI5dOUxQmFr9qPjRQexA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=DGiVegHKZnCmpOJ7TPKfx3IRFFnN1I1uuusgL4ReTV6nzDcq7cx/RECVfLHdXNREAkJzEiLn/snMsjWBHQvh1/1XEd07siQmnykc2iDSOCk/O8cJFL8AO6w3friUsRyD1TXPOW67ZbymRCeFIAci1LffggoPp4Ym22Uz0w1+2Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G8kuegL+; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G8kuegL+"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b4c1fc383eeso2249940a12.1
        for <patches@lists.linux.dev>; Sun, 07 Sep 2025 14:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757280523; x=1757885323; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GPZE3d2vBpIHqeqE5zsVlFxsV6AcS3+kycA992Tnu8k=;
        b=G8kuegL+UoGJhbmABBNXlB3Y+cJVrIXQdzhXQ/aCoTJ/bPe1mcS8qN75NtX3b5nwa/
         OWN3gAl9+7pCiONDL/vOgHvLdx2+7D/Oss3zsQnkfHwk6vzWzYZmsx5BEEhHpV8jIhoy
         BBKOwZs0McjaM9iXRWUeqbXCaXDCP5MD/tF7Se0l/Y8J5nYYtpy59bRrISLNLhFD+GUV
         mmDnHtlxMZMVaXO1ZlJnd36P5VPO8Rpxh/Ovs6hPJdj3QbjZihXkH+g/acwzqw2MUxJX
         TvzGj4gHx+xLi3sfqX/hNLOALpgicRkQ4VEsbvRD5rb5mnMW0uy9djdb2N5WNMnAVOe3
         onSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757280523; x=1757885323;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GPZE3d2vBpIHqeqE5zsVlFxsV6AcS3+kycA992Tnu8k=;
        b=I431010HXI2r0swlkZTw5bA2h2yWR7ROnTT4j071XMo2fka21hLsVjF1yFXh0UINrN
         od2Ov8HxJ9+7FsmUZ8RUE0rxpMZ7kOk+IVtNY3QoMIgFtBM3OGCJrI6LyAHU7z3NNbXG
         9GSmh9fFlxGfR5oFtXOQeRL8diDTnJyyYl3xRQJbfhieIWRuMr2aU3IMWkzUANlc33GD
         Hx0iRFUn99JyZ+vbyWQDwDqbqr1/tI5x8i24jX/kBRLMD/cwQC68fKs5D7SdWjk42H2P
         UDjd1fsSjDaRyxQ2azbtaa7gmKFOtSAsZh32/rijlJGoRGvLvbaDfo2dfid/rA9PiIdn
         35Ng==
X-Gm-Message-State: AOJu0YyLtzxuqb4LyqLCOvoWaiIClj1PkYND4hhhhmtxt8m+FYCzfPne
	feqIPndJE3h5Tg8HttqGJ2LwgQiQOAd/cIJCCKPbwGuxLNuGEEmfGCQV
X-Gm-Gg: ASbGncvQ+5v1Jyhmk7KvaBuXVqSj76PxSkUqogJaFbBvf4liWjNbmbqP8I0M8BnzF2P
	AL9IZ8tQTY7h7eFR2q+aWh4fvK6LUfEVxrFhZFYUcl7l6HbidPBw8Gz+T06+z6SebC1bO30NYF3
	Eg057ik3n2/R/GEA3MosDBI3XeAVDj73yWoMBg9f7vRCsZTzPhF+ZTcsKwI/Y0EWXVeNEeMUvWG
	ztezkZogFAdehKw4fKeEJW5ye/GoI0lFulsdZI6u6XeuVqY99rBBZxdACvd4Fn+tIhnDmlNyKrb
	rtpGsUm5JmFYH3OcnSCDA7/q7ASthRJXIdbIJwZ9Z3zZ8AcsHKI71dtd1zcRIDNk8Fu5kD7s4Xk
	pyrWY8lsu3Pk08PHOlls1HOV8AxW2nN1xH1txnt2jD9VnherrooSN5tabvTaBgs4e
X-Google-Smtp-Source: AGHT+IFjvDoW0qqD08FuutCREqLKopUYq03wiHKmvvg+3FvOwAgDbd+bp/VSXnR/dPtUmeD6521MHw==
X-Received: by 2002:a17:902:ec8e:b0:24c:cca1:7cfc with SMTP id d9443c01a7336-251761680f7mr84458115ad.59.1757280522623;
        Sun, 07 Sep 2025 14:28:42 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4cd28ad188sm24263276a12.26.2025.09.07.14.28.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Sep 2025 14:28:41 -0700 (PDT)
Message-ID: <32b78edd-c8a3-45d1-92df-9facadb61d89@gmail.com>
Date: Sun, 7 Sep 2025 14:28:40 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/45] 5.4.299-rc1 review
From: Florian Fainelli <f.fainelli@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250907195600.953058118@linuxfoundation.org>
 <82edb13f-134e-4aaf-ae5d-6b9f80b02e68@gmail.com>
Content-Language: en-US
In-Reply-To: <82edb13f-134e-4aaf-ae5d-6b9f80b02e68@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/7/2025 2:08 PM, Florian Fainelli wrote:
> 
> 
> On 9/7/2025 12:57 PM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.4.299 release.
>> There are 45 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/ 
>> patch-5.4.299-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable- 
>> rc.git linux-5.4.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
> BMIPS_GENERIC:
> 
> Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
> 
> Looks like we have a minor regression introduced in the 5.4.297 cycle 
> that I will be solving separately:

Looks like we are missing 9bd9c8026341f75f25c53104eb7e656e357ca1a2 
("usb: hub: Fix flushing of delayed work used for post resume purposes") 
in the 5.4.y branch, while we do have 
a49e1e2e785fb3621f2d748581881b23a364998a ("usb: hub: Fix flushing and 
scheduling of delayed work that tunes runtime pm"), looks like the 
cherry pick is not exactly clean, will work on that later today.
-- 
Florian

