Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CC92919
	for <patches@lists.linux.dev>; Fri, 18 Feb 2022 17:16:09 +0000 (UTC)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5650F1EC0304;
	Fri, 18 Feb 2022 18:15:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1645204557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=SwNBtYXWJ8xiYRb8tX389TEN1/KTpft305R1guyh4Rg=;
	b=HEND9/BS0oJ+LlJZKY72NIJltRz8k1VKVsnwXtG8WtQwT3M+tPyNBD+n0D2FIl6MOFucH8
	lCqIHoXJuQoRZSDukk2xSsnoWFOtWMVwQDeCDbmLAZy/APHak5P6PN3LisZ8Qw2JPj+3xu
	BzIEgPNmQUQSZTjoLmt4OvG8iuyjNxw=
Date: Fri, 18 Feb 2022 18:16:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jue Wang <juew@google.com>
Cc: Tony Luck <tony.luck@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2] x86/mce: work around an erratum on fast string copy
 instructions.
Message-ID: <Yg/UUHuVvd9AOJ94@zn.tnic>
References: <Yg54nse5qNQO3sbW@zn.tnic>
 <20220218013209.2436006-1-juew@google.com>
 <Yg+2Hc78nfSRmh/j@zn.tnic>
 <CAPcxDJ4c3eGXTB9UPJmZ8dzyCNPW4Lv9s1QSeoCWq_LdNWTrJw@mail.gmail.com>
 <Yg/FyrvLWhZHB/UC@zn.tnic>
 <CAPcxDJ72dMOpbKXxyb__OeMaEyjYSPtsL_ubVsKOuRXefAQ3_w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcxDJ72dMOpbKXxyb__OeMaEyjYSPtsL_ubVsKOuRXefAQ3_w@mail.gmail.com>

On Fri, Feb 18, 2022 at 08:21:36AM -0800, Jue Wang wrote:
> My concern was that here returns 0 instead the value read from the msr.

You'd walk into that code only if you're doing MCE injections. In that
case, it won't read or write MSR_IA32_MISC_ENABLE because the injection
code writes into the injection mce struct only.

So it won't disable fast strings when you manage to inject the exact
error type which triggers this erratum.

I think that's actually a good thing - you don't want to disable fast
strings just because you injected a particular MCE type.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
