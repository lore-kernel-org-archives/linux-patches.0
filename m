Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BD227FD72
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 16:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759596873; cv=none; b=cre8z+NwBW17aSjr2tPQ6NNBlW7+mDo0cmRF9Fsm6s+JfGJzBUiM7XWLdb38vjHgo10p/9R/jns/nlN7VAiBRIAJrJSDzFZ0Mii9r0v1fQkj7M+etO+OjI0Jkcj4/LwY1JRzM5e5dchLZ9SG3EcSvuuzGvY6dQeaUHYDuturnNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759596873; c=relaxed/simple;
	bh=7jwL6Vl5B43Ocy7VPpUCA/ZQ+E8vvJVNntNOaNWS/xs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mvswBVTuuVLzQ60zlrDGPHQT/l9Wr5NUnygHY9EKN91kdMzwtaj1r5VoxPS1AGbH7CDfCSXM+2OaF0bjbxgBEnGuurKE0HgtZgMFrbPJPmgNXB4aDjcuW6pC6EXUzy3Xt1kZobl5a+rlUEmeJcjPW+7QUaTfWDyzOcm7rEPZGc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K40+UhNw; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K40+UhNw"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-90926724bceso281472839f.1
        for <patches@lists.linux.dev>; Sat, 04 Oct 2025 09:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1759596871; x=1760201671; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KBHBG9tA41TCvQg7ZgtdnkfIFkrXuT8caUQqZNNWJoE=;
        b=K40+UhNwipoqOXB/TeETfAK5/V90/66MyWrYpGOUqczzArS0vCbQS+SjL3YTprhjb7
         ryg3oeULsggSFg9xODVOU9yLqtMrdDmntCjzdQjzaebdjtoSmLeM2CTtyI39TWVTr2io
         2pnds19nv9yDFIGjPaKZjo3jRdENS2Ss7gBIw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759596871; x=1760201671;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KBHBG9tA41TCvQg7ZgtdnkfIFkrXuT8caUQqZNNWJoE=;
        b=uGvQcE8KXNspmOa3RvHVeggWWi0lQDYDBl5r8+EffYyMtZmIwqc+TghBgE1r2NvyKs
         oe06DNSooAFh6ifuxq9fVfev8LTZuDb/Isw1QEGd9QjkoLcY6CU+AnOkTen1eXSMhIKs
         /LRmc/HCNH9RMsHlJny2kN9X1jWMTzJr29kBGyHfdaV7bMDQ/X6bW1JywbApZ9KLnVc2
         pHCefdaqihipStjZNO9wmHnxC69kwmQ9fpbXqXnYvyZMPbbg8lacoh6WEHlPHOwd9BRm
         Scx11D7Dh2lfPMlZQrKXlB5MqovxdLYjmRCXgkNewk6Pdfe0LeNJQ2peFsW30p8YzxW/
         hPsA==
X-Gm-Message-State: AOJu0YwUYgQJLfSSJqkTacb6Pqr9X+kfJ1a9DaNrGcH3ZgifMcfT7lk4
	2GdE6T7iRo6sNOEGTdvzN3rvU5YWJYXJVPO4KZdlAt3Ir3J6P3bsjiEqNNAv7BZ+5ms=
X-Gm-Gg: ASbGncsYL9UtTXqRYMG2DBFsxRY1GpbgiZ2VwCvIwedo4VZVdndnCMxE2N0ya8Xi1H3
	Z47aQq2QexH2cMjAIkHeD2OV3oZpkIcgjGCTPJzpr7FEhqgktyeTVzAz0VVztluPcY1GYgstrzK
	YO5rJFmdY9djY8SATbiBe27tVMy6VchE6VGq6V/rocvu95eGNKe7pZcVzcsM218GMqX5RqZ1M0Y
	sDlBX36yUPk/rYwJO+0GAanVkimExdnNctMyfZxs24bVbS4s0jWoHe435HKHY8i5J1vdIth2CAU
	pOvHYp+Qy5lyuQwKpYpzBDog9f3QAHq4z2iWbOkGAVZzdEw3KDPwK4ObNBveKCDjbRsNXnItTTB
	AtY2k1tlc1F12e1tfduVNAEqEJJUqpOGu6tVGlKF4QV6nuvPlbTtriSSLb+gTA1PKCNYB9Q==
X-Google-Smtp-Source: AGHT+IFpIfH6lTTmG0N2imGQ5NqZw46VJZnySYfxkXs0eV2kmfblbxS3NNNdc8KyNLc1LeccYMthRw==
X-Received: by 2002:a05:6602:3fc8:b0:8d3:6ac1:4dd3 with SMTP id ca18e2360f4ac-93b969aa445mr985467539f.6.1759596871101;
        Sat, 04 Oct 2025 09:54:31 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93a7d81c735sm291244939f.3.2025.10.04.09.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Oct 2025 09:54:30 -0700 (PDT)
Message-ID: <edd6a626-a7fb-41a0-9b98-2100f85ec2ee@linuxfoundation.org>
Date: Sat, 4 Oct 2025 10:54:28 -0600
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
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251003160359.831046052@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/3/25 10:05, Greg Kroah-Hartman wrote:
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
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
