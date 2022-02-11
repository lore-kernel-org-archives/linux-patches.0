Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E317E7E
	for <patches@lists.linux.dev>; Fri, 11 Feb 2022 20:18:14 +0000 (UTC)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 852E01EC03E3;
	Fri, 11 Feb 2022 21:17:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1644610679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=Zf1PGgxIHUKkb0cwjBPLhJFLsRuThXVtZ96hUpHXXuM=;
	b=ETMOcl+QFHSpdzRwUlFNBDaFHwiwgHLM4UtUvJhP7TkvhJT3rdGhWHX5xX3zkc9AwYp3HC
	XqsXetrGSuETB+rvYGTzwBpLwoden0kiAx0zVGoUmsA84GDVf0y6x7gXfwJSTbXaEf8xTB
	F/mphTx8FJ13XUEIzDitKNsEYDE6OuE=
Date: Fri, 11 Feb 2022 21:18:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jue Wang <juew@google.com>
Cc: Tony Luck <tony.luck@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] x86/mce: Add workaround for SKX/CLX/CPX spurious machine
 checks
Message-ID: <YgbEeFKdtrY+9d/x@zn.tnic>
References: <CAPcxDJ7nriZEJHF6dMPR7tQ+dGuueyRjw1NC+4CbjxiAT_S+ZA@mail.gmail.com>
 <20220208150945.266978-1-juew@google.com>
 <CAPcxDJ7iHshyZdCp9ngrfFV4j2=HTvXF5naN+E+D_AvcH8n4wg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcxDJ7iHshyZdCp9ngrfFV4j2=HTvXF5naN+E+D_AvcH8n4wg@mail.gmail.com>

On Fri, Feb 11, 2022 at 12:08:46PM -0800, Jue Wang wrote:
> Tony and Borislav,
> 
> Gently ping?

From: Documentation/process/submitting-patches.rst

Don't get discouraged - or impatient
------------------------------------

After you have submitted your change, be patient and wait.  Reviewers are
busy people and may not get to your patch right away.

Once upon a time, patches used to disappear into the void without comment,
but the development process works more smoothly than that now.  You should
receive comments within a week or so; if that does not happen, make sure
that you have sent your patches to the right place.  Wait for a minimum of
one week before resubmitting or pinging reviewers - possibly longer during
busy times like merge windows.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
