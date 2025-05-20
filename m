Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36302505C7
	for <patches@lists.linux.dev>; Tue, 20 May 2025 21:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747775553; cv=none; b=LBmbr5xyAGz17rfuk+puhwjDVz6Hhf1WQU5NaRGhEjyClBMKrh4F7Q7RYrr3/BWuQR2XyEJN0C9URHuGIlS9h1se8N0kPI0nILSIuvuzFTJ9u394LYdaq+BD1899nJEDPx4mZyedBjbEA62ywDxg9CbOCWuBEiicPlspRsZNtjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747775553; c=relaxed/simple;
	bh=JxHtbcJN/O4Vpsg3y6yxolxHrOTOCH+dF8W4h1Bq0C0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NEWWGPnZSkb77aR/IgVqdouYjGFVFu+MprXpuUrxA8nNv9IfNJsTnvWAOeRtZVzQcuonOzw1mmgUptZeQkIFtilUiMBZZ3tsM9XuJxvLGYRY0uX+JZCO1WzlwXhLyI3j/GG1hcn/bH7LLy5obGf/Pycp0x/TP6zM7oPT+FBnaL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hoegMAtz; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hoegMAtz"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-8613f456960so182140639f.1
        for <patches@lists.linux.dev>; Tue, 20 May 2025 14:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1747775550; x=1748380350; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KMrFfTENF4F3SCjFNJP/23CVdgvfjcCcQGdu8rVvJBA=;
        b=hoegMAtz8laJhDWjYHLvDbO9u21/zL2aPzeg4PRXq8oLchfH9bFJmDdLT7+hHtPY6j
         R3vXf0Jmb+b+FjlJpA/YEaJGdxgFIgMX1LzdOyj3OWdpjhzuplR9+NmkEigRfHFitwAn
         /SHe2m9SSMMEuhS/jabLXzkdsnnvSZ4FhkLRo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747775550; x=1748380350;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KMrFfTENF4F3SCjFNJP/23CVdgvfjcCcQGdu8rVvJBA=;
        b=ngf+LM+FqisyFAPcOKzolUFjB0UNDeWTyAG7vf2B0foaLkNyPgvPsJk3RaAOOWWCVt
         1ceblfs+456/bKf9PjrOYjrxKZxs8syxlw0NS/7b04+2etgMYMoTRcSxuCqW8mt0OFQF
         b6b9TeRtxCxeZrUHlKyaYDs5HtWhxJd5OFfkE6CLya2Di5zMmxUuYVJDHQFb4RTPfHli
         /m+Q9vfhxontDoqGYn7as3ZeLqzHCuDrF/7VQ7dzJJTIgRjmRqjA8cogIbTyD703yglF
         zTPG83hliXM/crr61etedJbJeXsGEQui7ubPOKot/+q4VTY0Yu5mBcFexwTLR/hDhaLa
         JFgw==
X-Gm-Message-State: AOJu0YwSPFOvSwfjS2ymKKl4S/eY6grb7MAXYtTyQkowZjjTtjxmfNps
	3/rwEHLXVHbTc16M9gcM/doE9xOzYWabb6KPaOZHaOfnfupcdJ7iH4LcCJr+cs837YE=
X-Gm-Gg: ASbGncuHSxciU/jCNLTnd7WKbI05155ekWkct6KVaVRe/ojsp6iWHzNWHitK6yIVzwm
	xSU4uiJeS9qEk+2deFAbfM8EXtT/AbYmjxTt1PTwfagulY4twQXzoAgwnMotFPLdu4z9vqs19ro
	qyxMJuRVfcbIwbTKAYX99WDDu588x14BWLYfsu2RcED0Nx1XFfzHnSUd5zj3DEAswtECbfHZliQ
	oRPhkGDCve2V20KRQJYnNsdoifiSIbI9+KJkPcHaew7vLm09+7CAQJ9KIH3YSZAGxwqFDsQqZeo
	+wSbNT2tS6OuLgQdpZbjyikcbYlEgmJgDR9udWFmluh/m16Xz1p4avnJrSWeyA==
X-Google-Smtp-Source: AGHT+IH1LDM15vwRPpbt5rCMjiAO4KoSLMc0NMXg9FmElbvwrQgJ4BrS4fhsC8wXOY8J96B+wGJ9fA==
X-Received: by 2002:a05:6602:3791:b0:861:d71f:33e3 with SMTP id ca18e2360f4ac-86a23199f69mr2609760039f.5.1747775549724;
        Tue, 20 May 2025 14:12:29 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc38a46dsm2397257173.16.2025.05.20.14.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 14:12:29 -0700 (PDT)
Message-ID: <b316a79c-1146-4bb7-baf2-6f0727f87a0d@linuxfoundation.org>
Date: Tue, 20 May 2025 15:12:28 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/145] 6.14.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/25 07:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.8 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
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
