Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545BA4A3E
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 00:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760747114; cv=none; b=O2WTcoyDpuvcVWnaY+sxXK2inBekTrwRJsb/kI35t92EWOgyA94+uu1bNhK+jIQyJL51a6x01RJwS8/TmHCLDI7UIO9Dq6ItoCMSaRgyBDqJS2CvO8D8JODQGK3gxr1LqSMKGaEagzmuwNbluGY3t2ryDnRsrNYV7ISmZutAnsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760747114; c=relaxed/simple;
	bh=Boo5q2fEiDnb5Yw1TGoo4/sU1WYR+nze8bhNsT/TMYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cQXuOqxFv7v+JMk1aU52Jpj3Fg2ojkJJ6DvAtF4kH2W7CN0JuNsc2mji8pLfAajJvPDVoda2AicaxVBzc6jdPRzit8ssZlwpdxBM5J6WK62uqWJ2i6oy3zRqeiFaHyNMranKRo0I5JjqzATVAsaOXeneI2ZUnkgVfxEPfovY7NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1ZehrWh; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1ZehrWh"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-917be46c59bso247789639f.1
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 17:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1760747111; x=1761351911; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k5OIGFJ3C3vAizbGtOqivJi6yt4VdvmhKJruwm5miX4=;
        b=B1ZehrWhYhCcOoxY6Q5R0M94mjiwJbYnmlQRGfogE9WaETuSkDkcaDMfenCnFDPfy6
         vaI9cIHvGmzdO3QL7npUU83NDBEbt3Lqgz4F7zyMjaqNXs0ZdJ5Zu2je8i6giOAHLpFi
         peU0cD/4I5rsHH/9heOIQCFDMmECYff1f3D0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760747111; x=1761351911;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k5OIGFJ3C3vAizbGtOqivJi6yt4VdvmhKJruwm5miX4=;
        b=LISUjDfyO2XinZXxkGsd8l9rf3IUJStP4H0YWrglrjkseFRdxdFPrg2p7TTjpLV5P/
         3Ix48ck9k/scKJ4qvfkbgIiDNQ+Ezgwor5cudDAojuZhn9bydtq7VwbXt9DwpP8M1bu2
         mbUGWSj0rJAqT8RRsDvqkdoZdoTMyNsoPHGk43htAL6Q1jpylXfWQQCmE8Vrd2doQPdU
         J2DvV+eszgwTN9TorpOskXr1snBDuHnhtiSkMPQSjRxXRahVoUn7bmd31KdF8XlgrEAw
         Xeryb31UGLfIgRJ12mqRDR6f3V6zfonJuocTkMHdk8oj26DWbjI5slGKxrkgfTjko92l
         rIng==
X-Gm-Message-State: AOJu0YztFtLRMarMl1e0ComVAB62kxGDtMjBHSBxy/Qv01a4ACP3qyg0
	MAcjqAg0Q9B9HnwSIdxbqT/csN2Bp2osSXjT993/DeShx9y5kCZcne9yu/dL7Stxo+E=
X-Gm-Gg: ASbGnctg1WLFa74NepBUKqUsgW3bzcdsqDQQxaA9oIveVw9jBo8WPTgoiXq3TQXL/Hw
	fQdme008XVcaqrIyKy2O0tr+1ufqU4fXf+sqGJsdBM06oPuz0BHGanavBrVWn3+TzEITWh556UF
	pRZU5bgmiMxp9fmCjSPNcsfAjpKB9owdKj4PNEwL7Z8dOF+Yb8dYZNGAi5ev90cXS/b1ZHOnsz7
	PKnyJ/x83XLNmi279ldkDl4CVCyAHX6hjhNLVjt9tehYtffTMd7oRdPNympHKImy5038z0sm2lx
	XUqWKCpMreRjwSWl62SW445pDMuxJm12j5jUWpgu7d+a7F+q8FA/gVoSbOpz/726aPKh0ujrH4M
	cghuOca2zsgr/h2n3BLXzH7XQmBquZWN81N41H1RYETreGop69HoKPxUkl48PElD8aaetBeyB5P
	BjUTsIg+ta0mQd
X-Google-Smtp-Source: AGHT+IHppeA2hPs8LYCDhLY7KevVOdanbHpjE2XQVUuhdAl3Pt8S47OrsMyYRzUyr/ymQV62yGgSFw==
X-Received: by 2002:a05:6e02:3807:b0:430:c0cf:7920 with SMTP id e9e14a558f8ab-430c527bc73mr79338755ab.19.1760747111397;
        Fri, 17 Oct 2025 17:25:11 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-430d06fa6c5sm4829095ab.1.2025.10.17.17.25.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 17:25:10 -0700 (PDT)
Message-ID: <1d63e732-bd8c-47bf-90f7-def9d7235d06@linuxfoundation.org>
Date: Fri, 17 Oct 2025 18:25:09 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/277] 6.12.54-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/25 08:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.54 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.54-rc1.gz
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
