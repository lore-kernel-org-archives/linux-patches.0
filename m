Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B713148CD
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 16:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780498; cv=none; b=qrIBh5IzXIhVTCmZ+2FNv9ImLEtg/tyyWV8GrEjiyjzRKeAgx8WSam8uYcXgp8kb30ir+QdhBrma6BxThWU9PDJaHXjqNlp73Uj3LADCY7JrJisQ3QDaPYebOMHaX0mxjczymlow2BOHASfk22TsplvNBqVbJRh3JJpApZheZWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780498; c=relaxed/simple;
	bh=oxau6eDveYWaz/EjGdZfCMTH0+2DX3glMxo4bJIV3yk=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C5a0+G0/YxNYGneenF9sYVTEO4xLtkqGb6NqQTLP1BeLTBFu3DQ0JPr+k65HxVMvCKs/25AAIsofEp/6Ua//smh9xI8+Nsm88iFFz6fR0R05XkKnIlx171J+Nd6MkpdmBpRaP2E+9Q4YmuBqQF9ec0jvoG1nekqfr5SU6aUyBl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=n9xuJeZh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tB+sKH98; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=n9xuJeZh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tB+sKH98; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="n9xuJeZh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tB+sKH98";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="n9xuJeZh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tB+sKH98"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 07B8A33724;
	Wed,  3 Dec 2025 16:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764780494; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I+s/foWkzpPy6jsmhSOz94twtb5X2L/oL9LWMEW7BFs=;
	b=n9xuJeZhmQAe8ry7hikcCzzm5vkT7PrOEPES/RR3glrPl1SkJYmfx+9laRrqOG7hAZumJ5
	Sn9JV0P/CNic3ID1sU6nY+Sme82OZGwxbN+qtw55S099cspOGhr3MkbCM+XgCDrejsxTmp
	FqHYy9/z7Xc0DDF8mAwMYO+iygf+yAY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764780494;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I+s/foWkzpPy6jsmhSOz94twtb5X2L/oL9LWMEW7BFs=;
	b=tB+sKH98XYhQr9EHhnURbCRa6Mmf9ZTlwsQaa89Ohz9lhag4nKliMekKxYAH+qFzEiZSE1
	sTYkQRAuauPURoDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=n9xuJeZh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tB+sKH98
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764780494; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I+s/foWkzpPy6jsmhSOz94twtb5X2L/oL9LWMEW7BFs=;
	b=n9xuJeZhmQAe8ry7hikcCzzm5vkT7PrOEPES/RR3glrPl1SkJYmfx+9laRrqOG7hAZumJ5
	Sn9JV0P/CNic3ID1sU6nY+Sme82OZGwxbN+qtw55S099cspOGhr3MkbCM+XgCDrejsxTmp
	FqHYy9/z7Xc0DDF8mAwMYO+iygf+yAY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764780494;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I+s/foWkzpPy6jsmhSOz94twtb5X2L/oL9LWMEW7BFs=;
	b=tB+sKH98XYhQr9EHhnURbCRa6Mmf9ZTlwsQaa89Ohz9lhag4nKliMekKxYAH+qFzEiZSE1
	sTYkQRAuauPURoDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D07253EA63;
	Wed,  3 Dec 2025 16:48:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RMi+Mc1pMGkNJgAAD6G6ig
	(envelope-from <tiwai@suse.de>); Wed, 03 Dec 2025 16:48:13 +0000
Date: Wed, 03 Dec 2025 17:48:13 +0100
Message-ID: <878qfjse9e.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,
	patches@lists.linux.dev,
	syzbot+bfd77469c8966de076f7@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 6.1 406/568] ALSA: usb-audio: Fix potential overflow of PCM transfer buffer
In-Reply-To: <20251203152455.557940099@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
	<20251203152455.557940099@linuxfoundation.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.1 Mule/6.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
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
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[bfd77469c8966de076f7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,appspotmail.com:email,syzkaller.appspot.com:url,suse.de:email,suse.de:dkim,suse.de:mid,msgid.link:url,windriver.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: 07B8A33724
X-Spam-Flag: NO
X-Spam-Score: -2.01

On Wed, 03 Dec 2025 16:26:48 +0100,
Greg Kroah-Hartman wrote:
> 
> 6.1-stable review patch.  If anyone has any objections, please let me know.
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
> @@ -1379,6 +1379,11 @@ int snd_usb_endpoint_set_params(struct s
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

This one requires the same workaround again, just as mentioned for
5.15.y:
  https://lore.kernel.org/87ecpbsfbj.wl-tiwai@suse.de 


thanks,

Takashi
