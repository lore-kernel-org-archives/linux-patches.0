Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249F221B182
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 20:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753908820; cv=none; b=FdsdUtMe5qF7PkjUTFP7J5itGeM+Tp+rEqiFW2DS7ircmYmrLaj3jpOTsemgiJZuXVM78OMUE5m/g7UhG7EZU+eZiaOsrSa9o6NULAmNSPe1iDSOpZhqnrFuN7zgZ4vLBB5TA7GK8ULCoWcGEjeixjw4+mok6BvwPUYGgEf1poo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753908820; c=relaxed/simple;
	bh=n7aPMwh4cnGZD3nLxV4Huj267B+JgGm5eIqZlxQB+fA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KVhYkKvGnwBT6PxeuZQCWfRTECdGhCpd/Ddf4DU5UkQQJp3rVzCrxl2/GeRO75MiW2WEEA4x8RCqsoqN+3s3hLD8QKKLR/ti+rQa+T3u4hKi8fnsVpycOF9gn6LlNJlgkObqZhOmI0IOAnqH03Z8Q9Ks/UYLYTo/0LjGRwPUpog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7Xq17xo; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7Xq17xo"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3e40050551bso1529615ab.2
        for <patches@lists.linux.dev>; Wed, 30 Jul 2025 13:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1753908816; x=1754513616; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TvlseZLHeeF6YAR9S3/qHnVzi0UmrI59s2OOwlGbvPw=;
        b=R7Xq17xoTRgr4JiJj3hygAgHN2O4LsZ/I5GSqjNDIbpRoUMk3kWAmJ5XEtrnLAvzza
         Qe6at3IPzK+NmOelwPPjRegY53abGQfKYor0nOiN05Mc1yy338lUy4rnMFHRSXwiJToZ
         piNHFlb8ze7iR9V0Aq1XTDjcbAGCifB2iBiBk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753908816; x=1754513616;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TvlseZLHeeF6YAR9S3/qHnVzi0UmrI59s2OOwlGbvPw=;
        b=e8bwh3v7/UY9XeGmbCnupHpYhRAltDd24GvjkkShtOtv7xb0PtKro/I7rWHx7fsIID
         ZSz64sYGnIyo/+Wv8jwrDToEjiN3ena3DCEK3asg3yZL4ziyjk1v2MiJoC7CQgLbPgqa
         azq+SxcSRKYsSLwZ2R/Tfl5clTCfZico4Eq9V5C+m32cQj79G7FkQgiwTNcIomhfe/kr
         5EiOurDif2qz6y/epUDEwTmM4swbvgAIAp90RZLMolji7wH+oxYSTkf36T8jN+LPNP0s
         qok3WygAkCR380vUCRSlohwWpJwE/g6nQNJXWddu2it5+dDWoNnromAef5bolkFR8t/d
         6+Pw==
X-Gm-Message-State: AOJu0Yzb6PImybzrNYf91oyZhOzUWshLXuziUJ9kh/kvz+dloSWRa3xh
	4yHzW3Uj+lnONLio4nQsD/LvYOVfmP+TmPY72SaRipmYYrxfTkRKYJagFevzrXQyycE=
X-Gm-Gg: ASbGncuwI43MHanmCJSbnFNxJUaulr8YduBhnHrCS9gbPb0Jacv8oE6Sf8oCDD7SjCG
	tRwwhC8PIHq3+iMfQCyAHddX+4W3HR8kC0zuUXsagTiUFc9x+hHtWZoCNVovNWHrBqsIj5ACrx8
	xjbI9EBb2EhnK8VvRjoyK4kXXw4rQ+US6ld/T6fwrtHES/O7aCbYwedHVWcWvbwsr+pcvIkZHht
	yeNhwYqYfRGrTmtyceSrU5wIDd5RO+RTjq5ekmk6rpcEkGYKWJL5UzYXcZnBVP85ok3eFZ2jmlQ
	30gQ694vH/Ryom6OOWSy54sWaA67JiKQjVXAiWnZSRqTMDmSO1KlRsayZaVL0DAnuu748tRTAlP
	brnVeMaXQD1CxW/Q8tEergFiP8SqdNI1BWF9HzLpkbVF4
X-Google-Smtp-Source: AGHT+IHBFCaotfb0CL4mgLRGNZuJ1u9L03txLX5ARtebB/M33t/uep6REz1q37wHqFu6wDRvJxAqNg==
X-Received: by 2002:a05:6e02:216a:b0:3e0:4f66:310a with SMTP id e9e14a558f8ab-3e3f624ff19mr76742445ab.16.1753908815891;
        Wed, 30 Jul 2025 13:53:35 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50a55da3444sm48655173.80.2025.07.30.13.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 13:53:35 -0700 (PDT)
Message-ID: <4611d075-1db2-46cd-8e93-9d25d27650d3@linuxfoundation.org>
Date: Wed, 30 Jul 2025 14:53:34 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/117] 6.12.41-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/25 03:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.41 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.41-rc1.gz
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
