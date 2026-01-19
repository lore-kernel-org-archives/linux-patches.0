Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7E23624C9
	for <patches@lists.linux.dev>; Mon, 19 Jan 2026 13:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768827756; cv=none; b=fdAYTmXrDg6eBi71CP86eJmt2TjDbscoojDXffpAlWqUzElhUk8Oc3bVjCuXKcBQu8BP//r9NIwRn7zORppE+rxGybLNKqDdW9xFc4Tt6sZ7OEq23BGSEktiijpL5fWJUwKbZBoBcxPsWoXI8WW8hlYSfuVpEutYeXqICbT1oWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768827756; c=relaxed/simple;
	bh=x7EiAMW9C+Ek2ACdhqu2hp1zr3Gbl/4Dyfqpz4ikI7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N0QmxfV4BDx+1UfkfDtOISvatY7KrsOhZWCNk9JRpLuuh43xzgnFhPqXKmGroDzjQvXPz94GpdEl9G81b2XYi/FMsh+pYLZF9A6fE8t+YSL6S/yYSGnrle6MCO1Af9ff6HP5bkgXQAZ1YAkkFVQEbNMe29iUgPZfSGJcCvHsWJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GpxTrrCh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+TQBIoDT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GpxTrrCh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+TQBIoDT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GpxTrrCh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+TQBIoDT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GpxTrrCh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+TQBIoDT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6061133739;
	Mon, 19 Jan 2026 13:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768827750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hrlNDf5VNjX9ELPfZ+LNgSuS5G7kdtoTlIu/QmH4T64=;
	b=GpxTrrCh4hNsKltNDaOOfHLdTmXmbCbJuybMTEcsUAuVT9J36wmtpIF8EFlMoadWtxXtE2
	ylRzfuhjJ+dA13jLiXffXp/Lv5zHW0Gz2UTyKBcwx4y4O/IZ5qlFd9kjXY+Uktdu6iwwcG
	23vSKEi2y+AUIGf/fZmM1ilG0wCZhmA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768827750;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hrlNDf5VNjX9ELPfZ+LNgSuS5G7kdtoTlIu/QmH4T64=;
	b=+TQBIoDTbAg2GSF0SfNzR8uubCOkCweGgGWruE/Tl6rbCXejkfSYemCINOKyH2tKiSesF7
	oJ0VVgKPmpXyqEBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768827750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hrlNDf5VNjX9ELPfZ+LNgSuS5G7kdtoTlIu/QmH4T64=;
	b=GpxTrrCh4hNsKltNDaOOfHLdTmXmbCbJuybMTEcsUAuVT9J36wmtpIF8EFlMoadWtxXtE2
	ylRzfuhjJ+dA13jLiXffXp/Lv5zHW0Gz2UTyKBcwx4y4O/IZ5qlFd9kjXY+Uktdu6iwwcG
	23vSKEi2y+AUIGf/fZmM1ilG0wCZhmA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768827750;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hrlNDf5VNjX9ELPfZ+LNgSuS5G7kdtoTlIu/QmH4T64=;
	b=+TQBIoDTbAg2GSF0SfNzR8uubCOkCweGgGWruE/Tl6rbCXejkfSYemCINOKyH2tKiSesF7
	oJ0VVgKPmpXyqEBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52B243EA65;
	Mon, 19 Jan 2026 13:02:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wok6E2YrbmlYKAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 19 Jan 2026 13:02:30 +0000
Date: Mon, 19 Jan 2026 14:02:25 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Daniel Wagner <wagi@kernel.org>, Keith Busch <kbusch@kernel.org>, 
	patches@lists.linux.dev, Justin Tee <justin.tee@broadcom.com>, 
	Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.10 219/451] nvme-fc: dont hold rport lock when putting
 ctrl
Message-ID: <ebd16272-73ea-4aad-b603-459841068a2b@flourine.local>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164238.821426188@linuxfoundation.org>
 <21f26a1c5d9b0ddf0320a13bf3625642d506b11d.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21f26a1c5d9b0ddf0320a13bf3625642d506b11d.camel@decadent.org.uk>
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,flourine.local:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

Hi Ben,

On Sat, Jan 17, 2026 at 09:47:30PM +0100, Ben Hutchings wrote:
> > Justin suggested use the safe list iterator variant because
> > nvme_fc_ctrl_put will also modify the rport->list.
> 
> The "safe" list iterator macros do protect against deletion of the
> current node within the loop body, but they assume the next node won't
> also be deleted.
> 
> [...]
> > -	list_for_each_entry(ctrl, &rport->ctrl_list, ctrl_list) {
> > +	list_for_each_entry_safe(ctrl, tmp, &rport->ctrl_list, ctrl_list) {
> >  		if (!nvme_fc_ctrl_get(ctrl))
> >  			continue;
> >  		spin_lock(&ctrl->lock);
> > @@ -1520,7 +1520,9 @@ nvme_fc_match_disconn_ls(struct nvme_fc_rport *rport,
> >  		if (ret)
> >  			/* leave the ctrl get reference */
> >  			break;
> > +		spin_unlock_irqrestore(&rport->lock, flags);
> >  		nvme_fc_ctrl_put(ctrl);
> > +		spin_lock_irqsave(&rport->lock, flags);
> 
> Does anything prevent the next node (*tmp) being removed by another
> thread while the lock is dropped here?

Thanks for looking at this. There is nothing in place to prevent LS
requests running in parallel, e.g. two dissociating controllers LS for
one rport,

	schedule_work(&rport->lsrcv_work)
        nvme_fc_handle_ls_rqst_work
            nvme_fc_handle_ls_rqst
                nvme_fc_ls_disconnect_assoc

What's the proper way to address this? I saw there is a list_safe_reset_next:

	list_for_each_entry_safe(ctrl, tmp, &rport->ctrl_list, ctrl_list) {
        [...]

		spin_unlock_irqrestore(&rport->lock, flags);
		nvme_fc_ctrl_put(ctrl);
		spin_lock_irqsave(&rport->lock, flags);
		list_safe_reset_next(ctrl, tmp, ctrl_list);
	}

Is there another common pattern? Normally, I would use the list swap
approach but here it doesn't work, at least without a lot of changes I
think.

Thanks,
Daniel
