Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05F414A8D
	for <patches@lists.linux.dev>; Mon, 29 Apr 2024 08:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714378105; cv=none; b=F5YwEmJ2X3eVLbWq7F3EN5y9rodk+gf3GQq/8Zw12AXstA4oWMKS3aUDe7XfAGB/gkU5NuvlrECNHcbeVjv6+5CBRhRg4h21riHQ35Z+YjWa/M1ViDT0yTmOYV/WD+ctCxzIkgQXg9DjzixZqqYhOzTB7ObKweshLWMCJhFBweM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714378105; c=relaxed/simple;
	bh=n4UbgoqCHIB7jgeCghFtvEcx2iNVwUURRXwMRBucCgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dzXxt5hCe7eOyg18UF8DlhG0ISWYe8IpES6G3pr/NuHEPR8W+PHC1wc7ubxKM0sR8JuXgxizpip8BDHBhVxNfYXPrMs1eQrSG108oYKvQiX2nhesG8uee5QoMaZXvv5R5y43e1O4s0J4uNxXIaa/zbdLcjsYdCSyhS/EPvRgORM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PihA+Ec+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PihA+Ec+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714378102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bvCOmGVAFf5Ef0h/Xn4WlU/W5Kebabz8DqE/Mw/nU0k=;
	b=PihA+Ec+XUV3SqrW1XYVzKR2YEZeDG0/kn9vi8dMCZp5oMqUyR4RjwqV4Dy/FlYjo3W80R
	G6RylDkHHiDZ52YayE6prGh+XUMb6n1OcDJDueW0HFMtMajy5RveF9GRT11ETnOu0p/+Kq
	ZaPNeMmd7PIYtPCwwGxOwutVWitpBS0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-5W_Z8b-0O7qBY_XInEzd2Q-1; Mon, 29 Apr 2024 04:08:17 -0400
X-MC-Unique: 5W_Z8b-0O7qBY_XInEzd2Q-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-572726d6e60so532290a12.2
        for <patches@lists.linux.dev>; Mon, 29 Apr 2024 01:08:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714378096; x=1714982896;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bvCOmGVAFf5Ef0h/Xn4WlU/W5Kebabz8DqE/Mw/nU0k=;
        b=jnqVb2VRI+mvxA8sbAxTNgEKA+wIVuXJyW5PWbdktOEPorqiWBmlEVYHc40XXnt3Qq
         dr69qmLPB/gWKdBzbqfuNK4CLgKkv2iX7Nf+LfByLrZevQVYvG4OI2jN+ZaAvsl4DqYB
         KLo+Z9IzIzOdZuB9gYy84n+/GhM60xN5VRCluGVtyAixqSH2F5rdtpxgEWiux2LD9M9r
         az3h1YRld+6KJ4EMRTMAmu71IJk16LZ7osy45l7GYgTTb8GBbCziTyCdI0WEh6+D+ucH
         V9+3DcGWGDTpzY6Omww3REJBMuaAB4kOFvuYo2GUosWP5YAq48N+DDISP069tF/ZxKPo
         9uWQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0Fv8+Vd3jy3a5qZg42s8SzXdqhQx/ZDN95tcqilfhqFOBzQkiN4rNd1CT50VIvZ2mdx1ysvG0wMXaptFJKrTdB42l3y8NUg==
X-Gm-Message-State: AOJu0YxHNfL5vsBz+l/DYqmGmrLMotvm/ZyYJBA5HWBO7jVuCDIY7y3E
	tLktp8B9LTkG1FvKp1Pqf98NY0ZStNgAoeVNEOua1BbQ6neLvW9L09+zMR5GMhABmpJmMEM1HRJ
	ATUzALd49vvnLdeFiAG1edbLxjkr/+bDYoNl2BAO0a1mazqXejX+Johk=
X-Received: by 2002:a05:6402:1a4d:b0:572:8aab:4420 with SMTP id bf13-20020a0564021a4d00b005728aab4420mr29027edb.39.1714378096424;
        Mon, 29 Apr 2024 01:08:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2PY7XCDmgXlbR7D5LD7OV6jKxY2gLjyhTyWooFsmVHoXR92UJBNXJ3PL4c2RbgWAhcI2qPg==
X-Received: by 2002:a05:6402:1a4d:b0:572:8aab:4420 with SMTP id bf13-20020a0564021a4d00b005728aab4420mr29012edb.39.1714378096049;
        Mon, 29 Apr 2024 01:08:16 -0700 (PDT)
Received: from [10.40.98.157] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id r19-20020aa7cb93000000b00572031756a8sm8925347edt.16.2024.04.29.01.08.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Apr 2024 01:08:15 -0700 (PDT)
Message-ID: <89949a4b-fe83-482f-99c7-e2b69cce535d@redhat.com>
Date: Mon, 29 Apr 2024 10:08:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/71] New Intel CPUID families
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20240424181245.41141-1-tony.luck@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20240424181245.41141-1-tony.luck@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 4/24/24 8:12 PM, Tony Luck wrote:
> Full v3 description and patches here:
> Link: https://lore.kernel.org/all/20240416211941.9369-1-tony.luck@intel.com/
> 
> But the tl;dr version is that some surgery is required to make adding
> CPUs with new CPUID "family" values elegant.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> Changes since v3:
> 
> *) Parts 1-3 have been applied to tip x86/cpu (Thanks Boris!) so dropped from this series.
>    Patches haved trickled through system and are now in linux-next (tag next-20240424)
>    or higher). So from this new series any of parts 1-69 could be tested against
>    tip x86/cpu or linux-next. There are hardly any interdependencies. Mostly safe
>    to just pick out the patches you care about.

That is good to know, thank you.

So what is the plan for upstreaming the rest of this series ?

I'm fine with the drivers/platform/x86 patches (patch 56-66) going upstream
through tip x86/cpu too:

Acked-by: Hans de Goede <hdegoede@redhat.com>

for those patches. That or we can wait till 6.10-rc1 is out with parts 1-3 merged
and then patches 56-66 can be merged directly into the pdx86 tree.

The same goes for the atomisp patch (patch 67) (including my Acked-by).

Regards,

Hans




> 
> *) Base commit for v4 of the series is now tip x86/cpu
> 	f055b6260eb3 ("x86/cpu/vfm: Update arch/x86/include/asm/intel-family.h")
> 
> *) Fixed "Subject:" lines in each patch to use appropriate prefix for subsystem 
>    followed by "Switch to new Intel CPU model defines"
> 
> *) Re-ordered remmaining patches to bring those with Acked-by or Reviewed-by
>    tags to the head of the queue in case Boris wants to pick off some/all of
>    patches 0001..0015 into tip x86/cpu (hint hint!).
> 
> *) Moved arch/x86/events/rapl.c patch to back of queue (patch 0069). It would
>    have a conflict with the tip perf/core branch. This can be resolved with a
>    future version against v6.10-rc1
> 
> *) Updated "peci" patches to have a copy of the VFM_*() macros instead of
>    trying to include <asm/cpu_device_id.h> which doesn't work when building
>    for a non-x86 target.
> 
> *) I had added #include <asm/cpu_device_id.h> to around a dozen files just before
>    the #include <asm/intel-family.h>. But the former includes the latter. So
>    simplify by just including <asm/cpu_device_id.h>
> 
> Tony Luck (71):
>   tpm: Switch to new Intel CPU model defines
>   platform/x86/intel/ifs: Switch to new Intel CPU model defines
>   KVM: x86/pmu: Switch to new Intel CPU model defines
>   KVM: VMX: Switch to new Intel CPU model defines
>   ACPI: LPSS: Switch to new Intel CPU model defines
>   ACPI: x86: Switch to new Intel CPU model defines
>   cpufreq: intel_pstate: Switch to new Intel CPU model defines
>   cpufreq: Switch to new Intel CPU model defines
>   intel_idle: Switch to new Intel CPU model defines
>   PCI: PM: Switch to new Intel CPU model defines
>   powercap: intel_rapl: Switch to new Intel CPU model defines
>   powercap: intel_rapl: Switch to new Intel CPU model defines
>   ASoC: Intel: Switch to new Intel CPU model defines
>   thermal: intel: intel_tcc_cooling: Switch to new Intel CPU model
>     defines
>   tools/power/turbostat: Switch to new Intel CPU model defines
>   crypto: x86/poly1305 - Switch to new Intel CPU model defines
>   crypto: x86/twofish - Switch to new Intel CPU model defines
>   perf/x86/intel/cstate: Switch to new Intel CPU model defines
>   perf/x86/lbr: Switch to new Intel CPU model defines
>   perf/x86/intel/pt: Switch to new Intel CPU model defines
>   perf/x86/intel/uncore: Switch to new Intel CPU model defines
>   perf/x86/intel/uncore: Switch to new Intel CPU model defines
>   perf/x86/intel/uncore: Switch to new Intel CPU model defines
>   perf/x86/msr: Switch to new Intel CPU model defines
>   x86/apic: Switch to new Intel CPU model defines
>   x86/aperfmperf: Switch to new Intel CPU model defines
>   x86/bugs: Switch to new Intel CPU model defines
>   x86/bugs: Switch to new Intel CPU model defines
>   x86/cpu/intel: Switch to new Intel CPU model defines
>   x86/cpu/intel_epb: Switch to new Intel CPU model defines
>   x86/cpu: Switch to new Intel CPU model defines
>   x86/mce: Switch to new Intel CPU model defines
>   x86/mce: Switch to new Intel CPU model defines
>   x86/mce: Switch to new Intel CPU model defines
>   x86/microcode/intel: Switch to new Intel CPU model defines
>   x86/resctrl: Switch to new Intel CPU model defines
>   x86/resctrl: Switch to new Intel CPU model defines
>   x86/cpu/: Switch to new Intel CPU model defines
>   x86/tsc: Switch to new Intel CPU model defines
>   x86/tsc_msr: Switch to new Intel CPU model defines
>   x86/mm: Switch to new Intel CPU model defines
>   x86/PCI: Switch to new Intel CPU model defines
>   x86/virt/tdx: Switch to new Intel CPU model defines
>   perf/x86/intel: Switch to new Intel CPU model defines
>   x86/platform/intel-mid: Switch to new Intel CPU model defines
>   x86/platform/atom: Switch to new Intel CPU model defines
>   x86/cpu: Switch to new Intel CPU model defines
>   x86/boot: Switch to new Intel CPU model defines
>   EDAC/i10nm: Switch to new Intel CPU model defines
>   EDAC, pnd2: Switch to new Intel CPU model defines
>   EDAC/sb_edac: Switch to new Intel CPU model defines
>   EDAC/skx: Switch to new Intel CPU model defines
>   extcon: axp288: Switch to new Intel CPU model defines
>   peci: cpu: Switch to new Intel CPU model defines
>   hwmon: (peci/cputemp) Switch to new Intel CPU model defines
>   platform/x86: intel_ips: Switch to new Intel CPU model defines
>   platform/x86/intel/pmc: Switch to new Intel CPU model defines
>   platform/x86/intel: pmc: Switch to new Intel CPU model defines
>   platform/x86: intel_scu_wdt: Switch to new Intel CPU model defines
>   platform/x86: ISST: Switch to new Intel CPU model defines
>   platform/x86: intel_speed_select_if: Switch to new Intel CPU model
>     defines
>   platform/x86: intel_telemetry: Switch to new Intel CPU model defines
>   platform/x86: intel: telemetry: Switch to new Intel CPU model defines
>   platform/x86: intel_turbo_max_3: Switch to new Intel CPU model defines
>   platform/x86: intel-uncore-freq: Switch to new Intel CPU model defines
>   platform/x86: p2sb: Switch to new Intel CPU model defines
>   media: atomisp: Switch to new Intel CPU model defines
>   ASoC: Intel: avs: es8336: Switch to new Intel CPU model defines
>   perf/x86/rapl: Switch to new Intel CPU model defines
>   x86/cpu/vfm: Delete X86_MATCH_INTEL_FAM6_MODEL[_STEPPING]() macros
>   x86/cpu/vfm: Delete all the *_FAM6_ CPU #defines
> 
>  .../atomisp/include/linux/atomisp_platform.h  |  27 +--
>  include/linux/peci-cpu.h                      |  24 ++
>  include/linux/platform_data/x86/soc.h         |  12 +-
>  arch/x86/include/asm/cpu_device_id.h          |  28 +--
>  arch/x86/include/asm/intel-family.h           |  85 +------
>  drivers/char/tpm/tpm.h                        |   2 +-
>  drivers/char/tpm/tpm_tis_core.h               |   2 +-
>  arch/x86/boot/cpucheck.c                      |   2 +-
>  arch/x86/crypto/poly1305_glue.c               |   4 +-
>  arch/x86/crypto/twofish_glue_3way.c           |  10 +-
>  arch/x86/events/intel/core.c                  | 212 +++++++++---------
>  arch/x86/events/intel/cstate.c                | 144 ++++++------
>  arch/x86/events/intel/lbr.c                   |   3 +-
>  arch/x86/events/intel/pt.c                    |  12 +-
>  arch/x86/events/intel/uncore.c                | 100 ++++-----
>  arch/x86/events/intel/uncore_nhmex.c          |   3 +-
>  arch/x86/events/intel/uncore_snbep.c          |   5 +-
>  arch/x86/events/msr.c                         | 132 +++++------
>  arch/x86/events/rapl.c                        |  84 +++----
>  arch/x86/kernel/apic/apic.c                   |  38 ++--
>  arch/x86/kernel/cpu/aperfmperf.c              |  17 +-
>  arch/x86/kernel/cpu/bugs.c                    |  30 +--
>  arch/x86/kernel/cpu/common.c                  | 154 +++++++------
>  arch/x86/kernel/cpu/intel.c                   | 115 +++++-----
>  arch/x86/kernel/cpu/intel_epb.c               |  12 +-
>  arch/x86/kernel/cpu/match.c                   |   2 +-
>  arch/x86/kernel/cpu/mce/core.c                |   6 +-
>  arch/x86/kernel/cpu/mce/intel.c               |  21 +-
>  arch/x86/kernel/cpu/mce/severity.c            |  10 +-
>  arch/x86/kernel/cpu/microcode/intel.c         |   5 +-
>  arch/x86/kernel/cpu/resctrl/core.c            |  10 +-
>  arch/x86/kernel/cpu/resctrl/pseudo_lock.c     |  22 +-
>  arch/x86/kernel/smpboot.c                     |   6 +-
>  arch/x86/kernel/tsc.c                         |   6 +-
>  arch/x86/kernel/tsc_msr.c                     |  14 +-
>  arch/x86/kvm/pmu.c                            |   8 +-
>  arch/x86/kvm/vmx/vmx.c                        |  20 +-
>  arch/x86/mm/init.c                            |  16 +-
>  arch/x86/pci/intel_mid_pci.c                  |   4 +-
>  arch/x86/platform/atom/punit_atom_debug.c     |  11 +-
>  arch/x86/platform/intel-mid/intel-mid.c       |   7 +-
>  arch/x86/virt/vmx/tdx/tdx.c                   |   8 +-
>  drivers/acpi/acpi_lpss.c                      |   4 +-
>  drivers/acpi/x86/utils.c                      |  42 ++--
>  drivers/cpufreq/intel_pstate.c                |  90 ++++----
>  drivers/cpufreq/speedstep-centrino.c          |   8 +-
>  drivers/edac/i10nm_base.c                     |  20 +-
>  drivers/edac/pnd2_edac.c                      |   4 +-
>  drivers/edac/sb_edac.c                        |  14 +-
>  drivers/edac/skx_base.c                       |   2 +-
>  drivers/extcon/extcon-axp288.c                |   2 +-
>  drivers/hwmon/peci/cputemp.c                  |   6 +-
>  drivers/idle/intel_idle.c                     | 116 +++++-----
>  drivers/pci/pci-mid.c                         |   4 +-
>  drivers/peci/cpu.c                            |  28 +--
>  drivers/platform/x86/intel/ifs/core.c         |  15 +-
>  drivers/platform/x86/intel/pmc/core.c         |  46 ++--
>  drivers/platform/x86/intel/pmc/pltdrv.c       |  16 +-
>  .../intel/speed_select_if/isst_if_common.c    |   4 +-
>  .../intel/speed_select_if/isst_if_mbox_msr.c  |   2 +-
>  .../platform/x86/intel/telemetry/debugfs.c    |   4 +-
>  drivers/platform/x86/intel/telemetry/pltdrv.c |   4 +-
>  drivers/platform/x86/intel/turbo_max_3.c      |   4 +-
>  .../intel/uncore-frequency/uncore-frequency.c |  56 ++---
>  drivers/platform/x86/intel_ips.c              |   3 +-
>  drivers/platform/x86/intel_scu_wdt.c          |   2 +-
>  drivers/platform/x86/p2sb.c                   |   2 +-
>  drivers/powercap/intel_rapl_common.c          | 118 +++++-----
>  drivers/powercap/intel_rapl_msr.c             |  16 +-
>  drivers/thermal/intel/intel_soc_dts_thermal.c |   2 +-
>  drivers/thermal/intel/intel_tcc_cooling.c     |  30 +--
>  sound/soc/intel/avs/boards/es8336.c           |   8 +-
>  tools/power/x86/turbostat/turbostat.c         | 161 +++++++------
>  73 files changed, 1103 insertions(+), 1163 deletions(-)
> 
> 
> base-commit: f055b6260eb3ef20a6e310d1e555a5d5a0a28ca0

