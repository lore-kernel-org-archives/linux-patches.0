Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D45A159568
	for <patches@lists.linux.dev>; Wed, 15 May 2024 18:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715799426; cv=none; b=i7B/0FK0AWP2c9ZRUBf0kOYU06FOI2Bt5XNLD1eqae8naLXdTyj5dhW8BTbwFPaZuZVh/+SycSRznco1ND1K0hJVOdbi2A23rnFGkYBoywZ4eX/OW1CSSIj6nHNt4I6SNmAkqmIVAXud53GzWPepVTObb1VOTa2dRUpPgwzz+yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715799426; c=relaxed/simple;
	bh=U6QNWqrHaDjx5k/0VVV+rAKJx1AodK3L6iYTiYAq/8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZzVlUyjWxumSadXkDZcSwzHY2D+llaELNonN1CDoPSGfFg0b2suRuzX00M/hWFgnTEdYMPiHLpqXPrTbBEmvuy98JV+9F1ZC5QxOn1QBwtY80wdu9AMyvB+tLNKLAQsNu6TZwSGkkbJyBiBMf3pgEV+XzSDwl9o1gNT43LErz7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S5mzPr3K; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S5mzPr3K"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6f4e59191a1so4507149b3a.1
        for <patches@lists.linux.dev>; Wed, 15 May 2024 11:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715799424; x=1716404224; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VGfD3BKBPRGgjG+X0s3W41syNi/RDQiIO3WMxL7HGtM=;
        b=S5mzPr3KBdNJ7XmWiaLdav1nB+kQoc+InGUrC+Wes/A83dTRYaZf2S4nitMGnUOzWF
         4zNYFu9fFD+hKQPCuNGOrZQK9wJTTclVPMjT3KWwd3m/zAD67XSsvXSTKqH4Dd0mjlYR
         qzG1VZFXxosGbyDb63B7ZufxMSh3fDZgu2EeKPXtWqU5QsShwHt5TkjAFF2oHsg6u9ky
         8oPXDG+3EIW5yXKeafg5pbr1Pii+TSWrUYOTv+n8vKmeRyzSF/xlSSTyFae2cldX69MT
         OdUZmgnLo2BGO1BkywmO9DCYI68SR7YMxLmHA1SIvzYehKrxowys8dfG4Ye+Gk8kmTeo
         BCEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715799424; x=1716404224;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VGfD3BKBPRGgjG+X0s3W41syNi/RDQiIO3WMxL7HGtM=;
        b=j3Iftzwd+PLcF+TZ90x0mPmqtQCMXVvG82jdNmsP/FuS27Ndac44xIGu8Xhc6jJRQW
         x1pnCVHEvEt8ilmANPQ/b+aMZ3WChhQViwmHqaMgh9/xtzHJpAa+pVqRWNFgWMHucjU7
         AKcndBsJuj2rC72f+mymKbOCUVE+2h64yoo/8hHFPKSD5WfCDJVmecPmH2EQNFbR2mne
         pm4xKMbN7RZ19Xu7pXNkl533/aEAoOcvG9H1XeAU0Oip1Lr1CRiUAVxpfSI0dchT5DMC
         w/aVfXxpv7vUc0sP76WDTL6mt6VRDzqbUHJTg/8PurMFzlCkBFena+x98lUp72xpocuN
         jyQQ==
X-Gm-Message-State: AOJu0YxPl5iID66fo91rVf0AMT8nMNL2BgezdFqKQKcJagaXvCDZxCnx
	G2eSYNAQZHFrrN/B+Td4Yesyjz6InbdA4jCzAZTCGpfR2DZiIiWO
X-Google-Smtp-Source: AGHT+IHlzmXACKbJQgWGMcU3gDFefSiM/uoRJ8YLQfxc5H61GBO1gLglVc82KjByrMxWoXQutd87UA==
X-Received: by 2002:a05:6a21:788e:b0:1af:a5b1:290a with SMTP id adf61e73a8af0-1afde0a994amr19114043637.13.1715799424354;
        Wed, 15 May 2024 11:57:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-65913e309a3sm48260a12.32.2024.05.15.11.57.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 11:57:03 -0700 (PDT)
Message-ID: <2cdf39bd-c4a0-48f6-9337-73a00f765c82@gmail.com>
Date: Wed, 15 May 2024 11:57:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 0/5] 6.9.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240515082345.213796290@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240515082345.213796290@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/24 01:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.1 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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

