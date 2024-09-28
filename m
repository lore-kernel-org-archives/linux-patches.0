Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEF2210FF
	for <patches@lists.linux.dev>; Sat, 28 Sep 2024 17:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727543628; cv=none; b=SOmdSRRuUb+G6V/2wPMetpEoa/+Y0wtyMqQwVmjwje39RzYxxdFwZfvHDOS+nygenD/fte3sTnGo0Trdnt3ry7lqmzV9RFFKRDEwWsFQHFXY3BLZYnDb9t5WJRGyNnD7R34Ctr6D0UWm6gf9OwXeW7IIYUqWJ3OzXO1NLR//riM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727543628; c=relaxed/simple;
	bh=WIQH7YpKqbnkP4VdBnh61v4Wxod55IsldJm9tOtb6cA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bziLAONmZNzmGvypWkyMEhHC5UlFlQ2xv75Q5qzWl/s5HTuO0w+Ac3dtFB/gFbyJU1wAhlVdCQ3JG4d36o5ercTkEmvXfJRuRbtYYOtqzkG7JFG4L6FpAzZi+ilJJxvEih57JNJoDohGFnKYIa5JPjKF/0P41ATA5QtRceGT7Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKZsE9jJ; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKZsE9jJ"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-82aac438539so157342439f.1
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 10:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1727543625; x=1728148425; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5iMutNFUHSQThjfKn15tCVspMXY8vAnhYmH8RW2rYcs=;
        b=EKZsE9jJxpevrbsI4zf/5vcscoTVud6GIS1seb9X8rzMyYAvV1oyHycgHS1VUo2/MC
         fK1uWtDlT4p9IrqG/k6amvadhaQZJ8u5piE5TPePDHbqNxGb01ZbK4DqDxI0fqdBfJY0
         0rpMgnEi3gNyBLANO79PKp+Z8TFNynxUz2HzU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727543625; x=1728148425;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5iMutNFUHSQThjfKn15tCVspMXY8vAnhYmH8RW2rYcs=;
        b=JuNUE/eguKTxtqdtJaBo5ff7J9yKZ0apswrIrnLnr+wtpIM/jVd4w6Gu3brhcK/dDn
         wAH0YN6Xpmt0h3KtQd6g696EV1OGB798M1rwuiU4b+t7pJmy/cb2HfWrl6zulXHa+ULL
         xed7RCOsVtkJHnlDj9moithuiEdD+23eOftwZIhMoQRZ63I7DWJYuOn8ljWseJz2Q4PQ
         eLJQgcijtouCBNekdEkDIbWCIv5mRS9b/siawPZuO49oQBuxV5jQPuJjE/oTEE97X8a6
         r2Av4G2rXkHs7Bgbmqj1kOhGp4gG3aI83x9abiHE7Mxmr1/dngOKLKsCPxZuWdKumJeN
         2+Zw==
X-Gm-Message-State: AOJu0YyOf308o/ccssQPe15R4bEfYG4EgiEo4RtBpkwC71X+ZmDCGENB
	41cPdedKYvIjeCIqUV455xjfFsIypxO7+3eGA0Co4GArPFEK6HDlDmoA8zA4H08=
X-Google-Smtp-Source: AGHT+IF3yhF7j9IwDBNWhxbVESzMplB1z5HLILKgeANdKoD+YzXDfSJbOVY2WnSlkPZguF2UPU2Rmg==
X-Received: by 2002:a05:6602:6087:b0:82c:f30d:fc72 with SMTP id ca18e2360f4ac-834931b0142mr528932839f.2.1727543625268;
        Sat, 28 Sep 2024 10:13:45 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-834936b4e97sm126980139f.6.2024.09.28.10.13.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Sep 2024 10:13:44 -0700 (PDT)
Message-ID: <b13b2120-bde8-41df-8299-37fbaa9bbba3@linuxfoundation.org>
Date: Sat, 28 Sep 2024 11:13:42 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/73] 6.1.112-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/27/24 06:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.112 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.112-rc1.gz
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

