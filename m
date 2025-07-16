Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05FA20F09C
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 15:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752678244; cv=none; b=MobMC3ZZqBkEW5eWLRIFO1LdhAGk7LwPxTQmyd9rfQkvYL6GoPt8tKtSy/dlu+wimLWIc27/9oo8ZFiN/9/kUbxc8jzaW563XdWFvlkV5NGRBRIlE2cgxVOXEVkPKm4SJaTgin62siGyvTkBpF1tNF5jUlfHXEJNXuvU7HMZkN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752678244; c=relaxed/simple;
	bh=s9/XlPXLbG0c9eCELEw3bGC2XL99Ks63z3n9IxWDUCE=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BVYFbgRZe0MYpqrJzJjkNF0RJJwqnJJa4tweF67EdqXo72Z645rv67GAmemHK1Ax+h1K7dx9MqTN8pKGi1wEDz8uFlclOn+tkZTLcHl0vUGbYJam0uh0E43NihSRV1LwzJqywUQ1BMGpnr0y9baQRB9A6OoBiO7ULmS2BIWzQcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=UOmSn5TH; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="UOmSn5TH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1752678242; x=1784214242;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=84aWejT8YQCzdyoWBEmbysArm20YqRb+jZgR4EzU6MY=;
  b=UOmSn5THSNBP8z61nrWRKhuCe/QhT5Ad2UnNJ64VMDnUE8WgOhAKztRo
   YHWc0gOBw/4YzNpADq6kyTxmpMXemrJl8TF5Pvq3mxa9HgLoTokVUBRF/
   l2i0B+ZDDJoM/yohMupzOEKX4Bwy7AQJNGtd/BNXma4+Wz5QR974eRq2J
   b2q8i+ZjQQ78XxsgeLjfJ47Msx7XGFYmsPbaee5RBnkCrLv3DRrWteTf+
   9zJzAaoV3Ojfy+GDv1U3qPpnEqolNIaeixXyvypUWLJ/b7ck28aBqEIeo
   lanBARaX0uR1CPAILVQMbVzs6J5r2SXhD33b5uGglylsPQ5Kn4b1Madek
   A==;
X-IronPort-AV: E=Sophos;i="6.16,316,1744070400"; 
   d="scan'208";a="215062476"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 15:04:01 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.43.254:44087]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.20.104:2525] with esmtp (Farcaster)
 id 3880ee74-890d-4584-9e41-090da4e75020; Wed, 16 Jul 2025 15:04:00 +0000 (UTC)
X-Farcaster-Flow-ID: 3880ee74-890d-4584-9e41-090da4e75020
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 16 Jul 2025 15:03:57 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com.amazon.de
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Wed, 16 Jul 2025
 15:03:54 +0000
From: Mahmoud Nagy Adam <mngyadam@amazon.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Maximilian Luz
	<luzmaximilian@gmail.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, "Hans
 de Goede" <hdegoede@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 279/355] platform: Add Surface platform directory
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
	<20250623130635.169604976@linuxfoundation.org>
Date: Wed, 16 Jul 2025 17:03:51 +0200
Message-ID: <lrkyqqzygch48.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: EX19D041UWB001.ant.amazon.com (10.13.139.132) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> 5.10-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Maximilian Luz <luzmaximilian@gmail.com>
>
> [ Upstream commit 1e3a2bc89de44ec34153ab1c1056346b51def250 ]
>
> It may make sense to split the Microsoft Surface hardware platform
> drivers out to a separate subdirectory, since some of it may be shared
> between ARM and x86 in the future (regarding devices like the Surface
> Pro X).
>
> Further, newer Surface devices will require additional platform drivers
> for fundamental support (mostly regarding their embedded controller),
> which may also warrant this split from a size perspective.
>
> This commit introduces a new platform/surface subdirectory for the
> Surface device family, with subsequent commits moving existing Surface
> drivers over from platform/x86.
>
> A new MAINTAINERS entry is added for this directory. Patches to files in
> this directory will be taken up by the platform-drivers-x86 team (i.e.
> Hans de Goede and Mark Gross) after they have been reviewed by
> Maximilian Luz.
>
> Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Link: https://lore.kernel.org/r/20201009141128.683254-2-luzmaximilian@gmail.com
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> Stable-dep-of: 61ce04601e0d ("platform/x86: dell_rbu: Fix list usage")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  MAINTAINERS                       |  9 +++++++++
>  drivers/platform/Kconfig          |  2 ++
>  drivers/platform/Makefile         |  1 +
>  drivers/platform/surface/Kconfig  | 14 ++++++++++++++
>  drivers/platform/surface/Makefile |  5 +++++
>  5 files changed, 31 insertions(+)
>  create mode 100644 drivers/platform/surface/Kconfig
>  create mode 100644 drivers/platform/surface/Makefile
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cdb5f1f22f4c4..beaa5f6294bd2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11633,6 +11633,15 @@ F:	drivers/scsi/smartpqi/smartpqi*.[ch]
>  F:	include/linux/cciss*.h
>  F:	include/uapi/linux/cciss*.h
>  
> +MICROSOFT SURFACE HARDWARE PLATFORM SUPPORT
> +M:	Hans de Goede <hdegoede@redhat.com>
> +M:	Mark Gross <mgross@linux.intel.com>
> +M:	Maximilian Luz <luzmaximilian@gmail.com>
> +L:	platform-driver-x86@vger.kernel.org
> +S:	Maintained
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git
> +F:	drivers/platform/surface/
> +
>  MICROSOFT SURFACE PRO 3 BUTTON DRIVER
>  M:	Chen Yu <yu.c.chen@intel.com>
>  L:	platform-driver-x86@vger.kernel.org
> diff --git a/drivers/platform/Kconfig b/drivers/platform/Kconfig
> index 971426bb4302c..18fc6a08569eb 100644
> --- a/drivers/platform/Kconfig
> +++ b/drivers/platform/Kconfig
> @@ -13,3 +13,5 @@ source "drivers/platform/chrome/Kconfig"
>  source "drivers/platform/mellanox/Kconfig"
>  
>  source "drivers/platform/olpc/Kconfig"
> +
> +source "drivers/platform/surface/Kconfig"
> diff --git a/drivers/platform/Makefile b/drivers/platform/Makefile
> index 6fda58c021ca4..4de08ef4ec9d0 100644
> --- a/drivers/platform/Makefile
> +++ b/drivers/platform/Makefile
> @@ -9,3 +9,4 @@ obj-$(CONFIG_MIPS)		+= mips/
>  obj-$(CONFIG_OLPC_EC)		+= olpc/
>  obj-$(CONFIG_GOLDFISH)		+= goldfish/
>  obj-$(CONFIG_CHROME_PLATFORMS)	+= chrome/
> +obj-$(CONFIG_SURFACE_PLATFORMS)	+= surface/
> diff --git a/drivers/platform/surface/Kconfig b/drivers/platform/surface/Kconfig
> new file mode 100644
> index 0000000000000..b67926ece95fb
> --- /dev/null
> +++ b/drivers/platform/surface/Kconfig
> @@ -0,0 +1,14 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +#
> +# Microsoft Surface Platform-Specific Drivers
> +#
> +
> +menuconfig SURFACE_PLATFORMS
> +	bool "Microsoft Surface Platform-Specific Device Drivers"
> +	default y
> +	help
> +	  Say Y here to get to see options for platform-specific device drivers
> +	  for Microsoft Surface devices. This option alone does not add any
> +	  kernel code.
> +
> +	  If you say N, all options in this submenu will be skipped and disabled.
> diff --git a/drivers/platform/surface/Makefile b/drivers/platform/surface/Makefile
> new file mode 100644
> index 0000000000000..3700f9e84299e
> --- /dev/null
> +++ b/drivers/platform/surface/Makefile
> @@ -0,0 +1,5 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Makefile for linux/drivers/platform/surface
> +# Microsoft Surface Platform-Specific Drivers
> +#

Hi Greg,

This patch adds a new configuration with new empty directory "surface",
this was for the follow up patches in this series[0], there is no
code/compilation effect by this patch alone, this afaict shouldn't be a
dependency for 61ce04601e0d ("platform/x86: dell_rbu: Fix list
usage"). Was this mistakenly backported as a false dependency?

[0]: https://lore.kernel.org/all/20201009141128.683254-2-luzmaximilian@gmail.com/

-MNAdam



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

