Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8092737F3
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 03:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760759117; cv=none; b=urRJbNHdfWBsYGm1Zz0t1xo3TL3WgpOrPBEdA2dWZSNwQ1sPG7oO8OyG6/iAr6trYOQZWveFHBpn1plJ/GK8kE5+LxRtFImqyQDzuwHdarRYVcobZDtBdUfz4xzdgd4ucAG7mXkSVlE7RJdYxjfkEE2ncwLatDjI8OVEUz8dirg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760759117; c=relaxed/simple;
	bh=u6/9jHkj7qO+NmSlMp88vtxuMBrWpXS2X966ZRiL2UU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=sRVw4Q1+tHkfKWlx+Qsz0nE9FWMKp/6pRdAeGbAmJCYKNUUZvWtlLC7TY/cxT/yhflacNp8lbb6mhmAjkej7dllG+Q9E06hhCk1O/eLddshNOvN/fdkXbl0XsQdUsuBLZ1dQm52fvfKb1XmC9KHkQ9sP+Z+/Gyl8BF0rgvfJT4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GSZ0/BVa; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GSZ0/BVa"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso2144923a12.3
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 20:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760759115; x=1761363915; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MZPiTXv5/P/VJj9LA8tqWCZHZQ3/DrJlaMULKUBY16Y=;
        b=GSZ0/BVawkV8yCmdKXbbSxhgHCLq2/YvwpPTfOPgUI/5I8ZXlxgoO4GU8CknSt6+sc
         mCVPPKjRBe9HOh9mcEU3HnLfwp1Pq1m7wh3N8fa+iku5oRGAkGy03OwMbmKyn7Q7Ko6F
         LfGE4t3nPUjcpEU99G/m0SKQR1oyrgsc79HDY7AthJFAhZBoTudTEKmgAwGYQRYuwzC7
         woqG11OT5HZOmpTcAt1aqSJEKKWtO9Ama9MQ2CEEsKlrgqiMSKeFAKME6oV+EfbyZfWf
         2Xfj04G5B4p8oY+jgWaBF3uosFNx371+EGamveQuRX3kwwNlCoqi73HIFcY+lsETLzUj
         JyCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760759115; x=1761363915;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MZPiTXv5/P/VJj9LA8tqWCZHZQ3/DrJlaMULKUBY16Y=;
        b=vR0FSedmVOt7iPebsHHV9FEbAk5TORnsQWWBtgtauEFMN5AvpiDHXJ11llLMd1fIgy
         cYglV0A6tACnNLC4LjzNiwRIbqMFTvfZXV8EFFth25SZlTtvLzSOldwq4l72VxWfjLOo
         sHeKH4ftuD/Gipe7Pwbu5pEy4Su/Uj6BTzy0/pih2j1wFDGPpnflzdO3crbovmNki3G9
         7GnytoNqJ6q2XahTf3mZIGvkub9Jh34F2USjLSflqAirfiOAydgQWAfiKE6suQ5HLvry
         8TM3KLAm9MYkcOL3MZxtMTItY86uDOwtHBIoq/PWlvKvBuDBKMJJJv8Pp1VOLcp0NlDV
         9lOw==
X-Gm-Message-State: AOJu0YxXCPOCgenopY5iM/rh6H3PHELjIr17kx61t1PFwqQkZLNY48sO
	0KsumVIVy9Q4LDqBr1gQXhX+913vIMSCoj8k0rVWg0bL7UE1WeHuOoto
X-Gm-Gg: ASbGncslqxT7QEe8E0saXOTj/TS3RChhelXeO/3jOvTiakgYREhDMbNWYiuxhW1npYl
	12V35L0yM5gMhzsovPxsoZ1kE5m12N70E4N3hoYPin6mFrAR6vdyNtq7S6Di7ukiSOPNgoxmsdS
	2qGAxOBLVg+KvZr+PKkCQ/r5L0qEHPfKuwLoi/FEleEro3GEN71R5x1e1tNuPfXiWoRA0ypJ0JU
	+IP+6yd0XGJ4GRSZC11fxaKbIIIMqOop83OtXRg3IbsqeZ8Q0igVLs+kgPQ7shaXq/lUQDmz0ug
	KpUyE9vf1MjqtPaPkZPrmmj4Zmn4obf4KJLmhLL8Oq62qS9bVdlVf8eiRJer5FbUCgOxILABrFz
	FG0e0sW03kCOy5HyT8BMO13gdBhtaHitGBZC0C3L/8YxdpmC7ksbi2/gxGQF1TNMXZrxBNGbWXq
	M8PXsUxLQDMKy+AcyyBQxfx+uHA88dGwBsuEXlbmNy2lJh073QfDdj
X-Google-Smtp-Source: AGHT+IEyPGDCrhJn7n3YskwxHujg7B2Q58Qq2Bz6HIvRczxy68f7zbwPSgq9Di41T7mu4GcH60pupw==
X-Received: by 2002:a05:6a20:939d:b0:334:97a6:17f2 with SMTP id adf61e73a8af0-334a85640efmr8177662637.14.1760759115108;
        Fri, 17 Oct 2025 20:45:15 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33d5de0c06dsm1035981a91.8.2025.10.17.20.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 20:45:14 -0700 (PDT)
Message-ID: <2d9f4775-7f31-4088-930a-f8b977f4ec22@gmail.com>
Date: Fri, 17 Oct 2025 20:45:14 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.17 000/371] 6.17.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251017145201.780251198@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/25 07:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.4 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
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
