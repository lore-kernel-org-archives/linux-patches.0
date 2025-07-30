Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B95EEEBA
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 17:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753896682; cv=none; b=YkkRwuuyOzKTGOtmj6aSf8kGRmXPlImnGzQ8+8FLtdNZTeeme6OBNiy+fR1EQAygOzsTMLoQWoeueNVSTy9NABqVndsDNEV9hpVcsOXMNpG3ZMTZPwx6NzZ2Z7R+8S+pgUDbbF3Js6NzJ5HRbW2h3jyT/8XmDIY3nUWG+bUJRmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753896682; c=relaxed/simple;
	bh=wh+OxDjm2ky6TsO+BjsktO3Xiz+K1KybX+LIivatlJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vB0aaxAOKiBNrHW8HreIdOcl2XE+0MVcrgWg4+hNOgFq73WSoS15XvLDQ43UNwEyIAwb925f7pq+MDAwPNVZy6m/4exsYAchrR6Karq92MaQckXtwtuNfxIg2Bd7Ld2ODIfKvn0Z5MMxH7dAql5Ck7rs6rSjxu5xMCDSmvchXfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=LM9bhU7F; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="LM9bhU7F"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3b794a013bcso75229f8f.2
        for <patches@lists.linux.dev>; Wed, 30 Jul 2025 10:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1753896679; x=1754501479; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DgAezQfpfvoELnWJXyHtGAEOwJomNa/aau3M286QXoc=;
        b=LM9bhU7Fjg0YfTHf5gzp59oIHaZTpEIkPCryD/6ikNtgAoFF29/VT8lrKGT1l3XJKz
         S2B0GPq13O0IjK3SMYO/W4QOFl4sf8x1hMKtSS+nU7T8d1hZSmRHNwDupQAeKR4tONPI
         Dn11PNU9JTw20v9loSY9/C+gof5Xb+zj8wC4FdIVVC8ArRgrFTGFJLceWbb3jJmwhHv+
         EwVDzG0PPd5PiUgX1CNLT9kSpVu7D35k4sRpFSTElmeXcYmP/FEjbwTa7II+Bj6GtCu2
         vIbt+uZxNckrwNf4Kaw+XcgX+4aKXGKpQsgXfiV6qWEEwPjxY9ItB3BSfC4jxJuWesWP
         s8jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753896679; x=1754501479;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DgAezQfpfvoELnWJXyHtGAEOwJomNa/aau3M286QXoc=;
        b=iDjo0QtkN8zlAKeleeYx9xLQozJ+F3K/1TsgfTYEkRfJvcicxuVbcDhngiHOo7SAlB
         OSzyyB2acFxUV2KFaP9hzYZ+Ni3N+8iGdm3As013s8LvhQPlTUL9+yr5RYShkTwplH9w
         aSf98R4AwdIwdMFY3TGZoG+xhDhjoY6pv3gQ4ZPOqf88hMW8R7O3pbnvQVBKYgPWad6r
         8hJtwznL8wFu9yxbBKeMTSbesNGCL+FNMHs9hzh/Hw25UKLKuHpU75WZZ9uplyo5JaPz
         2kSQL69SodVxl5wHGu5CrLLGXfU24DvnruQ/1OtWaevtip8Ktzt08rq9G2bhzptEdVKe
         ig0A==
X-Gm-Message-State: AOJu0YyTwb2/fI1Cr+JGbJjPg+vsuUzRJwuocjNVPCvzxg4Iy+J/0Fc6
	WQCquGLEkqiC1FgJYfPyLzrCxNKdSZNfX7TVzS5XgP0hBmDbH+1QLmA=
X-Gm-Gg: ASbGncsd3ly5UgP79cE8gfFuf+izUQuBTKSCgYJzqu2Da12D/aZ0cd37OA3Zaz5jKRK
	CdjC3duI5m+USbMTPOPerhlkaYsz2YB9qp0nfuYNUGwZinYssHvq0Yvg/wH3y9NYie41OLYLVWI
	Avbo8nDmNLnNo5jYW7HaNCSi9htiplt09MIm2FyRyTx15LhYXTviQ9ZdWtHGIgpHd5R5cqiM3Pg
	iIYb3UuyYBkJacn2ry9tJfSNrElT1gz2zgcDEpyQcMKw/FDda/rpyBno/Ox/D4m20NF11kEguTc
	ql7VN+XfjGDqWQOhO5dX3rL16fqUUIlVzLrCiqclq13QBMlfYoUQXemV4pGeIKeXw96GnBgwYuJ
	oZhWDRyIIIlXihUWiOwhfNuq95UMtTaP5RnzshIcb7IbHZzpQMJc3/2SSU6/uwi5/igh9DPhb+K
	M=
X-Google-Smtp-Source: AGHT+IEtSt2YP/r84p7bemt90c5M7i6/iVLdQs6GJqDQf54Hhh+r1spT0+0cyprZiObRj5UZUJ7U+g==
X-Received: by 2002:a5d:5f51:0:b0:3b7:8da6:1baf with SMTP id ffacd0b85a97d-3b794fd5940mr3365633f8f.16.1753896679003;
        Wed, 30 Jul 2025 10:31:19 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4284.dip0.t-ipconnect.de. [91.43.66.132])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b778f04009sm16894324f8f.38.2025.07.30.10.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 10:31:18 -0700 (PDT)
Message-ID: <5cc15441-1759-41f0-a987-6f2c0473340a@googlemail.com>
Date: Wed, 30 Jul 2025 19:31:16 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/76] 6.6.101-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250730093226.854413920@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.07.2025 um 11:34 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.101 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Built wich Clang 20.1.8 this time, boots and works fine on my 2-socket Ivy Bridge Xeon 
E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


[    0.000000] Linux version 6.6.101-rc1+ (root@linus.localdomain) (clang version 20.1.8 
(https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261), LLD 
20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)) #1 
SMP PREEMPT_DYNAMIC Wed Jul 30 18:47:00 CEST 2025
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-6.6.101-rc1+ 
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
