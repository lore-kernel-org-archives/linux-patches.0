Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0611CAA1;
	Sun, 21 Apr 2024 17:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713720740; cv=none; b=HX57VcqOxniHLbVVnBQ4aFPKH5KQmJ7iK3qarLR1OxmIS2ID1aeSj6aAVUe9jg3kq6B/NDzAw+ZsL/pi16r3cMfeDGmIEKbb852uKT2WddquORI7KAXWhGb1i0BZRKrqJUX/aIUuE+VWgo/6460+kb6+kkmg0g/j7xreoPCw04g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713720740; c=relaxed/simple;
	bh=TwI2qMXYuhhfaiqvQ31qVNyzCDr8DKrAOG+tEu9G14k=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rqr1o/yIumt1XkxgZl8/yVNlvKkos9H8M6NJeijg4JEGgdflpl79rIMgqpdKcIV0VNqiUwE3JjqptNJPvA7FGXzjHTF1owz1Oa7IdQ3rbWyVp/jmpfcpKrNH/NwWYwok0LaPD5uoerVdPHrohGH4LgVnVfP8M9rCriQwPy9yT+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=goY/VTqX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Q7TR+q6L; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=goY/VTqX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Q7TR+q6L; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="goY/VTqX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Q7TR+q6L";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="goY/VTqX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Q7TR+q6L"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0C58C5BE8A;
	Sun, 21 Apr 2024 17:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1713720735; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cQUY+ukk88AS8JHZQuQVE/sQcI8MVSVlq2WdArJBT8M=;
	b=goY/VTqX5KaRsFGcTIHPYjrOCFGEpkWZJtqsjB42hp6e5W/MXJTdbKND1vu4IAuk7zR2tq
	kVJVG/vKaOSJk8BZFRsbKJZXb9yGC7YStSWkAmEuW3tWlLMV6fo8disEI7vsWDpYExAZ9k
	5/QpatQ9QKd27+8mqxEfX3oOHPuwiIA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1713720735;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cQUY+ukk88AS8JHZQuQVE/sQcI8MVSVlq2WdArJBT8M=;
	b=Q7TR+q6Lo6V8GVD7ClDvnOiDr4ie4zbtgb5FA30cVpoqIwkP6CAoM49S+C3xeVKzzWtDZE
	Mmuw31/TwiausEBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1713720735; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cQUY+ukk88AS8JHZQuQVE/sQcI8MVSVlq2WdArJBT8M=;
	b=goY/VTqX5KaRsFGcTIHPYjrOCFGEpkWZJtqsjB42hp6e5W/MXJTdbKND1vu4IAuk7zR2tq
	kVJVG/vKaOSJk8BZFRsbKJZXb9yGC7YStSWkAmEuW3tWlLMV6fo8disEI7vsWDpYExAZ9k
	5/QpatQ9QKd27+8mqxEfX3oOHPuwiIA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1713720735;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cQUY+ukk88AS8JHZQuQVE/sQcI8MVSVlq2WdArJBT8M=;
	b=Q7TR+q6Lo6V8GVD7ClDvnOiDr4ie4zbtgb5FA30cVpoqIwkP6CAoM49S+C3xeVKzzWtDZE
	Mmuw31/TwiausEBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B9CAC13687;
	Sun, 21 Apr 2024 17:32:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 93PhK55NJWY2FAAAD6G6ig
	(envelope-from <tiwai@suse.de>); Sun, 21 Apr 2024 17:32:14 +0000
Date: Sun, 21 Apr 2024 19:32:23 +0200
Message-ID: <87a5lm4o60.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: g@b4.vu,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-sound@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] ALSA: scarlett2: Zero initialize ret in scarlett2_ag_target_ctl_get()
In-Reply-To: <20240419-alsa-scarlett2-fix-wsometimes-uninitialized-v1-1-e2ace8642e08@kernel.org>
References: <20240419-alsa-scarlett2-fix-wsometimes-uninitialized-v1-1-e2ace8642e08@kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -1.24
X-Spam-Level: 
X-Spamd-Result: default: False [-1.24 / 50.00];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	BAYES_HAM(-0.94)[86.47%];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[]

On Sat, 20 Apr 2024 02:25:59 +0200,
Nathan Chancellor wrote:
> 
> Clang warns (or errors with CONFIG_WERROR):
> 
>   sound/usb/mixer_scarlett2.c:3697:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>    3697 |         if (private->autogain_updated) {
>         |             ^~~~~~~~~~~~~~~~~~~~~~~~~
>   sound/usb/mixer_scarlett2.c:3707:9: note: uninitialized use occurs here
>    3707 |         return err;
>         |                ^~~
>   sound/usb/mixer_scarlett2.c:3697:2: note: remove the 'if' if its condition is always true
>    3697 |         if (private->autogain_updated) {
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   sound/usb/mixer_scarlett2.c:3688:9: note: initialize the variable 'err' to silence this warning
>    3688 |         int err;
>         |                ^
>         |                 = 0
>   1 error generated.
> 
> Initialize ret to zero to ensure ret is initialized in all paths within
> scarlett2_ag_target_ctl_get(), which matches the style of other
> functions in this driver.
> 
> Fixes: e30ea5340c25 ("ALSA: scarlett2: Add autogain target controls")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks, applied now.

> ---
> FWIW, a lot of the functions that end in just 'mutex_unlock()' before
> returning could probably benefit from the cleanup.h infrastructure,
> which would help with the scope of err in this particular function, but
> I decided to go with the most minimal fix here.

Yeah, we can clean up lots of such code now.

If it were a new code file, I'd suggest it, but since it was an
extention of the existing code, I accepted as is.


thanks,

Takashi
