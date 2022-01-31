Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6A82CA1
	for <patches@lists.linux.dev>; Mon, 31 Jan 2022 19:10:39 +0000 (UTC)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 470921EC0441;
	Mon, 31 Jan 2022 20:10:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1643656233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=nt+7MnJXJXHekJBzGjxIlCp+1Yx50xpN93dgm1OTVAU=;
	b=osc5qZKkjaHLkb8m4DX0sua0HB77CV9ocTi4Ze+q/10rVEkx9OSuCp8pIuyNyYJTyhK5WS
	xme8D2VmOgQzICb1FnyjvcA+Uf/S2slpHWcDjKWK9iOSPM3FLGsCA4L9AthjOQaKCjjS6h
	eBovgR4pNI4w44Gys7JoSntkwlBQgLg=
Date: Mon, 31 Jan 2022 20:10:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Smita Koralahalli Channabasappa <smita.koralahallichannabasappa@amd.com>,
	Wei Huang <wei.huang2@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, patches@lists.linux.dev
Subject: Re: [PATCH v2 0/6] PPIN (Protected Processor Inventory Number)
 updates
Message-ID: <Yfg0JauShcFw1WPc@zn.tnic>
References: <20220107225442.1690165-1-tony.luck@intel.com>
 <20220121174743.1875294-1-tony.luck@intel.com>
 <YffWtTq2y6K8+gHF@zn.tnic>
 <YfgbCFNeNEkypCmC@agluck-desk2.amr.corp.intel.com>
 <YfgoBgwgfoiKkPa9@zn.tnic>
 <YfgvPD6AUPIwQgyf@agluck-desk2.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfgvPD6AUPIwQgyf@agluck-desk2.amr.corp.intel.com>

On Mon, Jan 31, 2022 at 10:49:32AM -0800, Luck, Tony wrote:
> I think any paranoia about having a user readable "serial number"
> should be gone by now. Those wacky web folks found a dozen different ways
> to track your every move on the internet so that adverts for whatever
> you just searched for will follow you for days. It seems highly
> unlikely that browser writers will bother reading ppin and adding it
> to cookies.
> 
> But I didn't want to get distracted by that, so made the file mode 0400.

So by that logic, having it root-only would be only nuisance for FRU or
whatever software accesses it, so why not simply make it readable by
everyone then?

Lemme be clear: I'm being the devil's advocate here on purpose because
I want to make sure we don't walk into some privacy thing we haven't
thought about at the time.

So I guess 0400, root:root would be the correct thing to do - admins can
then change permissions later or so. Rather than making it readable by
everyone by default and leaving it to people to tighten it after boot.

Hmmm.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
