Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29944290E
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 00:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708562699; cv=none; b=uCQPxx3dEqyIzrV9O2NgfwaVdEGAnXHPcqYjdQAwujLMzf4wYH64ygwGKEOb2VgqDNC1I/CUSxUZ4BVgHzmGjh4/+LZHtzQsuUjkH7OhgGawto6lncl9WVPDxwM1eRX7uR0FKGEiQFV05F+hm5lvsVEzMz//kHqJJXekb8z2KvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708562699; c=relaxed/simple;
	bh=FTQVWoTN4udNIev/o61f7h3z6g9hy9brkZh6+BJLBuY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DJnUVoY4oGMxo9Tokw+rlM2My7dAEmgDTpPI4oLOrRsxzFv6ZA/a+tswrdOBUW5cqZzbU6pskTn1K/GNG0N9Ry9XQTMKhLXZ6YLehafFn6ViFAmS6Nz0htLeIstk+yDbMpCaMot9qrBtiN4mH41wgIxQe8I0GQVCSRawOVTMp+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hYMbbspc; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hYMbbspc"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-68fb71fc886so1856166d6.3
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 16:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708562697; x=1709167497; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p3b/ZWjoEVuTPYpZDzQMf2PYiptTKxj9oR1blBf+Uz0=;
        b=hYMbbspci7XqJ3X7XwKiJruSLlnbkzYK3K/JHhmINyx8O6HbjGJhU8Ve5P+/PfvAhY
         03OyIugM3xDNI66/gU7JN1VzQcZz0cIGEP3U3sGUU1qT8aDN7srAZGGTUOj3VrDpkrIg
         Ee0WM1CqygKjz8khqHiF060vmW7HW2xVHghr9/03wgyhhKviJIy21QTKHJ1BQFp1rWMe
         PAUgB6lOlJd+rDCt1DiJl8k+P0vQ64toCTh80OWrRpaq3HEMrZBAPQ8J/H5HZgzXVC/J
         pOcaGzQczIHMhnv+VzFGDAJM2C1Y5l6hMoPaXLAbq4Ow5DbykT33p89lF5KSX1Ix2USg
         v9hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708562697; x=1709167497;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p3b/ZWjoEVuTPYpZDzQMf2PYiptTKxj9oR1blBf+Uz0=;
        b=vqnWCLO1Gbcw9JTzvWPtcRuA8wcYtLoyMfT+txxtZaAmRAtp5JN4b5/6iePxUBCgWe
         QyqbCf4CorAYPd/ekzcLsm69jRLi1s5JPsfxhTn+ym3vFJgZnd7mtvvHwvi+vWIlX7td
         DIDTM1Gsj4wZ7bS2rVjJvkJOTKutndIeghsHK8In2zEkHtbOxrfNWgfdg3LfCkhrE8QS
         VvS9rG5J3OViAF6QFoJfFNiUkcjQmRnmk1IszYFB9fb7VsIJH+RbKOIAWzUjvpmfiyt/
         ECbu2bMH3Ud/AnX1i/VrWN32zuh6j+6FctypFRYnlju99xobifzydDLoDlW3wFyM9Gt+
         iTWg==
X-Gm-Message-State: AOJu0YyLUDayYOlJx2SHpgE2Uk0SUtAQ2o3N4gKGGITR4zWPd/pbyTZY
	0iUF498hAlQV3Juuh1FGe/7V/aqgickWqQTGp08WuBte+cmlIiKI
X-Google-Smtp-Source: AGHT+IHP7ox0/cmyfpIm9AiYc/3Y4/0B0F+cltZOxZ3nrUw0EDHOpAnz7iXfd2eJAokwNVKN2sNoLA==
X-Received: by 2002:a0c:e0cf:0:b0:68f:601b:9001 with SMTP id x15-20020a0ce0cf000000b0068f601b9001mr2928662qvk.23.1708562697083;
        Wed, 21 Feb 2024 16:44:57 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s9-20020ad45009000000b0068f11430971sm6107220qvo.35.2024.02.21.16.44.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 16:44:56 -0800 (PST)
Message-ID: <0bf4806e-0648-4c35-aaa0-7b3f1c177f0d@gmail.com>
Date: Wed, 21 Feb 2024 16:44:51 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/338] 6.6.18-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240221125953.770767246@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240221125953.770767246@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/24 05:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.18 release.
> There are 338 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.18-rc2.gz
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

