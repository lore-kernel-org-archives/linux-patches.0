Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E691B4240
	for <patches@lists.linux.dev>; Mon,  9 Dec 2024 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767086; cv=none; b=IoX9bHCLCiRYiXE+XiUHSlf9zuB0taNwNm3qAtEyK5vNynXoKdaoYGqtkk4++1PbAxLm3C767VfAhFiZhilt73ZHbtcNl/B6oQGJyHWV7+RYn+nwaTAN7txgE50lCq2QviVZkOo7wwGvEUtw3nWX1hyrOiE3ivO8bFP3Fkw1K/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767086; c=relaxed/simple;
	bh=yi0162Z72PaRcnO/geVNgvCA57dTZgtjgcyeH4xDkk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rcoBKukJcaEmiF7G9xxZaGXpZobDBCoBDQUs1EXuTTE+/jzuEFBxe5DuZP47utTDKjaP/r2bmVctfk3FOu/hyRrtnIoGt2Ll7/NP2A/x/Exax4l+N59uBQAnWlCO/pbPqRntsLaN9PvIhLttIQWk3oNntEis2/joMzi7nz/eSDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=F458GKBS; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="F458GKBS"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7A9EF40E019C;
	Mon,  9 Dec 2024 17:58:02 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Ggtm8W8l_t3T; Mon,  9 Dec 2024 17:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733767078; bh=bHWnT3ehCDePxHIVBORz0IXUF1hibjIw6+1/uXNKznI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F458GKBStDmoFvyd1d3L8hbrx5sII79xshlegc5+K/Em7GfYvbhIbxwJq5A5coaRk
	 Q520gjn7mJrJXO4D0aNxnhhnXzG1lKHZICYUGY4qfwz89pmhIfSbz0FFevRJZSzyaF
	 4ft0lTlA01w3aQEispahvYl3IQqtpZWiu1lLOPLd9nQHD+L40oN8ZGxT3+WWtFACUj
	 K6n45ey5HYhcYiZTM0LQre7ebwuSRNSV4IAepHIOxu725GWZcHFN0xQnbvIAYr7qoJ
	 a0LsTl/+MfmlrrsUJa3JSSTyttZOugT4gG0TRAq5ZHa1xHUuEsBp5gAiqkt9bHec+3
	 gPAzsXur9X9NGGjtnTA/D8Md5FPuxYhubiCQZoDBbCNESg5cod0StDBD4DCIoFlZG9
	 RRS0x1WQTgZaSIGBWFc8qRiUgZ8maBlTycja18RR0EvU+KQt//GNkO51+DHHJDbBIe
	 RKZs/dPUyV0zKpCKEMoqpPUsTENi2jvJc1GV/TP2dwVHh8uN03OitlhOdtQIDJgbCz
	 SZVbHvAA4KyIzbQXDJL/IxA8qwmuYRPGgtuYmoSict9rMeG24DyBUkJLOxjr4/cgNu
	 nlVdLdCsIpA/XC/Eg14ctRWq9H7GNE2aVSxj30B13W3+F/1YsaumJ5j3FZS89IEZNR
	 2Xg4iUF0ZLhPjf88g+26vVW0=
Received: from zn.tnic (p200300ea971F9307329c23FFfEA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9307:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id ACF1440E015E;
	Mon,  9 Dec 2024 17:57:44 +0000 (UTC)
Date: Mon, 9 Dec 2024 18:57:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Yu, Fenghua" <fenghua.yu@intel.com>,
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
Subject: Re: [PATCH v11 0/8] x86/resctrl: mba_MBps enhancement
Message-ID: <20241209175739.GIZ1cvkycetfLpEsgE@fat_crate.local>
References: <20241206163148.83828-1-tony.luck@intel.com>
 <7e7c01c5-f64f-42c3-9364-ddcfd01b25c1@intel.com>
 <20241209172859.GHZ1co28T-rRiQtIMp@fat_crate.local>
 <SJ1PR11MB60834A5C5D99F3BE9F2CF0DDFC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB60834A5C5D99F3BE9F2CF0DDFC3C2@SJ1PR11MB6083.namprd11.prod.outlook.com>

On Mon, Dec 09, 2024 at 05:53:12PM +0000, Luck, Tony wrote:
> v6.13-rc1 may give a lockdep splat when mounting /sys/fs/resctrl
> (known CONFIG options to trigger this are:
> 
> 	PROVE_LOCKING && SELINUX && (EXT4 || BTRFS)
> 
> but there may be others).
> 
> These resctrl patches are not directly dependent on the fixes that
> went into -rc2:
> 
>    22465bbac53c blk-mq: move cpuhp callback registering out of q->sysfs_lock
>    4bf485a7db5d blk-mq: register cpuhp callback after hctx is added to xarray table
> 
> they work ok on top of -rc1  (as long as you ignore the lockdep splat).

Thanks for the details.

> I see you already have one patch in TIP x86/cache on top of v6.13-rc1
> 
> Your choice whether to rebase that to -rc2 and then apply my series. It
> might make testing smoother.

Yah, I can rebase. Not worth the hassle of dealing with bogus reports.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
