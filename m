Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F784C9C
	for <patches@lists.linux.dev>; Fri, 18 Feb 2022 22:58:30 +0000 (UTC)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C15431EC0354;
	Fri, 18 Feb 2022 23:58:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1645225104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=3rAXJLMdbuBpc2KGmn5elYqUz5VKpJdFjvZiaEUj+xM=;
	b=UKljPwa5vrNHvBvsx1bOPm4c9m5FItnZY3KUlPHG7Am43LIDQYG+O5ThKcnLNHbm+a/ZLp
	oTNlWb3x9VRylsFSb1+ECe54P3Qm8h5+hdaROvqZa8CTTStEVqspplyCj71Eb2OluKe4xj
	deh5+/35aYi4WkePaKrFDhNSMKu0+vw=
Date: Fri, 18 Feb 2022 23:58:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jue Wang <juew@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v2] x86/mce: work around an erratum on fast string copy
 instructions.
Message-ID: <YhAkk9/gH2ZKsRZk@zn.tnic>
References: <Yg54nse5qNQO3sbW@zn.tnic>
 <20220218013209.2436006-1-juew@google.com>
 <Yg+2Hc78nfSRmh/j@zn.tnic>
 <CAPcxDJ4c3eGXTB9UPJmZ8dzyCNPW4Lv9s1QSeoCWq_LdNWTrJw@mail.gmail.com>
 <Yg/FyrvLWhZHB/UC@zn.tnic>
 <CAPcxDJ72dMOpbKXxyb__OeMaEyjYSPtsL_ubVsKOuRXefAQ3_w@mail.gmail.com>
 <Yg/UUHuVvd9AOJ94@zn.tnic>
 <CAPcxDJ7=hCz6KRih4OBVv-k8WLcBL4n+VSpeP_zky7Uunq89zg@mail.gmail.com>
 <YhAYQQ6f/XJjOI8A@zn.tnic>
 <0de9b9b5800e4e4a879fddc74b67bfec@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0de9b9b5800e4e4a879fddc74b67bfec@intel.com>

On Fri, Feb 18, 2022 at 10:38:10PM +0000, Luck, Tony wrote:
> > If so, we can sandwich around it with nstrumentation_begin() and _end()...
> 
> I guess so ... this stuff is all Greek to me.

roughly speaking... noinstr simply puts code in a special section
.noinstr.text and objtool checks whether that code calls code outside of
it. And noinstr is off-limits for tracing code.

The begin/end things are for ranges of code and work in a similar way,
see include/linux/instrumentation.h

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
