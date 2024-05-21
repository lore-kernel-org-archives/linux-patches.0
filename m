Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3627F48F
	for <patches@lists.linux.dev>; Tue, 21 May 2024 14:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716300736; cv=none; b=JRywqnhSib2Yxk3/xIr9b76K0J2JHMPf65cuu8P2P/xAmd3h/h28wpDGWi8ap7eFkEjsdarvxo3K3Daym5hbHPVLMx3B3K+KbFeTx1VJgPJXRGB1EJ1OGlKbCItXJiuqwQ14snC2aDdVljtKuvnQDE9ke0LaQh+OqpSlEcznnNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716300736; c=relaxed/simple;
	bh=x2tg1u28EWD6xzEiwBwWDlgtf82EbGpFYmzDT7mpwLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tFqiaieSMvI7NvgbStJSw/y335YwLFHqZ1v2p9pY1xBTPKPHDyD2RGTMdIPTnq5S8w7kD4C7EwMN6nK0GThYmadBpVQIPa9iPgduAi9rC84bWPU3ffunufna/MsIFCDWIgVgxG2+y3xdNSs9+hCC0Nyho+jZ48HpoXRxWBbgZ0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=fail smtp.mailfrom=kernel.org; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.org
X-CSE-ConnectionGUID: TdQ/TBngR/CCFMDQdT2+qQ==
X-CSE-MsgGUID: VyI7FPc4TNCnwUfjw1vpVA==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="30004811"
X-IronPort-AV: E=Sophos;i="6.08,178,1712646000"; 
   d="scan'208";a="30004811"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 07:12:15 -0700
X-CSE-ConnectionGUID: Xw61+hBiTTWYqmRt1qOffA==
X-CSE-MsgGUID: W9H9O+k7T3WBPmUVe+v3aQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,178,1712646000"; 
   d="scan'208";a="37892273"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 07:12:11 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andy@kernel.org>)
	id 1s9QDm-00000009g32-3emo;
	Tue, 21 May 2024 17:12:06 +0300
Date: Tue, 21 May 2024 17:12:06 +0300
From: Andy Shevchenko <andy@kernel.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v6 16/49] x86/platform/intel-mid: Switch to new Intel CPU
 model defines
Message-ID: <Zkyrtgj7yQR8H-Bz@smile.fi.intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
 <20240520224620.9480-17-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520224620.9480-17-tony.luck@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Mon, May 20, 2024 at 03:45:47PM -0700, Tony Luck wrote:
> New CPU #defines encode vendor and family as well as model.

...

> -	switch (boot_cpu_data.x86_model) {
> -	case 0x3C:
> -	case 0x4A:
> +	switch (boot_cpu_data.x86_vfm) {
> +	case INTEL_HASWELL:

Thanks, God^W your series, I just realised that this is quite a mistake.
I mean, you need to remove this line (with HASWELL) from this file.

  Fixes: bc20aa48bbb3 ("x86, intel-mid: Add Merrifield platform support")

HASWELL was never a part of Intel MID initiative (in a sense how it's
organised in HW and FW).

> +	case INTEL_ATOM_SILVERMONT_MID:
>  		x86_platform.legacy.rtc = 1;
>  		break;

So, TL;DR: Please add the patch, I will give a tag to it immediately.

-- 
With Best Regards,
Andy Shevchenko


