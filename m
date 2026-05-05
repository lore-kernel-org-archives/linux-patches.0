Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D7B48AE03
	for <patches@lists.linux.dev>; Tue,  5 May 2026 15:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777996512; cv=none; b=kFPG2ETqetNUtpOxPDBPdzTOXZyqrq8z+xPjSnm+pOga62+o8qKzJ73UH5HETSQex6d3hRuWWrdhCU8i6B+K0smxPG43AMY7UgnNkMuf5r6w2ZVwMjUapTIKHs2/L0Ib4SWB+5oYJtmXT5I6St2gvAsNJO6NY+C9bpI7Ivaa/Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777996512; c=relaxed/simple;
	bh=ztb0aECqkdj3lXdK3o+ezqOaq8qKXy8MXKKbZTgoFF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=svgnc6RKRicT7s0GsOeshSGWWftCOlFcD46ahThxmb8gZBdAs8KgD/R4sm0LLSsBxeKXh4X5sbMMZJwj8w+Hdr16N1P8FsuDsNkU3FY/9mlb3DYbiPXFC9uqd8DWoXoyjtCiP7GSovRufCOi9xU7Qnqef0aSO2YEyhC1zY1xEz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiQSezpY; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiQSezpY"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7dcd689829eso4893187a34.3
        for <patches@lists.linux.dev>; Tue, 05 May 2026 08:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1777996509; x=1778601309; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oJrrVXWHd1p8zVo0A7/cFUcaF3X+H1nPtvANH+xBNX4=;
        b=NiQSezpYp0corFwG5pMcGNGSouCrggRxdAioXgCdux3bdVGfRcbghXKxp+kgGj1JyX
         o2x8tp9UFyYdpMDZvOSZCXwthEVhljxR425G0NQdDY/iQq53O+7ypFu7y1QpeSBg2qA8
         6zFJxFQtB5yiojUuleH8IANLvoICsGfw89zoE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777996509; x=1778601309;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oJrrVXWHd1p8zVo0A7/cFUcaF3X+H1nPtvANH+xBNX4=;
        b=NNAlTfLgT0lIIcZqXQv6FEQSQVT2nE5igwaQ5O9/9wkSbHivMpHI0WvaZeTaEaaaFI
         0QbvyiwVxBgKnnf6zINGxkmLZEbI3upDaOE1MF8xw6MNS26jQgEGPNj89jtPBxzDSNHJ
         t1OdaWtMjMl0AQOzpLDNQqM7dQ0oVQypy02UR0eRW8oC6f17k4NHM5Tp8hzVfj/zUTS4
         i7s8JjbxNQI4G3TKYmnmIhCMLPJ0i3Z8/II3/6jCitm2m4GEbpaltjodDn/1TxtDGlBn
         hjuD4DlwPNolFAGshf6I/BctwKoxQXC3HjNk/7cFQP12+NRSeNYzz0/GmotCIVh8Unvl
         t6PA==
X-Gm-Message-State: AOJu0YxMM885VuN5LUpxKfiHTuXySyvgSxSElCVJxrCDNoptj3Ujr/zk
	0M2Cb83YRYW5G6fXwohg7s/MvFMNRWC6tkXw2NShzmrfYBZJ8LCJstqFjlcBAwgHF4k=
X-Gm-Gg: AeBDieuc5WtskaFMUyKLaO0mB6rUdyjyduC8vL2hCn3DZpSJshNJGvVV2jx4EBkwYXd
	j6TOrkuGFQaGCnjwLNz1ZAXzJGubDqdJz3x20yXwO2jsyVeGku2XS+QdItxLC4Ka2ju4DpWOI/q
	XtcCEkLHhUWwlY2Snjn2kHxir156YlE6lQxD++bdQNU/lpMZHXR0F/Jjrs21S/AY2e98QXVxaoG
	N86cduaYA+wxUgaWxfVwLfD4DDjX+vqU6H4Qty+xUrOA4CCUhk8UoIpLrg5zpAfGxWA0CamoIg2
	IKiaEgqDOY6NKQTOreepH6+b8NS5zKBbWuzj/toJ4/V++1vVBoX0pBy60lvWYtF9IshP90ZWjTO
	aaOhXt3mOyN5a6Tj0zbdxvU8tGm0EIJE7aGIoJlr0pEK6iN4Ba8LdtLiZ6TNarEy0AkE+mPwvBP
	I/+I4uIBM8abr3JvsQl4v8CJsLVJjfDfOo0Cuq6ObBDg==
X-Received: by 2002:a05:6830:3881:b0:7dc:c926:4f87 with SMTP id 46e09a7af769-7dee1395cafmr8505249a34.16.1777996509452;
        Tue, 05 May 2026 08:55:09 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7decadc2906sm10257665a34.23.2026.05.05.08.55.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:55:08 -0700 (PDT)
Message-ID: <24d25230-c180-452e-a7ee-2ec36df3a522@linuxfoundation.org>
Date: Tue, 5 May 2026 09:55:07 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/215] 6.12.86-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/26 07:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.86 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 May 2026 13:50:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.86-rc1.gz
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
