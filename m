Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84429439F89
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 17:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075215; cv=none; b=oqcMziCPb7JhhIKvfjCYyLVtnDMl3/5mwIPabOIBCIxvcrpdoP0zgQN3Ssq4QvQKkLVunYyJPd9ChIVtPAOfNrJ2NyYk8hq3OTOmRtVLRsOBUM8uNnbbpFFWh4Yii7zBpOsIryqcEpFBSyF8rf4M4MUZwcMTGdiXO3vI5RhqL6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075215; c=relaxed/simple;
	bh=J4UYv6fAQ4yuFzibg1XU5+BNJKmYJenjsold2tAx7Mk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HaFT8iqskOza4gv/wXZgtBDIRZzw1PVYttEpF6Gb3fx9nZhrqJDYg7MFXSn1PcUq4E6ZfGD0j0trf7RVOJk7/V5j6HbJotDsjrCPga36Tes93QmZ8LyZp4BttPyv4777UCRhEGbtFdz3VgER0Fwy6XHItgrdvTnkDl4Mic1ji5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARfRBtKo; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARfRBtKo"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7ee4399c423so88774a34.0
        for <patches@lists.linux.dev>; Tue, 18 Aug 2026 10:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787075212; x=1787680012; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IW38vascXUwMCh+f3xoc83fPD2z4l5Xb377VD6uPgco=;
        b=ARfRBtKorFLF2Sq+QqvVvwCeQBX+J42caDQNuUmHTVfbNhDsRXUWAKtvegVzPDmbFc
         fl7wSCbHSDhq8667u1UXMbd6BR9vs5BDmbs6swc2a56OCHQyLbhR3cw+HOIrDSfvJqow
         6Yx9828SWmjj0TYDr5GOw/45WllUW43zpbw0Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075212; x=1787680012;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IW38vascXUwMCh+f3xoc83fPD2z4l5Xb377VD6uPgco=;
        b=pN5feYRde2BnvzxEGEVNniwMKa2yjIRxWUCuV0PBCz4O8auf8dLA0qIgL39n+u0jJJ
         DfuS4FH8RyRXrb+B8+XHWIvCnOkHkrVU45+5i+7tg4ZLy8houI8SvasvHMV5i6IIQpjt
         4J2wqzS9WQelAI2LCsEpUzCn6xKpo13WSaWxBJGt1ALSLdzqHnqYIqQ1UU0ssyj+icsa
         SdzAz5Kt4KydY+O/ikc44NUR7PIp8bMsferTBS1D5ZTYzLdBNcYnKYKfR3BpUws1Cc9Z
         PX283U9y+gFAQ+GppJGfGzLz/ZyZMv3EutRkU3rrcVLKHoes7hGHsUGnmZfXCWX6+Bz1
         e5DA==
X-Gm-Message-State: AOJu0YzyHDPteoXC+e3Ya98JxmCDwmqEqKe1YxwQVhMO3QbMi6oPby7p
	OZJLu7pXhE2j9E9to4JZQLkMwC29aznEz2Pk/UoDJiuAd7J0uUPdp6Q4rsAKVLHBA4w=
X-Gm-Gg: AR+sD13gNNyP4VCkkXbgPy7cAV92Hu427mv9xjKJ2L2CykSvBOwnw5AEU/W1Z4eRpoh
	Ii+GCIKrXmGJSI+0zNH8JyblDjlN3iFUfKwG/ZSykYOiacMSNsJXomgR5NVZGKg26WVcgGHoxjh
	NXd5OrQp/u0s/k2SnK+CLeAJPNHdbnCuvUi/eqUQnk9BwVDrCaHI6bwhhwCHUOcCHkUBQoWV/Xw
	y2ygmAL/Apjje9hUxQuOHkRpKuOuAcMHSckZan9k7WePiUeq/sEJEjjRNHfALF3k4TYgLzLfBF1
	NEmkEylxZpRURjreNGi6Gvb+IxKYHeFa1gqcUJTezQyeXIpWwVuN58ytc/gMn09PovR+NIY4WJU
	nM0kvtNE5gK80rBAELW9gGmz4MFCMMifNyH5ns/jr/1gCKMQxXVKi/HvYmffwPPK4QoMK9ODLia
	jpPw3nyBZvh23yGgU/aG7QQJNxBoSWITfoRYJPhf4Qj9A7BqOXH8GPEQzcw87LoE+nu8MwEg==
X-Received: by 2002:a05:6830:82f6:b0:7d7:ef0a:1ce5 with SMTP id 46e09a7af769-7f3de631a8dmr32652444a34.9.1787075212385;
        Tue, 18 Aug 2026 10:46:52 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f41c0f6d05sm4802639a34.24.2026.08.18.10.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:46:51 -0700 (PDT)
Message-ID: <cd49274c-1bae-45a7-b187-7831abc52849@linuxfoundation.org>
Date: Tue, 18 Aug 2026 11:46:46 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/181] 6.12.104-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 07:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.104 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.104-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
