Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742FC2F43
	for <patches@lists.linux.dev>; Wed, 11 May 2022 15:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1652284322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8WFUC5VmX5Q36NEiF2EwlZNMFIvqDIQQRUATmgl6MsM=;
	b=J8UnCgOcXvQB7RvTX+nIbtAQfwz34JRFKRrnboqRIT+YrQgVpZAN73Y3gzVeREOpxUvwEL
	ZFcgqKuDk9XFN+9wQtl26QHhJCRqixojZegOjMCsnRIUgcIstBszhM3zxtHl62y6/Hyo4R
	QqbMb8RuP9S4QuGo4cTDikyA4INypT8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-8LBX2ziNMcOFU73zruDNfw-1; Wed, 11 May 2022 11:52:00 -0400
X-MC-Unique: 8LBX2ziNMcOFU73zruDNfw-1
Received: by mail-ej1-f72.google.com with SMTP id j1-20020a170906278100b006fa14cafba4so1401717ejc.1
        for <patches@lists.linux.dev>; Wed, 11 May 2022 08:51:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8WFUC5VmX5Q36NEiF2EwlZNMFIvqDIQQRUATmgl6MsM=;
        b=gPRa6WhyYFOkZ24G/0SJwdGj5quY+nNgSUlwNXVgsL9cQrllnIsgbMfOFy4cH4tImf
         tZ0B/4gE/x4guqecF6A0fZij1MHufMphB2mHIRalLS4nZyoqwdmn6DYWQYl2lYuIqXk8
         83bAjtKKIUq2I/irPOtGzgkQ5uq7t9ro6hd6wfpX/FCGbGB6jnMAAgm/jkuGfbLWwZE6
         3p2FjTFGtog/4icE5BHJJgZDYFk3bbhdMe/p76N3qQdRBcHPsxmzc7DrnhaFg7htESFr
         NLgAmEa6s9C/FSxVUJbbqRVnedkIW0SKonYl8fFDDxhwaGW0SVihvb+Z2O5pO2d3onOM
         oayw==
X-Gm-Message-State: AOAM531U8JLB9y2nvGb62KQ3yjyYB28knr8AD/6U5odUtGHhUnI5Vwr2
	bHx8JuD0wcaEqZv+z0ON3UYA6xtiLjq+lOLPNuHR7IYJJOpF46dDeJZiAhU5JwhJGHDE7lmoc3R
	bIUR8JWkrFY+RrQ3KBw==
X-Received: by 2002:a05:6402:1694:b0:425:ae5e:4843 with SMTP id a20-20020a056402169400b00425ae5e4843mr30291332edv.415.1652284318722;
        Wed, 11 May 2022 08:51:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxQrb8/5CfeZNcFbu2jomxbSGi+YkEw58M2wZqlSn4hvDjHHLrsiFQ/EfomUAfyryINR1FJg==
X-Received: by 2002:a05:6402:1694:b0:425:ae5e:4843 with SMTP id a20-20020a056402169400b00425ae5e4843mr30291297edv.415.1652284318525;
        Wed, 11 May 2022 08:51:58 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id g19-20020a170906c19300b006f3ef214e51sm1085645ejz.183.2022.05.11.08.51.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 08:51:58 -0700 (PDT)
Message-ID: <704401aa-b277-ad77-e4ee-6111d5f993c2@redhat.com>
Date: Wed, 11 May 2022 17:51:57 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v7 00/12] Introduce In Field Scan driver
To: Tony Luck <tony.luck@intel.com>, markgross@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, corbet@lwn.net,
 gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com,
 jithu.joseph@intel.com, ashok.raj@intel.com, rostedt@goodmis.org,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com
References: <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506225410.1652287-1-tony.luck@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20220506225410.1652287-1-tony.luck@intel.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=hdegoede@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 5/7/22 00:53, Tony Luck wrote:
> TL;DR this driver loads scan test files that can check whether silicon
> in a CPU core is still running correctly. It is expected that these tests
> would be run several times per day to catch problems as silicon ages.

Thank you for your patch-series, I've applied the series to my
review-hans branch:
https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/log/?h=review-hans

Note it will show up in my review-hans branch once I've pushed my
local branch there, which might take a while.

Once I've run some tests on this branch the patches there will be
added to the platform-drivers-x86/for-next branch and eventually
will be included in the pdx86 pull-request to Linus for the next
merge-window.

Regards,

Hans




> 
> Changes since v6
> 
> Thomas Gleixner
> ---------------
> "struct workqueue_struct *ifs_wq; Seems to be unused."
> 
> True. Deleted.
> 
> "static bool oscan_enabled = true; What changes this?"
> 
> Code that cleared it deleted. Drop this too.
> 
> "Please add curly brackets as these are not one-line statements"
> 
> Added
> 
> cpumask_first(topology_sibling_cpumask(cpu)); Shouldn't that be cpu_smt_mask()?"
> 
> Changed (and several other places)
> 
> "take up to 200 milliseconds before it retires.  200ms per test chunk?"
> 
> Updated comment to note that 200ms is for all chunks.
> 
> "Documentation lost in the intertubes"
> 
> Dredged up the version from v3 series and changed:
> 1) Fixed pathnames now this is a virtual misc device instead of platform
> device
> 2) Put all the text into a "/** DOC:" comment section in ifs.h with just
> a "kernel-doc:: drivers/platform/x86/intel/ifs/ifs.h" in the ifs.rst
> file under Documentation/x86.
> 3) Added a "big fat warning" (in all CAPS) pointing out that a core test
> can take up to 200 milliseconds. So admins must take extra steps if they
> are running latency sensitive workloads.
> 4) Added note that all HT threads of a core must be online to run a
> test.
> 
> Tony Luck
> ---------
> Off-by-one on retries check (#define set to 5, but tried 6 times). Fixed
> Fixed kerneldoc description of "integrity_cap_bit" (was missing a ":")
> 
> Jithu Joseph (7):
>   x86/microcode/intel: Expose collect_cpu_info_early() for IFS
>   platform/x86/intel/ifs: Read IFS firmware image
>   platform/x86/intel/ifs: Check IFS Image sanity
>   platform/x86/intel/ifs: Authenticate and copy to secured memory
>   platform/x86/intel/ifs: Add scan test support
>   platform/x86/intel/ifs: Add IFS sysfs interface
>   platform/x86/intel/ifs: add ABI documentation for IFS
> 
> Peter Zijlstra (1):
>   stop_machine: Add stop_core_cpuslocked() for per-core operations
> 
> Tony Luck (4):
>   x86/msr-index: Define INTEGRITY_CAPABILITIES MSR
>   platform/x86/intel/ifs: Add stub driver for In-Field Scan
>   trace: platform/x86/intel/ifs: Add trace point to track Intel IFS
>     operations
>   Documentation: In-Field Scan
> 
>  .../ABI/testing/sysfs-platform-intel-ifs      |  39 +++
>  Documentation/x86/ifs.rst                     |   2 +
>  Documentation/x86/index.rst                   |   1 +
>  MAINTAINERS                                   |   8 +
>  arch/x86/include/asm/cpu.h                    |  18 ++
>  arch/x86/include/asm/msr-index.h              |   7 +
>  arch/x86/kernel/cpu/intel.c                   |  32 +++
>  arch/x86/kernel/cpu/microcode/intel.c         |  59 +---
>  drivers/platform/x86/intel/Kconfig            |   1 +
>  drivers/platform/x86/intel/Makefile           |   1 +
>  drivers/platform/x86/intel/ifs/Kconfig        |  13 +
>  drivers/platform/x86/intel/ifs/Makefile       |   3 +
>  drivers/platform/x86/intel/ifs/core.c         |  73 +++++
>  drivers/platform/x86/intel/ifs/ifs.h          | 234 +++++++++++++++
>  drivers/platform/x86/intel/ifs/load.c         | 266 ++++++++++++++++++
>  drivers/platform/x86/intel/ifs/runtest.c      | 252 +++++++++++++++++
>  drivers/platform/x86/intel/ifs/sysfs.c        | 149 ++++++++++
>  include/linux/stop_machine.h                  |  16 ++
>  include/trace/events/intel_ifs.h              |  41 +++
>  kernel/stop_machine.c                         |  19 ++
>  20 files changed, 1182 insertions(+), 52 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-ifs
>  create mode 100644 Documentation/x86/ifs.rst
>  create mode 100644 drivers/platform/x86/intel/ifs/Kconfig
>  create mode 100644 drivers/platform/x86/intel/ifs/Makefile
>  create mode 100644 drivers/platform/x86/intel/ifs/core.c
>  create mode 100644 drivers/platform/x86/intel/ifs/ifs.h
>  create mode 100644 drivers/platform/x86/intel/ifs/load.c
>  create mode 100644 drivers/platform/x86/intel/ifs/runtest.c
>  create mode 100644 drivers/platform/x86/intel/ifs/sysfs.c
>  create mode 100644 include/trace/events/intel_ifs.h
> 
> 
> base-commit: 672c0c5173427e6b3e2a9bbb7be51ceeec78093a

