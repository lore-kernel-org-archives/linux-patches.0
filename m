Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD7148F836
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 23:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787699585; cv=none; b=rqbfB52ZJLiGlKuk52mascN4qbNYKb7iDGmQ/ZzD01tHcohm9aJd8J/AKEICalNosh5VmX1dyhCsxT3r3aCw6Vjc8Jb11xNxdAraDqAVEmpCWNxHEPo6DsjgG+B1lmrFLf01lPoyIFDZYyPDmuyZs5YBt1nVZmoRQSURk2QArdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787699585; c=relaxed/simple;
	bh=EAigMp6mAy3uoMpM831S3WsqDgx3Ym05X+5Typ5TZAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qvJ9oH4UunBNovSgLKpLsyfc+nfvvt9Ic9emGhUNcPzKLbh6lipqcVbVw5lS8woXe/yDhLlUxZOhAprz9qHbwYH82CEsgVPnTBqLeSEdL9Wik50pMVl5XNWEi0OJ2a2W5xRipSYoqvyMO932nj76EnrHT3G6FsaO2iGVgJ/yj/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V/OW5NYV; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V/OW5NYV"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-ca7bea5e5b3so265073a12.1
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 16:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787699583; x=1788304383; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RYBbOmVTKABvrkkz+zb/pofYfQFESYc0t56Qnb9KVDI=;
        b=V/OW5NYVlvSvKvto99Yw9e2IJp4jtfxTJIvuyZ/QX4VQGorfgRGeIkR50HS8BsKpie
         REsFCLDMPDpzdoQ+334bi3JnD9PGSs0EvgNNeD3ERpKKJ6uCgPwS3p4VtxHs4TIMKK0I
         5bM3ct4R6IW3QaI8oL44ZhHnkE7PvRVFqmrwP0NeNUEdGaQh2rRK+Vnsx00t2cc/Ysh5
         eYipODMZQmduwoYtL8yXgPOWQQoDEIVbNOG9CLQlYT/bY7+KpwaYNcwifkdFA6bxTF32
         7FL1L8aaFyraoo1/g4bBW+XNU+/2/8gImKtkaVE5DwUoujYeUXWb9rS0qcT/mkFwt/XT
         Q4WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787699583; x=1788304383;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RYBbOmVTKABvrkkz+zb/pofYfQFESYc0t56Qnb9KVDI=;
        b=Rz4upV72dgaeeNYsp4d2+UW7zSgC8uKNwU6kfRTc5RQl1q3pWOBaXwcY/AlGorAGBZ
         O/WkYLfyKkWXCBgvXrKDWV91itMPdB1NVOg1j0fHaGhHliwXk5rS0HMAkXOPZw8/+McY
         +o1jmPzIuTJgPaW2rGMZHWpl/DukpeLVCLBUSSMsKbadEELe5sOn+YzlPzdGfAehW00i
         BFUY8G8iMNsQv6+qjyMnCEIIQdL8pFN9LW1BSsR+GWu7uQksDq6pJdu5nWUaEJlvROjv
         VVsO5uMbZNm/1J8YvcUDantwkGiz/e8YhxH/VNj+9CjaDvpkqmMDuk6tKzzpfJqlovLQ
         7qZA==
X-Gm-Message-State: AFuF++lfGvHhmH7quHcp5tlAlCylHxow7UsJNPqQrwtIS8dWdvtud4al
	s11XIyfbkoldKqQNqhFJP8dZ6/+xcTH+Wg6wTt2vdz9NldPop5VmPWQo
X-Gm-Gg: AR+sD136URZUNNW8psi+jdoFXN9gV9ph+pSzHy7/dqN9ZPnLNiIr66snE5dC0Lv+S4M
	WT4rh3TwwuJhaeFBIz294ZkYwIEZGKtdxVOQRi4R8XPwPpsikPZFrEdTV20lZ7HvTAiK9vPmFUP
	BHAY3hRMeJW2L2Xx1w0/Sygme+OvWdZEkWhg6zwK8RgEyxyTkAJ2w5M26iKOkkqrLYCX3aev0Ux
	p7Iw7TCY2h+0CXvrSfwJHBgyzxjvbM+1+j84CiIb1ROxBjlncM/ixb48KhfA8qg7Ljc5ltfsSDe
	5lvwq1qjVTWXKYr1ueom1BsYGCt0z9yU7j9mfCoq85sQfwqppLHm3w9CkvqbDRQQczUrDgW/o2K
	xTvsGxRlZ/NpIyobSdJ09GclkEW/rxAo6kU0yemAv+ckBZov+TeatF0DZgHOZRFV5DlMXvZQPBk
	fmR9miHdyKAYmyMjF1E9lxm6a1LCp/ljlXHGBJ4xUrRboCbDabohQjs+isK3Gcl7HU0txkth9Fa
	A1qvpOpMVoHl5vtOw9UQwyrgw==
X-Received: by 2002:a05:6a21:6711:b0:3cd:a1e2:f238 with SMTP id adf61e73a8af0-3cf851546a1mr4332973637.16.1787699583390;
        Tue, 25 Aug 2026 16:13:03 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141a8e118fasm2400417c88.0.2026.08.25.16.12.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 16:12:34 -0700 (PDT)
Message-ID: <8cd99d70-2dcc-4f05-82c8-8d97e99b4b33@gmail.com>
Date: Tue, 25 Aug 2026 16:12:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/94] 6.18.47-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260825132541.887883084@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 06:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.47 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.47-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
