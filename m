Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145B5335BA
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 00:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725582352; cv=none; b=dujYSJ6NOgw8hmzLktXEiTSZIaAiXm0uW2innCYzy3Ss1ksfycJDzzg3UlL8D8pSTq08L9mf5l1+M2gIL284lAVzjtb4/w797ZnZQQaij9V1kg2RDWZaaq+gyRDJzyrrwRDxV37pPJxqgpuY/AVOB81neQsmyUoSDHA4ogZ/fX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725582352; c=relaxed/simple;
	bh=TceHKBuOWdShqn26e+E2114vw+BkWXu/eFJXoMvYLXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PWuaTCHn6eo6pE6GGLq6Jda9m5jQbT66o56TG5Duta9VSYBx2V5lNKzwXyd+CSvBghZtCIjagc2gx7XVV+upB0dfFaP82vOA0+hx5zVnJhNEcZQiAE8L9VfpCwZTQbS4xkr7YZgEk2a6IXYphutAR/9fbe6qSRJjJi6x7LoRL6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Er68bBNK; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Er68bBNK"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-205722ba00cso13975105ad.0
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 17:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1725582350; x=1726187150; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ApnYfKTQtuBNhNyBR6dUfgNS3EzyFjj/3NfY//JSza4=;
        b=Er68bBNK07+o9cLmEmLj7XgFfctM5gl/sZn6rWNoBU95BSTWr6x7mGL0YPDI1RJrKm
         3AzxfYPECo2gtbT8zz/yQNuBHzGwwQ10GU3jiBxhj1aaQNOcS/WfE5vl7+V3iGII5Fpa
         W/QlpcbCrzUNQQjPS9jiXteKIOoceRKLFtSvA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725582350; x=1726187150;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ApnYfKTQtuBNhNyBR6dUfgNS3EzyFjj/3NfY//JSza4=;
        b=L9MrZAK/8mK0j3vfrY1jheAXWBRe4zU9CSPkTYy/dtRX4+uC8d2/MqQrZSDhRW3ldm
         Kb/OvU3HsURzebduRfHTfYTYpd2onKsJW68E/tcKX3sUeEqDbbCJdiiYV3IJsdanRBOZ
         ScyHx/LdlPDNYXlkX1MfWXdcs8Hz3JjlUQrvdteH/MP1Qrjxqvdg5IjqRtYfUTX98QdX
         0QNp51PQLnQ5z+RfIASDtJ19wWnhIWDmh2kx7mC40bbJ3U+a7iS/sKcaeR0d2A1M4P7a
         6hpgiCDTyeso4ZbUQy5ttS+TLfZLtgxJbMwYvl6r/FXJTDZci0d/xnmYluxVSF3S8kZh
         TmPw==
X-Gm-Message-State: AOJu0YxNBWytSEngTrkHusIot7KoznHUSyQjAI4+xVR2lUXjcg0BFvRJ
	eHDmXbpi03r/dCMuRiZ7wZ5tFa/5Tmd9sM5MP8t5Lm+Z4nF47xxBhELR2bfhRW0=
X-Google-Smtp-Source: AGHT+IG2trqvH/COo0RmJGlhBeKlb575jX/M+2KRWkBWiacIcq6FUsdWSbhSiWrvOR9/Vv2rNHU6Jg==
X-Received: by 2002:a17:902:ce82:b0:206:a913:96a7 with SMTP id d9443c01a7336-206f05e55b7mr10488645ad.44.1725582350205;
        Thu, 05 Sep 2024 17:25:50 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea37cc2sm33928925ad.160.2024.09.05.17.25.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Sep 2024 17:25:49 -0700 (PDT)
Message-ID: <da10663d-0496-4419-9ab7-91da3fd87199@linuxfoundation.org>
Date: Thu, 5 Sep 2024 18:25:48 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/101] 6.1.109-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/5/24 03:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.109 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Sep 2024 09:36:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.109-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

