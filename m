Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740312112
	for <patches@lists.linux.dev>; Wed,  5 Jul 2023 14:23:35 +0000 (UTC)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-5704fce0f23so82686387b3.3
        for <patches@lists.linux.dev>; Wed, 05 Jul 2023 07:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688567014; x=1691159014;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=PhMX9Gf1eC3s7FkxmXbqbNQ7tc0qTU4hPkMTdctXh34=;
        b=nNU0d983bI6LB5Rei/Fl15hwCcPPQpjpa5z621GQI9bMc8N464MEaZtVtTDr4cfZ8v
         n7iQQvxtML6FZCXb5i5QtoLfqYXB/aDsaF/UKd2ddB5rRqIf0SfcB4s6CD7beCqyN1CB
         VEdCO9mE83Xf5USoHiGRt4rm14UpSH14YyPUrUR2Enw/7MCwANMW5B+wWDmCytiu3nyT
         ygTWDQm+eQn70r79m9opt7wAqptj9XUCvJ2GgsSZIVUbZTEBwnAbm7Dm3uijz4jiU6Ey
         m3Qez2kyDs1FcA9huQpeDjGN70Kpfq6NIOQg8BF8hlKDbTC/g+7NuOL33MGYpYfNQRrZ
         eFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688567014; x=1691159014;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PhMX9Gf1eC3s7FkxmXbqbNQ7tc0qTU4hPkMTdctXh34=;
        b=OPjGEnM3UcsvZM9TYt181cjDjwfJPMSyOzB50U7F8VvDthJDdmCqbNkoPDt9nJriJ2
         Q45MzgVvSQ337gnh17JHVRcxIwXk/Rfq38io7GH2QgF1NL83YGDc1b8S12O9en0MD23H
         fR8rapaLML5SOz3/EeVXONoxuzXsAsF5h2zRcU43gkFZAaFCwuMyajTi7w4RrWwFE5Hs
         V6owJLZ/RL0FqedN4NCJElXJA85wXyPZWHGUTH4e6nfPZs0xjS+oco792AeM6nESdXbu
         99iAp+PXiJZirrsQsMGx0Vq3HlPjcUR1pWhWSMnTaRDqCVvMdJaeFgnUNIz5hyggZEdb
         u0Kg==
X-Gm-Message-State: ABy/qLbnDhQF2UhuqIYBQwllLWAEAE92SMaRINSxKFmcskHeUPyBzTPM
	FY5zQdw/CbfoFEN2SSXieEw=
X-Google-Smtp-Source: APBJJlF2lwnjeMYyp2vVNhcNzRXbSEuEGAgDcQauGDciAIf14tH1VkhpsPQde93Axx083R6HkXgNvw==
X-Received: by 2002:a0d:d656:0:b0:579:ed5c:2d10 with SMTP id y83-20020a0dd656000000b00579ed5c2d10mr10385565ywd.30.1688567014245;
        Wed, 05 Jul 2023 07:23:34 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p190-20020a0dffc7000000b0055a7c2375dfsm6109811ywf.101.2023.07.05.07.23.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 07:23:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <824705ec-38ca-1587-573c-595b146ee2e1@roeck-us.net>
Date: Wed, 5 Jul 2023 07:23:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.1 00/13] 6.1.38-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
References: <20230704084611.071971014@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230704084611.071971014@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/4/23 01:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.38 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jul 2023 08:46:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.38-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Linux 6.1.38-rc2
> 
> Linus Torvalds <torvalds@linux-foundation.org>
>      gup: avoid stack expansion warning for known-good case
> 

I am a bit puzzled by this patch. It avoids a warning introduced with
upstream commit a425ac5365f6 ("gup: add warning if some caller would
seem to want stack expansion"), or at least it says so, but that patch
is not in v6.1.y. Why is this patch needed here ?

Thanks,
Guenter

> Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
>      drm/amd/display: Ensure vmin and vmax adjust for DCE
> 
> Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
>      drm/amdgpu: Validate VM ioctl flags.
> 
> Ahmed S. Darwish <darwi@linutronix.de>
>      docs: Set minimal gtags / GNU GLOBAL version to 6.6.5
> 
> Ahmed S. Darwish <darwi@linutronix.de>
>      scripts/tags.sh: Resolve gtags empty index generation
> 
> Krister Johansen <kjlx@templeofstupid.com>
>      perf symbols: Symbol lookup with kcore can fail if multiple segments match stext
> 
> Finn Thain <fthain@linux-m68k.org>
>      nubus: Partially revert proc_create_single_data() conversion
> 
> Linus Torvalds <torvalds@linux-foundation.org>
>      execve: always mark stack as growing down during early stack setup
> 
> Mario Limonciello <mario.limonciello@amd.com>
>      PCI/ACPI: Call _REG when transitioning D-states
> 
> Bjorn Helgaas <bhelgaas@google.com>
>      PCI/ACPI: Validate acpi_pci_set_power_state() parameter
> 
> Aric Cyr <aric.cyr@amd.com>
>      drm/amd/display: Do not update DRR while BW optimizations pending
> 
> Alvin Lee <Alvin.Lee2@amd.com>
>      drm/amd/display: Remove optimization for VRR updates
> 
> Max Filippov <jcmvbkbc@gmail.com>
>      xtensa: fix lock_mm_and_find_vma in case VMA not found
> 
> 
> -------------
> 
> Diffstat:
> 
>   Documentation/process/changes.rst        |  7 +++++
>   Makefile                                 |  4 +--
>   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c   |  4 +++
>   drivers/gpu/drm/amd/display/dc/core/dc.c | 50 +++++++++++++++++-------------
>   drivers/nubus/proc.c                     | 22 ++++++++++---
>   drivers/pci/pci-acpi.c                   | 53 ++++++++++++++++++++++++--------
>   include/linux/mm.h                       |  4 ++-
>   mm/memory.c                              |  4 +++
>   mm/nommu.c                               |  7 ++++-
>   scripts/tags.sh                          |  9 +++++-
>   tools/perf/util/symbol.c                 | 17 ++++++++--
>   11 files changed, 135 insertions(+), 46 deletions(-)
> 
> 

