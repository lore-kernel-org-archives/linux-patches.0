Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75771EC017
	for <patches@lists.linux.dev>; Tue, 17 Dec 2024 23:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734476432; cv=none; b=JiUAqdDCeoLfRef7FR+l1kv9MX0MSC2+cLoqeukyesifKQ5IBnWKYw4exJLdlq4KOb7939G8e54RdxXm10nD8wUjMNjoHCPgNoq+2R/eeGMPVsIXCfTdNegZWPB45bvR8/Qr3gIZkgqtZIAapQRrTOceXdH8M95Z7uTvZG0ieBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734476432; c=relaxed/simple;
	bh=heZCgR36okwrEPenz1vox0Ph/7lggzAvy9tEGMZmPdU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ivUyl3kA59IGKdX5wpU4P4qqLI7QeUYj/P6Z8+N4USwVKTgm3YYJAJjfchRtC2FKZVIrtpRwJRNt8VpGEGO2GwehOGFsxsITC0cKPDJXmlIwycmOns1ffopbbfq/aQEFtYKA4jLxxC66ZBUpX48Q3uHoZIvM68VcUX1malw0+3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nq/xEivA; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nq/xEivA"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3ab2f414695so18887615ab.0
        for <patches@lists.linux.dev>; Tue, 17 Dec 2024 15:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1734476430; x=1735081230; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ytheTzvx0tqGH28SZa+nd7zFHHJvqM/FuQZdlG8skUY=;
        b=Nq/xEivA5Vr/u/DQPDqQun3y02PASfLddh0ptRbgGcaos5ehUto3c7e+TniCz7HR6x
         aHxaUFosUJBmpRLVSH+tCQ3LoW/H+Yoelev4W7rKCeM9e1TOEpsock3kNK8Ud44Ylt1l
         XiOv6A/EDXWI334kwoq5FmL0Seg/3He3asLTM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734476430; x=1735081230;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ytheTzvx0tqGH28SZa+nd7zFHHJvqM/FuQZdlG8skUY=;
        b=PKNm/BKJpqLUneevExz0+7RmVrALy2Rafape1oDwoF9mUXALxAK9N3XPOkfH5L2sTD
         L+OOzQb1MeonVUv5wBOT/4uVHewaU84yJetoO2yYUlHz4WYJnKeXJXU7SUSZsmoBHAGG
         v8EE1Y4uq4+EgLtd2zLYDkW7c0+f+2xqfZ3dZ2/RxBYqw9eqplMbnRmQhicJ4Dyh7veU
         OHNnhG6PCnbCOCGIwCj71D4WnZdYS6nCu+iExQUq4TpmxJngvx0/WlivqyhBUmodUfv7
         4NicRDnj7VGfx2opjQMGlQJPZlw8eIS2uiSef//iU5oXC8AEyFjiiu5U22quVwMom8rq
         zHgg==
X-Gm-Message-State: AOJu0YyZ9FK3zyEnxyVL4N2u2LDrkH/YIIi12QPRE8F8nUBGej8TXz7E
	V14R/CNgcCyvbLvyS6jOtDZKghiC13D15V9l36pB21BEikDoHcEE93DkOHHT7R0=
X-Gm-Gg: ASbGncv00/od2aEJ37/h54Xm3Weuq/LP+0esXSo4lFU4siwI2GOyxeAD93v3eUWYA+H
	C6x7YYd2xJIkShCIZhjOSF8txiLU/z4ugJEThmLa8BwfGeCmSNtEbsvFXbNjosItzx5PKa4XuSp
	rVwEi3hF14G26miqa43eKHCZlDiE0RVcdxQIpF5u1dMPXsSnWO5neX31fGHS0A1MCWnjk4HZw9h
	VsgXO712DwKveI5WyhgExQWmGbiW77RZ4/CUu/px4G0bPSOcREgWRzTZnZc8m7jFH4y
X-Google-Smtp-Source: AGHT+IHj1urYnLVFd1H9Pq3MAXhO6pXENBDFiKLXPXYYGMdBg7DO4d/bKBJ0mtkdDouBQ9AMPQaYbw==
X-Received: by 2002:a05:6e02:148f:b0:3a0:9c99:32d6 with SMTP id e9e14a558f8ab-3bdc4f18812mr5930715ab.24.1734476429636;
        Tue, 17 Dec 2024 15:00:29 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5dd620e20sm1862035173.0.2024.12.17.15.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 15:00:29 -0800 (PST)
Message-ID: <842c3d3d-fa2b-4e30-a042-0cbc45562da2@linuxfoundation.org>
Date: Tue, 17 Dec 2024 16:00:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/109] 6.6.67-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/17/24 10:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.67 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.67-rc1.gz
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
