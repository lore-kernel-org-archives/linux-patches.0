Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC77429CD0
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 14:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787324051; cv=none; b=uS8z486LVLYo5Za9Jp5TaWBAJFHLiZZh8rgLxS/bMI0uulBc+OWgLuUBaSGSeSZNgS66y23TlktYfASdGLevxYpiQG+PgVE+NhgbAhZtU+y4/idZUZOTWhV9rY1b5zyGxQXAhNlUqyadzNn8iBQvHQO2Mc+cDhnOv3a+4qK0ml8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787324051; c=relaxed/simple;
	bh=+QWOHi4iDKzixCrf2abc7549MNGBHqZ+bmmF209jmrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kgaLWMgHNe+RnRQupq6vXQn0Y6otwQIpHnj2sha+fGFxBpKUenKB9PdL1k6L13zbbVHXh+VjVPUDLO26VBLxxaws5SurNnWp1owudVpibOCh7zpO9vI6xMtWw3c7hLHY8IcwxuiDJRzjw3rJF/NiUBSlEIkdr9cQ6qvTbIr137c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PquytH4K; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PquytH4K"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc11a30a259so1109892a12.3
        for <patches@lists.linux.dev>; Fri, 21 Aug 2026 07:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787324049; x=1787928849; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3hR7JQQteGF/jQra7sps0X0N2A4rZsWeUn2t7Q0mVcg=;
        b=PquytH4KrjrY97dsvBPqZwnSyfY8Fdhmy4IWuGHUtcZp/jUSQCs90brFcrxdD1GXQU
         Hghcr1xH6qsqRYw/BeIciVaN/xcpmEWinsSLdNMG47+vutWJcFkKjBD6FRGVlnhXSEgR
         o7NWSVBeieIXyJicDC8LYgXBBTPXHxNDh37wA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787324049; x=1787928849;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3hR7JQQteGF/jQra7sps0X0N2A4rZsWeUn2t7Q0mVcg=;
        b=L6hhT6aTUwv6LPIs/YF2sAiQHduJjwC3nd/pYed65yQ63YS72TFLoLo+wfl0Hv5JeB
         Q3PI3LhwtPMsYe3eKchWwaEryiszl1h+zoQFnEfPPuDD6B6vBEnxcFyYT31RYmZsT2Gr
         BOjww/jNidMlU6Kgb5TTxaVEWeYCPYmjXwwseANO68abhHpg0ikdangqAObXAZnLPb65
         lHkVgtARdBqnw7qi9iP1Aq6Ltzayg6JWaELBKAV5hmChY06OLrabZ3L0Q+8rAcqKsK99
         o4YEoa/ISFe/gMfnWkDo8MK6nDlzJwjMvu0X6eEwx0sMiH1+ZM5cgao0gaedXwCBkk3C
         Kz5A==
X-Gm-Message-State: AFuF++meJx+UT5SVbNcnEdYtnvRPwlLGjFAnpEZalFi4QBSIbTX3sTvb
	y0U0eJKn504Jlg5GxZELP8ts6PaHDzUL7CzjrOAKhVLtlTxVeDyS7e68ed15696QBDE=
X-Gm-Gg: AR+sD11a14mrAcOh+g4YAuViTj9/RYZ9FNBpr9KIm8YUraTk5wKSEoYHaoffnoZJRzW
	xm0OEiqhjLQpdoWg7ECOKxMnhRi421dzsDXLg/P8vQsHr7f/SNkeSee9xzYEglp3OPmLZe6KRz0
	X9lJzKTdjxcZVlTMGH0oBPvolcIMNHM3iGsHO0EULG2PTusu52FotoehX0uppKcoDqIkX26nlnu
	zHi1bP/tra/0/DAGuc4InJZahJNJowEJx4u7hcTahpgh1zv3sgwkIeDegDN97+LVgcKn9GMhteN
	dDYChINACigeCrFP7qLHrSeshamTk8P/m97TAvK8V/lAXLxGB75j+yTmWh/ng/Pa3ci/yYmRx3X
	OzML51+bLz7Y3T7vpdR7OCn7ur7Kk+ouw8+WZub0284V7N7KKTELaX8djCga/FnPq2Vwi8f0twm
	nQbM6gqwXCyqiC4AfwTC+lFI+0X9RxYwnKmoTdgCtdmGJyqCLQD1fMoZ4aRpBJI/NuN5PzEw==
X-Received: by 2002:a17:90a:d004:b0:38e:2517:5d1f with SMTP id 98e67ed59e1d1-395c35ba4ffmr13492259a91.9.1787324048499;
        Fri, 21 Aug 2026 07:54:08 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395c8e2d7e0sm1059140a91.0.2026.08.21.07.54.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 07:54:07 -0700 (PDT)
Message-ID: <a1d519d7-e861-43bc-b4d4-c4221387bd9c@linuxfoundation.org>
Date: Fri, 21 Aug 2026 08:54:03 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/303] 6.1.184-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 08:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.184 release.
> There are 303 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.184-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
>
Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
