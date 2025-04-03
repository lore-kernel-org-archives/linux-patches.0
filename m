Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793661A5B86
	for <patches@lists.linux.dev>; Thu,  3 Apr 2025 23:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743724477; cv=none; b=pl624YQZb5pfJydgPVAp3G36rmBSAU/7OBK2PvlYaggd9IV5VqAnk+JD1q2A6wZjZ+7c9KNufTafZKZWINkXxbOK8pbD0CBQeU3MmK0m+Lrkw1Yl/HqzF4ibAofEm3uBFmO7t2ZkzsTozSc9ycB2hFGuFZfdi6vF3OBIqd73gyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743724477; c=relaxed/simple;
	bh=gcQwd2bP18j0Gpe8CMOwsNYkIF0dQKhPA73tU9zFtMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KtSm7fc8XhOHITK9rBbZP2iH+QtA9/RtnHs2pilNlheNBHKfNzMQ2KC0qhmlKm0SkNskrE4JXcEd5xRJJUI1NGxQssQMBtv816BbIfCrj38FvFi3mFi43IiU0bLEEUvAcgWf8T1MVmiuNH5+F0whD3Z+7/FbrUwzHPuWRNtUAdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fxqZP6tY; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fxqZP6tY"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3fec2899574so897276b6e.2
        for <patches@lists.linux.dev>; Thu, 03 Apr 2025 16:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743724475; x=1744329275; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1Qhsl4ulLmLZB67Aq5ga1q8oYwKPws4Mfx8t4dx+JRE=;
        b=fxqZP6tYCU4GFkNQ8TmNqwijF3bRhfsR/kOfHM3lLRx9urRBwUJ6z6D2CCBZny+cFH
         PtmjaUcomEZNb1dr2JEkH4ZMHHhqcIemA01epoUnsJILEOKUQhFdjALJ4nq8fuWXeILD
         lZCUCi86MVVnZPT84TEu5odZdktsAc2H2rVEXjavsmU+G5lDReX9i+x+XVGyVOVa7scy
         yjMwW9zMJYZPoJV4SsP61pddzrH554otIM1+6fDnhGT0nZR3m1FmRgwmDogGXDPUG8Ei
         Kf/qtKiPgPiDDWbq8i9Cx3Xx2UsmOxlc0Mrk9se+Avg2vGq20F4lz/C5zVe7RqSLuHEp
         a1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743724475; x=1744329275;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Qhsl4ulLmLZB67Aq5ga1q8oYwKPws4Mfx8t4dx+JRE=;
        b=RYyeykz/BUXieWoNabUrywCIgKfPVdHQrP8JNe7SeZg2MIQbNQdsXzsAdgoFpUpXdO
         un52Mh4PA8TtZjrOErHdCBJ8VC+fPvrdqrlAmdZy6aW0i4giIHZstFgtDsPyaxLvd1x/
         O5seoKqkiEqir3IxKOvLkGbJlYbO+t8RBThx2Mx1RjL+N5y73NlBMP9k/SMsoiIRQ9mE
         AG9sZ/AkepsncmcFM1Mv15owDugxfKtaV5eebtWdEV515SbcHChLk4+6j/faL1ZVem9U
         +mnr6ZozJELmIWZ244lmOH9HRTzzy0Aozn38JKxez1uWqtk8+AEdXxwhvT5B7aRx4Ugy
         r5pw==
X-Gm-Message-State: AOJu0Ywxt8M6j7zDTDdHb4sGE8A2pjGb7OKJ+rG+tAKFEAvIANJDR2QS
	5clsaDh5H35LOu2J1/n748zlGIgo8DFoDVH8qnEwOakj1MTP3JEY
X-Gm-Gg: ASbGnctgo7d2YRveotVYxk49lqHXkOGiVEF8XRAebp6/75s0c4SCWl+e68zPxazCesf
	LEmsEh/xTMSM2XnhWKXp2ZV0G4U4wWa1PJ6fwfnaoWpIzvbqJ/GOllld1zEAtPLDll2caGFRqZ8
	gKsE4HcLOg1gh0hGPHrAl7kW3uacP5mA2y5DW1tsvuwIcQ6EJyJ6kuZr+qW+Lu59Viq1h2r+ckq
	+ph7NDqQkA+g9a4TQGJSaQa4YYvX1MmUkNpijoMaV87adBuL03NeRTH0aLPEM775WpszInBrvcg
	srVM2wtPVgXQGwBdrnqyBYhrBJovdjh01CL1K7FHctPlHP2+uYr58RPxYR4yBK2IJ5zFWGnX
X-Google-Smtp-Source: AGHT+IHmW5JtowPr2RX3tMM7fEEesHiLyqR/j8VnuBd2EXL8s6/KjEqwVIAYFYT9WeCmK+k+4J/G+g==
X-Received: by 2002:a05:6808:170a:b0:3fa:d6d4:8160 with SMTP id 5614622812f47-400455ada34mr694016b6e.10.1743724475377;
        Thu, 03 Apr 2025 16:54:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4003ff9a2c9sm398396b6e.23.2025.04.03.16.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Apr 2025 16:54:34 -0700 (PDT)
Message-ID: <b10e9375-994b-4ea2-b38b-51f227bc4c72@gmail.com>
Date: Thu, 3 Apr 2025 16:54:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/26] 6.6.86-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250403151622.415201055@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250403151622.415201055@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/25 08:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.86 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.86-rc1.gz
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
