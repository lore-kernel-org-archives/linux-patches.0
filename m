Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B17277007
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 16:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759597032; cv=none; b=sKkUG3JFI5aBOwQ2LOel5xG6b3NcQpCJWnCjFALT4Fw4KKujCKaPw37GCz4zek34dIV1jd56Q6cVO+0+xlVmidEcPca7RsKXmg1smYxuXEVVoyO90Y1awaQADL2WTdcGIe+150vFJy2XxzmB4YGbWIajr9Owt1S6WAz+bJ/t6YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759597032; c=relaxed/simple;
	bh=+UohY9HqNpMBf+gQ74FwUWrvvqUMkiginVNAaAKBJFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qDPAvVUkqyktIFe5/Bqzpq4b8FjNvmZnYJvyLxuJjPz8lBNW6KnXV4Qm9nzQHdL0rtN0yPVWIWu6VZiaPyP370xSPBM64lzIdRkmJB6YeA/rgnFHVzH8P/wPoBAP4GP8IFLiPJVoMoQq0HzJ9Os7cgKG++UyzhXJ7LZx/InwcqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fIk5BYR0; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fIk5BYR0"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-8ca2e53c37bso309893139f.3
        for <patches@lists.linux.dev>; Sat, 04 Oct 2025 09:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1759597030; x=1760201830; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a1mMWuCz0t3r8/HFzzxA4DdadxyuLy3zuMlmevG8qBs=;
        b=fIk5BYR0HRFX/nSUgWJAsUsAB32MzNB5R3YiN7/70lhXkKbDc+Hx3Z+kmuR1yZgS0A
         2nSFPBlcjebqJzyHHlAd+4u3h6zWEqFklUSu+7GPRTDVXLRu8UZV1mELG1nOyO/f2q6J
         AEo1sLgCG8mmq5otSgAgG7e1unImn+oBQIEbg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759597030; x=1760201830;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a1mMWuCz0t3r8/HFzzxA4DdadxyuLy3zuMlmevG8qBs=;
        b=klnLY1+TdBa9DmHfx30mGZTAY0zfO99HOkyi9zqpZmxMk1TbbZwDl8xwSdk7qq1xUm
         Sj3N/tw20PBkFptblnx0al7LAdZXHg0Tma+h6DtfMFlxsCcsCGtPz8qwbkBKzRl1egmf
         CC2GhVMpKHO378Nx7REd0We2fwNgWzI/ppwNGk43eBlLQOkHFzA1IMUG0XO7dxI4ndI7
         oWAwruh7jStKRjmLszjVrurUL5aq/uBxNRXl0X+f64iWF+GJ25nCuGAmG+GdFRNyJLbg
         zHSAbPJG3qOObIKctlI3hRACsrbHIFhmO/PpDGBbsN3rvEkWGhlTC6rf5aoLtpXXXi0x
         qBPA==
X-Gm-Message-State: AOJu0YxQ2K+LF4r85In7hJzOx7bRe81RLl4PoAJSVnDSpxzf9LCQr8ip
	dcNnOYbkkNPZJJXdU5rEbpyHb+7kcO9B1sRfJROOmQ4Xd4GruYkWGoHFj/3s4pGJhSQ=
X-Gm-Gg: ASbGncv3YQnxTIDF/iimuTQVGQhvTq8WIRTSWAHzhLOzXfcd2yflFd6inqF2qVb2OlT
	wUlJwy+H5uNcQuLKC845HU5gFbJZl7luTHcxskIABeWisGmix8WX4E6Xt0cZPZPSw1U53QF3jdE
	Il9MY7bEhGlrwilK+ObZbUe0Hn/zQSB6cPslXMJyQ//I0tPNT2EbJcxxP4QMnQc4yVlRcFOerm7
	OYfvd8nPSQLWyPviqQLBbY+tx+B35BwufIJwUqUGKgV5EIgA++hYoq51iSql5qoy3NKjXfy1PrX
	GRV2Kr28X5dzeoeFOyDxgYYg6VAO7a6Fa/CZhH6Y7MVY8WkBDNgrwWhAhkrx2cuVbECVwlrPrcy
	GHwA1q9xdbHGtdpKKrNvMSBqJA38HJJYpBuGa3ySjFmk20sWgZpoyevtcojc=
X-Google-Smtp-Source: AGHT+IHef8taA+Z8P8AtiePPCV7SM1tDyeVyNmWwQlrFm7/YcjguSwVAX+OofP7dxS87Htom2Ta7NA==
X-Received: by 2002:a05:6602:6215:b0:887:26b5:a581 with SMTP id ca18e2360f4ac-93b96a5d491mr841505339f.12.1759597029719;
        Sat, 04 Oct 2025 09:57:09 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5ea7f82asm2964305173.33.2025.10.04.09.57.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Oct 2025 09:57:09 -0700 (PDT)
Message-ID: <052bd9ce-fb5a-49e7-a670-a75613ad0488@linuxfoundation.org>
Date: Sat, 4 Oct 2025 10:57:08 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/10] 6.12.51-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251003160338.463688162@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251003160338.463688162@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/3/25 10:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.51 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.51-rc1.gz
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
