Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9023239B
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 00:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712709004; cv=none; b=VmtM1yB77Q5TUnNjRXoJPmD7jHYPFNlmf9676GlqDVtCHfiATwUfKPxdMXYHYZwcw+JPnXe0bNGI5KenEAId0x2ObQ4OOQzp7pSXf4RpPOBENHmYLRcz4XgLgDLWHxlC/UXBquyJXdh9IVwuLAbMvmomUl5OxPMZC25+TiTNmf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712709004; c=relaxed/simple;
	bh=Aohoo5m436ATY06E6fE2TkDvoVmQmitw2MESEWpP18s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H2j+Bt/8jh4ax7w6bOkbcFPVCVHgyLZTJayKGUa+udM/dHxzgBOwc5kJ2jkPV2B0fbf9wK2UYoFASQNRLseJvDRooWtoYUYAw3k92cFVQIkvITL0ButgtkH0g0oQ/DAf7zv38YiLhGiX8TwGD3Fu2njpxX/RpY1seBmxrmvlTmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6JeqWSk; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6JeqWSk"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so138093739f.1
        for <patches@lists.linux.dev>; Tue, 09 Apr 2024 17:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1712709000; x=1713313800; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E0mPzJYDDs9NjRkVwk8PAW+ML3/n48vFMOCW1SPs8DY=;
        b=P6JeqWSkvvodL3awcUYVYL8oU6hUxzUVeGVP6ZpJiefuoJsLW8FTLVkC5I+PLXU3RO
         nJoduPDe/LYTfZG9xjNV3pEJLyionCQsFhNjSBUePsbbFoEWUFWRUHiZH8bJk/WyJ4Da
         Muylb0uUr8r3QPOb1vFXe/uugZ4VVqaPaNaHw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712709000; x=1713313800;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E0mPzJYDDs9NjRkVwk8PAW+ML3/n48vFMOCW1SPs8DY=;
        b=adLNHM6CwzsZfiqLsJhDS2039aG2G6lekINZ7sbJ3spBkH6y0Mx1UDCHwOsk6KRIxh
         rp5qrhuySmSViYG6XXGaHDhPSXqBrB9856Ja0mA43ve3Pf5GAWsb4Dwc/Osa43BJ0XSU
         VyGzCOueK2h1rG0z2Zt+ChGufCww7iB7K8O6a0N8TKwRwVv0FcdJukQR2rUdBeOmUbvZ
         tJCil3f+nlSssxjbuitXlpY5NhqqjYrKXdhhmUdvtVAadyD9TM2k4S4PORsfiwENCezB
         Cee2pApJNIOWUZxaTG8DjV43R7/p5y8KqLzHMVcaT9xe9nsnOLw56xmpL4MaW1V/Xshe
         hycw==
X-Gm-Message-State: AOJu0YzyyLyMGq0a4xYYb7NlZ/pJKFlZ38gef7QZpfoCsfuvGGAMUrDo
	c5sEivSsNz3+FDWTvZsQsNxws9ucq3Ykt9W0gRIvdRaGqCNph7NPrbks3F2gCyc=
X-Google-Smtp-Source: AGHT+IGyUInGdc0DiRUYiPJpwVzrArmK5Ss4VpPR1wgMi7o4wISsmAZTzTzpqZ+Stn80wxBkyrIwvQ==
X-Received: by 2002:a05:6602:120b:b0:7d0:c0e7:b577 with SMTP id y11-20020a056602120b00b007d0c0e7b577mr1407387iot.2.1712709000699;
        Tue, 09 Apr 2024 17:30:00 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id k2-20020a056638140200b0047d68340fd9sm3564684jad.32.2024.04.09.17.29.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 17:30:00 -0700 (PDT)
Message-ID: <2dd6255c-ae7f-48d9-bf7e-ffeec074cab1@linuxfoundation.org>
Date: Tue, 9 Apr 2024 18:29:58 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/138] 6.1.85-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/24 06:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.85 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Apr 2024 12:52:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.85-rc1.gz
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
