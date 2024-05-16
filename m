Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C5C2C1B8
	for <patches@lists.linux.dev>; Thu, 16 May 2024 07:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715843898; cv=none; b=kv4bd0mmnpJMJvFiey0cWuHHKoz6VLZyqON2VN02QjmJSAL0sdF3QPePPuABnm/WZpV1pp48JJUtd3rWWcpceF7366vof1PqRq0H1lMRVjlfFTK9Up2/YC+WJIJ/mCGZdOEvY3ycAxBVTxticgweh2Ti+3Vx3mZXttU15THHpzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715843898; c=relaxed/simple;
	bh=rgXkxk9Orw9SGwaHV/qdWKAMzOz0en6hFneE/RcKR3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hXled6M59Ek9R9ruCZmD4C11I9SKsSJR8b/n8HkbnGPX8COitmVW7J9PTzRwNDQ1VH3p0I1787skkVapa1cj/tR0ULutV5VkzmPc3NHsIqSU9I8tRFVzT0uQpCa4Ynvdf+HweaOhfT6fZ1wRsF6BH1ldB7vEBILcc3lYvZFRU9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VTrERbxU; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VTrERbxU"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 31D5140E01A3;
	Thu, 16 May 2024 07:18:12 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Xj4QD_2gjpOz; Thu, 16 May 2024 07:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1715843888; bh=vEDqqJEpXplCnXAGo2TY8kMB/3YopuPJQZuB64A6wAA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VTrERbxUKOlGNBmwhar7AYP4n7jrzbsPFIdBnq5duTW4yw+NIa6cFn4Qsuc/8UNyZ
	 aQKSwMurKh6KiQx1BzCTHWzXm0ejQGRy6DjDAAvCgPZGAw1PT+XYSIkx+QauOU4tf2
	 YcMlP2Je92cSHuUMxyau9hVBsmDKN2abXUNXFKd3j2fsfJTpHSCaRSsWt04WjXWmEF
	 6w5BeXwEZeNcOmq97WonIxCBgDB8RtZ6D9j+VuHkiB+AyQQqdW1JZtFSLYo8P0UMy2
	 SfZPqRRWgxJ5BZagkG0dfs6bKnEMl9cSoJehurryeLLP3/8rq8ZVeI1OhR7LaFGRPi
	 v0X/iWjt4tTStpclO8371LQSWkKLlSJJRKmLWvR7iFCzLoClLy0gfV0kbJP5CO7iQ0
	 OdIXt8+9DmI2fBcmg5bVFLMKDI/QpoCN+Fr9qhTPbkJRnzYTrcnWxH00iGAkZ1Xmdw
	 nHyJLOhaldATmaRmwvqyp1zyrIP7efD9qqNT3DpWSqQWAx8YmqHNHKRQPQ8hbg9bQB
	 eF4olmhGN8wEk7i060jtCgqQ0UCcFO6K1POlF5n7sfXLua3pdCULPLVIBHWyQ8BGl/
	 Tr2TBKvZ94VNPl95cyJ5tMr8w+IgIj4B9Gctyz0+M653e1X2png1fJfbkJ1PbzeU0f
	 aWLrSFAOfqe93ZZM80wzcW/k=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9639940E01E8;
	Thu, 16 May 2024 07:18:04 +0000 (UTC)
Date: Thu, 16 May 2024 09:17:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Message-ID: <20240516071759.GAZkWzJ7t83HW6BECA@fat_crate.local>
References: <20240515214357.73798-1-tony.luck@intel.com>
 <20240515220058.GEZkUwmtNazjQaLdDn@fat_crate.local>
 <SJ1PR11MB6083D455CE90AFC3251703B8FCEC2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB6083D455CE90AFC3251703B8FCEC2@SJ1PR11MB6083.namprd11.prod.outlook.com>

On Wed, May 15, 2024 at 10:07:56PM +0000, Luck, Tony wrote:
> >> There's a wildcard match in arch/x86/kernel/smpboot.c that wants
> >> to hit on any CPU made by Intel. The match used to work because
> >
> > intel_cod_cpu[] or which one?
> >
> > Please be more specific.
> 
> intel_cod_cpu[] is the only one in arch/x86/kernel/smpboot.c

Sorry Tony, commit messages are not a guessing game but a precise
explanation as to what the problem is. Please try again.

Also, this change looks like "oh, lemme change the Intel vendor number
so that my conditional works".

But the Intel vendor has been 0 for what, 30 years?

Are you sure no other code in the tree relies on that? Audited?

Also, those x86_match_cpu functions with for-loop termination
conditionals checking whether stuff is not 0 - i.e., that:

        for (m = match;
             m->vendor | m->family | m->model | m->steppings | m->feature;
	     ^^^^^^^^^^^
             m++) {

are technically wrong when a vendor 0 is valid.

So this has all worked by chance and you've hit the one case where it
didn't.

Because it's not like we don't have a "invalid vendor" define:

#define X86_VENDOR_UNKNOWN      0xff

So, *actually*, all those terminators at the end of those arrays should
have those invalid values.

And there are a gazillion of those in the tree... :-\

Lovely.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
