Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA583375F7C
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 22:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774303550; cv=none; b=EivQcAFVqUMNFDy9mjC7gqWSg5LDI1msc5YOF2cbgd2S4zGo6hjpBWvpqY6G4RkJwMG5pB34qjV2LyTxIy6R067n3r8CFmM3xYjIfVU1UYzGoJXBUGAFqY13cSrD3zhOmImA7NbYHoqtpgk+2ic2PeYXwDW9tHxFv1DY32HFaG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774303550; c=relaxed/simple;
	bh=2g1nbK/812MZGIcGbvdGPhanwdYA1ypMF1HB4iF1iv4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mSJrvD3JJ1aAyDhsB3Vt69V9URRznnQFwkXNCRpXYdNRP09Iy8CvFBFeggoSVijKGjFLQr8AwCSBG9Zwzj1GHtvFz9h/lYCnalOXz9GmqsSbwMco1Xe4JGKsKuzw1Sw21vISdXyFyS/xRqnPy+Ah6IreBU6/CvzyounxuW6YZ1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkuxD1Zy; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkuxD1Zy"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d91f82d819so534433a34.1
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 15:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1774303547; x=1774908347; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GPi+fEBZe4b+olvD44XhIaSitJou679Kw/0wt1RgPRg=;
        b=YkuxD1Zy+uYQcRIq4ajllUqTr5/xU5RVKEYbfZ134DaFeV65RDfVO7ohnhsm+j2JbZ
         ByOAO3qwIfxFPrx50BrN417IHe+/0Nj1PDSJJwk5yNiQ73enEIjKGJD0RRNTlICOTskU
         ONcAF3rNb3fMLDMbze+CpM/V9m3IQMYwuRe/A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774303547; x=1774908347;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GPi+fEBZe4b+olvD44XhIaSitJou679Kw/0wt1RgPRg=;
        b=Zv+Sec4F2OCRN8Pu6dyVsvUs7dE4F8AY3MsP2kDqfLZSz3J4qVh1GEF6OrNzt/FSCl
         jcUppRX9y4UfG281A9nnfmxL+hSa/LqXdZ9iS/cD2TNiUgq2gH6tMwPhfKoAtYUd6Qez
         r983BR7sEDRsSQaKm2p1wJXkzCAUDF+/hvR2eJq2SjScyPGYQmDcKwqQ7L3FyzHef/LN
         KrFXMutLOhlDLXOj25WU9emHtUA2U/vV7cEUmEYudVh1wA5m8xrNLG7izyOd3qy/uf65
         glgZM2GLH+CSHLaQMUq613QkiPuh0cD8YL7RfISv3fNt9BYIXCgDkWvC2R68VAuVnnWH
         A25A==
X-Gm-Message-State: AOJu0Yx3AhBQGmfHaiJf2ocfEn/A1a7TBgBabgVVCbclfsUm7XMhIFZy
	j+UoJF3DiVS7NK5PVwZhsvyE124pev/i/uYbBc+H0HzsgAKIAjMpSY/N7pjl6wE99oI=
X-Gm-Gg: ATEYQzyE5c1etSC/Cb60Cix8hCDE3CXdB8g4ZGQHhBU1VqJ73+OstO6uol/nW/pxJJ4
	wZYeQbk8vlu/cO2dSFs3rEQyOu4sx/Bohm3m/iI/sl0JVV0Iq4rXTHYZiBY6HMMwr66eds7jY22
	tKIZItggk+V6nKdCa9f983kpCVZDYEBzitwp2YMM9I129bA0FFbhJrcsfE5VmP286emTgqTitCc
	WZ1kW8Xcdl7LXqInH2l3USmLrXMhfiSPObmJQ9rOomVhKQfBi5PB7X7K49/jg6MyjXfehj7QVbc
	HwIqxF83MZtbqAuj9tsCc2q8eBDK8PLFemQEZ30oBxbmS4g6VF1IP3KNHXsvTaSyz+X46ddb9qb
	EES7CkPvn0W6O9ohtwnYP/vGa9236GwWCEiyd/zYMYGbwa38QFaNz+R+n56defUCmSJVYqQsytN
	BpSMv5CMds5l4BElT7o2wqbrwDsqPcy70gBCjC+zONiR8yBg==
X-Received: by 2002:a05:6830:3505:b0:7d7:f031:37bf with SMTP id 46e09a7af769-7d7f03141dfmr5725121a34.19.1774303546826;
        Mon, 23 Mar 2026 15:05:46 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7eadce2e4sm10400300a34.17.2026.03.23.15.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 15:05:45 -0700 (PDT)
Message-ID: <fb9bec9c-3c25-47fa-a215-b485148dc7e5@linuxfoundation.org>
Date: Mon, 23 Mar 2026 16:05:44 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/26 07:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.10 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
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
