Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C04366A
	for <patches@lists.linux.dev>; Wed, 16 Feb 2022 18:03:01 +0000 (UTC)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 75C7F1EC0518;
	Wed, 16 Feb 2022 19:02:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1645034575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=jBtlGm8WJFBOdlSzBUlWwC0q4z+PZ1kReU2GS1VtCzg=;
	b=jbE12Yg54ODKlG6g3sf+XPrMSH70l35ZbFTc1OevwaYL0I99jU3mxv888vgnbJJsai/bLf
	/XYD0BnZJ2Ch332IwqA7PoBGo4OLSA3J0xwWvzqs9ZDP7B//X5TGWpwSAzz1VRYruNuEEp
	Wi3EUUglWkMOh4wqFo4hZTm5iVjJg1g=
Date: Wed, 16 Feb 2022 19:02:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jue Wang <juew@google.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] x86/mce: Add workaround for SKX/CLX/CPX spurious machine
 checks
Message-ID: <Yg08Uhg0fZ9xZuP2@zn.tnic>
References: <CAPcxDJ7nriZEJHF6dMPR7tQ+dGuueyRjw1NC+4CbjxiAT_S+ZA@mail.gmail.com>
 <20220208150945.266978-1-juew@google.com>
 <Ygwka++3eipjQzB2@zn.tnic>
 <YgwnqTc8FGG3orcE@agluck-desk3.sc.intel.com>
 <YgzRsfWOmqkNiNI7@zn.tnic>
 <CAPcxDJ4=iknzYbN=b2oQxvJyODkQ_MWEj1wkKEuGwf4HQ3aPZA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcxDJ4=iknzYbN=b2oQxvJyODkQ_MWEj1wkKEuGwf4HQ3aPZA@mail.gmail.com>

On Wed, Feb 16, 2022 at 07:50:24AM -0800, Jue Wang wrote:
> My slight reservation is that this suggests all use cases of "REP;
> MOVS*" must take the _ASM_EXTABLE_ form, which is not possible;
> considering "REP; MOVS*" can be exercised from any user space program.

Well, we could try to decode the instructions around rIP when the #MC
is raised and see what caused the MCE and perhaps pick apart which insn
caused it, is it accessing behind the buffer boundaries, etc.

> If there is a way to get all users of "REP; MOVS*" to use
> copy_mc_enhanced_fast_string, this could work. I am not sure this is
> possible.

Yeah, no, this is for the copy to user direction only.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
