Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67262F5B
	for <patches@lists.linux.dev>; Mon, 27 Jun 2022 14:40:37 +0000 (UTC)
Received: from zn.tnic (p200300ea9746579d329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9746:579d:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5A6221EC0324;
	Mon, 27 Jun 2022 16:40:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1656340826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=5Uw0AJzcz+NaVP9+fmQVzmmgxZlLX/u7bhWmR6+QNVg=;
	b=nxhiv/7MWD6J1g1BiymOqQXKB7/6tilsS8SNk+8wU2gCWigCHqKQmasQKoDIWh0WcnXIkH
	xt2cqZGeto8MWLFG1G2PT9wT41ppg7TWMXQCG4rDEwSzI3YFRyVaDFPd5Y2WhBfY4EBuv4
	pwKz876sFyXzxCeUzWaYFvzGT4EJTP8=
Date: Mon, 27 Jun 2022 16:40:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>
Subject: Re: [PATCH] RAS/CEC: Reduce default threshold to offline a page to
 "2"
Message-ID: <YrnBWjkX82OhXAtL@zn.tnic>
References: <20220607212015.175591-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220607212015.175591-1-tony.luck@intel.com>

On Tue, Jun 07, 2022 at 02:20:15PM -0700, Tony Luck wrote:
> A large scale study of memory errors in data centers showed that it is
> best to aggressively take pages with corrected errors offline. This is
> the best strategy of using corrected errors as a predictor of future
> uncorrected errors.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> ---
> Here's the link to the study. I thought of putting into the code
> comment, or the commit comment. But these links are sometimes changed
> as website is re-organised, making the link stale.
> 
> https://www.intel.com/content/dam/www/public/us/en/documents/intel-and-samsung-mrt-improving-memory-reliability-at-data-centers.pdf
> 
> The paper has two recommendations:
> 1) Change threshold to "2".

Kinda unconditional that... we haven't talked to other vendors even.

> 2) Do very smart platform dependent things

If you mean AI, that probably won't happen in the kernel.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
