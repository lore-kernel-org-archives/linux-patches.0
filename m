Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D313E34EEF3
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 16:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779128; cv=none; b=VobYHOvH2FgtLg0ZYhV+fxsAXrT5c7j29oXdjBJ2q/b3fryzEaDLKH7P6Tw6YQYmW3dM5pWcX92ChyyaEt8SGUwl0lyblhS/b1EN1a+T99OmxdFP9wU3YR7wWwwOIBKWIKqP6Vt3T3u8OH1LN26WliCgDhzeg0oG86P4oLqgCWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779128; c=relaxed/simple;
	bh=kRtZt2+xC3jiWLOR6EQNf0RED6xeCCW7ZCYxEDIHAlA=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PEVSWTCAlOy9anrK9CUpVVuZOlFptQnL5WQn5q0c6Tyiu/npZuCRB+p0QEjf/Em9NunMHFmLxf9U+XOYzJMKdNKW2gmoy+fwciUQyPrjTyR50z6VTkx7rvTvT8LGxzh5ivb1+y7AcQdJQ9+dzbo2HPpAUnsD/PnJKYauLVa7ovo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HWntTxFG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=luALAtNN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=A9EmrxSR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TNorrLWd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HWntTxFG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="luALAtNN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="A9EmrxSR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TNorrLWd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 67D0B336F0;
	Wed,  3 Dec 2025 16:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764779122; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PJsGlmKUmNCUFu/ai9KmssCBkH1xCYbK1kcPiYz9Ml8=;
	b=HWntTxFGofhEQeKmKiDhblxMDg1qeaZXqHkVCGopdv2qao8XsDGLGSM59UGzprOrPcfPtp
	ZgmPmRr4vQixu4YniA43Bwld3uIoOGr/xd+1llJ/bncFbKKO7gUk0zAkNxhokAliDHYlog
	A8noKM1QnuSNCRta4bCrSIY2d9rCglo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764779122;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PJsGlmKUmNCUFu/ai9KmssCBkH1xCYbK1kcPiYz9Ml8=;
	b=luALAtNNXLsDgw8GaFkeWjyvaFY00LTq+DPntledOnE6WsjDuSTd648VRzKISeiB9kKyiy
	0Ua543DPbroAudBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=A9EmrxSR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TNorrLWd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764779121; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PJsGlmKUmNCUFu/ai9KmssCBkH1xCYbK1kcPiYz9Ml8=;
	b=A9EmrxSRswXd6sU8X399spT7Ejaq6QEMfh2yFpeWRP5EZT4Xd/K5IQOWyPF5ntwh5kmwm7
	ykzsiu16PcIdV9E0AHeK5ELuknga2kdtrW3jSiu8eeno3HdFqHovg6ami4/koMDDaCZ0DX
	rnV1HgcGuqzMCIgSvOpERnPbrY/Ruck=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764779121;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PJsGlmKUmNCUFu/ai9KmssCBkH1xCYbK1kcPiYz9Ml8=;
	b=TNorrLWd8OQIsJ6LqoX6gcW6q1krILp7sYg0eqLPJGVx0U3RldpXEk/bj00Sg1TPqCeNpI
	DLsmcn8vA4GIjjAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 363073EA63;
	Wed,  3 Dec 2025 16:25:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id onsIDHFkMGmfEQAAD6G6ig
	(envelope-from <tiwai@suse.de>); Wed, 03 Dec 2025 16:25:21 +0000
Date: Wed, 03 Dec 2025 17:25:20 +0100
Message-ID: <87ecpbsfbj.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,
	patches@lists.linux.dev,
	syzbot+bfd77469c8966de076f7@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 5.15 276/392] ALSA: usb-audio: Fix potential overflow of PCM transfer buffer
In-Reply-To: <20251203152424.319007924@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
	<20251203152424.319007924@linuxfoundation.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.1 Mule/6.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -2.01
X-Rspamd-Queue-Id: 67D0B336F0
X-Spamd-Result: default: False [-2.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[bfd77469c8966de076f7];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[msgid.link:url,syzkaller.appspot.com:url,linuxfoundation.org:email,appspotmail.com:email,windriver.com:email,suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

On Wed, 03 Dec 2025 16:27:06 +0100,
Greg Kroah-Hartman wrote:
> 
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Takashi Iwai <tiwai@suse.de>
> 
> commit 05a1fc5efdd8560f34a3af39c9cf1e1526cc3ddf upstream.
> 
> The PCM stream data in USB-audio driver is transferred over USB URB
> packet buffers, and each packet size is determined dynamically.  The
> packet sizes are limited by some factors such as wMaxPacketSize USB
> descriptor.  OTOH, in the current code, the actually used packet sizes
> are determined only by the rate and the PPS, which may be bigger than
> the size limit above.  This results in a buffer overflow, as reported
> by syzbot.
> 
> Basically when the limit is smaller than the calculated packet size,
> it implies that something is wrong, most likely a weird USB
> descriptor.  So the best option would be just to return an error at
> the parameter setup time before doing any further operations.
> 
> This patch introduces such a sanity check, and returns -EINVAL when
> the packet size is greater than maxpacksize.  The comparison with
> ep->packsize[1] alone should suffice since it's always equal or
> greater than ep->packsize[0].
> 
> Reported-by: syzbot+bfd77469c8966de076f7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=bfd77469c8966de076f7
> Link: https://lore.kernel.org/690b6b46.050a0220.3d0d33.0054.GAE@google.com
> Cc: Lizhi Xu <lizhi.xu@windriver.com>
> Cc: <stable@vger.kernel.org>
> Link: https://patch.msgid.link/20251109091211.12739-1-tiwai@suse.de
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  sound/usb/endpoint.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- a/sound/usb/endpoint.c
> +++ b/sound/usb/endpoint.c
> @@ -1374,6 +1374,11 @@ int snd_usb_endpoint_set_params(struct s
>  	ep->sample_rem = ep->cur_rate % ep->pps;
>  	ep->packsize[0] = ep->cur_rate / ep->pps;
>  	ep->packsize[1] = (ep->cur_rate + (ep->pps - 1)) / ep->pps;
> +	if (ep->packsize[1] > ep->maxpacksize) {
> +		usb_audio_dbg(chip, "Too small maxpacksize %u for rate %u / pps %u\n",
> +			      ep->maxpacksize, ep->cur_rate, ep->pps);
> +		return -EINVAL;
> +	}
>  
>  	/* calculate the frequency in 16.16 format */
>  	ep->freqm = ep->freqn;

This backport requires a similar workaround done for 6.12.y for the
unbalanced mutex lock, the downstream commit fdf0dc82eb60
    ALSA: usb-audio: Fix missing unlock at error path of maxpacksize check

It seems that 5.10.y doesn't need the workaround as it has no mutex
lock applied around it.


thanks,

Takashi
