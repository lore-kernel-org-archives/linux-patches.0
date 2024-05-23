Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4381813BC0D;
	Thu, 23 May 2024 11:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716465482; cv=none; b=pfqN7UPZzaHIg4J/fHEgODZ1UilwLr+vokM8fSXiwpR3bdfZfiOTuCA3nUaIg4NWtUOOn6mPSMyrzdE/gQ/iLG5OpPu+dp+HLL/TPc3yVoTkztcwUPhPCRNKWJMqJCAgRMdoTJQaZwohZJIvjXf3L3XgcA+0WRcM2LFLsInEsMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716465482; c=relaxed/simple;
	bh=HAA1JcByLN2wxVzM8aQ+x0+swB/h7EfCk3kNXfRjJPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dpl6CsgCKBn19/wRHOKq293pet/XoolKiBQTIqVdbvnUBZlmrtoI0gwJiqY/KGZVtEJusIwVyWShqKlwI+qjOqRRlyhTgDD0XIikV4UubvsbXpq2Lg3sKF+HwSdzxj0Ld31xQJ7yWj948Sc1/VsVqwoZ3MCFHff/HxT559fEjYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=AHEaR+8V; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="AHEaR+8V"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8E80840E016A;
	Thu, 23 May 2024 11:57:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3CkgdAvAWOub; Thu, 23 May 2024 11:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1716465472; bh=CZsS3pH+jsfAXazQiScb1RJnmsQRxtO2MeMGpP7QhSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AHEaR+8VLh2AUD/73UMfLvOhkoWFwPnKKZAn7ED/OxX4oRee6Ajq7T6ITbQ2xxAZf
	 aBwbPRX0q1x3f6XAWb0VG9E+SXWL2pCDszYRyXTzhJWX0BxSSqIxqGcnqb3aoRrlUO
	 XSh5ntCCWer9JLBLpSTvvHn90cGKyrzSVx8pMtu3o/k4z0od20pciBHhftKLhAUtFb
	 DmZfa4ymad4XO4QgJwOxtPR1A/ZHoZOiEVdhrF83TKZblxG4AwXcLGRCztYAsdh1Bd
	 JjAf8YoRHy8HlGo9F6dJeLTJH2suS77Ge9TdLecdxwPtGJu/Y5CRn/r/tMmiCGK5o7
	 z6J0ZzxHbV2XBRY1hw7jfDkrjPIEyOa3PJ6BFBDgqc3hprhSw/k6zymY1AondSJch0
	 vI23KQpDgveZaefQsIotj8N6tza8ztrToAuMtk2WM5RWOmNARmb11O03sxos0wmcC0
	 s9ux/7PUexi1FnqRzn/Ybvb3SXrPhElFIKCTRG6ytaz8NkqrAQYp/McUwRVc2Q+UJQ
	 FdjeOuK8MsbruS9OZgnIcCl2VFd6KdNK1zeEutVyZ/t92MI+CD8boAlT4Gr+UQhg57
	 6Hxw11OBcREkKt93s+eMGNjkQxbtk0KKZWuZIA+5USbTGpTM/TZze4HnvG/nwgo2Pe
	 1KdbGlRc43GtDeFabG9VlnMY=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7B6A340E0177;
	Thu, 23 May 2024 11:57:40 +0000 (UTC)
Date: Thu, 23 May 2024 13:57:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] x86/boot: Address clang -Wimplicit-fallthrough in
 vsprintf()
Message-ID: <20240523115734.GAZk8vLgzOzD8Tv9pq@fat_crate.local>
References: <20240516-x86-boot-fix-clang-implicit-fallthrough-v1-1-04dc320ca07c@kernel.org>
 <20240517095110.GAZkcojmJQoY_zU-OT@fat_crate.local>
 <20240517151833.GB3660288@thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240517151833.GB3660288@thelio-3990X>

On Fri, May 17, 2024 at 08:18:33AM -0700, Nathan Chancellor wrote:
> There was a patch to make Clang match GCC's behavior a few years ago but
> I think Kees made a good argument that GCC's behavior leaves potential
> bugs on the table, so that was not pursued further.
> 
> https://reviews.llvm.org/D91895#2417170

Really? Maybe I'm being dense but I don't see real bugs there... I see
readability issues. :-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
