Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26D726ED4A
	for <patches@lists.linux.dev>; Wed, 26 Nov 2025 10:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764151622; cv=none; b=Ecul8+FhU/PlvMBJWr8FTKSQlgDfeEkHlI3ititwAJaNNP4IZaJ+fqB4rA9QefiqFPKz7JJ9YKxZiP0NlCXX8hz3I9jvD+lYEsuHdbLZ7rxB72arPSNsYzLr5w0ra6FToyjszGLC7uj7044FkIQvyOtyJE1UavPsrUyoHhn5u5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764151622; c=relaxed/simple;
	bh=a2KlWyNpN56rBzDMBGgYTs1Rg8LPCWB6zxYC+nyIm48=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VFkmOU+eTJ0T7vGdp+FiBZhAnxdjgHboBRRrfLBZW/mSlEvLlz62WoboDQwfI3y8G/Rfxtt5khB1LebYU7jskS4ynVB2C2H0hq4PFUirDPmDnHgJhJ4osiXkqFCsk89CqasCjGEmIQE8wXAM6FaYRR1nfvt9V1ubcpmX4aZHgyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0rL5oWNI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rP99+QzQ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0rL5oWNI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rP99+QzQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0rL5oWNI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rP99+QzQ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0rL5oWNI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rP99+QzQ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9E2135BE1B;
	Wed, 26 Nov 2025 10:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764151616; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sF8OzPG2wek3EEXkvuvVsydbOdkxjvT803vX2XgXT5U=;
	b=0rL5oWNIZ3UmZpf3wY6oxJM0WtNSzEXQse40FZSkatZFlkic8JpAlCbtWcBD6a9TXb7Asi
	uaUpn4NtyFfXwd8nWHSTtLDIpdmrkTRLDtYFhpGizUKrfWnJJE+togbbcgD5pBSTfeV3ek
	3oUIdreniUAsDNmQ0miW4Zczb/Lws5U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764151616;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sF8OzPG2wek3EEXkvuvVsydbOdkxjvT803vX2XgXT5U=;
	b=rP99+QzQY2OrhKd0cjA62r95AN+tZPELeXYF/1B5AdSSli61P7si3W5CaH7RVxmRVJTdtP
	buzYDFOe6OwPv8Aw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0rL5oWNI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rP99+QzQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764151616; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sF8OzPG2wek3EEXkvuvVsydbOdkxjvT803vX2XgXT5U=;
	b=0rL5oWNIZ3UmZpf3wY6oxJM0WtNSzEXQse40FZSkatZFlkic8JpAlCbtWcBD6a9TXb7Asi
	uaUpn4NtyFfXwd8nWHSTtLDIpdmrkTRLDtYFhpGizUKrfWnJJE+togbbcgD5pBSTfeV3ek
	3oUIdreniUAsDNmQ0miW4Zczb/Lws5U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764151616;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sF8OzPG2wek3EEXkvuvVsydbOdkxjvT803vX2XgXT5U=;
	b=rP99+QzQY2OrhKd0cjA62r95AN+tZPELeXYF/1B5AdSSli61P7si3W5CaH7RVxmRVJTdtP
	buzYDFOe6OwPv8Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B7933EA63;
	Wed, 26 Nov 2025 10:06:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G5hxCUDRJmkGOgAAD6G6ig
	(envelope-from <tiwai@suse.de>); Wed, 26 Nov 2025 10:06:56 +0000
Date: Wed, 26 Nov 2025 11:06:55 +0100
Message-ID: <87ikexaz0g.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Pavel Machek <pavel@denx.de>
Cc: Takashi Iwai <tiwai@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/185] 6.12.59-rc1 review
In-Reply-To: <aSbP77sRVyWjXxWC@duo.ucw.cz>
References: <20251121130143.857798067@linuxfoundation.org>
	<aSWtH0AZH5+aeb+a@duo.ucw.cz>
	<87ecpmp69f.wl-tiwai@suse.de>
	<aSbP77sRVyWjXxWC@duo.ucw.cz>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.1 Mule/6.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 9E2135BE1B
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-2.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	FREEMAIL_CC(0.00)[suse.de,linuxfoundation.org,vger.kernel.org,lists.linux.dev,linux-foundation.org,roeck-us.net,kernel.org,kernelci.org,lists.linaro.org,nvidia.com,gmail.com,gmx.de,microsoft.com,achill.org,sladewatkins.com];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email]
X-Spam-Score: -2.01

On Wed, 26 Nov 2025 11:01:19 +0100,
Pavel Machek wrote:
> 
> Hi!
> 
> > > > Takashi Iwai <tiwai@suse.de>
> > > >     ALSA: usb-audio: Fix potential overflow of PCM transfer buffer
> > > 
> > > This one is wrong for at least 6.12 and older.
> > > 
> > > +       if (ep->packsize[1] > ep->maxpacksize) {
> > > +               usb_audio_dbg(chip, "Too small maxpacksize %u for rate %u / pps %u\n",
> > > +                             ep->maxpacksize, ep->cur_rate, ep->pps);
> > > +               return -EINVAL;
> > > +       }
> > >  
> > > Needs to be err = -EINVAL; goto unlock;.
> > > 
> > > (Or cherry pick guard() handling from newer kernels).
> > 
> > Thanks Pavel, a good catch!
> > 
> > A cherry-pick of the commit efea7a57370b for converting to guard()
> > doesn't seem to be cleanly applicable on 6.12.y, unfortunately.
> > So I guess it'd be easier to have a correction on the top instead,
> > something like below.
> 
> Yes, works for me, thanks for handling this.
> 
> > -- 8< --
> > From: Takashi Iwai <tiwai@suse.de>
> > Subject: [PATCH v6.12.y] ALSA: usb-audio: Fix missing unlock at error path of
> >  maxpacksize check
> > 
> > The recent backport of the upstream commit 05a1fc5efdd8 ("ALSA:
> > usb-audio: Fix potential overflow of PCM transfer buffer") on the
> > older stable kernels like 6.12.y was broken since it doesn't consider
> > the mutex unlock, where the upstream code manages with guard().
> > In the older code, we still need an explicit unlock.
> > 
> > This is a fix that corrects the error path, applied only on old stable
> > trees.
> > 
> > Reported-by: Pavel Machek <pavel@denx.de>
> > Closes: https://lore.kernel.org/aSWtH0AZH5+aeb+a@duo.ucw.cz
> > Fixes: 98e9d5e33bda ("ALSA: usb-audio: Fix potential overflow of PCM transfer buffer")
> > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> Reviewed-by: Pavel Machek <pavel@denx.de>

OK, will submit properly.


thanks,

Takashi
