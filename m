Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1431EF0BC
	for <patches@lists.linux.dev>; Tue, 21 Jan 2025 23:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737502593; cv=none; b=tlarGv35MmGO3PB1b/d0d1nv6JEqfC/lyFQGRwPCpwdmlOAqI7w/7td7V44+ZGvucR2FC3SaGEysGYfj+cHuz+ITuM7UiiUX2pM6tBNn0QRCHetIbumQkiBMhgXaWgvAquMA+E9kdHTE+6uAib/XKw8UmY2viAVszFuA4TjOokI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737502593; c=relaxed/simple;
	bh=HhvXSyQnnl4WiEDxRFY6BAIiSCUL5vDMujoCA6Trt4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oz0Kxdz+ILY0r4Czi5krAC8GCDhE1Touml2pykyv0J+wrLz1qFtysQQ5YRH3vs8ljYPJiYJtveHnkEN6rzBk/XeP5XZUfbvPdgnRBG97c4Ucb5E07IB6eWBbUZ3euubb9RhWf5cQkJq1hXg4nIgnFSR/JrAG4ddtOkc78QSa+Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MB6EDwgP; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MB6EDwgP"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-844e161a8b4so187999139f.0
        for <patches@lists.linux.dev>; Tue, 21 Jan 2025 15:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1737502591; x=1738107391; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bKYuTz02mZcX3ZiwZL/mjlr1FVSouf1GajqEHj4wUMc=;
        b=MB6EDwgPJrzvZ5WrcQTdCJkmDGEeuzXDyuG0D2OvDwdU57lRnoVaIaJJYycC1sPcAN
         ycM+MQE/ufbhf0FWicR4KaKJy4n05mgn4+tgW1t589ybDgKzv3+7suj7h5eqEBkzx98s
         u3PzKmS4AYm4VN8YOE66MUVUQKUJ1e/AQk44o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737502591; x=1738107391;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bKYuTz02mZcX3ZiwZL/mjlr1FVSouf1GajqEHj4wUMc=;
        b=K6UvXlx46Fqle6ug5M34tJool5dp2OabiKHoL3IcY33DzlArYpaQMdE7H1L2ft+cbf
         wXP6z3wMb4qaZurEjxF1OWvpAbi5u8qFwpaeRzYRKi4ecytg21ZbPBlmZHlQ7M6ouRCv
         SCZLuZLS8vW1ZguYLm/Wc9s8xq4ToCuzbOJUYFoicHPEnIrFC/cLDf0D6J6v/uPMvsep
         8DUvdRsLnN+VE/QFsDjjoTiy0LpIp897K8wcK79o5s0uFmcUvMRfxfC5qnNiiqNe7rGE
         aXjt8Ri5ErCrDQ2qS2+wAInPsq3H3FKdto2ak5CzJko33Tza4L1TjCUhi3JelhgWGLkv
         Pdxw==
X-Gm-Message-State: AOJu0YwnweFra7xg4ZIVh6gbOXUfHXLncdbwxqyYx4D1IR/kHOyjnQTO
	H/Vmc2WYYBaRs8OrPSvXczZ0HgX67iWYqJbXd/O0+l8Qz0wbfvLdptEbfBwpNyM=
X-Gm-Gg: ASbGnctXA2mmitU3CHgENfwt5OH6fT7Xu8GLDpBkV2qaKXoQHaNpCztaBF7OcjPubS0
	iwq9qkamx1lfoW9zUFSlvP25HgeaWI4AOgvnZuMnTXeAdv1zByT08wkRX5mF6oPWfGrdGEQ19lR
	1RZcUIe95Xc1Y9dGsCI6P1Gc5WLCwf77Hx/qZJqQH7hWOsdIiyNAA4dNYQJa8qxWTFx9LsrBi/v
	TPpyXNBheXMLVOCsyS/+F9RiwXiB+aMWhf7zKlM6hZNnnibfwsUsrBO+l+hSwuHyK1kho4bd3oq
	pfwq
X-Google-Smtp-Source: AGHT+IFzvPyYt0vh1Cti1GCPTw6R6EXdCv+yO8aK7NAEMc1wHtbPbgG1byohmjfaCYMwuU4VZG3V3w==
X-Received: by 2002:a05:6602:6c11:b0:837:7f1a:40af with SMTP id ca18e2360f4ac-851b6522d65mr1374484739f.14.1737502590789;
        Tue, 21 Jan 2025 15:36:30 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-851b01f2e4asm341343539f.17.2025.01.21.15.36.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 15:36:30 -0800 (PST)
Message-ID: <2278a353-9f2e-4123-8e3b-4d3ce20395b3@linuxfoundation.org>
Date: Tue, 21 Jan 2025 16:36:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/127] 5.15.177-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/21/25 10:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.177 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.177-rc1.gz
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
