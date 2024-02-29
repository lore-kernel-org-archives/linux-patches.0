Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD85178261
	for <patches@lists.linux.dev>; Thu, 29 Feb 2024 18:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709230555; cv=none; b=bbaqoivv/njTQ0cQtUDVnkFClNsAIli28NFUOmY0R4buF2UiOgo2jxnLpjO8fxLo4T5BIhEJIYPvdlolWkEf2GUuSpw3fvrpszf+m8qzFDLcYk5dsS691pEJXSIsRzDuJzg/OnxImo6trDmNaIpTG+v0WbiDM+Z/28Jgd3ZwsHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709230555; c=relaxed/simple;
	bh=COo3G373l+Iz+717JUiLnEmx4+RH+rBRTGRjnlnmL44=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KS097MKI++S35JaXuYgpVd+op/nDcznrbM2HVCY+JppwtVOfIVTTUfAWj7tOLoq8zLR7VlFX3f+sTgcNxd6SjGXc/1Q5D2Ndh38sHwyvQX0WAV9J4bhYtfjAHmjCPjJHgm7TqX/a+2DSak5tzNJECHT3YglLa1f1v8R3jjlpIsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XeaIB1Yx; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XeaIB1Yx"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7c40863de70so62459839f.0
        for <patches@lists.linux.dev>; Thu, 29 Feb 2024 10:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709230553; x=1709835353; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=p/l7wuwerQx+PxQWBuAAIrGrI7y+fDmA/KYc8Dv6blA=;
        b=XeaIB1YxyGKLViB6CvlzPsBdhZCp9FrIvVxpvLDXyeCSWlb9vGKRNVU9K5fUdiiSn0
         RtXJZi1QpsZ013orHT7kxo3FC/OdqBn5LgG70nigR5Z7sc30s31n6t7IZGbtf8XRUDsh
         bO3hcm+TvJ1Nagpclrr0y7LXyqjL7aaPzn7vHcR0MmTXzhcuHhesKnxr5NU1zn2eukPT
         57UNQBRyiAD3CuMUz19WUtA92Q7miE3xe0CykhdKQbOggIBzme00C9NZlhDSrYD/EANo
         M7a4qZyZ7uROJD6XIAtwUvpCYefC31Z1MdaYnBy1XANcaZ5TeuC1LmTnZvSJuXcDpuYG
         LrYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709230553; x=1709835353;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p/l7wuwerQx+PxQWBuAAIrGrI7y+fDmA/KYc8Dv6blA=;
        b=f/ZQBewjw97Szb7HbPQU0UhnedWEqJKfzPt1WQyXv5vWqVFx6g7j+/Q79htaqYW0WO
         6R6oVqEeHPosFIzYqA99cqLgtIm8ybNw6VqrIum9hhJpogP8GWkrXnKiNf9z03u6oQUi
         iplGPBEkcAtqP+l2Hl8dUTb1Mqt9K7vI+kPRtfPrbJt7l9towfaXjsr4hprFtIWZ6FHE
         Z5UcvCW5mwfSaABie0kk4WYKCXkdKvJahSIBAb9OkurODORyjvl5tm8DW94CgBoxIiRP
         j0Vewie4CZGpSOyaqCDNGLFM6crdeT9Bs/FZELRQ4n2Hkj/shWc6ejNK4PMrhvqEKSNL
         c94Q==
X-Gm-Message-State: AOJu0YxDm7j+y2GaMd2N8EDunO6iPVSUM1cO388rQA9yroMDbymHrNuG
	hA3Rf62YAKeMlHK5Dm7238h3Cs9IBKApeloMof5M/k1Yxs7uoQ1v
X-Google-Smtp-Source: AGHT+IG6uA4BRrA6enQQJhJ39hOePhadyZHZvqMo8a/3FRtiMAeCcIjgpc/fCtzRgJEamSoqP2d8cw==
X-Received: by 2002:a5d:961a:0:b0:7c8:729:69b0 with SMTP id w26-20020a5d961a000000b007c8072969b0mr3052292iol.3.1709230552746;
        Thu, 29 Feb 2024 10:15:52 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c59-20020a029641000000b00474a3a31ef8sm430038jai.60.2024.02.29.10.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 10:15:51 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <03a17f2d-ab8f-4241-8912-ebd903fb2c43@roeck-us.net>
Date: Thu, 29 Feb 2024 10:15:49 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/245] 5.15.150-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240227131615.098467438@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/24 05:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.150 release.
> There are 245 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
> 

$ git grep dma_fence_allocate_private_stub
drivers/dma-buf/dma-fence-unwrap.c:             return dma_fence_allocate_private_stub(timestamp);
                                                                                        ^^^^^^^^^
drivers/dma-buf/dma-fence-unwrap.c:             tmp = dma_fence_allocate_private_stub(ktime_get());
                                                                                       ^^^^^^^^^^^
drivers/dma-buf/dma-fence.c: * dma_fence_allocate_private_stub - return a private, signaled fence
drivers/dma-buf/dma-fence.c:struct dma_fence *dma_fence_allocate_private_stub(void)
                                                                               ^^^^
drivers/dma-buf/dma-fence.c:EXPORT_SYMBOL(dma_fence_allocate_private_stub);
drivers/gpu/drm/drm_syncobj.c:  struct dma_fence *fence = dma_fence_allocate_private_stub();
include/linux/dma-fence.h:struct dma_fence *dma_fence_allocate_private_stub(void);
                                                                             ^^^^

This was introduced with commit 4e82b9c11d3cd ("dma-buf: add dma_fence_timestamp helper") in
v5.15.149. The additional parameter to dma_fence_allocate_private_stub() was introduced in the
upstream kernel with commit f781f661e8c99 ("dma-buf: keep the signaling time of merged fences
v3") which is missing in v5.15.y.

Guenter

