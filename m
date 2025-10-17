Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7C2330B08
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 15:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715778; cv=none; b=cOaqhFvaGGY0Prl/U9lnrU3lhVzG4ZisFZPsS0Pp1upcXf/4Mb6V3yj24n3pC4d0jpzaBIpZDbk2lZw/YaSN8EQhGdsIYVwn9IlYbryAKxGIB3Y4l7v5lPh1pFXcndxreROLXf6PTg25Ob27u2NsWBIQd62jOG8NyVJoCMOAwck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715778; c=relaxed/simple;
	bh=7pilBphE6MFK54HtMTZcIhLQoQNGtgEVHLrkJWRLKMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GH6MUr5LFHMxHahd9zGwmnVxj56RMavR3SsGPQhtHsEav2Or/upOpLC4dtKiOGm5AJ5bhoyzQlBeKaRPcovOlafQZyV6QvO2HH33O3UIDyaX/WWNEzNr4bWTd9w8S59BDX0HrMnQGxPkiRFQ7jbVy6e9tPl7p9/YY8ZfRLpFnWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zQn6Mxt/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=y5GTdQNY; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=s9/zEObj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kiH01kA7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zQn6Mxt/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="y5GTdQNY";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="s9/zEObj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kiH01kA7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 074202174D;
	Fri, 17 Oct 2025 15:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760715775;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7UlrgCueMrXsssLTpqaM53BC4RlHReGuzAJkL1XtptE=;
	b=zQn6Mxt/2ZQK+hcSVldGxfoirXOvX8KxoIJYb+DZTcrp4ifNnGapML1eWqq2EFAtgy77FA
	WxqGE8/N0SUmu8Nj95g0wN/ZdbRoQ8iSbH4qkdYNMSp9gZwhwaqw19XRrIGjE3sZJNulc3
	NTQ+sY9G5SHRPgGhcLBb/1GQ/mNG8pA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760715775;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7UlrgCueMrXsssLTpqaM53BC4RlHReGuzAJkL1XtptE=;
	b=y5GTdQNYzGohjDmbG9TvSdhL01fJO5Xq6AXtJUzdlXOVkno83U9p/PaoDtoYoQhsJ7z+b7
	PHCejtu2CaAwJzAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760715774;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7UlrgCueMrXsssLTpqaM53BC4RlHReGuzAJkL1XtptE=;
	b=s9/zEObjO9gK/tI8tM1qpbnZvbrBunimfFCH7iAmUGdBPSk0b59f1X6+qdeSNsQj1HfmQj
	3U+CjYqGY91AQXg5Jx0ns3fu1BNL7Ad0SpbNJUdYExHzCxsgB9cEPNRgrhH0IxMaKTfeFz
	YPgW6FknpS2JCxauZRNvXXnIirORY9o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760715774;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7UlrgCueMrXsssLTpqaM53BC4RlHReGuzAJkL1XtptE=;
	b=kiH01kA7bbOBSOmsviqftDXbU9a7bx4XbjnHiSK5B76TipJWyZ8zpSYexozhD5i0lfopLv
	ijyDQwO/wUjId4Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E0FF5136C6;
	Fri, 17 Oct 2025 15:42:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6km9Nv1j8mj3IQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 17 Oct 2025 15:42:53 +0000
Date: Fri, 17 Oct 2025 17:42:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 6.17 003/371] btrfs: fix the incorrect max_bytes value
 for find_lock_delalloc_range()
Message-ID: <20251017154248.GK13776@suse.cz>
Reply-To: dsterba@suse.cz
References: <20251017145201.780251198@linuxfoundation.org>
 <20251017145201.913683496@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017145201.913683496@linuxfoundation.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:email,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Fri, Oct 17, 2025 at 04:49:38PM +0200, Greg Kroah-Hartman wrote:
> 6.17-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Qu Wenruo <wqu@suse.com>
> 
> commit 7b26da407420e5054e3f06c5d13271697add9423 upstream.
> 
> [BUG]
> With my local branch to enable bs > ps support for btrfs, sometimes I
> hit the following ASSERT() inside submit_one_sector():
> 
> 	ASSERT(block_start != EXTENT_MAP_HOLE);
> 
> Please note that it's not yet possible to hit this ASSERT() in the wild
> yet, as it requires btrfs bs > ps support, which is not even in the
> development branch.
> 
> But on the other hand, there is also a very low chance to hit above
> ASSERT() with bs < ps cases, so this is an existing bug affect not only
> the incoming bs > ps support but also the existing bs < ps support.
> 
> [CAUSE]
> Firstly that ASSERT() means we're trying to submit a dirty block but
> without a real extent map nor ordered extent map backing it.
> 
> Furthermore with extra debugging, the folio triggering such ASSERT() is
> always larger than the fs block size in my bs > ps case.
> (8K block size, 4K page size)
> 
> After some more debugging, the ASSERT() is trigger by the following
> sequence:
> 
>  extent_writepage()
>  |  We got a 32K folio (4 fs blocks) at file offset 0, and the fs block
>  |  size is 8K, page size is 4K.
>  |  And there is another 8K folio at file offset 32K, which is also
>  |  dirty.
>  |  So the filemap layout looks like the following:
>  |
>  |  "||" is the filio boundary in the filemap.
>  |  "//| is the dirty range.
>  |
>  |  0        8K       16K        24K         32K       40K
>  |  |////////|        |//////////////////////||////////|
>  |
>  |- writepage_delalloc()
>  |  |- find_lock_delalloc_range() for [0, 8K)
>  |  |  Now range [0, 8K) is properly locked.
>  |  |
>  |  |- find_lock_delalloc_range() for [16K, 40K)
>  |  |  |- btrfs_find_delalloc_range() returned range [16K, 40K)
>  |  |  |- lock_delalloc_folios() locked folio 0 successfully
>  |  |  |
>  |  |  |  The filemap range [32K, 40K) got dropped from filemap.
>  |  |  |
>  |  |  |- lock_delalloc_folios() failed with -EAGAIN on folio 32K
>  |  |  |  As the folio at 32K is dropped.
>  |  |  |
>  |  |  |- loops = 1;
>  |  |  |- max_bytes = PAGE_SIZE;
>  |  |  |- goto again;
>  |  |  |  This will re-do the lookup for dirty delalloc ranges.
>  |  |  |
>  |  |  |- btrfs_find_delalloc_range() called with @max_bytes == 4K
>  |  |  |  This is smaller than block size, so
>  |  |  |  btrfs_find_delalloc_range() is unable to return any range.
>  |  |  \- return false;
>  |  |
>  |  \- Now only range [0, 8K) has an OE for it, but for dirty range
>  |     [16K, 32K) it's dirty without an OE.
>  |     This breaks the assumption that writepage_delalloc() will find
>  |     and lock all dirty ranges inside the folio.
>  |
>  |- extent_writepage_io()
>     |- submit_one_sector() for [0, 8K)
>     |  Succeeded
>     |
>     |- submit_one_sector() for [16K, 24K)
>        Triggering the ASSERT(), as there is no OE, and the original
>        extent map is a hole.
> 
> Please note that, this also exposed the same problem for bs < ps
> support. E.g. with 64K page size and 4K block size.
> 
> If we failed to lock a folio, and falls back into the "loops = 1;"
> branch, we will re-do the search using 64K as max_bytes.
> Which may fail again to lock the next folio, and exit early without
> handling all dirty blocks inside the folio.
> 
> [FIX]
> Instead of using the fixed size PAGE_SIZE as @max_bytes, use
> @sectorsize, so that we are ensured to find and lock any remaining
> blocks inside the folio.
> 
> And since we're here, add an extra ASSERT() to
> before calling btrfs_find_delalloc_range() to make sure the @max_bytes is
> at least no smaller than a block to avoid false negative.
> 
> Cc: stable@vger.kernel.org # 5.15+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Please drop this patch from all stable branch, this is for an unfinished
feature and not available in any release.
