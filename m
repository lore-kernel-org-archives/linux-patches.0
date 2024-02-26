Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913D3128390
	for <patches@lists.linux.dev>; Mon, 26 Feb 2024 13:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708954194; cv=none; b=DkTMQb22krtjHMrq5gzFhCx/2iA0zn7iZxveziPUDotMp5A9xZq/q5cEWu0QmWk1allPcep9P/bzWiX+m3yz+WrnsxynRm7CKS4WrqCBPVqRxP1cbuninU9K/YltRVAF+4V9+uAs6eqhDrcs/jo6F/Dhx0azqOQOHIux5xD90lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708954194; c=relaxed/simple;
	bh=XyFMwUy/gK0iBv/f/38HI3xokIi3sXTk+TSUi4LU860=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fWWdjp70S4U7F94fp1+qcM/2sZg5AgxLYPD1zWY+YfFXLSMszseMp36tl9wy3Y/HY9gweMBs8SkmO5R+u1I/Rk1NraDmEMqcqa35YyPfxuPDEJlfi53Ly2NnX/gOjE21PX46VQcD2kTjrCc1IxmIr5YFlKwb/CtRdSgubkoxqnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Nm4dsups; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y2qARyQD; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Nm4dsups; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y2qARyQD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Nm4dsups";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y2qARyQD";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Nm4dsups";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y2qARyQD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B611B1FD17;
	Mon, 26 Feb 2024 13:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1708954190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xhjAiOX7SA9f4sYjmlvNrpLw4wO/XOHIXJw2YAetApc=;
	b=Nm4dsups8GZBkB7jvWKin0tiLOxsfHYmEm4ETfuiNeQoLLkJPRF2F2jFis0i2pXhzUOo6f
	c7l2reCF6lToSEGi/d1ymbykOCZyvdMdshblt9QBHn70IHq3yvTuowC0Krz3ur6UpraLGF
	Kq0ZyD3jJQudSYlKAuaVBQajJT5UQbs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1708954190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xhjAiOX7SA9f4sYjmlvNrpLw4wO/XOHIXJw2YAetApc=;
	b=y2qARyQDT52UHmRBfu1xly7PqD7z9T1c6nASA9IvdYsUgplTtt4+0dVdyjNfnnW37JIW93
	KNk4LYW555mChMDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1708954190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xhjAiOX7SA9f4sYjmlvNrpLw4wO/XOHIXJw2YAetApc=;
	b=Nm4dsups8GZBkB7jvWKin0tiLOxsfHYmEm4ETfuiNeQoLLkJPRF2F2jFis0i2pXhzUOo6f
	c7l2reCF6lToSEGi/d1ymbykOCZyvdMdshblt9QBHn70IHq3yvTuowC0Krz3ur6UpraLGF
	Kq0ZyD3jJQudSYlKAuaVBQajJT5UQbs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1708954190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xhjAiOX7SA9f4sYjmlvNrpLw4wO/XOHIXJw2YAetApc=;
	b=y2qARyQDT52UHmRBfu1xly7PqD7z9T1c6nASA9IvdYsUgplTtt4+0dVdyjNfnnW37JIW93
	KNk4LYW555mChMDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C6C4C13A3A;
	Mon, 26 Feb 2024 13:29:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8ZywKU2S3GWEXgAAD6G6ig
	(envelope-from <jdelvare@suse.de>); Mon, 26 Feb 2024 13:29:49 +0000
Date: Mon, 26 Feb 2024 14:29:35 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Heiner Kallweit
 <hkallweit1@gmail.com>, Wolfram Sang <wsa@kernel.org>, Sasha Levin
 <sashal@kernel.org>
Subject: Re: [PATCH 5.15 372/476] i2c: i801: Remove
 i801_set_block_buffer_mode
Message-ID: <20240226142935.62cac532@endymion.delvare>
In-Reply-To: <20240221130021.778800241@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
	<20240221130021.778800241@linuxfoundation.org>
Organization: SUSE Linux
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Nm4dsups;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=y2qARyQD
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.82 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCPT_COUNT_FIVE(0.00)[6];
	 HAS_ORG_HEADER(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FREEMAIL_CC(0.00)[vger.kernel.org,lists.linux.dev,gmail.com,kernel.org];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-2.31)[96.78%]
X-Spam-Score: -3.82
X-Rspamd-Queue-Id: B611B1FD17
X-Spam-Flag: NO

On Wed, 21 Feb 2024 14:07:03 +0100, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [ Upstream commit 1e1d6582f483a4dba4ea03445e6f2f05d9de5bcf ]
> 
> If FEATURE_BLOCK_BUFFER is set then bit SMBAUXCTL_E32B is supported
> and there's no benefit in reading it back. Origin of this check
> seems to be 14 yrs ago when people were not completely sure which
> chip versions support the block buffer mode.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Reviewed-by: Jean Delvare <jdelvare@suse.de>
> Tested-by: Jean Delvare <jdelvare@suse.de>
> Signed-off-by: Wolfram Sang <wsa@kernel.org>
> Stable-dep-of: c1c9d0f6f7f1 ("i2c: i801: Fix block process call transactions")

There is no functional dependency between these 2 commits. The context
change which causes the second commit to fail to apply without the
first commit is trivial to fix. I can provide a patch for version 5.15
and older. I think it is preferable to backporting an extra patch which
wouldn't otherwise qualify for stable trees.

-- 
Jean Delvare
SUSE L3 Support
