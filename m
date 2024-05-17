Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F6779EA
	for <patches@lists.linux.dev>; Fri, 17 May 2024 14:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715957021; cv=none; b=OarohaEV0JX7DW3CEthTllP7QmJZVJNtcXOt1bKIEBXG67DkGHdTNZDUbiglVgKBeFjHYumQyy761pEsmsj9j0+a1d46mZIJQ3nNUa6iyQTW3R0LpoDADj22IIRM96Ytq9lLQRpbgZhumJBaQKVpS+BEQLjcZoTnTZGC2xmMVUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715957021; c=relaxed/simple;
	bh=5RHEgT4TRXWuR2TCtYoK0E9wYhkS7QE0koMrQ034yfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ead96tJmP5L+84Om8rDM/M6Xhfig6MoeoB3WFa81LSYJgqedyASekFj6WJJQ6a1BrOpVmatILnPVPxAG5AmbeW/kVbEmSb5fSI/Ut5dCCZff+noV8QszM3xU3dNxKWZLfw3Agze0R5PknsoqpoTGGeUt4KsLwqdmY7g7Vpa0L9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=fy08KIsZ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="fy08KIsZ"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 56D5E40E0177;
	Fri, 17 May 2024 14:43:37 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id mRYkkgVPbLtB; Fri, 17 May 2024 14:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1715957014; bh=nNhARHRzM+VvAMzzt6iIDXpl51Q18SFqa8WDQFl7zJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fy08KIsZosFStvfj1WTdLhGI7NKVAOsUsZVJleADawRD0LG/LghLnENAaELOxarqK
	 L7kmlcDUAads8HJPvs60uYKYBoRwgNc6OG/sewA+e7lwTqtxr0L/l0m/IzQHzT12vx
	 ZyGAMSRRCAI2qbOoVSVpxW7IgGkWkolJfpW5REwAqy4lgOA7svdDgov9pBLKKGuAUX
	 7XYCJQTPTkgrqK5LcPKY21B9h9Z3v6wgICYRvHa3mIXoXkZNt3N6QVP118KTN0gMq5
	 9Wt7iqdM7YzaHL7wVkiiqU6F1AGf3N3xbK9qO8dGif8RSiiQgoj30ZvpZm9qxn5dlz
	 EWvVhg58gu3WkZMxpCpW2YSu7BXAuP2Qev00yuCsmlMLQ7szyOAiWzOeONJkQRFFqF
	 0CQ3aVhdO9ERnLuSMyB/H09CwPOl8eMrJvlFh62EFEy/ytKYQPRiA5CcX1m34xWU0i
	 u8X6wWCGQ48ff21Fv9ws0kQHPtWVkIorWwHng35o5tAch/mymTCvyPGjf9DyQo88mQ
	 uS5syOLH3m3aiKgQl6pm60x5WApdInOfqc+akuEURzLaa8tiqz1hjW454z7jRQJLtZ
	 +ApmScmoOj3yrAxbwidikrjYu63AT1u3i6IH/Le+2ef6qxVUTnL3dUrtnEp0xc/lIA
	 XXmgPSOy574w7FWZLz4Hhu6g=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DF2B040E016A;
	Fri, 17 May 2024 14:43:17 +0000 (UTC)
Date: Fri, 17 May 2024 16:43:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Message-ID: <20240517144312.GBZkdtAOuJZCvxhFbJ@fat_crate.local>
References: <20240516162925.79245-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240516162925.79245-1-tony.luck@intel.com>

On Thu, May 16, 2024 at 09:29:25AM -0700, Tony Luck wrote:
> -#define X86_VENDOR_INTEL	0
>  #define X86_VENDOR_CYRIX	1
>  #define X86_VENDOR_AMD		2
>  #define X86_VENDOR_UMC		3
> +#define X86_VENDOR_INTEL	4
>  #define X86_VENDOR_CENTAUR	5
>  #define X86_VENDOR_TRANSMETA	7
>  #define X86_VENDOR_NSC		8
> -- 

From my last review:

> But the Intel vendor has been 0 for what, 30 years?

> Are you sure no other code in the tree relies on that? Audited?

But nope, apparently that's too much to ask. :-(

modinfo ./arch/x86/events/intel/intel-uncore.ko
filename:       ./arch/x86/events/intel/intel-uncore.ko
license:        GPL
srcversion:     ECE38449B18DD83223B93FD
alias:          cpu:type:x86,ven0000fam0006mod00B6:feature:*
alias:          cpu:type:x86,ven0000fam0006mod00AF:feature:*
alias:          cpu:type:x86,ven0000fam0006mod00BE:feature:*
			     ^^^^^^^^^

Would everything still work if it said "ven0004" now?

So tglx and I just did some poking and we think the best solution would
be to add a __u16 flags field to struct x86_cpu_id right...

struct x86_cpu_id {
        __u16                      vendor;               /*     0     2 */
        __u16                      family;               /*     2     2 */
        __u16                      model;                /*     4     2 */
        __u16                      steppings;            /*     6     2 */
        __u16                      feature;              /*     8     2 */

        /* XXX 6 bytes hole, try to pack */

<--- HERE

        kernel_ulong_t             driver_data;          /*    16     8 */

        /* size: 24, cachelines: 1, members: 6 */
        /* sum members: 18, holes: 1, sum holes: 6 */
        /* last cacheline: 24 bytes */
};

and the 32-bit version has the same hole:

struct x86_cpu_id {
        __u16                      vendor;               /*     0     2 */
        __u16                      family;               /*     2     2 */
        __u16                      model;                /*     4     2 */
        __u16                      steppings;            /*     6     2 */
        __u16                      feature;              /*     8     2 */

        /* XXX 2 bytes hole, try to pack */

<--- HERE

        kernel_ulong_t             driver_data;          /*    12     4 */

        /* size: 16, cachelines: 1, members: 6 */
        /* sum members: 14, holes: 1, sum holes: 2 */
        /* last cacheline: 16 bytes */
};

And then do:

struct x86_cpu_id {
        __u16 vendor;
        __u16 family;
        __u16 model;
        __u16 steppings;
        __u16 feature;  /* bit index */
	__u16 flags;
        kernel_ulong_t driver_data;
};

#define X86_CPU_ID_FLAG_VENDOR_VALID		BIT(0)

and then have the macros in arch/x86/include/asm/cpu_device_id.h set
that valid flag and then have x86_match_cpu() check it.

Then you don't risk a userspace breakage and that x86_match_cpu() crap
thing is fixed.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
