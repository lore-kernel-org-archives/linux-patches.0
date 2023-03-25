Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29A039B
	for <patches@lists.linux.dev>; Sat, 25 Mar 2023 16:43:19 +0000 (UTC)
Received: from zn.tnic (p5de8e687.dip0.t-ipconnect.de [93.232.230.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BF7F41EC018C;
	Sat, 25 Mar 2023 17:43:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1679762591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=Km7Uf9I1amhFm4e5ULmshh8t10f1X4Cdt5efipAaeSM=;
	b=IvhYQ3Y88Quj6oEqAAzps072Kbq3me85kc2MiRdVpj96wo1lGLwF0/U/g7GUvoGA26ivJY
	G6XgDD5UfVYa+o96N/kYg9rVYKZrZEKqGkgChTlM3YXkggtYWJKG0ropKqcvnyrC5/bE45
	V6JsMwBS9J/H6QHVPhTPO55VKnKUpGs=
Date: Sat, 25 Mar 2023 17:43:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] x86/cpu: Add model number for Intel Arrow Lake processor
Message-ID: <20230325164307.GAZB8kmwm6NqA+ROWi@fat_crate.local>
References: <20230324195932.241441-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230324195932.241441-1-tony.luck@intel.com>

On Fri, Mar 24, 2023 at 12:59:32PM -0700, Tony Luck wrote:
> https://www.intel.com/content/www/us/en/newsroom/news/intel-technology-roadmaps-milestones.html

This URL will become stale sooner or later.

> says this will be built on Intel 20A tiles and launch in 2024.

I don't think you need a source - you are a source enough. :-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
