Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D4A8C1D
	for <patches@lists.linux.dev>; Mon, 29 Apr 2024 03:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714360761; cv=none; b=jMWrVHQKVzDgUDfND64FP6Ney+b6ukuNnIDbjkQC6xAjY4SF7uD5nSbAdyLE/RJ/jZF1mWoCBIFfBnNqv58hHSWSRdh36UpC7+ImZEaxIJlgaguGYGs1vfnQ1mz/OUi/IwzovrLXXMnkJTu9vubtxW9YMdYnv3A3lCD5d6Eehcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714360761; c=relaxed/simple;
	bh=OciEEx6Xa4RgJ2yE5vkIFxrnfJLD6otTLW5rQZyujT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XC28YjaudJGLcFrGT1HQ5CnN9Y8YkYW+4LXVZvt53NXPEUmqmV89FyYS/QjtMWWC4OBZXotDKj2eX+5A/c1ssolIo4GsFvdsWGb6R6lUbwj7TczlXhBuQ8dPGsvQ7V8d4qpquYIT3vQjtXpLMIkqHNVccI6SnQCfX7Yl6l74KHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CtEYzdkF; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CtEYzdkF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714360760; x=1745896760;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OciEEx6Xa4RgJ2yE5vkIFxrnfJLD6otTLW5rQZyujT8=;
  b=CtEYzdkFPZw5UIz4RxjGFx13WYyneUt/pt28pUQkMahnBlC1CFnKv5eP
   7nAYcW7oPFoFQBitKTeCwf6OmziTJTJ0mrUQBqjPU4G1eNKeCWn/Lg4ip
   /RFIEtYXBIqu+6hXUEpbLeVc+pYAAYaDtz3c6SX0dRJOeq4PAdo4x9Tbz
   BikuFpyg2W0g5wO/SreCRhcXmVMiwJBR6+eobvqiSgCJjJ1bHNzJaPMFg
   By+THTZajTtqLEFATn1H3gsz7Q27ryYiwKVPB+FsBGVgs6dyq2ubJb9Jg
   D4JDwSQgeynWSi3v4kMd/VAR3x5OCWrx37n+oWz1I6hKyzuIIV04r+huM
   A==;
X-CSE-ConnectionGUID: NWonPspvQNadc7oTaTct0w==
X-CSE-MsgGUID: 2Nd2j0OZSMKvRwavf5vMyg==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="10226901"
X-IronPort-AV: E=Sophos;i="6.07,238,1708416000"; 
   d="scan'208";a="10226901"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2024 20:19:19 -0700
X-CSE-ConnectionGUID: CJ2Vjf+9STq/TRcESaF6hw==
X-CSE-MsgGUID: wyUBUmKiR3mGXD/N8gFbVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,238,1708416000"; 
   d="scan'208";a="56876978"
Received: from kscheema-mobl.amr.corp.intel.com (HELO [10.251.17.13]) ([10.251.17.13])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2024 20:19:18 -0700
Message-ID: <96c53b0a-5123-4542-8bb2-f8a3f25f112c@linux.intel.com>
Date: Sun, 28 Apr 2024 20:19:16 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/71] platform/x86/intel/ifs: Switch to new Intel CPU
 model defines
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
 Jithu Joseph <jithu.joseph@intel.com>, Hans de Goede <hdegoede@redhat.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: Ashok Raj <ashok.raj@intel.com>, platform-driver-x86@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20240424181245.41141-1-tony.luck@intel.com>
 <20240424181445.41193-1-tony.luck@intel.com>
Content-Language: en-US
From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <20240424181445.41193-1-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 4/24/24 11:14 AM, Tony Luck wrote:
> New CPU #defines encode vendor and family as well as model.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Jithu Joseph <jithu.joseph@intel.com>
> ---

Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

>  drivers/platform/x86/intel/ifs/core.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
> index 7b11198d85a1..33412a584836 100644
> --- a/drivers/platform/x86/intel/ifs/core.c
> +++ b/drivers/platform/x86/intel/ifs/core.c
> @@ -11,16 +11,15 @@
>  
>  #include "ifs.h"
>  
> -#define X86_MATCH(model, array_gen)				\
> -	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6,	\
> -		INTEL_FAM6_##model, X86_FEATURE_CORE_CAPABILITIES, array_gen)
> +#define X86_MATCH(vfm, array_gen)				\
> +	X86_MATCH_VFM_FEATURE(vfm, X86_FEATURE_CORE_CAPABILITIES, array_gen)
>  
>  static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
> -	X86_MATCH(SAPPHIRERAPIDS_X, ARRAY_GEN0),
> -	X86_MATCH(EMERALDRAPIDS_X, ARRAY_GEN0),
> -	X86_MATCH(GRANITERAPIDS_X, ARRAY_GEN0),
> -	X86_MATCH(GRANITERAPIDS_D, ARRAY_GEN0),
> -	X86_MATCH(ATOM_CRESTMONT_X, ARRAY_GEN1),
> +	X86_MATCH(INTEL_SAPPHIRERAPIDS_X, ARRAY_GEN0),
> +	X86_MATCH(INTEL_EMERALDRAPIDS_X, ARRAY_GEN0),
> +	X86_MATCH(INTEL_GRANITERAPIDS_X, ARRAY_GEN0),
> +	X86_MATCH(INTEL_GRANITERAPIDS_D, ARRAY_GEN0),
> +	X86_MATCH(INTEL_ATOM_CRESTMONT_X, ARRAY_GEN1),
>  	{}
>  };
>  MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer

