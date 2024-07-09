Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1E37E765
	for <patches@lists.linux.dev>; Tue,  9 Jul 2024 23:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720567390; cv=none; b=mMf/1Sa2KyTCi7XGkW9SAcf6z5sDTpyw1jjnOxzsOm1N+uGy9O2zPoFtPF0yqwYdJ6bpnRoBrRD7YaU7VXQQi0XiXkCmJgnKLPytirgktZaG5acQF91CUpVSg8Mha18435OzreWF8aSMpWvmZpTEMpq5tS4u06aoOhqxvSXdSIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720567390; c=relaxed/simple;
	bh=lzNEjgXu4r8j+W7K5icyhFYr8ozl/BnL1z4/q7wYvlA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eDhvNDse0V7sBpWfTHuTg9AUJdIq3FhM/zSgeNGC3Vgvs8yT24uEyeGTILKi+/8tfjGTJNaJqTi9bDrL2HTdoAdaHM63ci2JVtyszbA6lgUUYiT1HgZgz0osumgvPM27NMwW6TWrUw/sLwgMbYrrLDX0cxOw4BWP3tvEnPRdit8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPqMUK6V; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPqMUK6V"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7f70a7470d3so12751339f.0
        for <patches@lists.linux.dev>; Tue, 09 Jul 2024 16:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1720567387; x=1721172187; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MZ+w/XkfdHXX4WsNcOeYmZqVtCBCwZdWSjv1UC59168=;
        b=aPqMUK6Vv5aXSK64rZwHKD2E6yf+oaN32aMy1uEx4tJoIF89vJqyIKSwiQTO9J55VI
         nJjwdBVZ999ZqvBd29BnBq4Z6ck8ESqWJW0yKiCj81U3IngPvRfK/6b5bwv9ZIan+ohu
         KpiyKlT6/+5cPRwLGBJMslC+5Wgp+0QojN1iY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720567387; x=1721172187;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MZ+w/XkfdHXX4WsNcOeYmZqVtCBCwZdWSjv1UC59168=;
        b=OFqoVfD4njTaXikL1So3pqHrmDjQ5HaTkjpQqEutOaJtqn435kp+w5eYBSY/MsdlS5
         393Fd6ptiUFLcM8ONmi7m4EpTOHWc+RXy1ILy38oa9CLzfLlUI3AFoivt15Hugaq7aBm
         +He0ARFLyDa8lve1YiITed0uwNX7F7QAmMDAifvJUMUux0pK2FCUG7JKn9bQQpsm9Bsc
         8z9Po9FYfFGpCKHmpirjb5/P0/ycPACTpZXKwi5ETQGut4vvhgoxDyQBpz9EKFKVl6Hw
         L7dqZb7voCaS8T3uUj78UHg/BzZ1Z3wjK9ooSXo7tLgN19H5+GydWfG6FbJ+IIIoS5Dt
         W8sA==
X-Gm-Message-State: AOJu0Yxt24G++24zMtes+6KulacbtjratE+/RFfsBAdwWD15m3tpxdUP
	UcBj5i8AYCT+J1VI3MmUaHTmz/54mVSkq2a7/EZDpUP5Cvvn7QGYskaEvdk8jrc=
X-Google-Smtp-Source: AGHT+IGfwyA9Frqr4q+phODDSJdDL5G1s9zHOOePe2O2BpV1L9xAItxzzKIkxSk//h0ACflnrrSGIQ==
X-Received: by 2002:a05:6602:20d3:b0:803:f97f:59df with SMTP id ca18e2360f4ac-803f97f5a89mr109895839f.0.1720567387053;
        Tue, 09 Jul 2024 16:23:07 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7ffed680fa4sm79331239f.46.2024.07.09.16.23.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 16:23:05 -0700 (PDT)
Message-ID: <a2178b3a-955b-4689-8b99-6f931ec2fcf1@linuxfoundation.org>
Date: Tue, 9 Jul 2024 17:23:03 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/139] 6.6.39-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/24 05:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.39 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.39-rc1.gz
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
