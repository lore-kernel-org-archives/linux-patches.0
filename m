Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB72305E20
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 18:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760724233; cv=none; b=dKpPaxfKax8MllomJGpTXlQuPiAe7vEL8W3RmkbY9lU4PqgQQY6q2QCZBhYJnAzMa6fqkqGigwjh2FcEJkhuw11yn9n0Oq5NW0Z8Yqz0X1vtJypbNL7RG6Uez/a3xeNre1l2cMMe3pLYe8nAOte+xitx1x9f0SsnGpHwOTmC6C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760724233; c=relaxed/simple;
	bh=Zd6MLzXBrF3mpg/jucxRLfjpyHBbdXhPs5C3AwRQkj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sxLscG86MXiUvX9cmePB6xARkilb12Ssr8ua82fEmFn3f/b47BUf66wZvAye+d1OWcprpmQb8nHLXDJfayRIWk2KeVRpgeVODZjK0RlyMaVdANx1kReRAhwZHLpIWiG99YO0+TB7MI5vRmTS5PgneXAHOKkTY/X5BBqE+tivVPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JTL08YKs; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JTL08YKs"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b553412a19bso1494117a12.1
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 11:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760724231; x=1761329031; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=M5EapXnjhItxlB8Cc2OpFphDcsDthW/ApWpXMbKY6Ms=;
        b=JTL08YKsCj71av2qKyTTF5f+sl5W3rpsInFTumYA+1CFv6d4bfEbrgxf8mFfnVHXED
         GPGrgEiYKZHNn1E+B/xHmem+xLKgOb4svQd+p2ZNQ4mZihcYKVnZghLlPREomGQ7m6dP
         x3GaUg64eHxWUqZhA3CmejeQaCrTcpcJorQ1GHPt6D+b9kOqOi+SWbMsA0OvgFUeeAje
         JoYraggi6AvQqqcT1fPjnYFckmLsyX5L9OQ42t6iAIbb54XWiRdTUOKeDP7v1a+YthzL
         ZcFZs2r3pPG2lOtaDkK+aMovsvJBDebA8MTC3+0p2ygQPk0+bXiXnCGl76QULp+W2lQc
         t88w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760724231; x=1761329031;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M5EapXnjhItxlB8Cc2OpFphDcsDthW/ApWpXMbKY6Ms=;
        b=oLmug/NmASmRgyKvdpThgPsEdqgxdIIhTbJEglP6q1ZqskGAMjvFHgs74vpuh4iXq7
         WTDhkI07TiatQ291fNSocHzNNdFZfxRAOTukn0/ke/2dGupyc4to7zCJdLwyJLbjG4ME
         g6t62k1cj8yKLwfmCJBUjIsRVj8N6gzfZqfFO0YBZtWWalqRDNyOu3woLKJxf6uI45cD
         iLJ3UaAlwFLLiTNHa9oCSv+/C4h28Ta83gQc1q9aYZQQZdsQ/vO7FKyVYY+74K3X2eYp
         K61+RKRnQEK5z/Pqa9OKFa5EUs18+bdffqPBwYiGc9iD4B7PK6JHZBUQJ2ohXNAUX39x
         qdIQ==
X-Gm-Message-State: AOJu0YyBD90W1PQytwDgzlL0rGeBuTMBlSfI3CWsooTJo6vkN7gLVLXS
	Z135/PACI8GkAWAhpRc3BvvdL5dCy5G7AGg/9BKNJ4OhGOPN3+PBu7sw
X-Gm-Gg: ASbGncvt8MUjdmAWLFztUrju8W55DW2UHkgngxouCrc8SCd9/WdFjfkqMj6aPj9NBc7
	UfjunASv7lwmd+CXVPVwF22lJsHDeA6jPVZ4+8oR8POQ7QSkiyMfYWDWr5suNTU4MzejpXgZcJK
	lJnzl+TQYNC6SHWJ81suyC40MXT4wz5/5vA3K2qHTF4h8lA6O6cq2ICc5i7P1h1vGwb6R9HvpJz
	gDTkNM7eYZV+3345ltSYiBWGRvJw3Zw1CFgrhmWQg39mryyvVZfP/KUxu8l4+xFh11d1VM2E4hp
	91quXXm3ZctyipS0JmS17hkbFS6RYGL1uclRbGp1DWYEM8Q7R8RIJHLOGaBQxZcUnvEwYDsZrao
	yscaLhvAt1uoe79VY8oCiV2DpNZmSiNmTjG+iDzHoXHzTHTJtD0K9+K+84yTPmmuQVn4xvTI8Qj
	XfrrTl+FOkaeb3gi4WzmUgis4o/DEOMob2VHoMBjmdc/fhEvaT
X-Google-Smtp-Source: AGHT+IGSeuGzSvV1SvGyM5DjDZgcVh7TfEToaBesiSuO+6AC9QAVHx9qtNq+2+KwAMgSlcxjqhqJmQ==
X-Received: by 2002:a17:902:d4c4:b0:275:27ab:f6c8 with SMTP id d9443c01a7336-290c9cae467mr58172695ad.20.1760724231103;
        Fri, 17 Oct 2025 11:03:51 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29246ebcfd0sm1580425ad.8.2025.10.17.11.03.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 11:03:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <7d762aa4-b73d-49be-8150-3971435b8712@roeck-us.net>
Date: Fri, 17 Oct 2025 11:03:47 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/563] 6.17.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20251013144411.274874080@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/25 07:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.3 release.
> There are 563 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
> 

Building m68k:allmodconfig ... failed
--------------
Error log:
drivers/vfio/cdx/intr.c: In function 'vfio_cdx_msi_enable':
drivers/vfio/cdx/intr.c:41:15: error: implicit declaration of function 'msi_domain_alloc_irqs'; did you mean 'msi_domain_get_virq'? [-Wimplicit-function-declaration]
    41 |         ret = msi_domain_alloc_irqs(dev, MSI_DEFAULT_DOMAIN, nvec);
       |               ^~~~~~~~~~~~~~~~~~~~~
       |               msi_domain_get_virq
drivers/vfio/cdx/intr.c: In function 'vfio_cdx_msi_disable':
drivers/vfio/cdx/intr.c:135:9: error: implicit declaration of function 'msi_domain_free_irqs_all' [-Wimplicit-function-declaration]
   135 |         msi_domain_free_irqs_all(dev, MSI_DEFAULT_DOMAIN);

Bisect results below.

Guenter


---
# bad: [17e9266e1aff69de51dbd554c8dad36c4cfef0bd] Linux 6.17.3
# good: [449d48b1b99fdaa076166e200132705ac2bee711] Linux 6.17.2
git bisect start 'HEAD' 'v6.17.2'
# bad: [8e0a18d6ee733f4fc77bc05d73f28dba33914ccb] accel/amdxdna: Use int instead of u32 to store error codes
git bisect bad 8e0a18d6ee733f4fc77bc05d73f28dba33914ccb
# good: [6b4eacd05f6b96dabc2d26b753f2bc4e39094f82] Revert "arm64: dts: ti: k3-j721e-beagleboneai64: Fix reversed C6x carveout locations"
git bisect good 6b4eacd05f6b96dabc2d26b753f2bc4e39094f82
# good: [f74032d51f93114e361f17d9919d12d6036f3687] mfd: max77705: Setup the core driver as an interrupt controller
git bisect good f74032d51f93114e361f17d9919d12d6036f3687
# good: [83ced3c206c292458e47c7fac54223abc7141585] scsi: pm80xx: Fix array-index-out-of-of-bounds on rmmod
git bisect good 83ced3c206c292458e47c7fac54223abc7141585
# good: [2ca40698d2d78da82b6450968ab6a8b606a90304] drm/panel: Allow powering on panel follower after panel is enabled
git bisect good 2ca40698d2d78da82b6450968ab6a8b606a90304
# good: [03f3cd82ec4d88905e53ed60ece681266d54c000] PCI: qcom: Restrict port parsing only to PCIe bridge child nodes
git bisect good 03f3cd82ec4d88905e53ed60ece681266d54c000
# bad: [5e6ebfc78c11ff4ffe01aed73555a6c97c866300] ALSA: lx_core: use int type to store negative error codes
git bisect bad 5e6ebfc78c11ff4ffe01aed73555a6c97c866300
# bad: [ab6cfdfd8bd76367828cc952d57120436a076258] PCI/ACPI: Fix pci_acpi_preserve_config() memory leak
git bisect bad ab6cfdfd8bd76367828cc952d57120436a076258
# bad: [db05b70c5d4c34c748e25697bf7489b909d1d71a] cdx: don't select CONFIG_GENERIC_MSI_IRQ
git bisect bad db05b70c5d4c34c748e25697bf7489b909d1d71a
# first bad commit: [db05b70c5d4c34c748e25697bf7489b909d1d71a] cdx: don't select CONFIG_GENERIC_MSI_IRQ

