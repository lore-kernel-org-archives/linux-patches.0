Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793288057;
	b=BuZZsXebDuTrbQlbWUCSi/gLl59bmfU0/YaIFNDW798sircHtIxk0cnMhSnqCCo4zaC8
	 xoFzbZUTh1DwCLI5je9wN810V12Y7LQASxTTXwqe8EoJgOaVqvDqsSCJmb1rpeFFENw6g
	 pDhhMemQ/+i/H3Vf5//gAUNfBcEJ63YLk6P1C8kv/I6WDDKk9WdE04uvI+Ke1n3lA21Tf
	 ILFSu9KtIWvr6cWj4cpuyMhxaf0//K/7y8J2oyfXQY3AIXVvXxdRV5+HChk4NOMPAwepz
	 Uf1PQMpxwdu3i9j5aZ6A0ypHX6DNpLJeCcgTFGVPXK0OCmztmAqp06oW8MSeGxpbfGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793288057;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=2V4JLnzK67IJcCHq2My/KdT+6D1UK3FIaHGDhvNAL2Q=;
	b=244PUrhB0sO3840iIilEtZSldmOZPct1E/WW2frfA/vSjlbvRhraC/UfBRwkSY4LpqYm
	 zzKwuyVvSAQOoHdz0xP/ZEA77f7UcmZ8KkP0/pEPfxYlwmi1ohoXWQxN6s5Zn+y0+7Q6Y
	 Ecjs0soaNP8Lx6alv6QTwSTOVTgZ7oAkmmAhVLxXA2OnC3OaLmP3BdxFOehyqqSfkMQaV
	 G5iLyRtp2lLTFwUrJJlD1hq/aMsJfXaZPGghoeZL+iArlz4HIOF+Mr/MgXNGtHJi4r+f7
	 TGO1mzm4K9sc2J6HKtaoVMmZwUoRV51uR0rfr+6jGT1dY5s/U+T2E9Os1LlvSBgzk1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=Nf85amXx;
	arc=none smtp.remote-ip=209.85.161.47
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E57C606A31C
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 15:34:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E57C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=Nf85amXx
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6fe4372c5f3so1534936eaf.3
        for <patches@lists.linux.dev>; Thu, 29 Oct 2026 08:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1793288055; x=1793892855; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2V4JLnzK67IJcCHq2My/KdT+6D1UK3FIaHGDhvNAL2Q=;
        b=Nf85amXxvegY4dWc+hCk6z97Y3xy5eU+Lp9pSCMUQGS6X8xVSrA8N+z81Dk86TqZBL
         8/Wrom4oqBHRuB7e8vC/odwYOls7JW4NuNTfhlJj+0Lsd2McUMmpHssyKICiX1zfAqom
         mUFkJfD6fgtuJmYtWIp/QAjoO5k+9/huLJMRM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793288055; x=1793892855;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2V4JLnzK67IJcCHq2My/KdT+6D1UK3FIaHGDhvNAL2Q=;
        b=hrDL8O2Qakh1sm20EivqNUFrAv0aLIg9ts0iw341wCVlb+YhH2RjvpOX4ytZeCWNW5
         5DgzfN1jfOmhxqJ8XHmu+m0r9kU8Hq0LXWYkpMm6/MFujQ3nbBNo+RoXv/8bNZUwfT6j
         Axmt2RdnqTpw0puaOPjA8ihIqlbToOUnmvadrWpGdGpSGhKrEsHP8I7OuWZTbeEQ2Nsp
         g42Ov9xmvGRYChM6vVuGbY7KCo2L081IIkP8ssUVTsLwD7xfMp0XEXgud64uIPhV/4wF
         hfqdYByY5xVGhwXOt/LPyGux2aIm7QX55TCZNHgccjRMQXDBCmy84RC4STw0E25dO24Z
         as2w==
X-Gm-Message-State: AFq9FYLk7Yslvj3zYWIR2kRD5ATgN65ru/W5fuUVJaDp8tnIQJsSLNEq
	TK59G09SPUF+djPAgJQAb7U2NAVX61t6ydAjE2qB6GZr3xa6hvhDhs3Sx6MkyYZs38Q=
X-Gm-Gg: AYBFou0LEIZKaQoOz7UWG6OXietlpf03P+dxG1cYuN9FAhWpvxmO5zgmkB9oe/1aajZ
	ChdYxyGWuR9TE6afcl6a61MYki/kK7lokTCMwhrBeaVRKDYAdlSkdRmNnn/3gDXafL0l3A3UzDy
	fInRNTm94cIKdK8LO5HF/V1EO+MDGE8CdbgYkL0oLEPRB3+ey1x1P0gTcaCUqbeabYgWtK6dhT3
	sqvlwW3UAEhJnp9nFIXmi624hF7hH4JD3U+/wi5kNdfdOB10xkYI3B2G1FjmVPiTFHFAIWT+JYg
	/iQ5JpSu1qhAzCqk8RMbTnqg+9iYC5sPDXNEHNHBUVszsYDIQ8T0XVf0FDcy0obIsDzLazHnHvj
	QxgNHNCAbU0DjfaswU5eOj2jLHfGPeQD0Z/1VayYb/k0e8so72A1nt8fl0tzdOaMy8FIcNw20aW
	N6Rnu7a9nxLoPep8OFMGJYFKE7HqhnWPAAr0F1py6ZCWM+hd+gtLYNXV6wvXNEKPE0y17Scfigq
	OwGXyrQ/WAXCQBxjAiaVgn5Q8fEV6LN9gAK7/B1np4g45u1PwwP3SXx2uZJ8LBmBmGSsqyqpqC7
	o0p7AsxofidW6zmpCWaubYDLFw2rfdxqWjJRuQ==
X-Received: by 2002:a05:6820:7093:10b0:6d8:462d:2759 with SMTP id 006d021491bc7-713ef924163mr2829588eaf.90.1793288055258;
        Thu, 29 Oct 2026 08:34:15 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-85d3400540asm79447a34.19.2026.10.29.08.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 08:34:14 -0700 (PDT)
Message-ID: <03dcc5c7-5d14-412f-bf6c-723af54a3b77@linuxfoundation.org>
Date: Thu, 29 Oct 2026 09:34:09 -0600
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0000/1887] 6.1.191-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 10:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.191 release.
> There are 1887 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 17:02:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.191-rc1.gz
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

