Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCAC69D24
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 15:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708529564; cv=none; b=uKnDzJF4dJBHqNKO7MjAuHsgXXyRABygwXOYKQhX+ljBoz0IfjY5RB55c3HIijh7VHzGTxTHNrzI9ae5xag5jGVBmPmMyZh8pRCWB8iVeFtdswdJghG5Cbu3cDwB+HSSRV7/RwfcnAzPPbEVKsN6ZQ+5o/UfOK7yeZJGfcDVB44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708529564; c=relaxed/simple;
	bh=V7d0HSjRnHzOfU+EEKSUCWwEtLbsiZEB5+rydMOHck8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kXiBcXhAEvd5VrBI8HiN6hCGQg2Sw+lmgwUavguvNe8BjXWB8xz6xoW82P4DZC+CwbXAG/gYoKBtmnul93Q5RDgn+JR5ps3vowUzTUAoQQdRKBsJw23UbYSv+gxp96aM+6vvyhkot6BoCwBkQgVquBOuuQyCu+BHs3H7DX8Y7O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSHYYPny; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSHYYPny"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so60063039f.0
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 07:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1708529562; x=1709134362; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rTUWS3ITPqTvVHNlrNDdtxwJD4AyTQiAHNyBeZPU4ps=;
        b=GSHYYPny5ohBB1FVs7iidsCK5DAu4FzyrGUsa2QVZ6q0AyPnubegrs6ZCe5OTSYFhs
         EaQyXy1vL+QgchxYHeYcART905XqodF3szJMGydDx1bg3BJhkVJ5O9Vx9msTrilxew1H
         PZMyrYVcbH/41ApkE52Zj8mBg2PBKxq3t/vaQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708529562; x=1709134362;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rTUWS3ITPqTvVHNlrNDdtxwJD4AyTQiAHNyBeZPU4ps=;
        b=J4RYn0WEYgKz4ebtfZzIw9c2lwm2C85gj+vvFdKUSQ2H2m9qf7gi4U99Mowq+z3ojZ
         k34opmk4lOh8G+r9J/AVJE967tyqfIJn+QDkthC8y3Bv6wqzHWQQza3aag+rGltwRZdl
         3wQ3sqGHYYwHmd5JGVjQOvecJ/F3rbUkURnPKPU+V0H8T4H4dCZWz1WPwjkAp1ekfvaj
         zGBRBX60rmYuQ5e01dNkidzupW3V0iPuNmYFuuYmBDHmNXr/8O2Ss/lgVbdn7noSyWhw
         vqWlOlTG0jmcdk7ROXiGURhUV7KUfz/y7/v66/QFDY6680gEIaLc6CiUbxFMBTTpp1Re
         H/9g==
X-Gm-Message-State: AOJu0YxVMO1b4QRGOoC18xaFy64N4yK0G4kzixug2B9Er3lIoqMckMkT
	qovxfh2zpclZG/qwkmiInLs/qZH4BrRUSWKXFLBTpQQuAkeYRRIaX9ymL840njw=
X-Google-Smtp-Source: AGHT+IGsafhl7SWuEo6yvVNtfR8RuWLkNqrVmSIk/bzAZaHH0TBGFMabmNdsRvlZhXzy453/7nPXrw==
X-Received: by 2002:a05:6602:1d47:b0:7c4:655:6e05 with SMTP id hi7-20020a0566021d4700b007c406556e05mr17213245iob.2.1708529562000;
        Wed, 21 Feb 2024 07:32:42 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id q11-20020a0566380ecb00b00474269ff209sm1796067jas.119.2024.02.21.07.32.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 07:32:41 -0800 (PST)
Message-ID: <bc6e74d1-4354-4881-929f-ae45ea1e35c6@linuxfoundation.org>
Date: Wed, 21 Feb 2024 08:32:40 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 000/309] 6.7.6-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/24 13:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.6 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 Feb 2024 20:55:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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

