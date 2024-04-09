Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714683A1C7
	for <patches@lists.linux.dev>; Tue,  9 Apr 2024 06:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712644948; cv=none; b=fK2CAosUHQ1Q7ycAELnaSFmO0oL4/K4+XXb7hMr+Y60zfe2JlxQQEKH2PTfah1x+FGoGOLx/kA56X09aelFXoAbx055f7pucPjiQiYr+k5LIMMTKi96Exz5RtEEkD/+tAmDpfsIr53PonU4MaP3BytSclslSJ3ovY+n8qXQkf38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712644948; c=relaxed/simple;
	bh=2UWzZU3OGus20bi2QNQyPyLmKfS/WdjFHRdIB5PJHkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eo0BBxTRhxGiY+AY1tROEwVfoxneoaMBWCk5Qi2ZF0m953sPUPDgP78Bi+YYL9xOXsIb++F/FZp3cjn3Qf1k+0GsITbL5nSSfhjIoa/GElK2sgVLGmMD4HrQx7o09dT+Ux2Z86R388x5Oa4ohvlbKTT9y9PfU6RrC4oTHax7FyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UfucgPxI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EMEJyXjC; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=e3tjHwKv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=sagsR/lQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UfucgPxI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EMEJyXjC";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="e3tjHwKv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="sagsR/lQ"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 879792081C;
	Tue,  9 Apr 2024 06:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1712644944;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gW640Tnn4Pgl8BZXIbzNI+gNPREqrCBZDNR4tdFxVhU=;
	b=UfucgPxIYHsVeGMkR4aCD5ThpZ0cbOaHxhgiGD7wVMK97qaJZ8F1kUjHar+DWTIHEe1UHu
	rnizqLI9ckrrX0ZPHZwRAT5miQJYzoqTIdba+VVLAfup0Q80DsEZvneNhrL3LaNzbvyi6b
	avflrRaRGmj61LeKiIe/4xEs+ZfglkA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1712644944;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gW640Tnn4Pgl8BZXIbzNI+gNPREqrCBZDNR4tdFxVhU=;
	b=EMEJyXjCJRahYmWphIV4cW4METhi1cKHXLY3JT+irX/4z//4tqE2WFnC9TebmZHgJjlaLk
	B6Q3Ct6KGf17gDAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=e3tjHwKv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="sagsR/lQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1712644943;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gW640Tnn4Pgl8BZXIbzNI+gNPREqrCBZDNR4tdFxVhU=;
	b=e3tjHwKvyZ644QwQVJrSV4FV0CPtgBGC76T7ZkyT2ju5iSWscczuZBZcst0z2QiYUT9rBc
	4M/ipgYZ67AWKfFIBHje9pz8kfoy8iCRZ9lECJiWm0KbQkvc9T2hHdVAVOBiW6t50eAujP
	56wMe2D0bPz65mJgdwbDWniKhXqK3JE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1712644943;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gW640Tnn4Pgl8BZXIbzNI+gNPREqrCBZDNR4tdFxVhU=;
	b=sagsR/lQsc0Jo6L+iXzmESqdjRYHmlcJAhLgjnl3W5fuw1yIeJtBWwnx8Ofjz/SeY5OGuK
	HE9+a4Q7h9upi5CA==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 6805D13253;
	Tue,  9 Apr 2024 06:42:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id YqlHGE/jFGajIgAAn2gu4w
	(envelope-from <pvorel@suse.cz>); Tue, 09 Apr 2024 06:42:23 +0000
Date: Tue, 9 Apr 2024 08:42:22 +0200
From: Petr Vorel <pvorel@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH 5.15 463/690] nfsd: fix net-namespace logic in
 __nfsd_file_cache_purge
Message-ID: <20240409064222.GA83048@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20240408125359.506372836@linuxfoundation.org>
 <20240408125416.405210374@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408125416.405210374@linuxfoundation.org>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.71 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	HAS_REPLYTO(0.30)[pvorel@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap2.dmz-prg2.suse.org:helo,imap2.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto,suse.cz:email,oracle.com:email];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 879792081C
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -3.71

Hi all,

> 5.15-stable review patch.  If anyone has any objections, please let me know.

> ------------------

> From: Jeff Layton <jlayton@kernel.org>

> [ Upstream commit d3aefd2b29ff5ffdeb5c06a7d3191a027a18cdb8 ]

> If the namespace doesn't match the one in "net", then we'll continue,
> but that doesn't cause another rhashtable_walk_next call, so it will
> loop infinitely.

> Fixes: ce502f81ba88 ("NFSD: Convert the filecache to use rhashtable")
> Reported-by: Petr Vorel <pvorel@suse.cz>
> Link: https://lore.kernel.org/ltp/Y1%2FP8gDAcWC%2F+VR3@pevik/
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  fs/nfsd/filecache.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

> diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
> index 0b19eb015c6c8..024adcbe67e95 100644
> --- a/fs/nfsd/filecache.c
> +++ b/fs/nfsd/filecache.c
> @@ -892,9 +892,8 @@ __nfsd_file_cache_purge(struct net *net)

>  		nf = rhashtable_walk_next(&iter);
>  		while (!IS_ERR_OR_NULL(nf)) {
> -			if (net && nf->nf_net != net)
> -				continue;
> -			nfsd_file_unhash_and_dispose(nf, &dispose);
I don't know the context (whether the fix is needed for 5.15 and older), but
patch does not apply because nfsd_file_unhash_and_dispose() was introduced in
ce502f81ba88 ("NFSD: Convert the filecache to use rhashtable") in v6.0-rc1.  It
was actually renamed from nfsd_file_unhash_and_release_locked() in that commit.
Also the context changed - nfsd_file_unhash_and_dispose() was introduced in the
commit which is supposed to be fixed in this commit, one would say that this fix
is not needed in older kernels (5.15, 5.10 and 5.4; 4.19 has completely
different code). But that's a question for Jeff or Chuck.

Kind regards,
Petr

> +			if (!net || nf->nf_net == net)
> +				nfsd_file_unhash_and_dispose(nf, &dispose);
>  			nf = rhashtable_walk_next(&iter);
>  		}
