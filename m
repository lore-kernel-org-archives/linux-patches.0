Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B251381C7
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 15:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721834155; cv=none; b=Mvs75TMChWTDxEw3FgMJVkDnQSwpcYU8ki6BObVoCv3awy/t0Yka/KIVRAHkdvNqTN4GlC1TiqqH/m0DvOHTH8hOS7l+PjSQDu6BvFtsk6FA9NKvbummrQyk6KEdGxFT0di3Ohg2g0PiCQbvq9n0Ke6vIud7VxS9P0SHL7kUZ8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721834155; c=relaxed/simple;
	bh=lGgGD/+IXoF0KJnjpTmdRSHZSZlZGVyJTw4PkaUX1kE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TtRNOWz/i01ZSedRNUU57m+QAH1mK6IocMr6vYvwRrY3f1IcRAjJUjNl8XbReV1kUxfe9D1B4JThNRLzFVZqimad15AFHvFG0ojs3Tb4QVVWJ4mKIT05yZw/evD7sNddyL8HE6Nyg3nGalZl2+w5DBx5zRk651Lu3cSHJGdA7Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JB/piKZK; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JB/piKZK"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-805fc096a34so31623639f.3
        for <patches@lists.linux.dev>; Wed, 24 Jul 2024 08:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1721834153; x=1722438953; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iJp2TIbNZjY641ZWwyv7gFm6PT+jwbh0kxK3G/HVx84=;
        b=JB/piKZKJBvYg9LxsOgN/K5+Zn5TH9x/Moc0djbvFz5kWbGDKheF4zay+q8zTyMnjl
         ZVZKSnebYnHTAO93OlWHf27Lp/BgGma8BAtWJ3S8MEUNuDc/InlXCTqjuMPvd7FlVm3G
         PFwpOVpLyrLawSiesiXhCWqpTYDFurHfZGnag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721834153; x=1722438953;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iJp2TIbNZjY641ZWwyv7gFm6PT+jwbh0kxK3G/HVx84=;
        b=efoA5F8tGbObp4apZeagbWQi/EVtogPX96SxqNCXu9nvjBRa8aO0qfabICcQM9L89V
         7eTqPCKUfBMP7m1uZdivFwugg3stik+TzE7+yc2J4DJ4cVxmNXMlQTF2Igqk6lKlBtVw
         OIX3ik2ejHidRth2UmY7a+/CHtXbyjLJQfGD5tKenwQwMj9yXuBVQiMbxxSzPxxqofCV
         9cRVi/gtrbs5423XzTmjLxS5c9RnCvavxGU+JL6BS6Lh45xbQE1DRoODNz+66wlO40qw
         2T/cQtTfNWMx3mpk2eVl9+te6ctnukl28y6UuqzpU9lT6NuSjmXOeYeLBPf0mObVlqdd
         epgg==
X-Gm-Message-State: AOJu0YygyelIrTYwZPXWeqD9ZlgaxOsz1XpvrR6EwPWnonqZx2mPwZAx
	uKUpLBlPA3nHAMbSzYtbs7UZ7fLuNhUa8+wS7QP9scDW+6q6TVym86HVOEpBg+o=
X-Google-Smtp-Source: AGHT+IGRiqaTdECn60Wzc2HMFdnCkr3xP7fGAB/QUdwhu4VgXpKSeXIyj56FGa+6ASLRBRNOfcJT4w==
X-Received: by 2002:a5d:9f5a:0:b0:803:f97f:59e1 with SMTP id ca18e2360f4ac-81f7bc78dfemr14099939f.0.1721834153091;
        Wed, 24 Jul 2024 08:15:53 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c28c93321asm434572173.87.2024.07.24.08.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jul 2024 08:15:52 -0700 (PDT)
Message-ID: <f9c063a0-f575-49ab-a5b4-f3b32a6cb486@linuxfoundation.org>
Date: Wed, 24 Jul 2024 09:15:51 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 000/163] 6.9.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/24 12:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.11 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jul 2024 18:01:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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
