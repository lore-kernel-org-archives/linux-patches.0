Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEB130B50D
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 02:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330802; cv=none; b=gm2hIc7w+11t9eJL5RzZlrMXkjGpvA4yGCaDBKMlomTmwFm5K0VhISWcpr+Vmm8lVQgt3UresE203Ebrvqx1oCa5bqBRrtdtjkp0OZHxgIKljU77HxX3TaNYEhTdeqhQNiyJFWZHG2yqnMQ0tFMq+igZVb9whV3LI350E4Drbd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330802; c=relaxed/simple;
	bh=5WaUFU3bGZiPd41PvlAvIlK6JQaJ4z8q5ub2AgYB65g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=biHa0rOVZvwL6ZhonPo5kS7tiLMSEPmxKyhYUhmAZpPQu+WLdcUA0kKYKtObZ0ihrqg8bUe7TNCNQ9xEtHrDKtRtUlrF9RRppJjVT9fgaLek6xtjxY5zNByDgh/VkbDaQxbCTkRzYSYkV27HX+moINfE3rpuoZyoTEVk3gueXHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=iN2ZQgUI; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="iN2ZQgUI"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-483a233819aso31906295e9.3
        for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772330797; x=1772935597; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1RCAALCUk9Fp/MgQGMAl9mSO6ME2yBDRqbMEN1gfDt0=;
        b=iN2ZQgUI9xMHWUHpwmto8d98DMJQXoDSbylZYwBIiTboa7ouoxU//uBoS60xyLnBnO
         H2B0FT8xRK9LXP33ukXQJEug6WHa402SS5e5PkOYfMVBr5uxUoe0OyET8PzOxnxwiG6s
         hrtVU4Dmc7+DGdMxQnuk0EQmRBwG3eoU8POLpehLLdyhVIhcaJyewEn9Z0V7/eYZ2Oqd
         xoIJLtRAqaLrzcBCmvQk4ywpL5112H9soR2L/KcWOLVqdu5gOE879DvaF+AJtOYwnACw
         VIIy3NeHf+OSCslyYvr1NTx6I33pF/cqd/GZGam1+AXkZJR7+CO9GMwxkmCyp8zYe326
         z0sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772330797; x=1772935597;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1RCAALCUk9Fp/MgQGMAl9mSO6ME2yBDRqbMEN1gfDt0=;
        b=r9AB5SeCl8zLWf0ecBHaEYVUOmUu7O7UQTMOPUINHVHqsiNeuCR5C+NvDygXYvRub5
         3VbqnYmhmlJa2SWSThkAwXnEPXPuukmthSFunpAAC5xzfiJoCPo2hkcJnuAyzGGMv1+J
         CMVTWaRwfCsKVmt9Eljt7D3j39VGuzwhhiNpx7kMxxk9fl3C6Ch0yL+tlKO3DFR8fJTN
         0y1jm2mWHqP1TB+KFMUG5ZomH2OWnzoXfJfNHn0QgTn5wEvdZ0DZmy2WrcUWbQVmgPVD
         C9C38rGcp5B5DcwDRQfP5UaNQB3iTGTaMjbDum9aSDftasIMj9qX7+DdEAiGqTYaK0Uk
         oVeA==
X-Forwarded-Encrypted: i=1; AJvYcCUsg9QueD1JKw+59U/WjaKSxotsU48S83rgl7zyea+0m7Kt/Hk7I5l8eaSHvAKzSKx715aCJuVC@lists.linux.dev
X-Gm-Message-State: AOJu0YyatvJdXMmh1Q88wlTeUj++ZRHzdhyPrTSkzbs7u94gbehZhN89
	AvBcr/T6ZrHBTf8b/Fu8PUJl/MxQSiNG2w2hNbUR3rezpsfzfgG7CG8=
X-Gm-Gg: ATEYQzz4yrHmPNVRVnC31WG/ShQS2gIo/l0IA0lw3lTwCFlb+N4XRcTz/IBSziWuzRT
	b/J9JuzYJthp+w7IkGgh3O5Yi9qK4Id7MoSeMyNPZ6wWFxSCOzV1WQCgFz8PR/Zfa08QBcRh4aS
	d68Ig/xoCtp68SQNgBfTKdjaDfAaVWvNhmotL02h9KiGCDGMwdnbXk3JnmlyzvWeQzFHujYJB0L
	HZZYUNiq9euObSfifFQySvDKY+XcfWg05p/jPspDXscG4feQqlhRWJ+Wg79gtdIqtAfmz7i8cHt
	/Vyivk3tX8Zn2EAFdmzAW9dRKQGllNPGQASR2e6h4CTjrN6STNolXCOysH/O1sKY4qbvCnVvyE9
	rgYFf86F9ti378JZbq2XCMyGPToMXQSWQSRulRfxVRaSokcyDXi6rY6b3+TPAkjY/s7khD3Vjdf
	z/Ar3v7wP2Fa84f2z12FkoSL7Xn5k1TpirAVByI20QXawJS/F4e2xx6iqflBV2lfEm2UdYPi/B9
	9NP
X-Received: by 2002:a05:600c:6388:b0:480:4a90:1af2 with SMTP id 5b1f17b1804b1-483c9c2c2damr139958575e9.35.1772330796525;
        Sat, 28 Feb 2026 18:06:36 -0800 (PST)
Received: from [192.168.1.3] (p5b2acadf.dip0.t-ipconnect.de. [91.42.202.223])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd75df90sm326947105e9.14.2026.02.28.18.06.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Feb 2026 18:06:36 -0800 (PST)
Message-ID: <a71fa783-743a-4bb0-89e7-5ef1beab3255@googlemail.com>
Date: Sun, 1 Mar 2026 03:06:35 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/752] 6.18.16-rc1 review
Content-Language: de-DE
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228174736.1542240-1-sashal@kernel.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260228174736.1542240-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.02.2026 um 18:47 schrieb Sasha Levin:
> 
> This is the start of the stable review cycle for the 6.18.16 release.
> There are 752 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
