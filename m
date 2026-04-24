Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED87245012
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 22:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777069333; cv=none; b=kDfVJlQSQweE67J0XFy5BaAItPzIe04cZSJ9FnAE8phnm0TQa5BneSTt1oFVsCe1F+tgP9ephwhkgUcqnzJhKOLdpRDgp79UGhEj0+ISdyOi1HJDdwg/lZPNXgr45T+OhCGvQwea5WCoEP8lSQZVCmyPRuYhfo1+kAw455EtEzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777069333; c=relaxed/simple;
	bh=oYNo3/+FyEKrTHKLJkRD4aVvzna102CatqrFg3NdI4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OgsBvV/yLUORrMQcNBIQdQ9sDo0OGCVPDglM1PXfKxEsvpqoKmdfy2O51WrnocF6Nb/h7zxL1OWLPEfGVTd/nqwyH9j777kne0bub6JQLBCPhRBvV3/uy1aQFOHvPuSNFAILbA2yRd7F7RNo/n4ED/o7TnoeodUB41ET/3DymkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOgM+PcR; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOgM+PcR"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7dcdd1b492eso4153142a34.1
        for <patches@lists.linux.dev>; Fri, 24 Apr 2026 15:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1777069331; x=1777674131; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jLa0zZdyW+6g0urj9+DuUfwOz9Hpy4c8WpAoeyZh2sI=;
        b=HOgM+PcRHBrdQslNABy01AW1Kh845CQmLRpFsTul2dG0XlHkqgcytJHnRy/Ob3kuJ/
         jXs+QNTCCEy9XGNS7AYrXbh7ybtI2+suidOk/bca2ahYtGFeLoh85vLVH/ZzM7Pihci6
         MU7i6OGkTT403Wk2zHk2Robm2KlNg+6qB44C0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777069331; x=1777674131;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jLa0zZdyW+6g0urj9+DuUfwOz9Hpy4c8WpAoeyZh2sI=;
        b=ivn6+rWqVbcaJ8xDoKYA5WAjtXLnLAZU4exHYqJvBi3UoDVokrsvOoqyHHL2QiHd6Z
         DoDVDmdfksd1sst/3o5ZiJnie9YolxEBOQBYXE6YsDq/y9vpXloSRGUyNIvCux0Ejuur
         wB/DwnAiRLL6VwTiTkwR4RKTfJTewpKggT9ROu/SVrVdngCGLNiIUQl7aTBej+O7i38c
         zU6S+VZ5OzMICXFxCBZJFG1BAqnuE2EH9lZPiywndB9KROyktDg/ROLQoGdBKzxQlNCN
         Pl2AxhogqyR7gFcy5aG2LUQsUqmjULwrtOlK0nSgYO3tvknHkk5G+wxieKnBt2R1LBqm
         z66Q==
X-Gm-Message-State: AOJu0YxMpnECCSJlefJdIiHZEAaEbtQgdS5rcuNWsqgfDjnQXBZw+y3f
	UXPQVCXIF6DycjFVLZP4LJxoKOskIIwzs0hPYs0wSreb2j+cN3CBqDhJWPVnoaD5WIE=
X-Gm-Gg: AeBDiev8Q18pNnzbWnmh3LgkCpPBlIZGH0GTqFjwZo4ndsqS6OxKYVuNkFx9NHbEySw
	fo3QmACNuHPaddWqrxfE7alS82EpR58FoAIVkYvLC6e65gWDa5IrFo7UVFKLsBAV4L5E5WuJh+4
	3guUQXB44x/a1w4H8pELSgN3KeWN9DnWPAEWX1jTYAhZ5NPAEGh5pdKmcQoK/Kgt1H/H+iX/avf
	07mos3e58mLF23tLuYfl9leToozSEc/L9nTjF/LY3Uw/jwGwP0Vq19UU363G+VdsNypRECYHD/E
	PhcvgYVVYtyFLITTRmpf3VmXSJWszinWm0RvweFwsXgpJeReb/5lwKxHCf7KKAt8RMO63kPip4f
	DhO0ixCBMSVjBxlSXTdcytJUG+SlpFYQvpr6iLi5kBg6Hdsosf/S0rQCiV88kr/oZtsyhBuixBW
	Z+44DNcdLW08xVlsdyOpatdBmE1kF6sGn2PpicGdOSBQ==
X-Received: by 2002:a9d:7f05:0:b0:7d7:dead:e388 with SMTP id 46e09a7af769-7dc955de02emr13490999a34.15.1777069330948;
        Fri, 24 Apr 2026 15:22:10 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dcdd3fb6b4sm9815628a34.7.2026.04.24.15.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 15:22:10 -0700 (PDT)
Message-ID: <9272b18d-d88e-4dba-ae00-4302d3a3324b@linuxfoundation.org>
Date: Fri, 24 Apr 2026 16:22:08 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 00/42] 7.0.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/26 07:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.2 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Apr 2026 13:23:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
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
