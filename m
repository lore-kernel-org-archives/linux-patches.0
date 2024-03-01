Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EDA443E;
	Fri,  1 Mar 2024 17:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709313096; cv=none; b=ZpAtV3xZas32rbBsxoXrWnEXMr7V0kOCMuwhT+WyW6henK3tJ8k9wRYicG+V9SWB7Njnh9Vyssg0nwrDZuAkPtIU92srPOVIGRnaT7LD7hV8mRL1OueEs12NDJhqHLLD95MyGZRW6VdH+20Ycc8ZF/1Ahl4n4uHwwqzUmv1cD0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709313096; c=relaxed/simple;
	bh=0eG27HJGmrzviSUU2df5ixSbDPnF01WArbSDUl6VEG8=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TxNUnooWiFqceC4ZC/OES7tRmktE1wiN2aUgV9UWt+H8CZOvL6pcuUYCAl+P1A2uis2AFdMt5wHL0K4rDqEDhGKAtkYXSBdKFjpOD1VwaPC3bwWW2/iLeoarnnnaXkOklpXueobgo/K8gGGMYdrrqLj0Lu+Z4JoZvNVTpIQp8JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=p5xO09hi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kgknxri9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=p5xO09hi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kgknxri9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="p5xO09hi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kgknxri9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="p5xO09hi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kgknxri9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9ECD7207BD;
	Fri,  1 Mar 2024 17:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709313092; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5j2kPwBVd8O0rTERYRu6JHTM9sYfIkLnP/XLHk1BXms=;
	b=p5xO09hi1M8YlWk0elFETz1Dq19+erWRhJ+94BvJQLIEYy1m8MTTW1wpKF2296OSIYi+dW
	oSOYIYM8bzIbmCFRCpYAtpIXqSSBzjf6INhV72fG8c2KtElpx8HDnSjWW4a494uMaUdR6O
	CW1vnwjJbwx8hdjx5bvKcTkbbUEfFXI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709313092;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5j2kPwBVd8O0rTERYRu6JHTM9sYfIkLnP/XLHk1BXms=;
	b=kgknxri9KiFwFhbAFPfeXtifzjFS3thkwiDfqzuLGuuXPGoBBD6/77D/xdhZ5X476/mpd+
	S913cgbCZZ/wHfDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709313092; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5j2kPwBVd8O0rTERYRu6JHTM9sYfIkLnP/XLHk1BXms=;
	b=p5xO09hi1M8YlWk0elFETz1Dq19+erWRhJ+94BvJQLIEYy1m8MTTW1wpKF2296OSIYi+dW
	oSOYIYM8bzIbmCFRCpYAtpIXqSSBzjf6INhV72fG8c2KtElpx8HDnSjWW4a494uMaUdR6O
	CW1vnwjJbwx8hdjx5bvKcTkbbUEfFXI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709313092;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5j2kPwBVd8O0rTERYRu6JHTM9sYfIkLnP/XLHk1BXms=;
	b=kgknxri9KiFwFhbAFPfeXtifzjFS3thkwiDfqzuLGuuXPGoBBD6/77D/xdhZ5X476/mpd+
	S913cgbCZZ/wHfDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5718213A59;
	Fri,  1 Mar 2024 17:11:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NsXKE0QM4mVNGgAAD6G6ig
	(envelope-from <tiwai@suse.de>); Fri, 01 Mar 2024 17:11:32 +0000
Date: Fri, 01 Mar 2024 18:11:31 +0100
Message-ID: <874jdp5130.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: perex@perex.cz,
	tiwai@suse.com,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com,
	linux-sound@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] ALSA: hwdep: Move put_user() call out of scoped_guard() in snd_hwdep_control_ioctl()
In-Reply-To: <20240301-fix-snd-hwdep-guard-v1-1-6aab033f3f83@kernel.org>
References: <20240301-fix-snd-hwdep-guard-v1-1-6aab033f3f83@kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
Authentication-Results: smtp-out2.suse.de;
	none
X-Spamd-Result: default: False [-2.10 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 RCPT_COUNT_SEVEN(0.00)[9];
	 MID_CONTAINS_FROM(1.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -2.10

On Fri, 01 Mar 2024 18:08:22 +0100,
Nathan Chancellor wrote:
> 
> Clang prior to 17.0.0 has a bug in its asm goto jump scope analysis to
> determine that no variables with the cleanup attribute are skipped by an
> indirect jump. Instead of only checking the scope of each label that is
> a possible target of each asm goto statement, it checks the scope of
> every label, which can cause an error when a variable with the cleanup
> attribute is used between two asm goto statements with different scopes,
> even if they have completely different label targets:
> 
>   sound/core/hwdep.c:273:8: error: cannot jump from this asm goto statement to one of its possible targets
>                           if (get_user(device, (int __user *)arg))
>                               ^
>   arch/powerpc/include/asm/uaccess.h:295:5: note: expanded from macro 'get_user'
>                     __get_user(x, _gu_addr) :                             \
>                     ^
>   arch/powerpc/include/asm/uaccess.h:283:2: note: expanded from macro '__get_user'
>           __get_user_size_allowed(__gu_val, __gu_addr, __gu_size, __gu_err);      \
>           ^
>   arch/powerpc/include/asm/uaccess.h:199:3: note: expanded from macro '__get_user_size_allowed'
>                   __get_user_size_goto(x, ptr, size, __gus_failed);       \
>                   ^
>   arch/powerpc/include/asm/uaccess.h:187:10: note: expanded from macro '__get_user_size_goto'
>           case 1: __get_user_asm_goto(x, (u8 __user *)ptr, label, "lbz"); break;  \
>                   ^
>   arch/powerpc/include/asm/uaccess.h:158:2: note: expanded from macro '__get_user_asm_goto'
>           asm_volatile_goto(                                      \
>           ^
>   include/linux/compiler_types.h:366:33: note: expanded from macro 'asm_volatile_goto'
>   #define asm_volatile_goto(x...) asm goto(x)
>                                   ^
>   sound/core/hwdep.c:291:9: note: possible target of asm goto statement
>                                   if (put_user(device, (int __user *)arg))
>                                       ^
>   arch/powerpc/include/asm/uaccess.h:66:5: note: expanded from macro 'put_user'
>                     __put_user(x, _pu_addr) : -EFAULT;                    \
>                     ^
>   arch/powerpc/include/asm/uaccess.h:52:9: note: expanded from macro '__put_user'
>                                                                   \
>                                                                   ^
>   sound/core/hwdep.c:276:4: note: jump bypasses initialization of variable with __attribute__((cleanup))
>                           scoped_guard(mutex, &register_mutex) {
>                           ^
>   include/linux/cleanup.h:169:20: note: expanded from macro 'scoped_guard'
>           for (CLASS(_name, scope)(args),                                 \
> 
> To avoid this issue, move the put_user() call out of the scoped_guard()
> scope, which allows the asm goto scope analysis to see that the variable
> with the cleanup attribute will never be skipped by the asm goto
> statements.
> 
> There should be no functional change because prior to the refactoring,
> put_user() was not called under register_mutex, so this call does not
> even need to be in the scoped_guard() in the first place.
> 
> Fixes: e6684d08cc19 ("ALSA: hwdep: Use guard() for locking")
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2003
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Applied now.  Thanks!


Takashi
