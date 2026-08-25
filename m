Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211003B2FD6
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 19:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787685858; cv=none; b=bTW0487CeAhKBlEBzRa++YdaQt+9obMxxQiVLe5GKpNDzUKTyH/unNDoQrOEktED3KuhTS0MjsRoy03UsEFVZ+BpjKIB4+2TevwxDYmgCbaZh+wDNHoaqiBDrjF9vB1GccJVOrUUtQzDlrgw8+WjXTDye77DxxJ3B6etWFWOCrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787685858; c=relaxed/simple;
	bh=vTYjnNdymmsHtqEqqHPDmaAC1BdahywFgQS9kpiFb/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TjpeAI/yBwtr3bmYMbCnb+6CPaWQYdRlpCqcSpwxTucKQU0vzzvoN4gOho5UI2TW/ny0nE5AtyPOr2oriFQoofMlSNvkX1sgY8pLOpcGRV277JwQSh/VB1O93yfE2b6/+QoZ72FHi6ShnJl36tiOB85DiYBdbSx1HktO3tFKE14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=D0yLTos1; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="D0yLTos1"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CF4B240E01EE;
	Tue, 25 Aug 2026 19:24:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id MUY8Iu2PUDPR; Tue, 25 Aug 2026 19:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1787685844; bh=v4KNgTWWgbVEI1w3wqnewXTIvpgMD8/3bfYy9Zmz+hw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D0yLTos1ZGAvXNLrlBEF9v9C6K8L2xQQLEbKAOl76I6wwlWU+XrNoKAcBArqF3Zc6
	 0jUX7jzoRqJlNPLn+3lFBWpyEI21lzN6o70mAjNvXUtQ40NmwtD1Wg8y286c7Ks5dl
	 z7NWb761x+vB8GeXCi/+EBSi+Ut3tImlUemuRxRZQ4ZEhHRTYeRGtsGBS82Z7/Pgfd
	 meZkF7niGLanl9z7BfaD4Wg6ZQr52DJh0IytlGMzUDPHQi1dA1KQ7jKDnFbNIaMrlq
	 yNhTrS0f9d1vBb7K9Zay9QpIB4Jq1grrcy2+UPNxArgn1UDPTiiGWGm5nnhGSAYULd
	 clqwza1E/B2vvLs5YvhIyU0dl9T62HSGSpoioQlSLoP3ORVEBK7Hi73K8Bdk50rQHE
	 p1ettd/zjFTtX1ZgbaqEImX0YVJKcuzctS+7ZqigHzWpe73dNwL1IwQEUQKhOYti9l
	 PK64w9xNdiTRD/cAOpnuIi05GdZjoOcEtuwzY0ZfeNe5Lhggosrx0wt513YTCBY4lU
	 Ra0SU2vsP7aasFyQDU3lAWUoTHtsr0LAisfyW0MHNgGVA5/XP0Nuk81rP1XY/JZyrn
	 j4K3bu+HZhWZklNpVHA8e1BeDYUPV9zIaSHTbCKd0g7tOQbZK2voQY41fT39V/u496
	 b1ER48cvZtTzjvq9yBEzXnbk=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2BA8E40E01DA;
	Tue, 25 Aug 2026 19:23:57 +0000 (UTC)
Date: Tue, 25 Aug 2026 12:23:54 -0700
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hansg@kernel.org>, Breno Leitao <leitao@debian.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH 0/7] Intel platform driver to reset bitfix filters
Message-ID: <20260825192354.GDao3ryqPi25fDHTsX@fat_crate.local>
References: <20260825181526.13203-1-tony.luck@intel.com>
 <20260825182857.GBao3e6Qv_Xg0LCXFM@fat_crate.local>
 <SJ1PR11MB6083BCCECCB6C5037B0B2B62FCAF2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB6083BCCECCB6C5037B0B2B62FCAF2@SJ1PR11MB6083.namprd11.prod.outlook.com>

On Tue, Aug 25, 2026 at 06:55:27PM +0000, Luck, Tony wrote:
> Mostly that not everyone wants to run EDAC drivers.

Just because or is there a particular reason?

Because we could try to address those reasons if they were more concrete and
valid...

> Plausibly. But it is model specific. Needs to know how h/w banks are shared
> between logical CPUs so it can get the time comparisons right when a shared
> bank reports BFF overflow on different CPUs. Intel doesn't have any enumeration
> for bank sharing, and changes things often.
> 
> It's also just for one (not yet released) CPU model today. So, building it into the MCE
> code would be overhead for almost everyone.
>
> But I can move it if you think that is a better place for it.

Well, my angle is: we already have soo much RAS glue in the kernel so adding
a *platform* driver for it is simply unnecessary.

For example, drivers/edac/mce_amd.c is the whole AMD MCE decoding and even
though it is in drivers/edac/, it is not really an EDAC driver. So your BFFs
(wonderful acronym btw :-P) would likely fit there too.

And looking at the code, it looks very familiar to that thing - simply
a notifier callback with a bunch of logic to decode and report the error.

And there's drivers/ras/ too.

And we already have the whole machinery around it so let's move it somewhere
more fitting than in yet another new place pls.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
