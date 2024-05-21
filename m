Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F7917997
	for <patches@lists.linux.dev>; Tue, 21 May 2024 16:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716308258; cv=none; b=KH8xpANxWRCOaqfNGrXgvXtbdL75mTWhMeeDc3DtmZWOelFWVIvydi25LYG2zruwWIoGQtzb/rFFanOAVR0RaDUWdGn72AYNgw2ObpIf3OHbxxVe7PgaJwCVI9z77MiIH5GFiBGoCdAQDu9L8OTDkw7nKHYZcFzoOFE4ASJCcvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716308258; c=relaxed/simple;
	bh=Mp+X4n+G4e+9QIapZ3qaEU0CrBdfMJsKLNODW33+ROE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f+DDG2FEuQQKvW7tLvwImLj/h+cROEfY0RDWgEAZgEC835AYXprY5Cozm3sGf579LO5JZwMdmEqJGxrSHyWt7M1MiFTVpq2nhIDitF1hwhFLCFs1Fe+Ih8KQsv9iiS5kr3swOwOox2ARZFYeJ2SwnvurPaDyOGUXNdgIfkoqO94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=fail smtp.mailfrom=kernel.org; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.org
X-CSE-ConnectionGUID: llM+uVlbT0aILzMifyaH6g==
X-CSE-MsgGUID: dL5EGQuYQdOHG4Q2JOfFkg==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="23652303"
X-IronPort-AV: E=Sophos;i="6.08,178,1712646000"; 
   d="scan'208";a="23652303"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 09:17:21 -0700
X-CSE-ConnectionGUID: FInIGSHkSASZXYn4LNWvgw==
X-CSE-MsgGUID: P/ernt7WR92JzSqFzPwp9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,178,1712646000"; 
   d="scan'208";a="70387499"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 09:17:17 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andy@kernel.org>)
	id 1s9SAr-00000009i16-3hrV;
	Tue, 21 May 2024 19:17:13 +0300
Date: Tue, 21 May 2024 19:17:13 +0300
From: Andy Shevchenko <andy@kernel.org>
To: Tony Luck <tony.luck@intel.com>
Cc: ak@linux.intel.com, arnd@arndb.de, bp@alien8.de,
	dave.hansen@linux.intel.com, hpa@zytor.com,
	linux-kernel@vger.kernel.org, mingo@redhat.com, mjguzik@gmail.com,
	patches@lists.linux.dev, peterz@infradead.org,
	rick.p.edgecombe@intel.com, tglx@linutronix.de, trenn@suse.de,
	ubizjak@gmail.com, x86@kernel.org
Subject: Re: [PATCH v6.1 16/49] x86/platform/intel-mid: Switch to new Intel
 CPU model defines
Message-ID: <ZkzJCWIahaYPYwDz@smile.fi.intel.com>
References: <Zkyrtgj7yQR8H-Bz@smile.fi.intel.com>
 <20240521161002.12866-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521161002.12866-1-tony.luck@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Tue, May 21, 2024 at 09:10:01AM -0700, Tony Luck wrote:
> New CPU #defines encode vendor and family as well as model.
> 
> N.B. Drop Haswell. CPU model 0x3C was included by mistake
> in upstream code.

Yep, the result looks good. Dunno if it's better to have a separate patch with
proper Fixes tag. Up to you, folks.

-- 
With Best Regards,
Andy Shevchenko


