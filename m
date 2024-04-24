Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0F5165FDE
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 16:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713977886; cv=none; b=gnhEKn+1XQQiYu1WoOhpVYb1OidpG+tFp/OcmZGN2zk/X9TO98zw00hUuQbw9eQzNF8Izj/AHolNUZnapiB4XFdyK07s/KsvBgal9n0tZCjoIYWdSpZ5vbE+bZnTFsgvqzdmEFTmDDaD1huy9U8ZzBimvLZ/AtlLMh8DsgK3vPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713977886; c=relaxed/simple;
	bh=e5ZKVeNtxf1w8OFUtdCpUboS6VVKv8i5GD5AF/b5/kk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pLJpTEe6WFf8bQ/Ij62whRbcXdC3A/leoWTAXrSOZW/sa5X/dEsXgJqrnYO5RxWifsGZUwunZQHI/Iziz6/gI4dB/ddrBIdTg9pPgshRgu3tXproI1lXjknikTqjGs8eeecjQMjpBy6HduswtVEO7qZdDijPfTr06BAlO6hA/TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aiV7P5wq; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aiV7P5wq"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1e651a9f3ffso153595ad.1
        for <patches@lists.linux.dev>; Wed, 24 Apr 2024 09:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713977885; x=1714582685; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fsZtiOHkbqirmmEckPSW+sQ0iABPhXuSiVY+tOMb7CQ=;
        b=aiV7P5wq/RoKjDo+c9R6Z14d7WMQOJ3+Qc0OUD9jRW1uyQySEJH3BUByiwCsqjqHFo
         bT+whsFc3Jv+4GxM16W/+fbVptDCBgzw2TT5TiMF/8E/NWrB9M8Hc67IF9xcQepF39FW
         cgk3GBKZTP+pr6KwmWsAvOpDGXpUeMOp8QFJVrNIf1jDwNSjHwhpNelGoyZXT9bqxlmQ
         ImGBbi0qp4xqHvLMtl4JgYfJOjp4BNiTfgiyLAWNhdAISmAtBoQSwG1wKN3yAeixLoD4
         t8BlBj8RcrnQAe6AMm8WYlIicKYugubJIr3evTPAjPA+UYFOoxnuteGQKsmJATEoyjDx
         PfYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713977885; x=1714582685;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fsZtiOHkbqirmmEckPSW+sQ0iABPhXuSiVY+tOMb7CQ=;
        b=VHF5NFjZs8qtkqclD22Nte4NW0swyZsvXmDBjnJG3jCkQYdfdieLZhC8Z7mNRbNMn/
         uFn4snM0Ah2e23rgZTuG4SSXXcTdQVQRcQuLFbvVOPr4b1/gxm50TYQIxjZu2cC6dy3r
         I7fcDiQVRGs45Bjvod46VUp6CSnKYnhR0oc+D5Xnx0klF+TVQAz6PNhtKsZ1daF5qQ5A
         hNQ+GhvRkzTPZasahLEkWHc3PnxRCjad9OwUQsTzGR4APUjixxJDGLhjM1Ztce7xKE2m
         LmtplS6yHG4Q4xZFrLSA5S24PCHxXj0CIdh99+Tu/RDVjG1brlmV+J9pQzc0IlOYIDVa
         1nBg==
X-Gm-Message-State: AOJu0YwKv2vVM3Q7y4/ngqUrIPyBUvu43tX0UEo0323r9H/854AP4f1o
	BMrSZ1ZDv9CscEosG0S8bRZdrZEUhRfSVu7jxRQiss970kVprE8c
X-Google-Smtp-Source: AGHT+IEDAmLGW91gRlRzuilWNOAMiR2h1TzrI0u2RLbDoGK1arYKxFN5HzbL4kNhu4tg8oYNanSk+Q==
X-Received: by 2002:a17:902:b587:b0:1e7:f944:b000 with SMTP id a7-20020a170902b58700b001e7f944b000mr2792857pls.24.1713977884786;
        Wed, 24 Apr 2024 09:58:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b14-20020a170902650e00b001e5e6877494sm12369676plk.238.2024.04.24.09.58.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Apr 2024 09:58:04 -0700 (PDT)
Message-ID: <380cd0a6-0fd3-4200-ba43-7d3b92b894c2@gmail.com>
Date: Wed, 24 Apr 2024 09:58:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/158] 6.6.29-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240423213855.696477232@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/24 14:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.29 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Apr 2024 21:38:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.29-rc1.gz
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

