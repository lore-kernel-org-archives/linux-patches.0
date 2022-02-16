Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBEA2568
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:22 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 59AF721129
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4CF9713A8D
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id uRDrEWVnE2KdIAAAMHmgww
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Mon, 21 Feb 2022 11:20:20 +0100
Resent-Message-ID: <1ea24f22-6939-f9ca-4687-0bf445546fa8@suse.cz>
Received: from dovecot-director2.suse.de ([192.168.254.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.suse-dmz.suse.de with LMTPS
	id eB2ZNa5oDWLxMAAAMHmgww
	(envelope-from <willy@infradead.org>)
	for <vbabka>; Wed, 16 Feb 2022 21:12:14 +0000
Received: from relay2.suse.de ([149.44.160.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	by dovecot-director2.suse.de with LMTPS
	id MMOvNK5oDWJ9HgAApTUePA
	(envelope-from <willy@infradead.org>)
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 21:12:14 +0000
Received: from relay2.suse.de (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id D09DEA3B8B
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 21:12:14 +0000 (UTC)
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
	with ESMTP id ig7CpYMeB2yN for <vbabka@imap.suse.de>;
	Wed, 16 Feb 2022 21:12:09 +0000 (UTC)
Received: from mx2.suse.de (unknown [149.44.161.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 7EF8BA3B8F
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 21:12:09 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTPS id 61834AD86
	for <vbabka@suse.cz>; Wed, 16 Feb 2022 21:12:09 +0000 (UTC)
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nKRaj-00F2ir-Am; Wed, 16 Feb 2022 21:12:01 +0000
Date: Wed, 16 Feb 2022 21:12:01 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Roman Gushchin <guro@fb.com>
Cc: Vasily Averin <vvs@virtuozzo.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux MM <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: tools/cgroup/memcg_slabinfo.py is broken
Message-ID: <Yg1ooYmX54j8l+Fz@casper.infradead.org>
References: <327b9e92-88bb-d66f-e07c-526161db539b@virtuozzo.com>
 <Ygw3au+tPdg2MXYT@carbon.dhcp.thefacebook.com>
 <35486a00-791c-3b1b-14e0-476e6242709b@virtuozzo.com>
 <Yg1kFH3umdrvOhu1@carbon.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yg1kFH3umdrvOhu1@carbon.dhcp.thefacebook.com>

On Wed, Feb 16, 2022 at 12:52:36PM -0800, Roman Gushchin wrote:
> The problem can be fixed by explicitly casting struct page * to struct
> slab * for slab pages. The tools works as expected with this fix, e.g.:

This feels like a quick fix, and not really correct.

> @@ -77,7 +77,8 @@ def count_partial(n, fn):
>  
>  
>  def count_free(page):
> -    return page.objects - page.inuse
> +    slab = cast('struct slab *', page)
> +    return slab.objects - slab.inuse

count_free() should take a slab, not a page.

>  def slub_get_slabinfo(s, cfg):
> @@ -193,10 +194,11 @@ def main():
>          # look over all slab pages, belonging to non-root memcgs
>          # and look for objects belonging to the given memory cgroup
>          for page in for_each_slab_page(prog):

for_each_slab_page() should be renamed for_each_slab().
It should return a slab, not a page.  And it should definitely skip
over tail pages (it works today by coincidence because tail pages do
not have PG_slab set).

count_partial() should use struct slab, and slab_list, not lru.

... I think that's it.  But I'm no pythonist, much less dragoneer.
