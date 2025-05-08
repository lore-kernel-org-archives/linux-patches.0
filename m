Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DA98460
	for <patches@lists.linux.dev>; Thu,  8 May 2025 14:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746715653; cv=none; b=gjjn0UIote66jdm4vWvFkQuTd2ULllPhCy94noGoOA6wSh8NGZ2o35Qx3Lz7lI9Vcjt3oBQXmIxc7Ek+thfL3eQmJP+ZOlbixpaYb7LpoeNz3M8qkE7fVarLM02qDVl18vD8g4WuFeyLi+mMy1L6+NDdxI6kA3mGJ4FTREEQz9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746715653; c=relaxed/simple;
	bh=luUJyA3uAaGs/PyaYYxxJvQIzj2lSb8XygjS9Rd72wo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T7QBL9za5Eair6r8juySWbouzfMLaZ/3bk+Jhj5YTUsIWaz2KSozrUH1ri6qs9t8hbu+OWNjGmC2Y6UFN0ucISPo8+tE3z0qKCK1Zi/8tqb9i+9d/8hfqDDV9fuWqFlWYkqPElFyeJBJU6uiOnQdfN6NYQhbUygelQ/O7IF66eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCTZvgC2; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCTZvgC2"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-86135d11760so76702439f.2
        for <patches@lists.linux.dev>; Thu, 08 May 2025 07:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1746715649; x=1747320449; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QrqpCdSBggVj7dmGh50mibgH8h/HbWjldXII+uWa/Ng=;
        b=bCTZvgC2F+9DHaRLYAO9Rf5VL4aTEAlkJrvNtbIVZLUyUzJwwTU6/v5Lr8cg+/EpLj
         seSKAGEtB9VhcBzTFkYSqN7cna0hwRMKdOGxcWgYyhuB24bHZaEYPTyR9WqJ0HfS8k1p
         bQJtzJ60ag8lpzYuwDJCGdirPpWuRLFtd0BJY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746715649; x=1747320449;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QrqpCdSBggVj7dmGh50mibgH8h/HbWjldXII+uWa/Ng=;
        b=VBmlobj8xIucFWDIl87EJuAq8hvHVg3N2PItiusKQFZ4ddGtHTAj9Dp3nPWANxmRL0
         qBjk4uIgUV5FRJX3CM2eu7QRzoJI7hCU0ofciVKRl4aXPS7rKQvayq1xHpVa/3D76gRN
         WI6dDjIoAN73E4tbuP1BtSk6N8uyK+M2/58NA508jPce3HKEqq8oQqma+eJDVlZwIVOM
         JXhqJWAiDQ/1RmJK4Qp837oBY1KWTSo1SqolMZwqVCQ1nRLQWbSQ8LykvwWHRiPhk0No
         LMprlEM4pjcF/fmLcRWj2L5Tl/9HqFqHvQgpsHCt0R8gDmcHc1/fnniw+xyv9um8tg+9
         xvmA==
X-Gm-Message-State: AOJu0YzyIjih2ebz9VkoSxNZ8cF3gaFzgzUARklU4gwSbKWd6JkYbusD
	pxpuIl4I9657WSrQrX3OxzIgk3e7LM/zEELvD8gPtL/WM+F6yocQp5VKPxj+/14=
X-Gm-Gg: ASbGnct+MYpqAVnu2xYdA2586nAsFraA4/+HN4w/zc8AmRNZq+dxOBUUE+9Bqhy2Wce
	lduh6uP++KPQFwTbPvZYjYtMWW4tm8e4Q/3Vfn7HugP39n1XPtpdr3+tQVrNaV+zCIcXJJJOais
	xL6K10sorNmHwi/eOcEoOtAcMd91BoeD/DdRi4utgwuWa6/PlNt8vtpl36I/ARH802W3dlvD32x
	5Z6d/0PTArp5RTfOYlZcmhl17+lfbJDEjUZ1W/qRTk/DxUUPYc+cG/RBo9Z30hRS1AI8FyW122Q
	6ujVSJbMkP3Mu++31MN6M7yKWxPW6sVqOkLiR+FK9eTZbxTmAjI=
X-Google-Smtp-Source: AGHT+IGxYglVOnzP6wSYH0JFEU/1vIQ7nILmgdTbPRyB1ivX5F+qBWHF0YJIRlfVAST6F9A35ixJlw==
X-Received: by 2002:a05:6602:1609:b0:864:4aa2:d796 with SMTP id ca18e2360f4ac-86755073684mr422835339f.8.1746715649197;
        Thu, 08 May 2025 07:47:29 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-864aa43a361sm308633939f.38.2025.05.08.07.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 07:47:28 -0700 (PDT)
Message-ID: <c2d56742-8156-4069-8843-9e004cb1472a@linuxfoundation.org>
Date: Thu, 8 May 2025 08:47:27 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/183] 6.14.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/25 12:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
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
