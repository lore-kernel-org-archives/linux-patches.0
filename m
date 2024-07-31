Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7046417579
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 20:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722457505; cv=none; b=scC7CPKwbF0Y6Dd6n2Ms6gAfxFtey6ajeydXaDWHY21ZiNL62dJsP58ZQ2ESPWfPmH6RfaY+4Qx4R8KO01IUkU66ajkzObVqfWn8MQZI5TdJTrCtpgZfgbfcbVt5y6AI/J3d5rAhrm8GmBjqt4do31G8e9G8NTY/WOWFyLrDE5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722457505; c=relaxed/simple;
	bh=5iljddl6Dy1+iqapnBBDqeHgVvb6+kC9EnooWBoaZ+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U3giq8sqjiLyJs24BUUctg7jyIA6njcFixBmFOoMaZ/gceTD4ecTRgInNgrjCoFfjib8kV8/yhuT9jMtVLWxojbc22vk7dEdHznaLevvyj4kCG2SytZHBA2eh+if/LdkiuMoD71xdwA69QiaRFkxJomMDoZPF8/IrGqM+W/B7Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6PZUjS8; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6PZUjS8"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-81f8add99b6so29495339f.2
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 13:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1722457502; x=1723062302; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qNpsP02VSjKsYtcASUUA6qMfypdvykuyxCt7zWGiFLk=;
        b=b6PZUjS8cDjb+Udss9GOP+fWHd4n7crcXsurbWAdD6z0AW9SktfAxjQyxbXdOyPxzh
         2G0oBDBdoi+puN3jRdafLrGNoNsLHlB2YI5LfksPzRhPFFYkJt20OMLRocAmo8OPHzjF
         5oNw6GcJdRIeVqudBzgtDfckSCB4FA98Gehp4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722457502; x=1723062302;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qNpsP02VSjKsYtcASUUA6qMfypdvykuyxCt7zWGiFLk=;
        b=vQecBnI1XsgQmCaFepuHaK16HmeUpbDwPauKCkCw7cfuiDIuFpz4UkHjeiYiVn01qE
         SM/xeglw8F13pc4OnuZPS2RPD9Czr0ZSxkjpKNgRicoWPa2qIL3VwBrqHnbcUQka2l1h
         7hhvvuc5xu5r9e0XrZ+ZUvvzonQ9/QAsRZfLe5SekQcKOkeZMgECWBbxphCLnIsMqr+h
         Btjsj4vChqfqmYyOeUkFA9Aau4toKGU7jFmaxpT/Pvj1OCORwu0EcdkgR2npW2zy0YU9
         9MQjyir6EekVjNRhmFVH5BoElL6/rRJuEuVSco98K1EQjZklhyJDogjfAxcFDt+et3cv
         wfvw==
X-Gm-Message-State: AOJu0YzJuINTlVDHdITS3GOCTeJTesK3N4Btqlfk5VUPgEXJkn8voJ3q
	dlkdc0xkjDgpoYlTSpICYLGvESyVAsTS3nPG2n3uS+nDGMDwZnUv2S3fMMZHAJM=
X-Google-Smtp-Source: AGHT+IHizPAHD4S5ZiqFk080B6OLpCMsmkSB9xS6xlQxHULKrSv9bR+UjdoWxv8uUQ1IXUjy0JVfbQ==
X-Received: by 2002:a6b:4f0a:0:b0:81f:8295:fec5 with SMTP id ca18e2360f4ac-81fcc1c1b19mr28919539f.1.1722457502455;
        Wed, 31 Jul 2024 13:25:02 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c29fbd9a7asm3352896173.96.2024.07.31.13.25.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 13:25:02 -0700 (PDT)
Message-ID: <d9fea67f-4871-4b26-8a69-f9a8fca8fb13@linuxfoundation.org>
Date: Wed, 31 Jul 2024 14:25:01 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240731095022.970699670@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240731095022.970699670@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/31/24 04:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Aug 2024 09:47:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.3-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
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
