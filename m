Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DEC14F9C8
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 08:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719910443; cv=none; b=O/a7S5/BzNvhkByMKli6EEgdBmWyh4pC+F2LR2FXEZmG4JlmZ6IlPG7/7NXWhFPrVi3NuVnGIMHS90aUF4cKn5jHVyVfg3TI7m9u2r+wweWD6/nNZbsOlx+K/qJ7lGn+jrnTcDWwrAgvvLg5ha6uxyNfdxdTyjQavb5fEgajMyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719910443; c=relaxed/simple;
	bh=XNxsRThvAXchIOilo5GBLdnvnAbbgaRWY5XAGGquwr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jA8MEnnPRBPhXN815jk2zXCXBgke0je9n/gTG7eH9o3S1CI/kXYaQ0e3iflhEjgrrodL5jMXhDs9+1jvq5LtpVnbhMTLL/vQq7vNpUaSRmOjOeOc1tuq56q2t7uU34cfjDLQg21t5xgcw+GTcIPoBbO+V99v70nWUWkQ9Z8+NDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ExLbIJlV; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ExLbIJlV"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 800DB40E021B;
	Tue,  2 Jul 2024 08:53:58 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 8MGdSkc_Eq9a; Tue,  2 Jul 2024 08:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1719910435; bh=RNRdA9p4LXYxcZ8gbelEQAm4XKn64IJNQ1dfc77MGiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ExLbIJlVfN6JElCfvZLPFno5HnqAlO2KBwfFEc6wwo3RKln7mroiWiESGUK5SV3uV
	 dKzixas4SRsycc/2FxGdBFkisgf6R8NyZzLTrBVNagCBZVxgZbJNuNmVjjW8PL3gCN
	 MmCk2BrU9yqPT9wjgCkja8HMjgiEKY9H3vFVuY4A8thZhGF4cNohUta6eTlMwXsRUy
	 GwoDPQ71GvLW4nJO/o4rV/h6iarwmyJ/n26AUeaBHbrfcbL2ZtAPJhTcSwkdWeoC9e
	 dr1aE5SkHqClOTNvnb6xpeFpA9N1bmodHABk0oNUgx1x/9aCZaOP5DL0Z5KFVGBROe
	 iPraaKcbiJOfXJOZQEC4kGuDwvaNrCqOQJc+XQ1TErrV+ANqVIyn+9FokZ8R+F7C+8
	 dWos9X1UVrHAq+HoJMidCnBn9S/wH6w5Rw58a7Ga+4o1xCd8dxm1eVLZCttbnTg8sI
	 9oOd+BNU7B+DvmohDI/LreF5O/ixXv+vTUcxEidTyyLk0YS7CRC+laeCFZcnQQy/fb
	 MxNF67K7PJ5X5lilKJxFa5758FHf5wv0dCvwy7gVwLFytgPz2b1MWSGCfIX4nyu4KT
	 WDxU2FVYadJUgtwQ0poLyYs2MsNgVWkUQWWCgw0KXHIGUd+QfKVJXfAlyiap63W3Jl
	 jf9vuvhTDK/I4CC9DqOE9iS0=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1401B40E0185;
	Tue,  2 Jul 2024 08:53:43 +0000 (UTC)
Date: Tue, 2 Jul 2024 10:53:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v23 14/19] x86/resctrl: Handle removing directories in
 Sub-NUMA Cluster (SNC) mode
Message-ID: <20240702085337.GAZoPAEaEBtT18iD3V@fat_crate.local>
References: <20240628215619.76401-1-tony.luck@intel.com>
 <20240628215619.76401-15-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240628215619.76401-15-tony.luck@intel.com>

On Fri, Jun 28, 2024 at 02:56:14PM -0700, Tony Luck wrote:
>  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
> -		sprintf(name, "mon_%s_%02d", r->name, dom_id);
> -		kernfs_remove_by_name(prgrp->mon.mon_data_kn, name);
> +		kn = kernfs_find_and_get(prgrp->mon.mon_data_kn, name);
> +		if (!kn)
> +			continue;
> +		kernfs_put(kn);
> +
> +		if (kn->dir.subdirs <= 1)
> +			kernfs_remove(kn);
> +		else
> +			kernfs_remove_by_name(kn, subname);

This...

>  
> -		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list)
> -			kernfs_remove_by_name(crgrp->mon.mon_data_kn, name);
> +		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list) {
> +			kn = kernfs_find_and_get(crgrp->mon.mon_data_kn, name);
> +			if (!kn)
> +				continue;
> +			kernfs_put(kn);
> +
> +			if (kn->dir.subdirs <= 1)
> +				kernfs_remove(kn);
> +			else
> +				kernfs_remove_by_name(kn, subname);
> +		}

... and this are almost identical hunks.

Why isn't there a helper which gets called here?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
