Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBD9246BB0
	for <patches@lists.linux.dev>; Tue, 25 Nov 2025 13:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764078864; cv=none; b=YnEYfxQumu5cbK1g6bRjRgM+3RE51dUvZl4VIM9wNfIiGwCcOed1GVM7VotHXt1Hzav1eCKIiSSq2lkQzz7IOov6k3Hx5ywyCRiCB2iDhD5mdPV15J8KaIjM+lWiQNJl9UOaUTTg1ZqcaqkKh61rT7woEJiy4xt+O6b6xZ7jRmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764078864; c=relaxed/simple;
	bh=HgQTSY5v5mVVFde5AJh9ZexonRSkDxF6J5oBfO5ZNR0=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SlS8ZyFy154fXKydYNEV6gh1zvBw67jBA7NA1aepO4G8pF5gUkq62qw0VkMy6zWXRecaQeMfLp69Aj/2xAODppPpYYooTsheUS5JDEa2VM1C5XB5kGlOOq0i+qYlJ5sHLmC3faEbl4oSQb9Uwb5cg43JXEB0REkU581ndOugbSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WnKJvwZv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MnXfoqoK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WnKJvwZv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MnXfoqoK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WnKJvwZv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MnXfoqoK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WnKJvwZv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MnXfoqoK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5277521C04;
	Tue, 25 Nov 2025 13:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764078861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D1a5QC4G/roBzvdsPps1dfncvjYeH784oT3/41/dP/c=;
	b=WnKJvwZvrLXO7IoSb5lxvEw5LFFdYPbRtlLVKeEPXdpUsr3qAdX++w10po6Z2RtdWuv1pM
	zee1p7AsTVJ+S6A9XHsm36AKt91WqqBrBf1CNgmMQSCnyCBKoNUfb5eu5Y1xH3lkDaM8v0
	vzRQ0DVhL9gBVdl3mmCucgz8xtf5BZU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764078861;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D1a5QC4G/roBzvdsPps1dfncvjYeH784oT3/41/dP/c=;
	b=MnXfoqoKAXBA267SSfevD5p7S0Tpx00wvIqhdO0CinzUByDOyGeIuV+M+ZMOGb6YMJZhDi
	QU3AMKK4IQQM3wAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764078861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D1a5QC4G/roBzvdsPps1dfncvjYeH784oT3/41/dP/c=;
	b=WnKJvwZvrLXO7IoSb5lxvEw5LFFdYPbRtlLVKeEPXdpUsr3qAdX++w10po6Z2RtdWuv1pM
	zee1p7AsTVJ+S6A9XHsm36AKt91WqqBrBf1CNgmMQSCnyCBKoNUfb5eu5Y1xH3lkDaM8v0
	vzRQ0DVhL9gBVdl3mmCucgz8xtf5BZU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764078861;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D1a5QC4G/roBzvdsPps1dfncvjYeH784oT3/41/dP/c=;
	b=MnXfoqoKAXBA267SSfevD5p7S0Tpx00wvIqhdO0CinzUByDOyGeIuV+M+ZMOGb6YMJZhDi
	QU3AMKK4IQQM3wAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C31CC3EA63;
	Tue, 25 Nov 2025 13:54:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qSCMLAy1JWlKQgAAD6G6ig
	(envelope-from <tiwai@suse.de>); Tue, 25 Nov 2025 13:54:20 +0000
Date: Tue, 25 Nov 2025 14:54:20 +0100
Message-ID: <87ecpmp69f.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	tiwai@suse.de,
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
In-Reply-To: <aSWtH0AZH5+aeb+a@duo.ucw.cz>
References: <20251121130143.857798067@linuxfoundation.org>
	<aSWtH0AZH5+aeb+a@duo.ucw.cz>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.1 Mule/6.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-1.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWELVE(0.00)[21];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linuxfoundation.org,suse.de,vger.kernel.org,lists.linux.dev,linux-foundation.org,roeck-us.net,kernel.org,kernelci.org,lists.linaro.org,nvidia.com,gmail.com,gmx.de,microsoft.com,achill.org,sladewatkins.com];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,denx.de:email]
X-Spam-Flag: NO
X-Spam-Score: -1.80

On Tue, 25 Nov 2025 14:20:31 +0100,
Pavel Machek wrote:
> 
> On Fri 2025-11-21 14:10:27, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.59 release.
> > There are 185 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> 
> > Takashi Iwai <tiwai@suse.de>
> >     ALSA: usb-audio: Fix potential overflow of PCM transfer buffer
> 
> This one is wrong for at least 6.12 and older.
> 
> +       if (ep->packsize[1] > ep->maxpacksize) {
> +               usb_audio_dbg(chip, "Too small maxpacksize %u for rate %u / pps %u\n",
> +                             ep->maxpacksize, ep->cur_rate, ep->pps);
> +               return -EINVAL;
> +       }
>  
> Needs to be err = -EINVAL; goto unlock;.
> 
> (Or cherry pick guard() handling from newer kernels).

Thanks Pavel, a good catch!

A cherry-pick of the commit efea7a57370b for converting to guard()
doesn't seem to be cleanly applicable on 6.12.y, unfortunately.
So I guess it'd be easier to have a correction on the top instead,
something like below.


Takashi

-- 8< --
From: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH v6.12.y] ALSA: usb-audio: Fix missing unlock at error path of
 maxpacksize check

The recent backport of the upstream commit 05a1fc5efdd8 ("ALSA:
usb-audio: Fix potential overflow of PCM transfer buffer") on the
older stable kernels like 6.12.y was broken since it doesn't consider
the mutex unlock, where the upstream code manages with guard().
In the older code, we still need an explicit unlock.

This is a fix that corrects the error path, applied only on old stable
trees.

Reported-by: Pavel Machek <pavel@denx.de>
Closes: https://lore.kernel.org/aSWtH0AZH5+aeb+a@duo.ucw.cz
Fixes: 98e9d5e33bda ("ALSA: usb-audio: Fix potential overflow of PCM transfer buffer")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/usb/endpoint.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 7238f65cbcff..aa201e4744bf 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1389,7 +1389,8 @@ int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
 	if (ep->packsize[1] > ep->maxpacksize) {
 		usb_audio_dbg(chip, "Too small maxpacksize %u for rate %u / pps %u\n",
 			      ep->maxpacksize, ep->cur_rate, ep->pps);
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock;
 	}
 
 	/* calculate the frequency in 16.16 format */
-- 
2.52.0

