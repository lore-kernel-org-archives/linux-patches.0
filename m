Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0322773E6
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 07:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760081955; cv=none; b=KyKGSPtbdTqT7+Lq8IalYWLKQZeP1rpbGcK2GCQ122Okp6a+RDAbmt4YOrABC+ESF1ruPVdaCV+FBSmai7Vow+guW65Pitrf46/JgWnoq7quLMWvXeyESSksTek+iV1iMWQMDeuf5fgGvrqm+WB7CZp9IM160JNLcz+GLRkS1VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760081955; c=relaxed/simple;
	bh=kT9YVemjzzhAAN5e2M0Qz7Wi09RuV71T6B1Sb/HtrtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=emh2E54Y2CEONMhaCfe0nGwdKHCGV8JlJCg2MS15hHBC+BxgLIAIGbGgezqBmlGBO/EAitkWIQUYIWdpQ1Hlj9UOdQY5GGoGHOQykQApPy7T0fmjIocYyuNIH2XhtJ9ZTRpBzPlbdCRXYVApgG2/WrbdE7mq1gJpJoKAe+1ywsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JnEPpBhB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wBiK3mBo; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=w8XVwUaj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wDm94fF2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JnEPpBhB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wBiK3mBo";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="w8XVwUaj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wDm94fF2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B72BE22023;
	Fri, 10 Oct 2025 07:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760081950; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PXUUf9UPJHpPGdwbQIJ6NG0AXh/4W4yjOiF3IUrv3io=;
	b=JnEPpBhBRkLDQLxGm38oa40reqYWKwK/Epg4HN8+IQPG60qwmfYrNw23aTdUsmNWhtMUrX
	E9Z/2i+mBDeevyI8qyvvnsS+fRXQd+VsstC9gIwx9Iwilo3rICX2jZnL3DQMFLuVKg1eC6
	PZaG3yLkrO58GzhcL9pODsZixjQWav8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760081950;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PXUUf9UPJHpPGdwbQIJ6NG0AXh/4W4yjOiF3IUrv3io=;
	b=wBiK3mBoKAjKKGhsFKUuOPOK31RPXNQJlmBtrJNy1H1aF28gt88atoJ7+aP2yo18zNZpNh
	9lMtbpZy6jqC0aDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w8XVwUaj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wDm94fF2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760081949; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PXUUf9UPJHpPGdwbQIJ6NG0AXh/4W4yjOiF3IUrv3io=;
	b=w8XVwUaj/92adQTwbZl9cDyYYNRSyM6XqECEKyfK7mfGXr+VlaZ+9eXlGtlMqkn2XeJcqk
	zEgD+ZxxQxvJAIYifv+MIikppJZ6IyAsvTQ0x4w7ByEBamvHaFTfG/bcbyN+iNKTL2KeMg
	l70nYfAnFclvEnWOiCB3Cw5ScLCKeyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760081949;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PXUUf9UPJHpPGdwbQIJ6NG0AXh/4W4yjOiF3IUrv3io=;
	b=wDm94fF2fD8MG0lDX7ES+YOL+du7Ng4hR9btpwIrN17JAjX1K203U+UDNftq5PRAqbhzXY
	tw4pOzYybD0tKdBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4C2C1375D;
	Fri, 10 Oct 2025 07:39:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dr48Jx246GhVBwAAD6G6ig
	(envelope-from <dwagner@suse.de>); Fri, 10 Oct 2025 07:39:09 +0000
Date: Fri, 10 Oct 2025 09:39:05 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	Daniel Wagner <wagi@kernel.org>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
	Hannes Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>, justin.tee@broadcom.com, 
	nareshgottumukkala83@gmail.com, paul.ely@broadcom.com, sagi@grimberg.me, kch@nvidia.com, 
	linux-nvme@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 6.17-5.15] nvmet-fc: avoid scheduling association
 deletion twice
Message-ID: <8bed9f7a-ad84-40e8-a275-09b19a917155@flourine.local>
References: <20251009155752.773732-1-sashal@kernel.org>
 <20251009155752.773732-15-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009155752.773732-15-sashal@kernel.org>
X-Rspamd-Queue-Id: B72BE22023
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,kernel.org,wdc.com,suse.de,broadcom.com,gmail.com,grimberg.me,nvidia.com,lists.infradead.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,wdc.com:email,suse.de:email,suse.de:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

Hi Sasha,

On Thu, Oct 09, 2025 at 11:54:41AM -0400, Sasha Levin wrote:
> From: Daniel Wagner <wagi@kernel.org>
> 
> [ Upstream commit f2537be4f8421f6495edfa0bc284d722f253841d ]
> 
> When forcefully shutting down a port via the configfs interface,
> nvmet_port_subsys_drop_link() first calls nvmet_port_del_ctrls() and
> then nvmet_disable_port(). Both functions will eventually schedule all
> remaining associations for deletion.
> 
> The current implementation checks whether an association is about to be
> removed, but only after the work item has already been scheduled. As a
> result, it is possible for the first scheduled work item to free all
> resources, and then for the same work item to be scheduled again for
> deletion.
> 
> Because the association list is an RCU list, it is not possible to take
> a lock and remove the list entry directly, so it cannot be looked up
> again. Instead, a flag (terminating) must be used to determine whether
> the association is already in the process of being deleted.
> 
> Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Closes: https://lore.kernel.org/all/rsdinhafrtlguauhesmrrzkybpnvwantwmyfq2ih5aregghax5@mhr7v3eryci3/
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This patch is part of a whole series:

https://lore.kernel.org/all/20250902-fix-nvmet-fc-v3-0-1ae1ecb798d8@kernel.org/

IMO, all should all be backported:

db5a5406fb7e nvmet-fc: move lsop put work to nvmet_fc_ls_req_op
f2537be4f842 nvmet-fc: avoid scheduling association deletion twice
10c165af35d2 nvmet-fcloop: call done callback even when remote port is gone
891cdbb162cc nvme-fc: use lock accessing port_state and rport state

Thanks,
Daniel
