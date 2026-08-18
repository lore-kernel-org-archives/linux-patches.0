Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6853638F639
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 17:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787074644; cv=none; b=n8NPsDk2Tet+F+wd3tt37EeaASXr7ivM2JRrPU1/VqqWBn+biUdlaRqZnpCGOFBW1JizMdXOOxXhKTGfE3hu9JE9OYT8icROOhWuVAyfSZnu3jZk+mp4ga7gwr1t8iVmUp+w5lVoDQENHYA2XfK91HwTnQZvihCB7fta80Zk1Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787074644; c=relaxed/simple;
	bh=g4igpkjRW/gzssrsO8VF7rAC1YOodN0DQU+YJi48h8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OMaM6TIkpJ7r3+IGQyOzn03Qnu75utN/DRonqdH5RcXgcjer+5yzeSKR7E6dY5NHwrTsw43Uz+Jus+48zk7d1rWvsRn17i/8CiD+ZMWDuvXIt9havmRScM+tCc5+IDXnvDS3yrutKuXfBRfZQl2N35rJVU1kvf+eCJkPrWK3mrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diTogcfT; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diTogcfT"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-4a43c2a126fso105378b6e.3
        for <patches@lists.linux.dev>; Tue, 18 Aug 2026 10:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787074640; x=1787679440; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pMas4PLE2VjLEhJFKIS7cha7z8zOGMsrrYlzGahYsx4=;
        b=diTogcfTCTLak/buQbTxq26uxefdocNDZlnYfTx7qvf0JrXCTWsJQ5mZCafCFUXbaO
         5/IwdLLNto62qUoV+ex+8H0GwnVAV3Sm6KRRIMWF7Ob+MFgIhij3H9Dr0vV+JEKS3wPz
         wO6rd4gPWgcFeZgM/8KwG8RUNkmZ5RjlReLn4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787074640; x=1787679440;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pMas4PLE2VjLEhJFKIS7cha7z8zOGMsrrYlzGahYsx4=;
        b=EFbqMzNOs0d6H9M1GxeFssxi2ePtdU4x1Q0s4xEqusvvmYfBX/qfhXYxFqYU+F0Vmd
         VtEf2gmL+NLWKSun+jwT/26VL0EFaSu67U3B1zVjxx1992Szo/sRuC2OKgkfl3+vLL6x
         tCJgj3UNUisaxi3x3FfXu7g7mFfxQ/B/x1zX+SQrmvGSQSbrTJmtbHMI94Tj4oY143/7
         5Zp1LQNykfx/uELoUicajI+Tehcz7RrQo6gzg+pQwbcbBpvkRczuHT1eRzqt1Rbppmur
         bS+2poDefT9ZySHy9aqU5uF82zaVLy+BDOqQKzxDCgnnr+yJih2QNR0F3qXy/LbU2rbI
         kxxg==
X-Gm-Message-State: AOJu0YzCUCKc5S/P7+jKoe1kTrZmy265Oyc8g9J52VP9Ktc6wKrcQf6U
	pzJ1b0G8fQezUMBrHYtofGkhGBB/5jh9A3cmKFAcSv/56V/BayeJAmc0GE1eMzoaLk0=
X-Gm-Gg: AR+sD12Cyo9Y8Vib4bQldOZNbRUE+xa87R85JItrlCcqpJdkDY6JDf3GqqEY+VjgxM6
	tvxcej6vyM5WYX4puzmZSVyMHN5+g9tYPfag4N9X+iSIsUcMkxPK+6RDxJrZOLwnfoAXdqDz9Gf
	ViPGgofxzWzWvyF7kBjrCNZuZNhJpWR4LQTrD8hVc8BQtko09O5+b+ttJ+cyeWBRsml1LPW++p6
	7efPWIG3SwjQyHKKwHwOZctYZaxrTF2hN9OY5Kppgky79BXGKwBgWSUbvvJs9RdAJ3oN/u2v33e
	VZqtxmRbSSgAzWS+4hzU5nudrn1Z4guqE3m6yHjo5IVmQhwnD6E4xCaCylcWYyLgE7innA9wrXd
	OWOdXz5bTa+uYxOytL7hpW60jex1y2vFnqA6e1R6jc/cIvxezET3B+0uhu87yJDAPilMCl9GAtt
	auJOC6Damr3hfYuGnyELZ4Zt4YnupoA6ztMggrmyqtv+NYRWt3FJxHICAIGFUBUi3X08ngeek=
X-Received: by 2002:a05:6808:220b:b0:496:11f1:f2b5 with SMTP id 5614622812f47-4b241e1589dmr34983556b6e.10.1787074640223;
        Tue, 18 Aug 2026 10:37:20 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b29609c26bsm3354116b6e.13.2026.08.18.10.37.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:37:19 -0700 (PDT)
Message-ID: <ceb0399d-fadf-40d1-ac33-e8552494838e@linuxfoundation.org>
Date: Tue, 18 Aug 2026 11:37:16 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/250] 6.18.45-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 07:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.45 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.45-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
