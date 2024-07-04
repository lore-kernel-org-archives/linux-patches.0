Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2131AE84E
	for <patches@lists.linux.dev>; Thu,  4 Jul 2024 15:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720105960; cv=none; b=PYQ0zIE8AhycS51Jl2LZJgtFcBXetRTRm00VdGuJZ0i/wT9586HUHYVLUIsGeVfqRKNWgaFrN/ZMQEsfP+YpbwIPGJCclsk2E+9YguHpSp2jPm6tn9tAHSHtyEbDhIBJab6gfCQYAnluc0k4FeqwsDihvjjbaOMr9OpgiPMGM0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720105960; c=relaxed/simple;
	bh=iXLCVcKJ93rj0R+0XrMmhuGBlcFgQoki7G5H+B+wEos=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a7tZzaUNHq0m/y9AZgyTf3OBbLYTPWPkwuMDQOMtBeBwLWM/1mC9BH26CAOMR/iqTsQ+xTY1kRHJphV9mS+MaAnCmJp0r4myrp1H1wkcotSyVC3tx0oM3ybG1E8OU0l24Z5SjM3nZM7bkgcoFGmBQnmQc21iqrxDVR4hDMXsqkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EZx4yDma; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EZx4yDma"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-79c0c19ff02so55886885a.1
        for <patches@lists.linux.dev>; Thu, 04 Jul 2024 08:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720105957; x=1720710757; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AzLZqmXXL7U3v5CC4/jZDNYk7C8VuhH+npsYCW/RVmU=;
        b=EZx4yDmalE/SlMSOxUdXvGRTxvyggCoJvGSq9WBYRLOQGmClAcp3tEkS68qaA0oCk5
         0s2iZ3+iakQpW0/UobepHcvaElZKdTTb4ZcXU7T2mSxvJ2ncoTwAoAV8fP5FpbsDjCzz
         3eZOwBzcDSdb1YD8EUM0lmRcObAJZHH7COpNus8PYU+ezUPI7jprrG8Mbfxd2kgdnm3R
         Tz0UY61yBlMpDoX6mhbIU22N9lVg6kn4tD62gjmVIWVVPLI+ROH2SA6P+b3zd3/xNkXG
         Y6wRQEL+FJ7XqcpDFkd2XZKy/CYXP0eKSgu9SxZf4/2J+CZtxRze/Ug/f/OLqRdsiYNk
         vlhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720105957; x=1720710757;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AzLZqmXXL7U3v5CC4/jZDNYk7C8VuhH+npsYCW/RVmU=;
        b=mDF9cy5I0X7I3fh95YOxqE5dv9DxVm4T60O3JW+4ioqi5QmTTexvXWk882UdoN84v4
         gcUSBudL+BATGTciEd1+J3g0MbIJwkWG0+w5hLeBTwiNAxef3fkXIcM9iRL4xRTRkRPm
         +hHEWU/InKyxzK7sTT5bvSR6oabtUx/oKyRWMzk5Z625qha1HyzjG803I382pc/JY8DE
         aJe6nSRcnwLYV4MzQUyKVCzzVpMevfXyarMDgShiF3U0hibDGTXbc5iHr+mZUk19xlLM
         BlMGqMaUDxbu2A8bBvIML0MSGHcjfwe2Zaz8e9KnFelir0jmNbFyBymdgfO5dGnVjuXx
         +AfQ==
X-Gm-Message-State: AOJu0YyVjAUZ67SKYQFIUTdatQPmGYC5sqcOON9yo7Mfb0EHnLGsscFg
	rUEJ493o9I7+s0cxjEhtWQYrerIFUKgJkkwssRQwBx5N+GbcnNhf
X-Google-Smtp-Source: AGHT+IHTYZGhvAOYOH6mWW1ynTo/jszAqJ23XjJ40VDBAO2d8lD6bwQnG0D3QIZdaTDO2bmjW5lXBQ==
X-Received: by 2002:a05:6214:27ec:b0:6b2:d335:e914 with SMTP id 6a1803df08f44-6b5ed250ddamr21094846d6.52.1720105956794;
        Thu, 04 Jul 2024 08:12:36 -0700 (PDT)
Received: from [10.40.5.113] ([89.207.175.15])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b59e5f1550sm64229406d6.84.2024.07.04.08.12.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jul 2024 08:12:35 -0700 (PDT)
Message-ID: <17d91006-a9f8-423d-930d-d5a1d1308995@gmail.com>
Date: Thu, 4 Jul 2024 17:12:29 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/163] 6.6.37-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240702170233.048122282@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 HGuUuzv+GKZ6nsysJw==
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/2/2024 6:01 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.37 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.37-rc1.gz
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
