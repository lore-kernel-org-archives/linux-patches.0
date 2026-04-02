Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9712374728
	for <patches@lists.linux.dev>; Thu,  2 Apr 2026 22:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775170267; cv=none; b=dJsCvS3XobPVPddcVoCxRukGwnVwZEy7DIxRvnr6T0x350y6upfljdzS3OGE3b/a5lqLD3A05XoS+IF1n8Oqzjmz3ZVo9TonQRb/NhR19LZl3uEN5w/0tTetNwn3pcNblQYzkyfuLhEz0TBkS9b/3Q8f6CB7PXk9uaLOl6oKC7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775170267; c=relaxed/simple;
	bh=0ZeeJM4QuJubzdrVlPnaK6gT4u5etGNsimdm2s6C0Pw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pi8Ps8lGKnrYtSSLDrogpvSEyLmWE/FGiK/pdNaWswDqYcNHgA/XwBL0ZFSTn+LN+A8Qhi2JRp5EjCqJxD2uaoVOZN3OaVrAEF+pcnp2O0c4b3FDQouYhJwgnhdgI1HXVgWl1ovZZZQ3KeAYy6SEfzaqi2BKER5t90wOpAFWGUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JunoTd22; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JunoTd22"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8a151012558so18527016d6.3
        for <patches@lists.linux.dev>; Thu, 02 Apr 2026 15:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775170265; x=1775775065; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cIQ39JUfKxuV8oXRIw8XFZkJM/CpnZ94rlBPTcNXAms=;
        b=JunoTd228EATUL8E3kB9Pl9mej5dD4eyh1Ll6VdwKHFpEMtcoKjpNLdS+bnTbWMKvS
         Yc0xTHeZmsr/nMfTyA1agXWwj+vNj2dRmU1Q8faQ30gFUXYdF/xZRc3LOSRNfNffd0sL
         8PGsWJDySegZoc2M4dV4OUvSV6JAjesBtvIvez0h6nR1unxgR08V4hGsCKUlxIJdEqSb
         ELS2N4rGJe1DJxI0HZx1ac3Hi4dtfjCOH0LDrxkrNgliRtUyrVF6wLPS9zk4weJgTMsc
         Upt7wmfoEZW98ScLD9LN3ZqENf9+UYCqaI5aAwFh2SqvVRojbVjZMy/ooINU5mHJ1AX6
         Cjjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775170265; x=1775775065;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cIQ39JUfKxuV8oXRIw8XFZkJM/CpnZ94rlBPTcNXAms=;
        b=Ed1tjg5fpmt9tt+KglyK8ngZNjvspgVm2IPufK6RnYdOCAhR1t9YLA0MdaYWVZoK+O
         OxUdaK1QIuY66mfwAPfbzlt5+rtc3FraMPVhjqx5AaqkXwD7dAJCy9d2BK3u+r3Sp4sm
         VFI1ZTMOfjPpjunk9sPXKKTHf2Rjmr8iwBpP0++egXGS1WMVlh1A6cKYMZS3xhqgKzDZ
         cOh4miSNVBlD3uAe7nBGMkjXfOfRIcOapiIYln1hEFmAXVLtlTXiM8a/BzBZu56LfxO9
         38q2ddkUjqa1KlcOUmfZBm59Ba36z2d1JcY+wf9/PEMFEW0bHRhHFKvE50L7qhoGUV1c
         4OVw==
X-Gm-Message-State: AOJu0YybTP0xW3V0spDrSfEKE1ohV4K3/b0czBRaNgLfuxjtnTv1XsEF
	0zM6xiXQD5UBaab1I2m78VxjcVPoH07slpCsDYKzJ3sDWsRGE1FtfjUZ
X-Gm-Gg: AeBDietLAutKNgd90AqMB8OQK94nIvapFomHfPIFtiU6/ANBa+4UJsF+J7oK10Su3tc
	Ywk9lgoG2oHu47fu/es6UlPKLkKoX1U20Dmg3tiPu1EG2QDSNEFuAFhpqTnA0hhG5ChGHHnGWDj
	ocL0ZxUirhYS2BIn8g7p1MaSRzoaAh3wOC8vSiFoh+rrEmijkQHgxBTuwORB/Mj9nbsibp/loVw
	fY6OReul5lvR7dK43I6latAL5yAlKyV4oBGnDBTlBTrO/Db6pg3IhWbSNFhhoVw8VYP+kBnO2kr
	1lTlNpWbTzlSBRa9rpTG7sk4aM8oD3MygGu5roXYSo2TQZxlcrrBAn3EZpqJUL81KxGNrI1xycm
	H/UI0xtGPAODpu95lpFZLNCzzC0DID/E3Pv7dXC5uxKufm0k28Gg8U2Cc5lWF28KH/SJjn+GXa6
	t7/RI7oL83iTnJdVO+FvF73opl2CTgUMGjjGq3k/2qHSnvzKicQg==
X-Received: by 2002:a05:6214:4e1b:b0:8a3:d463:da96 with SMTP id 6a1803df08f44-8a7046daafcmr15182986d6.43.1775170264726;
        Thu, 02 Apr 2026 15:51:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8a5977dac0esm32556306d6.46.2026.04.02.15.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Apr 2026 15:51:03 -0700 (PDT)
Message-ID: <fb0e46ab-6ad0-4ad6-9113-89f8363df6d1@gmail.com>
Date: Thu, 2 Apr 2026 15:51:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/244] 6.12.80-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260331161741.651718120@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/31/26 09:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.80 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.80-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
