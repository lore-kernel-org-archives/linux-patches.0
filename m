Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1463B3D3D12
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 13:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770299481; cv=none; b=lVCx8TGfYSdm0UMDXCZk5sfNztRucMVEmQq7kjzOky0Fdy1zKVXwRKEAFv5oO+JnJoZBt45bLjY18RubWLDEv85cmZiKtUkz8xsqebsL29+G95ELvM8sZrVq89yg3WEK3W4zNU/MxSSQK0qd+oNT63259SZoRKPt1g3Icm4q/Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770299481; c=relaxed/simple;
	bh=kID9LT+3vkAWDNh860FDVKv2s5vZydEPh7O+Os3Pgto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MdYxVfipTt+/MzITqH0hIug/bWIOYdn6CfiufqRifa+eKizlKfBTT+65laqj6G3g6DgWK/rHdjolmorN1bz+3fa0jEKRWTL7vKOkNC5p3+1fRLEkOeWmFQn1NqywYViva0PGRkJi4kXyhuyaFJWYwXj66lsQqHPxUsKwGmj5X4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KV2ZKLPL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UzWW8/S1; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KV2ZKLPL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UzWW8/S1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KV2ZKLPL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UzWW8/S1";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KV2ZKLPL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UzWW8/S1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 622943E7B0;
	Thu,  5 Feb 2026 13:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770299479;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=63RyASxkcM4F025EolOaK9mj0Ir2CweXFhvCwSQW1vg=;
	b=KV2ZKLPLIiH/uNsqr6JiJRhtoGdAIesqvKD2y+u+Yn3P3yoXgCoqa75Zyzzm7uKrurtjXG
	lq2qhsEI9Aw3emvwWHTEshZgzNWl0rtaUZJ1KHXBFjfDmJYRgSYIZAV3mu6bDWSm+Jr2zJ
	e4e9ldwOTy4Hlo+CUxQzSN0ys1eLZ6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770299479;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=63RyASxkcM4F025EolOaK9mj0Ir2CweXFhvCwSQW1vg=;
	b=UzWW8/S1a9bIoY0LDuSCdGZCHYxSz8X1wryLTHJiaAOv9kjDJdenrLFjUidWDYti2wZvb1
	RNVYVKFhPzKTQjDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770299479;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=63RyASxkcM4F025EolOaK9mj0Ir2CweXFhvCwSQW1vg=;
	b=KV2ZKLPLIiH/uNsqr6JiJRhtoGdAIesqvKD2y+u+Yn3P3yoXgCoqa75Zyzzm7uKrurtjXG
	lq2qhsEI9Aw3emvwWHTEshZgzNWl0rtaUZJ1KHXBFjfDmJYRgSYIZAV3mu6bDWSm+Jr2zJ
	e4e9ldwOTy4Hlo+CUxQzSN0ys1eLZ6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770299479;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=63RyASxkcM4F025EolOaK9mj0Ir2CweXFhvCwSQW1vg=;
	b=UzWW8/S1a9bIoY0LDuSCdGZCHYxSz8X1wryLTHJiaAOv9kjDJdenrLFjUidWDYti2wZvb1
	RNVYVKFhPzKTQjDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3DBBD3EA63;
	Thu,  5 Feb 2026 13:51:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rS3oDleghGnbSwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 05 Feb 2026 13:51:19 +0000
Date: Thu, 5 Feb 2026 14:51:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 004/161] btrfs: send: check for inline extents in
 range_is_hole_in_parent()
Message-ID: <20260205135118.GX26902@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260204143851.755002596@linuxfoundation.org>
 <20260204143851.919366239@linuxfoundation.org>
 <03a74299797f4864d0e563cd9517276f690a4bf0.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03a74299797f4864d0e563cd9517276f690a4bf0.camel@decadent.org.uk>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Wed, Feb 04, 2026 at 07:28:42PM +0100, Ben Hutchings wrote:
> On Wed, 2026-02-04 at 15:37 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Qu Wenruo <wqu@suse.com>
> > 
> > [ Upstream commit 08b096c1372cd69627f4f559fb47c9fb67a52b39 ]
> > 
> > Before accessing the disk_bytenr field of a file extent item we need
> > to check if we are dealing with an inline extent.
> > This is because for inline extents their data starts at the offset of
> > the disk_bytenr field. So accessing the disk_bytenr
> > means we are accessing inline data or in case the inline data is less
> > than 8 bytes we can actually cause an invalid
> > memory access if this inline extent item is the first item in the leaf
> > or access metadata from other items.
> > 
> > Fixes: 82bfb2e7b645 ("Btrfs: incremental send, fix unnecessary hole writes for sparse files")
> > Reviewed-by: Filipe Manana <fdmanana@suse.com>
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > Reviewed-by: David Sterba <dsterba@suse.com>
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  fs/btrfs/send.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > index d86b4d13cae48..f144171ed6b7e 100644
> > --- a/fs/btrfs/send.c
> > +++ b/fs/btrfs/send.c
> > @@ -5892,6 +5892,8 @@ static int range_is_hole_in_parent(struct send_ctx *sctx,
> >  		extent_end = btrfs_file_extent_end(path);
> >  		if (extent_end <= start)
> >  			goto next;
> > +		if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE)
> > +			return 0;
> 
> This will leak path, unless (at least) commits 4c74a32ad323 "btrfs:
> DEFINE_FREE for struct btrfs_path" and 4ca6f24a52c4 "btrfs: more trivial
> BTRFS_PATH_AUTO_FREE conversions" are also backported.
> 
> That could be avoided by using { ret = 0; goto out; } here instead of
> simply returning.

Right, the original patch assumes the automatic cleanup of btrfs_path, so
for anything below it needs to be updated as you say.
