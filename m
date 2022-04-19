Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E8D1374
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 18:09:21 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id j70so4051400pgd.4
        for <patches@lists.linux.dev>; Tue, 19 Apr 2022 11:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YYmvKovcTU6rmYG1sMPHfPQz8ABPeGl+bM0jHRmpzis=;
        b=yMJod5bYimT8rDmcFp5bN/kHiVVWwbIxs+p3BVP2yx8f4QIJHBoRNrAY8gf0Za1hhG
         oYHMC/USR9o8QC4xHQ6zyd0qGMzGj+HMfagUIG1Y7LZs6xI/yss+yoaDL1KjNNvAGnI+
         SY4NlsopmStCyhUmZM3Q/LC0yOb38lxNHnnso8O8FjmZMQmeArUwza2UdQ7kY1tAKVN1
         tbI9mjitOcesp/hTLVP2rphmqTjU7i4sBagX597BEau1fO8GVoXKfcoueH+EPcCHo3c6
         WBzvzrQjWyE2GdHi4CO0bF1ym1K4DyrbZ9XperGCL7rZVi5gx96mDiBXZoN8uhhJZFZ3
         SdBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YYmvKovcTU6rmYG1sMPHfPQz8ABPeGl+bM0jHRmpzis=;
        b=k1BRdLOleH1DQPFp+Ofnf8gbWBOwYtInAy3IAyZpJPhW6lC/NJ9LP+GvSLhMkqMCiB
         fvqH3Xry/KlqA1a6EIqlrlg6R/41SyVEHGeBAu4TIGK9BpxtppJ504LlkZofSUFowLxk
         QMjsjoce9sxdqt0hSrgF4CXF3XhVKq/afNL39sZ93LD782ujrCppB+j4AmcAbSCOwY8C
         Z3eThb6Bud7FTv1ORQ3c7M0p6Ox+noHWwEtNdlYwegq0a7j7dBePbfdez8yDvgky33pc
         pPr9s63pMZKYouU/tWbvX+F283xBlL8zPHkJ3Pa3DrPisu9ivL/r5KcSx+rFjC+pZHJX
         o6qQ==
X-Gm-Message-State: AOAM532BRzCzIDK2Vud5uISYB/drqfZ1Y6ufYXDEw1juhZsBUAE9LUjJ
	UOq2ORSzRYuFd7sP5RhS+1SzfwOQ50kAQ9kHqU3oEg==
X-Google-Smtp-Source: ABdhPJxKEJeesJs1zZXSkOCI0lwVH4KISjHVHn30n+qo5EI5CYiu1aFO21JoQLAgELUyB/wBgi1z8fhBBV5ROaSj4yk=
X-Received: by 2002:a05:6a00:e14:b0:4fe:3cdb:23f with SMTP id
 bq20-20020a056a000e1400b004fe3cdb023fmr19124950pfb.86.1650391760482; Tue, 19
 Apr 2022 11:09:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220407191347.9681-1-jithu.joseph@intel.com> <20220419163859.2228874-1-tony.luck@intel.com>
 <20220419163859.2228874-4-tony.luck@intel.com> <Yl7npfrVTPFEIivC@kroah.com>
In-Reply-To: <Yl7npfrVTPFEIivC@kroah.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Apr 2022 11:09:09 -0700
Message-ID: <CAPcyv4jzscs3Dg4QN0+XHRYdekBeqy1=dRX-mWCj1OXo8jS2vQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/11] platform/x86/intel/ifs: Create device for Intel
 IFS (In Field Scan)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Hans de Goede <hdegoede@redhat.com>, markgross@kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	"Joseph, Jithu" <jithu.joseph@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, 
	Steven Rostedt <rostedt@goodmis.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
	patches@lists.linux.dev, Ravi V Shankar <ravi.v.shankar@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 19, 2022 at 9:48 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Apr 19, 2022 at 09:38:51AM -0700, Tony Luck wrote:
> > The initial implementation of IFS is model specific. Enumeration is
> > via a combination of family-model-stepping and a check for a bit in the
> > CORE_CAPABILITIES MSR.
> >
> > Linux has handled this lack of enumeration before with a code stub to
> > create a device.  See arch/x86/kernel/pmem.c. Use the same approach
> > here.
>
> Ick, why?  Why not just create a simple virtual device and use that?  Do
> you really want to bind a driver to this?  Or do you already "know" the
> only driver that you have will bind to this?

With the realization that there may be multiple instances of an
IFS-like capability going forward, and that ideally those capabilities
would move away from a CPU capability bit to an ACPI description, then
it seemed to me that a simulated platform_device for this is a
reasonable fit. I.e. when / if an ACPI _HID is assigned for this
capability the same platform_driver can be reused for those instances.

> pmem.c should not be used as a good example of anything, sorry.

Yes, the arch/x86/kernel/pmem.c hack was supplanted by an ACPI device
description. There is no ACPI device description for the IFS
capability, yet.

So I saw these two cases as similar, that capabilities like this need
enumeration besides a CPU-id bit or an E820 table entry, and when they
move to an enumerable bus like ACPI a platform_driver is expected.

>
> greg k-h
>
>
> >
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  MAINTAINERS                                   |  7 +++
> >  drivers/platform/x86/intel/Kconfig            |  1 +
> >  drivers/platform/x86/intel/Makefile           |  1 +
> >  drivers/platform/x86/intel/ifs/Kconfig        |  2 +
> >  drivers/platform/x86/intel/ifs/Makefile       |  1 +
> >  .../platform/x86/intel/ifs/intel_ifs_device.c | 50 +++++++++++++++++++
> >  6 files changed, 62 insertions(+)
> >  create mode 100644 drivers/platform/x86/intel/ifs/Kconfig
> >  create mode 100644 drivers/platform/x86/intel/ifs/Makefile
> >  create mode 100644 drivers/platform/x86/intel/ifs/intel_ifs_device.c
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 40fa1955ca3f..9e372a960fa5 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -9861,6 +9861,13 @@ B:     https://bugzilla.kernel.org
> >  T:   git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git
> >  F:   drivers/idle/intel_idle.c
> >
> > +INTEL IN FIELD SCAN (IFS) DRIVER
> > +M:   Jithu Joseph <jithu.joseph@intel.com>
> > +R:   Ashok Raj <ashok.raj@intel.com>
> > +R:   Tony Luck <tony.luck@intel.com>
> > +S:   Maintained
> > +F:   drivers/platform/x86/intel/ifs
> > +
> >  INTEL INTEGRATED SENSOR HUB DRIVER
> >  M:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> >  M:   Jiri Kosina <jikos@kernel.org>
> > diff --git a/drivers/platform/x86/intel/Kconfig b/drivers/platform/x86/intel/Kconfig
> > index 1f01a8a23c57..794968bda115 100644
> > --- a/drivers/platform/x86/intel/Kconfig
> > +++ b/drivers/platform/x86/intel/Kconfig
> > @@ -4,6 +4,7 @@
> >  #
> >
> >  source "drivers/platform/x86/intel/atomisp2/Kconfig"
> > +source "drivers/platform/x86/intel/ifs/Kconfig"
> >  source "drivers/platform/x86/intel/int1092/Kconfig"
> >  source "drivers/platform/x86/intel/int3472/Kconfig"
> >  source "drivers/platform/x86/intel/pmc/Kconfig"
> > diff --git a/drivers/platform/x86/intel/Makefile b/drivers/platform/x86/intel/Makefile
> > index c61bc3e97121..10285d0fd16a 100644
> > --- a/drivers/platform/x86/intel/Makefile
> > +++ b/drivers/platform/x86/intel/Makefile
> > @@ -5,6 +5,7 @@
> >  #
> >
> >  obj-$(CONFIG_INTEL_ATOMISP2_PDX86)   += atomisp2/
> > +obj-y                                        += ifs/
> >  obj-$(CONFIG_INTEL_SAR_INT1092)              += int1092/
> >  obj-$(CONFIG_INTEL_SKL_INT3472)              += int3472/
> >  obj-$(CONFIG_INTEL_PMC_CORE)         += pmc/
> > diff --git a/drivers/platform/x86/intel/ifs/Kconfig b/drivers/platform/x86/intel/ifs/Kconfig
> > new file mode 100644
> > index 000000000000..51325b699563
> > --- /dev/null
> > +++ b/drivers/platform/x86/intel/ifs/Kconfig
> > @@ -0,0 +1,2 @@
> > +config INTEL_IFS_DEVICE
> > +     bool
> > diff --git a/drivers/platform/x86/intel/ifs/Makefile b/drivers/platform/x86/intel/ifs/Makefile
> > new file mode 100644
> > index 000000000000..12c2f5ce9925
> > --- /dev/null
> > +++ b/drivers/platform/x86/intel/ifs/Makefile
> > @@ -0,0 +1 @@
> > +obj-$(CONFIG_INTEL_IFS_DEVICE)       += intel_ifs_device.o
> > diff --git a/drivers/platform/x86/intel/ifs/intel_ifs_device.c b/drivers/platform/x86/intel/ifs/intel_ifs_device.c
> > new file mode 100644
> > index 000000000000..64a143871d72
> > --- /dev/null
> > +++ b/drivers/platform/x86/intel/ifs/intel_ifs_device.c
> > @@ -0,0 +1,50 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright(c) 2022 Intel Corporation. */
> > +
> > +#include <linux/platform_device.h>
> > +#include <linux/init.h>
> > +#include <asm/cpu_device_id.h>
> > +
> > +#define MSR_IA32_CORE_CAPS_INTEGRITY_BIT     2
> > +#define MSR_IA32_CORE_CAPS_INTEGRITY         BIT(MSR_IA32_CORE_CAPS_INTEGRITY_BIT)
> > +
> > +#define X86_MATCH(model)                                     \
> > +     X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6,            \
> > +             INTEL_FAM6_##model, X86_FEATURE_CORE_CAPABILITIES, NULL)
> > +
> > +static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
> > +     X86_MATCH(SAPPHIRERAPIDS_X),
> > +     {}
> > +};
> > +
> > +static __init int register_ifs_device(void)
> > +{
> > +     struct platform_device *pdev;
> > +     const struct x86_cpu_id *m;
> > +     u64 ia32_core_caps;
> > +
> > +     m = x86_match_cpu(ifs_cpu_ids);
> > +     if (!m)
> > +             return -ENODEV;
> > +
> > +     if (rdmsrl_safe(MSR_IA32_CORE_CAPS, &ia32_core_caps))
> > +             return -ENODEV;
> > +
> > +     if (ia32_core_caps & MSR_IA32_CORE_CAPS_INTEGRITY) {
> > +             pdev = platform_device_alloc("intel_ifs", 0);
> > +             if (pdev) {
> > +                     if (platform_device_add(pdev))
> > +                             platform_device_put(pdev);
> > +             }
> > +     }
> > +
> > +     /*
> > +      * Failure here will be visible by a missing device
> > +      * in sysfs. Returning an error code would not make
> > +      * that any easier to diagnose. Would also complicate
> > +      * future implementations that may support a subset of
> > +      * the types of tests.
> > +      */
> > +     return 0;
>
> So even if everything fails, you succeed?  But you are failing above for
> some cases, so why is creating the device somehow special here that you
> should succeed no matter what?

My bad, this failure is not fatal to init and test execution tooling
will notice the missing device, but yes this can just return the
initcall error to be logged.
