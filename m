Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F062E03EA
	for <patches@lists.linux.dev>; Tue, 12 Aug 2025 21:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755035245; cv=none; b=nJcxEhO+kdYDQsDSOZmSVUuQW+8xP7JwN+zzxyEiETaECOq8dF6dqcBc1WyXRcK1vNbAXCC2BMaveveXvthHJJ01CpjowmNa8aZocc51vmzheKGP1LoU8pV+YKSdUY+n2Wmeyu1trw4JNwvDxzu9RYl0O3mYJb3DvX7UEQTDA+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755035245; c=relaxed/simple;
	bh=hsaqDC8OPPR0PygLlB4gX/F0Mb9ek+K2IeeHeAGzOek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ikolF/sV6yPF1G6cf51yJk3NNwt4dEFstueSnD+nfhRr3NuZ4UhC+j+RlcJTFu7eYuPLUEj+9AKI31H1W0kGLQS0Q9QUbbLdclSGYrHvrxZYnAiA6aTbvQFejR8Mqj6VjB0/9g0PVPaemFEcHu+HEM564pD3WmNuv0pWOp9T5yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RQqVd0jt; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RQqVd0jt"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-30b6b801f4eso3146701fac.1
        for <patches@lists.linux.dev>; Tue, 12 Aug 2025 14:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755035243; x=1755640043; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DqsZo/0V3DrbiFJ1KYNqTCoRcndCD+0Zay74Kd6rwzw=;
        b=RQqVd0jtpy0viwIZYafd+VQBpHvmwZJpYvUEOIAtsaC9dqE9hlyL5AyWfDAHYCvmQh
         tPxRPcPRRMgd2bq37iNtXq2BfjmXOuFGnGZF0pgUeox6xhTpTRuYj12PwW2CrRXYV0C+
         3wKbJ4wX82XboUqPvu1I9E40A/DZGreNp8oWM3AzoaSR3ovCI0JduwetMRqSK81KreV0
         uZUDbmnuV0310dNIg2KSestuf+dQmnTjdefeaQGZSB/Cv6We/njpfVTQC6f9FoFJ6hV1
         evxDskdUiGiKTluJbCh7ABSDZROAinypBXMS50oOZcBQZLW1Pnb1PG4yEo7oaE94jNLO
         /flA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755035243; x=1755640043;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DqsZo/0V3DrbiFJ1KYNqTCoRcndCD+0Zay74Kd6rwzw=;
        b=ECMrAiGNtG8EtCxNxSPC3Hi6V21XT6p5biXiMtK3Mva1VWsLU0yZvNA4TEMnYAsQEu
         gm1ALA25SPGkPQ8WS486s54w/vSRf+8pUB75kwv3hSDkWSh+0E7BuTXJZ1BNZQQ+GSan
         mhP1UZ8tjZBUCLykVtYBg3JHHl2ogGuL1uIrWDZIsXwjoutnOvzMS2NDUavpMoSKbVr9
         BfO512exyah1rUia7ga7pTSS/DhF5sgW81JsE9iG4WwDX3qj7ycbHyNiVFyKiTQIMPR+
         +nTQbB9yGWPTgrng74X4NWmO0YtriaTsXoNt+gtY3thrHUNA+yAf50n4T+3p/OiaEGx5
         7mqw==
X-Gm-Message-State: AOJu0YzyXG+XB000N21vj4fKO/dQ9jzJXlkJ7ASoYGGfpOjJzHZYZ1PC
	M8VVho7v5LwT5CN8ugXgJQvRIRr/MlFhri91nenOuR/6AIFS1aLrypZJ
X-Gm-Gg: ASbGnctM8H0RKkZwM0scYlJ5tYIF7J4EhPEN+0U7PKDMnzM6PYYewGLt3E9O/j6o95/
	QTqIu1Zjs+8oNy1FriF/X2PjLZeIJxH3AHO8J/IsKRFS7xZ5cw+RKv6TR2AesEfzBL2SDqz61rP
	DunRzNbriHfKaHKC+HtxBPZSrlYvzIB2ldNn84Q7pvbi8CIWkg3+ySpimHhcuVuZwkQ5w/Hysr4
	zMsL0+pmoC/V50v58OdR2ikQS2aueGx+3D5nOKrnFmQGvu2s9NVqSfxSnKnz6M8r/MIyLehOUhS
	+Xe1B3x4jhx7Y3b1kqdLDsbnr7QYRcpCgA3Up5UCJxeGk4IamuoQr5UtbieHnZHJZO4Z16v/lgN
	QVR98wGQ5hl5MEc738erPk6o+w4GDM6RcLk2MgZelnhsh
X-Google-Smtp-Source: AGHT+IF9cUjsSFJiU6UBtafgV6gmnJFu9CkOBo9dXkRHbMOqAhT6sVwBWadWx/52BAuh/XOo7q6kng==
X-Received: by 2002:a05:6808:1821:b0:435:72ab:27f2 with SMTP id 5614622812f47-435d414d2f6mr638942b6e.13.1755035243255;
        Tue, 12 Aug 2025 14:47:23 -0700 (PDT)
Received: from [10.236.102.133] ([108.147.189.97])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-435ce8efb8bsm372942b6e.36.2025.08.12.14.47.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 14:47:22 -0700 (PDT)
Message-ID: <d114cdf6-1aaa-4489-a75f-c519146dd371@gmail.com>
Date: Tue, 12 Aug 2025 14:47:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/480] 6.15.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250812174357.281828096@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/12/2025 10:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.10 release.
> There are 480 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
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

