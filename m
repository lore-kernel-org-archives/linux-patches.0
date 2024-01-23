Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1806C2C682
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 21:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706044791; cv=none; b=nshXBdWY4Yo5/OIryU7KL0UF0l9uv+nDqFLhbvFbzFAxoTQ4iZPRSEuBGNBkW2S8tVI6exC/YzE83xpB4adOJ+kFLm7XWkFn7l7XgQwbJe5ijgtFxq0IMEWKty+TVucna+L5qTl0qnodAnKW3/uOiFHmwrYhLs+Mvc7Bsmv4avk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706044791; c=relaxed/simple;
	bh=VXPP3Yfv+aN5927BzSpWYPembSi2sAsppWfJkocPaiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XrX6xkjJllRl+cHRltSmV2n/67F4K/avfaPhgFJXtm1rO655aPVnv1k1btHC1WfBWBEwmS196ZTJ7gfYP5GttBwek3hRcZpKMF88hExlibxO9FJ7PSoHL33CmEnGHWONUxKnaFXmknXnrKZ5YOgdumDZTHSsyGH0M47lLPf2RfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VZnsjmBf; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VZnsjmBf"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5cddfe0cb64so2448988a12.0
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 13:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706044788; x=1706649588; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Io8epyIIIUF8bbtlZ2MdvLDPjTnzIChAR6sGUafC630=;
        b=VZnsjmBfvG7OOMKGa2EpncvmrQOs3UUnBwGpRhV2TjAdP/Q0sNqjdD51sv51KAotF3
         rAFlnQSRAbvkcyAdoljxsDNvYPJi6K/+3BgldHSdjNIsgaEgy8hPN1dx0/xLldTgAeGm
         POCVOH3QpFhMbjR/9gW9lm/6ocbmTbt3E791p0o14bBzW6z99DQ+lj8L374hTzze8Hc8
         AJz7fS4b4M/eb3cJCp9fhQEHATKZ/FiM4DKEf9MNnY0VFBnh/jkkMTPOT1/NIhbHGKyx
         7jAya2S3+d82ddau3pENo6XMkfW0lYWj+4iohMR8vkqFfbcpNOVLi3qhtrf4OwCCTc5d
         jUQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706044788; x=1706649588;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Io8epyIIIUF8bbtlZ2MdvLDPjTnzIChAR6sGUafC630=;
        b=WvMBQ5m/afSBj5Jr6AVyVlcwfBMfmkR7et2ND1pRm/bKTX9yuKDJddoc+8Vl4tEkso
         n0a+zWdjVGN5JPleRj63/uC3xdpUpk4lQUEiinXs3okS6vjnR5QTqQLOtPaKJLf8oAkf
         QczWDCnUDNnJ7E7g4O3iJE/UzO8Kby5K7KgmaobRbFwSYgF30f8ATd6mNe8wc07PuAxZ
         uLEZ3b8OAuVmJkzCKWhd+gCjxQcV2tlGvngT2Hn3vuf77RmVjQjQzC+dbMdsXaNwgDTY
         ealvOyQ45oYISsSWFLDdq/HasM7UmMbzNNW9aQ5zjGSiTgcROE5saE7AOEM4UdqK/F5t
         gYpg==
X-Gm-Message-State: AOJu0YyB2BpLji5HO+LPCvzUis7yZXn7Y5FgrnBVdLDyhEwD8QV0fLCy
	9dW1MNr7HNsT7wHZ4Ea03YNWT9UBD3rOHeopqt6so0DqwFbv7nlF5SInG0JM
X-Google-Smtp-Source: AGHT+IEh48OvAcikgSeMaSejKjwWPjve5WVTLz/rCnmWG7U/d6hF4BScscCeT86idN2WSeJF0cHMkA==
X-Received: by 2002:a05:6a20:6da2:b0:19b:1eda:ab61 with SMTP id gl34-20020a056a206da200b0019b1edaab61mr2927864pzb.54.1706044758541;
        Tue, 23 Jan 2024 13:19:18 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q81-20020a632a54000000b005d39e412031sm1588892pgq.36.2024.01.23.13.19.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 13:19:18 -0800 (PST)
Message-ID: <c8ac1c40-3944-43a6-b64d-a9b9ec98c7ff@gmail.com>
Date: Tue, 23 Jan 2024 13:19:16 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/286] 5.10.209-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240122235732.009174833@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/22/24 15:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.209 release.
> There are 286 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Jan 2024 23:56:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.209-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

