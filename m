Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E3A1E5B85
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 21:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745443048; cv=none; b=suxusRjjKWzOB8jf4sf5NLq9fcXledw0GsCZnQzvortmWcdkQqO+dRuOH3iwpC42ttp4qLCnHgRZwc5VROCfFCyz0zeuY31DKssaZV2o/aiDHz95i7LwYF45tKDWiZbdvdA3Y6ySD47DWSeTFjLAbg7xvWvOkIWGyedhdpGrygc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745443048; c=relaxed/simple;
	bh=U5ZhDPfpS+YKKIq8omJZ8lYB+4B7ZbQsmohNqr+ETkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cGHzu0vnzwanU8rL8znT4dA1QsyUYbYso6uIFVNCAgBVwWdLTa2trGezdttHMV//J1wQyVgiTTSS+TXMjtwC7SlwZUmRMKJ780eWF3QD8S3676/Zb6Xk3ifMIWgqTLQRF+lEHhC5RT6xMczVzEpbTpAA303/dX6m6CY8DKEM0jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBsvZ5hd; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBsvZ5hd"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d92585938aso949175ab.2
        for <patches@lists.linux.dev>; Wed, 23 Apr 2025 14:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1745443046; x=1746047846; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=chdVg3DD/9/cLpbZdSTropk2aaUqeVP24/sslKciaJE=;
        b=dBsvZ5hd0CES7VpKt/2X3M8Rpv6mX148ObBN0WZCjdc8vtJ3V62Xx/olw1tFQXAm63
         DnMKk2q9V890fpvw2FicWv/h8zILxnvrPjXyQXfR3w1hGs2a8VeBIjV2soFigwFTb7Ay
         yLzWjh8tZzuUoWHj0beGM6Y61n5e5a54lkFBc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745443046; x=1746047846;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=chdVg3DD/9/cLpbZdSTropk2aaUqeVP24/sslKciaJE=;
        b=AoijkCngLH+2NDhfh0GdFDu7IqmGi0UaOGcf2fmNup2gPj5pKBsnbc3jhJpkHoY5S0
         jNUcoOijrGQ4ZhNrN2m1XAbwUS8QHaT+iP5vZTYJ81u8Z5k6+v33qQop7Rg03inOiYgj
         POenJXvoq37Z2hNQxj3HbQpYAqwkqPQIqfgkaOas6XAapdwIWJSX53/M/OthHTHDuOI2
         Pb11+YX6y16QrVvsxeixgymJltlLF+kmD/gCkmuoRIyWd5Fma5l7P3TcrXTzD4WT2P4+
         j8X7VWZaZ4KHspM9yDLXbrtCHOYhyKMu6YtmGz/+XmkatR0+/0UsbXGYSzD6mT0YhibL
         HDAw==
X-Gm-Message-State: AOJu0Yw39s0BiuyvbrsnvFe1nPlxnO1pZl7Kj+3Fmcsi5m83GiX4zZXU
	14ENIcI3M4X/jYkWtUcJ7+hQWhJVxkFx5ya+OZ24UduPNbnfrl/IJUNmWtaw5aQ=
X-Gm-Gg: ASbGncvTVONt5KS1ia3o5DqWzrT+dBoAvc45+LFEH76ra9V8GZ4DUP+CFSNkR4TzKho
	2r/pwZTuKR2V8CIh/Y47z2Dj+QqvZIMaSO4NujDcTckRrGG1549ezR38ViDkMGtVObj6ybFL2mj
	3CUHOwoyw1Rb4h3EAG+EVtBg86MqPIWPogMr5Y/LpjtY86s9M5bqBTHlZgdQWhcT/KjlCZaguvj
	8vaSd46z2LumugHo7xv9xHqK4aPZqt2jlZW2LABfFWv0YpBgxL7SgizbHpdJXI6Tys6x0HDV0U5
	7X+le2CqMa8nsM1tiP33iAvlLkDPUXn5zYpdDl/GLi78X6baWF5RWQEZZPPbTQ==
X-Google-Smtp-Source: AGHT+IHCn2m04+D1m+Vyv0CL9LnnBZoMW4EoCPPLnYGeV85B+zuoNK55CnRyXvy7a+pwH0vkMd410Q==
X-Received: by 2002:a05:6e02:1564:b0:3cf:bc71:94f5 with SMTP id e9e14a558f8ab-3d93041dbdbmr1891995ab.22.1745443046107;
        Wed, 23 Apr 2025 14:17:26 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d9275bceeasm5249825ab.37.2025.04.23.14.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 14:17:25 -0700 (PDT)
Message-ID: <6c7b5a49-2890-4db9-afab-5af337207916@linuxfoundation.org>
Date: Wed, 23 Apr 2025 15:17:24 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/291] 6.1.135-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/25 08:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.135 release.
> There are 291 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.135-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
