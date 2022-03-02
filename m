Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7343E6153
	for <patches@lists.linux.dev>; Wed,  2 Mar 2022 23:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646264363; x=1677800363;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y6ExcioFqlJjDZQpSBxXHW53xAZe9Os27BCVKLck3NM=;
  b=Qr3MqRcwUX8j8RCgIOFZ5MInK7iScNLe+754L1SeebE0StjS4vZodkUa
   23JAfw0LwwVXEKDOspiIEpzUcNqDLyNO8MNNNsEfgFTrpHP6B4fJPbi6Y
   1qfwiJtSOze0ws6MxAKl7iWMqtyaj3vVwEN+JBC8011QA2QzdJOvqohGR
   QDOVLkt3oJwn1pfK+lriwT9PFGoSBz5fIEGubgfFPJLQ4Q/IWVbhjIvzv
   Rn+s6byGD22cLxJLWWJUQ9sA/QUSTGVO6/ZORIrQkJLwhtnmTx506ZLWS
   Y4CWTLYQH3vgi6wynQC6vQvXHcMkeN+QGcJLz39lVLjiZq53YNJ4ZzY/e
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="234147187"
X-IronPort-AV: E=Sophos;i="5.90,150,1643702400"; 
   d="scan'208";a="234147187"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 15:39:16 -0800
X-IronPort-AV: E=Sophos;i="5.90,150,1643702400"; 
   d="scan'208";a="641884850"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.125])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 15:39:16 -0800
Date: Wed, 2 Mar 2022 15:31:00 -0800
From: "Raj, Ashok" <ashok.raj@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "hdegoede@redhat.com" <hdegoede@redhat.com>,
	"markgross@kernel.org" <markgross@kernel.org>,
	"Joseph, Jithu" <jithu.joseph@intel.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"Luck, Tony" <tony.luck@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, Ashok Raj <ashok.raj@intel.com>
Subject: Re: [RFC 03/10] platform/x86/intel/ifs: Add driver for In-Field Scan
Message-ID: <20220302233100.GE9351@otc-nc-03>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <20220301195457.21152-4-jithu.joseph@intel.com>
 <f0e958c612ac4dab30ba458a08a7681e1114668f.camel@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0e958c612ac4dab30ba458a08a7681e1114668f.camel@intel.com>

On Wed, Mar 02, 2022 at 03:24:47PM -0800, Dan Williams wrote:
> On Tue, 2022-03-01 at 11:54 -0800, Jithu Joseph wrote:
> > In-Field Scan (IFS) provides hardware hooks to perform core tests and
> > report failures for portions of silicon that lack error detection
> > capabilities, which will be available in some server SKUs starting with
> > Sapphire Rapids. It offers infrastructure to specific users such as cloud
> > providers or OEMs to schedule tests and find in-field failures due to aging
> > in silicon that might not necessarily be reported with normal machine
> > checks.
> >
> > Add basic parts of the IFS module (initialization and check IFS capability
> > support in a processor).
> >
> > MSR IA32_CORE_CAPABILITY is a feature-enumerating MSR, bit 2 of which
> > reports MSR_INTEGRITY_CAPABILITIES. Processor that supports IFS
> > should reports the MSR_INTEGRITY_CAPABILITIES enabled.
> >
> > Please check the latest Intel 64 and IA-32 Architectures Software
> > Developer's Manual for more detailed information on the MSR and the
> > MSR_INTEGRITY_CAPABILITIES.
> >
> > Originally-by: Kyung Min Park <kyung.min.park@intel.com>
> > Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> > Reviewed-by: Ashok Raj <ashok.raj@intel.com>
> > Reviewed-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  MAINTAINERS                             |  7 ++++
> >  drivers/platform/x86/intel/Kconfig      |  1 +
> >  drivers/platform/x86/intel/Makefile     |  1 +
> >  drivers/platform/x86/intel/ifs/Kconfig  |  9 +++++
> >  drivers/platform/x86/intel/ifs/Makefile |  7 ++++
> >  drivers/platform/x86/intel/ifs/core.c   | 49 +++++++++++++++++++++++++
> >  drivers/platform/x86/intel/ifs/ifs.h    | 14 +++++++
> >  7 files changed, 88 insertions(+)
> >  create mode 100644 drivers/platform/x86/intel/ifs/Kconfig
> >  create mode 100644 drivers/platform/x86/intel/ifs/Makefile
> >  create mode 100644 drivers/platform/x86/intel/ifs/core.c
> >  create mode 100644 drivers/platform/x86/intel/ifs/ifs.h
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 777cd6fa2b3d..4c9912c0d725 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -9685,6 +9685,13 @@ B:       https://bugzilla.kernel.org
> >  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git
> >  F:     drivers/idle/intel_idle.c
> >
> > +INTEL IN FIELD SCAN (IFS) DRIVER
> > +M:     Jithu Joseph <jithu.joseph@intel.com>
> > +R:     Ashok Raj <ashok.raj@intel.com>
> > +R:     Tony Luck <tony.luck@intel.com>
> > +S:     Maintained
> > +F:     drivers/platform/x86/intel/ifs
> > +
> >  INTEL INTEGRATED SENSOR HUB DRIVER
> >  M:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> >  M:     Jiri Kosina <jikos@kernel.org>
> > diff --git a/drivers/platform/x86/intel/Kconfig b/drivers/platform/x86/intel/Kconfig
> > index 8e65086bb6c8..7339e7daf0a1 100644
> > --- a/drivers/platform/x86/intel/Kconfig
> > +++ b/drivers/platform/x86/intel/Kconfig
> > @@ -4,6 +4,7 @@
> >  #
> >
> >  source "drivers/platform/x86/intel/atomisp2/Kconfig"
> > +source "drivers/platform/x86/intel/ifs/Kconfig"
> >  source "drivers/platform/x86/intel/int1092/Kconfig"
> >  source "drivers/platform/x86/intel/int33fe/Kconfig"
> >  source "drivers/platform/x86/intel/int3472/Kconfig"
> > diff --git a/drivers/platform/x86/intel/Makefile b/drivers/platform/x86/intel/Makefile
> > index 35f2066578b2..bd7f2ef5e767 100644
> > --- a/drivers/platform/x86/intel/Makefile
> > +++ b/drivers/platform/x86/intel/Makefile
> > @@ -5,6 +5,7 @@
> >  #
> >
> >  obj-$(CONFIG_INTEL_ATOMISP2_PDX86)     += atomisp2/
> > +obj-$(CONFIG_INTEL_IFS)                        += ifs/
> >  obj-$(CONFIG_INTEL_SAR_INT1092)                += int1092/
> >  obj-$(CONFIG_INTEL_CHT_INT33FE)                += int33fe/
> >  obj-$(CONFIG_INTEL_SKL_INT3472)                += int3472/
> > diff --git a/drivers/platform/x86/intel/ifs/Kconfig b/drivers/platform/x86/intel/ifs/Kconfig
> > new file mode 100644
> > index 000000000000..88e3d4fa1759
> > --- /dev/null
> > +++ b/drivers/platform/x86/intel/ifs/Kconfig
> > @@ -0,0 +1,9 @@
> > +config INTEL_IFS
> > +       tristate "Intel In Field Scan"
> > +       depends on X86 && 64BIT && SMP
> 
> Are there actual CONFIG_SMP and CONFIG_64BIT compilation dependencies
> in this driver? It looks like this could compile without those config
> dependencies.

Don't think this is anything specific to compile dependencies. 

This is a server feature and only targetted and validated in those configs,
untested and unsupported in 32bit configs. 

