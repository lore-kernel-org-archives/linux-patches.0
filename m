Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60B15F54B;
	Sat,  3 Feb 2024 19:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706989538; cv=none; b=a7hPh1UVufA8gAsFOQLzTW/sY6wlgdhY6PPDzQl+Fc21YTj7HPX+fAvTsB9OWp7hYqULbNBjfqYDtkSM6ENerb3Uug9s8fcecTBDBF5caJHctvgniaBp0na1AFcxbX7rIXHJEut1vNLsRU5eazf+e7oVCWWTXtVNBxulfOHsUME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706989538; c=relaxed/simple;
	bh=OZ8tqHKMSnW/RLCgujHSxVnpe/vJVwNLA9V9eMIlOok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UITIhKIDf1pUhjakNSH/5hv/DfcAe2sNouhs57Hv3c6GXfENW9Oe9kOq/zo1UBjjILRU6rx/jprR/0rrmodLpOiJSRNIeg88Zp3aKWndbkBPs9HPH2hSS3vz+enE8omWOr4EjRkWdEJjPv53ts3wddxKmOeCQ/eEE/JhwirBAgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Nh9kTd7v; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Nh9kTd7v"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D16F940E016C;
	Sat,  3 Feb 2024 19:45:32 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id LL7Mp7vWCURW; Sat,  3 Feb 2024 19:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706989529; bh=vt5PlNONgksbT19ob4ZS3LjM5BOwuQhzw7BUPoTXCes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nh9kTd7vAUqVQnH8xoN0CI7kiALIESBMw3IJaxqVDcffloE5lXkTcXnWvXnta6nEC
	 VxzBRDomI5iMsVOG1uy0n8FivpMqxF9RbClAGxKUejVFJDP4/ji65kmMuRY2mP21jO
	 6JJljwoK9iQM20nYH1wXSlAjZVhzqefg1z8Go29I89rieyXcxVd6lKHBgFknDX91sz
	 UWlJQsE08oWOLDkTsUBosh11YLDPJdpIlQROK+Nwx2hw9W5F5LIkAGxBA9fshiDEvE
	 SKenGeaax8zXm/zD0gLcie6927LDGbtqvtJcyd06WO4cmKQiBhOUd4k5PgyeoULjwt
	 Qi66UzpNZmR0Ed+qj4fA014LIvjtTBkuNdbWNTOamKCAN1zuDJilHhLRCHeixFBBH/
	 bSei+pm2NZt3l+QGzZ3IjM3eAAMYe71zjhM6ud+4bL26UPrfKINlKsaec6UZ6LXV9s
	 NLpHjYw7TVGDzJQZBUKkHpzi+QajERFSlfe3Jx0iocmQ6MBIWLxEsTadQHLDtYISAb
	 ndHusx76kiyGtxYb5Ep/v3eLDCe6uI7tVqwr4kRUBmDb4tB/t1ieLaL7TxvoPqiEuE
	 kL+FVzyTfG6SqxNowGATvc7wtMhQ0MQIOHq5szOBXD57WngBaA2qLQaH44laGaIS2L
	 yZwj2HWo3TZ4yLjBAjPKRhbg=
Received: from zn.tnic (pd953021b.dip0.t-ipconnect.de [217.83.2.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BBD3E40E0081;
	Sat,  3 Feb 2024 19:45:16 +0000 (UTC)
Date: Sat, 3 Feb 2024 20:45:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org,
	kirill.shutemov@linux.intel.com, ndesaulniers@google.com,
	morbo@google.com, justinstitt@google.com,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] x86/coco: Define cc_vendor without
 CONFIG_ARCH_HAS_CC_PLATFORM
Message-ID: <20240203194510.GJZb6Xxh2h-cqqY27f@fat_crate.local>
References: <20240202-provide-cc_vendor-without-arch_has_cc_platform-v1-1-09ad5f2a3099@kernel.org>
 <20240203102925.GFZb4VhT1IwX-XRxTV@fat_crate.local>
 <20240203160806.GA520926@dev-fedora.aadp>
 <20240203190729.GHZb6O8UborcetShlw@fat_crate.local>
 <20240203193552.GA655765@dev-fedora.aadp>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240203193552.GA655765@dev-fedora.aadp>

On Sat, Feb 03, 2024 at 12:35:52PM -0700, Nathan Chancellor wrote:
> Yeah, that seems like a fair plan to me. I was a little concerned about
> a future change that would require backporting to kernels that have
> da86eb961184 (i.e., 6.6) that do not have a9ef277488cf and miss this fix
> but that is a bridge that can be crossed if it ever appears, no point in
> thinking too hard about it at this point.

Yep.

> I can send a v2 on Monday, unless Paolo wants to just add
> 
> Fixes: a9ef277488cf ("x86/kvm: Fix SEV check in sev_map_percpu_data()")
> 
> directly during application. I think the rest of the patch is fine but
> if there are any other changes that should be made, I am more than happy
> do to so.

Nah, LGTM.

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
