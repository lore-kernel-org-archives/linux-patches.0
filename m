Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500C14399D3
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 18:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784744066; cv=none; b=aTikelJLUuhfbhPhJ3QfhgbtakJTipUS52a/GKQnRuvXmyJZw5rnqKLPGw5YdDoDqWD9N9Bwnt6Ixf2MSHXUHJdpoC7xSk+doWiJkMkYEEANaO22PjA89R9hg5imN9oAUWlKv6pKIigX7b3QOlX64tayQuc5RGxRpCuuU0XkDt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784744066; c=relaxed/simple;
	bh=YOPoIUclH28ukZ9YepMYS8Y9xPg26QbGbwJ2RgkS8iE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GDW6QJrxRFBRpOUvzC+SxRsYd8DZdZvERJuht754u3qoDAXvLhclVmYeZdubLV6sj0qZhOWxfXnH/s9c95kmteNtQo9S4mjtxiPrIUK/JJah2O6EV/U1SvT9kvgPprFwwJ4hEUhMik/5FEc3AQTtOQsydhINE8PHVOxhbqiT/eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vp0CV549; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vp0CV549"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cae1a3a744so96745255ad.3
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 11:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784744064; x=1785348864; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o1nxlzxXGxOHYHNh7Zjh3tlK7oPbDKB3XdsU0h+O300=;
        b=Vp0CV549t4onYF68z5T6ziAV5F85b6v+7Mw5hQ5n3a4HeWsbpedYlIgGFY8vhkqHb3
         yflfFpiMBmCQbaK8PwSL9U20T3jnUh3boGaWqDek39Lo6ALPSJb3vdgvGl5fYzCOAj2l
         p98jDKQXQP1cbX1KobaSJIYfm+KJpLSjb+oxigwtrpfpatrDtJURerenv8TsAoxVrct8
         VIz8oals8YCn4ojVd1peccO1/klweZomdE8mnriAq1Yw2F8A/5bmfyaMvWKi4oWV6dAy
         ow+sgNCMusZkzTwm7vQwkOh1Yvy5KJSx+huwLHUQr7oJCXHp59eT/QplCBTEWhWDRD0H
         pU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784744064; x=1785348864;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o1nxlzxXGxOHYHNh7Zjh3tlK7oPbDKB3XdsU0h+O300=;
        b=MUU1PsBL/2qg4aNWLu27nA/tmrY0lKfLqqZ75GF4youiXEfgEk6pbM5HYbP0ANZ28N
         0CSuBEy0on7XvxH9lOruE1XhfEqxgYVei/AA7hEqzxPU2MLzm1uI9PPZZ4CGA69F7RY+
         UsT1wEDy+D4QY/2zPAIicxgUN8CPC7oDSO1P6boIpSjzZ0iZGMcariK2ae54L8cj6xRM
         W/GI3mTNKzYiSZxqx0/IAZaTiWtyX04uYgfZJVgSXR7zwQRNqMSQJt6aI5W9bsPlYMA5
         /aWSFA82rpidE/bL+7labiqtd5mlJgx1RDzk8bj6hyGoXB7sURxDzytSZudjMu6cTs9a
         fmyQ==
X-Gm-Message-State: AOJu0YwbhOxhEU2PCIWFBI1XjgGwPbsQTkR3daoKJpwbLA5SnVjSdZ+O
	QKQ7zEZD9IrDySij5h0N7I1b9I/sGCK+Aq5E1BO62Y0W5BULa4VPrsqt
X-Gm-Gg: AR+sD11g+ldcCcDaSfD5epvjMbLiofrtZwQfvxqZPjd+q1qcQ55ciJ5E6+p4DQOU/xN
	WLsmhYoHalwexSeSYVnYKeQTJwIcl3NJOZPSJUT7Awmla+YiUgy7OB4ziB00LTrEbGkvI6YBoY0
	oxVF3uj4/v0vN0zQlJk+WPC2WIwGwAKmTksxf5PuqnQw4B3ECZWtqMIPjDpMELsUCoUcWia1vFe
	X+u0UY6F2lCY3Qw2OElEC46/NrQhjADsz6r0ikl4/RYsbPTx8bbOeAg5mABen90OzRO41YxxehO
	QlLvasCRISU0AYzJbaYFtvhBBXPdoVaTm+sai2Xqnzr/GOrzl3Bj5AlX7vZX/Dc/oYWOTzKRgFj
	NDT5hKIY2hKK/BKNTDUBBVj9jEuPh4usnmYNvC9IyUzQ6IQ9mUN4f+xxe4i+uJX99tXj47D+Fg1
	oK4k5BZTnCXV5qQy/UyqFS83nt2+DR
X-Received: by 2002:a17:903:37cf:b0:2cc:5fae:cc56 with SMTP id d9443c01a7336-2cf3495ffe4mr257798985ad.27.1784744064473;
        Wed, 22 Jul 2026 11:14:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147dc6781dsm12391494eec.9.2026.07.22.11.14.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 11:14:23 -0700 (PDT)
Message-ID: <36bb4bca-985b-44f8-b3d8-2f0eb092fec5@gmail.com>
Date: Wed, 22 Jul 2026 11:14:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/812] 5.15.212-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260722142759.100285390@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260722142759.100285390@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/26 07:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.212 release.
> There are 812 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.212-rc2.gz
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
