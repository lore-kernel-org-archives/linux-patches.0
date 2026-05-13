Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFE13B19BB
	for <patches@lists.linux.dev>; Wed, 13 May 2026 19:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778699352; cv=none; b=a3Jna+GO23zQQiq6BPSRtyRcbx6DVB/OTsAoG0tsr6EXdq6XcR0C/Gn6g07xEKhZnn8+47fEZ2lUk29sUWd+xl22c405ESeOvR7H2jhn+gCFCqiifhb1s49+Sz6RZH61A1RSwXfo2bab9BkwiT9kf641rkP5bmsIhLujeb4NX9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778699352; c=relaxed/simple;
	bh=QX5G2rB7ifXMkwPdHvgF7zs1jKDfOFey5yX8c24qomQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=HFTqS5EzepUJqa8vhRezJuKoE51RZfLfCMuS5v0oVjn7mwIsugXj+X9Unfj2AsZj4PB9FuPsU3RKcHjavFZMtyq7oVoG5D2gEA2SWSbTp2VTi9wETbahRrSj/aCIbtJ8Ml3DO0AdHmSUQvJtBybEOHT6wVW3d2vGDy+yR+JBXL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gTlYCIbZ; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gTlYCIbZ"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50d876329bbso67071831cf.2
        for <patches@lists.linux.dev>; Wed, 13 May 2026 12:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778699349; x=1779304149; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UtNWbA0oJC/4NfkSFTFtpG8npNpENo6PjEJYah1z9Iw=;
        b=gTlYCIbZkty7tgCy1VeKx8h5rKE8x4uSEAr+EkArBLGT2qswaTgCaIxIJ0N2ECLCif
         26VwNFmzylQXAfpHEvgBl3cP9inhlULBzUuVhphMCaOKV/lBQaYR0pyDe/ywTdu9jn03
         +WfsW1XTeuSCHnzY3yKJvKvZCNL/GqH7MX+F0EyDEow22sOznnEJl77a8A3lx94WLKTI
         DQ9wzQNNa/zQm1YBw4G9mrmzdky8bUKEkOEPYLhL83eRGefcuVn5GpjMUVGn9H5zJmAs
         tsHaBQ9afi4LN0TxQadPxe+6DF+LE7pr8gyvY4HDSqrJfJZauK9RIlF6HiYZ2XW94E31
         Ax7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778699349; x=1779304149;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UtNWbA0oJC/4NfkSFTFtpG8npNpENo6PjEJYah1z9Iw=;
        b=HLJFMGYANuPyowJ5WgQKUe3xQJL1RcPjqfn57JVKkrhFGJxASvhgBEGQbZ3aHvyrKq
         TX0GN2xqYpPC5lVF46+Pe5tELcghyNZKIpbbkJiyRTcPunKc7f2Vi/Hbrwwp/pgWkrSl
         XtG0WGx01MUFMbWheNnqyX6lAe4v5gIRNVy3fjF4nLXf0XMvAVWjgfLfn8dmogXN+tdW
         6xbOxE132bkWMWrt3o5WtCt1Vl5RL9oKOFRogsReK1MhBkBhdWGbZez0+dgHHYyBW1N9
         UcgBL3kwLzBjq+EGlSon/zcF0dN5+IsmNxgmBujozujcocZHVER+nw16+JMSO8qWJa9z
         jgpQ==
X-Gm-Message-State: AOJu0YzfsFsI0K+Z2HBS/BHOm1WTwqTPmiCx7FzAsrRwlVsgZ+ofrhUn
	uz3/+SsJMwWY7U5nUtWC+iFnwyj5WXwuAD5yfTzIMr8LYqmxjhtKNuEi
X-Gm-Gg: Acq92OGqStCfDLynz4TUzd8yq4WPS3XiISj2XmxfH4tHqnYng5hn/d5tU01fL+DNwNc
	GTrDPKObHvI5v29kyZ8wV+Ms1eOmAL7tRRal6X4YCieEd3CyRJ0AVg00sj56dJCqeL5H8mxtan5
	VOpAeJmW+yf7AgnjIpC+GEzBap21WdC3k5svZHQr1Yz9W2iofmnv9tHimzmqh0TnM9xP6PX1zl3
	neLh9QJMuB5QGT6hN1jhotmCXrUi5SgsqyQ3vf7adjWHevbI1jMjV3lUadfMzDMlGaGVeYzOlHC
	ST7jzze6Yu2kZi1vncuCreWyoM/8fvpxd0UYTnBDLQ8fJAXbT6s0MSXYowbRn1d+7TPKPRsN2Jy
	DFckhrBygVdVQqAil6C867mGNa6P1f5wFvBBdA1E8tKH2kS3rybmAXWxVlh3M5UTA/BzrluQMnt
	UkN1VVa9B6t+tJiuNO6t9kZCt0y8PDk4k0zV7JuDGMJUzI3hvv2zhClbaghHXy
X-Received: by 2002:a05:622a:64c:b0:50f:b81e:c655 with SMTP id d75a77b69052e-5162f68d146mr63497791cf.57.1778699348501;
        Wed, 13 May 2026 12:09:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5148e830ddfsm153785331cf.27.2026.05.13.12.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 12:09:07 -0700 (PDT)
Message-ID: <268c8519-84d4-4795-b06c-4159d8bf48f4@gmail.com>
Date: Wed, 13 May 2026 12:09:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 7.0 000/305] 7.0.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260513153754.934923793@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20260513153754.934923793@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/13/2026 9:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.7 release.
> There are 305 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 15 May 2026 15:37:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>

Same perf build issue as reported for 6.12.y (and 6.18.y FWIW) due to 
older kernel headers with our toolchain.

Thanks!
-- 
Florian

