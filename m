Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF314457B5
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 18:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784745652; cv=none; b=fNAWpkPf1Te1fodAN08o2JEanefdhN1pXnvWLiV2S3ypG3Vg5++b/zAu1eaCN2umikE+u9sHODSuWeWrYNzzWaylvFzXqGLXSdNchRhGFs/4HvUcE1nourkYjsZkc1ztw90Jut8hahhdUtVKL6Io/GhWsSiLrA4qQTYz30pPNpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784745652; c=relaxed/simple;
	bh=7qZBQPeaTZoAMVx8IfJUlVURpmaaUj1MqqDnq1C4U9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xj3qDc62UZ4N36Lt+D5W0TkKJn0wnhSs5F05qe55YM8wQWVfCEoSHymO0kTJd1cui1cYRdG1fNSZRdAnYsrKZzA5m+o6kLvSHJJ23RTVGPrqrwqdLhzAx20oA7kdrRdIGhc1eXsqCFLR7qUY3R3cbzGbedJaDk8IccBg84liz3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gxons0XV; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gxons0XV"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38dfe7eb825so7552832a91.0
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 11:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784745649; x=1785350449; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VdNCdLaik619FSQBqF2V5/e4A360f7gF9xZJF2Ihnx8=;
        b=Gxons0XVq/xlWjghBC50Q95liGUAiiZ7Fm+YLz7c2ziv+Qe5fyPneputimIProl1Wh
         WHPYJXa8Q8m4FMKUcN7WoTHzwx9a4ZNLV+dWbQxHtucskQ32dRThFvIO2WsqU1TwkEfm
         wr1rKCU0tVH3jlUkteyYATthFGD7FyO3Dz7DLFf1tWiLrc2YJb5pXUBcIgXZ/bWlTajy
         7RsXK+3wnDOshOYjbP9qIapsAo1g3D0FXULN8HmmXF/Ucmi3EILsaQjwlwqLaNXA8OFy
         YsGubBNA94mj+CEemmw9z+M08Q+gdwwm9A8/q43/rV8tsBhbRcZ69zVNkqTlQ9FwkwDC
         ZWjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784745649; x=1785350449;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VdNCdLaik619FSQBqF2V5/e4A360f7gF9xZJF2Ihnx8=;
        b=U9Fw/wXERoTchqq/URgvHANJ/Hfj7h83RH5ZCE1/5v2Q+91UkxC/2m0yQ/xhHbl5Y+
         LVksgQQEnUS3GVDAOoTFYK+DYquQSu5nbqAt3Oc7GL9XTn7Cyt3J5aZ3T93MgzQm1qV7
         Ly4vpLY8zK9R65qdQTHusLD6OtnX73Ljiz6iMehhxAI1hEGZMEaBu/R66K3epdURxvjg
         1EHjE7yfWvL632NEtf/5PYZpSUe5dUlsEUpD179gKkNxDKz6z3no4cUZs+k/Fl9rbGTU
         706UEt7Ys2GQ8IoQsFkj+ncqs31+mduyIIewfWKU0Xa/RYH9+VPntEvy3CiJXV/3CnYN
         at9w==
X-Gm-Message-State: AOJu0Yz5d6Gqxko+oxKZ8ciyGGHfjbGFTfXCLefkUv7mb9OQVNqRrYT9
	1QVI9GV/K4RsFtKCp/SC7Ut9C2QQyyN/EtMQlJA4N6NfAzGdTkja/FXz
X-Gm-Gg: AR+sD122vi7jqLsNzkAIsqFNJAmsGWT97UmbIlkUBXJRc46OK5nIAX0a9TTYifoEjx4
	4LBFx+VcXpe58OuBWMtSmaQ2swnZl7SfNweZkvGTI7sqz71rYJKhm9FDZ0hsGB4qbmEST5LEJyp
	F6z/NTJYfjezUI0owHnXMSCY5nXEXjEkZemSb1eKlUfOyA2R9/PuqTsM8euZlri19q5e1yNAGWa
	FDh01dDNpa0jgnKT3sQb/fllx+G+BOqoCbLsIs5R3lnr3W/DBPaQK3LX1XaVPOeczuta4OYEuCf
	6X4SUXPYkgMq3CIeMwpe9j/sj+EaLxW79WmKEYfO0ZSKvZFvZY60rCITWCSGyAYpGZn9BzPumoS
	vMG/jDe9NpNs5fk5doa8WoFlPbyeu1md8SsQ+lHgHInnyyQ4oyMvra0jPWHqHIbzqsazMj5Ruui
	H5x/wYTr57BWAM8bbz2T/KXO/oW8m6
X-Received: by 2002:a17:90b:3c43:b0:37f:9ce1:735e with SMTP id 98e67ed59e1d1-38e4b537ddemr24352815a91.31.1784745649456;
        Wed, 22 Jul 2026 11:40:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d13003f12sm14193359c88.2.2026.07.22.11.40.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 11:40:48 -0700 (PDT)
Message-ID: <5d794ae8-1aba-4394-8937-4057c1998d46@gmail.com>
Date: Wed, 22 Jul 2026 11:40:47 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1202] 6.12.97-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260722142834.868902312@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260722142834.868902312@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/26 07:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.97 release.
> There are 1202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.97-rc2.gz
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
