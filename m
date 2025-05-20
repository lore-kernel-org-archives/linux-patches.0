Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217FD1D63CD
	for <patches@lists.linux.dev>; Tue, 20 May 2025 21:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747775816; cv=none; b=RB/eR/XvW6QLrvWG5fRet+Xf2sqOTe0HtWZ3Vg13muvhYB1zCNKw30zAIrVEVrOoSLlkSH0MFM943jt+iNSR1x6zpaPKQs8lJYLVfk6PFLrNj0a/MI2O9y43IrMP50ZOpotc/aBBtjfeD/hLT0ZNGQ0JfmEeFrQ2pIWvy3Etp7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747775816; c=relaxed/simple;
	bh=tmAXI5Vz6kKlh04iIaEoTryqP3ZZCQEc8B5PrHjzjGw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lOT4oLX3iQypuc1PeyfLhSIvMcZD5rA6zLjZjw1+E07kVmDi2nR4wDV5iQClTnM3R4whBUTjEPLYKM7YFropNFUM3n7eVkicEPKFZRdpfuxnYRxbmI4qvK6TXpWjzMFFtsH14JffFYoQDpU4lC4hNjrRvVAJZfpWj/TKXzlyfVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4gokWwE; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4gokWwE"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-85b3f92c866so175464539f.3
        for <patches@lists.linux.dev>; Tue, 20 May 2025 14:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1747775814; x=1748380614; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yGTzXh3InLODqO504vLG8maKIJQ4gfFaDVwDUD+ra6A=;
        b=Y4gokWwEqQVUo890TIfroy/oujTxxKpcd0RtrrOMLkT8pN3luxF1Lbc7C4qGeFsckv
         0vVulCpklddiTeDFLk5yHPQF0qWU06ALPr2bg7GkBuASsLBL1RgkSIiPdYo5ZLseaql5
         ZmMNXBB25KWhSdbNGUuw/qdUTksSL7Qq1Q8lo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747775814; x=1748380614;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yGTzXh3InLODqO504vLG8maKIJQ4gfFaDVwDUD+ra6A=;
        b=h1eLRGiNEYbMHHAPRvYcop32mP/60YHJZcuypwMpSt2fTmIrjPLLlFdt2gU2VNrwLI
         wYqZRmsYNg6WxFe+xIjTVl3rJdrv9o06Q+JErLxs6fDNPeo6ZXJ9ImcJewe/ZbsBXE6L
         N53YYOxmriJBgIB1BljNG0OBoQ85wfhd4Vde+qXkA4osImpIDypEyNB5rbYnRvL9+NH/
         EpCsa3LKRfNFvBKoC6okWB6DUfRLwLhfruYZGN+Jwhsax+o2rzc0nTIl41b0kEKEGE5/
         S3w1x2eoyLGVDxLxMD9PXvWCozGF8Nd3W+eCdqZrlbm0kIAkW32Uxb2jlsmfRsfRc/k6
         Xejg==
X-Gm-Message-State: AOJu0YyJz3fWuLkNccko1OzFl2VpGSCPIMBtFe6Ru1IwBCEetpEAcd2/
	rQ1tou09BSIQD7EweGvQPN19PKBsn8c4HwganWOTFukjjGdUo4KcaPxqEBsEOO1Cm5M=
X-Gm-Gg: ASbGncta5GyUSM7GZWvmxB45XnmRNfggct2G1qPzVmArDMOeZafEIWwOzZpJZD91cqt
	Yjh96orP/amB/W92lu2PQE3kM4+aYeJECOBxg1diMF2VTb2buK3+vcy1mPcEoT/rRxJPmoxKsu+
	gRI4yj3wPgrbEsRewvJ/A4HYNIfuFAUKlTjjmZfdO+TETVI5loEN7ASodxp/1qGQTPVI7OSGyLB
	r4UFTG/av6hkogObGbi5wc4nPN1fECDHOWUYr3AETXVeSJyj8Y+wg+cTR0MaFjpxHPe8zSjgJLh
	Wuj4cSHT9ZPmbuoyVtxorUFg4rHMQjwijx+oPONgMFsS/zPcSEhF8amE6DOyrw==
X-Google-Smtp-Source: AGHT+IEMRyI+8zulQv0se3ozP6ij1ybvQAhG+E/hVHlSg6txJKueo5YQaKNLbqitTbAHP3RIFXXtIA==
X-Received: by 2002:a05:6602:3944:b0:867:3670:5d49 with SMTP id ca18e2360f4ac-86a24bfbfdcmr2441929939f.7.1747775814121;
        Tue, 20 May 2025 14:16:54 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4eaa3csm2357278173.143.2025.05.20.14.16.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 14:16:53 -0700 (PDT)
Message-ID: <010b13ee-d640-4563-9215-a78c4c4015da@linuxfoundation.org>
Date: Tue, 20 May 2025 15:16:52 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/117] 6.6.92-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/25 07:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.92 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.92-rc1.gz
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
