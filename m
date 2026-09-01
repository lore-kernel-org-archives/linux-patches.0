Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C343B6354
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 16:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281262; cv=none; b=Aa3Lz6mlegp2z35h9BRBvCV0G91u8WfS8B80o+2Z5OdQT/MKLh3WFcTsVna5eCVly+74WLPghTVWCg4UnqTKEafajzpQUYG5JtcFF6vwoObcTo8TvgJrpauWYl0Hf3Kf9bAn238vTdLu8bxuNFCH7AfDGCLKPcgDbJ2710Y4DKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281262; c=relaxed/simple;
	bh=hXcx+zWej0g5jt49mEsC6y+RCbKQYJzwcUjDvMMMrbU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rA56hQHZotCdKHt2Thyun8g/OTRo1BPknAnIxw+Tp22Uvd+gp7dNKr1nlfZfG0aQycVfLpvVt86tgjiVMS/HhvirJ43uoNqU96J1Ij+Fd2m8bghZizzoyqCymxRq0GFqU4rur8q6Sf9DLCoiENzK1p/+bicNSqzb7kMPb8SsfFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+CxSEvY; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+CxSEvY"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-446f87b6de1so64679fac.3
        for <patches@lists.linux.dev>; Tue, 01 Sep 2026 09:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1788281259; x=1788886059; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2ZUuS5KsY6EoA6yaoBJmvArPf16bQqatmcGtTHp56E8=;
        b=W+CxSEvYl4r6EffsT7LFiJQpWGRZy4wVlcNKGXMd5tw94tq77jqH9uC+a0DiKiOWPR
         oKgBVa/+5qBQMaeCOhawYukOURT5dQiJoI7EHFu1db497SLBmjx2NilypgwyTxaBdXCY
         VqWQ5G3vj0BBhv8isEZIBL4NmIocWKs9rl54E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281259; x=1788886059;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2ZUuS5KsY6EoA6yaoBJmvArPf16bQqatmcGtTHp56E8=;
        b=awRtyRASztP/UDDl7bvQ9K7FoPeYy7ke7ypuTzGswXVtIrSLph7L85Z+Nm6iWaLpJY
         rdSF+6ej9731gHOFQa4YgwKumU5q0GZQbeCBA/ulrUpZkt3dYwF9N4S/2RU0QzHikmIR
         jGkMg6vREGzEa+RmqKN2FILXaEWku1p0skRXPsmLLv1uIK/FymJDFAvqnJxZKO7HE97k
         2o7yxIQOlq9MbFVpXmzOgQOiUHQqBqtC3M0IBEcfiz8gDndkWhLR96tlZkVSuwU5Y1JL
         O4YyaBjaoLQond24UM7PkwEI7liUe5UkMD89G+bTnsZTX/9ISvBcuKieWXFsEzqWflRL
         zCtw==
X-Gm-Message-State: AFuF++kpqWUyataTr0/nSO00zyctIrbGmRvmLCRqVIKm24TdtFRzyeB9
	mX9RvNeO0olZ/YLojhorgF9C4L9B+PahjYhWQWUhUC5m1dsK19Q45cUugRA9Bq++3oI=
X-Gm-Gg: AYBFou3AQTj+5Pfnrg8pQV4vDc0KHmGQkiZvVu5xXc/Yhr+Vv8zRZxDKxmLOgDgOnnZ
	EEin043zRbqyI4OtIomkIADwAbPIUKcT2PpKL3987H1B/GqbchdNJhC1tsZ+9YbnYmmL5RfX8eN
	/5TDK4xWHh/kxNIfe7TrdM0/Q5HHVroV1O78TSrFmB4szaDB6SjlLD8Zu++wNKJnMrxUWmgiulV
	75OgX3rgKRge4I5sbAowZv1EUAOdP9wnEwE6+g+kzdmb0NH4/Fb8b3FgyPxY3sKlLyMEPw55Ck3
	EEiGGZ4CF6MBcybVHVnHTa9yn1k0KohtDbPWhf5WQA7bprcDmpncZO8Pwg/nh4rwsUJKHI56NDY
	25i4QEH+s8hzJ5El5EUDpnZ8dLDcY9J1bVU2n2Z6hQEt6NER2t+3/iScY2mbAfgSndP8MeK1Q0f
	cu4b1YiLaBLu3xIz2WxTXEtfNmg+bX3dprcABeORSTmURvpwGnnYlWZCAxLbqAIBOOSBWH
X-Received: by 2002:a05:6870:8094:b0:43a:19fb:8b99 with SMTP id 586e51a60fabf-46af568c963mr9831277fac.9.1788281259524;
        Tue, 01 Sep 2026 09:47:39 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-46f2d4b266esm219881fac.0.2026.09.01.09.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 09:47:38 -0700 (PDT)
Message-ID: <aa5f3249-f81a-4b61-830e-f2702ec28d7f@linuxfoundation.org>
Date: Tue, 1 Sep 2026 10:47:32 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/69] 5.15.220-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 07:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.220 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.220-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
