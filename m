Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F15219E7F9
	for <patches@lists.linux.dev>; Mon,  9 Dec 2024 22:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733782878; cv=none; b=lZ1XbEfjnDcnKUErkp4eOA1oV7iNoKGZ15lSFRGTWWXQpcW7Slb8Pi+zfzBACpF16bLpGDlTzJl+ANsjAtJzS0Q49pB3ubauErXvOgN0QTM50wNSzThGZWc+WqSQKVvvgFsjyxGablEF2eSxz5XthET+cl0p3T00uyYFF7vf/VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733782878; c=relaxed/simple;
	bh=bwzYOAuoJO2yAuRVUE6d9wqLyu40DkAaVYdXryd1xdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u+qmvoK4ILHNMsvyb2pqlwMnlx+/yxLhhYsgSTVDgH12s82YMLkyqvOa9JOHHg5Lp3vg4fjf6oFtTgWIEC0VP6fgE1vUzWzKrsNuIFqh0ItsKt5/m5N2tPyymgKOI9ZO3Muthui1arbBTIHWQKQIVTpcjg5vyOLQ8mTLlJgEv18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=UwuFx0xS; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="UwuFx0xS"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D17CB40E0277;
	Mon,  9 Dec 2024 22:21:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id t1OGWIsr1yrN; Mon,  9 Dec 2024 22:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733782868; bh=21QrC0wOQ48GOvsESM0ZAE9MczwzGypXpmwP1LEdWa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UwuFx0xSduVIpjCgwbkQ561hAu/eoEU4rX1B7ku7yYfGY5RSMn5q/rdH6miIoWhzE
	 Ap5xN+FrXGkYyKur3MR5sAqPVsG+785SuN8mTCPU02R+88WnDNkFPcBRNLFoluhdFV
	 hNY7qRFSntrmOB+z+XWlN4gr6bp7QJqhhDJaaL9j+xR29OptqqSlQzO3nUJXgKNN1A
	 s38BQ8b6LaPu1ahoKuPrTLNMjYB3nXv1dLQ1XqjvkSF+I8d5tY9Qs5nbCPQKAq8pLD
	 C4Zm6pWhcmxDDp+YAcUVIyytzjo+YOKSnyDh/u/5Dzm+X+KchhJy2uFNe9gEeWG4Kp
	 aiua/RzWbnCezhoUpe16C69tnuMHNQlnFyjBlgqCKwa0w+5djTpzc0Zw2MJP74zEK5
	 JOVS+qoGgkTWD2AZFgE1NzXIlIPEn1o0FikqckCOrD150Njj8MdbnyXdehoMUiQ5ZI
	 PWwAZ7gHNV8MRj0rzqcNOZ/2WD1Q3BXzKkJbbN0mUNuNeo4cQ1NJuFzkx+RiGBxzyx
	 gZ5iHnNvspQ/s42QnIZLhEctHxxElwVVy7DEaIeVSdxCmA/CkhTHSv6fc7RSZXp8Va
	 2GcCFavLCrW8OyIqRJIoHKUBnZBNVvknalsjAe0KJuGTyR8FVIS8faIbYsPK8KY9Lv
	 NCs+W8RJDzzuPliYVJzDvVu8=
Received: from zn.tnic (p200300Ea971F9307329c23fFfEA6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9307:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 698A740E019C;
	Mon,  9 Dec 2024 22:20:54 +0000 (UTC)
Date: Mon, 9 Dec 2024 23:20:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org" <x86@kernel.org>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v11 2/8] x86/resctrl: Prepare for per-CTRL_MON group
 mba_MBps control
Message-ID: <20241209222047.GKZ1dtPxIu5_Hxs1fp@fat_crate.local>
References: <20241206163148.83828-1-tony.luck@intel.com>
 <20241206163148.83828-3-tony.luck@intel.com>
 <20241209204519.GAZ1dW3-NjcL4Sewaf@fat_crate.local>
 <SJ1PR11MB6083BA367F2CDFC92D87FDA1FC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB6083BA367F2CDFC92D87FDA1FC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>

On Mon, Dec 09, 2024 at 10:05:43PM +0000, Luck, Tony wrote:
> mba_mbps_default_event isn't architecture specific. The mba_MBps
> feedback code could be implemented on any architecture that supports
> both measurement and control of memory bandwidth.

Yes, and it should be moved to that header then, right?

But not earlier.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
