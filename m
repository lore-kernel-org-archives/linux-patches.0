Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22AF29CA
	for <patches@lists.linux.dev>; Thu, 20 Jan 2022 22:48:21 +0000 (UTC)
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6D6F11EC04DB;
	Thu, 20 Jan 2022 23:48:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1642718895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=RF5c4TYC1hPw++nx52jVFiblIAdK9umcAQMhWne90Pg=;
	b=ERJu9R0fw7zz8m9s0R7Kb8OOMQvZfowSMLmHwr3QpgkP9AQwL34qTMEy7wJr3uOCUWU0hn
	PRjjU5FkuybTrakRQ4O0URGjEB+fuhX8sZFUraj1rkTAibWYQNgE698Ga+fOrIhK7bqhmO
	nDDmXXdhknVnVLOq65Mx7g8saVLuj04=
Date: Thu, 20 Jan 2022 23:48:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Smita Koralahalli Channabasappa <smita.koralahallichannabasappa@amd.com>,
	Wei Huang <wei.huang2@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, patches@lists.linux.dev
Subject: Re: [PATCH 5/5] x86/sysfs: Add PPIN in sysfs under cpu topology
Message-ID: <YenmqFQTOfoS+SfF@zn.tnic>
References: <20220107225442.1690165-1-tony.luck@intel.com>
 <20220107225442.1690165-6-tony.luck@intel.com>
 <YellN/3VCasDI3OD@zn.tnic>
 <Yemjj26elXuOcegg@agluck-desk2.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yemjj26elXuOcegg@agluck-desk2.amr.corp.intel.com>

On Thu, Jan 20, 2022 at 10:01:51AM -0800, Luck, Tony wrote:
> It "looks" unused, But thanks to the obscurity of CPP macros using ## to
> concatenate tokens it is needed.

Ofcourse it is.

It crossed my mind for a second that, hey, that is *probably* used by
some macro magic there... oh well.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
