Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C95D1EA90
	for <patches@lists.linux.dev>; Fri, 12 Jul 2024 17:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720805178; cv=none; b=BSWIeILMgb0LvrCsH2oMareSWdMkJK7Xm4sV48ZGeAdp/fDTOhmcCpwhagFXsgEGXqqvqieT+Vtph0zoy2JUpsLQWcIv8v1g+EYn2YRJzXUdVFHmdpcM9TZm2E9j21riRzwMwOm7e3s02fzqgkUziISsw2OspzGRCTtl+dY5Bpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720805178; c=relaxed/simple;
	bh=/VjqO/3zgNDdhMTYe4USUSkjtpPhw+zF5KO3FgdK6is=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rJuTCLqHTZ678rCpG735qLdU80F/3hWc78EU2u3BNbE8UXueXX72axmo6YWTrFWqm+XEvHZJu4Kb/EiGiCCS1yCoiYLezQ0nw8Gs/nlTN7tyHt+nl8T5OPsm3eOtjszE+rt4+6ZqbgOT+vRJ4HR7ADshJLVJvcaAW5DNEvCmiKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M0Pq3t4P; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M0Pq3t4P"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1f9de13d6baso18034215ad.2
        for <patches@lists.linux.dev>; Fri, 12 Jul 2024 10:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720805176; x=1721409976; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XSpJ3GhelfOwQSGbY8nRGIriyOJSpRVJlayhSCxpKeA=;
        b=M0Pq3t4PJ9GsoEFWNKC4HIn3B8xGsQqfPphLGEyxNHq7tVDO/FoKJZistfgcZs/TgB
         rp+WK6orpAeglh/OcKQvr+viFG4QisXIum04WIWvlWuHdFjCNp+Ff98AGwir3/70KGg9
         zOlpVwzfa1wt1+cTerIC6VMATK4yogxprKnGNkVXyTEuXKQK0tYcVhzP42eUdWldXkKM
         RuAme/iGS4ST7wHPQeWwY5F7djpMlmulvfEySrbwZKwNYDGCvjir6v0os9zUdpgC1CuJ
         aQ+z4R4yqfi+jj+lEYYTbn2olX7K2PN996vkr1KQKuSUmLQkfJt47Iv43YfZFmBkHdJk
         xhsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720805176; x=1721409976;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XSpJ3GhelfOwQSGbY8nRGIriyOJSpRVJlayhSCxpKeA=;
        b=dLO3qALTr6uZTlN9vy0oRkBU5qXWxNaVZQLNSjdQ/Mhgt7d7g5jp5R0GVNRjpp6Np2
         gMDCeqJsVDACarHM4KpGz3Nevkxx7cJysIY1M2mq+Uqb+xVrXxMy0C1RRZxu6hQVBqyL
         3rUKMpN0lJROsqNuPkIApX4xyvcNP8egkoled1vYFxHiGlsH0z70/E01phfdfoMMvirH
         sOUzuPR20Ze2ibRrIDxfsPSuHAS7SDv6UxGYWti7qB6hyZmfTZWqLeI1D+QvS8Wcjkek
         TDdeZeIDg82nr9tpikXsJamN4M+LJzam1acGhbRwi+Ov0uDsNPQ7KC818eokIrnu5vyf
         sDKA==
X-Gm-Message-State: AOJu0Yynaev3532JpP3WhB0UTD3pDH1F7I8pTrwS057H/TT50tOplhNh
	UDQKU1a+tleT9DXVoMJ73BU8rLka/JjfgxbLBWCirU8ZtDoNgA0C
X-Google-Smtp-Source: AGHT+IErfbWmHh1GB/4b1sv1DCFWnYZqR3hDLlRsz4fkcPL5203zFPWukODV0KU23ANjTwLjhdLrjA==
X-Received: by 2002:a17:903:2291:b0:1fb:5c1:2681 with SMTP id d9443c01a7336-1fbb6ce1320mr120155055ad.21.1720805176195;
        Fri, 12 Jul 2024 10:26:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-1fbb6ab6b9fsm69708425ad.138.2024.07.12.10.26.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:26:14 -0700 (PDT)
Message-ID: <ba6cea8f-85cf-4248-a373-b761629a7e3f@gmail.com>
Date: Fri, 12 Jul 2024 10:26:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/139] 6.6.39-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240709110658.146853929@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/24 04:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.39 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.39-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

