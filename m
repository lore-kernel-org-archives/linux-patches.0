Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239712580
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 884012113B
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6F69213A8E
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 9FvJFmVnE2KnIAAAMHmgww
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Mon, 21 Feb 2022 11:20:20 +0100
Resent-Message-ID: <8ec29191-ef8c-aac9-af39-f80be375a482@suse.cz>
Received: from dovecot-director2.suse.de ([192.168.254.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.suse-dmz.suse.de with LMTPS
	id eCgROk6TDWLCeQAAMHmgww
	(envelope-from <willy@infradead.org>)
	for <vbabka>; Thu, 17 Feb 2022 00:14:06 +0000
Received: from relay2.suse.de ([149.44.160.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	by dovecot-director2.suse.de with LMTPS
	id 4KnOOE6TDWK1OwAApTUePA
	(envelope-from <willy@infradead.org>)
	for <vbabka@imap.suse.de>; Thu, 17 Feb 2022 00:14:06 +0000
Received: from relay2.suse.de (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id E13DAA3B87
	for <vbabka@imap.suse.de>; Thu, 17 Feb 2022 00:14:06 +0000 (UTC)
X-Virus-Scanned: by amavisd-new at relay2.suse.de
X-Spam-Flag: NO
X-Spam-Score: 0.59
X-Spam-Level:
X-Spam-Status: No, score=0.59 tagged_above=-9999 required=5
	tests=[BAYES_50=0.8, DKIM_SIGNED=0.1, DKIM_VALID=-0.1,
	DKIM_VALID_AU=-0.1, DKIM_VALID_EF=-0.1, T_SCC_BODY_TEXT_LINE=-0.01]
	autolearn=no autolearn_force=no
Received: from relay2.suse.de ([127.0.0.1])
	by relay2.suse.de (relay2.suse.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id E5hFziGsjI6W for <vbabka@imap.suse.de>;
	Thu, 17 Feb 2022 00:14:01 +0000 (UTC)
Received: from mx2.suse.de (unknown [149.44.161.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 900EAA3B83
	for <vbabka@imap.suse.de>; Thu, 17 Feb 2022 00:14:01 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTPS id 6BCA2AA55
	for <vbabka@suse.cz>; Thu, 17 Feb 2022 00:14:01 +0000 (UTC)
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nKUQj-00F91t-SG; Thu, 17 Feb 2022 00:13:53 +0000
Date: Thu, 17 Feb 2022 00:13:53 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>, Vasily Averin <vvs@virtuozzo.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux MM <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: tools/cgroup/memcg_slabinfo.py is broken
Message-ID: <Yg2TQbpWen2SUP+l@casper.infradead.org>
References: <327b9e92-88bb-d66f-e07c-526161db539b@virtuozzo.com>
 <Ygw3au+tPdg2MXYT@carbon.dhcp.thefacebook.com>
 <35486a00-791c-3b1b-14e0-476e6242709b@virtuozzo.com>
 <Yg1kFH3umdrvOhu1@carbon.dhcp.thefacebook.com>
 <Yg1ooYmX54j8l+Fz@casper.infradead.org>
 <Yg1wKkIJxIdN43qU@carbon.dhcp.thefacebook.com>
 <Yg1y0ax5bnjGLAqz@casper.infradead.org>
 <Yg16ClVQj8SLSlqV@carbon.DHCP.thefacebook.com>
 <Yg2EwqE07d97gmms@casper.infradead.org>
 <CALvZod5nqqt_9Xn0Yq4wiue_QePY5wz6BX6Vk2dH3P9qc92yPw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod5nqqt_9Xn0Yq4wiue_QePY5wz6BX6Vk2dH3P9qc92yPw@mail.gmail.com>

On Wed, Feb 16, 2022 at 03:57:39PM -0800, Shakeel Butt wrote:
> On Wed, Feb 16, 2022 at 3:12 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> [...]
> > > Here I'd keep _page (or _folio, if you want), because
> > > it makes it clear that the function goes over all pages
> > > (and is expensive therefore).
> >
> > But there's no intrinsic reason that it should.  If that's a
> > performance problem, you could keep slabs on a separate list
> > from, eg, file or anon memory.
> >
> 
> Is there enough space in the struct slab for that list or do you mean
> something different?

Well, I don't know what data structure your for_each_page() uses, so
I don't know what to suggest exactly.

If it's an iteration over the entirety of memmap, then maybe you'd
rather iterate over each kmem_cache like /proc/slabinfo does?
