Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429424C94
	for <patches@lists.linux.dev>; Fri, 18 Feb 2022 22:05:53 +0000 (UTC)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3A8531EC0354;
	Fri, 18 Feb 2022 23:05:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1645221947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=CWJC1P/sLyxUIsCvaeYtW1Utw5v9i8wbcHpx0w8Ba4Q=;
	b=Ger7/x/3RcukDDgSp5SvJnvz/z0/rXk/4iVqIUr0NXZaXDqHLmgvKLYtV3llIYoQEX8EfL
	WEOYQ0V3ZloaqYZwYkrenwbviuYSSXjZCYf/T8nsKuyjoF4tE/PWtGDjT6riZrLnEjzyco
	SI0JlKdNts7mXcmL64RswnyMzwHkfuA=
Date: Fri, 18 Feb 2022 23:05:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jue Wang <juew@google.com>
Cc: Tony Luck <tony.luck@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2] x86/mce: work around an erratum on fast string copy
 instructions.
Message-ID: <YhAYQQ6f/XJjOI8A@zn.tnic>
References: <Yg54nse5qNQO3sbW@zn.tnic>
 <20220218013209.2436006-1-juew@google.com>
 <Yg+2Hc78nfSRmh/j@zn.tnic>
 <CAPcxDJ4c3eGXTB9UPJmZ8dzyCNPW4Lv9s1QSeoCWq_LdNWTrJw@mail.gmail.com>
 <Yg/FyrvLWhZHB/UC@zn.tnic>
 <CAPcxDJ72dMOpbKXxyb__OeMaEyjYSPtsL_ubVsKOuRXefAQ3_w@mail.gmail.com>
 <Yg/UUHuVvd9AOJ94@zn.tnic>
 <CAPcxDJ7=hCz6KRih4OBVv-k8WLcBL4n+VSpeP_zky7Uunq89zg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcxDJ7=hCz6KRih4OBVv-k8WLcBL4n+VSpeP_zky7Uunq89zg@mail.gmail.com>

Hmm,

do we really need that printk in there?

If so, we can sandwich around it with nstrumentation_begin() and _end()...

20-11-56-randconfig-x86_64-23931-clang.log:1:vmlinux.o: warning: objtool: quirk_skylake_repmov()+0x9a: call to _printk() leaves .noinstr.text section
20-11-56-randconfig-x86_64-23931.log:1:vmlinux.o: warning: objtool: quirk_skylake_repmov()+0xab: call to _printk() leaves .noinstr.text section
20-31-21-randconfig-x86_64-24082-clang.log:2:vmlinux.o: warning: objtool: quirk_skylake_repmov()+0x7d: call to _printk() leaves .noinstr.text section
20-31-21-randconfig-x86_64-24082.log:1:vmlinux.o: warning: objtool: quirk_skylake_repmov()+0x87: call to _printk() leaves .noinstr.text section
20-33-22-randconfig-x86_64-11836-clang.log:2:vmlinux.o: warning: objtool: quirk_skylake_repmov()+0x9a: call to _printk() leaves .noinstr.text section
...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
