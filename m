Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0352C1B7
	for <patches@lists.linux.dev>; Wed, 13 Dec 2023 13:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AlxembAF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="I8OUWC0l";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AlxembAF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="I8OUWC0l"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 20E5C219C0;
	Wed, 13 Dec 2023 13:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1702473300;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N+tRkpzKknIH5zGeJRqYhM0xsQDyR09cPqGQ08XRLYo=;
	b=AlxembAFuGzXLoKikMWezt6YCg3t4i+gDtyUnvwaaGliNHj5pN/jZfmeHquNvE0TM8ws9C
	7NS4Sl3VJTnB3lpQeyBpDCKoRJYSHOBtxwd/6/yodNolWCmGQZ84k3zMCAEL95fZE73FOz
	W+LSWN+9R6g2f4sn6UbxF3xtCGepxXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1702473300;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N+tRkpzKknIH5zGeJRqYhM0xsQDyR09cPqGQ08XRLYo=;
	b=I8OUWC0l75Rfsa3R9KGATeWe2T5Zhscyv4ZVbOS0K7RPXXKykmOc8Vbunmg5W4nYlVQ0i5
	Ml3Xf7Ng/BmO8JAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1702473300;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N+tRkpzKknIH5zGeJRqYhM0xsQDyR09cPqGQ08XRLYo=;
	b=AlxembAFuGzXLoKikMWezt6YCg3t4i+gDtyUnvwaaGliNHj5pN/jZfmeHquNvE0TM8ws9C
	7NS4Sl3VJTnB3lpQeyBpDCKoRJYSHOBtxwd/6/yodNolWCmGQZ84k3zMCAEL95fZE73FOz
	W+LSWN+9R6g2f4sn6UbxF3xtCGepxXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1702473300;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N+tRkpzKknIH5zGeJRqYhM0xsQDyR09cPqGQ08XRLYo=;
	b=I8OUWC0l75Rfsa3R9KGATeWe2T5Zhscyv4ZVbOS0K7RPXXKykmOc8Vbunmg5W4nYlVQ0i5
	Ml3Xf7Ng/BmO8JAA==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id B843213240;
	Wed, 13 Dec 2023 13:14:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id Dh1NK1OueWVXKQAAn2gu4w
	(envelope-from <dsterba@suse.cz>); Wed, 13 Dec 2023 13:14:59 +0000
Date: Wed, 13 Dec 2023 14:08:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Anand Jain <anand.jain@oracle.com>,
	Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 5.4 63/94] btrfs: add dmesg output for first mount and
 last unmount of a filesystem
Message-ID: <20231213130808.GC3001@suse.cz>
Reply-To: dsterba@suse.cz
References: <20231205031522.815119918@linuxfoundation.org>
 <20231205031526.359703653@linuxfoundation.org>
 <20231209172836.GA2154579@dev-arch.thelio-3990X>
 <2023121106-henna-unclog-6d2f@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023121106-henna-unclog-6d2f@gregkh>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: 4.99
X-Spam-Flag: NO
X-Spamd-Bar: ++
X-Rspamd-Queue-Id: 20E5C219C0
X-Spam-Level: **
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AlxembAF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=I8OUWC0l;
	dmarc=none;
	spf=softfail (smtp-out1.suse.de: 2a07:de40:b281:104:10:150:64:98 is neither permitted nor denied by domain of dsterba@suse.cz) smtp.mailfrom=dsterba@suse.cz
X-Spam-Score: 2.79
X-Spamd-Result: default: False [2.79 / 50.00];
	 HAS_REPLYTO(0.30)[dsterba@suse.cz];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 ARC_NA(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 MIME_GOOD(-0.10)[text/plain];
	 REPLYTO_ADDR_EQ_FROM(0.00)[];
	 DMARC_NA(1.20)[suse.cz];
	 R_SPF_SOFTFAIL(4.60)[~all];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.cz:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[7];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.com:email,suse.cz:dkim,suse.com:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Flag: NO
X-Rspamd-Server: rspamd1

On Mon, Dec 11, 2023 at 03:56:16PM +0100, Greg Kroah-Hartman wrote:
> On Sat, Dec 09, 2023 at 10:28:36AM -0700, Nathan Chancellor wrote:
> > On Tue, Dec 05, 2023 at 12:17:31PM +0900, Greg Kroah-Hartman wrote:
> > > 5.4-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Qu Wenruo <wqu@suse.com>
> > > 
> > > commit 2db313205f8b96eea467691917138d646bb50aef upstream.
> > > 
> > > There is a feature request to add dmesg output when unmounting a btrfs.
> > > There are several alternative methods to do the same thing, but with
> > > their own problems:
> > > 
> > > - Use eBPF to watch btrfs_put_super()/open_ctree()
> > >   Not end user friendly, they have to dip their head into the source
> > >   code.
> > > 
> > > - Watch for directory /sys/fs/<uuid>/
> > >   This is way more simple, but still requires some simple device -> uuid
> > >   lookups.  And a script needs to use inotify to watch /sys/fs/.
> > > 
> > > Compared to all these, directly outputting the information into dmesg
> > > would be the most simple one, with both device and UUID included.
> > > 
> > > And since we're here, also add the output when mounting a filesystem for
> > > the first time for parity. A more fine grained monitoring of subvolume
> > > mounts should be done by another layer, like audit.
> > > 
> > > Now mounting a btrfs with all default mkfs options would look like this:
> > > 
> > >   [81.906566] BTRFS info (device dm-8): first mount of filesystem 633b5c16-afe3-4b79-b195-138fe145e4f2
> > >   [81.907494] BTRFS info (device dm-8): using crc32c (crc32c-intel) checksum algorithm
> > >   [81.908258] BTRFS info (device dm-8): using free space tree
> > >   [81.912644] BTRFS info (device dm-8): auto enabling async discard
> > >   [81.913277] BTRFS info (device dm-8): checking UUID tree
> > >   [91.668256] BTRFS info (device dm-8): last unmount of filesystem 633b5c16-afe3-4b79-b195-138fe145e4f2
> > > 
> > > CC: stable@vger.kernel.org # 5.4+
> > > Link: https://github.com/kdave/btrfs-progs/issues/689
> > > Reviewed-by: Anand Jain <anand.jain@oracle.com>
> > > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > > Reviewed-by: David Sterba <dsterba@suse.com>
> > > [ update changelog ]
> > > Signed-off-by: David Sterba <dsterba@suse.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  fs/btrfs/disk-io.c |    1 +
> > >  fs/btrfs/super.c   |    5 ++++-
> > >  2 files changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > --- a/fs/btrfs/disk-io.c
> > > +++ b/fs/btrfs/disk-io.c
> > > @@ -2829,6 +2829,7 @@ int open_ctree(struct super_block *sb,
> > >  		goto fail_alloc;
> > >  	}
> > >  
> > > +	btrfs_info(fs_info, "first mount of filesystem %pU", disk_super->fsid);
> > 
> > clang tells me this backport does not appear to be correct and will
> > likely introduce a null pointer deference:
> > 
> >   fs/btrfs/disk-io.c:2832:55: warning: variable 'disk_super' is uninitialized when used here [-Wuninitialized]
> >    2832 |         btrfs_info(fs_info, "first mount of filesystem %pU", disk_super->fsid);
> >         |                                                              ^~~~~~~~~~
> >   fs/btrfs/ctree.h:3002:41: note: expanded from macro 'btrfs_info'
> >    3002 |         btrfs_printk(fs_info, KERN_INFO fmt, ##args)
> >         |                                                ^~~~
> >   fs/btrfs/disk-io.c:2630:38: note: initialize the variable 'disk_super' to silence this warning
> >    2630 |         struct btrfs_super_block *disk_super;
> >         |                                             ^
> >         |                                              = NULL
> >   1 warning generated.
> 
> Thanks for the notice, I've now reverted this.

Thanks. I've verified that this only affects 5.4. The patch is still
possible to apply there, the btrfs_info() call would have to be moved
after 'disk_super' is initialized. The patch is not that important so
reverting is OK for me.
