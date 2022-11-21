Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A3379C3
	for <patches@lists.linux.dev>; Mon, 21 Nov 2022 19:44:42 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F2C97220E5;
	Mon, 21 Nov 2022 19:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1669059880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HK8SHrswSKDS6/O+Mgs+PmBluOOCcSpzcSHcaJVrEzE=;
	b=sGBGsUvnd5vxckcevJ68UxFxz1PoSqb+HhkiZGIEIDv5PR4YlOP0Zat6gVJdddKiT400ks
	wisOjKNDBHCc4+joBpswgAQDQXnYetJ9aUaT7Wg9UcqlRbNDkiHk7BWVRvebwJDG2sibT+
	RwgzKgvvOsvdRGQJ/P8vcVMnR/oOku0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1669059880;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HK8SHrswSKDS6/O+Mgs+PmBluOOCcSpzcSHcaJVrEzE=;
	b=RHu+rInak5/4nHVa3RdOHmAbZaaxIEagdc61JXpBnzjGyWi4Zyr3p6vQ7MuqiWEOoxE/qR
	Nt9yrf83lq8MtuDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6022D1376E;
	Mon, 21 Nov 2022 19:44:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id sE6GFifVe2O+QwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Mon, 21 Nov 2022 19:44:39 +0000
Message-ID: <53c6d988-7147-2233-6904-f881e7c067b6@suse.cz>
Date: Mon, 21 Nov 2022 20:42:53 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 12/12] mm, slob: rename CONFIG_SLOB to
 CONFIG_SLOB_DEPRECATED
Content-Language: en-US
To: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, patches@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, Aaro Koskinen <aaro.koskinen@iki.fi>,
 Janusz Krzysztofik <jmkrzyszt@gmail.com>, Tony Lindgren <tony@atomide.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>,
 Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>,
 Conor Dooley <conor@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
 openrisc@lists.librecores.org, linux-riscv@lists.infradead.org,
 linux-sh@vger.kernel.org
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-13-vbabka@suse.cz>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20221121171202.22080-13-vbabka@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/22 18:12, Vlastimil Babka wrote:
> As explained in [1], we would like to remove SLOB if possible.
> 
> - There are no known users that need its somewhat lower memory footprint
>    so much that they cannot handle SLUB (after some modifications by the
>    previous patches) instead.
> 
> - It is an extra maintenance burden, and a number of features are
>    incompatible with it.
> 
> - It blocks the API improvement of allowing kfree() on objects allocated
>    via kmem_cache_alloc().
> 
> As the first step, rename the CONFIG_SLOB option in the slab allocator
> configuration choice to CONFIG_SLOB_DEPRECATED. Add CONFIG_SLOB
> depending on CONFIG_SLOB_DEPRECATED as an internal option to avoid code
> churn. This will cause existing .config files and defconfigs with
> CONFIG_SLOB=y to silently switch to the default (and recommended
> replacement) SLUB, while still allowing SLOB to be configured by anyone
> that notices and needs it. But those should contact the slab maintainers
> and linux-mm@kvack.org as explained in the updated help. With no valid
> objections, the plan is to update the existing defconfigs to SLUB and
> remove SLOB in a few cycles.
> 
> To make SLUB more suitable replacement for SLOB, a CONFIG_SLUB_TINY
> option was introduced to limit SLUB's memory overhead.
> There is a number of defconfigs specifying CONFIG_SLOB=y. As part of
> this patch, update them to select CONFIG_SLUB and CONFIG_SLUB_TINY.

Hm I forgot - some of those defconfigs might not actually be for so tiny 
devices to need CONFIG_SLUB_TINY (or SLOB previously). For those it 
would make more sense to simply remove CONFIG_SLOB=y and leave it to the 
default choice, which is SLUB (without _TINY). Feel free to point those 
out to me and I'll adjust. Thanks.

> [1] https://lore.kernel.org/all/b35c3f82-f67b-2103-7d82-7a7ba7521439@suse.cz/
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
> Cc: Janusz Krzysztofik <jmkrzyszt@gmail.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Jonas Bonn <jonas@southpole.se>
> Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> Cc: Stafford Horne <shorne@gmail.com>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Rich Felker <dalias@libc.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Conor Dooley <conor@kernel.org>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: <linux-arm-kernel@lists.infradead.org>
> Cc: <linux-omap@vger.kernel.org>
> Cc: <openrisc@lists.librecores.org>
> Cc: <linux-riscv@lists.infradead.org>
> Cc: <linux-sh@vger.kernel.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

