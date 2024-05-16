Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169AE1553A1
	for <patches@lists.linux.dev>; Thu, 16 May 2024 17:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715879543; cv=none; b=JVgUhTaev7yVzfbh5F86SDuKojDVqz2yvsZmp8DrwiR/RZgqaF0lup/mROhwqxaLZyGj+eEvS91TR1N22VQBB4zndReRxNk8kffUQpxBrLCmZEXT4aIaH2L55cxjsDgeh3jg7egSBL2NklvUsoyxZ2U+BU13vbhy6RFhIaWHB/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715879543; c=relaxed/simple;
	bh=FhE0/+Vev/VD1sKePplNrzUpXEfx7mJdHOT5LI85Ld0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z8rASoHyIiPU1jDRWVqe4yFrOj6QLtSMM3lPJtXDxXIKnB8WjTHIVWo+jyf2ndg5FsLI0S5mnzeuMveOiY452/vQUL4TT7qGZE+O3WMja6LBKcDe6DNgM7xHKKgr6UU4CZsPB2tmyxdeJL8AkLk519u9JgGZJhYA1nuAw4jrsYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FErB+m1X; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FErB+m1X"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6a0b68733f5so55018766d6.1
        for <patches@lists.linux.dev>; Thu, 16 May 2024 10:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715879541; x=1716484341; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WNtCqrtDQOq5DdS6OQ5vwazjgqxJj8aBt0efGR7Z08Y=;
        b=FErB+m1X/aI25ILW3rVLLXhUV8ONU86DHrhr1cazpHwJd+l0o7/eyp0A17703p5rVC
         wXjD9aLK8E6zOM16MtaRtyEUah0capxVJOxgwUSXvyy0Xz9dMxCxsZX/n1oTClXMUU6F
         vNVOUZZr5Aeh4+ybKeRhkEt4Z24YVacXhISwsOPlnx+OoLsp0CmmzOJHQme6PjSi4OrS
         TjZrVsyTKVOTUK2YtXTDSC+Y/QaD2pKabnWYEYtQR/aPakgE4bIHjZB2Nd1R6sWF+q7B
         XpC8MRS+CahBEb6kJVbqH6uoJrWBo6KRFl1nn22lQnlt7fkd5+bs0ObN08suLt59rPtw
         iJTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715879541; x=1716484341;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WNtCqrtDQOq5DdS6OQ5vwazjgqxJj8aBt0efGR7Z08Y=;
        b=YfeGyQcBLdBpXUNXclYWls+4q0WlLiuvBm1PwaldQtjsI5nZTWaijS3EWDiW1suBtG
         ycXl7hBYDyviL2n8ZVLU4dKW3XdiQ3S0YWANHQCZ8gu0p4acJ6cr/eTUHi8gq1RDBLHP
         8GbgZIWPE9yTtDWXXLujwrpi9rScp/JyxlzpkYVSUl/CDdZ9lxhYNi09wh7U6h/BS4Rz
         W030rAhz38wTvUlZ7wkBA7zrs/UG++nvIYyIOwrynPJiuJmrQF4rKeP4VBAj7HHzdQcg
         upNzMrpt9duRTOujmWYJUEyxgkvUh6EucfavnOlff02O8Apbew2Uz0KlUqc/m8Fn31Np
         O7+w==
X-Gm-Message-State: AOJu0YyWhO3e2nIXvuumFUqU0GL9WQzIQq05u9v0uyCgH5igYevtPFIw
	w4HPw1LVJturz18jFBDy7ugTOkRiWCFs1U5/xTq+9cjhZt0yDJS7
X-Google-Smtp-Source: AGHT+IG9HkjRFX1+YYNHBv/8dIe/DIDRiBupHz5JYg3PVe/p9rP5vVSjJEbRQE/hJq1GVm93at3f8g==
X-Received: by 2002:a05:6214:2f8b:b0:69b:12a0:295c with SMTP id 6a1803df08f44-6a168378b13mr232212446d6.57.1715879540836;
        Thu, 16 May 2024 10:12:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6a15f194945sm76619176d6.61.2024.05.16.10.12.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 May 2024 10:12:19 -0700 (PDT)
Message-ID: <ea42405f-77df-40fa-af3f-e35b8a8cd484@gmail.com>
Date: Thu, 16 May 2024 10:12:16 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/168] 5.15.159-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240515082414.316080594@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240515082414.316080594@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/24 01:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.159 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.159-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

