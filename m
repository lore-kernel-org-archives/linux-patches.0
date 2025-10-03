Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47CA2DA77F
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 17:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759513258; cv=none; b=LHsgZF/UfBLq63M6KRtpI6Z0u0h0vD3pyV+SpHPPkYEQ1T/LjWjzUuT9d2cQtdP5hABNJmE1zVi/WvC+D9zrM9s9MGGjz1XcfMR40d39edfe5f/6jMqH2nx2HxihBifdlcfHBPpGed15IS22xyveU+bmrhOEfjeea/SXNX7Jjjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759513258; c=relaxed/simple;
	bh=7zGsOrHucK/F3TXGYVNST8Ic2yHVpPVoo2wGcmdWcrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L3yW6kHEW7QiwWcsQsvYQE/KzM4At0Uwfakkeh3Au5kiaOUenPekLZxPEuyjvE2IJ5XSJKfdgPkp+0Ma2I/GAs9P3q1WIQas23rDCevYhRbCKYzQSkNrvMiFy9ZfrHlAAn2ItDXNZ8H4NQHsIGPGocAZiPBzxvovo5BidrM1z9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dsm9ht3v; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dsm9ht3v"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7835321bc98so2618133b3a.2
        for <patches@lists.linux.dev>; Fri, 03 Oct 2025 10:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759513256; x=1760118056; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8DvF1xSe5T64RA3ceOh6pYqc2KwrLyGdOksJedmvMUU=;
        b=dsm9ht3vhlLaSSUPzBWm8IFH1pVfqeQbvA+Hn3bCIDzUQS3ZpWfTNalV+wUAXpWDtS
         pnnLTTdTh4TRd+vi63YB548QammB+smNkISYYZ5ZKY7rLNXeR+fJVE1q0+On14Og92ZQ
         RqwP+vy+xMhD/6v9rRQRAp526IcZrbF2aeg1FcA42OaAX/Pv1U/zRLpUwjfoLhOYg6ic
         Wi/cK3J6NroZSWxzZkceCcXSEXlDNUMBGI5evfEBDuP/Zsw9HMQxKXqOgpmzuZ2Mt63B
         HizDwa6DFP29vEorDqrFLsfLkjk0RtsiaSODCnSX85wBAbH5oE1/1Jz+DASCzS+DrdSu
         ly+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759513256; x=1760118056;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8DvF1xSe5T64RA3ceOh6pYqc2KwrLyGdOksJedmvMUU=;
        b=cM8dDrmn0wJQPZ9bAtuHdMJNlsocmzEKHueFKgxZS7BElClFFuKOpLD02ppDpLw16e
         xTI9k+sbobJq0T6cDn9N2P/yED1IE96moBjIpUzSBntaMFU3xYDoQ+bmhA9mv89XfGyU
         /TMeY7zyBHGwUiXvhE1cun3udItbMDcmSPi3kUZ7xnS0MIcpZlMawOn0PW0lzh7IOsXF
         ZLVawfPEZpHDU+DN7pY454QnSKIzf5PN5gS0dE5R9hFI6En/HZPtGjle222p7Ci3SzWh
         enTqH5E8wuTskDcKLv8zdKffOIu8RC12RkHVBLdkafJWHnE24AoHL4RrNsStWR+1Bs9K
         lzMQ==
X-Gm-Message-State: AOJu0YzgSRe1PMaHdEDn3w3s3nWa23Vy1pLbGGsMy28GCgQt8i7NLM2F
	wND42ePF2aM0zJ1pJZD8V+Q4RpSwDkZTiMk8q6B6wrlXWMko1ydfhRxG
X-Gm-Gg: ASbGnctDClLVykB73lhkCBDY0W2CC46/je1e74YEWxG2JV+2FIhz5u4/GawH9bQqr8P
	vn0jdPwpmASzjjKoaYjCbtITypSoRE+997HFtT9oeYVEjs/Y2Xw+otj7/c8qCB+3zO13/Eh9FWL
	91xcJYygpkeiCuQ0jn1busDC00JK6sjlEqUZb0XmesXIN3FwFKuJ83ZhNf13ho3XCHr4vJC8md8
	ekn1F1HCGfDhDcb6YIsnRTv5T+F6ZDQc0QeXnWOyTdcOMRSCOZHJ897vSEO++to+gcz1k4yYrmD
	A/EtJ63AFw74lpPKvZyJZ1nNI4YjFMFQRucjPaj1f2oe396cHOzQNUIjemwdZphnJJ29tFZcnCy
	GmcY1Qf/Ic0cb66QkWZv5V7KbXckj4T1iy86N9TrSkd5hD1+wiYzxdx+4rV2ws04sYoE9uN7kkC
	zSFsAz638oClKJWoI4z/N1SHg=
X-Google-Smtp-Source: AGHT+IF0CWD2qg+PTIx7YyLiOrkXXs3s6uMSmo5ndEoOaGo2dua6hr9Ax9ka74DU9LIpjixcoQgBjQ==
X-Received: by 2002:a05:6a21:3283:b0:2e6:a01e:f218 with SMTP id adf61e73a8af0-32b61dfbdf5mr4344924637.11.1759513255860;
        Fri, 03 Oct 2025 10:40:55 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78b02053584sm5446155b3a.50.2025.10.03.10.40.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Oct 2025 10:40:55 -0700 (PDT)
Message-ID: <cacabcda-c0c7-497b-8556-f6475639a341@gmail.com>
Date: Fri, 3 Oct 2025 10:40:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 00/15] 6.17.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251003160359.831046052@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/3/2025 9:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.1 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

