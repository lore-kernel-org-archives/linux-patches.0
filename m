Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EA73C05
	for <patches@lists.linux.dev>; Tue, 28 Jun 2022 16:00:06 +0000 (UTC)
Received: from zn.tnic (p200300ea97156a99329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9715:6a99:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 775EA1EC018C;
	Tue, 28 Jun 2022 17:59:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1656431994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=BrUtUlmZIekyNsj7MCySV2fHm1RFiOXl4lfKJ2ufHxo=;
	b=k372JxwoJjO9Djfi1xWfGmz0/Kc/GnqsOQWn0+ieBdyMkAupyeshYY98S08j8Xhz82DPgV
	aJBUvI50RBLGMviKzHW1lyUmQNWrrR265R2eea7sjaMGQemimIFjy0M8PEOgEeE4C/1hoq
	A55seH/qk6Vz/0f6GsPNwFFAj8H7AJI=
Date: Tue, 28 Jun 2022 17:59:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Yazen Ghannam <yazen.ghannam@amd.com>
Subject: Re: [PATCH] RAS/CEC: Reduce default threshold to offline a page to
 "2"
Message-ID: <Yrsleko0MnGtwaaR@zn.tnic>
References: <20220607212015.175591-1-tony.luck@intel.com>
 <YrnBWjkX82OhXAtL@zn.tnic>
 <7da92773f7084c57814f7ef4d033bc53@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7da92773f7084c57814f7ef4d033bc53@intel.com>

On Mon, Jun 27, 2022 at 05:27:57PM +0000, Luck, Tony wrote:
> Existing default is 1023 ... which is not a good choice for anyone (except
> perhaps ostriches that want to bury their heads in the sand an ignore marginal
> DIMMs for as long as possible).

Why isn't that a good choice?

I'm sure there are error rates where this fits just fine.

> So changing the threshold to "2" would be an improvement in at least
> being right for one vendor, instead of wrong for all.

So I'm pretty sure that is not needed on AMD at all.

> Linux already had a hook in the GHES code to take an error record from
> the platform and offline a page. So this "smart" code could be done
> by BIOS or BMC just providing the resulting list of pages that should
> be taken offline to Linux.

So my worry is some firmware agent interfering with our recovery
strategy. And reportedly, there are people who don't like the firmware
recovery at all and prefer it all is done in the OS.

Which then makes it a problem of how to synchronize with the firmware
about who does what in RAS. And we don't have any API here...

Anyway, this is just a worry I have from watching where it all goes
to.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
