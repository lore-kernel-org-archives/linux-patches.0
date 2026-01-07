Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA053BB4A
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 08:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767773115; cv=none; b=X7SVbLdjZaE2Jn9JffQCg3Y5fiRiElDpK5oMmKRklWVJX9ZMv2PfOi4uJ9hOXo0f8/jyW9kchqp0LrhiXz+j5VrSjEsiNeIb+321tqSVjX2uZkZ9kDk45O5GoZDahvdthrcA8/x9NTQvrUz7dLkgpH+Rie5BEykq9JTwy3T6w8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767773115; c=relaxed/simple;
	bh=xHllFBFUlqwO9t0eAvqYTg9WJll2vY0hzxsQKnhIlxg=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d7fUqjaQf15v+9S3L8dRU9iXxbbsXGAFIN8dc2O5bBk11EGckJUtXSHzU/6I49gzrcf9aWhhhJ6suZM/98yHDzwuaDe77Zmi+BloJy2VrjhV+Izz49g/L8sPQYp5CIQOu5CYStV/0dzakQTy10c9UAtlzK4Rs7+bGlMKkRbswyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hW5uosiX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UR/FsX+/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hW5uosiX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UR/FsX+/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hW5uosiX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UR/FsX+/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hW5uosiX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UR/FsX+/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 859FE33AF2;
	Wed,  7 Jan 2026 08:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767773111; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jD09M/XJzsS6gONTWnJUHOB1Hx0G1Mtqz242EBUvEmE=;
	b=hW5uosiXriRQ2Lzvw3G12+ZtWw0/ODqBX8wrsAPcDDWR1dY0O6zjQ2tGTFWDWJ+KZNDtQD
	KVkj0IysN8iRRCNAEeRex9/w+/Tq7hrHpCpoqsQDHvWe0YUeUoG7XdWFCXOFSeJxN/jlnS
	SUo28PIhRugOuc2UrHNmXqomSRyFKIw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767773111;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jD09M/XJzsS6gONTWnJUHOB1Hx0G1Mtqz242EBUvEmE=;
	b=UR/FsX+/JdSxAs9ksYmZf9HrYNG3gcYOoxzYt8gYDQFVOY5yK3FPhjLyUPgQkC8/K1gKAs
	sWcj21gaSlxzShDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hW5uosiX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="UR/FsX+/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767773111; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jD09M/XJzsS6gONTWnJUHOB1Hx0G1Mtqz242EBUvEmE=;
	b=hW5uosiXriRQ2Lzvw3G12+ZtWw0/ODqBX8wrsAPcDDWR1dY0O6zjQ2tGTFWDWJ+KZNDtQD
	KVkj0IysN8iRRCNAEeRex9/w+/Tq7hrHpCpoqsQDHvWe0YUeUoG7XdWFCXOFSeJxN/jlnS
	SUo28PIhRugOuc2UrHNmXqomSRyFKIw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767773111;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jD09M/XJzsS6gONTWnJUHOB1Hx0G1Mtqz242EBUvEmE=;
	b=UR/FsX+/JdSxAs9ksYmZf9HrYNG3gcYOoxzYt8gYDQFVOY5yK3FPhjLyUPgQkC8/K1gKAs
	sWcj21gaSlxzShDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 37BAE3EA63;
	Wed,  7 Jan 2026 08:05:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id p8xWDLcTXmllSAAAD6G6ig
	(envelope-from <tiwai@suse.de>); Wed, 07 Jan 2026 08:05:11 +0000
Date: Wed, 07 Jan 2026 09:05:10 +0100
Message-ID: <87jyxtetl5.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-sound@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] ALSA: pcm: Revert bufs move in snd_pcm_xfern_frames_ioctl()
In-Reply-To: <20260106-pcm_native-revert-var-move-free-for-old-clang-v1-1-06a03693423d@kernel.org>
References: <20260106-pcm_native-revert-var-move-free-for-old-clang-v1-1-06a03693423d@kernel.org>
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
X-Rspamd-Queue-Id: 859FE33AF2
X-Spamd-Result: default: False [-2.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[perex.cz,suse.com,gmail.com,google.com,vger.kernel.org,lists.linux.dev,intel.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[lkml];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

On Wed, 07 Jan 2026 00:08:18 +0100,
Nathan Chancellor wrote:
> 
> When building with clang older than 17 targeting architectures that use
> asm goto for their get_user() and put_user(), such as arm64, after
> commit f3d233daf011 ("ALSA: pcm: Relax __free() variable declarations"),
> there are bogus errors around skipping over a variable declared with the
> cleanup attribute:
> 
>   sound/core/pcm_native.c:3308:6: error: cannot jump from this asm goto statement to one of its possible targets
>           if (put_user(result, &_xfern->result))
>               ^
>   ...
>   arch/arm64/include/asm/uaccess.h:298:2: note: expanded from macro '__put_mem_asm'
>           asm goto(
>           ^
>   sound/core/pcm_native.c:3295:6: note: possible target of asm goto statement
>           if (put_user(0, &_xfern->result))
>               ^
>   ...
>   sound/core/pcm_native.c:3300:8: note: jump exits scope of variable with __attribute__((cleanup))
>           void *bufs __free(kfree) =
>                 ^
> 
> clang-17 fixed a bug in clang's jump scope checker [1] where all labels
> in a function were checked as valid targets for all asm goto instances
> in a function, regardless of whether they were actual targets in a
> paricular asm goto's provided list of labels.
> 
> To workaround this, revert the change done to
> snd_pcm_xfern_frames_ioctl() by commit f3d233daf011 ("ALSA: pcm: Relax
> __free() variable declarations") to avoid a variable declared with
> cleanup from existing between multiple uses of asm goto. There are no
> other uses of cleanup in this function so there should be low risk from
> moving this variable back to the top of the function.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1886 [1]
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202512190802.i4Jzbcsl-lkp@intel.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

I hoped that this mess is addressed in the put_user() side, but it
doesn't seem happening, so I took your workaround now.


thanks,

Takashi
