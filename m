Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF8420AF97
	for <patches@lists.linux.dev>; Mon, 24 Feb 2025 23:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740440049; cv=none; b=K5EKTfrr5XPiiTXqWNYMhJXsqHVZqWjH3GuSGEBVa/ZiRIqyJ1ggvM3FKzRVoiWO5oBwIbmG3AQSN41j/QOFHOyDbMe1CRKgzh4afrNtLGt03LWCkHxa7pv13E23ZUyhjZwXdPnyK5qqjyadpBqy5Z/UUImf5EA0B174zKyhMzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740440049; c=relaxed/simple;
	bh=scb6E/iGLRkq80b8k6U/vzSP1FLlrDnpwz0XioeQPfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aiVjZ7d/Lkt32VJXBpFBL4Ljovn7r2dj3j0BYtnYWk2JyHrUYYh+AQcE5MuMrfGzfAtH4OnVC4jPTynM8VNon6DmIEAiFHGI4ojudTPR1nJwjscV+sjl7+sJpKFLEU+aOBvC4CqkRqR5vIVLsKUxKSl/SzirIYgQCsNZFFoMtPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqQl5J5i; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqQl5J5i"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3d2a8c2467eso17559865ab.3
        for <patches@lists.linux.dev>; Mon, 24 Feb 2025 15:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1740440046; x=1741044846; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2KjhyzijhKip7FfXadwTT9xIm71M/ulVqGAx55Z5jtQ=;
        b=QqQl5J5iz8JWeeyMX1SXDwLcFAd/QsE4DsxL6O3F4AM4862g+bkQvXlZOdNLGwb1pA
         JGb7xkm5kxv1AGkc4EhcilWS2GGs+uEYQS729mx2hnQlKH4M/zdH+5JaPFwkmr6Zvq4O
         RYlKWQHw/534o4nAsVLLjL6Q0EvhBZnH4VnSU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740440046; x=1741044846;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2KjhyzijhKip7FfXadwTT9xIm71M/ulVqGAx55Z5jtQ=;
        b=AKMWFTs6vY99VVCOhu7JgJm7mqFRQvlkx2ySPLGWcXQAcqCdQVmK2C6Uc4y3XDlhmd
         iLPWHGOqwCTSGQtZwnd4V2/sdJoG6ia+5+5NPNNLBI3wUoGo/2Ihqlc5D6e0haKrGgkK
         biNp95aL9uEEOrylCOv0QD79nJBv5GZq9i0VtHiClOn/hGjNqX8zHs1yRMM9Lkr89H67
         1pjiTp9jHKTegK0z7EGIvEwEM9Ndk6z4M6NAnxt+fr/xrCo0W3VsH3lN+R08Io/IcA+r
         78D82COypaYEQem+QPjd0j/SnK4jDT0Df2oCIr3AzFV/0Sev7DLO1hZnvGN4G53gpSv8
         wkxg==
X-Gm-Message-State: AOJu0YwQWXFUKqSPbxO0BqEl8YkK+UWWJ4b8L7IUgHbC+eHAIoHCbESA
	fIwfR1XcuCWzG6knXbiWhr5MRR87vE41VpyAGqpPeyhyJb1ptyV9PnYfgpQeUU4=
X-Gm-Gg: ASbGncsDgPOTkLQaf2bBh52ObLZ9Mkna6Z4hYQJP9uVjVfWHLliLRnCT8rHLLz5QWXc
	gCXFS9ewL1mu3Wn1BCwo32AVoyJrXTGjVK+HdxtENReOsvkr/GuCVpKFBasTGK26UhBl8RQyKzw
	edtEPgo78z0f5WtzUmfbfvH7ZOw1vh49iu5WpL1mEYJYPv2RrrFOAjONhcRlcDC6mg7h1vISbcH
	EmgV8WpAJBkMoO+VSnf3vmmbTlMhLcEe4gi39TG7dks2ArpYwy9f42gpplZ2yB6awBCVEo/tHjA
	9jsv2dyxnYiiDaAMTJB/rIgxQODis6OFR/QZ
X-Google-Smtp-Source: AGHT+IGYWotOFGyKz9ftjHFF2iZ8yrfovvsX1YqrefW9illRRiARYFLhIqcWOCsOIn5Zr2EynOZ3XQ==
X-Received: by 2002:a05:6e02:16cf:b0:3d2:bac3:b45f with SMTP id e9e14a558f8ab-3d2fc0d9638mr14385945ab.4.1740440046590;
        Mon, 24 Feb 2025 15:34:06 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f04744ba1bsm131759173.25.2025.02.24.15.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 15:34:06 -0800 (PST)
Message-ID: <8685f243-b3d1-4ce2-bba3-8e9cd8a47caa@linuxfoundation.org>
Date: Mon, 24 Feb 2025 16:34:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/140] 6.6.80-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 07:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.80 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Feb 2025 14:25:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.80-rc1.gz
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
