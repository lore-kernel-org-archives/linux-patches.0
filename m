Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E097C28E2
	for <patches@lists.linux.dev>; Fri, 18 Feb 2022 16:14:05 +0000 (UTC)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7F2E21EC01FC;
	Fri, 18 Feb 2022 17:13:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1645200839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=7gXNi5HTe8UERuhg/odXJCtnt+1lAhAWiuip8GObiLA=;
	b=gNpyF+ELnVweX+WqHTBHsiOTlGuZnB1D8F/iMq7IY6wBZmyU0DgeE+le/cmrjroX5JwV4h
	mB0/1enDZpwTG91lkFwKGeVMEuJXKQp/AUPD53uVKuUDnVBRe1YRopY99zvRTt/a0W1CCV
	Vt2XteGzVQcFVGxFJ+WH63ur0HUzwZU=
Date: Fri, 18 Feb 2022 17:14:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jue Wang <juew@google.com>
Cc: Tony Luck <tony.luck@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2] x86/mce: work around an erratum on fast string copy
 instructions.
Message-ID: <Yg/FyrvLWhZHB/UC@zn.tnic>
References: <Yg54nse5qNQO3sbW@zn.tnic>
 <20220218013209.2436006-1-juew@google.com>
 <Yg+2Hc78nfSRmh/j@zn.tnic>
 <CAPcxDJ4c3eGXTB9UPJmZ8dzyCNPW4Lv9s1QSeoCWq_LdNWTrJw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcxDJ4c3eGXTB9UPJmZ8dzyCNPW4Lv9s1QSeoCWq_LdNWTrJw@mail.gmail.com>

On Fri, Feb 18, 2022 at 08:03:24AM -0800, Jue Wang wrote:
> Since MSR_IA32_MISC_ENABLE is not a MCA register, I wonder if we want
> to mix its read/write with the injected MCE code.
>
> I was a bit concerned about potential race with mce-inject and the
> read/write to MSR_IA32_MISC_ENABLE.

It won't inject anything:

                offset = msr_to_offset(msr);
                if (offset < 0)
                        ret = 0;


Besides, you need to use those routines due to EX_TYPE_{RD,WR}MSR_IN_MCE

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
