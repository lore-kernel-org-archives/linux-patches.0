Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AAB135419
	for <patches@lists.linux.dev>; Thu,  4 Apr 2024 20:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712261961; cv=none; b=ne9Bf394Tigw4T/LX/DQGIWBC2bg2yKQhogaVQ5mg0PACNpu0dq+lND+JUzfCXvB/M4lFpar1wM7OTQ9fMXZLFtc5aDGOWqDTwXivUicvXnxc5/rufaNmQ00I2YiHjgUW89B3JsT4EyoMKHYXvBBwsUEghxikrmhNxQmRBwpDG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712261961; c=relaxed/simple;
	bh=w0J4zbPe6JElF9mSTVzlFkygGNgh6g/7Byt7NDMak0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OjjNigLHmlKuc/QUzGt+CQA6vSbUiX5YYNOqo1sknTYCcM9GMGI0lAA/0oj5ipvFFwyVDxWa29oJUqYEORszdMFonPvuEm9hq1PYE3kS93qbOH1HVZAGI3ge5mwYFiEaSHXX6yVSSW8AZX1LUwL4G2a22jeFYSKjYxJNJpfjyQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PDSHOUN9; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PDSHOUN9"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-78a3bccc41dso51323285a.0
        for <patches@lists.linux.dev>; Thu, 04 Apr 2024 13:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712261959; x=1712866759; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zt4DKHBY+VHDIhqqlQCWnE/AGPM6SuI6iCdlV3YdRD0=;
        b=PDSHOUN9hxu4gF1xysLoBLxb8jOrv4eK5iqlXj6wRZ+fRXCVtp1wNZ59Sx0qInze/5
         nmLnqEd3hf8VU5/Jb4szwfCwpmrEzBl4eaiztffXhkHRAcQWeEoitGz01IxPxcf3Z1ps
         6+HaH360J8MJfKMAkx9S+xHyNejp2H1HIbD8+YeO6kvyjarPfPPPeBuoL++IhsTtZe/V
         9KRPh5EEF0DwTrvkxP0KkfqdBf6fA5VeCqpxexCTs7WIFIioCdYqfWHD0IzaanHFM3M2
         Tguub78xOdENisv7dv7sB6o4fZeo5GnOxxh8zRh9sXwkGD/bq7lkWYhc5McBvqpPBaXE
         vY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712261959; x=1712866759;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zt4DKHBY+VHDIhqqlQCWnE/AGPM6SuI6iCdlV3YdRD0=;
        b=hrp0ykFUajCIfktPLhwXnoDuTWS+m3AylDs2QXmsPPJHXqy+TiJzAidr6llLRbub5i
         QkxJg19AoGLNguS/H2pSKnShSmoEm47Zcm7NYqRhuJG4dKKLbp31GFO/hh+1h5hY3773
         CEU7nG4b3TRppYIdGb9PovvTPWhFfDEWKrwDFc58kQLWcJ7O2jdZB34tbARe2AHnzm/k
         9rP858aSS5jytH/5LnN73vHx5ZHnk5DYl8oEwfG8UcEQAqsMXrpEsV9Q9SpkrXxfHDBe
         Qh1tC4Fr5dIzGOExxYUavnvYnqTgDZf9bOGIKNXKO/ylijBvY1d1lEcf2svui2/S2VkH
         ykYA==
X-Gm-Message-State: AOJu0Yx4xJuuVGEC06Nqgu83Uxi0IkPgDTgZM8wg7IqShCiER98jINJ6
	XzX1luWuL/PNty7P82iBeclihw/z6DmQJpheZqU9htu8IcVgtSWr
X-Google-Smtp-Source: AGHT+IHBHhv+pwO97xTouPmxltde0KQLvJ12DR+Cx/wmhXsuBOJCWB0WUtvNrCMHWomdYZQTKO8j4g==
X-Received: by 2002:a05:620a:5685:b0:78a:462d:1bda with SMTP id wg5-20020a05620a568500b0078a462d1bdamr3904328qkn.66.1712261959179;
        Thu, 04 Apr 2024 13:19:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s9-20020a05620a030900b00789fb5397d4sm51934qkm.100.2024.04.04.13.19.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 13:19:18 -0700 (PDT)
Message-ID: <003e00da-ac9c-4c98-800d-fcb5383a9e7d@gmail.com>
Date: Thu, 4 Apr 2024 13:19:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 00/11] 6.8.4-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240403175125.754099419@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240403175125.754099419@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/24 10:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.4 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Apr 2024 17:51:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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

