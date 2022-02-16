Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD8A2583
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:24 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A72C71F392
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 82FE913A8D
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id W3BLH2VnE2K2IAAAMHmgww
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Mon, 21 Feb 2022 11:20:20 +0100
Resent-Message-ID: <f830ba44-b8a7-3277-1a43-48e087427a88@suse.cz>
Received: from dovecot-director2.suse.de ([192.168.254.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.suse-dmz.suse.de with LMTPS
	id gJTfEM+EDWJxYwAAMHmgww
	(envelope-from <willy@infradead.org>)
	for <vbabka>; Wed, 16 Feb 2022 23:12:15 +0000
Received: from relay2.suse.de ([149.44.160.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	by dovecot-director2.suse.de with LMTPS
	id UKq5D8+EDWJAMgAApTUePA
	(envelope-from <willy@infradead.org>)
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 23:12:15 +0000
Received: from relay2.suse.de (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id 3A232A3B8B
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 23:12:15 +0000 (UTC)
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
	with ESMTP id cGOgCqJ5usUC for <vbabka@imap.suse.de>;
	Wed, 16 Feb 2022 23:12:09 +0000 (UTC)
Received: from mx2.suse.de (unknown [149.44.161.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id B6C60A3B88
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 23:12:09 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTPS id 95665AD86
	for <vbabka@suse.cz>; Wed, 16 Feb 2022 23:12:09 +0000 (UTC)
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nKTSs-00F6qN-AG; Wed, 16 Feb 2022 23:12:02 +0000
Date: Wed, 16 Feb 2022 23:12:02 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Roman Gushchin <guro@fb.com>
Cc: Vasily Averin <vvs@virtuozzo.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux MM <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: tools/cgroup/memcg_slabinfo.py is broken
Message-ID: <Yg2EwqE07d97gmms@casper.infradead.org>
References: <327b9e92-88bb-d66f-e07c-526161db539b@virtuozzo.com>
 <Ygw3au+tPdg2MXYT@carbon.dhcp.thefacebook.com>
 <35486a00-791c-3b1b-14e0-476e6242709b@virtuozzo.com>
 <Yg1kFH3umdrvOhu1@carbon.dhcp.thefacebook.com>
 <Yg1ooYmX54j8l+Fz@casper.infradead.org>
 <Yg1wKkIJxIdN43qU@carbon.dhcp.thefacebook.com>
 <Yg1y0ax5bnjGLAqz@casper.infradead.org>
 <Yg16ClVQj8SLSlqV@carbon.DHCP.thefacebook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yg16ClVQj8SLSlqV@carbon.DHCP.thefacebook.com>

On Wed, Feb 16, 2022 at 02:26:18PM -0800, Roman Gushchin wrote:
> On Wed, Feb 16, 2022 at 09:55:29PM +0000, Matthew Wilcox wrote:
> > On Wed, Feb 16, 2022 at 01:44:10PM -0800, Roman Gushchin wrote:
> > > On Wed, Feb 16, 2022 at 09:12:01PM +0000, Matthew Wilcox wrote:
> > > > On Wed, Feb 16, 2022 at 12:52:36PM -0800, Roman Gushchin wrote:
> > > > > The problem can be fixed by explicitly casting struct page * to struct
> > > > > slab * for slab pages. The tools works as expected with this fix, e.g.:
> > > > 
> > > > This feels like a quick fix, and not really correct.
> > > 
> > > Do you mind to provide a correct version?
> > 
> > I know nothing about python, nor how to even run this script.  But this
> > is the kind of thing I was thinking about.
> > 
> > I didn't do the 'skip over tail pages' because I have no idea how
> > you'd tell for_each_page() to do that.  I don't know where to get
> > drgn.helpers.linux from, so I can't look at the implementation.
> > Maybe it already does that.
> 
> Is there an actual plan to set the slab flag for tail pages?
> If not, why to check both? It's fairly expensive already, so I'd
> not add any additional checks if there is no strict necessity.

The plan to set the slab flag on tail pages is probably about five
years away.  There are a lot of moving parts before we get there.
I think you could reduce the cost if we had a for_each_folio()
loop.  Most code doesn't really want to look at every page, so
having a shorter list (and iterating over each page within a folio
for the few places that really do want to see every page) would
be a good tradeoff.

> > @@ -145,14 +145,14 @@ def detect_kernel_config():
> >      return cfg
> >  
> >  
> > -def for_each_slab_page(prog):
> > +def for_each_slab(prog):
> 
> Here I'd keep _page (or _folio, if you want), because
> it makes it clear that the function goes over all pages
> (and is expensive therefore).

But there's no intrinsic reason that it should.  If that's a
performance problem, you could keep slabs on a separate list
from, eg, file or anon memory.

