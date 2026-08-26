Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB363B8111
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 08:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787732120; cv=none; b=sV+QNCLvSPVrSsTf6W6hkjQUUPMYRSWp0mqSVUR9DmLx82L3PMGHbJVuLiF5slt9rknD9CXOdVTWMZ1ibSI7UTEjxt3VCq23ZvW7Qs0Z5mttqf87uUnLCbKY0IR8G7c0xga6dolaqH+ZNInRaXZNSDaW9sCY9tX/RXaHKlwM2Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787732120; c=relaxed/simple;
	bh=Ide7a1rRU3u9KywgEQqcNpS7Ea/WYSoIVFl8vETMXpE=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Wrq/6DntavpzjJpgtCmJ+OOPsgpPFbe2cE8htnep0tL3LJ0n9bbS3kyuRHI18XfI/HseiHcJsqAuke+5wyJ6FH96w+FwM9ufR443S8cusQy4DaAsisL1twf8UZS3CZHUNQq759unzOa7/3qhzQ+7V60qw0FDCWFpW1sf4DYrE6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GJI24z2S; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GJI24z2S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787732119; x=1819268119;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=Ide7a1rRU3u9KywgEQqcNpS7Ea/WYSoIVFl8vETMXpE=;
  b=GJI24z2SxNw/w7h4T/ZqqmrlkQhqUcAYWFbhcxwjIsK1yEnn0Z3ifhFz
   58YH7AWsMTjcPUO0WZR0SMZHRJv2kAoKde0lzQTqAyRKCx1HMMzkxa1Ll
   ON2zehm99xz/dYaxOb0ul7XOQNusZoU9hEUaZynZI9hEsoUwFyINxKrDw
   nYA3NnjZXLanA+MSfhGBEat/CJXFBLGeRU5S2/XzbfM7YozChRHl1ZzzG
   DN6dSZQcEPpK7/5zv1wnjSR1nEO6lILm7/aQmql5ZzzEYC5lxl73wkO7M
   PZTbSPaiU+HV30bYUbckTbD8uTawFOxjPlM96CE6rfRkKWr/KQOZMJm0e
   Q==;
X-CSE-ConnectionGUID: oQ66FMnlQ0mWrZ6fqc1oAg==
X-CSE-MsgGUID: D0N1dx06Rw2prn2CvyRCPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="90719835"
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="90719835"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 01:15:19 -0700
X-CSE-ConnectionGUID: RnUlrpzcS9qGzAacLyGNhA==
X-CSE-MsgGUID: gLKrYDw4Sa2aiukMxft1zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="271006263"
Received: from abityuts-desk1.ger.corp.intel.com (HELO localhost) ([10.245.245.247])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 01:15:15 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Wed, 26 Aug 2026 11:15:11 +0300 (EEST)
To: Tony Luck <tony.luck@intel.com>
cc: Hans de Goede <hansg@kernel.org>, Borislav Petkov <bp@alien8.de>, 
    Breno Leitao <leitao@debian.org>, platform-driver-x86@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
    Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [PATCH 2/7] x86/mce: Enumeration updates for Intel bitfix filter
 reset
In-Reply-To: <20260825181526.13203-3-tony.luck@intel.com>
Message-ID: <cf4b1c2a-b21b-de7b-ff65-fe3e2f1a7f78@linux.intel.com>
References: <20260825181526.13203-1-tony.luck@intel.com> <20260825181526.13203-3-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 25 Aug 2026, Tony Luck wrote:

> IA32_CORE_CAPABILITIES enumerates the bitfix filter reset feature.
> 
> Also add definitions for the threshold status field in the machine
> check status registers.
> 
> Co-developed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/include/asm/mce.h       | 6 ++++++
>  arch/x86/include/asm/msr-index.h | 2 ++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index e575b702063d..0d5bcb6f1750 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -13,6 +13,7 @@
>  #define MCG_CTL_P		BIT_ULL(8)   /* MCG_CTL register available */
>  #define MCG_EXT_P		BIT_ULL(9)   /* Extended registers available */
>  #define MCG_CMCI_P		BIT_ULL(10)  /* CMCI supported */
> +#define MCG_TES_P		BIT_ULL(11)  /* Threshold-based error status supported */
>  #define MCG_SEAM_NR		BIT_ULL(12)  /* MCG_STATUS_SEAM_NR supported */
>  #define MCG_EXT_CNT_MASK	0xff0000     /* Number of Extended registers */
>  #define MCG_EXT_CNT_SHIFT	16
> @@ -41,6 +42,11 @@
>  #define MCI_STATUS_PCC		BIT_ULL(57)  /* processor context corrupt */
>  #define MCI_STATUS_S		BIT_ULL(56)  /* Signaled machine check */
>  #define MCI_STATUS_AR		BIT_ULL(55)  /* Action required */
> +#define MCI_STATUS_TES_SHIFT	53           /* Threshold-based error status */
> +#define MCI_STATUS_TES_MASK	GENMASK_ULL(54, 53)
> +#define MCI_STATUS_TES(s)	(((s) & MCI_STATUS_TES_MASK) >> MCI_STATUS_TES_SHIFT)

This opencodes FIELD_GET(), and you don't need usually need _SHIFT define 
at all when you use FIELD_GET().

> +#define  MCI_STATUS_TES_GREEN	1	     /* Threshold-based errors below threshold */
> +#define  MCI_STATUS_TES_YELLOW	2	     /* Threshold-based errors above threshold */
>  #define MCI_STATUS_CEC_SHIFT	38           /* Corrected Error Count */
>  #define MCI_STATUS_CEC_MASK	GENMASK_ULL(52,38)
>  #define MCI_STATUS_CEC(c)	(((c) & MCI_STATUS_CEC_MASK) >> MCI_STATUS_CEC_SHIFT)
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 18c4be75e927..13d3efc87b14 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -114,6 +114,8 @@
>  #define MSR_IA32_CORE_CAPS_INTEGRITY_CAPS	  BIT(MSR_IA32_CORE_CAPS_INTEGRITY_CAPS_BIT)
>  #define MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT_BIT  5
>  #define MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT	  BIT(MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT_BIT)
> +#define MSR_IA32_CORE_CAPS_BFF_RESET_DETECT_BIT   9
> +#define MSR_IA32_CORE_CAPS_BFF_RESET_DETECT	  BIT(MSR_IA32_CORE_CAPS_BFF_RESET_DETECT_BIT)
>  
>  #define MSR_PKG_CST_CONFIG_CONTROL	0x000000e2
>  #define NHM_C3_AUTO_DEMOTE		(1UL << 25)
> 

-- 
 i.

