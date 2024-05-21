Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B770014885C
	for <patches@lists.linux.dev>; Tue, 21 May 2024 17:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716311971; cv=none; b=U0NsYEEBeggRS/FeXBIIPXtgxG+Vv2fWtM90Py/ATGsp1WXxnbLtE9XaUvk8+db0WEcQ3xlseAgGc7rTX7oKApUyVKVowvcq5V0vCVHK22U+/91M/kS2sc2VTVqLn7Fe+3NODFuuBCegxII4BIm5bB9MBqRjDhcAx1Fx8YLKh1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716311971; c=relaxed/simple;
	bh=SnjQmmHj3682eqik0h6BacYnsaW2Q1DcBY8AcxJVqp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EuU+6LJIkEkLUgFJZdgpQn/9VeXNWeUNESoUggC64zHOqaSlEkTsmv1VuoVUDciY5xEthdE3PczUQN3YJs3187ptjX+pspTvlgcmdu2IWQE2jXPZJ/Gy1yqnwcoQ03fRkR4kspToYpN/UhXMy8Wywvc17ALT2gSCK5lDPaNFNZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=dtbyA5bA; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="dtbyA5bA"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 561A140E02A7;
	Tue, 21 May 2024 17:19:20 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id F2vLtku8JMay; Tue, 21 May 2024 17:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1716311956; bh=dJikrL1uuSAnJySe0ZT1Y6BvwVtJE8CcgDSwOfEYw28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dtbyA5bA2FTWkiYSSQbn80ZNL3oQB3QQZd7Ll/zSq/zOvO7HkF0V0NiBvU5hvGMRJ
	 GI296/OBkRqkZNlLVPCG6IPqte/m1kZDMWF4XQ5qO2JLGEd7z4QMq0Iw+APOan/az9
	 0gdJoqVrHkAogSShPJscoWsZQDN6hb9Cj8zlgIeftI64VAGbKJ8yu+ovR3AmrjhRZV
	 APa9nsGWgrgN4ZOSQH7Fo/V7d+I4KhV06ae8hxF+Q07T1ZDG2A/MtI/XUyanv3ob2m
	 8GOTejDa9Mze/vqsWeWv7rEHa56AjDdqGVoIsfjO4WZlXVwAocTM8EwHUVzzodibtX
	 4gOEGcSo0Rzo5Ob+CK2TOajV5YhKDPduOiz2sFncXsVeIMHP5sA3kRYcDqL2JoXEHP
	 wrmdhZuT8WHfqdNg+A7Z911bsPvk0FlrEuQktJGRjGswFojeZLKf6xQuh/fwSuYSZe
	 b8rGQKjk2LP9QwGkJoa35MoTq5kdHhlYjo34qVwNn6MGPrqO3YpEuoWBqYoYf/0THx
	 ypi1kCwnt7rH6ZrhedfMGzE6VVsHaRbheHohE5DB+oBzXKm4OpOzS0rZhVCaz7GP0H
	 VwKfx+mx6qPI+vMy/2FYb/ExoVOamL2IlFj3oJXD80zaqjBPIBOWZgtquD2gq8Zo8U
	 BrDnbrzirsOq2GLkrEMFoRx0=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 91FB440E01A3;
	Tue, 21 May 2024 17:19:01 +0000 (UTC)
Date: Tue, 21 May 2024 19:18:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v6 02/49] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Message-ID: <20240521171856.GEZkzXgH4z4hYKOZOA@fat_crate.local>
References: <20240520224620.9480-1-tony.luck@intel.com>
 <20240520224620.9480-3-tony.luck@intel.com>
 <20240521074947.GAZkxSG_u08uLDqZ_m@fat_crate.local>
 <ZkzCUj7zCcGPT-IX@agluck-desk3.sc.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZkzCUj7zCcGPT-IX@agluck-desk3.sc.intel.com>

On Tue, May 21, 2024 at 08:48:34AM -0700, Tony Luck wrote:
> I didn't include a Cc: stable. Is there some better way to report
> the source commit for a problem without triggering a backport?

Looking at:

Documentation/process/stable-kernel-rules.rst

I guess this:

"There furthermore is a variant of the stable tag you can use to make the stable
team's backporting tools (e.g AUTOSEL or scripts that look for commits
containing a 'Fixes:' tag) ignore a change::

     Cc: <stable+noautosel@kernel.org> # reason goes here, and must be present"

Might want to explain in that reason there what the situation is and
that this patch should be backported only when the SNC change is in the
tree or so, yadda yadda.

Or the crypto one - your patch 1 in this thread.

> Agreed. Looks better to keep the define out of a <linux/*.h> file.
> 
> Do you want me to spin a new patch? Or can you fold your change into
> my patch when applying?

Nah, I can fold everything in.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
