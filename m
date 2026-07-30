Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF79E3CCFC3
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 21:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785446438; cv=none; b=a4GvP5roevYW9ulQjrLxzAjKXjUrp+g4HbjRd2Zeig8qif2HtDVHUeFQGXhlOUsmo4kawkS6V/mHVbCGhieTfILGyxmyIrT4WHUHS0aGUvdhjywz2ggJUhb0Ew+l0r+wMU3TShFdL4wEnKVinDSNrWtSEFxKxyvqzw4P1Aoyy0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785446438; c=relaxed/simple;
	bh=zT10JIzlCbI3uWQxtNeRi0PuQu5AB2ETLq6smUtHfRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HqnMMtdFLCou4E3Jd4/0c16wSlXez5vsTWIHJyq5hT1c3g4ZBotgIpmK38GbhGMNSsnQsLuKaOQSxYfhakl4P4Arx+lyaKH6ou0KPPOVcoOfNUQzN3elmunyZf35QosoNo1ie5DIUDneaZezx5Wv9chMFqXBh1WjxG26d8vApLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDj1goXk; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDj1goXk"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7f0167e59a3so192145a34.0
        for <patches@lists.linux.dev>; Thu, 30 Jul 2026 14:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1785446436; x=1786051236; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=voCLBuUeQMgrtWerws8E6SbHXuHnpUq0yvX2L0ODNXw=;
        b=CDj1goXk9Gfyflu7PDuWY+jzko38qGf/92GJu4S1Rx6LiPM32DO/Fm3Y3/hGam2pmu
         5IzG+NoexTXkWt++9sbdc2pe5UZ/ueFbnhwSEP9cJnrirEHq1Y/kisj0gexicmVaKZzI
         mkyLrGqQBXsa6xfCaQg1mBeIFXgOFMT7UuCGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785446436; x=1786051236;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=voCLBuUeQMgrtWerws8E6SbHXuHnpUq0yvX2L0ODNXw=;
        b=fquL2IyQnHceZC24l3atSOn5bcuOo+cSGJdyycyYuVyYcSteLC/5OcrTk/alQWn3Nt
         cNWxYq3zfO/VbBqx0EbP8JMvdtZaOTWUg8Wg9+N7+Nm9eDGZ80dF1EUaIoChb6dh91c9
         Kcxt25uMfZujcMoKOVq+cqHL8sfQNWG5HvgOeFnTydTAf5lbrfMSQGeyV5U0Pjtv6U/U
         vV1dNw7OG+a0zgr5HI6/QPYEZPnphShkrtg50Z84SLYCw8rSdakKWKBved32IzmQpQO1
         BmXsisWczxBzLiH9+JPwCFVFNED8Ds+cdPJ1uJjI//ai1T1uDB7gT8zpUDJr8FansTKf
         hYQg==
X-Gm-Message-State: AOJu0YzE1vpHpZfWeLNhpM2dY6K+gUXBr0LyI2L9ok23H01HJrTCgasv
	rxZ91kR/F+j+Q/X7W+NzBUa9Uzg6rp65Vq5soxlL3t9UtmSFAG4UWTSH49YbHLTQAVc=
X-Gm-Gg: AR+sD12dMD8vDri1Lg803NeyoTFwoQLFIrok20wyn20/k/Msr53r27pMFVxXI0pYMte
	Ocq5xQozo/Zqs9/tRvLSwBjRWXK221mBLRoBDwS4zv4rPojG/dgroeEe9ckJO2ALgZOPr4dkxgT
	CBTO6/uY1VaoLj4kAwfki60gt4Q+eKSG3rYOcGG5NkQtf+6UXWlOWKipckah1VG0gUgaMpkVOw6
	kxj/9B+U23of71VavCA8QzFr3wNoaUKyajIABU9pNm4JYmuEgJQILqZdqv7owER/ZoKD9aegjQ3
	D2kB2cUVdw2+O/pDqOkEFZ+NRPqCIjfhlMg4bWMWK3FfTUxJzmZcpSUEqSPUfyXlm/XN84q7g+f
	9gsbsQBIFg5XzLOGLCLYAgiRqlTJd6X7ayTXfUhM7lj+sIfcaOHhKtLcqsRNpNPqnwPhy2trDdB
	9vTM7Scr0WZMuimtg5SZko+sAhIA8AzeFqH6KIqmgwRQqbDpuU5BX/MkAqWEpf/i+gQQCe4Q==
X-Received: by 2002:a05:6830:f95:b0:7e6:cfd0:42de with SMTP id 46e09a7af769-7f02c164df2mr3084911a34.15.1785446435690;
        Thu, 30 Jul 2026 14:20:35 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-458c29ceb9dsm3150856fac.14.2026.07.30.14.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 14:20:34 -0700 (PDT)
Message-ID: <11e028da-6541-4414-aead-0d218ac2cf8a@linuxfoundation.org>
Date: Thu, 30 Jul 2026 15:20:32 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/675] 6.18.42-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/26 08:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.42 release.
> There are 675 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2026 14:13:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.42-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
