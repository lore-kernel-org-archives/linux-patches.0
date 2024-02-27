Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4220951C4C
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 20:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709066068; cv=none; b=qq8l0Gx9kDw8oY89xgxuGQVORuLgnkpPlPssckQjO5c1QA3phpG4JdLjk0PG+jbczfhG5xVhg+ve0Pjmar1Gcyc3OlTm6ZJ9CZI9LHFAlw7KttyeHMYJOwdo04UzYKmCrYmsanl5t5/LrhWA3GC+ZlU8Vu3pmKD3pZCf1bgeP28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709066068; c=relaxed/simple;
	bh=f3z84LXBnZzBPTb1qf6WzHGjUhjJLj8dRujsavxbKpU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uC7MBKCf1xM3Pfehjq9N2KUmoluOeawWpQZVu60DmfCxodXMUmZvaEQyitjLrCd3EqILmegn9ZIysZ/YfUxhtwIMYLQkr52pnjW7TM9Oz5LzdooWPqw0SPpkyQkRsE3UWxmtdJkC35et59xWk7r5VoNnDR3wq4dhWGkLPzIMAy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hVBKcaYf; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hVBKcaYf"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3c132695f1bso2700529b6e.2
        for <patches@lists.linux.dev>; Tue, 27 Feb 2024 12:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709066066; x=1709670866; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mK/ZFrnnYw6RSzivQhp5csCqakE9t+9sf6LNYK8Z6+8=;
        b=hVBKcaYf5yK4wa9YuqsrnSERJokSJrcZyL9yNdQ9fGjUJLyvSTE+R8KDriCOslITKY
         W5CwUHXY52m/vVwh8n3er9jEFTyUeiDoJNuxpxIYqmMQfa11zWXEK4jVNJV0VVjbmvkn
         wfCrz4c3zLf1NnPKeB+6xuLqttop9d0WlpTrmRHV1APiVhHFhtvFekEkzAYMqt/N6W/O
         4PsOjv8yB5nRd3glv5elLK7X0Gyza0srR6VI7JpvAZ3LeDY0wuCW7rPZXi7kmzPOenKJ
         1cR8YZCiIdcvCW2bmZhKpU2RXBIMFBcuCi16rkbmbI/WbRvIG5yE+fZ7WYrjAwftLH/p
         u4vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709066066; x=1709670866;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mK/ZFrnnYw6RSzivQhp5csCqakE9t+9sf6LNYK8Z6+8=;
        b=nc+I0C2/tkeZv8ZzP0LTt9lBy0GX7zJtePfUTj5G7QXkYOModmcCdLO1+DdzPUE44T
         Z4yD6nvfuPFW4CDmB55I3xnBEMT8DYisRAqfClUBrtfnouwTaw1EJ8qJbQ7hDpMnt9OG
         36OwfXlBfZcMP7GxsQsfDrT64KstY3VFSJmSSRPfglynlD6CDGwIiOJwqmvew+NW+scg
         Gr3Qanik5l+6w4zdWrf//3xMmDHWHTvmfHVuYcufulQ0FVmDUbbcgelmuQu9+yzHiBXO
         nUX8Vq/juNHzvPJj3wfW0ISnmBNzr6+gbOsuJ0MPz0ir5kVl17qXp0Z5TBuq6W5LJ1Yk
         qQKg==
X-Gm-Message-State: AOJu0YwC1r+gKfYU7dc2h3YkP8/GtXL6B1PxMQ5ZcfeU2YCJ4x03+H3B
	pOrwzgybA4kbheu0WyQDlFyirqBNfzrqBKJlb164OKOeXQgHHHboX8wY2JykOd4=
X-Google-Smtp-Source: AGHT+IEcT+EhiyvnVNxO9WJz91kkjHWjzkOXE0F36aECFMQ+TegqvIo8lOT/IQRlb0m7cfwCLt739Q==
X-Received: by 2002:a05:6358:1222:b0:176:91bb:9600 with SMTP id h34-20020a056358122200b0017691bb9600mr14704650rwi.3.1709066066189;
        Tue, 27 Feb 2024 12:34:26 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j3-20020a0cf303000000b0068fdc6f89cbsm4484480qvl.133.2024.02.27.12.34.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 12:34:25 -0800 (PST)
Message-ID: <58ac5eb4-3412-49fb-8682-f8959772aad1@gmail.com>
Date: Tue, 27 Feb 2024 12:34:21 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 000/334] 6.7.7-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240227131630.636392135@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/24 05:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.7 release.
> There are 334 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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

