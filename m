Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85EA15B129
	for <patches@lists.linux.dev>; Wed, 15 May 2024 22:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715810475; cv=none; b=VAQ7vNZ8OAJQO7P0Fybur8AnCJxHgKq/MkgavbVF8miP7ENiXe8xxlfUlqAcDv+lhhhcoMQQp/9wJ1waH9+Z/cmidC5RIeQSTteyf/JBpPIIReMOC5XK6JrKJ/UVmq69DFCbd6arr8Xj04FuPUM79cpDkxFDpM9+4b3mLYqRcFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715810475; c=relaxed/simple;
	bh=WBflPNnguyzCbGhyi8kVvOzAAj24TdMyE4PIQIyS9L8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LtqYds8wcGL2Rfv/+y6oSmHiEcAcajWfhiHyPk6HxdJMStsfotvZqYuO9lzs9HcEjyV/fwKpCyM1935ok16I5pOyNy3uoXYZmIyJSwGP6pB9atkpQ5Pvo7/kLtj8E1vL7l8luu+1if1j1Kzs+sutEM2x5MWPAy8NMOicHpWS2Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=bDpMHWQd; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bDpMHWQd"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E329640E01A3;
	Wed, 15 May 2024 22:01:11 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ge1W069CeEPb; Wed, 15 May 2024 22:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1715810468; bh=T6EaO+NB9zsv3zMwUnb4vxkzKtoC6naH4PBduEJOXHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bDpMHWQdVnXzTFjs3KsRiP+O/QIg7B9qVe47Eegz8oyIlQZ7OZ2gXVmsEfNi9UgdT
	 UqHFGPRfvdrGlO9Ge1kkeH3sJ0ns/h0mVMW8wqh6TanhiE88vdGj3vxpfxRONQSzfM
	 dFTnAqrHrzonJsE5qqfFho/grtPNXNXbdPRHrNLe6HgvVnHBrGWIfYs0Yoh+PglfMy
	 mRo7q/wlQrLD/EPwXqkCoQPfOWaYAxf9Kh/UYuyw3vIklMFZ5PU0wf7agnL4Ca9CU6
	 oRZPazSz9n+2XUZKB/o0ymShuN4yYyIZfRDqoLj8gmlzAgOlgiL2w15IL4FV27GQ2r
	 HskdwraMlSStX/WZf0WP03dTiitkrjAxxtucxjS/Hi7mxIuvhd5ewX+/WirYxEg8ho
	 Gk8GsuZMgMs5emCS/Uc8ClWAGWXVeJDMfngBmQ+KsM3Fyy2QWEkR/GDV8trTiIseN1
	 FBUyjUYH6mX54Qg+zJ+GTrWy2C9y5Nzsb8BDirCem0fNIkqjDG7WdEn8Q8PjHR3CI9
	 qDBxNSKrVRhJkhCvJ00e9ByOFp8IS9Y5DL7TEQrIO/gds4Sd0BBnMTkDakLI/rYA7z
	 rTbsYMCYSJmtMTG0Uu4KqUaYKKQhk2/mebHziBrx/2hybh1USqKdZKzdw+kfQRaUzE
	 dhW5ohj0OmzUt+4NaKWf0wEs=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 239C740E016A;
	Wed, 15 May 2024 22:01:04 +0000 (UTC)
Date: Thu, 16 May 2024 00:00:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Message-ID: <20240515220058.GEZkUwmtNazjQaLdDn@fat_crate.local>
References: <20240515214357.73798-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240515214357.73798-1-tony.luck@intel.com>

On Wed, May 15, 2024 at 02:43:57PM -0700, Tony Luck wrote:
> There's a wildcard match in arch/x86/kernel/smpboot.c that wants
> to hit on any CPU made by Intel. The match used to work because

intel_cod_cpu[] or which one?

Please be more specific.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
