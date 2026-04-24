Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3380B37BE7C
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 20:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777061867; cv=none; b=lfSDoUv/DLgBaH0fOVudpLbmRmgda/iV04GMasxMqzuS69djbFAL63qz7Z21aaBXtjpS4WXOW5nOyj7/v+4f17gfbo+kA3VaaP3wxr8RpQPj8bzSfjys/GQk3kUH6oitFdnoS7AUI4HdZO/csOSOAEkd9VhJ5onZw6cbcd8rCGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777061867; c=relaxed/simple;
	bh=Gkl1QzrZ7N4bDfiIdKK+4iFDj1dRTnHohqu0nRIJo0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JluMQ0e4ecvwLziQLPOcYCk31Qc/AXX/QeetX1vBpfWO1KGOPP8fwHYdLZn4C1g9EL5BNREMRQ54uVHhothY0JwtaM1puTryW5Jlm1yisiQ+sAZ0nXKgzjApL73PM1/4poqR3t7RKu9bX0nUVVuKsblKhO2JMrePT+VGmtMByjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cxDsQhWH; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cxDsQhWH"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8a210c813f8so55531596d6.0
        for <patches@lists.linux.dev>; Fri, 24 Apr 2026 13:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777061863; x=1777666663; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7c2lMMSx8lhoxtQP1VdjluOjQF1ubaN8Vricctt/Pq0=;
        b=cxDsQhWHrnX8BAowYy8tdE6LVzCviqBQgJYYIZxOwaJEmUX29iNOvnpvHO+sGp2lRA
         xeDTaG/Jb5ljjNMhL26PkmVkKutG69hNlX9Lf1FqKDdGeBto6ycH9Yu1OMloEvws89Nt
         jpRIGZHlYRaqJ/jjuU+AeJ/+Ze+faumOLKtwUQr9tiZugbtuYBq/15CoJ+JrKQGV5JOQ
         XVVmQsMYtRDo1VQaMMDU6hR8yXXTD502qNdq90NJKqcurkUMwGrul6lvxFEGqXWL7kbr
         Avd7WeoORjcZZAT0SGC47h8sv63TMMw1wXnRr3tTVnhVrehoi5DFaIcVCrCJnk6kn4Wa
         Bqww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777061863; x=1777666663;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7c2lMMSx8lhoxtQP1VdjluOjQF1ubaN8Vricctt/Pq0=;
        b=rdac2ubXkeeuqtiq2xPdWMZ4mpG4V1R7BZOEJFZYINzu1y5oHBVDmAUyKSSqrT00Yl
         01aKTOu5HfCOCpQWZRcAXGTGhLYDZIDqirl5ejB3ZwYPCYK4YPLpJBZRm6u3ITib1J74
         /qzimkqbNDtdvRQg2aTqXZIpBterSNw5rS6DF6BaMpi6PfuoPW6aF7V8KNjyfVDezhxX
         1jFaofw5CtcsQxuI8h5nCU7dygZG/fDQVkt8a6EaOx+Lt99BdVBPCtZRBa1Qf9OWAvgR
         BGd3qnY8Dx/Al4sXVowpwIua11ZSlTBL2DaJMOeJ/4MeQPVi1dWva5MakG4OqN266orJ
         W8tw==
X-Gm-Message-State: AOJu0YxKb5qhyI1gwP3RY/jsOP9S7/zMdlKKWUi3/RdrJqJCtztnVW/Z
	rrVLsmj8QEtQwodTJjCZSbr6fM6zue8c+uEHo7HNBDdgiW8QLQjTVOdi
X-Gm-Gg: AeBDiesUH4jw+nvMpVvgudEA9aVF1DH6x/o1wZnRJQ78fnYo3469BcLr2FaLKu5qlgO
	6C+L4evSFeHCJQfmR6e2t9f4yuawBkRZgiMMe5+aWiaBYWTPk9YNZzOPA251TmE2mYDM56opw5G
	ghS/ydRmsIrZ1Igajd2SKIQykLQDv9xkG/cMtP6pdnLyCSmG4tebbIe3lfnz63dQY0Iw3FJW6le
	uOyLn3WoxrEbFSu2M0tpY8gjarrg9xg5Ks48pti/GbV0VBshvKgpna7dY6rFx0iVUXwVoS+eNeV
	g5XUkJfn8Ayah70K3ORd1OOLtalqh2WC1DTjtug04gaX96e4C1UBpwy9paoLSG2mtCyxc0Z5l5b
	axYTeT7pU90JPdkgVRuXZqdBsNd7NuXXZ6/ZoJcmtMz5ZBDInAIBdwreQ73vBdgKGpaUAsx34iM
	ZHXozalOigAMlZmXO+58l3P7Y+1GUS96/GeoWcYYUBChWwOCWlmsGmCWfq7XTq
X-Received: by 2002:a05:6214:5912:b0:8a4:db54:b3a4 with SMTP id 6a1803df08f44-8b028013decmr531322466d6.7.1777061863457;
        Fri, 24 Apr 2026 13:17:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ae5c4b9sm264466736d6.28.2026.04.24.13.17.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 13:17:42 -0700 (PDT)
Message-ID: <7589e56f-cb44-42bb-9427-cf0ec65051e3@gmail.com>
Date: Fri, 24 Apr 2026 13:17:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/35] 6.12.84-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260424132411.427029259@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/26 06:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.84 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Apr 2026 13:23:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.84-rc1.gz
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
