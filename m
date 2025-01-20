Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB43C1E1A1F;
	Mon, 20 Jan 2025 13:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737380493; cv=none; b=s2Vs7+IxRL6ri+/QmdncHyyXwb+pvr0z17npvmtw8Yt1k1IKrUuxFSLvHOsab2rStnKR1EBQ6W+RsicNe9b7sUfPMIR1YOCg27ha5bi0VyN9k+IytkIqLmsyXOQurLMnLj4s7BEIUglm3dYosqBoo9DwtrwbRCeobYHa66GglrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737380493; c=relaxed/simple;
	bh=O1UFxQ2qDP/bmIfQWdj0NTrQ5Ym1JCNyvEkIPHlQVcA=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ei5lIJdXtzE7DTCLchGYRKPa1Tp6o23PLnL/ybYtBRYF6r0D1wDo6NrtAJS79fPZJpKFnpORrpZ8RllurxicwoAuxRRbl4tdXhS3c5ifdCJkBY7j4XmyW/Mi/RzgepyU6DTOAr0Uuw3BIqcwRtqccYgvp9aQEdDSesQZuWOH79Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mTgzsi/y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wBhZRjvG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=L/WIrjdt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=rCJtu5RY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mTgzsi/y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wBhZRjvG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="L/WIrjdt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="rCJtu5RY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E4E8021177;
	Mon, 20 Jan 2025 13:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737380489; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TLUTMfDl8nDyy14DGr3qW1JeMdTREWz7VuBOHkZpaqw=;
	b=mTgzsi/yWYFBGkmclgfRS8ItmyzU+TxhOZRcwkeGKds0knKGO7DcgEtqtP+oN9E9iu/SlI
	/1dvom72QcU2aIp4mEHULp/KwyvpTa1h9yy2ucKmYeynjBIfAEIv4Jr/F8wKbsY9FTt5N/
	mdqpIgMVN0ihiNoBkvWYqTKNfD/ryi4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737380489;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TLUTMfDl8nDyy14DGr3qW1JeMdTREWz7VuBOHkZpaqw=;
	b=wBhZRjvGjhwQqSFEy0hsUtOf3dg/72CpwZh2ODeOBr00TYeGWVfdhjWk0y25JoPytcS78T
	VbIlx4qzFiXHrNAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="L/WIrjdt";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rCJtu5RY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737380488; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TLUTMfDl8nDyy14DGr3qW1JeMdTREWz7VuBOHkZpaqw=;
	b=L/WIrjdtmNjeFDT/T5zn1xy93dRCyrO954NakAMxTLw39lTc3YYX2R4bTR3/AmhmeTL5td
	I79L9lGKpHanf1KoH8pcQWN2Yx1JCL4QiR/1BcujrO14m4NBy3R/tG2Vo+zuYnk6BC8vsE
	+EdEh6tf/ZabygoKCKfJCCNggTkJ9BY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737380488;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TLUTMfDl8nDyy14DGr3qW1JeMdTREWz7VuBOHkZpaqw=;
	b=rCJtu5RYUgRQdrh10PFWJDzT7RCH+i2R+tYo78sm8jrAephnkuhqpO/VQY9wNIzkONQPOc
	QWwEX+UYJXzGYoCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE3471393E;
	Mon, 20 Jan 2025 13:41:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g9VYKYhSjmewSAAAD6G6ig
	(envelope-from <tiwai@suse.de>); Mon, 20 Jan 2025 13:41:28 +0000
Date: Mon, 20 Jan 2025 14:41:28 +0100
Message-ID: <87ed0xbo1j.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Baojun Xu <baojun.xu@ti.com>,
	linux-sound@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] ALSA: hda: tas2781-spi: Fix -Wsometimes-uninitialized in tasdevice_spi_switch_book()
In-Reply-To: <20250120-tas2781_hda_spi-fix-wsometimes-uninitialized-v1-1-d7fd104aa63e@kernel.org>
References: <20250120-tas2781_hda_spi-fix-wsometimes-uninitialized-v1-1-d7fd104aa63e@kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: E4E8021177
X-Spam-Level: 
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.51
X-Spam-Flag: NO

On Mon, 20 Jan 2025 14:32:48 +0100,
Nathan Chancellor wrote:
> 
> Clang warns (or errors with CONFIG_WERROR=y):
> 
>   sound/pci/hda/tas2781_hda_spi.c:110:6: error: variable 'ret' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>     110 |         if (tas_priv->cur_book != TASDEVICE_BOOK_ID(reg)) {
>         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   sound/pci/hda/tas2781_hda_spi.c:119:9: note: uninitialized use occurs here
>     119 |         return ret;
>         |                ^~~
>   sound/pci/hda/tas2781_hda_spi.c:110:2: note: remove the 'if' if its condition is always true
>     110 |         if (tas_priv->cur_book != TASDEVICE_BOOK_ID(reg)) {
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   sound/pci/hda/tas2781_hda_spi.c:108:9: note: initialize the variable 'ret' to silence this warning
>     108 |         int ret;
>         |                ^
>         |                 = 0
> 
> Sink the declaration of ret into the if block and just return 0 at the
> end of the function, as there is nothing to do if cur_book has already
> been changed.
> 
> Fixes: bb5f86ea50ff ("ALSA: hda/tas2781: Add tas2781 hda SPI driver")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202501192006.Hm9GmKiV-lkp@intel.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks, applied now.


Takashi
