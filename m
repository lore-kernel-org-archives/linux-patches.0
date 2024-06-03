Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58D312F373
	for <patches@lists.linux.dev>; Mon,  3 Jun 2024 18:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717439110; cv=none; b=p3AEaV0s+uBDmMXR0AH4BaUT87BekhdK2JHZtRNsNLTKSgyRcczQ5MX/OSFSbUQPc9d4BJQyIz8tBjgZoyEE6apxrBdxehbd2vqreZq1Fk8l0wkm2vLAJtZ1xCFvGkzinJOzYYv5CssFX0WMfN1ke84RxLh37J81Rb4tvznv+w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717439110; c=relaxed/simple;
	bh=J4i4nzVP6ByO8GiNsx37/x+9O99dx2cNcPJdboNN3Ik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IVRI9k47KAg0t8TF5nhXZ8Xv43ZBhyfdQroAc/0NqPqagclr31Xx1eFenNKQbD9OPjdXi9vA3ekQw8GkRCTyBQ4W/nXVpIt5HgKeZJjLd6p6Gxbb0BO9ug1r23ZJl2JEXpGNtU2AXdoSVa+UYCF9sfGcjFroiyoXZk5OETBxLCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ip5Fq3qj; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ip5Fq3qj"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A1D6540E00C9;
	Mon,  3 Jun 2024 18:25:06 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 036XX_kGuaVT; Mon,  3 Jun 2024 18:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1717439103; bh=nrDJ8q1CYtcH12efiesq/geD7h4Qs+kx3ITpcO547CA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ip5Fq3qj4924YESplzKtoI9h3pimZRXgqBVL2O0lkiz8r3r9/gRq8f8HRVKQGJTXO
	 AXpqn1EFWGxybOa+BPH21GgLupzwysLu06GdBDk8qWoLwwXPM9HCj4h76JK1QixCZX
	 JkaFZLd68AV8T7Cl8pLyyRyYqU/RjfgR9p3yIQZNz8xlT5h45CxzJM/KqxUg0R4VAB
	 Iw73kB4974o40rt8PnM7hi2C+hbeuRLNMGnNBdhiLJLHREzUqr5drdhKG5Jozc62tK
	 FQwSTtv4t5W3fiZ/8cYIIkmjPLkshh+EGkxrOCQMMidOXZoOHDZyZbeyvKDcbeaZ2r
	 DSYShMis5f6dMOdsanqKBLi9jc6Ka8CmiEvKRP7ezZvipXelWgwhCilp1EunmR59sO
	 y5a4ORBto8cmWf15JKJEgqc819kwfNiEEmXxGVrK+97xSK83XhZPZrZ1YynAQEAOPH
	 WXRmMpYdJ6RqU9eOgurskRzf1APKYozUZerDOu9rbNJNNSf8F4IaeEcofK01PmHwiP
	 g7CMlu9S9qGyG8G5eT6K8UAJLIL2hYr99EDi9ZuHzKInpHJZp2G9YgpI17kcbPmtlx
	 e4yuvnqOIczNdTLXVDLKzLMlPWoVFgiKapYqu5yezYcz2Y/XJ6sk5ULzIjh/XrBJEg
	 JBN/c1ofR3RCyE9XKaIxNLT4=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F0EE540E016E;
	Mon,  3 Jun 2024 18:24:48 +0000 (UTC)
Date: Mon, 3 Jun 2024 20:24:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Yu, Fenghua" <fenghua.yu@intel.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH 0/3] Add and use get_cpu_cacheinfo_level()
Message-ID: <20240603182442.GLZl4KasdZWjtZ3jgD@fat_crate.local>
References: <20240531195720.232561-1-tony.luck@intel.com>
 <22569491-1b29-4b3d-8e9c-a5d10b73b6ab@intel.com>
 <20240603170106.GHZl320tVKXp2HyUfb@fat_crate.local>
 <SJ1PR11MB608311F25E4B0B789E54866AFCFF2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB608311F25E4B0B789E54866AFCFF2@SJ1PR11MB6083.namprd11.prod.outlook.com>

On Mon, Jun 03, 2024 at 05:18:37PM +0000, Luck, Tony wrote:
> The two resctrl patches depend on the patch to <linux/cacheinfo.h>
> So you'd need to take that patch through tip x86/cache as well.

Sure, as it is usually done.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
