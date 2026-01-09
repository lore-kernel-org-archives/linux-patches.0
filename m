Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9156D33CE92
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 15:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767973071; cv=none; b=f3033Tm7CYKZG7PF2L5zK/1E5nwHlP+t6yKff8lV8XZLK+JE137zjCj/hHsPomdxliFf4ckVj7mr0q1Pm4U8MyEwEEiwPJ73TUYpFCYOMcwvAgr6HHPHx9oBBBBBJPFskIfN8BiA1+zI13maU5zhfXd9K+WfoXHZrbpoXqjJI7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767973071; c=relaxed/simple;
	bh=eHHfkh7PMM+dME08ptuElzFnbV++Hm5gFDCJ28ZwKr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g+I4BeEMF6jlx4NTCFq48mFxwndcP892LjKS1zbEv9Oo0JTSslMzSfks9gSHWWmBvFCu3aI+ZYaQB5vaaKPeJ6LcKPnxekRomb3pRRAejucUnrI8vjb2WDSqPtQQxNPEa0vRR86zUXDN0OqA5/8sZKZ+NH10CdGesgHKI61oUYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=GGG6tnPX; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GGG6tnPX"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5134F40E02D3;
	Fri,  9 Jan 2026 15:37:47 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id NSNlQb-LLMaA; Fri,  9 Jan 2026 15:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1767973063; bh=c6JKP2LFYynYh/hnJIimPjKNdm7fpNLqoBt+2/lzTbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GGG6tnPXFXCny8RfkgP79uPVR9nf6ut5yAA93OzKDo5+eYHg3hnVDSGLqfeLgJClN
	 UKKv8d0xqwhpkaw13ShaWXmblh2kA5dY70z2un/0Sf/HmoY6XtMiPGZMauyG9MI6IP
	 LwPA9Mh7xsgHn+0Yn+wHG+hVjopoC/isy+lOEIYaBcLVwZc+2cN/+JR3OWZSs7pLPb
	 tPfNdB1cj0c/XoEAppcGa4QMYahzxmfRADXHkswvVsqm8QV2SHj/+MzhnfK6qM/LMe
	 zZTU/TkD32jtxiv7BHx+pKhMzpizQiZ9VpMQJw+IvZB0oIHhjnDQSTk3wW3kLOB4Ns
	 x81jviPZ9MLOvzl1WNiMXmwOj3/9AFidpLRjspVtqyHe6rgGVU9G9kWV43D5BkVyLp
	 YVsEdfe5TJLpXTO2gpIkmYaLUBTm9EzhpdYAOh3nVWhSe/wr80QObnjVhs7UQFnyzh
	 /9IO03wd7GNdvTxVFgqSU3e8jQvdnTWs4q1Btdmg7dRrx0qcQeMXLxfUFUwt06r7gY
	 ezG6B5yEq6TdkOU0SII2XslgZAlD24Eepar7Dzt2NwkDo5NOAODLlSug2Uka5A66Zc
	 hZoLtOdahf7Ye8EUepppeN3XLTO2z6Up84zLOZ/7/2T3Lr7ATyeSzCnEmCTfUEC/aP
	 ElfqflqJrdOa+8M1szcZxEp4=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id B4D6A40E02D1;
	Fri,  9 Jan 2026 15:37:30 +0000 (UTC)
Date: Fri, 9 Jan 2026 16:37:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 13/32] x86,fs/resctrl: Add an architectural hook called
 for first mount
Message-ID: <20260109153725.GCaWEgtcwzF0DUnfSR@fat_crate.local>
References: <20260108174227.11307-1-tony.luck@intel.com>
 <20260108174227.11307-2-tony.luck@intel.com>
 <f3a5f539-0843-4643-9b52-8bb7315441ed@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f3a5f539-0843-4643-9b52-8bb7315441ed@intel.com>

On Fri, Jan 09, 2026 at 07:28:25AM -0800, Reinette Chatre wrote:
> Needs imperative. "Only call the hook on the first mount ..."?
> Although, to help with brevity, the last three sentences could be merged. For example:
> 
> 	Add a hook for use by telemetry event enumeration and initialization and
> 	run it once at the beginning of resctrl mount without any locks held.
> 	Architecture is responsible for any required locking.

Done.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
