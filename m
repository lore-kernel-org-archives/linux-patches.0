Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BC847F4A
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 22:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757371981; cv=none; b=oH76aY7APFoI+YsiNA6TXPyQ2N1RScw2vuMhxyewfmyYXIqrp70/Lbkm73T0h+RHScexjhvj2xFiMWs9iyFIY+g9qB50NDajGntOpp7fQPeG+XmTGBXw7Sy4bR0f9Xc151Nbt4WyRZcZePIz6eekxkHR9ZWT2x3IhD5Lyy5sOzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757371981; c=relaxed/simple;
	bh=pP64zdSLYuawWGL6M9+/rStQBf+nMDaUB0PCbB3UWLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OniQqnpVp+3utxGS+mlK4gMQ0JSJi5892LhDwlzjTLmqJFWv4/a+7hL2Gxjc1sXOymZwA1do71pA1p/xZbSuss+ATTeVprIfapKSV0uswZdTEB7OLQ0HIfKQZ9rgkNpNgIHYl42CusExvyizZ6yYEGhLVLb11KKn1mpF6lmoW88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YiBIMAZN; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YiBIMAZN"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-40f9e28b09dso1664065ab.0
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 15:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1757371979; x=1757976779; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x6g2ytjEOuNxZukcRm0gYsVtC6FSF5PRujJ//3LZSz4=;
        b=YiBIMAZNCWg7KBSqOHvRwD4GQg2odaMulsEMARyRzjL4Q3Sjr3f5Becl/T69JR2nMr
         PppXTMt8X1PuD5iw6KFq42N7+3TYZgj4x7GB7zVbvl2Pb2b5fDE4+//pH6KZuLKIQr0C
         +jrxjyjrNzhDUdjvAa2lBej9lIFsOaWlR3RuA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757371979; x=1757976779;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x6g2ytjEOuNxZukcRm0gYsVtC6FSF5PRujJ//3LZSz4=;
        b=C6khlAmxTYFyMDO7FsYtKCGeb8FWmc9/1X1ew7108Rc95TfyD43sOx0bwUj+b3ST6/
         cWSwmoWLOnk/DbSqMsA7Vnj6ra31ahXfiOs0BLGMs1CetuuwFrZMl+oDbLJ2Jaw7j2XT
         EY1HXw5Ii7Bou4L+qirKcEM5eaxIPGgMh+WDP74LsoznIhMCSl8qdGdmP5HV8q8gRGJR
         y4+SMkzyRZKVfFElqRmJiGKyKmn3/o2Vk4EnJTwwfgyWgqf3BY3+CinYnWPujqr39vhb
         nwqu9cJS1AqFNHDhLFPKaXmZfoJbP7o2WYISvn2hZV9QV29ktfLNIeTrewvmxWr0UiT5
         Sfgw==
X-Gm-Message-State: AOJu0YxCqHY14vGS9XbonfGiZFHpSSmHY4qZSNhBVcA36ODxuSXz9ond
	SoXQf5umWiDvsuapsgDU/IwETeZ1+plKcB6kp0zfto4UAfUUh4ttH3Ffmj/ZSzrid4k=
X-Gm-Gg: ASbGncsR4I+gbPZ51FU8gcSwQRwaIQJYZg4SpKiO5fQWUrBXuxoITMd+/7qZl0d09Hs
	W2VJXl0jvp0ZzLZAgfeTvycy0npQDYWIBKIOh9DRKhjsJMpmCWwoA44POTwjzcucJHCRF1LMU9J
	m9/MM8lfLVh3Jp7AZIrFnIVBQvuksUYcF0etf60MplfpxNTYcT2cJc4xykd8ZiySCICaZC4HUTV
	0+Mwjy7UcQImxB4y6CU5onf/8Kaj2GeupwNqp4WIXUBmCnFw2mBCYvQ7c+kitgc2GVOSw6cV4xm
	j47OzGdz5DbPSeRwy9xQ4aUTPXc3ea8P3slhIcaIztAUH8r4WLmieoZxSIB0/eyYGCJ6tzQAtsI
	M7Cl4JjppkhiJhliE+wAcre3C+eCiOvijgR2+LkhqCHSY4A==
X-Google-Smtp-Source: AGHT+IGHlfDmvkZr5EsWyqNrB2Jpq9AoMeyzzheU0TqJZfe/YG8cZIrPRn1JB8n7L66+uFRG4iz1qw==
X-Received: by 2002:a05:6e02:f90:b0:3fe:fa06:bfd6 with SMTP id e9e14a558f8ab-3fefa06bfffmr93467105ab.18.1757371978863;
        Mon, 08 Sep 2025 15:52:58 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50d8f0d594fsm9224126173.23.2025.09.08.15.52.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 15:52:58 -0700 (PDT)
Message-ID: <e413e58b-f09d-415e-891e-832b58be1533@linuxfoundation.org>
Date: Mon, 8 Sep 2025 16:52:57 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/64] 5.15.192-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/25 13:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.192 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.192-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
