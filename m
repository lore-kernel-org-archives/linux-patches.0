Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6B412C46D
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 23:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723849929; cv=none; b=AXdpyB9Q5NLlfF5sL/A0cijaYF/5Ozrv/BV0yL5Fuihg81AsMmnelyjKQJlb9/y8p4nXd5wmJs033lFrMrea3rCS+ducX4AHSXESAgpgbfFgzMYlnM/6LQ2poanpxAStiTPrJ0lR2VZgxFbX6fhYbZ5r6zOvViVOapVnMBdcbnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723849929; c=relaxed/simple;
	bh=VqgeCohKwlc47KX4Zj8FiW90wMhohjXLHGiV1j2Y3so=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oNlX3mXGGV6csA0VGLH2qZHQTyqJ9cMzH/itc/erHTnq1jSlPzz47tVR0IEBfXPlhg5vcvwMmCcdQWc2DREES4D0NvSFixF7DNHudrDaKtXQ5Y58eQHOV5Msp3e/Aq4yFk1yv/8zxj5inTKk1oyA72dVinqWkBxl0neOxpyvunw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bw6/wTdm; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bw6/wTdm"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-451a0b04f6bso15611531cf.2
        for <patches@lists.linux.dev>; Fri, 16 Aug 2024 16:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723849926; x=1724454726; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YuYrt97qnFeOgUr+X0/IIcLUk1twOyd4D2g5S2ojYio=;
        b=Bw6/wTdmtrewLtgUCgpwNkBbzJjyRzp1RYTDIrOf6L/xkWQsBwA/uoj92IAbQUpPkw
         V5gMLvwNvKXEi0aB5wicMpmZsemCd1/xlTA9KWuNxiu+sz4gFMlZGjoCjAIEzGxvse4q
         6KbK0xNWd/XNGWFMGHy8+RBJKYAo4YPSw0QUtBkaCXtoAd3JSkYFio86kfCKu54HAwnW
         5kzCAmzzXil7X3KTEIGKtCbk1i3r3zd6gTAep+gxIMqpfqodaHfbsYgRDtAa9jIb5WmG
         YHQwgS2SzLp0TJm3WAfwJKlBPGJpIKxMFqMM5bgAVj2vTdasvmIVrJgZXBx0YTeoOAyV
         zfRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723849926; x=1724454726;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YuYrt97qnFeOgUr+X0/IIcLUk1twOyd4D2g5S2ojYio=;
        b=SaXWBfDb81h14DPTEyrHUlOswdG4lWv2d6hnJFvi7OuK4ehURIDwZxaE6kX0Ylwld1
         JRy7KmO7ZUXDDhHzaEIADLfr3pne18FxjFeY4JWr8mYo8MyTJvzWBqEjRrwE4p8lcd+O
         dFgNraGyfYAUJw/PCyRegpO6NFhXETTCP6+c7V2VUm0Rd082NmeW+zsqVsybbz8/veHv
         HyWl3lalvY9BGr7uxbvKSsQlyUnvbO02LBvTY+HPip7dCGpyWt602ysFywcFuWEe79kj
         yVvFIIRzf6Pdsli9kYXQ+B3FyH0AJuKtOw/ZIBWOh1EYnetHoWYPPsoiDx1eI7QYLTXh
         r7Tw==
X-Gm-Message-State: AOJu0Yx6IlCJprST2sYJNgW+AvtcG12f+VX5tvXqVEW2P7qOX3OBZN0+
	bEukLZ0BWVDO818iN8n2gdneahKy/Cm0twSCFt1SNkTC3zdfGfZa
X-Google-Smtp-Source: AGHT+IEqF3gF79Oy2kJAgzpkiNtP4bcIr2Pg4vqiQ3djkbPGd7nGz/2WQolO/19dng/hRKHoegYp6w==
X-Received: by 2002:a05:6214:460e:b0:6b5:e60c:76dc with SMTP id 6a1803df08f44-6bf7ce2746bmr48783796d6.19.1723849926594;
        Fri, 16 Aug 2024 16:12:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6bf6fef0267sm22579886d6.113.2024.08.16.16.12.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 16:12:06 -0700 (PDT)
Message-ID: <b619ad4f-431f-450c-a3b8-29f48eefb8ce@gmail.com>
Date: Fri, 16 Aug 2024 16:12:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/350] 5.10.224-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240816101509.001640500@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240816101509.001640500@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/16/24 03:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.224 release.
> There are 350 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Aug 2024 10:14:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.224-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernel, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

