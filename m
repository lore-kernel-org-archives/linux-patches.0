Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6281F463A
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 20:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753906132; cv=none; b=meik3PCaYtQxYZAZdSPY9/vvuVhnoKsTZe7uA3L/eKSkNPBNpwa9PmBmW47zWUaBUT0aoS69Ri6oAXbyae2i+F2xj9Ds11ik+vPXT5XG9oBRjJ7mWMt/IoubEqGBXiMZn1OrQUtFaGLrJXL4I1dCtP9/em+RDzVzVLfPgo+JCus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753906132; c=relaxed/simple;
	bh=I2VwIorDAW82CA2/qdCBZgMLcdD+U2jqsGaJ1dMtPxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OLT8oUZitgjonXRBI86nwdE5um9PuiDn7Su6SEIdnYQNNhC1BG6kSeQstxNnM5joHdo5X0X7ifJn1HhfjtI+ehc2d/F9NK0/xcvxb8KycF5+WAQPqzINGwd4IteblSdyUmAi3xCC3O71pgOAjmdWpq1x8bDQBa8TR28S1gnIzdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=OuVw0GrZ; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="OuVw0GrZ"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3b78d13bf10so240816f8f.1
        for <patches@lists.linux.dev>; Wed, 30 Jul 2025 13:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1753906129; x=1754510929; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+cMNnDttzZ6RQt6wGgmmTCVQa3RNZnes1HqAh2ZhHsc=;
        b=OuVw0GrZOBihZISJS/4RretSFesbe6JA/LDsSl5PFBkXPqXsqNN2/MZChlG59hw8sl
         1zFDf1aOSqv2jCdzjsoIc98OvyprprEYD1htwVMRcwijm9JSKEh0muSDkvpslll6kvi7
         Jl2cnlQd+0CWAk9e98YkMrCyfNvsTGbi2s/75/wzbcp/0fjl7yEnFuTJdxt6xovXKmBX
         pdc4tD3luGRrawFwodzDs7slbhhHaM+AxivFZcRnxgSRy71KPrHLJJgk5E28rjA7G0Y4
         /vNE7cxRQi6X965vPCwmR6RHZ+rP+VfWn8/wTZK7YuOI3LQv8pnwAEjeei3AjXnbEuGY
         q32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753906129; x=1754510929;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+cMNnDttzZ6RQt6wGgmmTCVQa3RNZnes1HqAh2ZhHsc=;
        b=Xdzp+Z/B2taFYsk3YggSD1Lh4JIQBlNv7HMmYbV6yDc/dk9Nsv+flKGo/v7dG/Rwta
         LE/kBt19W5Uyk2GjYxfmT4rQDZ+z1AIQazDENS37D6XcfFYCZQk6lUNj+sGp4hk541gP
         e+EgLZUp5dAMUdjiFhmOuIDFOmKi4tgEKTBRXrs4rTPrlftceXCfO7JGiSJtMtI4CBI9
         p2rozMEY6A9K/HOaXYW2L6q/rWFZh9dp23h4pLfUnvEbywy14vYewZu32d7FDf0vTiIi
         lKIM2/WVCZTnBCGz5YIGGPq4Ykna48FojnMDZFPUa7KjkPnh44zGHWvJ1aFMsPLYdtW4
         ERsw==
X-Gm-Message-State: AOJu0YwJOBhdqPHMp95RKFJj1TG0S0r9lr9Dx958wR3Qe44BjoIcAfX4
	5htBzugNLQyFe+Wf71pc3i/ejtPhv/DQugjlYnNa7HVjLiJIplHeZxk=
X-Gm-Gg: ASbGncsP3RH0VWHkRqbV5QAA5+ThqpwcVn48QNRZd4gOZ10pWB1GyUhun98TRoK5fA9
	1We2UpBWUhog+50rVh7eDdP0wkkuaV489UJMAX+WNFOzwfMVjDcXMEBHYwls0r/8eUNnAcDRs1y
	jpitVRhP+ER9WFOmtCSi/m4M7TrlZDBK/EAwx2674O/Uu0E2dhgzKEdPIsyBg3ok085iZv7IYvF
	77TfJUhQNYNF+iqEvtnpNbfPo3C8eRdjxzjqdsXH8P0iyuuaSy3pKDS/ckivY2AcPRQrNmykVTr
	dv9FmQVt6BTlnA+4crUpeLjf/OEjIU+jbWQ8eNv2TDBFm4Mp/hx+QTt3vZzsX7KmW4GZhC+qOL/
	1ZRg9z+xZYHqmgkIGG8JKmaYRxBfNGfLP1ejskrVB5/6kggpZ+QGZiLPByb6WK8AeAdzvsOpimr
	/BCTzFLksTQA==
X-Google-Smtp-Source: AGHT+IGbbeFnHcOTsEgMeBZIa911Ksjql+ptroLdZznDSsPIw7/H4yUH8bndCMfzMG5rIym/4F2a2g==
X-Received: by 2002:a05:6000:2003:b0:3b7:886b:fb8d with SMTP id ffacd0b85a97d-3b795026234mr3404428f8f.31.1753906128897;
        Wed, 30 Jul 2025 13:08:48 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4284.dip0.t-ipconnect.de. [91.43.66.132])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3abe18sm14384f8f.2.2025.07.30.13.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 13:08:48 -0700 (PDT)
Message-ID: <c0060290-ee3f-4b54-8b16-50a1ea5ac2ec@googlemail.com>
Date: Wed, 30 Jul 2025 22:08:47 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.15 00/92] 6.15.9-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250730093230.629234025@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.07.2025 um 11:35 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.15.9 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Built wich Clang 20.1.8 this time, boots and works fine on my 2-socket Ivy Bridge Xeon 
E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


[    0.000000] Linux version 6.15.9-rc1+ (root@linus.localdomain) (clang version 20.1.8 
(https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261), LLD 
20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)) #1 
SMP PREEMPT_DYNAMIC Wed Jul 30 21:01:43 CEST 2025
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-6.15.9-rc1+ 
root=UUID=3842ebdd-e37f-4e4e-afd4-d7eb79b41984 ro quiet intel_iommu=on iommu=pt 
vfio-pci.ids=10de:1201,10de:0e0c
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Hygon HygonGenuine
[    0.000000]   Centaur CentaurHauls
[    0.000000]   zhaoxin   Shanghai
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000096fff] usable



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
