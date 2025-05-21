Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AEA1A5BAC
	for <patches@lists.linux.dev>; Wed, 21 May 2025 21:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747862767; cv=none; b=N9xoBE0vyWZBtt72SgQe0+eMWrTx/p5Z+8aWLx3vg/efgDgLzgrf+EvhthzL50qbefXASwFQwpblM2CPBhSsnupGZNF3kpO64TDuGOmVgppWRtO3Ry134xboc5Rt9qwxUILS/vwyxA2oyz7NWnRQepp1AMzqpbh3+bWiW8R0r5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747862767; c=relaxed/simple;
	bh=bcXmaaPzQjxXCtKv8uM2pdouSD5ZCy58z4JthWLzheA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AncZsgg1eVNScfoxfXtk2bGBUK6Wk1imM6IVRNtZY8nTyznounbHAW7kMj8Etq8v6MSJexRUM9H+H1OxgNB1VMRhEv5xfUs4GxSZYSDA1JW5Az2gGeRODi2x/QbNafL9HMHwlQ7hKxaieGuHgY4KqpNvzZR2Qf4a2Ut5DRVWWCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hvJgU9TE; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hvJgU9TE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747862766; x=1779398766;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bcXmaaPzQjxXCtKv8uM2pdouSD5ZCy58z4JthWLzheA=;
  b=hvJgU9TEe1M4r/oLiZYojSjadIx7n0n2Nj4VT0NA7n0iCHWgJeBqXmJe
   OQMGxzUKCdz3zgX0PuI4CvItRfF4eRcZnsuErlqjIoAxmf2o0G9QJ5vN9
   OyAYSnFguMTtPUulNwcG/IWhaHPkLmZCL0AeN16q3M4ZGoSGGwjBLN2f4
   UbvDsCni6jMXQTU6Eor4jLH6Tb6iCsgl6Mko7sRBxCkYvAyW97SBCiVdb
   xSaCEvLnnfOg1uuz6wapTmp2QzbS1Gh9yAmS4i8KLe6d/V3QLYo06dTk1
   XQwRYOqk+loH4inIKkC0/O/GMyGaF/THIYee9AIWBEqmWaxlcmjW2Bf00
   A==;
X-CSE-ConnectionGUID: QA1SB99KRhCy0ds53LHFag==
X-CSE-MsgGUID: etnMshEcTjCLNINy6kHN9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="61207321"
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="61207321"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 14:26:05 -0700
X-CSE-ConnectionGUID: z+3VBKYXQ5KkKqOJj9HalQ==
X-CSE-MsgGUID: pPhP+5HhSbezxQOijYiolg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,304,1739865600"; 
   d="scan'208";a="145390862"
Received: from ssuvarig-mobl.amr.corp.intel.com (HELO desk) ([10.125.146.23])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 14:26:05 -0700
Date: Wed, 21 May 2025 14:25:56 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Alexandre Chartre <alexandre.chartre@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Salvatore Bonaccorso <carnil@debian.org>,
	Moritz =?utf-8?Q?M=C3=BChlenhoff?= <mmuhlenhoff@wikimedia.org>
Subject: Re: [PATCH 5.15 00/59] 5.15.184-rc1 review
Message-ID: <20250521212103.gpdkplv77acgsdsb@desk>
References: <20250520125753.836407405@linuxfoundation.org>
 <81cd1d38-8856-4b27-921d-839d9e385942@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81cd1d38-8856-4b27-921d-839d9e385942@oracle.com>

On Wed, May 21, 2025 at 09:10:58PM +0200, Alexandre Chartre wrote:
> It looks the problem comes from pages allocated for dynamic thunks for modules, and
> this patch appears to fix the problem:
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 43ec73da66d8b..9ca6973e56547 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -460,6 +460,8 @@ void its_free_mod(struct module *mod)
>         for (i = 0; i < mod->its_num_pages; i++) {
>                 void *page = mod->its_page_array[i];
> +               set_memory_nx((unsigned long)page, 1);
> +               set_memory_rw((unsigned long)page, 1);
>                 module_memfree(page);
>         }
>         kfree(mod->its_page_array);
> 
> I don't know the exact underlying issue but I suspect that the kernel doesn't
> correctly handle pages freed without the write permission, and restoring page
> permissions to rw (instead of rox) before freeing prevent the problem.

Your analysis aligns with the proposed fix to backport below patch as well:

x86/modules: Set VM_FLUSH_RESET_PERMS in module_alloc()
https://lore.kernel.org/stable/20250521171635.848656-1-pchelkin@ispras.ru/
