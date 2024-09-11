Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE7A1B3F3F
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 17:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726075709; cv=none; b=BeBF0PiMJKyyL9MUoTlm8w8HtYMPM8x42tkpGznYZdICiOfTsEkLKUBwuXz0LQJLbqHLOtUIbAQ6FzFioQOThbEtIf+Fk6ezX6Mmk4Nv3OY6CciK7PBF5GOI8/2HPnRDeUyDF+GBzTeC8KAs4VWwCKeC09fEgIes3N3OoGAyoRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726075709; c=relaxed/simple;
	bh=I2lSwbBoSxfLWPHBpEDCm+PIm25NtmqYiCU6qJVvrVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u4MikNLwf2D8nv3UN23N9vzHoCrqQakWP7IjIw7oQASVO1p6fs7Tep18y++zD6HWfVR/b+lOn974oT+tIFTFdKN2k8hE9sv1F1lmmCwC7na6S33j4RuYPgLIWx75QUT+N3wLjV1Y+9AuNFuWHTYxAZYGjXPb+boRybb2cXKXlTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCtkQ1ga; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCtkQ1ga"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-82aa3f65864so1679639f.2
        for <patches@lists.linux.dev>; Wed, 11 Sep 2024 10:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1726075707; x=1726680507; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U9xFRDO32s5hrf0vuo1g4X5zViAPdgBVeN7fh3GcQd0=;
        b=JCtkQ1gaHlMh5pBXe9lFK6BMMHbZKhnmmYOMpxAvNWuEH+ldYMZxrmwmJX414D2oyT
         JaNp9rbMXM1a61J5r9lM8QGnteYFLwzzMBlHddJ/6Iri2OxGUZAOZcJXlmP8BtHtflmc
         abnV+a5SutQa71fL2JLa5ROaBj2NAi8sJgD1c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726075707; x=1726680507;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U9xFRDO32s5hrf0vuo1g4X5zViAPdgBVeN7fh3GcQd0=;
        b=W70UXsX0QEE7sFMuRORuz+OZAqU4ZhLWIGu7QeYqozRoWyNLOJBmTg3wJqOSA31NyI
         B/Vk/bzAEuP6+A0arzCyT0oErFWeLVzfLAKagXLFwW3EXt+dphrIL1yEZp0lowvKuydI
         H+H2lz0fma7k5DzbJlcBToYAKDpq3KvysZ7IY8yQYBXjZ3TH2Ho/ldKhGGhXfNZih0xK
         EJO4nruMNdJ3pqt2A7xJhfjc3GbAGAci8oyhrUlTKTz2lRFH/ue+fZi/0Y9bXblhECKU
         7yZhe2XQ1tYnLgu6TSGD8EqHDTg+CEGVqROP4ZxuqbOgaAmSfLxGAJ+afGgAM3Ylv+4Z
         wk4w==
X-Gm-Message-State: AOJu0Yxn7SZLluZ3F2L758IiHsdo4pw3tM8So//RPIafODxo2ZKR34eK
	mHMLuAkL3BKQ4f0JI4y4++xRxaVPV6+bAwllPFvA4SdN1ABY5mg96kKXp6TaPi4=
X-Google-Smtp-Source: AGHT+IEAyEGZhgRzi2A13WFyJTv9dc9wjNfkWHIOb+ncIxw/rl9qf+hd2RNXS1chcDosl0OSXhY3Jw==
X-Received: by 2002:a05:6602:13c7:b0:82c:d67d:aa91 with SMTP id ca18e2360f4ac-82d1f8a7fa9mr43556839f.1.1726075707421;
        Wed, 11 Sep 2024 10:28:27 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d35f43445esm96620173.11.2024.09.11.10.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 10:28:27 -0700 (PDT)
Message-ID: <7ca4ccea-9bbe-456d-b7f7-692df98c6c73@linuxfoundation.org>
Date: Wed, 11 Sep 2024 11:28:26 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/95] 4.19.322-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240910094253.246228054@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240910094253.246228054@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 03:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.322 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:42:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.322-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
