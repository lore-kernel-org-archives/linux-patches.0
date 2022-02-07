Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B152C2F25
	for <patches@lists.linux.dev>; Mon,  7 Feb 2022 21:20:24 +0000 (UTC)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E5A851EC0354;
	Mon,  7 Feb 2022 22:20:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1644268819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=CYC/XprXxlLjtCSDTCZqFLi9fh8jP1dSac6rxXbSPk4=;
	b=fU1lWmvzCg69qwsNYNKlDaDvwmjKJUgL9a/luch7eyALhUviHyTgfvMsAWaXa1U4Pqp/CC
	l7qB4AEbN8UWRoZI9+AL0RMmesnkE7/zwz06nPtHnHsuz9vHcuThbk0cv3VqpbFImrs6gg
	yYm1ZzVk6JP4jggO9RJTXbdO6SvquIo=
Date: Mon, 7 Feb 2022 22:20:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jue Wang <juew@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [RFC] x86/mce: Add workaround for SKX/CLX/CPX spurious machine
 checks
Message-ID: <YgGNDenGMCE5ixXw@zn.tnic>
References: <20220207043640.2829295-1-juew@google.com>
 <YgFqiJOU5tZsHbY6@zn.tnic>
 <YgFyBRIOIquMI2ng@agluck-desk2.amr.corp.intel.com>
 <YgGAv/aCVG+RDADI@zn.tnic>
 <be53997f26704089b941d33d9bf47bc6@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <be53997f26704089b941d33d9bf47bc6@intel.com>

On Mon, Feb 07, 2022 at 09:07:05PM +0000, Luck, Tony wrote:
> Yes. That would work. It's an extra MSR read instead of a memory read.
> But this isn't a performance path.

Exactly.

> The erratum has made its way through to the public specification
> update yet :-(

You mean "has not"?

In any case, I guess you could say something like:

	pr_err_once("Erratum #XXX detected, disabling fast string copy instructions.\n");

or so and people can search with the erratum number later where the doc
will explain it in more detail.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
