Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4E6142E82
	for <patches@lists.linux.dev>; Fri, 17 May 2024 17:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715968433; cv=none; b=uTjl2GD1qqyF4wztFpyo0YXH7W2DK9pa3DnsuC5wE4RgoIj3Lhxi5lIL9A1sX/mqeehChOdpMs7rvNtdiZvNq8Ji+OxsnkQyoXyxIrY9oghG9pACevD2axPreHbQ7nTuys80khf4e5IqMs10mZjV7qpMShliYO+1EyxRQTDZqKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715968433; c=relaxed/simple;
	bh=Pj3XqwCP/tWyNk1MTxRUoT5OZi3EKwTxbKbZWc4jLRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AAqIan+oBblgczBmTukxe50ifFd7N/IA7U/K619inAHQdknx9QViaNPNd7zDNWzOwC4vvIl5Eea5JPamfykh1He3JGkpIvynOgA0fsNPiz4F1IEPocavj1ASzL+1XTRWgWu/qSsCcfiWbmnmGFjtLpyCVl5tvmjlQ469/P7Szk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=BiJJFotS; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="BiJJFotS"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3E8BE40E01E8;
	Fri, 17 May 2024 17:53:49 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id H0VWSqlu61N5; Fri, 17 May 2024 17:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1715968426; bh=BklJ0Xy1NwJgkxAFnP/a6AerOzCrYYikftsLx1c6YRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BiJJFotSKGK3qH/tIdBxj01UL2ZC1FN17eQ4IXKlyPgIpFCj4/A1ZQZgXqMn+U5in
	 LX+pS60VjFg9CtSkLIKigDBTZmhgaS6WJvwTN5ChKraij4y1eFsxX5SeISeiRG8/NY
	 Yp0UoNZyuxJUq0tmzGrjBGZkHXWMD9IlegnPvn/kU6/Jioz/mRQBiuZt1an+jsdXky
	 yHop8mXx439mohzl93AX7vlvIZyCMg9AMKmIYOjZfkRYevTUqNN+T1Pf54HwI1MrZf
	 PDyZ2RyQpGzrCM87AyWhVGNYozXgjqeS08GM9ie2tJh8V5DpK65BBvbki1nVnGD3BL
	 nPsgeSbLlgT7dZmKY0WyqVGdmqXGU+2Z60oflzorrmkaAVK+CYAbGVlIy3InOHK4RA
	 zbWhazdc3K6Qd/lx514pee6vsT5iAlsD9JlLKDW7RmhwvYZr0Olv3I8LszpQjMFKKE
	 0S1aIKge9IIzyFuuVqriA4OHcFBdYcV6rrTGKbuEISAwysmAQo55jdQbDRlqcAgMSK
	 jWKb97u4h/IQLRQN7QwCkbCL43S/6NP2+4MJFaXjj9F5DckwlopEYeVJDG2ovY8+OR
	 4z6r+s0m1ICB9qomj2EV+4ZyjBxj2WatSMTpuVMaXcnaKjZCY90q7XYJ4VhOy/wHVo
	 J2cFSWgsGEMBuGQGtVMuMEDM=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E87D340E0244;
	Fri, 17 May 2024 17:53:29 +0000 (UTC)
Date: Fri, 17 May 2024 19:53:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v3] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Message-ID: <20240517175324.GGZkeZlNgjGxwfumLu@fat_crate.local>
References: <20240517172134.7255-1-tony.luck@intel.com>
 <20240517173811.GFZkeWAzKjYtEMwe1e@fat_crate.local>
 <SJ1PR11MB608386716D1DA533791DE7A2FCEE2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB608386716D1DA533791DE7A2FCEE2@SJ1PR11MB6083.namprd11.prod.outlook.com>

On Fri, May 17, 2024 at 05:43:10PM +0000, Luck, Tony wrote:
> What if the bit in flags was named " X86_CPU_ID_FLAG_ENTRY_VALID"
> 
> Then the loop in x86_match_cpu() could just be:
> 
> 	for (m = match; m->flags & X86_CPU_ID_FLAG_ENTRY_VALID; m++) {

Yeah, makes sense at a first glance.

This'll keep the terminators "{}" unchanged so that we don't have to
touch all those gazillion places and it'll explicitly state that an
entry is valid or not.

But the devil's in the detail, as always...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
