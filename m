Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854A42222BD
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716451; cv=none; b=MOsiOr6+F5OdTJITHn0yVjW1QWSukUtJc2t2hGZThMmzh9hXB5pG3z2U7b54ehPoSnX2nLVn3q7U2hgPuxRPho89HFFWBKDr9RVl4z6LeDFREIVygLh0ciT1gWn19jZm6ICadxrH73FbmaipywR3gkiet3EMq2COUf5g9M20Wig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716451; c=relaxed/simple;
	bh=bE/GlSLGGPFXT36aFU4gchBsyjqq28AacvXawkAxJyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kP/+lk5OhI9AjZ/wuGlOmUhTECsg2tkHc3kDKY8UIVjC2uNbumh95MfsVXeX+gdrX4TlLPQ1GDhpa5Ng9XI8rDBbBv2mK0i9TLJcrCJBvdm2VicJtQeTaglbDQdsQRY+R26f3uMzbAzZ0Mq0CBm4LHdtJE4ngcgT6/8cc0WFDtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXDFgAKg; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXDFgAKg"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d96836c1bcso3447215ab.3
        for <patches@lists.linux.dev>; Thu, 08 May 2025 08:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1746716448; x=1747321248; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CaDQuSmU6yJ5IUs4m+YlbKlu2TNPWtfrQAZlJGyILvk=;
        b=eXDFgAKgqZ5i3Ix3ZTd1GX7XR+hNszj+u0lgGSaIUTNpY/m0RukLvKoZDIw5HZP6oS
         zEGG9ymRkWLO1Y6nZN0u4n2QBdsJmejqNdQltXbJ/UZwJGvj42UtysAz+NWQT1hCJxHj
         Si9A593443Nr+1uU0fn3QVXEUxX6pMimZMZ3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746716448; x=1747321248;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CaDQuSmU6yJ5IUs4m+YlbKlu2TNPWtfrQAZlJGyILvk=;
        b=GkArFIQN4+2VEMFFiRmflTS9XlKEr7igJgtUJyo93O9Q5jRuJhmbiqQCauR3O+qa/4
         kEZnUfu4qx8r2cOsxJZ8vCWxydzqANz3sVPXDM7jDw194dzlw6hWeOnNxeKqQiFLuqst
         8n2NbUSjlZv+Wc+KGHLn+1QbilnaRen/RPP7ktQeU5R+2kCBJQSBH853UFE1d9XbH3Qd
         bdu8YUDROL2Hw9UDVtcNozltqW01GLm3U0+dBsYRwH3tknc3j21y2qY/K3CoZkOfpl1f
         F5GDudPWsfGQv1gxGkxZuhdStaZo/1sEFreB4Hj458I7uStZTvGa0mNL89xB2c/9Fk7O
         fLMg==
X-Gm-Message-State: AOJu0Yzp0WxhPz++z4foNKoynaE0grrwE2X8QkN3ae2KJDGgK2c/Sqj3
	a7aOfV4ZOVwiFblb4JSvSERTv1vjRzh2q0734YBtWAF4GeuZve6vYP6KU5c3R74=
X-Gm-Gg: ASbGncuTku7uiJexELU6AbgB03i0ZVR+k4UeyLcta5hYJskIt8bh4IjzHyHxwx9NPf5
	jGNInxcBto4gREPosurgarmdVpHvXaOc05QGFD/bbr1pP6yUmlnZNaWJkrDQCgQykme7mmiS89Q
	V5DfvCYk0XBTe6smAgVWHlLYOHn5Xrdg5UB+fGdVr70P/eiFDyV6+xvFw3kLokVn0MUGv7Tql33
	BBurPx61Wq5zrsgeN0dgX7yxsLMou9kGq6jBTvLZ+SHqurLbM6IaZbV5dzURZjUsUwHl+AUrpZh
	hgcOHg8xg5zt6nfuwXASj3eCfvtXMQSwbExOum/3Ou+l0/DuUEw=
X-Google-Smtp-Source: AGHT+IE/XgtNYN0EtpMRL67XznMJq44ZZbXSNS4qg3wRIrU5gb+loCCKNTbLb3TOZ1VVWtQF37EIyg==
X-Received: by 2002:a05:6e02:3c87:b0:3d8:1a87:89ce with SMTP id e9e14a558f8ab-3da7854d5b7mr52089525ab.3.1746716444166;
        Thu, 08 May 2025 08:00:44 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3da721e7e92sm11526345ab.60.2025.05.08.08.00.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 08:00:43 -0700 (PDT)
Message-ID: <2f15967d-0bc8-4f91-9924-6312caa63036@linuxfoundation.org>
Date: Thu, 8 May 2025 09:00:42 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/97] 6.1.138-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/25 12:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.138 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.138-rc1.gz
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
