Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9984913B791
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 17:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738863948; cv=none; b=YY9tgiBvMnXjXwecwBoLZuxiTrAje81lWrRUi6KqjLlH98FV4RGhIP4oXyD1wPB7+2NKZeD7KGBnwDh9ptyw++y+efFzQrWzlZ9EKPCF7l8Ep9LI+W2gFJLjad2i9xfhkPT9ep9ewYhiLX19w63KcjkQ9BZ05yVjA3iHVADRBLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738863948; c=relaxed/simple;
	bh=hcjhRL1uUhBnIfOKURbeZFxjUil/y+rGWQbSJbr1HYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CFIzf0iZQhqQW35s2DPklUIulYEYBIuTQOebrkgzsuES+NDH5WweTrHmh9iPTs3a1KgE+pJHDh4LKBfEWSwvReqJeFWhbLMw6mhaejDodnzMznl0wsTQjEMaD4DmFDq+rjn+2mMt51jdeHX/Lr0E2P+lPvdFn/zK4mC1DcurvTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tQRLsYVy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qMbktalG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tQRLsYVy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qMbktalG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tQRLsYVy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qMbktalG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tQRLsYVy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qMbktalG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9AF052115F;
	Thu,  6 Feb 2025 17:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1738863944;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u6np/06nqTwdt+l9JmmqF0b95EaD4Aq0LdjLZ+jJRTM=;
	b=tQRLsYVySzT5PkFgFysI01NKNVejixRQm1XOiUkQ8oKXm9jDHnIceuO4cLdmUmjYdepNM2
	Q9mBCSq6pOb8dNATjPpcu/zcA8U0bycTQUd+TeMQe6z3PMeCTdIvBV1ODmRNe+d54QrpFj
	7x1nJJx7GVwOTEwtjLHy32G84Y/JhKc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1738863944;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u6np/06nqTwdt+l9JmmqF0b95EaD4Aq0LdjLZ+jJRTM=;
	b=qMbktalGZKxZGjT4GPqf9cs/jCmYVqIAEgfdomk/eTsuqAXsxE1j2QrDNkxJN5IOWrKwHD
	k5vCCBc0bVcDSODQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1738863944;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u6np/06nqTwdt+l9JmmqF0b95EaD4Aq0LdjLZ+jJRTM=;
	b=tQRLsYVySzT5PkFgFysI01NKNVejixRQm1XOiUkQ8oKXm9jDHnIceuO4cLdmUmjYdepNM2
	Q9mBCSq6pOb8dNATjPpcu/zcA8U0bycTQUd+TeMQe6z3PMeCTdIvBV1ODmRNe+d54QrpFj
	7x1nJJx7GVwOTEwtjLHy32G84Y/JhKc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1738863944;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u6np/06nqTwdt+l9JmmqF0b95EaD4Aq0LdjLZ+jJRTM=;
	b=qMbktalGZKxZGjT4GPqf9cs/jCmYVqIAEgfdomk/eTsuqAXsxE1j2QrDNkxJN5IOWrKwHD
	k5vCCBc0bVcDSODQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 79D5D13697;
	Thu,  6 Feb 2025 17:45:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7np/HUj1pGewYwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 06 Feb 2025 17:45:44 +0000
Date: Thu, 6 Feb 2025 18:45:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Koichiro Den <koichiro.den@canonical.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 6.12 102/114] btrfs: avoid monopolizing a core when
 activating a swap file
Message-ID: <20250206174542.GM5777@suse.cz>
Reply-To: dsterba@suse.cz
References: <20241230154218.044787220@linuxfoundation.org>
 <20241230154222.045141330@linuxfoundation.org>
 <q6zj7uvssfaqkz5sshi7i6oooschrwlyapb7o47y36ylz4ylf7@dkopww2lfuko>
 <2025020634-grid-goldfish-c9ef@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025020634-grid-goldfish-c9ef@gregkh>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Score: -4.00
X-Spam-Flag: NO

On Thu, Feb 06, 2025 at 03:31:02PM +0100, Greg Kroah-Hartman wrote:
> On Thu, Feb 06, 2025 at 08:41:33PM +0900, Koichiro Den wrote:
> > On Mon, Dec 30, 2024 at 04:43:39PM GMT, Greg Kroah-Hartman wrote:
> > > 
> > 
> > Hi, please let me confirm; is this backport really ok? I mean, should the
> > cond_resched() be added to btrfs_swap_activate() loop? I was able to
> > reproduce the same situation:
> > 
> >     $ git rev-parse HEAD
> >     319addc2ad901dac4d6cc931d77ef35073e0942f
> >     $ b4 mbox --single-message  c37ea7a8de12e996091ba295b2f201fbe680c96c.1733929328.git.fdmanana@suse.com
> >     1 messages in the thread
> >     Saved ./c37ea7a8de12e996091ba295b2f201fbe680c96c.1733929328.git.fdmanana@suse.com.mbx
> >     $ patch -p1 < ./c37ea7a8de12e996091ba295b2f201fbe680c96c.1733929328.git.fdmanana@suse.com.mbx
> >     patching file fs/btrfs/inode.c
> >     Hunk #1 succeeded at 7117 with fuzz 1 (offset -2961 lines).
> >     $ git diff
> >     diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> >     index 58ffe78132d9..6fe2ac620464 100644
> >     --- a/fs/btrfs/inode.c
> >     +++ b/fs/btrfs/inode.c
> >     @@ -7117,6 +7117,8 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
> >                             ret = -EAGAIN;
> >                             goto out;
> >                     }
> >     +
> >     +               cond_resched();
> >             }
> >     
> >             if (file_extent)
> > 
> > The same goes for all the other stable branches applied. Sorry if I'm
> > missing something.
> 
> Hm, looks like patch messed this up :(

The fix is part of 4 patch series. The stable tree 6.12 has only 3 and
in different order, so this one fails to apply due to missing context
and got applied to the wrong function.

Applying all 4 in order to 6.12.y (same base commit f6279a98db132da0cff)
works without conflicts.

$ git cherry-pick 0525064bb82e50d59543b62b9d41a606198a4a44
Auto-merging fs/btrfs/inode.c
[detached HEAD 0466e0dbbb99] btrfs: fix race with memory mapped writes when activating swap file
 Author: Filipe Manana <fdmanana@suse.com>
 Date: Fri Nov 29 12:25:30 2024 +0000
 1 file changed, 24 insertions(+), 7 deletions(-)

$ git cherry-pick 03018e5d8508254534511d40fb57bc150e6a87f2
Auto-merging fs/btrfs/inode.c
[detached HEAD 1715e6abcf46] btrfs: fix swap file activation failure due to extents that used to be shared
 Author: Filipe Manana <fdmanana@suse.com>
 Date: Mon Dec 9 12:54:14 2024 +0000
 1 file changed, 69 insertions(+), 27 deletions(-)

$ git cherry-pick 9a45022a0efadd99bcc58f7f1cc2b6fb3b808c40
Auto-merging fs/btrfs/inode.c
[detached HEAD 78d50f8c8827] btrfs: allow swap activation to be interruptible
 Author: Filipe Manana <fdmanana@suse.com>
 Date: Mon Dec 9 16:31:41 2024 +0000
 1 file changed, 5 insertions(+)

$ git cherry-pick 2c8507c63f5498d4ee4af404a8e44ceae4345056
Auto-merging fs/btrfs/inode.c
[detached HEAD a162d2371965] btrfs: avoid monopolizing a core when activating a swap file
 Author: Filipe Manana <fdmanana@suse.com>
 Date: Mon Dec 9 16:43:44 2024 +0000
 1 file changed, 2 insertions(+)

I have more trust in git patch logic than 'patch', this can happen in the
future again.
