Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDCB19F
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 00:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712708687; cv=none; b=kDs8vNwxEFKiMnPlnXg4LerD43c74Oy1KbRHEfAOdatzVwTbRGucJ1oZdj1j1GRL9oAS1sNCxi4mjQQJEDDxA10pK8rV7N1BMMLLhyZC9N/C5Lgcb6Td4MXBaYOwiWWv+sOGqLCTLhZ1m/vq5o+QVwN2ns4gxe7n3Lbmm/N6e9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712708687; c=relaxed/simple;
	bh=GIYL7/nThlCUdA4CAU9q44dwx4jH78PDGJqI3ovNgOo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C7/GIfDV/1vyXm4WErWFQdYFblC8HA7+4rqGERfjHO4LN4R6teXtMKqPEs7cxbFc+zeqZnQqzxbvn0st8IavC7D7mnYzmUufZKSDfD0+KMJE+Dwv7nfpXPqnPkZIxQGXVn4uf6lHt9Z7+bsshZNsoJvdiEF7TszaQDJPdu8wA6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hxw4h//b; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hxw4h//b"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7d0772bb5ffso142330439f.0
        for <patches@lists.linux.dev>; Tue, 09 Apr 2024 17:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1712708685; x=1713313485; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ES6QomRFvLrFDB39gb2GX3zkfNFij1oZGJPnUaL3yX8=;
        b=Hxw4h//boLijKWdlYGqbvZ9oZBPku9RJS6xdltcLYJqHvYPYUXyrrxTyrOD8G9QSXJ
         /PPSbt2z1repDmTq31UZcWONRz6y7OxynlQKNMHeaWsII0oxIcTGAv1HXbKyosFhMfPH
         f6S+CyVOewpBUV+Lekq6nub3AkhmRly2oi6t8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712708685; x=1713313485;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ES6QomRFvLrFDB39gb2GX3zkfNFij1oZGJPnUaL3yX8=;
        b=ii7Ix8ebs+MxyLiQxe2qkMgBIYqnHFbiXkTDUqa/Mg7maB7KlyZe2R9DB2Dy3D/PmA
         aZvsTySuFaokYSiiYkTAleAqC1DkSlXv8Tngx+RGy2clvJhX6z7k6D0Xc6il8kmBC+7f
         RHoEq03PEdzzKEN1QsY4TgwHXKUg5JQTWiYxSYqubOcjdG3CConSjwv8SGeqCeI2on9X
         J/JWv/lhYK5+w6cLZQ2rxPIv6Cam7HjlkdaUx/J8UUzY8eB+2a96Yw8bDJE1AsaS0L2W
         ciN861ieDQp9hr/rAk/pQWfSrdBOTYGioOHxMYduWMDOpzf7lLyrHSE9qsEjXn4UjkGi
         S4zQ==
X-Gm-Message-State: AOJu0YzYxvucmdsKe0ljIA/dX/h4I+s14VCqcJGOHG9ThBoGPPi2Nyoj
	7zWNGvePhmJZiFgOLbZf3QduM9V45lxJ0RbJnLQu6MOMqRJXd3o0k/JuFoMENI0=
X-Google-Smtp-Source: AGHT+IHAftx4RfZVpvtH7wznKTottslQUrkWU/Fb6KD2yX1QroQOCt6CIVbNLlH0WAmaBk1thLR4Tw==
X-Received: by 2002:a5d:9ec1:0:b0:7d5:ddc8:504d with SMTP id a1-20020a5d9ec1000000b007d5ddc8504dmr1441180ioe.0.1712708684989;
        Tue, 09 Apr 2024 17:24:44 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id el6-20020a0566384d8600b0047f100b70e1sm3630203jab.105.2024.04.09.17.24.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 17:24:44 -0700 (PDT)
Message-ID: <c1b7885b-8f21-4b8c-87ac-429799551723@linuxfoundation.org>
Date: Tue, 9 Apr 2024 18:24:43 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/252] 6.6.26-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/24 06:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.26 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Apr 2024 12:52:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.26-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
