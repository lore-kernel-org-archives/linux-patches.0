Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C8B184D
	for <patches@lists.linux.dev>; Wed, 17 Apr 2024 07:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713339889; cv=none; b=YKClsOBcJAk67KKxAj89Obvm9GM4rMEiYv0vZVbJQSwKQVk6Y567MSQ6ez0hFxHDksftQpHUfdnI7a/o2PQQwUKm40ZDy23lkz+bVXdfmfWDqYrgOdHjWYfgd0HGjsnc9UjeDrxo+JpR/QipIw5UR6QzxKNf6V75vngoWtJScg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713339889; c=relaxed/simple;
	bh=Le1XBAG80UzXZ5fJRhAn6sSYUHbNBDFbEaiuc+1VJe4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LKh0Io8s2Uh3rMwjiQp5lMgEv1bel4G6cfZN7uoPRug5HEUPaq6jnOwO0tMfsqAhkM8m/djuJDzDC7cJ75VYOdRrMw36WxVGREtw/KT9BsXkgL6ER+aIjoDhGZwS972KofiLW2PUjLP+Hinrc3TApXaUuoFn0LK0fBYc63nYNTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dAOxoxXr; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dAOxoxXr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713339887; x=1744875887;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Le1XBAG80UzXZ5fJRhAn6sSYUHbNBDFbEaiuc+1VJe4=;
  b=dAOxoxXriXIRGdnwyqYrL5M/7WzPuVAIReawRN10AS4T7zeQ2XhthJK5
   bL+1oK8Vpm37Rr9ouQP3QM4y5R7uLhHnGMBgxQ/em7goQgXT5I4e2tFgH
   mUpd2fwmb+u1SEnXcBv1XbZeaOwcfwOzMygYdWp4eopggewnEfxbaabaj
   y+ifWrc9w9PrdGfoYDcIoAvXXsz8z1SuSYNDFYuEmpwb8Ea4AIHW0Rve3
   AGbdIghZ5CQsFxP13Z1NUyrF6BJSpxajwbCJS5Zs3q4SEiPKsckRqfx/t
   kJybY9KdKQvyPxwPxIQL463YDF8+7pNZoRt4DrRaGeD+dX2ax4whffjet
   w==;
X-CSE-ConnectionGUID: b4Fkyg1nQ2+j5odIsaa1NA==
X-CSE-MsgGUID: 90xRqs+CTHSyIDBCOGTi5g==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="11759084"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="11759084"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 00:42:35 -0700
X-CSE-ConnectionGUID: +fTXNeW+RpeTQQFXGr/eqQ==
X-CSE-MsgGUID: g1co9ad3TSOc5RcLXb9hGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="22613333"
Received: from aslawinx-mobl.ger.corp.intel.com (HELO [10.94.0.53]) ([10.94.0.53])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 00:42:28 -0700
Message-ID: <ebef1fa3-ece5-4fb0-b887-9b33b8b6f724@linux.intel.com>
Date: Wed, 17 Apr 2024 09:42:25 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/74] x86/cpu/vfm: Add new macros to work with
 (vendor/family/model) values
Content-Language: en-US
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>
References: <20240416211941.9369-1-tony.luck@intel.com>
 <20240416211941.9369-3-tony.luck@intel.com>
From: =?UTF-8?Q?Amadeusz_S=C5=82awi=C5=84ski?=
 <amadeuszx.slawinski@linux.intel.com>
In-Reply-To: <20240416211941.9369-3-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/2024 11:19 PM, Tony Luck wrote:
> To avoid adding a slew of new macros for each new Intel CPU family
> switch over from providing CPU model number #defines to a new
> scheme that encodes vendor, family, and model in a single number.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>   arch/x86/include/asm/cpu_device_id.h | 93 ++++++++++++++++++++++++++++
>   1 file changed, 93 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
> index bf4e065cf1e2..833f230aeafc 100644
> --- a/arch/x86/include/asm/cpu_device_id.h
> +++ b/arch/x86/include/asm/cpu_device_id.h
> @@ -2,6 +2,39 @@
>   #ifndef _ASM_X86_CPU_DEVICE_ID
>   #define _ASM_X86_CPU_DEVICE_ID
>   
> +/*
> + * Can't use <linux/bitfield.h> because it generates expressions that
> + * cannot be used in structure initializers. Bitfield construction
> + * here must match the union in struct cpuinfo_86:

Typo:
cpuinfo_86 -> cpuinfo_x86

